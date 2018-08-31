using System;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;

namespace HaloShaderGenerator
{
    static class HaloShaderGeneratorPrivate
    {
        [DllImport("kernel32.dll")]
        private static extern IntPtr GetModuleHandle(string lpModuleName);

        private static bool IsDllLoaded(string path)
        {
            return GetModuleHandle(path) != IntPtr.Zero;
        }

        private static Assembly _HaloShaderGeneratorAssembly = null;
        public static Assembly HaloShaderGeneratorAssembly
        {
            get
            {
                if (_HaloShaderGeneratorAssembly != null) return _HaloShaderGeneratorAssembly;

                var haloshadergenerator = "HaloShaderGenerator.dll";
                if (!IsDllLoaded(haloshadergenerator))
                {
                    var local_path = Path.GetFullPath(haloshadergenerator);
                    if (File.Exists(local_path))
                    {
                        _HaloShaderGeneratorAssembly = Assembly.LoadFile(local_path);
                        return _HaloShaderGeneratorAssembly;
                    }

                    var process = Process.GetCurrentProcess(); // Or whatever method you are using
                    string fullPath = process.MainModule.FileName;

                    var relative_to_process_path = Path.Combine(Path.GetDirectoryName(fullPath), haloshadergenerator);
                    if (File.Exists(relative_to_process_path))
                    {
                        _HaloShaderGeneratorAssembly = Assembly.LoadFile(relative_to_process_path);
                        return _HaloShaderGeneratorAssembly;
                    }

                    return null;
                }
                return null;
            }
        }

        public static bool IsBaseDLLLoaded
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
    }


}
