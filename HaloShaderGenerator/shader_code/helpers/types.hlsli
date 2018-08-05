#ifndef _TYPES_HLSLI
#define _TYPES_HLSLI

#define xform2d float4

float2 apply_xform2d(float2 texcoord, xform2d xform)
{
    return texcoord * xform.xy + xform.zw;
}

#endif