#ifndef _ALBEDO_HLSLI
#define _ALBEDO_HLSLI

#include "../helpers/types.hlsli"
#include "../helpers/math.hlsli"

uniform float4 albedo_color;
uniform float4 albedo_color2;
uniform float4 albedo_color3;

uniform sampler base_map;
uniform xform2d base_map_xform;
#ifdef shader_template // no idea why this is so
uniform xform2d unknown_map : register(s1);
#endif
uniform sampler detail_map;
uniform xform2d detail_map_xform;

uniform float4 debug_tint;

uniform sampler detail_map2;
uniform xform2d detail_map2_xform;

uniform sampler change_color_map;
uniform xform2d change_color_map_xform;
uniform float3 primary_change_color;
uniform float3 secondary_change_color;
uniform float4 primary_change_color_old : register(c190); // TODO Figure this one out
uniform float4 secondary_change_color_old : register(c191); // TODO Figure this one out
uniform float3 tertiary_change_color;
uniform float3 quaternary_change_color;

uniform sampler detail_map3;
uniform xform2d detail_map3_xform;

uniform sampler detail_map_overlay;
uniform xform2d detail_map_overlay_xform;

uniform sampler color_mask_map;
uniform xform2d color_mask_map_xform;
uniform float4 neutral_gray;

float4 calc_albedo_default_ps(float2 texcoord)
{
    float2 base_map_texcoord = apply_xform2d(texcoord, base_map_xform);
    float2 detail_map_texcoord = apply_xform2d(texcoord, detail_map_xform);

    float4 base_map_sample = tex2D(base_map, base_map_texcoord);
    float4 detail_map_sample = tex2D(detail_map, detail_map_texcoord);
    
    return base_map_sample * detail_map_sample * albedo_color;
}

float4 calc_albedo_detail_blend_ps(float2 texcoord)
{
    float2 base_map_texcoord = apply_xform2d(texcoord, base_map_xform);
    float2 detail_map_texcoord = apply_xform2d(texcoord, detail_map_xform);
    float2 detail_map2_texcoord = apply_xform2d(texcoord, detail_map2_xform);

    float4 base_map_sample = tex2D(base_map, base_map_texcoord);
    float4 detail_map_sample = tex2D(detail_map, detail_map_texcoord);
    float4 detail_map2_sample = tex2D(detail_map2, detail_map2_texcoord);

    float3 blended_detail = lerp(detail_map_sample.xyz, detail_map2_sample.xyz, base_map_sample.w);

    return float4(base_map_sample.xyz * blended_detail, base_map_sample.w);
}

float4 calc_albedo_constant_color_ps(float2 texcoord)
{
    return albedo_color;
}

float4 calc_albedo_two_change_color_ps(float2 texcoord)
{
    float2 base_map_texcoord = apply_xform2d(texcoord, base_map_xform);
    float2 detail_map_texcoord = apply_xform2d(texcoord, detail_map_xform);
    float2 change_color_map_texcoord = apply_xform2d(texcoord, change_color_map_xform);

    float4 base_map_sample = tex2D(base_map, detail_map_texcoord);
    float4 detail_map_sample = tex2D(detail_map, detail_map_texcoord);
    float4 change_color_map_sample = tex2D(change_color_map, change_color_map_texcoord);

    float2 change_color_value = change_color_map_sample.xy;
    float2 change_color_value_invert = 1.0 - change_color_value;

    float3 change_primary = primary_change_color * change_color_value.x + change_color_value_invert.x;
    float3 change_secondary = secondary_change_color * change_color_value.y + change_color_value_invert.y;

    float3 change_aggregate = change_primary * change_secondary;

    float4 base_detail_aggregate = base_map_sample * detail_map_sample;

    return float4(base_detail_aggregate.xyz * change_aggregate, base_detail_aggregate.w);
}

float4 calc_albedo_four_change_color_ps(float2 texcoord)
{
    float2 base_map_texcoord = apply_xform2d(texcoord, base_map_xform);
    float2 detail_map_texcoord = apply_xform2d(texcoord, detail_map_xform);
    float2 change_color_map_texcoord = apply_xform2d(texcoord, change_color_map_xform);

    float4 base_map_sample = tex2D(base_map, detail_map_texcoord);
    float4 detail_map_sample = tex2D(detail_map, detail_map_texcoord);
    float4 change_color_map_sample = tex2D(change_color_map, change_color_map_texcoord);

    float4 change_color_value = change_color_map_sample.xyzw;
    float4 change_color_value_invert = 1.0 - change_color_value;

    float3 change_primary = primary_change_color * change_color_value.x + change_color_value_invert.x;
    float3 change_secondary = secondary_change_color * change_color_value.y + change_color_value_invert.y;
    float3 change_tertiary = tertiary_change_color * change_color_value.y + change_color_value_invert.y;
    float3 change_quaternary = quaternary_change_color * change_color_value.y + change_color_value_invert.y;

    float3 change_aggregate = change_primary * change_secondary;

    float4 base_detail_aggregate = base_map_sample * detail_map_sample;

    return float4(base_detail_aggregate.xyz * change_aggregate, base_detail_aggregate.w);
}

float4 calc_albedo_three_detail_blend_ps(float2 texcoord)
{
    float2 base_map_texcoord = apply_xform2d(texcoord, base_map_xform);
    float2 detail_map_texcoord = apply_xform2d(texcoord, detail_map_xform);
    float2 detail_map2_texcoord = apply_xform2d(texcoord, detail_map2_xform);
    float2 detail_map3_texcoord = apply_xform2d(texcoord, detail_map3_xform);

    float4 base_map_sample = tex2D(base_map, base_map_texcoord);
    float4 detail_map_sample = tex2D(detail_map, detail_map_texcoord);
    float4 detail_map2_sample = tex2D(detail_map2, detail_map2_texcoord);
    float4 detail_map3_sample = tex2D(detail_map3, detail_map3_texcoord);

    float alpha2 = saturate(base_map_sample.w * 2.0); // I don't understand why this is so
    float4 blended_detailA = lerp(detail_map_sample, detail_map2_sample, alpha2);

    float alpha2b = base_map_sample.w * 2.0 + -1.0; // I don't understand why this is so
    float4 blended_detailB = lerp(blended_detailA, detail_map3_sample, alpha2b);

    float3 color = base_map_sample.xyz * blended_detailB.xyz;

	// the alpha2 component there handles transparency throughout the entire interpolation
	// however, because of that, I think this entire function could be re-arranged and
	// that could lead to better assembly generation

    return float4(color, blended_detailB.w);
}

float4 calc_albedo_two_detail_overlay_ps(float2 texcoord)
{
    float2 base_map_texcoord = apply_xform2d(texcoord, base_map_xform);
    float2 detail_map_texcoord = apply_xform2d(texcoord, detail_map_xform);
    float2 detail_map2_texcoord = apply_xform2d(texcoord, detail_map2_xform);
    float2 detail_map_overlay_texcoord = apply_xform2d(texcoord, detail_map_overlay_xform);

    float4 base_map_sample = tex2D(base_map, base_map_texcoord);
    float4 detail_map_sample = tex2D(detail_map, detail_map_texcoord);
    float4 detail_map2_sample = tex2D(detail_map2, detail_map2_texcoord);
    float4 detail_map_overlay_sample = tex2D(detail_map_overlay, detail_map_overlay_texcoord);

    float4 detail_blend = lerp(detail_map_sample, detail_map2_sample, base_map_sample.w);

    float3 detail_color = base_map_sample.xyz * detail_blend.xyz * detail_map_overlay_sample.xyz;

    float alpha = detail_map_overlay_sample.w * detail_blend.w;

    return float4(detail_color, alpha);
}

float4 calc_albedo_two_detail_ps(float2 texcoord)
{
    float2 base_map_texcoord = apply_xform2d(texcoord, base_map_xform);
    float2 detail_map_texcoord = apply_xform2d(texcoord, detail_map_xform);
    float2 detail_map2_texcoord = apply_xform2d(texcoord, detail_map2_xform);

    float4 base_map_sample = tex2D(base_map, base_map_texcoord);
    float4 detail_map_sample = tex2D(detail_map, detail_map_texcoord);
    float4 detail_map2_sample = tex2D(detail_map2, detail_map2_texcoord);

    float4 detail_color = base_map_sample * detail_map_sample * detail_map2_sample;

    return detail_color;
}

float4 calc_albedo_color_mask_ps(float2 texcoord)
{
    float2 base_map_texcoord = apply_xform2d(texcoord, base_map_xform);
    float2 detail_map_texcoord = apply_xform2d(texcoord, detail_map_xform);
    float2 color_mask_map_texcoord = apply_xform2d(texcoord, color_mask_map_xform);

    float4 base_map_sample = tex2D(base_map, base_map_texcoord);
    float4 detail_map_sample = tex2D(detail_map, detail_map_texcoord);
    float4 color_mask_map_sample = tex2D(color_mask_map, color_mask_map_texcoord);

    float4 color = base_map_sample * detail_map_sample;

    float3 color_mask_invert = 1.0 - color_mask_map_sample.xyz;
    float4 neutral_invert = float4((1.0 / neutral_gray.xyz), 1.0);

    float4 masked_color0 = color_mask_map_sample.x * albedo_color;
    float4 masked_color1 = color_mask_map_sample.y * albedo_color2;
    float4 masked_color2 = color_mask_map_sample.z * albedo_color3;

    masked_color0 = masked_color0 * neutral_invert + color_mask_invert.xxxx;
    masked_color1 = masked_color1 * neutral_invert + color_mask_invert.yyyy;
    masked_color2 = masked_color2 * neutral_invert + color_mask_invert.zzzz;

    float4 result = color * masked_color0 * masked_color1 * masked_color2;

    return result;
}

float4 calc_albedo_two_detail_black_point_ps(float2 texcoord)
{
    float2 base_map_texcoord = apply_xform2d(texcoord, base_map_xform);
    float2 detail_map_texcoord = apply_xform2d(texcoord, detail_map_xform);
    float2 detail_map2_texcoord = apply_xform2d(texcoord, detail_map2_xform);

    float4 base_map_sample = tex2D(base_map, base_map_texcoord);
    float4 detail_map_sample = tex2D(detail_map, detail_map_texcoord);
    float4 detail_map2_sample = tex2D(detail_map2, detail_map2_texcoord);


	// This one seems to make zero sense so I'm just going to program it as it disassembled

    float4 c0 = float4(21.1120949, 1, 0.5, 0.00313080009);
    float4 c1 = float4(12.92, (5.0 / 12.0), 1.055, -0.055);

    float4 r0 = detail_map2_sample;
    float4 r1 = detail_map_sample;
    float4 r2 = base_map_sample;

	// This code is very similar to the strange bungie stuff
	// But that value of 21.1, no idea. I've seen it before
	// and just substtitudes this function out with the
	// regular disassembled version
	// except this one appears to be slightly different

    r1.xyz *= r2.xyz; //mul r1.xyz, r1, r2
    r0.xyz *= r1.xyz; //mul r0.xyz, r0, r1

    float3 export_color = r0.xyz;

    r1.xyz = r0.xyz * c0.x; //mul r1.xyz, r0, c0.x
    r2.x = c0.x; //mov r2.x, c0.x // Like what the fuck is a value like this doing in here?
    r0.xyz = r0.xyz * (-r2.xxx) + debug_tint.xyz; //mad r0.xyz, r0, -r2.x, c60
    r0.xyz = debug_tint.www * r0.xyz + r1.xyz; //mad r0.xyz, c60.w, r0, r1
    r1.xyz = log(r0.xyz); //log r1.x, r0.x //log r1.y, r0.y //log r1.z, r0.z
    r1.xyz *= c1.y; //mul r1.xyz, r1, c1.y
    r2.xyz = exp(r1.xyz); //exp r2.x, r1.x //exp r2.y, r1.y //exp r2.z, r1.z
    r1.xyz = r2.xyz * c1.z + c1.w; //mad r1.xyz, r2, c1.z, c1.w
    r2.xyz = (-r0.xyz) + c0.w; //add r2.xyz, -r0, c0.w // 50 shades of what the fuck is that
    r0.xyz *= c1.x; //mul r0.xyz, r0, c1.x
    float3 color = r2.xyz >= 0 ? r0.xyz : r1.xyz; //cmp oC0.xyz, r2, r0, r1

	// This is the other bit I dont get at all. Extra alpha processing.

    r0.x = r2.w + c0.y; //add r0.x, r2.w, c0.y
    r0.y = lerp(-r2.w, c0.y, c0.z); //lrp r0.y, c0.z, c0.y, -r2.w // I think this is some kind of average? c0.z = 0.5
    r0.x *= c0.z; //mul r0.x, r0.x, c0.z
    r0.z = r1.w * r0.w + (-r2.w); //mad r0.z, r1.w, r0.w, -r2.w
    r0.w = saturate(r1.w * r0.w + (-r0.x)); //mad_sat r0.w, r1.w, r0.w, -r0.x
    r0.y = 1.0 / r0.y; //rcp r0.y, r0.y
    r0.y = saturate(r0.y * r0.z); //mul_sat r0.y, r0.y, r0.z
    r0.x = r0.x * r0.y + r0.w; //mad r0.x, r0.x, r0.y, r0.w

    float alpha = r0.x;

	// In theory, any of the crazy stuff should just be compiled out?
    return float4(export_color, alpha);
}

float4 calc_albedo_two_change_color_anim_ps(float2 texcoord)
{
	return random_debug_color(11);
}

float4 calc_albedo_chameleon_ps(float2 texcoord)
{
	return random_debug_color(12);
}

float4 calc_albedo_two_change_color_chameleon_ps(float2 texcoord)
{
	return random_debug_color(13);
}

float4 calc_albedo_chameleon_masked_ps(float2 texcoord)
{
	return random_debug_color(14);
}

float4 calc_albedo_color_mask_hard_light_ps(float2 texcoord)
{
	return random_debug_color(15);
}

float4 calc_albedo_default_vs(float2 texcoord)
{

}

float4 calc_constant_color_vs(float2 texcoord)
{

}

//fixups
#define calc_albedo_two_change_color_anim_overlay_ps calc_albedo_two_change_color_anim_ps

#ifndef calc_albedo_ps
#define calc_albedo_ps calc_albedo_default_ps
#endif
#ifndef calc_albedo_vs
#define calc_albedo_vs calc_albedo_default_vs
#endif

#endif
