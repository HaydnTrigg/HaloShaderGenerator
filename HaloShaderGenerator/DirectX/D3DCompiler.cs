using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace HaloShaderGenerator.DirectX
{
    public static class D3DCompiler
    {
        public enum D3DCOMPILE : UInt32
        {
            //Directs the compiler to insert debug file/line/type/symbol information into the output code.
            D3DCOMPILE_DEBUG = (1 << 0),
            //Directs the compiler not to validate the generated code against known capabilities and constraints.We recommend that you use this constant only with shaders that have been successfully compiled in the past. DirectX always validates shaders before it sets them to a device.
            D3DCOMPILE_SKIP_VALIDATION = (1 << 1),
            //Directs the compiler to skip optimization steps during code generation.We recommend that you set this constant for debug purposes only.
            D3DCOMPILE_SKIP_OPTIMIZATION = (1 << 2),
            //Directs the compiler to pack matrices in row-major order on input and output from the shader.
            D3DCOMPILE_PACK_MATRIX_ROW_MAJOR = (1 << 3),
            //Directs the compiler to pack matrices in column-major order on input and output from the shader.This type of packing is generally more efficient because a series of dot-products can then perform vector-matrix multiplication.
            D3DCOMPILE_PACK_MATRIX_COLUMN_MAJOR =(1 << 4),
            //Directs the compiler to perform all computations with partial precision.If you set this constant, the compiled code might run faster on some hardware.
            D3DCOMPILE_PARTIAL_PRECISION =(1 << 5),
            //Directs the compiler to compile a vertex shader for the next highest shader profile. This constant turns debugging on and optimizations off.
            D3DCOMPILE_FORCE_VS_SOFTWARE_NO_OPT =(1 << 6),
            //Directs the compiler to compile a pixel shader for the next highest shader profile.This constant also turns debugging on and optimizations off.
            D3DCOMPILE_FORCE_PS_SOFTWARE_NO_OPT =(1 << 7),
            //Directs the compiler to disable Preshaders.If you set this constant, the compiler does not pull out static expression for evaluation.
            D3DCOMPILE_NO_PRESHADER =(1 << 8),
            //Directs the compiler to not use flow-control constructs where possible.
            D3DCOMPILE_AVOID_FLOW_CONTROL =(1 << 9),
            //Directs the compiler to use flow-control constructs where possible.
            D3DCOMPILE_PREFER_FLOW_CONTROL =(1 << 10),
            /*
             * Forces strict compile, which might not allow for legacy syntax.
             * By default, the compiler disables strictness on deprecated syntax.
             */
            D3DCOMPILE_ENABLE_STRICTNESS = (1 << 11),
            //Directs the compiler to enable older shaders to compile to 5_0 targets.
            D3DCOMPILE_ENABLE_BACKWARDS_COMPATIBILITY =(1 << 12),
            //Forces the IEEE strict compile.
            D3DCOMPILE_IEEE_STRICTNESS =(1 << 13),
            //Directs the compiler to use the lowest optimization level.If you set this constant, the compiler might produce slower code but produces the code more quickly. Set this constant when you develop the shader iteratively.
            D3DCOMPILE_OPTIMIZATION_LEVEL0 =  (1 << 14),
            //Directs the compiler to use the second lowest optimization level.
            D3DCOMPILE_OPTIMIZATION_LEVEL1 =  0,
            //Directs the compiler to use the second highest optimization level.
            D3DCOMPILE_OPTIMIZATION_LEVEL2 = ((1 << 14) | (1 << 15)),
            //Directs the compiler to use the highest optimization level.If you set this constant, the compiler produces the best possible code but might take significantly longer to do so.Set this constant for final builds of an application when performance is the most important factor.
            D3DCOMPILE_OPTIMIZATION_LEVEL3 =  (1 << 15),
            //Directs the compiler to treat all warnings as errors when it compiles the shader code. We recommend that you use this constant for new shader code, so that you can resolve all warnings and lower the number of hard-to-find code defects.
            D3DCOMPILE_WARNINGS_ARE_ERRORS = (1 << 18),
            /*
             * Directs the compiler to assume that unordered access views(UAVs) and shader resource views(SRVs) may alias for cs_5_0.
             * Note
             * This compiler constant is new starting with the D3dcompiler_47.dll.
             */
            D3DCOMPILE_RESOURCES_MAY_ALIAS =(1 << 19),
            /*
             * Directs the compiler to enable unbounded descriptor tables.
             * Note
             * This compiler constant is new starting with the D3dcompiler_47.dll.
             */
            D3DCOMPILE_ENABLE_UNBOUNDED_DESCRIPTOR_TABLES = (1 << 20),
            /*
             * Directs the compiler to ensure all resources are bound.
             * Note
             * This compiler constant is new starting with the D3dcompiler_47.dll.
             */
            D3DCOMPILE_ALL_RESOURCES_BOUND = (1 << 21),
        }

        public static byte[] Compile(string Source, string Entrypoint, string Target, D3D.SHADER_MACRO[] Defines = null, D3DCOMPILE Flags1 = 0, uint Flags2 = 0, string SourceName = null, Include include = null)
        {
            // Macros should never be duplicated
            for (var i = 0; i < Defines.Count(); i++)
            {
                for (var j = 0; j < Defines.Count(); j++)
                {
                    if (i == j) continue;
                    if (Defines.ElementAt(i).Name == Defines.ElementAt(j).Name)
                    {
                        throw new Exception($"Macro {Defines.ElementAt(i).Name} is defined multiple times");
                    }
                }
            }

            byte[] data = null;
            D3D.ID3DBlob ppCode = null;
            D3D.ID3DBlob ppErrorMsgs = null;

            // Null terminated defines array
            var _defines = Defines?.Concat(new D3D.SHADER_MACRO[] { new D3D.SHADER_MACRO() }).ToArray();
            var source_data = ASCIIEncoding.ASCII.GetBytes(Source + char.MinValue);
            var source_size = source_data.Length;

            var CompileResult = D3D.D3DCompile(source_data, new UIntPtr((uint)source_size), SourceName, _defines, include?.NativePointer ?? IntPtr.Zero, Entrypoint, Target, (UInt32)Flags1, Flags2, ref ppCode, ref ppErrorMsgs);

            if (ppErrorMsgs != null)
            {
                IntPtr errors = ppErrorMsgs.GetBufferPointer();
                int size = ppErrorMsgs.GetBufferSize();
                var error_text = Marshal.PtrToStringAnsi(errors);

                Marshal.ReleaseComObject(ppErrorMsgs);
                

                if (CompileResult != 0)
                {
                    if (ppCode != null) Marshal.ReleaseComObject(ppCode);
                    throw new Exception(error_text);
                }
                else
                {
                    Console.WriteLine(error_text);
                }
            }

            if (ppCode != null)
            {
                IntPtr pData = ppCode.GetBufferPointer();
                int iSize = ppCode.GetBufferSize();

                data = new byte[iSize];
                Marshal.Copy(pData, data, 0, data.Length);

                Marshal.ReleaseComObject(ppCode);
            }

            return data;
        }

        public static byte[] CompileFromFile(string Filename, string Entrypoint, string Target, D3D.SHADER_MACRO[] Defines = null, D3DCOMPILE Flags1 = 0, uint Flags2 = 0, Include include = null)
        {
            byte[] data = null;
            D3D.ID3DBlob ppCode = null;
            D3D.ID3DBlob ppErrorMsgs = null;

            // Null terminated defines array
            var _defines = Defines?.Concat(new D3D.SHADER_MACRO[] { new D3D.SHADER_MACRO() }).ToArray();

            var CompileResult = D3D.D3DCompileFromFile(Filename, _defines, include?.NativePointer ?? IntPtr.Zero, Entrypoint, Target, (UInt32)Flags1, Flags2, ref ppCode, ref ppErrorMsgs);

            if (ppErrorMsgs != null)
            {
                IntPtr errors = ppErrorMsgs.GetBufferPointer();
                int size = ppErrorMsgs.GetBufferSize();
                var error_text = Marshal.PtrToStringAnsi(errors);

                Marshal.ReleaseComObject(ppErrorMsgs);
                if (ppCode != null) Marshal.ReleaseComObject(ppCode);

                if (CompileResult != 0)
                {
                    throw new Exception(error_text);
                }
                else
                {
                    Console.WriteLine(error_text);
                }
            }

            if (ppCode != null)
            {
                IntPtr pData = ppCode.GetBufferPointer();
                int iSize = ppCode.GetBufferSize();

                data = new byte[iSize];
                Marshal.Copy(pData, data, 0, data.Length);

                Marshal.ReleaseComObject(ppCode);
            }

            return data;
        }

        public static byte[] Assemble(string Assembly, string filename = null, D3D.SHADER_MACRO[] Defines = null, uint Flags = 0, Include include = null)
        {
            byte[] data = null;
            D3D.ID3DBlob ppCode = null;
            D3D.ID3DBlob ppErrorMsgs = null;

            var macros = Defines?.Concat(new D3D.SHADER_MACRO[] { new D3D.SHADER_MACRO() }).ToArray();
            var source_data = ASCIIEncoding.ASCII.GetBytes(Assembly + char.MinValue);
            var source_size = source_data.Length;

            var CompileResult = D3D.D3DAssemble(source_data, new UIntPtr((uint)source_size), filename, Defines, include?.NativePointer ?? IntPtr.Zero, Flags, ref ppCode, ref ppErrorMsgs);

            if (ppErrorMsgs != null)
            {
                IntPtr errors = ppErrorMsgs.GetBufferPointer();
                int size = ppErrorMsgs.GetBufferSize();
                var error_text = Marshal.PtrToStringAnsi(errors);

                Marshal.ReleaseComObject(ppErrorMsgs);
                if (ppCode != null) Marshal.ReleaseComObject(ppCode);

                if (CompileResult != 0)
                {
                    throw new Exception(error_text);
                }
                else
                {
                    Console.WriteLine(error_text);
                }
            }

            if (ppCode != null)
            {
                IntPtr pData = ppCode.GetBufferPointer();
                int iSize = ppCode.GetBufferSize();

                data = new byte[iSize];
                Marshal.Copy(pData, data, 0, data.Length);

                Marshal.ReleaseComObject(ppCode);
            }

            return data;
        }

        public static string Disassemble(byte[] bytecode)
        {
            D3D.ID3DBlob ppDisassembly = null;

            var result = D3D.D3DDisassemble(bytecode, new UIntPtr((uint)bytecode.Length), 0, null, ref ppDisassembly);

            if (result != 0)
            {
                //throw new Exception("Failed to disassembly shader");
                return null;
            }

            string result_str = null;

            if (ppDisassembly != null)
            {
                IntPtr pData = ppDisassembly.GetBufferPointer();
                int iSize = ppDisassembly.GetBufferSize();

                var data = new byte[iSize];
                Marshal.Copy(pData, data, 0, data.Length);

                Marshal.ReleaseComObject(ppDisassembly);

                result_str = System.Text.Encoding.ASCII.GetString(data);
            }

            return result_str;
        }
    }
}
