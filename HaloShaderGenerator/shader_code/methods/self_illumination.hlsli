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
	return float4(0.0, 0.0, 0.0, 0.0);
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
    


    
    float4 c69 = thinness_medium;
    float4 c70 = thinness_sharp;
    float4 c71 = thinness_wide;


    float4 c66 = color_medium;
    float4 c67 = color_sharp;
    float4 c68 = color_wide;

    
    
    //log r0.w, r0.w
    noise = log(noise);
    //mul r1.x, r0.w, c71.x
    //exp r1.x, r1.x
    float a = exp(noise * thinness_wide);
    //mul r1.y, r0.w, c69.x
    //exp r1.y, r1.y
    float b = exp(noise * thinness_medium.x);
    //add r1.x, -r1.y, r1.x
    float c = a - b;
    //mul r0.w, r0.w, c70.x
    //exp r0.w, r0.w
    float d = exp(noise * thinness_sharp.x);
    //add r1.y, -r0.w, r1.y
    float e = b - d;


    float3 color = float3(0, 0, 0);


    //mul r2.xyz, c67.w, c67
    //mul r2.xyz, r0.w, r2
    color = (color_sharp.rgb * c67.w) * d;
    //mul r4.xyz, c66.w, c66
    //mad r2.xyz, r4, r1.y, r2
    color += (color_medium.rgb * color_medium.w) * e;
    //mul r4.xyz, c68.w, c68
    //mad r1.xyz, r4, r1.x, r2
    color += (color_wide.rgb * c68.w) * c;
    color = color * alpha_mask_map_sample.a; // apply alpha mask

    

    float4 test = alpha_mask_map_sample + noise_map_a_sample + noise_map_b_sample;
    test += color_medium;
    test += color_sharp;
    test += color_wide;
    test += thinness_medium;
    test += thinness_sharp;
    test += thinness_wide;
    test= float4(0,0, clamp(test.x, 0.0, 0.0001), 1.0);

    //float3 color = (c * e).xxx;
    //color = bungie_color_processing(color);
    color *= self_illum_intensity;
    color *= g_alt_exposure.x;

    return float4(test.xyz + color.rgb, 1.0);

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
