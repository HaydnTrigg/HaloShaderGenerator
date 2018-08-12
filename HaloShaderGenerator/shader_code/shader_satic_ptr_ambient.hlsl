#include "helpers/definition_helper.hlsli"
#include "registers/shader.hlsli"
#include "helpers/input_output.hlsli"

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

#define overwrite(old, new) (clamp(old * 0.0001, 0, 0.0001) + new)


//TODO: This is poor mans templateing for the time being

float4 material_type_diffuse_only(float2 fragcoord)
{
    return float4(0, 0, 0, 0);
}

//#ifndef material_type
//#define material_type material_type_diffuse_only
//#endif

struct ALBEDO_PASS_RESULT
{
    float3 albedo;
    float alpha;
    float3 normal;
};

#ifndef envmap_type_arg
#define envmap_type_arg 0
#endif
#ifndef k_environment_mapping_custom_map_none
#define k_environment_mapping_custom_map_none 0
#endif

// finally we have this crazy code!!!!
float3 apply_debug_tint(float3 color)
{
    float debug_tint_factor = 4.595;
    float3 negative_tinted_color = color * (-debug_tint_factor) + debug_tint.rgb;
    float3 positive_color = color * debug_tint_factor;
    return positive_color + negative_tinted_color * debug_tint.a;
}


ALBEDO_PASS_RESULT get_albedo_and_normal(float2 fragcoord, float2 texcoord, float3 tangentspace_x, float3 tangentspace_y, float3 tangentspace_z)
{
    ALBEDO_PASS_RESULT result = (ALBEDO_PASS_RESULT) 0;

    if (actually_calc_albedo)
    {
        float4 diffuse_and_alpha = calc_albedo_ps(texcoord);
        result.albedo = apply_debug_tint(diffuse_and_alpha.xyz);
        result.alpha = diffuse_and_alpha.w;
        result.normal = calc_bumpmap_ps(tangentspace_x, tangentspace_y, tangentspace_z, texcoord);
        return result;
    }
    else
    {
        // sample from framebuffer
        float4 albedo_texture_sample = tex2D(albedo_texture, fragcoord);
        result.albedo = albedo_texture_sample.xyz;
        result.alpha = albedo_texture_sample.w;

        float4 normal_texture_sample = tex2D(normal_texture, fragcoord);
        result.normal = normalize(normal_texture_sample.xyz * 2.0 - 1.0);
    }

    return result;
}


PS_OUTPUT_DEFAULT entry_static_prt_ambient(VS_OUTPUT_STATIC_PTR_AMBIENT input) : COLOR
{
    // These are from albedo, not 100% sure if correct
    float2 texcoord = input.TexCoord.xy;
    float2 texcoord_tiled = input.TexCoord.zw;
    float3 tangentspace_x = input.TexCoord3.xyz;
    float3 tangentspace_y = input.TexCoord2.xyz;
    float3 tangentspace_z = input.TexCoord1.xyz;

    PS_OUTPUT_DEFAULT output;

    //TODO: Clean this up
    float4 c11 = float4(0.5, 2, -1, 0.333333343);
    float4 c12 = float4(0, 0, 9.99999975e-005, 0.0500000007);
    float4 c58 = float4(-1.02332795, 0.886227012, -0.85808599, 0.429042995);

    //TODO: Better name these, not 100% sure what they do yet
    float3 fragment_world_position = input.TexCoord6.xyz; // camera direction in world space
    float unknown_vertex_value0 = input.TexCoord7.x;
    float3 v2 = input.Color.xyz; // some kind of vertex baked ao? not sure cause of shadows gotta investigate
    float3 unknown_vertex_color1 = input.Color1.xyz;
    float2 vPos = input.vPos.xy;

    float2 fragcoord = (vPos + 0.5) / texture_size;
    
    ALBEDO_PASS_RESULT albedo_and_normal = get_albedo_and_normal(fragcoord, texcoord, tangentspace_x, tangentspace_y, tangentspace_z);
    float3 albedo = albedo_and_normal.albedo;
    float3 normal = albedo_and_normal.normal;

    float3 eye_world = normalize(fragment_world_position);
    
    float3 material_lighting = material_type(albedo, normal, unknown_vertex_color1, fragment_world_position, unknown_vertex_value0);
    float3 environment = envmap_type(eye_world, normal);
    float4 self_illumination = calc_self_illumination_ps(texcoord, albedo);

    float3 color = (environment + self_illumination.xyz) * v2 + material_lighting;

    float3 exposed_color = expose_color(color);

    //TODO: No transparency so far, we're going to need this!!!
    float4 output_color = blend_type(float4(exposed_color, 1.0));

    output.LowFrequency = export_low_frequency(output_color); //oC0
    output.HighFrequency = export_high_frequency(output_color); //oC1

    output.Unknown = float4(0, 0, 0, 0); //oC2

    return output;
}
