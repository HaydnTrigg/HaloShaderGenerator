#ifndef _MATH_HLSLI
#define _MATH_HLSLI

#define RAND_COEFFICIENTS float3(12.9898, 78.233, 4.1414)

float rand3(float3 value) {
	return frac(sin(dot(value.xyz, RAND_COEFFICIENTS)) * 43758.5453);
}

float rand2(float2 value) {
	return rand3(float3(value, 0));
}

float rand1(float value) {
	return rand2(float2(value, 0));
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

float4 debug_color(int index) {
	float r = rand1(index * 100);
	float g = rand1(index * 100 + 1);
	float b = rand1(index * 100 + 2);
	float3 color = float3(r, g, b);
	float maximum = max_component3(color);
	color /= maximum;
	return float4(color, 1.0);
}

#endif
