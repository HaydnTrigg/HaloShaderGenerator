#ifndef param_fade
float fade = 1.0;
#endif

float4 opaque(float4 input)
{
	return float4(input.xyz, 1.0);
}

float4 additive(float4 input)
{
	return input;
}

float4 multiply(float4 input)
{
	// Need to double check
	float3 xyz = (input.xyz - 1.0) * fade.x + 1.0;
	return float4(xyz, input.w);
}

float4 alpha_blend(float4 input)
{
	float alpha = input.w * fade.x;
	return float4(input.xyz, alpha);
}

float4 double_multiply(float4 input)
{
	// Need to double check
	float alpha = input.w * fade.x;
	float3 xyz = (input.xyz - 0.5) * alpha + 0.5;
	return float4(xyz, alpha);
}

float4 pre_multiplied_alpha(float4 input)
{
	float alpha = input.w * fade.x;
	// Need to check fade.x implementation
	return float4(input.xyz, alpha) * alpha;
}

float4 maximum(float4 input)
{
	return input; // Not implemented
}

float4 multiply_add(float4 input)
{
	return input; // Not implemented
}

float4 add_src_times_dstalpha(float4 input)
{
	// Need to double check
	return input;
}

float4 add_src_times_srcalpha(float4 input)
{
	// Need to double check
	return input;
}

float4 inv_alpha_blend(float4 input)
{
	// Need to check fade.x implementation
	return input; // Not implemented
}

#ifndef blend_type
#define blend_type opaque
#endif