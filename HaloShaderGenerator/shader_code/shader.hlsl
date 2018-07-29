#include "methods/albedo.hlsli"

float4 main(float texCoord : TEXCOORD) : COLOR
{
	return calc_albedo_ps(texCoord);
}