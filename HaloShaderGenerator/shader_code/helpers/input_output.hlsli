#ifndef _INPUT_OUTPUT_HLSLI
#define _INPUT_OUTPUT_HLSLI

struct VS_OUTPUT_ALBEDO
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

struct VS_OUTPUT_ACTIVE_CAMO
{
    float4 vPos : VPOS;
    float4 TexCoord : TEXCOORD0;
    float4 TexCoord1 : TEXCOORD1;
};

struct PS_OUTPUT_DEFAULT
{
    float4 LowFrequency;
    float4 HighFrequency;
    float4 Unknown;
};

struct VS_OUTPUT_STATIC_PTR_AMBIENT
{
    // These are from VS_OUTPUT_ALBEDO
    float4 TexCoord : TEXCOORD;
    float4 TexCoord1 : TEXCOORD1;
    float4 TexCoord2 : TEXCOORD2;
    float4 TexCoord3 : TEXCOORD3;





    float4 vPos : VPOS;
    float4 TexCoord6 : TEXCOORD6;
    float4 TexCoord7 : TEXCOORD7;
    float4 Color : COLOR;
    float4 Color1 : COLOR1;
};

#endif