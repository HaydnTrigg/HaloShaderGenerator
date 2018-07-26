using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HaloShaderGenerator
{
    public partial class ShaderGenerator
    {
        public enum Bump_Mapping
        {
            Off,
            Standard,
            Detail,
            Detail_Masked,
            Detail_Plus_Detail_Masked
        }

        public enum Alpha_Test
        {
            None,
            Simple
        }

        public enum Specular_Mask
        {
            No_Specular_Mask,
            Specular_Mask_From_Diffuse,
            Specular_Mask_From_Texture,
            Specular_Mask_From_Color_Texture
        }

        public enum Material_Model
        {
            Diffuse_Only,
            Cook_Torrance,
            Two_Lobe_Phong,
            Foliage,
            None,
            Glass,
            Organism,
            Single_Lobe_Phong,
            Car_Paint,
            Hair
        }

        public enum Environment_Mapping
        {
            None,
            Per_Pixel,
            Dynamic,
            From_Flat_Texture,
            Custom_Map
        }

        public enum Self_Illumination
        {
            Off,
            Simple,
            _3_Channel_Self_Illum,
            Plasma,
            From_Diffuse,
            Illum_Detail,
            Meter,
            Self_Illum_Times_Diffuse,
            Simple_With_Alpha_Mask,
            Simple_Four_Change_Color,
            Illum_Detail_World_Space_Four_Cc
        }

        public enum Blend_Mode
        {
            Opaque,
            Additive,
            Multiply,
            Alpha_Blend,
            Double_Multiply,
            Pre_Multiplied_Alpha
        }

        public enum Parallax
        {
            Off,
            Simple,
            Interpolated,
            Simple_Detail
        }

        public enum Misc
        {
            First_Person_Never,
            First_Person_Sometimes,
            First_Person_Always,
            First_Person_Never_With_rotating_Bitmaps
        }

        public enum Distortion
        {
            Off,
            On
        }

        public enum Soft_fade
        {
            Off,
            On
        }
    }
}
