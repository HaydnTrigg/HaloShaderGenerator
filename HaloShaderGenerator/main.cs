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
            byte[] shader_bytecode = ShaderGenerator.GenerateSource(ShaderStage.Default, Albedo.Two_Change_Color);
            byte[] shader_bytecode = ContrailGenerator.GenerateSource(ShaderStage.Default, Albedo.Two_Change_Color);
            return source.Length;
        }
    }
}
