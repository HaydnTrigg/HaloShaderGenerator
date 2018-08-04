#include <helpers\math.hlsli>

float3 calc_bumpmap_off_ps(
	float3 tangentspace_x,
	float3 tangentspace_y,
	float3 tangentspace_z,
	float2 texcoord
) {
	return tangentspace_z;
}

float3 calc_bumpmap_default_ps(
	float3 tangentspace_x,
	float3 tangentspace_y,
	float3 tangentspace_z,
	float2 texcoord
) {
	return tangentspace_z; //TODO
}

float3 calc_bumpmap_detail_ps(
	float3 tangentspace_x,
	float3 tangentspace_y,
	float3 tangentspace_z,
	float2 texcoord
) {
	return tangentspace_z; //TODO
}

float3 calc_bumpmap_detail_masked_ps(
	float3 tangentspace_x,
	float3 tangentspace_y,
	float3 tangentspace_z,
	float2 texcoord
) {
	return tangentspace_z; //TODO
}

float3 calc_bumpmap_detail_plus_detail_masked_ps(
	float3 tangentspace_x,
	float3 tangentspace_y,
	float3 tangentspace_z,
	float2 texcoord
) {
	return tangentspace_z; //TODO
}

void calc_bumpmap_off_vs()
{

}

void calc_bumpmap_default_vs()
{

}

void calc_bumpmap_detail_vs()
{

}

//fixup
#define calc_bumpmap_standard_ps calc_bumpmap_default_ps
#define calc_bumpmap_standard_vs calc_bumpmap_default_vs

#ifndef calc_bumpmap_ps
#define calc_bumpmap_ps calc_bumpmap_off_ps
#endif
#ifndef calc_bumpmap_vs
#define calc_bumpmap_vs calc_bumpmap_off_vs
#endif
