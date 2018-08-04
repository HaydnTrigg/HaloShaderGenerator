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
        public static Task<byte[]> GenerateAsync(
            ShaderStage stage,
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
            return Task.Run<byte[]>(() => Generate(
                stage,
                albedo,
                bump_mapping,
                alpha_test,
                specular_mask,
                material_model,
                environment_mapping,
                self_illumination,
                blend_mode,
                parallax,
                misc,
                distortion,
                soft_fade
            ));
        }

        public static byte[] Generate(
            ShaderStage stage,
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
            string template = $"shader.hlsl";

            List<D3D.SHADER_MACRO> macros = new List<D3D.SHADER_MACRO>();

            switch (stage)
            {
                //case ShaderStage.Default:
                case ShaderStage.Albedo:
                    break;
                //case ShaderStage.Static_Default:
                //case ShaderStage.Static_Per_Pixel:
                //case ShaderStage.Static_Per_Vertex:
                //case ShaderStage.Static_Sh:
                //case ShaderStage.Static_Prt_Ambient:
                //case ShaderStage.Static_Prt_Linear:
                //case ShaderStage.Static_Prt_Quadratic:
                //case ShaderStage.Dynamic_Light:
                //case ShaderStage.Shadow_Generate:
                //case ShaderStage.Shadow_Apply:
                //case ShaderStage.Active_Camo:
                //case ShaderStage.Lightmap_Debug_Mode:
                //case ShaderStage.Static_Per_Vertex_Color:
                //case ShaderStage.Water_Tesselation:
                //case ShaderStage.Water_Shading:
                //case ShaderStage.Dynamic_Light_Cinematic:
                //case ShaderStage.Z_Only:
                //case ShaderStage.Sfx_Distort:
                default:
                    return null;
            }

            macros.AddRange(ShaderGeneratorBase.CreateMethodEnumDefinitions<Albedo>());
            macros.Add(ShaderGeneratorBase.CreateMacro("calc_albedo_ps", albedo, "calc_", "_ps"));
            if (albedo == Albedo.Constant_Color)
            {
                macros.Add(ShaderGeneratorBase.CreateMacro("calc_albedo_vs", albedo, "calc_", "_vs"));
            }

            macros.Add(ShaderGeneratorBase.CreateMacro("shader_stage", stage));
            macros.AddRange(ShaderGeneratorBase.CreateMethodEnumDefinitions<ShaderStage>());

            var shader_bytecode = ShaderGeneratorBase.GenerateSource(template, macros, "entry_" + stage.ToString().ToLower(), "ps_3_0");
            return shader_bytecode;
        }
    }
}
