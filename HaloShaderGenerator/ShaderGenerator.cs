using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HaloShaderGenerator.DirectX;
using HaloShaderGenerator.Enums;

namespace HaloShaderGenerator
{
    public partial class ShaderGenerator
    {
        public static void GenerateSource(
            Albedo albedo,
            Bump_Mapping bump_mapping,
            Alpha_Test alpha_test,
            Specular_Mask specular_mask,
            Material_Model material_model,
            Environment_Mapping environment_mapping,
            Self_Illumination self_illumination,
            Blend_Mode blend_mode,
            Parallax parallax,
            Misc misc,
            Distortion distortion,
            Soft_fade soft_fade
            )
        {
            














        }

        public static byte[] GenerateSource(ShaderStage stage)
        {
            string template = $"{stage.ToString().ToLower()}_template.hlsl";

            D3D.SHADER_MACRO[] macros = { new D3D.SHADER_MACRO { Name = "test\0", Definition = "1.0\0" } };

            switch (stage)
            {
                case ShaderStage.Default:
                    break;
                case ShaderStage.Albedo:
                case ShaderStage.Static_Default:
                case ShaderStage.Static_Per_Pixel:
                case ShaderStage.Static_Per_Vertex:
                case ShaderStage.Static_Sh:
                case ShaderStage.Static_Prt_Ambient:
                case ShaderStage.Static_Prt_Linear:
                case ShaderStage.Static_Prt_Quadratic:
                case ShaderStage.Dynamic_Light:
                case ShaderStage.Shadow_Generate:
                case ShaderStage.Shadow_Apply:
                case ShaderStage.Active_Camo:
                case ShaderStage.Lightmap_Debug_Mode:
                case ShaderStage.Static_Per_Vertex_Color:
                case ShaderStage.Water_Tesselation:
                case ShaderStage.Water_Shading:
                case ShaderStage.Dynamic_Light_Cinematic:
                case ShaderStage.Z_Only:
                case ShaderStage.Sfx_Distort:
                default:
                    return null;
            }

            var shader_bytecode = ShaderGeneratorBase.GenerateSource(template, macros);
            return shader_bytecode;
        }
    }
}
