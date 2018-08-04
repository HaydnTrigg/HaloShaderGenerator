using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HaloShaderGenerator.Enums
{
    public enum Albedo
    {
        Default,
        Detail_Blend,
        Constant_Color,
        Two_Change_Color,
        Four_Change_Color,
        Three_Detail_Blend,
        Two_Detail_Overlay,
        Two_Detail,
        Color_Mask,
        Two_Detail_Black_Point,
        Two_Change_Color_Anim_Overlay,
        Chameleon,
        Two_Change_Color_Chameleon,
        Chameleon_Masked,
        Color_Mask_Hard_Light,
        Two_Change_Color_Tex_Overlay,
        Chameleon_Albedo_Masked
    }
}
