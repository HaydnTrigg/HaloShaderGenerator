using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using HaloShaderGenerator.DirectX;
using HaloShaderGenerator.Enums;

namespace HaloShaderGenerator
{
    public partial class ShaderGenerator
    {
        public static bool IsShaderStageSupported(ShaderStage stage)
        {
            switch (stage)
            {
                //case ShaderStage.Default:
                case ShaderStage.Albedo:
                //case ShaderStage.Static_Per_Pixel:
                //case ShaderStage.Static_Per_Vertex:
                //case ShaderStage.Static_Sh:
                case ShaderStage.Static_Prt_Ambient:
                case ShaderStage.Static_Prt_Linear:
                case ShaderStage.Static_Prt_Quadratic:
                //case ShaderStage.Dynamic_Light:
                //case ShaderStage.Shadow_Generate:
                case ShaderStage.Active_Camo:
                //case ShaderStage.Lightmap_Debug_Mode:
                //case ShaderStage.Static_Per_Vertex_Color:
                //case ShaderStage.Dynamic_Light_Cinematic:
                //case ShaderStage.Sfx_Distort:
                    return true;
            }
            return false;
        }

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
                //case ShaderStage.Static_Per_Pixel:
                //case ShaderStage.Static_Per_Vertex:
                //case ShaderStage.Static_Sh:
                case ShaderStage.Static_Prt_Ambient:
                case ShaderStage.Static_Prt_Linear:
                case ShaderStage.Static_Prt_Quadratic:
                //case ShaderStage.Dynamic_Light:
                //case ShaderStage.Shadow_Generate:
                case ShaderStage.Active_Camo:
                //case ShaderStage.Lightmap_Debug_Mode:
                //case ShaderStage.Static_Per_Vertex_Color:
                //case ShaderStage.Dynamic_Light_Cinematic:
                //case ShaderStage.Sfx_Distort:
                    break;
                default:
                    return null;
            }

            macros.AddRange(ShaderGeneratorBase.CreateMethodEnumDefinitions<ShaderStage>());
            macros.AddRange(ShaderGeneratorBase.CreateMethodEnumDefinitions<ShaderType>());
            macros.AddRange(ShaderGeneratorBase.CreateMethodEnumDefinitions<Albedo>());
            macros.AddRange(ShaderGeneratorBase.CreateMethodEnumDefinitions<Bump_Mapping>());
            macros.AddRange(ShaderGeneratorBase.CreateMethodEnumDefinitions<Alpha_Test>());
            macros.AddRange(ShaderGeneratorBase.CreateMethodEnumDefinitions<Specular_Mask>());
            macros.AddRange(ShaderGeneratorBase.CreateMethodEnumDefinitions<Material_Model>());
            macros.AddRange(ShaderGeneratorBase.CreateMethodEnumDefinitions<Environment_Mapping>());
            macros.AddRange(ShaderGeneratorBase.CreateMethodEnumDefinitions<Self_Illumination>());
            macros.AddRange(ShaderGeneratorBase.CreateMethodEnumDefinitions<Blend_Mode>());
            macros.AddRange(ShaderGeneratorBase.CreateMethodEnumDefinitions<Parallax>());
            macros.AddRange(ShaderGeneratorBase.CreateMethodEnumDefinitions<Misc>());

            macros.Add(ShaderGeneratorBase.CreateMacro("calc_albedo_ps", albedo, "calc_albedo_", "_ps"));
            if (albedo == Albedo.Constant_Color)
            {
                macros.Add(ShaderGeneratorBase.CreateMacro("calc_albedo_vs", albedo, "calc_albedo_", "_vs"));
            }

            macros.Add(ShaderGeneratorBase.CreateMacro("calc_bumpmap_ps", bump_mapping, "calc_bumpmap_", "_ps"));
            macros.Add(ShaderGeneratorBase.CreateMacro("calc_bumpmap_vs", bump_mapping, "calc_bumpmap_", "_vs"));

            macros.Add(ShaderGeneratorBase.CreateMacro("calc_alpha_test_ps", alpha_test, "calc_alpha_test_", "_ps"));
            macros.Add(ShaderGeneratorBase.CreateMacro("calc_specular_mask_ps", specular_mask, "calc_specular_mask_", "_ps"));

            macros.Add(ShaderGeneratorBase.CreateMacro("calc_self_illumination_ps", self_illumination, "calc_self_illumination_", "_ps"));

            macros.Add(ShaderGeneratorBase.CreateMacro("calc_parallax_ps", parallax, "calc_parallax_", "_ps"));
            switch (parallax)
            {
                case Parallax.Simple_Detail:
                    macros.Add(ShaderGeneratorBase.CreateMacro("calc_parallax_vs", Parallax.Simple, "calc_parallax_", "_vs"));
                    break;
                default:
                    macros.Add(ShaderGeneratorBase.CreateMacro("calc_parallax_vs", parallax, "calc_parallax_", "_vs"));
                    break;
            }

            macros.Add(ShaderGeneratorBase.CreateMacro("material_type", material_model, "material_type_"));
            macros.Add(ShaderGeneratorBase.CreateMacro("envmap_type", environment_mapping, "envmap_type_"));
            macros.Add(ShaderGeneratorBase.CreateMacro("blend_type", blend_mode, "blend_type_"));

            macros.Add(ShaderGeneratorBase.CreateMacro("shaderstage", stage, "shaderstage_"));
            macros.Add(ShaderGeneratorBase.CreateMacro("shadertype", stage, "shadertype_"));

            macros.Add(ShaderGeneratorBase.CreateMacro("albedo_template_id", albedo, "albedo_"));
            macros.Add(ShaderGeneratorBase.CreateMacro("material_model_template_id", material_model, "material_model_"));
            macros.Add(ShaderGeneratorBase.CreateMacro("environment_mapping_template_id", environment_mapping, "environment_mapping_"));

            

            var shader_bytecode = ShaderGeneratorBase.GenerateSource(template, macros, "entry_" + stage.ToString().ToLower(), "ps_3_0");
            return shader_bytecode;
        }
    }
}
