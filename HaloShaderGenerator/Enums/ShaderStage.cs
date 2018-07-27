using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HaloShaderGenerator.Enums
{
    public enum ShaderStage
    {
        Default,
        Albedo,
        Static_Default,
        Static_Per_Pixel,
        Static_Per_Vertex,
        Static_Sh,
        Static_Prt_Ambient,
        Static_Prt_Linear,
        Static_Prt_Quadratic,
        Dynamic_Light,
        Shadow_Generate,
        Shadow_Apply,
        Active_Camo,
        Lightmap_Debug_Mode,
        Static_Per_Vertex_Color,
        Water_Tesselation,
        Water_Shading,
        Dynamic_Light_Cinematic,
        Z_Only,
        Sfx_Distort,
    }
}
