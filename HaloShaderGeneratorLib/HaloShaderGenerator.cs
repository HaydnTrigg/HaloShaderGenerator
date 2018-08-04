using HaloShaderGenerator.Enums;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace HaloShaderGenerator
{
    public static class HaloShaderGenerator
    {
        [DllImport("kernel32.dll")]
        private static extern IntPtr GetModuleHandle(string lpModuleName);

        private static bool IsDllLoaded(string path)
        {
            return GetModuleHandle(path) != IntPtr.Zero;
        }

        private static Assembly _HaloShaderGeneratorAssembly = null;
        private static Assembly HaloShaderGeneratorAssembly
        {
            get
            {
                if (_HaloShaderGeneratorAssembly != null) return _HaloShaderGeneratorAssembly;

                var haloshadergenerator = "HaloShaderGenerator.dll";
                if (!IsDllLoaded(haloshadergenerator))
                {
                    var path = Path.GetFullPath(haloshadergenerator);
                    if (File.Exists(path))
                    {
                        _HaloShaderGeneratorAssembly = Assembly.LoadFile(path);
                        return _HaloShaderGeneratorAssembly;
                    }
                    return null;
                }
                return null;
            }
        }

        private static bool IsBaseDLLLoaded
        {
            get
            {
                var haloshadergenerator = "HaloShaderGenerator.dll";
                if (!IsDllLoaded(haloshadergenerator))
                {
                    return HaloShaderGeneratorAssembly != null;
                }
                return true;
            }
        }

        public static bool IsShaderSuppored(ShaderType type, ShaderStage stage)
        {
            if (!IsBaseDLLLoaded) return false;

            switch (type)
            {
                case ShaderType.Shader:
                    Type shadergeneratortype = HaloShaderGeneratorAssembly.ExportedTypes.Where(t => t.Name == "ShaderGenerator").FirstOrDefault();
                    if (shadergeneratortype != null)
                    {
                        return (dynamic)shadergeneratortype.GetMethod("IsShaderStageSupported").Invoke(null, new object[] { stage });
                    }
                    return false;
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

        public static byte[] GenerateShader(
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
            if (!IsBaseDLLLoaded) return null;

            Type shadergeneratortype = HaloShaderGeneratorAssembly.ExportedTypes.Where(t => t.Name == "ShaderGenerator").FirstOrDefault();

            if (shadergeneratortype == null) return null;

            dynamic result = shadergeneratortype.GetMethod("Generate").Invoke(null, new object[] {
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

            return result;
        }
    }
}
