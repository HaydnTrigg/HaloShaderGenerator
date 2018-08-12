#ifndef _SELF_ILLUMINATION_HLSLI
#define _SELF_ILLUMINATION_HLSLI

#include "../helpers/math.hlsli"
#include "../helpers/color_processing.hlsli"
#include "../registers/shader.hlsli"

#define SELF_ILLUM_ARGS float2 texcoord, float3 diffuse

float4 calc_self_illumination_none_ps(SELF_ILLUM_ARGS)
{
	return float4(0.0, 0.0, 0.0, 0.0);
}

float4 calc_self_illumination_simple_ps(SELF_ILLUM_ARGS)
{
    float4 self_illum_map_sample = tex2D(self_illum_map, apply_xform2d(texcoord, self_illum_map_xform));

    float3 illum_color = self_illum_map_sample.rgb;

    illum_color *= self_illum_color.rgb;
    illum_color *= self_illum_intensity;
    illum_color *= g_alt_exposure.x;

    return float4(illum_color, self_illum_map_sample.w);
}

float4 calc_self_illumination_three_channel_ps(SELF_ILLUM_ARGS)
{
    return float4(0.0, 0.0, 0.0, 0.0);
}

float4 calc_self_illumination_plasma_ps(SELF_ILLUM_ARGS)
{
    //mad r1.xy, v0, c63, c63.zwzw
    //texld r1, r1, s5
    float4 alpha_mask_map_sample = tex2D(alpha_mask_map, apply_xform2d(texcoord, alpha_mask_map_xform));
    //mad r1.xy, v0, c64, c64.zwzw
    //texld r2, r1, s6
    float4 noise_map_a_sample = tex2D(noise_map_a, apply_xform2d(texcoord, noise_map_a_xform));
    //mad r1.xy, v0, c65, c65.zwzw
    //texld r4, r1, s7
    float4 noise_map_b_sample = tex2D(noise_map_b, apply_xform2d(texcoord, noise_map_b_xform));

    float noise = 1.0 - abs(noise_map_a_sample.x - noise_map_b_sample.x);
    float log_noise = log(noise);

    float noise_wide = exp(log_noise * thinness_wide);
    float noise_medium = exp(log_noise * thinness_medium);
    float noise_sharp = exp(log_noise * thinness_sharp);

    // These three noise components represent the full [0-1] range
    float noise_wide_to_medium = noise_wide - noise_medium;
    float noise_medium_to_sharp = noise_medium - noise_sharp;
    float noise_sharp_to_zero = noise_sharp - 0.0;

    float3 color = float3(0, 0, 0);
    
    color = color_sharp.rgb * color_sharp.a * noise_sharp_to_zero;
    color += color_medium.rgb * color_medium.a * noise_medium_to_sharp;
    color += color_wide.rgb * color_wide.a * noise_wide_to_medium;

    color *= alpha_mask_map_sample.a; // apply alpha mask
    color *= self_illum_intensity;
    color *= g_alt_exposure.x;

    // not 100% sure about alpha yet
    return float4(color.rgb, 1.0);
}

float4 calc_self_illumination_from_albedo_ps(SELF_ILLUM_ARGS)
{
	return float4(0.0, 0.0, 0.0, 0.0);
}

float4 calc_self_illumination_detail_ps(SELF_ILLUM_ARGS)
{
	return float4(0.0, 0.0, 0.0, 0.0);
}

float4 calc_self_illumination_meter_ps(SELF_ILLUM_ARGS)
{
	return float4(0.0, 0.0, 0.0, 0.0);
}

float4 calc_self_illumination_times_diffuse_ps(SELF_ILLUM_ARGS)
{
	return float4(0.0, 0.0, 0.0, 0.0);
}

float4 calc_self_illumination_simple_with_alpha_mask_ps(SELF_ILLUM_ARGS)
{
	return float4(0.0, 0.0, 0.0, 0.0);
}

float4 calc_self_illumination_simple_four_change_color_ps(SELF_ILLUM_ARGS)
{
    return float4(0.0, 0.0, 0.0, 0.0);
}

// fixups
#define calc_self_illumination_off_ps calc_self_illumination_none_ps
#define calc_self_illumination_3_channel_self_illum_ps calc_self_illumination_three_channel_ps
#define calc_self_illumination__3_channel_self_illum_ps calc_self_illumination_three_channel_ps
#define calc_self_illumination_from_diffuse_ps calc_self_illumination_from_albedo_ps
#define calc_self_illumination_illum_detail_ps calc_self_illumination_detail_ps
#define calc_self_illumination_self_illum_times_diffuse_ps calc_self_illumination_times_diffuse_ps

#ifndef calc_self_illumination_ps
#define calc_self_illumination_ps calc_self_illumination_none_ps
#endif

#endif
