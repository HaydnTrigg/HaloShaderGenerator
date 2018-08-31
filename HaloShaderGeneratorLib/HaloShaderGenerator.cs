using HaloShaderGenerator.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HaloShaderGenerator
{

    public static class HaloShaderGenerator
    {
        
        public static bool IsShaderSuppored(ShaderType type, ShaderStage stage)
        {
            if (!HaloShaderGeneratorPrivate.IsBaseDLLLoaded) return false;

            Type shadergeneratortype = HaloShaderGeneratorPrivate.HaloShaderGeneratorAssembly.ExportedTypes.Where(t => t.Name == "ShaderGenerator").FirstOrDefault();

            if (shadergeneratortype == null) return false;

            switch (type)
            {
                case ShaderType.Shader:
                    return (dynamic)shadergeneratortype.GetMethod("IsShaderStageSupported").Invoke(null, new object[] { stage });
                case ShaderType.Cortana:
                    return (dynamic)shadergeneratortype.GetMethod("IsShaderCortanaStageSupported").Invoke(null, new object[] { stage });
                case ShaderType.Beam:
                case ShaderType.Contrail:
                case ShaderType.Decal:
                case ShaderType.Halogram:
                case ShaderType.LightVolume:
                case ShaderType.Particle:
                case ShaderType.Terrain:
                    return false;
            }

            return false;
        }

        public static ShaderGeneratorResult GenerateShader(
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
            if (!HaloShaderGeneratorPrivate.IsBaseDLLLoaded) return null;

            Type shadergeneratortype = HaloShaderGeneratorPrivate.HaloShaderGeneratorAssembly.ExportedTypes.Where(t => t.Name == "ShaderGenerator").FirstOrDefault();

            if (shadergeneratortype == null) return null;

            var result = (byte[])shadergeneratortype.GetMethod("GenerateShader").Invoke(null, new object[] {
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
            });

            if (result == null) return null;

            return new ShaderGeneratorResult(result);
        }

        public static ShaderGeneratorResult GenerateShaderCortana(
            ShaderStage stage
            )
        {
            if (!HaloShaderGeneratorPrivate.IsBaseDLLLoaded) return null;

            Type shadergeneratortype = HaloShaderGeneratorPrivate.HaloShaderGeneratorAssembly.ExportedTypes.Where(t => t.Name == "ShaderGenerator").FirstOrDefault();

            if (shadergeneratortype == null) return null;

            var result = (byte[])shadergeneratortype.GetMethod("GenerateShaderCortana").Invoke(null, new object[] {
                    stage
            });

            if (result == null) return null;

            return new ShaderGeneratorResult(result);
        }

    }


}
