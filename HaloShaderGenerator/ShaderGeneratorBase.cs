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

                // HACK: This should be improved!!!
                Uri uri1 = new Uri(Directory.GetCurrentDirectory() + "/");
                Uri uri2 = new Uri(Path.GetFullPath(relative_path));
                Uri relativeUri = uri1.MakeRelativeUri(uri2);
                relative_path = relativeUri.ToString();
                if (relative_path.StartsWith("./")) relative_path = relative_path.Substring(2);

                string path = Path.Combine("HaloShaderGenerator\\shader_code", relative_path);
                string directory = Path.GetDirectoryName(path);

                var resourceName = path.Replace('\\', '.').Replace('/', '.');

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

        public static byte[] GenerateSource(string template, IEnumerable<D3D.SHADER_MACRO> macros, string entry, string version)
        {
            // Macros should never be duplicated
            for (var i = 0; i < macros.Count(); i++)
            {
                for (var j = 0; j < macros.Count(); j++)
                {
                    if (i == j) continue;
                    if (macros.ElementAt(i).Name == macros.ElementAt(j).Name)
                    {
                        throw new Exception($"Macro {macros.ElementAt(i).Name} is defined multiple times");
                    }
                }
            }    

            IncludeManager include = new IncludeManager();

            string shader_source = include.ReadResource(template);

            byte[] shader_code = D3DCompiler.Compile(
                shader_source,
                entry,
                version,
                macros.ToArray(),
                0,
                0,
                template,
                include
            );

            return shader_code;
        }

        public static string CreateMethodDefinition(object method, string prefix = "", string suffix = "")
        {
            var method_type_name = method.GetType().Name.ToLower();
            var method_name = method.ToString().ToLower();

            return $"{prefix.ToLower()}{method_name}{suffix.ToLower()}";
        }

        public static string CreateMethodDefinitionFromArgs<MethodType>(IEnumerable<object> args, string prefix = "", string suffix = "") where MethodType : struct, IConvertible
        {
            var method = args.Where(arg => arg.GetType() == typeof(MethodType)).Cast<MethodType>().FirstOrDefault();
            var method_type_name = method.GetType().Name.ToLower();
            var method_name = method.ToString().ToLower();

            return $"{prefix.ToLower()}{method_name}{suffix.ToLower()}";
        }

        public static D3D.SHADER_MACRO CreateMacro(string name, object method, string prefix = "", string suffix = "")
        {
            return new D3D.SHADER_MACRO { Name = name, Definition = CreateMethodDefinition(method, prefix, suffix) };
        }

        public static D3D.SHADER_MACRO CreateMacroFromArgs<MethodType>(string name, IEnumerable<object> args, string prefix = "", string suffix = "") where MethodType : struct, IConvertible
        {
            return new D3D.SHADER_MACRO { Name = name, Definition = CreateMethodDefinitionFromArgs<MethodType>(args, prefix, suffix) };
        }

        public static IEnumerable<D3D.SHADER_MACRO> CreateMethodEnumDefinitions<MethodType>() where MethodType : struct, IConvertible
        {
            List<D3D.SHADER_MACRO> macros = new List<D3D.SHADER_MACRO>();

            var method_type_name = typeof(MethodType).Name.ToLower();

            var values = Enum.GetValues(typeof(MethodType));
            foreach (var method in values)
            {
                var method_name = method.ToString().ToLower();

                macros.Add(new D3D.SHADER_MACRO { Name = $"k_{method_type_name}_{method_name}", Definition = ((int)method).ToString() });
            }

            return macros;
        }
    }
}
