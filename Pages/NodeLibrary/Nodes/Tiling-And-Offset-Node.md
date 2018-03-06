## Description

Tiles and offsets the value of input **UV** by the inputs **Tiling** and **Offset** respectively. This is commonly used for detail maps and scrolling textures over [Time](https://github.com/Unity-Technologies/ShaderGraph/wiki/Time-Node).

## Ports

| Name        | Direction           | Type  | Binding | Description |
|:------------ |:-------------|:-----|:---|:---|
| UV      | Input | Vector 2 | UV | Input UV value |
| Tiling      | Input | Vector 2 | None | Amount of tiling to apply per channel |
| Offset      | Input | Vector 2 | None | Amount of offset to apply per channel |
| Out | Output      |    Vector 2 | None | Output UV value |

## Shader Function

```
Out = UV * Tiling + Offset;
```