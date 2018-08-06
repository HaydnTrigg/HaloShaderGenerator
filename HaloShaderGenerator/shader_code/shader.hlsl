#define shader_template

#include "registers/shader.hlsli"

#include "methods/albedo.hlsli"
#include "helpers/color_processing.hlsli"

//TODO: These must be in the correct order for the registers to align, double check this
#include "methods\bump_mapping.hlsli"
#include "methods\alpha_test.hlsli"
#include "methods\specular_mask.hlsli"
#include "methods\material_model.hlsli"
#include "methods\environment_mapping.hlsli"
#include "methods\self_illumination.hlsli"
#include "methods\blend_mode.hlsli"
#include "methods\parallax.hlsli"
#include "methods\misc.hlsli"

struct VS_OUTPUT_ALBEDO
{
    float4 TexCoord : TEXCOORD;
    float4 TexCoord1 : TEXCOORD1;
    float4 TexCoord2 : TEXCOORD2;
    float4 TexCoord3 : TEXCOORD3;
};

struct PS_OUTPUT_ALBEDO
{
    float4 Diffuse;
    float4 Normal;
    float4 Unknown;
};

PS_OUTPUT_ALBEDO entry_albedo(VS_OUTPUT_ALBEDO input) : COLOR
{
    float2 texcoord = input.TexCoord.xy;
    float2 texcoord_tiled = input.TexCoord.zw;
    float3 tangentspace_x = input.TexCoord3.xyz;
    float3 tangentspace_y = input.TexCoord2.xyz;
    float3 tangentspace_z = input.TexCoord1.xyz;
    float3 unknown = input.TexCoord1.w;

    float3 diffuse;
    float alpha;
	{
        float4 diffuse_alpha = calc_albedo_ps(texcoord);
        diffuse = diffuse_alpha.xyz;
        alpha = diffuse_alpha.w;
    }
    diffuse = bungie_color_processing(diffuse);
    
    float3 normal = calc_bumpmap_ps(tangentspace_x, tangentspace_y, tangentspace_z, texcoord);

    PS_OUTPUT_ALBEDO output;
    output.Diffuse = blend_type(float4(diffuse, alpha));
    output.Normal = blend_type(float4(normal_export(normal), alpha));
    output.Unknown = unknown.xxxx;
    return output;
}

struct VS_OUTPUT_ACTIVE_CAMO
{
    float4 vPos : VPOS;
    float4 TexCoord : TEXCOORD0;
    float4 TexCoord1 : TEXCOORD1;
};

struct PS_OUTPUT_DEFAULT
{
    float4 LowFrequency;
    float4 HighFrequency;
    float4 Unknown;
};

PS_OUTPUT_DEFAULT entry_active_camo(VS_OUTPUT_ACTIVE_CAMO input) : COLOR
{
    //note: vpos is in range [0, viewportsize]
    // add a half pixel offset
    float2 vpos = input.vPos.xy;
    float2 screen_location = vpos + 0.5; // half pixel offset
    float2 texel_size = float2(1.0, 1.0) / texture_size.xy;
    float2 screen_coord = screen_location * texel_size; // converts to [0, 1] range

    // I'm not sure what is happening here with these three
    // but I think its a depth value, and this is a kind of
    // clamp of the effect at a distance
    float unknown0 = 0.5 - input.TexCoord1.w;
    float unknown1 = 1.0 / input.TexCoord1.w;
    float unknown2 = unknown0 >= 0 ? 2.0 : unknown1;

    // not sure where these values come from
    // however, the aspect ratio is 16:9 multiplied by 4
    float2 unknown3 = input.TexCoord.xy * k_ps_active_camo_factor.yz / float2(64, 36);

    float2 texcoord = unknown3 * unknown2 + screen_coord;

    float4 sample = tex2D(scene_ldr_texture, texcoord);
    float3 color = sample.xyz;

    float alpha = k_ps_active_camo_factor.x;
    
    PS_OUTPUT_DEFAULT output;
    output.HighFrequency = export_high_frequency(float4(color, alpha));
    output.LowFrequency = export_low_frequency(float4(color, alpha));
    output.Unknown = float4(0, 0, 0, 0);
    return output;
}

struct VS_OUTPUT_STATIC_PTR_AMBIENT
{
    float4 vPos : VPOS;
    float4 TexCoord6 : TEXCOORD6;
    float4 TexCoord7 : TEXCOORD7;
    float4 Color : COLOR;
    float4 Color1 : COLOR1;
};

PS_OUTPUT_DEFAULT entry_static_prt_ambient(VS_OUTPUT_STATIC_PTR_AMBIENT input) : COLOR
{
    PS_OUTPUT_DEFAULT output;

    //   no_dynamic_lights     b0       1
    //   g_exposure            c0       1
    //   p_lighting_constant_0 c1       1
    //   p_lighting_constant_1 c2       1
    //   p_lighting_constant_2 c3       1
    //   p_lighting_constant_3 c4       1
    //   p_lighting_constant_4 c5       1
    //   p_lighting_constant_5 c6       1
    //   p_lighting_constant_6 c7       1
    //   p_lighting_constant_7 c8       1
    //   p_lighting_constant_8 c9       1
    //   p_lighting_constant_9 c10      1
    //   texture_size          c14      1
    //   Camera_Position_PS    c16      1
    //   simple_light_count    c17      1
    //   simple_lights         c18     40
    //   albedo_texture        s0       1
    //   normal_texture        s2       1
    //   g_exposure            c0       1

    bool b0 = no_dynamic_lights;

    float4 c0 = g_exposure;
    float4 c1 = p_lighting_constant_0;
    float4 c2 = p_lighting_constant_1;
    float4 c3 = p_lighting_constant_2;
    float4 c4 = p_lighting_constant_3;
    float4 c5 = p_lighting_constant_4;
    float4 c6 = p_lighting_constant_5;
    float4 c7 = p_lighting_constant_6;
    float4 c8 = p_lighting_constant_7;
    float4 c9 = p_lighting_constant_8;
    float4 c10 = p_lighting_constant_9;
    float2 c14 = texture_size;
    float3 c16 = Camera_Position_PS;
    float c17 = simple_light_count;
    float4 c18 = simple_lights[0];
    float4 c19 = simple_lights[1];
    float4 c20 = simple_lights[2];
    float4 c21 = simple_lights[3];
    float4 c22 = simple_lights[4];
    float4 c23 = simple_lights[5];
    float4 c24 = simple_lights[6];
    float4 c25 = simple_lights[7];
    float4 c26 = simple_lights[8];
    float4 c27 = simple_lights[9];
    float4 c28 = simple_lights[10];
    float4 c29 = simple_lights[11];
    float4 c30 = simple_lights[12];
    float4 c31 = simple_lights[13];
    float4 c32 = simple_lights[14];
    float4 c33 = simple_lights[15];
    float4 c34 = simple_lights[16];
    float4 c35 = simple_lights[17];
    float4 c36 = simple_lights[18];
    float4 c37 = simple_lights[19];
    float4 c38 = simple_lights[20];
    float4 c39 = simple_lights[21];
    float4 c40 = simple_lights[22];
    float4 c41 = simple_lights[23];
    float4 c42 = simple_lights[24];
    float4 c43 = simple_lights[25];
    float4 c44 = simple_lights[26];
    float4 c45 = simple_lights[27];
    float4 c46 = simple_lights[28];
    float4 c47 = simple_lights[29];
    float4 c48 = simple_lights[30];
    float4 c49 = simple_lights[31];
    float4 c50 = simple_lights[32];
    float4 c51 = simple_lights[33];
    float4 c52 = simple_lights[34];
    float4 c53 = simple_lights[35];
    float4 c54 = simple_lights[36];
    float4 c55 = simple_lights[37];
    float4 c56 = simple_lights[38];
    float4 c57 = simple_lights[39];

    sampler s0 = albedo_texture;
    sampler s2 = normal_texture;
    
    float4 r0 = float4(0, 0, 0, 0);
    float4 r1 = float4(0, 0, 0, 0);
    float4 r2 = float4(0, 0, 0, 0);
    float4 r3 = float4(0, 0, 0, 0);
    float4 r4 = float4(0, 0, 0, 0);
    float4 r5 = float4(0, 0, 0, 0);
    float4 r6 = float4(0, 0, 0, 0);
    float4 r7 = float4(0, 0, 0, 0);

    float4 oC0 = float4(0, 0, 0, 0);
    float4 oC1 = float4(0, 0, 0, 0);
    float4 oC2 = float4(0, 0, 0, 0);

    //ps_3_0
    //def c11, 0.5, 2, -1, 0.333333343
    float4 c11 = float4(0.5, 2, -1, 0.333333343);
    //def c12, 0.318309873, 0, 9.99999975e-005, 0.0500000007
    float4 c12 = float4(0.318309873, 0, 9.99999975e-005, 0.0500000007);
    //def c13, 3, 4, 5, 6
    float4 c13 = float4(3, 4, 5, 6);
    //def c15, 7, 0, 0, 0
    float4 c15 = float4(7, 0, 0, 0);
    //def c58, -1.02332795, 0.886227012, -0.85808599, 0.429042995
    float4 c58 = float4(-1.02332795, 0.886227012, -0.85808599, 0.429042995);
    //dcl_texcoord6 v0.xyz
    float3 v0 = input.TexCoord6.xyz;
    //dcl_texcoord7 v1.x
    float v1 = input.TexCoord7.x;
    //dcl_color v2.xyz
    float3 v2 = input.Color.xyz;
    //dcl_color1 v3.xyz
    float3 v3 = input.Color1.xyz;
    //dcl vPos.xy
    float2 vPos = input.vPos.xy;

    float2 frag_coord = (vPos + 0.5) / texture_size;

    //rcp r0.x, c14.x
    //rcp r0.y, c14.y
    float2 texel_size = 1.0 / texture_size;
    r0.xy = texel_size;
    //add r0.zw, c11.x, vPos.xyxy
    r0.zw = (c11.xxxx + vPos.xyxy).zw;
    //mul r0.xy, r0, r0.zwzw
    r0.xy = (r0 * r0.zwzw).xy;
    //texld r1, r0, s2
    r1 = tex2D(s2, r0.xy);
    float4 outputA = r1 * 2.0 - 1.0;
    //mad r1.xyz, r1, c11.y, c11.z
    r1.xyz = (r1 * c11.yyyy + c11.zzzz).xyz;
    //nrm r2.xyz, r1
    r2.xyz = normalize(r1.xyz);
    //dp3 r1.x, r2, c2
    r1.x = dot(r2.xyz, c2.xyz);
    //dp3 r1.y, r2, c3
    r1.y = dot(r2.xyz, c3.xyz);
    //dp3 r1.z, r2, c4
    r1.z = dot(r2.xyz, c4.xyz);
    //mul r1.xyz, r1, c58.x
    r1.xyz = (r1 * c58.xxxx).xyz;
    //mov r3.y, c58.y
    r3.y = c58.y;
    //mad r1.xyz, c1, r3.y, r1
    r1.xyz = (c1 * r3.yyyy + r1).xyz;
    //texld r0, r0, s0
    r0 = tex2D(s0, r0.xy);
    float4 outputB = r0;
    //mul r3.xyz, r2.yzxw, r2
    r3.xyz = (r2.yzxw * r2).xyz;
    //dp3 r4.x, r3, c5
    r4.x = dot(r3.xyz, c5.xyz);
    //dp3 r4.y, r3, c6
    r4.y = dot(r3.xyz, c6.xyz);
    //dp3 r4.z, r3, c7
    r4.z = dot(r3.xyz, c7.xyz);
    //mad r1.xyz, r4, c58.z, r1
    r1.xyz = (r4 * c58.zzzz + r1).xyz;
    //mov r3.w, c11.w
    r3.w = c11.w;
    //mul r3.xyz, r2, r2
    r3.xyz = (r2 * r2).xyz;
    //dp4 r4.x, r3, c8
    r4.x = dot(r3, c8);
    //dp4 r4.y, r3, c9
    r4.y = dot(r3, c9);
    //dp4 r4.z, r3, c10
    r4.z = dot(r3, c10);
    //mad r1.xyz, r4, -c58.w, r1
    r1.xyz = (r4 * (-c58.wwww) + r1).xyz;
    //mul r1.xyz, r1, c12.x
    r1.xyz = (r1 * c12.xxxx).xyz;
    
    
    if (b0) //if b0
    {
        //  mul r3.xyz, r1, v1.x
        r3.xyz = (r1 * v1.xxxx).xyz;
    }
    else //else
    {
        //  mov r4.y, c12.y
        r4.y = c12.y;
        //  if_lt -c17.x, r4.y
        if (c17.x > r4.y)
        {
            //add r4.xyz, c16, -v0
            //add r5.xyz, -r4, c18
            //dp3 r0.w, r5, r5
            //rsq r1.w, r0.w
            //mul r5.xyz, r1.w, r5
            //dp3 r1.w, r2, r5
            //add r2.w, r0.w, c18.w
            //rcp r6.x, r2.w
            //dp3 r6.y, r5, c19
            //mad r5.xy, r6, c21, c21.zwzw
            //max r6.xy, c12.z, r5
            //pow r2.w, r6.y, c20.w
            //add_sat r2.w, r2.w, c19.w
            //mov_sat r6.x, r6.x
            //mul r2.w, r2.w, r6.x
            //max r3.w, c12.w, r1.w
            //add r0.w, r0.w, -c22.x
            //mul r5.xyz, r2.w, c20
            //mul r5.xyz, r3.w, r5
            //cmp r5.xyz, r0.w, c12.y, r5
            //mov r6.yz, c11

            if (c17.x > r6.z) //if_lt -r6.z, c17.x
            {
                //add r6.xzw, -r4.xyyz, c23.xyyz
                //dp3 r0.w, r6.xzww, r6.xzww
                //rsq r1.w, r0.w
                //mul r6.xzw, r1.w, r6
                //dp3 r1.w, r2, r6.xzww
                //add r2.w, r0.w, c23.w
                //rcp r7.x, r2.w
                //dp3 r7.y, r6.xzww, c24
                //mad r6.xz, r7.xyyw, c26.xyyw, c26.zyww
                //max r7.xy, c12.z, r6.xzzw
                //pow r2.w, r7.y, c25.w
                //add_sat r2.w, r2.w, c24.w
                //mov_sat r7.x, r7.x
                //mul r2.w, r2.w, r7.x
                //max r3.w, c12.w, r1.w
                //add r0.w, r0.w, -c27.x
                //mul r6.xzw, r2.w, c25.xyyz
                //mad r6.xzw, r6, r3.w, r5.xyyz
                //cmp r5.xyz, r0.w, r5, r6.xzww

                if (c17.x > r6.y) //if_lt r6.y, c17.x
                {
                    //add r6.xyz, -r4, c28
                    //dp3 r0.w, r6, r6
                    //rsq r1.w, r0.w
                    //mul r6.xyz, r1.w, r6
                    //dp3 r1.w, r2, r6
                    //add r2.w, r0.w, c28.w
                    //rcp r7.x, r2.w
                    //dp3 r7.y, r6, c29
                    //mad r6.xy, r7, c31, c31.zwzw
                    //max r7.xy, c12.z, r6
                    //pow r2.w, r7.y, c30.w
                    //add_sat r2.w, r2.w, c29.w
                    //mov_sat r7.x, r7.x
                    //mul r2.w, r2.w, r7.x
                    //max r3.w, c12.w, r1.w
                    //add r0.w, r0.w, -c32.x
                    //mul r6.xyz, r2.w, c30
                    //mad r6.xyz, r6, r3.w, r5
                    //cmp r5.xyz, r0.w, r5, r6
                    //mov r6.x, c17.x

                    if (c17.x > c13.x) //if_lt c13.x, r6.x
                    {
                        //add r6.yzw, -r4.xxyz, c33.xxyz
                        //dp3 r0.w, r6.yzww, r6.yzww
                        //rsq r1.w, r0.w
                        //mul r6.yzw, r1.w, r6
                        //dp3 r1.w, r2, r6.yzww
                        //add r2.w, r0.w, c33.w
                        //rcp r7.x, r2.w
                        //dp3 r7.y, r6.yzww, c34
                        //mad r6.yz, r7.xxyw, c36.xxyw, c36.xzww
                        //max r7.xy, c12.z, r6.yzzw
                        //pow r2.w, r7.y, c35.w
                        //add_sat r2.w, r2.w, c34.w
                        //mov_sat r7.x, r7.x
                        //mul r2.w, r2.w, r7.x
                        //max r3.w, c12.w, r1.w
                        //add r0.w, r0.w, -c37.x
                        //mul r6.yzw, r2.w, c35.xxyz
                        //mad r6.yzw, r6, r3.w, r5.xxyz
                        //cmp r5.xyz, r0.w, r5, r6.yzww

                        if (c13.y < r6.x) //if_lt c13.y, r6.x
                        {
                            //add r6.yzw, -r4.xxyz, c38.xxyz
                            //dp3 r0.w, r6.yzww, r6.yzww
                            //rsq r1.w, r0.w
                            //mul r6.yzw, r1.w, r6
                            //dp3 r1.w, r2, r6.yzww
                            //add r2.w, r0.w, c38.w
                            //rcp r7.x, r2.w
                            //dp3 r7.y, r6.yzww, c39
                            //mad r6.yz, r7.xxyw, c41.xxyw, c41.xzww
                            //max r7.xy, c12.z, r6.yzzw
                            //pow r2.w, r7.y, c40.w
                            //add_sat r2.w, r2.w, c39.w
                            //mov_sat r7.x, r7.x
                            //mul r2.w, r2.w, r7.x
                            //max r3.w, c12.w, r1.w
                            //add r0.w, r0.w, -c42.x
                            //mul r6.yzw, r2.w, c40.xxyz
                            //mad r6.yzw, r6, r3.w, r5.xxyz
                            //cmp r5.xyz, r0.w, r5, r6.yzww
                        
                            if (c13.z < r6.x) //if_lt c13.z, r6.x
                            {
                                //add r6.yzw, -r4.xxyz, c43.xxyz
                                //dp3 r0.w, r6.yzww, r6.yzww
                                //rsq r1.w, r0.w
                                //mul r6.yzw, r1.w, r6
                                //dp3 r1.w, r2, r6.yzww
                                //add r2.w, r0.w, c43.w
                                //rcp r7.x, r2.w
                                //dp3 r7.y, r6.yzww, c44
                                //mad r6.yz, r7.xxyw, c46.xxyw, c46.xzww
                                //max r7.xy, c12.z, r6.yzzw
                                //pow r2.w, r7.y, c45.w
                                //add_sat r2.w, r2.w, c44.w
                                //mov_sat r7.x, r7.x
                                //mul r2.w, r2.w, r7.x
                                //max r3.w, c12.w, r1.w
                                //add r0.w, r0.w, -c47.x
                                //mul r6.yzw, r2.w, c45.xxyz
                                //mad r6.yzw, r6, r3.w, r5.xxyz
                                //cmp r5.xyz, r0.w, r5, r6.yzww
                            
                                if (c13.w < r6.x) //if_lt c13.w, r6.x
                                {
                                    //add r6.yzw, -r4.xxyz, c53.xxyz
                                    //dp3 r0.w, r6.yzww, r6.yzww
                                    //rsq r1.w, r0.w
                                    //mul r6.yzw, r1.w, r6
                                    //dp3 r1.w, r2, r6.yzww
                                    //add r2.w, r0.w, c53.w
                                    //rcp r7.x, r2.w
                                    //dp3 r7.y, r6.yzww, c54
                                    //mad r6.yz, r7.xxyw, c56.xxyw, c56.xzww
                                    //max r7.xy, c12.z, r6.yzzw
                                    //pow r2.w, r7.y, c55.w
                                    //add_sat r2.w, r2.w, c54.w
                                    //mov_sat r7.x, r7.x
                                    //mul r2.w, r2.w, r7.x
                                    //max r3.w, c12.w, r1.w
                                    //add r1.w, -r6.x, c15.x
                                    //add r4.xyz, -r4, c48
                                    //dp3 r4.w, r4, r4
                                    //rsq r5.w, r4.w
                                    //mul r4.xyz, r4, r5.w
                                    //dp3 r2.x, r2, r4
                                    //add r2.y, r4.w, c48.w
                                    //rcp r6.x, r2.y
                                    //dp3 r6.y, r4, c49
                                    //mad r2.yz, r6.xxyw, c51.xxyw, c51.xzww
                                    //max r4.xy, c12.z, r2.yzzw
                                    //pow r2.y, r4.y, c50.w
                                    //add_sat r2.y, r2.y, c49.w
                                    //mov_sat r4.x, r4.x
                                    //mul r2.y, r2.y, r4.x
                                    //max r4.x, c12.w, r2.x
                                    //add r2.x, r4.w, -c52.x
                                    //mul r4.yzw, r2.y, c50.xxyz
                                    //mad r4.xyz, r4.yzww, r4.x, r5
                                    //cmp r2.xyz, r2.x, r5, r4
                                    //add r0.w, r0.w, -c57.x
                                    //mul r4.xyz, r2.w, c55
                                    //mad r4.xyz, r4, r3.w, r2
                                    //cmp r4.xyz, r0.w, r2, r4
                                    //cmp r5.xyz, r1.w, r2, r4
                                } //endif
                            } //endif
                        } //endif
                    } //endif
                } //endif
            } //endif
        }
        else //  else
        {
            //    mov r5.xyz, c12.y
            r5.xyz = c12.yyy;
        } //  endif
        
        //  mad r3.xyz, r1, v1.x, r5
        r3.xyz = (r1 * v1.xxxx + r5).xyz;
    } //endif

    
    //mul r0.xyz, r0, r3
    r0.xyz = (r0 * r3).xyz;
    //mov r1.xyz, v2
    r1.xyz = v2.xyz;
    //mad r0.xyz, r0, r1, v3
    r0.xyz = (r0 * r1).xyz + v3;
    //mul r0.xyz, r0, c0.x
    r0.xyz = (r0 * g_exposure.x).xyz;
    //max r1.xyz, r0, c12.y
    r1.xyz = max(r0.xyz, c12.yyy);
    //rcp r0.x, c0.y
    r0.x = 1.0 / g_exposure.y;
    //mul oC1.xyz, r0.x, r1
    oC1.xyz = (r1 * r0.xxxx).xyz;
    //mov oC0.xyz, r1
    oC0.xyz = (r1).xyz;
    //mov oC0.w, c0.w
    oC0.w = g_exposure.w;
    //mov oC1.w, c0.z
    oC1.w = g_exposure.z;
    //mov oC2, c12.y

    
    //output.LowFrequency = export_low_frequency(float4(frag_coord, 0.0, 0.15));
    //output.HighFrequency = export_high_frequency(float4(0.0, 0.0, 0.0, 0));
    output.LowFrequency = oC0;
    output.HighFrequency = oC1;
    //output.LowFrequency = outputB;
    //output.HighFrequency = outputA * 0.00001;
    

    output.Unknown = float4(0, 0, 0, 0);
    return output;
}

float4 entry_static_prt_linear(VS_OUTPUT_ALBEDO input) : COLOR
{
    return float4(0.0, 1.0, 0.0, 0.15);
}

float4 entry_static_prt_quadratic(VS_OUTPUT_ALBEDO input) : COLOR
{
    return float4(0.0, 0.0, 1.0, 0.15);
}
