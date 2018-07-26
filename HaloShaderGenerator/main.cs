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
            byte[] source = ShaderGenerator.GenerateSource();
            return source.Length;
        }
    }
}
