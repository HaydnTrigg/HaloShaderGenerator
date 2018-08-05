#ifndef _SHADER_HLSLI
#define _SHADER_HLSLI

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

#endif
