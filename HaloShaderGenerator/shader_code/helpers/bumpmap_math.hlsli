#ifndef _BUMPMAP_MATH_HLSLI
#define _BUMPMAP_MATH_HLSLI

float2 sample_bump_map_2d(sampler bump_map, float2 texcoord)
{
    float4 bump_map_sample = tex2D(bump_map, texcoord);

    float scale = 255.0 / 127.0;
    float offset = 128.0 / 127.0;

    return bump_map_sample.xy * scale - offset;
}

/**
* reconstructs the positive z component of a normal using the X and Y components
* @result z = 1.0 - sqrt(saturate(x^2 + y^2))
*/
float reconstruct_normal_z(float2 normal)
{
    float remainder = 1.0 - saturate(dot(normal, normal));
    float normal_z = sqrt(remainder);
    return normal_z;
}

/*
* reconstructs a normal from only the X and Y components
* @param normal the X and Y component of the normal
* @result (x, y, 1.0 - sqrt(x^2 + y^2))
*/
float3 reconstruct_normal(float2 normal)
{
    return float3(normal, reconstruct_normal_z(normal));
}

float3 sample_normal_2d(sampler bump_map, float2 texcoord)
{
    float2 bump_sample = sample_bump_map_2d(bump_map, texcoord);

    return reconstruct_normal(bump_sample);
}

float3 normal_transform(
	float3 tangentspace_x,
	float3 tangentspace_y,
	float3 tangentspace_z,
	float3 normal
)
{
    //TODO: normal may need to be pre normalized
    float3 surface_normal = tangentspace_x * normal.x + tangentspace_y * normal.y + tangentspace_z * normal.z;
    float3 result = normalize(surface_normal);

    return result;
}

#endif

