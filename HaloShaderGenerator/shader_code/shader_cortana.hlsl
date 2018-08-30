#define shader_template

#include "registers/shader.hlsli"
#include "helpers/input_output.hlsli"

#include "methods/albedo.hlsli"
#include "helpers/color_processing.hlsli"

//TODO: These must be in the correct order for the registers to align, double check this
#include "methods\bump_mapping.hlsli"
#include "methods\alpha_test.hlsli"
#include "methods\specular_mask.hlsli"
#include "methods\material_model.hlsli"
#include "methods\environment_mapping.hlsli"
#include "methods\self_illumination.hlsli"
#include "methods\blend_mode.hlsli"
#include "methods\parallax.hlsli"
#include "methods\misc.hlsli"

PS_OUTPUT_DEFAULT entry_active_camo(VS_OUTPUT_ACTIVE_CAMO input) : COLOR
{
    //note: vpos is in range [0, viewportsize]
    // add a half pixel offset
    float2 vpos = input.vPos.xy;
    float2 screen_location = vpos + 0.5; // half pixel offset
    float2 texel_size = float2(1.0, 1.0) / texture_size.xy;
    float2 fragcoord = screen_location * texel_size; // converts to [0, 1] range

    // I'm not sure what is happening here with these three
    // but I think its a depth value, and this is a kind of
    // clamp of the effect at a distance
    float unknown0 = 0.5 - input.TexCoord1.w;
    float unknown1 = 1.0 / input.TexCoord1.w;
    float unknown2 = unknown0 >= 0 ? 2.0 : unknown1;

    // not sure where these values come from
    // however, the aspect ratio is 16:9 multiplied by 4
    float2 unknown3 = input.TexCoord.xy * k_ps_active_camo_factor.yz / float2(64, 36);

    float2 texcoord = unknown3 * unknown2 + fragcoord;

    float4 sample = tex2D(scene_ldr_texture, texcoord);
    float3 color = sample.xyz;

    color *= 0.00001;
    color += float3(fragcoord, 0.0);

    float alpha = k_ps_active_camo_factor.x;
    
    PS_OUTPUT_DEFAULT output;
    output.HighFrequency = export_high_frequency(float4(color, alpha));
    output.LowFrequency = export_low_frequency(float4(color, alpha));
    output.Unknown = float4(0, 0, 0, 0);
    return output;
}
