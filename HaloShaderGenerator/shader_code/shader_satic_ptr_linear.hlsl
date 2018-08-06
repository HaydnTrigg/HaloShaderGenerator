#include "registers/shader.hlsli"
#include "helpers/input_output.hlsli"
#include "helpers/color_processing.hlsli"

float3 calculate_simple_light(SimpleLight simple_light, float3 previous_illumination, float4 r1, float4 r2, float4 r4)
{
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

    float4 r5 = float4(0, 0, 0, 0);
    float4 r6 = float4(0, 0, 0, 0);
    float4 r3 = float4(0, 0, 0, 0);

    float temporary0 = 0.0;

    //add r5.xyz, -r4, simple_light.unknown0
    r5.xyz = ((-r4) + simple_light.unknown0).xyz;
    //dp3 temporary0, r5, r5
    temporary0 = dot(r5.xyz, r5.xyz);
    //rsq r1.w, temporary0
    r1.w = 1.0 / sqrt(temporary0);
    //mul r5.xyz, r1.w, r5
    r5.xyz = (r1.wwww * r5).xyz;
    //dp3 r1.w, r2, r5
    r1.w = dot(r2.xyz, r5.xyz);
    //add r2.w, temporary0, simple_light.unknown0.w
    r2.w = temporary0 + simple_light.unknown0.w;
    //rcp r6.x, r2.w
    r6.x = 1.0 / r2.w;
    //dp3 r6.y, r5, simple_light.unknown1
    r6.y = dot(r5.xyz, simple_light.unknown1.xyz);
    //mad r5.xy, r6, simple_light.unknown3, simple_light.unknown3.zwzw
    r5.xy = (r6 * simple_light.unknown3 + simple_light.unknown3.zwzw).xy;
    //max r6.xy, c12.z, r5
    r6.xy = max(c12.zzzz, r5).xy;
    //pow r2.w, r6.y, simple_light.unknown2.w
    r2.w = pow(r6.y, simple_light.unknown2.w);
    //add_sat r2.w, r2.w, simple_light.unknown1.w
    r2.w = saturate(r2.w + simple_light.unknown1.w);
    //mov_sat r6.x, r6.x
    r6.x = saturate(r6.x);
    //mul r2.w, r2.w, r6.x
    r2.w = r2.w * r6.x;
    //max r3.w, c12.w, r1.w
    r3.w = max(c12.w, r1.w);
    //add temporary0, temporary0, -simple_light.unknown4.x
    temporary0 = temporary0 - simple_light.unknown4.x;
    //mul r5.xyz, r2.w, simple_light.unknown2
    r5.xyz = (simple_light.unknown2 * r2.w).xyz;
    //mul r5.xyz, r3.w, r5
    r5.xyz = (r5 * r3.w).xyz;

    // we need to accumulate here
    r5.xyz += previous_illumination;

    //cmp r5.xyz, temporary0, c12.y, r5
    r5.xyz = (temporary0.xxx >= 0 ? previous_illumination : r5.xyz).xyz;

    return r5.xyz;
}



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
    float4 c18 = simple_lights[0].unknown0;
    float4 c19 = simple_lights[0].unknown1;
    float4 c20 = simple_lights[0].unknown2;
    float4 c21 = simple_lights[0].unknown3;
    float4 c22 = simple_lights[0].unknown4;
    float4 c23 = simple_lights[1].unknown0;
    float4 c24 = simple_lights[1].unknown1;
    float4 c25 = simple_lights[1].unknown2;
    float4 c26 = simple_lights[1].unknown3;
    float4 c27 = simple_lights[1].unknown4;
    float4 c28 = simple_lights[2].unknown0;
    float4 c29 = simple_lights[2].unknown1;
    float4 c30 = simple_lights[2].unknown2;
    float4 c31 = simple_lights[2].unknown3;
    float4 c32 = simple_lights[2].unknown4;
    float4 c33 = simple_lights[3].unknown0;
    float4 c34 = simple_lights[3].unknown1;
    float4 c35 = simple_lights[3].unknown2;
    float4 c36 = simple_lights[3].unknown3;
    float4 c37 = simple_lights[3].unknown4;
    float4 c38 = simple_lights[4].unknown0;
    float4 c39 = simple_lights[4].unknown1;
    float4 c40 = simple_lights[4].unknown2;
    float4 c41 = simple_lights[4].unknown3;
    float4 c42 = simple_lights[4].unknown4;
    float4 c43 = simple_lights[5].unknown0;
    float4 c44 = simple_lights[5].unknown1;
    float4 c45 = simple_lights[5].unknown2;
    float4 c46 = simple_lights[5].unknown3;
    float4 c47 = simple_lights[5].unknown4;
    float4 c48 = simple_lights[6].unknown0;
    float4 c49 = simple_lights[6].unknown1;
    float4 c50 = simple_lights[6].unknown2;
    float4 c51 = simple_lights[6].unknown3;
    float4 c52 = simple_lights[6].unknown4;
    float4 c53 = simple_lights[7].unknown0;
    float4 c54 = simple_lights[7].unknown1;
    float4 c55 = simple_lights[7].unknown2;
    float4 c56 = simple_lights[7].unknown3;
    float4 c57 = simple_lights[7].unknown4;


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

    r1 = tex2D(s2, frag_coord);
    r0 = tex2D(s0, frag_coord);

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
    
    
    if (no_dynamic_lights)
    {
        r3.xyz = (r1 * v1.xxxx).xyz;
    }
    else
    {
        float3 accumulation = float3(0, 0, 0);

        if (-c17.x < c12.y)
        {
            r4.xyz = (c16 - v0).xyz;
            accumulation = calculate_simple_light(simple_lights[0], accumulation, r1, r2, r4);
            r6.yz = c11.yz;
            if (-r6.z < c17.x)
            {
                accumulation = calculate_simple_light(simple_lights[1], accumulation, r1, r2, r4);
                if (r6.y < c17.x)
                {
                    accumulation = calculate_simple_light(simple_lights[2], accumulation, r1, r2, r4);
                    if (c13.x < r6.x)
                    {
                        accumulation = calculate_simple_light(simple_lights[3], accumulation, r1, r2, r4);
                        if (c13.y < r6.x)
                        {
                            accumulation = calculate_simple_light(simple_lights[4], accumulation, r1, r2, r4);
                            if (c13.z < r6.x)
                            {
                                accumulation = calculate_simple_light(simple_lights[5], accumulation, r1, r2, r4);
                                if (c13.w < r6.x)
                                {
                                    accumulation = calculate_simple_light(simple_lights[6], accumulation, r1, r2, r4);
                                    accumulation = calculate_simple_light(simple_lights[7], accumulation, r1, r2, r4);
                                }
                            }
                        }
                    }
                }
            }
        }

        r3.xyz = (r1.xyz * v1.xxx + accumulation).xyz;
    }

    
    //mul r0.xyz, r0, r3
    r0.xyz = (r0 * r3).xyz;
    //mov r1.xyz, v2
    r1.xyz = v2.xyz;
    //mad r0.xyz, r0, r1, v3
    r0.xyz = (r0 * r1).xyz + v3;

    float3 color = expose_color(r0.xyz);
    output.LowFrequency = export_low_frequency(float4(color, 1.0));
    output.HighFrequency = export_high_frequency(float4(color, 1.0));

    output.Unknown = float4(0, 0, 0, 0);
    return output;
}