#include "registers/shader.hlsli"
#include "helpers/input_output.hlsli"
#include "helpers/color_processing.hlsli"

float3 calculate_simple_light(SimpleLight simple_light, float3 previous_illumination, float3 normal, float3 relative_position)
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
    float temporary1 = 0.0;
    float temporary2 = 0.0;

    //add r5.xyz, -r4, simple_light.unknown0
    r5.xyz = ((-relative_position) + simple_light.unknown0.xyz).xyz;
    //dp3 temporary0, r5, r5
    temporary0 = dot(r5.xyz, r5.xyz);
    //rsq temporary1, temporary0
    temporary1 = 1.0 / sqrt(temporary0);
    //mul r5.xyz, temporary1, r5
    r5.xyz = (temporary1.xxxx * r5).xyz;
    //dp3 temporary1, r2, r5
    temporary1 = dot(normal, r5.xyz);
    //add temporary2, temporary0, simple_light.unknown0.w
    temporary2 = temporary0 + simple_light.unknown0.w;
    //rcp r6.x, temporary2
    r6.x = 1.0 / temporary2;
    //dp3 r6.y, r5, simple_light.unknown1
    r6.y = dot(r5.xyz, simple_light.unknown1.xyz);
    //mad r5.xy, r6, simple_light.unknown3, simple_light.unknown3.zwzw
    r5.xy = (r6 * simple_light.unknown3 + simple_light.unknown3.zwzw).xy;
    //max r6.xy, c12.z, r5
    r6.xy = max(c12.zzzz, r5).xy;
    //pow temporary2, r6.y, simple_light.unknown2.w
    temporary2 = pow(r6.y, simple_light.unknown2.w);
    //add_sat temporary2, temporary2, simple_light.unknown1.w
    temporary2 = saturate(temporary2 + simple_light.unknown1.w);
    //mov_sat r6.x, r6.x
    r6.x = saturate(r6.x);
    //mul temporary2, temporary2, r6.x
    temporary2 = temporary2 * r6.x;
    //max r3.w, c12.w, temporary1
    r3.w = max(c12.w, temporary1);
    //add temporary0, temporary0, -simple_light.unknown4.x
    temporary0 = temporary0 - simple_light.unknown4.x;
    //mul r5.xyz, temporary2, simple_light.unknown2
    r5.xyz = (simple_light.unknown2 * temporary2).xyz;
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

    //TODO: Clean this up
    float4 c11 = float4(0.5, 2, -1, 0.333333343);
    float4 c12 = float4(0.318309873, 0, 9.99999975e-005, 0.0500000007);
    float4 c58 = float4(-1.02332795, 0.886227012, -0.85808599, 0.429042995);

    //TODO: Better name these, not 100% sure what they do yet
    float3 v0 = input.TexCoord6.xyz;
    float v1 = input.TexCoord7.x;
    float3 v2 = input.Color.xyz;
    float3 v3 = input.Color1.xyz;
    float2 vPos = input.vPos.xy;

    float2 frag_coord = (vPos + 0.5) / texture_size;
    
    float4 albedo_texture_sample = tex2D(albedo_texture, frag_coord);
    float3 albedo = albedo_texture_sample.xyz;

    float4 normal_texture_sample = tex2D(normal_texture, frag_coord);
    float3 normal = normalize(normal_texture_sample.xyz * 2.0 - 1.0);

    // Matirx multiplications, on normals. Maybe a screen space normal? Dunno.
    float3 unknown;
    {
        float3 r1 = float3(0, 0, 0);
        float3 r4 = float3(0, 0, 0);
        float4 r3 = float4(0, 0, 0, 0);

        //dp3 r1.x, r2, c2
        r1.x = dot(normal, p_lighting_constant_1.xyz);
        //dp3 r1.y, r2, c3
        r1.y = dot(normal, p_lighting_constant_2.xyz);
        //dp3 r1.z, r2, c4
        r1.z = dot(normal, p_lighting_constant_3.xyz);
        //mul r1.xyz, r1, c58.x
        r1.xyz = (r1 * c58.xxx).xyz;
        //mov r3.y, c58.y
        r3.y = c58.y;
        //mad r1.xyz, c1, r3.y, r1
        r1.xyz = (p_lighting_constant_0.xyz * r3.yyy + r1).xyz;
        //mul r3.xyz, r2.yzxw, r2
        r3.xyz = normal.yzx * normal;
        //dp3 r4.x, r3, c5
        r4.x = dot(r3.xyz, p_lighting_constant_4.xyz);
        //dp3 r4.y, r3, c6
        r4.y = dot(r3.xyz, p_lighting_constant_5.xyz);
        //dp3 r4.z, r3, c7
        r4.z = dot(r3.xyz, p_lighting_constant_6.xyz);
        //mad r1.xyz, r4, c58.z, r1
        r1.xyz = (r4 * c58.zzz + r1.xyz).xyz;
        //mov r3.w, c11.w
        r3.w = c11.w;
        //mul r3.xyz, r2, r2
        r3.xyz = (normal * normal).xyz;
        //dp4 r4.x, r3, c8
        r4.x = dot(r3, p_lighting_constant_7);
        //dp4 r4.y, r3, c9
        r4.y = dot(r3, p_lighting_constant_8);
        //dp4 r4.z, r3, c10
        r4.z = dot(r3, p_lighting_constant_9);
        //mad r1.xyz, r4, -c58.w, r1
        r1.xyz = (r4 * (-c58.www) + r1.xyz).xyz;
        //mul r1.xyz, r1, c12.x
        r1.xyz = (r1 * c12.xxx).xyz;

        unknown = r1.xyz;
    }
    
        // i think this is ambient lighting
    float3 ambient = unknown * v1;
    float3 accumulation = ambient;

    if (!no_dynamic_lights)
    {
        // not 100% sure if this is correct
        float3 relative_position = Camera_Position_PS - v0;

        if (simple_light_count > 0)
        {
            accumulation = calculate_simple_light(simple_lights[0], accumulation, normal, relative_position);
            if (simple_light_count > 1)
            {
                accumulation = calculate_simple_light(simple_lights[1], accumulation, normal, relative_position);
                if (simple_light_count > 2)
                {
                    accumulation = calculate_simple_light(simple_lights[2], accumulation, normal, relative_position);
                    if (simple_light_count > 3)
                    {
                        accumulation = calculate_simple_light(simple_lights[3], accumulation, normal, relative_position);
                        if (simple_light_count > 4)
                        {
                            accumulation = calculate_simple_light(simple_lights[4], accumulation, normal, relative_position);
                            if (simple_light_count > 5)
                            {
                                accumulation = calculate_simple_light(simple_lights[5], accumulation, normal, relative_position);
                                if (simple_light_count > 6)
                                {
                                    accumulation = calculate_simple_light(simple_lights[6], accumulation, normal, relative_position);
                                    if (simple_light_count > 7)
                                    {
                                        accumulation = calculate_simple_light(simple_lights[7], accumulation, normal, relative_position);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    float3 color = albedo * accumulation * v2 + v3;
    float3 exposed_color = expose_color(color);

    output.LowFrequency = export_low_frequency(float4(exposed_color, 1.0));
    output.HighFrequency = export_high_frequency(float4(exposed_color, 1.0));

    output.Unknown = float4(0, 0, 0, 0);
    return output;
}