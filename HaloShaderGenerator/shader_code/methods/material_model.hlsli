#ifndef _MATERIAL_MODEL_HLSLI
#define _MATERIAL_MODEL_HLSLI

#include "../helpers/math.hlsli"
#include "../registers/shader.hlsli"

#define MATERIAL_TYPE_ARGS float3 diffuse, float3 normal, float3 unknown_vertex_color1, float3 fragment_world_position, float3 unknown_vertex_value0
#define MATERIAL_TYPE_ARGNAMES diffuse, normal, unknown_vertex_color1, fragment_world_position, unknown_vertex_value0

float3 calculate_unknown_lighting_value(float3 normal)
{
    //TODO: Clean this up
    float4 c11 = float4(0.5, 2, -1, 0.333333343);
    float4 c12 = float4(0, 0, 9.99999975e-005, 0.0500000007);
    float4 c58 = float4(-1.02332795, 0.886227012, -0.85808599, 0.429042995);

    // Matirx multiplications, on normals. Maybe a screen space normal? Dunno.
    float3 unknown_lighting_value;

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
    r1.xyz = r1.xyz / PI;

    unknown_lighting_value = r1.xyz;

    return unknown_lighting_value;
}

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

float3 material_type_diffuse_only(MATERIAL_TYPE_ARGS)
{
    float3 unknown_lighting_value = calculate_unknown_lighting_value(normal);

    float3 lighting = float3(0, 0, 0);

    if (no_dynamic_lights)
    {
        lighting = unknown_lighting_value.xyz * unknown_vertex_value0;
    }
    else
    {
        // not 100% sure if this is correct
        float3 relative_position = Camera_Position_PS - fragment_world_position;

        float3 accumulation = float3(0, 0, 0);
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

        lighting = unknown_lighting_value.xyz * unknown_vertex_value0 + accumulation;
    }

    return diffuse * lighting;
}

float3 material_type_cook_torrance(MATERIAL_TYPE_ARGS)
{
    return material_type_diffuse_only(MATERIAL_TYPE_ARGNAMES);
}

float3 material_type_two_lobe_phong(MATERIAL_TYPE_ARGS)
{
    return material_type_diffuse_only(MATERIAL_TYPE_ARGNAMES);
}

float3 material_type_foliage(MATERIAL_TYPE_ARGS)
{
    return material_type_diffuse_only(MATERIAL_TYPE_ARGNAMES);
}

float3 material_type_none(MATERIAL_TYPE_ARGS)
{
    return unknown_vertex_color1;
}

float3 material_type_glass(MATERIAL_TYPE_ARGS)
{
    return material_type_diffuse_only(MATERIAL_TYPE_ARGNAMES);
}

float3 material_type_organism(MATERIAL_TYPE_ARGS)
{
    return material_type_diffuse_only(MATERIAL_TYPE_ARGNAMES);
}

float3 material_type_single_lobe_phong(MATERIAL_TYPE_ARGS)
{
    return material_type_diffuse_only(MATERIAL_TYPE_ARGNAMES);
}

float3 material_type_car_paint(MATERIAL_TYPE_ARGS)
{
    return material_type_diffuse_only(MATERIAL_TYPE_ARGNAMES);
}

float3 material_type_hair(MATERIAL_TYPE_ARGS)
{
    return float3(0, 1, 0);
}

#ifndef material_type
#define material_type material_type_none
#endif

#endif
