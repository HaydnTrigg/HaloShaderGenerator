#ifndef _MATH_HLSLI
#define _MATH_HLSLI

#define RAND_COEFFICIENTS float3(12.9898, 78.233, 4.1414)

float rand2(float2 co)
{
	float a = 12.9898;
	float b = 78.233;
	float c = 43758.5453;
	float dt = dot(co.xy, float2(a, b));
	float sn = fmod(dt, 3.14);
	return frac(sin(sn) * c);
}

float rand3(float3 value) {
	float a = rand2(value.xy);
	float b = rand2(value.yz);
	float c = rand2(float2(a, b));

	return c;
}

float rand1(float value) {
	return rand2(float2(value, 0));
}

float4 random_debug_color(int index)
{
	float r = rand2(float2(sin(float(index)), cos(float(index))));
	float g = rand2(float2(sin(float(index) - 0.25), cos(float(index) + 0.333)));
	float b = rand2(float2(sin(float(index) - 0.5), cos(float(index) + 0.666)));
	return float4(r, g, b, 1.0);
}

float rand_1_05(in float2 uv)
{
	float2 noise = (frac(sin(dot(uv, float2(12.9898, 78.233)*2.0)) * 43758.5453));
	return abs(noise.x + noise.y) * 0.5;
}

float max_component2(float2 v) {
	return max(v.x, v.y);
}

float max_component3(float3 v) {
	return max(max(v.x, v.y), v.z);
}

float max_component3(float4 v) {
	return max(max(v.x, v.y), max(v.z, v.w));
}

float3 normal_export(float3 normal)
{
    return normal * 0.5 + 0.5;
}

#endif
