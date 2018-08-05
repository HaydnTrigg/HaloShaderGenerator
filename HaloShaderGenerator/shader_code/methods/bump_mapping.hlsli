#ifndef _BUMP_MAPPING_HLSLI
#define _BUMP_MAPPING_HLSLI

#include "../helpers/types.hlsli"
#include "../helpers/math.hlsli"
#include "../helpers/bumpmap_math.hlsli"

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
    float2 bump_map_texcoord = apply_xform2d(texcoord, bump_map_xform);
    float3 normal = sample_normal_2d(bump_map, bump_map_texcoord);
    return normal_transform(tangentspace_x, tangentspace_y, tangentspace_z, normal);
}

float3 calc_bumpmap_detail_ps(
	float3 tangentspace_x,
	float3 tangentspace_y,
	float3 tangentspace_z,
	float2 texcoord
)
{
    float3 bump_map_sample = sample_normal_2d(bump_map, apply_xform2d(texcoord, bump_map_xform));
    float3 bump_detail_map_sample = sample_normal_2d(bump_detail_map, apply_xform2d(texcoord, bump_detail_map_xform));
    float3 normal = bump_map_sample + bump_detail_map_sample * bump_detail_coefficient.x;
    return normal_transform(tangentspace_x, tangentspace_y, tangentspace_z, normal);
}

float3 calc_bumpmap_detail_masked_ps(
	float3 tangentspace_x,
	float3 tangentspace_y,
	float3 tangentspace_z,
	float2 texcoord
)
{
    float3 bump_map_sample = sample_normal_2d(bump_map, apply_xform2d(texcoord, bump_map_xform));
    float3 bump_detail_map_sample = sample_normal_2d(bump_detail_map, apply_xform2d(texcoord, bump_detail_map_xform));
    float3 normal = bump_map_sample + bump_detail_map_sample * bump_detail_coefficient.x;
    return normal_transform(tangentspace_x, tangentspace_y, tangentspace_z, normal);

    //NOTE: This is a new saber shader
    //TODO: We need to implement the mask
}

float3 calc_bumpmap_detail_plus_detail_masked_ps(
	float3 tangentspace_x,
	float3 tangentspace_y,
	float3 tangentspace_z,
	float2 texcoord
) {
    float3 bump_map_sample = sample_normal_2d(bump_map, apply_xform2d(texcoord, bump_map_xform));
    float3 bump_detail_map_sample = sample_normal_2d(bump_detail_map, apply_xform2d(texcoord, bump_detail_map_xform));
    float3 normal = bump_map_sample + bump_detail_map_sample * bump_detail_coefficient.x;
    return normal_transform(tangentspace_x, tangentspace_y, tangentspace_z, normal);

    //NOTE: This is a new saber shader
    //TODO: We need to implement the mask + second detail
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

#endif