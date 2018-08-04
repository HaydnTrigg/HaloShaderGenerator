#include <helpers\math.hlsli>

float4 calc_albedo_default_ps(float2 texcoord)
{
	return float4(0.75, 0.75, 0.75, 1.0);
}

float4 calc_albedo_detail_blend_ps(float2 texcoord)
{
	return float4(0.75, 0.75, 0.75, 1.0);
}

float4 calc_albedo_constant_color_ps(float2 texcoord)
{
	return float4(0.75, 0.75, 0.75, 1.0);
}

float4 calc_albedo_two_change_color_ps(float2 texcoord)
{
	return float4(0.75, 0.75, 0.75, 1.0);
}

float4 calc_albedo_four_change_color_ps(float2 texcoord)
{
	return float4(0.75, 0.75, 0.75, 1.0);
}

float4 calc_albedo_three_detail_blend_ps(float2 texcoord)
{

}

float4 calc_albedo_two_detail_overlay_ps(float2 texcoord)
{

}

float4 calc_albedo_two_detail_ps(float2 texcoord)
{

}

float4 calc_albedo_color_mask_ps(float2 texcoord)
{

}

float4 calc_albedo_two_detail_black_point_ps(float2 texcoord)
{

}

float4 calc_albedo_default_vs(float2 texcoord)
{

}

float4 calc_constant_color_vs(float2 texcoord)
{

}

#ifndef calc_albedo_ps
#define calc_albedo_ps calc_albedo_default_ps
#endif
#ifndef calc_albedo_vs
#define calc_albedo_vs calc_albedo_default_vs
#endif
