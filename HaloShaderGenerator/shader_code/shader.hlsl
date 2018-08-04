#define shader_template
#include "methods\albedo.hlsli"
#include "methods\bump_mapping.hlsli"
#include "methods\alpha_test.hlsli"
#include "methods\specular_mask.hlsli"
#include "methods\material_model.hlsli"
#include "methods\environment_mapping.hlsli"
#include "methods\self_illumination.hlsli"
#include "methods\blend_mode.hlsli"
#include "methods\parallax.hlsli"
#include "methods\misc.hlsli"

struct VS_OUTPUT
{
	float4 TexCoord : TEXCOORD;
	float4 TexCoord1 : TEXCOORD1;
	float4 TexCoord2 : TEXCOORD2;
	float4 TexCoord3 : TEXCOORD3;
};

struct PS_OUTPUT_ALBEDO
{
	float4 Diffuse;
	float4 Normal;
	float4 Unknown;
};

PS_OUTPUT_ALBEDO entry_albedo(VS_OUTPUT input) : COLOR
{
	float2 texcoord = input.TexCoord.xy;
	float2 texcoord_tiled = input.TexCoord.zw;
	float3 tangentspace_x = input.TexCoord3.xyz;
	float3 tangentspace_y = input.TexCoord2.xyz;
	float3 tangentspace_z = input.TexCoord1.xyz;
	float3 unknown = input.TexCoord1.w;

	float3 diffuse;
	float alpha;
	{
		float4 diffuse_alpha = calc_albedo_ps(texcoord);
		diffuse = diffuse_alpha.xyz;
		alpha = diffuse_alpha.w;
	}
	
	float3 normal = calc_bumpmap_ps(tangentspace_x, tangentspace_y, tangentspace_z, texcoord);

	PS_OUTPUT_ALBEDO output;
	output.Diffuse = blend_type(float4(diffuse, alpha));
	output.Normal = blend_type(float4(normal, alpha));
	output.Unknown = unknown.xxxx;
	return output;
}






