using HaloShaderGenerator.Enums;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HaloShaderGenerator
{
    class Application
    {
        static int Main()
        {
            int size = 0;

            //foreach (var shaderstage in Enum.GetValues(typeof(ShaderStage)).Cast<ShaderStage>())
            //{
            //    if (!HaloShaderGenerator.IsShaderSuppored(ShaderType.Shader, shaderstage)) continue;

            //    var bytecode = HaloShaderGenerator.GenerateShader(
            //        shaderstage,
            //        Albedo.Two_Change_Color,
            //        Bump_Mapping.Off,
            //        Alpha_Test.None,
            //        Specular_Mask.No_Specular_Mask,
            //        Material_Model.None,
            //        Environment_Mapping.None,
            //        Self_Illumination.Off,
            //        Blend_Mode.Opaque,
            //        Parallax.Off,
            //        Misc.First_Person_Always,
            //        Distortion.Off,
            //        Soft_fade.Off
            //    );

            //    size += bytecode?.Length ?? 0;
            //}

            bool active_camo_support = HaloShaderGenerator.IsShaderSuppored(ShaderType.Cortana, ShaderStage.Active_Camo);

            if (active_camo_support)
            {
                var result = HaloShaderGenerator.GenerateShaderCortana(ShaderStage.Active_Camo);
                size += result?.Bytecode?.Length ?? 0;
            }

            return size;
        }
    }
}
