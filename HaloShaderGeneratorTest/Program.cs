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

            foreach (var shaderstage in Enum.GetValues(typeof(ShaderStage)).Cast<ShaderStage>())
            {
                if (!ShaderGenerator.IsShaderStageSupported(shaderstage)) continue;

                var bytecode = ShaderGenerator.Generate(
                    shaderstage,
                    Albedo.Two_Change_Color,
                    Bump_Mapping.Off,
                    Alpha_Test.None,
                    Specular_Mask.No_Specular_Mask,
                    Material_Model.None,
                    Environment_Mapping.None,
                    Self_Illumination.Off,
                    Blend_Mode.Opaque,
                    Parallax.Off,
                    Misc.First_Person_Always,
                    Distortion.Off,
                    Soft_fade.Off
                );

                size += bytecode.Length;
            }

            return size;
        }
    }
}
