#include <helpers\math.hlsli>

float4 calc_alpha_test_off_ps(float4 input)
{
	return input;
}

float4 calc_alpha_test_on_ps(float4 input)
{
	return input; //TODO
}

#ifndef calc_alpha_test_ps
#define calc_alpha_test_ps calc_alpha_test_off_ps
#endif
