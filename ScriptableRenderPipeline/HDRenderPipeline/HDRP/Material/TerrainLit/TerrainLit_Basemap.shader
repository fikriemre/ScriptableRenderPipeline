Shader "Hidden/HDRenderPipeline/TerrainLit_Basemap"
{
    Properties
    {
        // Following are builtin properties

        // Stencil state
        [HideInInspector] _StencilRef("_StencilRef", Int) = 2 // StencilLightingUsage.RegularLighting
        [HideInInspector] _StencilWriteMask("_StencilWriteMask", Int) = 7 // StencilMask.Lighting  (fixed at compile time)
        [HideInInspector] _StencilRefMV("_StencilRefMV", Int) = 128 // StencilLightingUsage.RegularLighting  (fixed at compile time)
        [HideInInspector] _StencilWriteMaskMV("_StencilWriteMaskMV", Int) = 128 // StencilMask.ObjectsVelocity  (fixed at compile time)

        // Blending state
        [HideInInspector] _ZWrite ("__zw", Float) = 1.0
        [HideInInspector] _CullMode("__cullmode", Float) = 2.0
        [HideInInspector] _ZTestDepthEqualForOpaque("_ZTestDepthEqualForOpaque", Int) = 4 // Less equal
        [HideInInspector] _ZTestGBuffer("_ZTestGBuffer", Int) = 4

        [ToggleUI] _DoubleSidedEnable("Double sided enable", Float) = 0.0
        [Enum(Flip, 0, Mirror, 1, None, 2)] _DoubleSidedNormalMode("Double sided normal mode", Float) = 1
        [HideInInspector] _DoubleSidedConstants("_DoubleSidedConstants", Vector) = (1, 1, -1, 0)

        // Caution: C# code in BaseLitUI.cs call LightmapEmissionFlagsProperty() which assume that there is an existing "_EmissionColor"
        // value that exist to identify if the GI emission need to be enabled.
        // In our case we don't use such a mechanism but need to keep the code quiet. We declare the value and always enable it.
        // TODO: Fix the code in legacy unity so we can customize the behavior for GI
        _EmissionColor("Color", Color) = (1, 1, 1)

        _MetallicTex("Metallic (R)", 2D) = "white" {}

        // HACK: GI Baking system relies on some properties existing in the shader ("_MainTex", "_Cutoff" and "_Color") for opacity handling, so we need to store our version of those parameters in the hard-coded name the GI baking system recognizes.
        _MainTex("Albedo", 2D) = "white" {}
        _Color("Color", Color) = (1,1,1,1)

        [ToggleUI] _SupportDBuffer("Support DBuffer", Float) = 1.0
    }

    HLSLINCLUDE

    #pragma target 4.5
    #pragma only_renderers d3d11 ps4 xboxone vulkan metal

    #pragma shader_feature _DOUBLESIDED_ON
    #pragma shader_feature _DISABLE_DBUFFER

    //enable GPU instancing support
    #pragma multi_compile_instancing
    #pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap

    //-------------------------------------------------------------------------------------
    // Define
    //-------------------------------------------------------------------------------------

    #define UNITY_MATERIAL_LIT // Need to be define before including Material.hlsl
    // Use surface gradient normal mapping as it handle correctly triplanar normal mapping and multiple UVSet
    #define SURFACE_GRADIENT
    // This shader support vertex modification
    #define HAVE_VERTEX_MODIFICATION

    //-------------------------------------------------------------------------------------
    // Include
    //-------------------------------------------------------------------------------------

    #include "CoreRP/ShaderLibrary/Common.hlsl"
    #include "../../ShaderPass/FragInputs.hlsl"
    #include "../../ShaderPass/ShaderPass.cs.hlsl"

    //-------------------------------------------------------------------------------------
    // variable declaration
    //-------------------------------------------------------------------------------------

    #define TERRAINLIT_BASEMAP_SHADER

    //-------------------------------------------------------------------------------------
    // variable declaration
    //-------------------------------------------------------------------------------------

    #include "../../Material/Lit/LitProperties.hlsl"

    // All our shaders use same name for entry point
    #pragma vertex Vert
    #pragma fragment Frag

    ENDHLSL

    SubShader
    {
        // This tags allow to use the shader replacement features
        Tags{ "RenderPipeline" = "HDRenderPipeline" "RenderType" = "HDLitShader" }

        // Caution: The outline selection in the editor use the vertex shader/hull/domain shader of the first pass declare. So it should not bethe  meta pass.
        Pass
        {
            Name "GBuffer"  // Name is not used
            Tags { "LightMode" = "GBuffer" } // This will be only for opaque object based on the RenderQueue index

            Cull [_CullMode]
            ZTest[_ZTestGBuffer]

            Stencil
            {
                WriteMask [_StencilWriteMask]
                Ref [_StencilRef]
                Comp Always
                Pass Replace
            }

            HLSLPROGRAM

            #pragma multi_compile _ DEBUG_DISPLAY
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ DYNAMICLIGHTMAP_ON
            #pragma multi_compile _ SHADOWS_SHADOWMASK

            #define SHADERPASS SHADERPASS_GBUFFER
            #include "../../ShaderVariables.hlsl"
            #ifdef DEBUG_DISPLAY
            #include "../../Debug/DebugDisplay.hlsl"
            #endif
            #include "../../Material/Material.hlsl"
            #include "TerrainLitSharePass.hlsl"
            #include "TerrainLitData_Basemap.hlsl"
            #include "../../ShaderPass/ShaderPassGBuffer.hlsl"

            ENDHLSL
        }

        // Extracts information for lightmapping, GI (emission, albedo, ...)
        // This pass it not used during regular rendering.
        Pass
        {
            Name "META"
            Tags{ "LightMode" = "Meta" }

            Cull Off

            HLSLPROGRAM

            // Lightmap memo
            // DYNAMICLIGHTMAP_ON is used when we have an "enlighten lightmap" ie a lightmap updated at runtime by enlighten.This lightmap contain indirect lighting from realtime lights and realtime emissive material.Offline baked lighting(from baked material / light,
            // both direct and indirect lighting) will hand up in the "regular" lightmap->LIGHTMAP_ON.

            #define SHADERPASS SHADERPASS_LIGHT_TRANSPORT
            #include "../../ShaderVariables.hlsl"
            #include "../../Material/Material.hlsl"
            #include "TerrainLitSharePass.hlsl"
            #include "TerrainLitData_Basemap.hlsl"
            #include "../../ShaderPass/ShaderPassLightTransport.hlsl"

            ENDHLSL
        }

        Pass
        {
            Name "Motion Vectors"
            Tags{ "LightMode" = "MotionVectors" } // Caution, this need to be call like this to setup the correct parameters by C++ (legacy Unity)

            // If velocity pass (motion vectors) is enabled we tag the stencil so it don't perform CameraMotionVelocity
            Stencil
            {
                WriteMask [_StencilWriteMaskMV]
                Ref [_StencilRefMV]
                Comp Always
                Pass Replace
            }

            Cull[_CullMode]

            ZWrite On

            HLSLPROGRAM

            #define SHADERPASS SHADERPASS_VELOCITY
            #include "../../ShaderVariables.hlsl"
            #include "../../Material/Material.hlsl"
            #include "../Lit/ShaderPass/LitVelocityPass.hlsl"
            #include "TerrainLitData_Basemap.hlsl"
            #include "../../ShaderPass/ShaderPassVelocity.hlsl"

            ENDHLSL
        }

        Pass
        {
            Name "ShadowCaster"
            Tags{ "LightMode" = "ShadowCaster" }

            Cull[_CullMode]

            ZClip [_ZClip]
            ZWrite On
            ZTest LEqual

            ColorMask 0

            HLSLPROGRAM

            #define SHADERPASS SHADERPASS_SHADOWS
            #define USE_LEGACY_UNITY_MATRIX_VARIABLES
            #include "../../ShaderVariables.hlsl"
            #include "../../Material/Material.hlsl"
            #include "../Lit/ShaderPass/LitDepthPass.hlsl"
            #include "TerrainLitData_Basemap.hlsl"
            #include "../../ShaderPass/ShaderPassDepthOnly.hlsl"

            ENDHLSL
        }

        Pass
        {
            Name "DepthOnly"
            Tags{ "LightMode" = "DepthOnly" }

            Cull[_CullMode]

            ZWrite On

            ColorMask 0

            HLSLPROGRAM

            #define SHADERPASS SHADERPASS_DEPTH_ONLY
            #include "../../ShaderVariables.hlsl"
            #include "../../Material/Material.hlsl"
            #include "../Lit/ShaderPass/LitDepthPass.hlsl"
            #include "TerrainLitData_Basemap.hlsl"
            #include "../../ShaderPass/ShaderPassDepthOnly.hlsl"

            ENDHLSL
        }

        Pass
        {
            Name "Forward" // Name is not used
            Tags{ "LightMode" = "Forward" } // This will be only for transparent object based on the RenderQueue index

            Stencil
            {
                WriteMask [_StencilWriteMask]
                Ref [_StencilRef]
                Comp Always
                Pass Replace
            }

            // In case of forward we want to have depth equal for opaque mesh
            ZTest [_ZTestDepthEqualForOpaque]
            ZWrite [_ZWrite]
            Cull [_CullMode]

            HLSLPROGRAM

            #pragma multi_compile _ DEBUG_DISPLAY
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ DYNAMICLIGHTMAP_ON
            #pragma multi_compile _ SHADOWS_SHADOWMASK
            // #include "../../Lighting/Forward.hlsl"
            //#pragma multi_compile LIGHTLOOP_SINGLE_PASS LIGHTLOOP_TILE_PASS
            #define LIGHTLOOP_TILE_PASS
            #pragma multi_compile USE_FPTL_LIGHTLIST USE_CLUSTERED_LIGHTLIST

            #define SHADERPASS SHADERPASS_FORWARD
            // In case of opaque we don't want to perform the alpha test, it is done in depth prepass and we use depth equal for ztest (setup from UI)
            #ifndef _SURFACE_TYPE_TRANSPARENT
                #define SHADERPASS_FORWARD_BYPASS_ALPHA_TEST
            #endif
            #include "../../ShaderVariables.hlsl"
            #ifdef DEBUG_DISPLAY
            #include "../../Debug/DebugDisplay.hlsl"
            #endif
            #include "../../Lighting/Lighting.hlsl"
            #include "TerrainLitSharePass.hlsl"
            #include "TerrainLitData_Basemap.hlsl"
            #include "../../ShaderPass/ShaderPassForward.hlsl"

            ENDHLSL
        }

        UsePass "Hidden/Nature/Terrain/Picking/TERRAINPICKING"
    }
}