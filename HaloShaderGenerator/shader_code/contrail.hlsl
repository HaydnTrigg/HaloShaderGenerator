#define contrail_template
#include "methods/albedo.hlsli"
#include "methods/blend_mode.hlsli"
#include "methods/black_point.hlsli"
#include "methods/fog.hlsli"

// not 100% sure if this is correct yet, it might be copypaste
struct VS_OUTPUT
{
	float4 TexCoord : TEXCOORD;
	float4 TexCoord1 : TEXCOORD1;
	float4 TexCoord2 : TEXCOORD2;
	float4 TexCoord3 : TEXCOORD3;
	float4 TexCoord4 : TEXCOORD4;
};

struct PS_OUTPUT
{
	float4 Color0 : COLOR0;
	float4 Color1 : COLOR1;
	float4 Unknown : COLOR2;
};

float4 entry_default(VS_OUTPUT input) : COLOR
{
	return _debug_color;
}