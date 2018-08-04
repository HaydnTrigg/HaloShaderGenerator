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
        static void Benchmark()
        {
            var then = DateTime.Now;
            List<Task<byte[]>> tasks = new List<Task<byte[]>>();
            for (int i = 0; i < 100000; i++)
            {
                var task = ShaderGenerator.GenerateAsync(
                ShaderStage.Default,
                Albedo.Two_Change_Color,
                ShaderGenerator.Bump_Mapping.Off,
                ShaderGenerator.Alpha_Test.None,
                ShaderGenerator.Specular_Mask.No_Specular_Mask,
                ShaderGenerator.Material_Model.None,
                ShaderGenerator.Environment_Mapping.None,
                ShaderGenerator.Self_Illumination.Off,
                ShaderGenerator.Blend_Mode.Opaque,
                ShaderGenerator.Parallax.Off,
                ShaderGenerator.Misc.First_Person_Always,
                ShaderGenerator.Distortion.Off,
                ShaderGenerator.Soft_fade.Off
                );
                tasks.Add(task);
            }
            Task.WaitAll(tasks.ToArray());
            TimeSpan delta = DateTime.Now - then;
            Console.WriteLine(delta.TotalSeconds);
            Console.WriteLine($"{100000.0 / delta.TotalSeconds} shaders/s");
        }
        static int Main()
        {
            var bytecode = ShaderGenerator.Generate(
                ShaderStage.Albedo,
                Albedo.Two_Change_Color,
                ShaderGenerator.Bump_Mapping.Off,
                ShaderGenerator.Alpha_Test.None,
                ShaderGenerator.Specular_Mask.No_Specular_Mask,
                ShaderGenerator.Material_Model.None,
                ShaderGenerator.Environment_Mapping.None,
                ShaderGenerator.Self_Illumination.Off,
                ShaderGenerator.Blend_Mode.Opaque,
                ShaderGenerator.Parallax.Off,
                ShaderGenerator.Misc.First_Person_Always,
                ShaderGenerator.Distortion.Off,
                ShaderGenerator.Soft_fade.Off
                );
            return bytecode?.Length ?? -1;
        }
    }
}
