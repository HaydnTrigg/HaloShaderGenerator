#include <helpers\math.hlsli>

float4 calc_self_illumination_none_ps(float3 diffuse)
{
	return float4(0.0, 0.0, 0.0, 0.0);
}

float4 calc_self_illumination_simple_ps(float3 diffuse)
{
	return float4(0.0, 0.0, 0.0, 0.0);
}

float4 calc_self_illumination_three_channel_ps(float3 diffuse)
{
	return float4(0.0, 0.0, 0.0, 0.0);
}

float4 calc_self_illumination_from_albedo_ps(float3 diffuse)
{
	return float4(0.0, 0.0, 0.0, 0.0);
}

float4 calc_self_illumination_detail_ps(float3 diffuse)
{
	return float4(0.0, 0.0, 0.0, 0.0);
}

float4 calc_self_illumination_meter_ps(float3 diffuse)
{
	return float4(0.0, 0.0, 0.0, 0.0);
}

float4 calc_self_illumination_times_diffuse_ps(float3 diffuse)
{
	return float4(0.0, 0.0, 0.0, 0.0);
}

float4 calc_self_illumination_simple_with_alpha_mask_ps(float3 diffuse)
{
	return float4(0.0, 0.0, 0.0, 0.0);
}

// fixups
#define calc_self_illumination_off_ps calc_self_illumination_none_ps
#define calc_3_channel_self_illum_ps calc_self_illumination_three_channel_ps
#define calc_self_illumination_from_diffuse_ps calc_self_illumination_from_albedo_ps
#define calc_self_illumination_illum_detail_ps calc_self_illumination_detail_ps
#define calc_self_illumination_self_illum_times_diffuse_ps calc_self_illumination_times_diffuse_ps

#ifndef calc_self_illumination_ps
#define calc_self_illumination_ps calc_self_illumination_none_ps
#endif
