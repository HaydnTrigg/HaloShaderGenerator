using HaloShaderGenerator.DirectX;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace HaloShaderGenerator
{
    static class ShaderGeneratorBase
    {
        private class IncludeManager : Include
        {

            public IncludeManager(string root_directory = "") : base(root_directory)
            {

            }

            public string ReadResource(string filepath, string _parent_directory = null)
            {
                string parent_directory = _parent_directory ?? base.DirectoryMap[IntPtr.Zero];
                var assembly = Assembly.GetExecutingAssembly();

                string relative_path = Path.Combine(parent_directory, filepath);
                string path = Path.Combine("HaloShaderGenerator\\shader_code", relative_path);
                string directory = Path.GetDirectoryName(path);

                var resourceName = path.Replace('\\', '.');

                using (Stream stream = assembly.GetManifestResourceStream(resourceName))
                {
                    if(stream == null)
                    {
                        throw new Exception($"Couldn't find file {relative_path}");
                    }
                    using (StreamReader reader = new StreamReader(stream))
                    {
                        return reader.ReadToEnd();
                    }
                }
            }

            protected override int Open(D3D.INCLUDE_TYPE includeType, string filepath, string directory, ref string hlsl_source)
            {
                switch (includeType)
                {
                    case D3D.INCLUDE_TYPE.D3D_INCLUDE_LOCAL:
                        hlsl_source = ReadResource(filepath, directory);
                        return 0;
                    case D3D.INCLUDE_TYPE.D3D_INCLUDE_SYSTEM:
                        hlsl_source = ReadResource(filepath, base.DirectoryMap[IntPtr.Zero]);
                        return 0;
                    default:
                        throw new Exception("Unimplemented include type");
                }
            }
        }

        public static byte[] GenerateSource(string template, IEnumerable<D3D.SHADER_MACRO> macros)
        {
            IncludeManager include = new IncludeManager();

            string shader_source = include.ReadResource(template);

            byte[] shader_code = D3DCompiler.Compile(
                shader_source,
                "main",
                "ps_3_0",
                macros.ToArray(),
                0,
                0,
                template,
                include
            );

            return shader_code;
        }
    }
}
