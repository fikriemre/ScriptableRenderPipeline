Shader "HDRenderPipeline/TerrainLit"
{
    Properties
    {
        [HideInInspector] _Control("Control (RGBA)", 2D) = "red" {}

        [HideInInspector] _Splat0("Layer 0", 2D) = "white" {}
        [HideInInspector] _Splat1("Layer 1", 2D) = "white" {}
        [HideInInspector] _Splat2("Layer 2", 2D) = "white" {}
        [HideInInspector] _Splat3("Layer 3", 2D) = "white" {}

        // TODO: route values from terrain layers. enable _DENSITY_MODE if any of these enabled.
        [HideInInspector] [ToggleUI] _OpacityAsDensity0("_OpacityAsDensity0", Float) = 0.0
        [HideInInspector] [ToggleUI] _OpacityAsDensity1("_OpacityAsDensity1", Float) = 0.0
        [HideInInspector] [ToggleUI] _OpacityAsDensity2("_OpacityAsDensity2", Float) = 0.0
        [HideInInspector] [ToggleUI] _OpacityAsDensity3("_OpacityAsDensity3", Float) = 0.0

        // Following set of parameters represent the parameters node inside the MaterialGraph.
        // They are use to fill a SurfaceData. With a MaterialGraph this should not exist.

        // All the following properties are filled by the referenced lit shader.

        // Reminder. Color here are in linear but the UI (color picker) do the conversion sRGB to linear
        _BaseColor0("BaseColor0", Color) = (1, 1, 1, 1)
        _BaseColor1("BaseColor1", Color) = (1, 1, 1, 1)
        _BaseColor2("BaseColor2", Color) = (1, 1, 1, 1)
        _BaseColor3("BaseColor3", Color) = (1, 1, 1, 1)

        _Metallic0("Metallic0", Range(0.0, 1.0)) = 0
        _Metallic1("Metallic1", Range(0.0, 1.0)) = 0
        _Metallic2("Metallic2", Range(0.0, 1.0)) = 0
        _Metallic3("Metallic3", Range(0.0, 1.0)) = 0

        _Smoothness0("Smoothness0", Range(0.0, 1.0)) = 1.0
        _Smoothness1("Smoothness1", Range(0.0, 1.0)) = 1.0
        _Smoothness2("Smoothness2", Range(0.0, 1.0)) = 1.0
        _Smoothness3("Smoothness3", Range(0.0, 1.0)) = 1.0

        _SmoothnessRemapMin0("SmoothnessRemapMin0", Range(0.0, 1.0)) = 0.0
        _SmoothnessRemapMin1("SmoothnessRemapMin1", Range(0.0, 1.0)) = 0.0
        _SmoothnessRemapMin2("SmoothnessRemapMin2", Range(0.0, 1.0)) = 0.0
        _SmoothnessRemapMin3("SmoothnessRemapMin3", Range(0.0, 1.0)) = 0.0

        _SmoothnessRemapMax0("SmoothnessRemapMax0", Range(0.0, 1.0)) = 1.0
        _SmoothnessRemapMax1("SmoothnessRemapMax1", Range(0.0, 1.0)) = 1.0
        _SmoothnessRemapMax2("SmoothnessRemapMax2", Range(0.0, 1.0)) = 1.0
        _SmoothnessRemapMax3("SmoothnessRemapMax3", Range(0.0, 1.0)) = 1.0

        _AORemapMin0("AORemapMin0", Range(0.0, 1.0)) = 0.0
        _AORemapMin1("AORemapMin1", Range(0.0, 1.0)) = 0.0
        _AORemapMin2("AORemapMin2", Range(0.0, 1.0)) = 0.0
        _AORemapMin3("AORemapMin3", Range(0.0, 1.0)) = 0.0

        _AORemapMax0("AORemapMax0", Range(0.0, 1.0)) = 1.0
        _AORemapMax1("AORemapMax1", Range(0.0, 1.0)) = 1.0
        _AORemapMax2("AORemapMax2", Range(0.0, 1.0)) = 1.0
        _AORemapMax3("AORemapMax3", Range(0.0, 1.0)) = 1.0

        _MaskMap0("MaskMap0", 2D) = "white" {}
        _MaskMap1("MaskMap1", 2D) = "white" {}
        _MaskMap2("MaskMap2", 2D) = "white" {}
        _MaskMap3("MaskMap3", 2D) = "white" {}

        _NormalMap0("NormalMap0", 2D) = "bump" {}
        _NormalMap1("NormalMap1", 2D) = "bump" {}
        _NormalMap2("NormalMap2", 2D) = "bump" {}
        _NormalMap3("NormalMap3", 2D) = "bump" {}

        _NormalMapOS0("NormalMapOS0", 2D) = "white" {}
        _NormalMapOS1("NormalMapOS1", 2D) = "white" {}
        _NormalMapOS2("NormalMapOS2", 2D) = "white" {}
        _NormalMapOS3("NormalMapOS3", 2D) = "white" {}

        _NormalScale0("_NormalScale0", Range(0.0, 2.0)) = 1
        _NormalScale1("_NormalScale1", Range(0.0, 2.0)) = 1
        _NormalScale2("_NormalScale2", Range(0.0, 2.0)) = 1
        _NormalScale3("_NormalScale3", Range(0.0, 2.0)) = 1

        _BentNormalMap0("BentNormalMap0", 2D) = "bump" {}
        _BentNormalMap1("BentNormalMap1", 2D) = "bump" {}
        _BentNormalMap2("BentNormalMap2", 2D) = "bump" {}
        _BentNormalMap3("BentNormalMap3", 2D) = "bump" {}

        _BentNormalMapOS0("BentNormalMapOS0", 2D) = "white" {}
        _BentNormalMapOS1("BentNormalMapOS1", 2D) = "white" {}
        _BentNormalMapOS2("BentNormalMapOS2", 2D) = "white" {}
        _BentNormalMapOS3("BentNormalMapOS3", 2D) = "white" {}

        _HeightMap0("HeightMap0", 2D) = "black" {}
        _HeightMap1("HeightMap1", 2D) = "black" {}
        _HeightMap2("HeightMap2", 2D) = "black" {}
        _HeightMap3("HeightMap3", 2D) = "black" {}

        // Caution: Default value of _HeightAmplitude must be (_HeightMax - _HeightMin) * 0.01
        // Those two properties are computed from the ones exposed in the UI and depends on the displaement mode so they are separate because we don't want to lose information upon displacement mode change.
        [HideInInspector] _HeightAmplitude0("Height Scale0", Float) = 0.02
        [HideInInspector] _HeightAmplitude1("Height Scale1", Float) = 0.02
        [HideInInspector] _HeightAmplitude2("Height Scale2", Float) = 0.02
        [HideInInspector] _HeightAmplitude3("Height Scale3", Float) = 0.02
        [HideInInspector] _HeightCenter0("Height Bias0", Range(0.0, 1.0)) = 0.5
        [HideInInspector] _HeightCenter1("Height Bias1", Range(0.0, 1.0)) = 0.5
        [HideInInspector] _HeightCenter2("Height Bias2", Range(0.0, 1.0)) = 0.5
        [HideInInspector] _HeightCenter3("Height Bias3", Range(0.0, 1.0)) = 0.5

        [Enum(MinMax, 0, Amplitude, 1)] _HeightMapParametrization0("Heightmap Parametrization0", Int) = 0
        [Enum(MinMax, 0, Amplitude, 1)] _HeightMapParametrization1("Heightmap Parametrization1", Int) = 0
        [Enum(MinMax, 0, Amplitude, 1)] _HeightMapParametrization2("Heightmap Parametrization2", Int) = 0
        [Enum(MinMax, 0, Amplitude, 1)] _HeightMapParametrization3("Heightmap Parametrization3", Int) = 0
        // These parameters are for vertex displacement/Tessellation
        _HeightOffset0("Height Offset0", Float) = 0
        _HeightOffset1("Height Offset1", Float) = 0
        _HeightOffset2("Height Offset2", Float) = 0
        _HeightOffset3("Height Offset3", Float) = 0
        // MinMax mode
        _HeightMin0("Height Min0", Float) = -1
        _HeightMin1("Height Min1", Float) = -1
        _HeightMin2("Height Min2", Float) = -1
        _HeightMin3("Height Min3", Float) = -1
        _HeightMax0("Height Max0", Float) = 1
        _HeightMax1("Height Max1", Float) = 1
        _HeightMax2("Height Max2", Float) = 1
        _HeightMax3("Height Max3", Float) = 1

        // Amplitude mode
        _HeightTessAmplitude0("Amplitude0", Float) = 2.0 // in Centimeters
        _HeightTessAmplitude1("Amplitude1", Float) = 2.0 // in Centimeters
        _HeightTessAmplitude2("Amplitude2", Float) = 2.0 // in Centimeters
        _HeightTessAmplitude3("Amplitude3", Float) = 2.0 // in Centimeters
        _HeightTessCenter0("Height Bias0", Range(0.0, 1.0)) = 0.5
        _HeightTessCenter1("Height Bias1", Range(0.0, 1.0)) = 0.5
        _HeightTessCenter2("Height Bias2", Range(0.0, 1.0)) = 0.5
        _HeightTessCenter3("Height Bias3", Range(0.0, 1.0)) = 0.5

        // These parameters are for pixel displacement
        _HeightPoMAmplitude0("Height Amplitude0", Float) = 2.0 // In centimeters
        _HeightPoMAmplitude1("Height Amplitude1", Float) = 2.0 // In centimeters
        _HeightPoMAmplitude2("Height Amplitude2", Float) = 2.0 // In centimeters
        _HeightPoMAmplitude3("Height Amplitude3", Float) = 2.0 // In centimeters

        [Enum(TangentSpace, 0, ObjectSpace, 1)] _NormalMapSpace0("NormalMap space", Float) = 0
        [Enum(TangentSpace, 0, ObjectSpace, 1)] _NormalMapSpace1("NormalMap space", Float) = 0
        [Enum(TangentSpace, 0, ObjectSpace, 1)] _NormalMapSpace2("NormalMap space", Float) = 0
        [Enum(TangentSpace, 0, ObjectSpace, 1)] _NormalMapSpace3("NormalMap space", Float) = 0

        _DiffusionProfile0("Diffusion Profile0", Int) = 0
        _DiffusionProfile1("Diffusion Profile1", Int) = 0
        _DiffusionProfile2("Diffusion Profile2", Int) = 0
        _DiffusionProfile3("Diffusion Profile3", Int) = 0

        _SubsurfaceMask0("Subsurface Mask0", Range(0.0, 1.0)) = 1.0
        _SubsurfaceMask1("Subsurface Mask1", Range(0.0, 1.0)) = 1.0
        _SubsurfaceMask2("Subsurface Mask2", Range(0.0, 1.0)) = 1.0
        _SubsurfaceMask3("Subsurface Mask3", Range(0.0, 1.0)) = 1.0

        _SubsurfaceMaskMap0("Subsurface Mask Map0", 2D) = "white" {}
        _SubsurfaceMaskMap1("Subsurface Mask Map1", 2D) = "white" {}
        _SubsurfaceMaskMap2("Subsurface Mask Map2", 2D) = "white" {}
        _SubsurfaceMaskMap3("Subsurface Mask Map3", 2D) = "white" {}

        _Thickness0("Thickness", Range(0.0, 1.0)) = 1.0
        _Thickness1("Thickness", Range(0.0, 1.0)) = 1.0
        _Thickness2("Thickness", Range(0.0, 1.0)) = 1.0
        _Thickness3("Thickness", Range(0.0, 1.0)) = 1.0

        _ThicknessMap0("Thickness Map", 2D) = "white" {}
        _ThicknessMap1("Thickness Map", 2D) = "white" {}
        _ThicknessMap2("Thickness Map", 2D) = "white" {}
        _ThicknessMap3("Thickness Map", 2D) = "white" {}

        _ThicknessRemap0("Thickness Remap", Vector) = (0, 1, 0, 0)
        _ThicknessRemap1("Thickness Remap", Vector) = (0, 1, 0, 0)
        _ThicknessRemap2("Thickness Remap", Vector) = (0, 1, 0, 0)
        _ThicknessRemap3("Thickness Remap", Vector) = (0, 1, 0, 0)

        // All the following properties exist only in layered lit material

        // Layer blending options
        _LayerInfluenceMaskMap("LayerInfluenceMaskMap", 2D) = "white" {}
        [ToggleUI] _UseHeightBasedBlend("UseHeightBasedBlend", Float) = 0.0

        _HeightTransition("Height Transition", Range(0, 1.0)) = 0.0

        [ToggleUI] _UseMainLayerInfluence("UseMainLayerInfluence", Float) = 0.0

        _InheritBaseNormal1("_InheritBaseNormal1", Range(0, 1.0)) = 0.0
        _InheritBaseNormal2("_InheritBaseNormal2", Range(0, 1.0)) = 0.0
        _InheritBaseNormal3("_InheritBaseNormal3", Range(0, 1.0)) = 0.0

        _InheritBaseHeight1("_InheritBaseHeight1", Range(0, 1.0)) = 0.0
        _InheritBaseHeight2("_InheritBaseHeight2", Range(0, 1.0)) = 0.0
        _InheritBaseHeight3("_InheritBaseHeight3", Range(0, 1.0)) = 0.0

        _InheritBaseColor1("_InheritBaseColor1", Range(0, 1.0)) = 0.0
        _InheritBaseColor2("_InheritBaseColor2", Range(0, 1.0)) = 0.0
        _InheritBaseColor3("_InheritBaseColor3", Range(0, 1.0)) = 0.0

        [Enum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Planar, 4, Triplanar, 5)] _UVBlendMask("UV Set for blendMask", Float) = 0
        [HideInInspector] _UVMappingMaskBlendMask("_UVMappingMaskBlendMask", Color) = (1, 0, 0, 0)
        _TexWorldScaleBlendMask("Tiling", Float) = 1.0

        // Following are builtin properties

        [ToggleUI]  _EnableSpecularOcclusion("Enable specular occlusion", Float) = 0.0

        _EmissiveColor("EmissiveColor", Color) = (1, 1, 1)
        _EmissiveColorMap("EmissiveColorMap", 2D) = "white" {}
        _EmissiveIntensity("EmissiveIntensity", Float) = 0
        [ToggleUI] _AlbedoAffectEmissive("Albedo Affect Emissive", Float) = 0.0

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

        [Enum(Use Emissive Color, 0, Use Emissive Mask, 1)] _EmissiveColorMode("Emissive color mode", Float) = 1
        [Enum(UV0, 0, Planar, 4, TriPlanar, 5)] _UVEmissive("UV Set for emissive", Float) = 0
        _TexWorldScaleEmissive("Scale to apply on world coordinate", Float) = 1.0
        [HideInInspector] _UVMappingMaskEmissive("_UVMappingMaskEmissive", Color) = (1, 0, 0, 0)

        // Caution: C# code in BaseLitUI.cs call LightmapEmissionFlagsProperty() which assume that there is an existing "_EmissionColor"
        // value that exist to identify if the GI emission need to be enabled.
        // In our case we don't use such a mechanism but need to keep the code quiet. We declare the value and always enable it.
        // TODO: Fix the code in legacy unity so we can customize the beahvior for GI
        _EmissionColor("Color", Color) = (1, 1, 1)

        _TexWorldScale0("Tiling", Float) = 1.0
        _TexWorldScale1("Tiling", Float) = 1.0
        _TexWorldScale2("Tiling", Float) = 1.0
        _TexWorldScale3("Tiling", Float) = 1.0

        [HideInInspector] _InvTilingScale0("Inverse tiling scale = 2 / (abs(_BaseColorMap_ST.x) + abs(_BaseColorMap_ST.y))", Float) = 1
        [HideInInspector] _InvTilingScale1("Inverse tiling scale = 2 / (abs(_BaseColorMap_ST.x) + abs(_BaseColorMap_ST.y))", Float) = 1
        [HideInInspector] _InvTilingScale2("Inverse tiling scale = 2 / (abs(_BaseColorMap_ST.x) + abs(_BaseColorMap_ST.y))", Float) = 1
        [HideInInspector] _InvTilingScale3("Inverse tiling scale = 2 / (abs(_BaseColorMap_ST.x) + abs(_BaseColorMap_ST.y))", Float) = 1

        [Enum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Planar, 4, Triplanar, 5)] _UVBase0("UV Set for base0", Float) = 0 // no UV1/2/3 for main layer (matching Lit.shader and for PPDisplacement restriction)
        [Enum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Planar, 4, Triplanar, 5)] _UVBase1("UV Set for base1", Float) = 0
        [Enum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Planar, 4, Triplanar, 5)] _UVBase2("UV Set for base2", Float) = 0
        [Enum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Planar, 4, Triplanar, 5)] _UVBase3("UV Set for base3", Float) = 0

        // HACK: GI Baking system relies on some properties existing in the shader ("_MainTex", "_Cutoff" and "_Color") for opacity handling, so we need to store our version of those parameters in the hard-coded name the GI baking system recognizes.
        _MainTex("Albedo", 2D) = "white" {}
        _Color("Color", Color) = (1,1,1,1)

        [ToggleUI] _SupportDBuffer("Support DBuffer", Float) = 1.0
    }

    HLSLINCLUDE

    #pragma target 4.5
    #pragma only_renderers d3d11 ps4 xboxone vulkan metal

    #pragma shader_feature _DOUBLESIDED_ON

    #pragma shader_feature _ _EMISSIVE_MAPPING_PLANAR _EMISSIVE_MAPPING_TRIPLANAR
    #pragma shader_feature _ _LAYER_MAPPING_PLANAR_BLENDMASK _LAYER_MAPPING_TRIPLANAR_BLENDMASK
    #pragma shader_feature _ _LAYER_MAPPING_PLANAR0 _LAYER_MAPPING_TRIPLANAR0
    #pragma shader_feature _ _LAYER_MAPPING_PLANAR1 _LAYER_MAPPING_TRIPLANAR1
    #pragma shader_feature _ _LAYER_MAPPING_PLANAR2 _LAYER_MAPPING_TRIPLANAR2
    #pragma shader_feature _ _LAYER_MAPPING_PLANAR3 _LAYER_MAPPING_TRIPLANAR3
    #pragma shader_feature _NORMALMAP_TANGENT_SPACE0
    #pragma shader_feature _NORMALMAP_TANGENT_SPACE1
    #pragma shader_feature _NORMALMAP_TANGENT_SPACE2
    #pragma shader_feature _NORMALMAP_TANGENT_SPACE3

    #pragma shader_feature _NORMALMAP0
    #pragma shader_feature _NORMALMAP1
    #pragma shader_feature _NORMALMAP2
    #pragma shader_feature _NORMALMAP3
    #pragma shader_feature _MASKMAP0
    #pragma shader_feature _MASKMAP1
    #pragma shader_feature _MASKMAP2
    #pragma shader_feature _MASKMAP3
    #pragma shader_feature _BENTNORMALMAP0
    #pragma shader_feature _BENTNORMALMAP1
    #pragma shader_feature _BENTNORMALMAP2
    #pragma shader_feature _BENTNORMALMAP3
    #pragma shader_feature _EMISSIVE_COLOR_MAP
    #pragma shader_feature _ENABLESPECULAROCCLUSION
    #pragma shader_feature _HEIGHTMAP0
    #pragma shader_feature _HEIGHTMAP1
    #pragma shader_feature _HEIGHTMAP2
    #pragma shader_feature _HEIGHTMAP3
    #pragma shader_feature _SUBSURFACE_MASK_MAP0
    #pragma shader_feature _SUBSURFACE_MASK_MAP1
    #pragma shader_feature _SUBSURFACE_MASK_MAP2
    #pragma shader_feature _SUBSURFACE_MASK_MAP3
    #pragma shader_feature _THICKNESSMAP0
    #pragma shader_feature _THICKNESSMAP1
    #pragma shader_feature _THICKNESSMAP2
    #pragma shader_feature _THICKNESSMAP3

    #pragma shader_feature _MAIN_LAYER_INFLUENCE_MODE
    #pragma shader_feature _INFLUENCEMASK_MAP
    #pragma shader_feature _DENSITY_MODE
    #pragma shader_feature _HEIGHT_BASED_BLEND
    #pragma shader_feature _ _LAYEREDLIT_3_LAYERS _LAYEREDLIT_4_LAYERS

    #pragma shader_feature _DISABLE_DBUFFER

    //enable GPU instancing support
    #pragma multi_compile_instancing

    //-------------------------------------------------------------------------------------
    // Define
    //-------------------------------------------------------------------------------------

    #define UNITY_MATERIAL_LIT // Need to be define before including Material.hlsl
    // Use surface gradient normal mapping as it handle correctly triplanar normal mapping and multiple UVSet
    #define SURFACE_GRADIENT
    // This shader support vertex modification
    #define HAVE_VERTEX_MODIFICATION // TODO: Implement ApplyVertexModification for terrain heightmap sampling

    //-------------------------------------------------------------------------------------
    // Include
    //-------------------------------------------------------------------------------------

    #include "CoreRP/ShaderLibrary/Common.hlsl"
    #include "../../ShaderPass/FragInputs.hlsl"
    #include "../../ShaderPass/ShaderPass.cs.hlsl"

    //-------------------------------------------------------------------------------------
    // variable declaration
    //-------------------------------------------------------------------------------------

    #define _MAX_LAYER 4

    #if defined(_LAYEREDLIT_4_LAYERS)
    #   define _LAYER_COUNT 4
    #elif defined(_LAYEREDLIT_3_LAYERS)
    #   define _LAYER_COUNT 3
    #else
    #   define _LAYER_COUNT 2
    #endif

    // Explicitely said that we are a layered shader as we share code between lit and layered lit
    #define LAYERED_LIT_SHADER

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
            #include "../Lit/ShaderPass/LitSharePass.hlsl"
            #include "TerrainLitData.hlsl"
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
            #include "../Lit/ShaderPass/LitSharePass.hlsl"
            #include "TerrainLitData.hlsl"
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
            #include "TerrainLitData.hlsl"
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
            #include "TerrainLitData.hlsl"
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
            #include "TerrainLitData.hlsl"
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
            #include "../Lit/ShaderPass/LitSharePass.hlsl"
            #include "TerrainLitData.hlsl"
            #include "../../ShaderPass/ShaderPassForward.hlsl"

            ENDHLSL
        }
    }

    CustomEditor "UnityEditor.Experimental.Rendering.HDPipeline.TerrainLitGUI"
}