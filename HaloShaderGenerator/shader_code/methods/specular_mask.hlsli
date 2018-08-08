#ifndef _SPECULAR_MASK_HLSLI
#define _SPECULAR_MASK_HLSLI

#include "../helpers/math.hlsli"

float4 calc_specular_mask_no_specular_mask_ps(float3 diffuse)
{
	return float4(0.0, 0.0, 0.0, 0.0);
}

float4 calc_specular_mask_from_diffuse_ps(float3 diffuse)
{
	return float4(0.0, 0.0, 0.0, 0.0); //TODO
}

float4 calc_specular_mask_texture_ps(float3 diffuse)
{
	return float4(0.0, 0.0, 0.0, 0.0); //TODO
}

#ifndef calc_specular_mask_ps
#define calc_specular_mask_ps calc_specular_mask_no_specular_mask_ps
#endif

#endif
