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

        public static byte[] GenerateSource()
        {
            D3D.SHADER_MACRO[] macros = { new D3D.SHADER_MACRO { Name = "test\0", Definition = "1.0\0" } };

            return ShaderGeneratorBase.GenerateSource("shader_template.hlsl", macros);
        }
    }
}
