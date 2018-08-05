#ifndef _SHADER_HLSLI
#define _SHADER_HLSLI

#include "../helpers/types.hlsli"

uniform float4 g_exposure : register(c0);

//TODO
uniform float4 __unknown_c1 : register(c1);
uniform float4 __unknown_c2 : register(c2);
uniform float4 __unknown_c3 : register(c3);
uniform float4 __unknown_c4 : register(c4);
uniform float4 __unknown_c5 : register(c5);
uniform float4 __unknown_c6 : register(c6);
uniform float4 __unknown_c7 : register(c7);
uniform float4 __unknown_c8 : register(c8);
uniform float4 __unknown_c9 : register(c9);
uniform float4 __unknown_c10 : register(c10);
uniform float4 __unknown_c11 : register(c11);
uniform float4 __unknown_c12 : register(c12);
uniform float4 __unknown_c13 : register(c13);
uniform float4 __unknown_c14 : register(c14);
uniform float4 __unknown_c15 : register(c15);
uniform float4 __unknown_c16 : register(c16);
uniform float4 __unknown_c17 : register(c17);

// Not 100% sure if this is in here all the time
uniform float4 simple_lights[40] : register(c18);

/*
This region here is where dynamically created uniforms are allowed
Not entirely sure where this ends
*/

/*
-------------------------------------------------- ALBEDO
*/

uniform float4 albedo_color;
uniform float4 albedo_color2;
uniform float4 albedo_color3;

uniform sampler base_map;
uniform xform2d base_map_xform;
// no idea why this is so, this seems to disappear when hightmaps are present :/
// we need a better solution for this
//NOTE: We should be able to macro this out
#ifdef shader_template 
uniform xform2d __unknown_s1 : register(s1);
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

/*
-------------------------------------------------- END ALBEDO
*/

/*
-------------------------------------------------- BUMP MAPPING
*/

uniform sampler bump_map;
uniform xform2d bump_map_xform;
uniform sampler bump_detail_map;
uniform xform2d bump_detail_map_xform;
uniform xform2d bump_detail_coefficient;
uniform sampler bump_detail_mask_map;
uniform xform2d bump_detail_mask_map_xform;

/*
-------------------------------------------------- END BUMP MAPPING
*/




#endif
