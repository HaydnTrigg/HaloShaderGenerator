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

//#define hdr_gamma2 float4(1.0, 1.0, 1.0, 1.0)
//#define ldr_gamma2 float4(1.0, 1.0, 1.0, 1.0)
#define hdr_gamma2 true
#define ldr_gamma2 true

uniform sampler2D scanline_map;
uniform float4 scanline_map_xform;

#define sgt(src1, src2) ((src1) > (src2)) ? 1.0f : 0.0f;

PS_OUTPUT_DEFAULT entry_active_camo(VS_OUTPUT_ACTIVE_CAMO input) : COLOR
{
    //note: vpos is in range [0, viewportsize]
    // add a half pixel offset
    float2 vpos = input.vPos.xy;
    float2 screen_location = vpos + 0.5; // half pixel offset
    float2 texel_size = float2(1.0, 1.0) / texture_size.xy;
    float2 fragcoord = screen_location * texel_size; // converts to [0, 1] range


    //// I'm not sure what is happening here with these three
    //// but I think its a depth value, and this is a kind of
    //// clamp of the effect at a distance
    //float unknown0 = 0.5 - input.TexCoord1.w;
    //float unknown1 = 1.0 / input.TexCoord1.w;
    //float unknown2 = unknown0 >= 0 ? 2.0 : unknown1;

    //// not sure where these values come from
    //// however, the aspect ratio is 16:9 multiplied by 4
    //float2 unknown3 = input.TexCoord.xy * k_ps_active_camo_factor.yz / float2(64, 36);

    //float2 texcoord = unknown3 * unknown2 + fragcoord;

    //float4 sample = tex2D(scene_ldr_texture, fragcoord);
    //float3 color = sample.xyz;

    //color += albedo_color.xyz * 0.00001;
    ////color *= 0.00001;

    //float4 basemapsample = tex2D(base_map, apply_xform2d(input.TexCoord1.xy, base_map_xform));
    //color += basemapsample.xyz;
    ////color += input.TexCoord1.xyz;

    ////color += float3(input.TexCoord.xy,0);

    //float alpha = k_ps_active_camo_factor.x;

    float3 color = float3(1.0, 1.0, 1.0);
    float alpha = 1.0;


    float3 c16 = Camera_Position_PS;
    bool b15 = hdr_gamma2;
    bool b14 = ldr_gamma2;
    float4 c236 = albedo_blend;
    float4 c98 = albedo_color;
    float4 c238 = analytical_anti_shadow_control;
    float4 c103 = analytical_specular_contribution;
    float4 c102 = area_specular_contribution;
    sampler2D s0 = base_map;
    float4 c99 = base_map_xform;
    sampler2D s2 = bump_map;
    float4 c235 = bump_map_xform;
    //float4 c245 = depth_darken;
    //float4 c246 = detail_color;
    sampler s1 = detail_map;
    float4 c234 = detail_map_xform;
    float4 c100 = diffuse_coefficient;
    float4 c15 = dynamic_environment_blend;
    samplerCUBE s6 = dynamic_environment_map_0;
    samplerCUBE s7 = dynamic_environment_map_1;
    float4 c240 = env_roughness_scale;
    float4 c239 = env_tint_color;
    float4 c104 = environment_map_specular_contribution;
    //sampler s9 = fade_gradient_map;
    //float4 c252 = fade_gradient_map_xform;
    //float4 c253 = fade_gradient_scale;
    float3 c106 = fresnel_color;
    float4 c12 = g_alt_exposure;
    float4 c0 = g_exposure;
    sampler2D s4 = g_sampler_cc0236;
    sampler2D s5 = g_sampler_dd0236;
    //float4 c233 = k_ps_distort_bounds;
    float4 c11 = k_ps_dominant_light_direction;
    float4 c13 = k_ps_dominant_light_intensity;
    //float4 c243 = layer_contrast;
    //int i1 = layer_count;
    //float4 c241 = layer_count;
    //float4 c242 = layer_depth;
    sampler2D s3 = material_texture;
    float4 c105 = material_texture_xform;
    float4 c1 = p_lighting_constant_0;
    float4 c2 = p_lighting_constant_1;
    float4 c3 = p_lighting_constant_2;
    float4 c4 = p_lighting_constant_3;
    float4 c5 = p_lighting_constant_4;
    float4 c6 = p_lighting_constant_5;
    float4 c7 = p_lighting_constant_6;
    float4 c8 = p_lighting_constant_7;
    float4 c9 = p_lighting_constant_8;
    float4 c10 = p_lighting_constant_9;
    float4 c107 = roughness;
    //float4 c248 = scanline_amount_opaque;
    //float4 c249 = scanline_amount_transparent;
    //sampler2D s8 = scanline_map;
    //float4 c247 = scanline_map_xform;
    sampler2D s10 = scene_ldr_texture;
    //int i0 = simple_light_count_int;
    // SIMPLE LIGHTS HERE
    float4 c101 = specular_coefficient;
    float3 c237 = specular_tint;
    //float2 c244 = texcoord_aspect_ratio;
    float2 c14 = texture_size;
    bool b1 = use_material_texture;
    //float4 c251 = warp_amount;
    //float4 c250 = warp_fade_offset;
    
    float4 r0 = float4(0, 0, 0, 0);
    float4 r1 = float4(0, 0, 0, 0);
    float4 r2 = float4(0, 0, 0, 0);
    float4 r3 = float4(0, 0, 0, 0);
    float4 r4 = float4(0, 0, 0, 0);
    float4 r5 = float4(0, 0, 0, 0);
    float4 r6 = float4(0, 0, 0, 0);
    float4 r7 = float4(0, 0, 0, 0);
    float4 r8 = float4(0, 0, 0, 0);
    float4 r9 = float4(0, 0, 0, 0);
    float4 r10 = float4(0, 0, 0, 0);
    float4 r11 = float4(0, 0, 0, 0);
    float4 r12 = float4(0, 0, 0, 0);
    float4 r13 = float4(0, 0, 0, 0);
    float4 r14 = float4(0, 0, 0, 0);
    float4 r15 = float4(0, 0, 0, 0);
    float4 r16 = float4(0, 0, 0, 0);
    float4 r17 = float4(0, 0, 0, 0);
    float4 r18 = float4(0, 0, 0, 0);
    float4 r19 = float4(0, 0, 0, 0);
    float4 r20 = float4(0, 0, 0, 0);
    float4 r21 = float4(0, 0, 0, 0);
    float4 r22 = float4(0, 0, 0, 0);
    float4 r23 = float4(0, 0, 0, 0);
    
    // Fill these with data
    float4 c231 = float4(0, 0, 0, 0);


//    exec
//    mad r6.zw, r0.yyyx, c235.yyyx, c235.wwwz
//    mad r9.zw, r9_abs.yyyx, c247.yyyx, c247.wwwz
//    mad r10.xy, r0.yx, c99.yx, c99.wz
//    tfetch2D r10, r10.yx, tf0, FetchValidOnly=false
//    tfetch2D r11, r9.wz, tf8, FetchValidOnly=false
//    tfetch2D r14._xy_, r6.wz, tf2, FetchValidOnly=false

    float2 texcoord = input.TexCoord1.xy;
    float4 base_map_sample = tex2D(base_map, apply_xform2d(texcoord, base_map_xform));
    float4 bump_map_sample = tex2D(bump_map, apply_xform2d(texcoord, bump_map_xform));
    float4 scanline_map_sample = tex2D(scanline_map, apply_xform2d(texcoord, scanline_map_xform));
    float4 detail_map_sample = tex2D(detail_map, apply_xform2d(texcoord, detail_map_xform));
    
    r10 = base_map_sample;
    r11 = scanline_map_sample;
    r14 = bump_map_sample;

    color += base_map_sample.x;
    color -= bump_map_sample.x;
    color += scanline_map_sample.x;
    color -= detail_map_sample.x;
    color += albedo_color;
    color *= 0.00001;

    float4 scene_ldr_texture_sample = tex2D(scene_ldr_texture, fragcoord);

    color += scene_ldr_texture_sample.rgb;
    color += base_map_sample.rgb + albedo_color.rgb * detail_map_sample.rgb;
    alpha = base_map_sample.a * albedo_color.a;



//    exec
//    serialize
//    mad r9.zw, r0.xxxy, c234.xxxy, c234.zzzw
    
    
    r12.yzw = sgt(-abs(texcoord.x), c231.z);
    r2.w = c231.z;
    r13 = sgt(-abs(texcoord.x), c231.z);

//    sgt r12.yzw, -r0_abs.x, c231.z
//  + movs r2.w, c231.z
//    sgt r13, -r0_abs.x, c231.z
//  + movs r0._, c244.x
//    dp3 r0.z, r4.zxy, r4.zxy
//  + muls_prev r7.w, c234.x
//    add r3.w, c248.x, -c249.x
//  + rsq r4.w, r0_abs.z
//    dp2add r0.z, r14.yz, r14.yz, c231.z
//    exec
//    add r11, r11, -c231.x
//  + addsc r1.w, c231.x, r0.z
//    mul r10, r10.xwyz, c98.xwyz
//  + movs r6.z, r0.z
//    mul r21.xyz, r4.w, r4.xyz
//  + movs r6.w, c231.x
//    mad r3.w, r10.y, r3.w, c249.x
//    mad r12.x, r11.w, r3.w, c231.x
//    dp3 r4.w, r21.zxy, r3.zxy
//  + mins r0.z, r6.zw
//    exec
//    mad r11.xyz, r11.xyz, r3.w, c231.x
//    add r1.w, r1.w, -r0.z
//  + subsc r3.w, c231.x, r0.z
//    dp3 r0.z, r21.zxy, r2.zxy
//  + rsq r1.w, r1_abs.w
//    mul r11.xyz, r10.xzw, r11.xyz
//  + mulsc r6.w, c234.y, r0.z
//    mul r6.z, r7.w, r4.w
//  + sqrt r14.x, r3_abs.w
//    mul r15.xyz, r1.w, r14.xzy
//  + mulsc r14.x, c242.x, r6.z
//    exec
//    mul r1.xyz, r15.x, r1.xyz
//  + mulsc r14.y, c242.x, r6.w
//    mad r1.xyz, r15.y, r2.xyz, r1.xyz
//    mad r1.yzw, r15.z, r3.xxyz, r1.xxyz
//    dp3 r1.x, r1.wyz, r1.wyz
//  + rcp r10.x, c241.x
//    mul r2.xy, r14.xy, r10.x
//  + rsq r1.x, r1_abs.x
//    mul r1.xyz, r1.yzw, r1.x
//  + movs r1.w, c231.x
//    loop i17, L8
//label L6
//    exec
//    movs r0.z, r1.w
//    tfetch2D r3, r9.zw, tf1, FetchValidOnly=false
//    serialize
//    add r9.zw, -r2.xxxy, r9.zzzw
//  + mulsc r1.w, c245.x, r0.z
//    mad r13, r3.wxyz, r0.z, r13
//    mov r12.yzw, r13.wwzy
//  + movs r2.w, r13.x
//    endloop i17, L6
//label L8
//    exec
//    mul r14.x, r10.x, r2.w
//  + movs r3.w, c107.x
//    mul r16.x, c10.w, c225.y
//  + movs r3.x, c104.x
//    mul r16.y, c8.w, c225.y
//  + movs r3.z, c236.x
//    dp3 r2.x, r1.zxy, r1.zxy
//  + movs r3.y, c101.x
//    mul r15, r10.yx, r12.xwzy
//  + rsq r0.z, r2_abs.x
//    mul r12.xyz, r1.xyz, r0.z
//  + subsc r4.w, c231.x, r10.y
//    exec
//    dp3 r17.z, r12.zxy, c2.zxy
//  + log r1.y, r15_abs.y
//    dp3 r17.x, r12.zxy, c3.zxy
//  + log r1.z, r15_abs.z
//    dp3 r17.y, r12.zxy, c4.zxy
//  + log r1.w, r15_abs.w
//    dp3 r0.z, r21.zxy, r12.zxy
//  + muls r1.x, r2_abs.xx
//    mul r13.xyz, r12.xyz, r12.yzx
//  + muls r2.y, r1.xx
//    dp3 r2.x, r13.zxy, c5.zxy
//  + muls r10.x, r12.xx
//    exec
//    dp3 r2.z, r13.zxy, c7.zxy
//  + muls r10.y, r12.yy
//    dp3 r2.w, r13.zxy, c6.zxy
//  + muls r10.z, r12.zz
//    dp3 r16.z, r10.zxy, c10.zxy
//  + mulsc r7.w, c243.x, r1.y
//    dp3 r16.w, r10.zxy, c8.zxy
//  + mulsc r1.x, c243.x, r1.z
//    mul r13.xyz, r12.xyz, r0.z
//  + mulsc r1.w, c243.x, r1.w
//    cndeq r10, c231.zzzx, r10.zxy, c225.y
//    exec
//    dp4 r1.y, r10, c9.zxyw
//  + exp r14.y, r7.w
//    add r10.xyz, r13.xyz, -r21.xyz
//  + exp r14.z, r1.x
//    add r1.xz, r16.wz, r16.yx
//  + exp r14.w, r1.w
//    mad r10.yzw, r10.xxyz, c228.x, r21.xxyz
//    mul r14, r14, c246.wxyz
//  + muls r1.w, r2.yy
//    mad r2.y, r14.x, r4.w, r15.x
//    exec
//    mad r14.xyz, r14.yzw, r4.w, r11.xyz
//    dp3 r4.w, r10.wyz, r10.wyz
//  + mulsc r10.x, c13.x, r1.w
//    mul r1.xyz, r1.xyz, c228.y
//  + rsq r4.w, r4_abs.w
//    mul r11.xyz, r10.yzw, r4.w
//  + mulsc r10.y, c13.y, r1.w
//    mad r1.xyz, r2.zwx, c224.x, -r1.zyx
//    mad r1.xyz, r17.xyz, c227.x, r1.yxz
//    exec
//    mad r1.xyz, c1.zyx, c227.y, r1.yxz
//    mul r2.xzw, r1.zyyx, c225.z
//  + mulsc r10.z, c13.z, r1.w
//    cjmp !b129, L16
//    exec
//    mad r1.xy, r0.yx, c105.yx, c105.wz
//    tfetch2D r3.zxyw, r1.yx, tf3, FetchValidOnly=false
//    serialize
//    nop
//label L16
//    exec    // PredicateClean=false
//    dp3 r1.x, r12.zxy, c11.zxy
//  + subsc r1.y, c231.x, r3.z
//    mul r1.yzw, r1.y, c106.xxyz
//    mad r18.xyz, r14.xyz, r3.z, r1.yzw
//    min r1.x, r1.x, r0.z
//    setp_gt r0._, r1.x
//    (p0) add r15.xyz, r21.xyz, c11.xyz
//  + (p0) movs r1.y, r3.w
//(p0) exec
//    (p0) dp3 r1.w, r15.zxy, r15.zxy
//  + (p0) movs r1.z, c224.y
//    (p0) min r16.xyz, r18.xyz, c226.w
//  + (p0) rsq r1.w, r1_abs.w
//    (p0) mul r15.xyz, r15.xyz, r1.w
//  + (p0) maxs r19.y, r1.yz
//    (p0) dp3 r1.y, r12.zxy, r15.zxy
//  + (p0) sqrt r23.x, r16_abs.x
//    (p0) dp3 r19.z, r21.zxy, r15.zxy
//  + (p0) muls r23.w, r1.yy
//    (p0) mul r15.xy, r19.yz, r19.yz
//  + (p0) sqrt r23.y, r16_abs.y
//(p0) exec
//    (p0) mul r1.z, r15.x, r23.w
//  + (p0) sqrt r23.z, r16_abs.z
//    (p0) add r22.xyz, -r23.xyz, c231.x
//  + (p0) rcp r16.x, r1.z
//    (p0) rcp r16.y, r22.x
//    (p0) add r1.w, r5.w, c231.x
//  + (p0) rcp r16.z, r22.y
//    (p0) add r20, r23, c231.xxxy
//  + (p0) rcp r16.w, r22.z
//    (p0) mul r22, r20.wxyz, r16
//(p0) exec
//    (p0) mad r15.xyz, r22.yzw, r22.yzw, r15.y
//    (p0) add r15.xyz, r15.xyz, c231.y
//    (p0) mul r20.x, r0.z, c229.w
//  + (p0) sqrt r16.x, r15_abs.x
//    (p0) mul r23.x, r1.z, r23.w
//  + (p0) sqrt r16.y, r15_abs.y
//    (p0) mul r1.z, r22.x, c225.x
//  + (p0) sqrt r16.z, r15_abs.z
//    (p0) add r15.yzw, -r19.z, r16.xxyz
//(p0) exec
//    (p0) add r16.xyz, r19.z, r16.xyz
//    (p0) mad r22.yzw, r19.z, r16.xxyz, c231.y
//    (p0) mul r23.yzw, r19.z, r15.yyzw
//    (p0) add r23, r23, c231.wx
//  + (p0) exp r22.x, r1.z
//    (p0) add r1.y, r1.y, r1.y
//  + (p0) rcp r19.x, r23.x
//    (p0) mov_sat r16.w, r19.z
//  + (p0) rcp r19.y, r23.y
//(p0) exec
//    (p0) mul r20.yzw, r16.xxyz, r16.xxyz
//  + (p0) rcp r19.z, r23.z
//    (p0) add r20, r20, c231.w
//  + (p0) rcp r19.w, r23.w
//    (p0) mul r22, r22, r19
//    (p0) mul r16.xyz, r22.yzw, r22.yzw
//    (p0) add r16, r16, c231.xxxw
//  + (p0) rcp r15.x, r20.x
//    (p0) mul r19.yzw, r15.yyzw, r15.yyzw
//  + (p0) rcp r1.z, r16.w
//(p0) exec
//    (p0) mul r1.x, r1.x, r1.z
//  + (p0) rcp r15.y, r20.y
//    (p0) mul_sat r1.x, r1.x, r1.y
//  + (p0) rcp r15.z, r20.z
//    (p0) mul r19.x, r22.x, r1.x
//  + (p0) rcp r15.w, r20.w
//    (p0) mul r15, r19, r15
//    (p0) mul r1.xyz, r15.yzw, c229.x
//    (p0) mul r1.xyz, r1.xyz, r16.xyz
//    exec    // PredicateClean=false
//    (p0) mul r1.xyz, r15.x, r1.xyz
//    (p0) min r1.xyz, r1.w, r1.xyz
//    (p0) mul r1.yzw, r10.xxyz, r1.xxyz
//    (!p0) mov r1.yzw, c231.w
//    setp_gt r0._, c238.x
//(!p0) jmp L28
//    exec
//    mad r15.w, -r10.y, c227.w, c1.y
//    mul r10.xzw, c11.yzzx, c226.x
//    dp3 r0.z, c3.zxy, c3.zxy
//    mad r0.z, c1.y, c1.y, r0.z
//    mad r15.xyz, -r10.wxz, r10.y, c3.xyz
//    dp4 r1.x, r15.zxyw, r15.zxyw
//  + rcp r0.z, r0.z
//    exec
//    mul r0.z, r1.x, r0.z
//    min r0.z, r0.z, c231.x
//    subsc r1.x, c231.x, r0.z
//    mul r3.z, c238.x, c227.z
//  + log r1.x, r1_abs.x
//    mul r1.x, r3.z, r1.x
//    exp r1.x, r1.x
//    exec
//    mul r1.yzw, r1.x, r1.yyzw
//label L28
//    exec
//    sgt r15, -r0_abs.x, c231.z
//    log r1.x, c107_abs.x
//    sgt r10, -r0_abs.x, c231.z
//  + mulsc r0.z, c229.z, r1.x
//    add r19.xyz, -r4.xyz, c16.xyz
//  + exp r1.x, r0.z
//    sgt r16.xyz, -r0_abs.x, c231.z
//  + mulsc r0.z, c224.z, r1.x
//    loop i16, L35
//label L30
//    exec    // PredicateClean=false
//    add r4.xyz, -r19.xyz, c[18+aL].xyz
//  + movs r20.z, r10.w
//    dp3 r1.x, r4.zxy, r4.zxy
//  + movs r20.y, r16.y
//    sge r3.z, r1.x, c[22+aL].x
//  + movs r20.x, r16.z
//    mov r16.yz, r15.wwz
//  + setp_eq r0._, r3.z
//    (p0) add r3.z, r1.x, c[18+aL].w
//  + (p0) rsq r1.x, r1_abs.x
//    (p0) mul r4.xyw, r4.xyz, r1.x
//(p0) exec
//    (p0) dp3 r1.x, r12.zxy, r4.wxy
//    (p0) dp3 r4.z, r4.wxy, r11.zxy
//    (p0) dp3 r4.y, r4.wxy, c[19+aL].zxy
//  + (p0) rcp r4.x, r3.z
//    (p0) mad r4.xy, r4.xy, c[21+aL].xy, c[21+aL].zw
//    (p0) max r4.xzw, r4.xyyz, c231.z
//    (p0) max r15.y, r1.x, c224.y
//  + (p0) log r1.x, r4_abs.z
//(p0) exec
//    (p0) mul r3.z, r1.x, c[20+aL].w
//  + (p0) log r1.x, r4_abs.w
//    (p0) mul r1.x, r0.z, r1.x
//  + (p0) exp r3.z, r3.z
//    (p0) add r15.x, r3.z, c[19+aL].w
//    (p0) mul r4.y, r15.x, r4.x
//    (p0) mul r10.xyz, r4.xy, c[20+aL].zxy
//  + (p0) exp r15.z, r1.x
//    (p0) mul r4.zw, r10.yyyz, r15.z
//    exec
//    (p0) mul r10.xyz, r10.xzy, r15.xy
//    (p0) mul r4.xy, r10.x, r15.zy
//    (p0) add r16.xy, r10.zy, r16.xy
//  + (p0) movs r0._, r4.y
//    (p0) add r20.xyz, r4.zwx, r20.xyz
//  + (p0) adds_prev r16.z, r16.z
//    mov r15, r16.zyzy
//  + movs r16.y, r20.y
//    mov r10, r20.zyxz
//  + movs r16.z, r20.x
//    endloop i16, L30
//label L35
//    exec
//    add r4.xyw, r21.xyz, -r13.xyz
//    dp3 r1.x, r11.zxy, c11.zxy
//    max r3.z, r1.x, c231.z
//    dp3 r1.x, r4.wxy, r4.wxy
//    mul r4.z, r3.z, c228.z
//  + rsq r1.x, r1_abs.x
//    mul r22.xyz, r4.xyw, r1.x
//  + movs r4.y, r3.w
//    exec
//    dp3 r4.x, r21.zxy, r22.zxy
//  + movs r4.w, c224.y
//    add r4.xz, r4.xz, c230.xy
//  + maxs r4.y, r4.yw
//    tfetch2D r19.xyz_, r4.xy, tf5, FetchValidOnly=false
//    tfetch2D r20.xyz_, r4.xy, tf4, FetchValidOnly=false
//    serialize
//    add r12.yzw, -r18.xxyz, c231.x
//  + movs r3.z, c100.x
//    mul r10.xyz, r0.z, r10.zyx
//  + movs r16.z, r15.x
//    exec
//    mad r13.xyz, r10.xyz, r18.xyz, r1.yzw
//    dp3 r1.x, r22.zxy, c3.zxy
//  + movs r16.y, r15.y
//    dp3 r1.y, r22.zxy, c2.zxy
//  + movs r0._, r2.y
//    dp3 r1.z, r22.zxy, c4.zxy
//  + muls_prev r0.z, r3.x
//    mul r10.xyz, r1.xyz, r4.z
//  + movs r0._, r2.y
//    mul r1.xyz, -r17.xyz, r4.z
//  + muls_prev r1.w, r3.y
//    exec
//    mul r4.xyz, r1.yxz, r20.y
//  + movs r0._, r0.z
//    mul r1.xyz, r1.yxz, r19.y
//  + muls_prev r3.x, r3.y
//    mad r1.xyz, r19.x, c1.zyx, r1.xyz
//    mad r4.xyz, r20.x, c1.zyx, r4.xyz
//    mad r4.xyz, r10.yzx, r20.z, r4.zxy
//    mad r1.xyz, r10.xyz, r19.z, r1.yzx
//    exec
//    mul r1.xyz, r1.yxz, c226.z
//  + mulsc r12.x, c237.x, r1.w
//    mul r1.xyz, r1.yxz, r12.zyw
//  + mulsc r12.y, c237.y, r1.w
//    mad r4.xyz, r18.zyx, r4.yzx, r1.zxy
//    mul r1.xyz, r4.yxz, r5.z
//  + mulsc r12.z, c237.z, r1.w
//    max r4.xyw, r4.yzx, c231.z
//  + mulsc r4.z, c237.z, r1.y
//    mul r10.xyz, r4.wyx, c102.x
//  + mulsc r4.x, c237.x, r1.z
//    exec
//    mad r10.xyz, r13.xzy, c103.x, r10.yxz
//    mul r10.xyz, r12.xyz, r10.xzy
//  + mulsc r4.y, c237.y, r1.x
//    cjmp !b129, L43
//    exec
//    subsc r3.z, c231.x, r3.y
//label L43
//    exec
//    mad r0.xy, r0.yx, c252.yx, c252.wz
//    mov r6.z, r6.x
//  + mulsc r0.z, c240.x, r3.w
//    max r4.w, r0.w, c229.x
//  + mulsc r0.z, c228.w, r0.z
//    max r0.z, r0.z, c231.z
//  + movs r11.y, -r11.y
//    cube r1, r11.zzxy, r11.yxz
//    mov r11.z, r1.w
//  + rcp r3.y, r1_abs.z
//    exec
//    mad r11.xy, r1.yx, r3.y, c229.y
//    setTexLOD r0.z
//    tfetchCube r12, r11.xyz, tf6, FetchValidOnly=false, UseComputedLOD=false, UseRegisterLOD=true
//    tfetchCube r11, r11.xyz, tf7, FetchValidOnly=false, UseComputedLOD=false, UseRegisterLOD=true
//    tfetch2D r0._w__, r0.yx, tf9, FetchValidOnly=false
//    serialize
//    add r1.yzw, -c15.xxyz, c231.x
//    exec
//    max r4.xyz, r4.xyz, c226.y
//    mad r2.xzw, r2.xzzw, r5.x, r16.xyyz
//    mul r5.xyw, r11.xyz, r11.w
//  + mulsc r11.x, c253.x, r0.y
//    mul r0.xyz, r12.xyz, r12.w
//  + mulsc r1.x, c251.x, r6.z
//    mul r11.yzw, r5.xxyw, c225.w
//  + mulsc r5.x, c225.w, r0.x
//    mul r2.xzw, r2.xzzw, r3.z
//  + mulsc r5.y, c225.w, r0.y
//    exec
//    mul r1.yzw, r11.yyzw, r1.yyzw
//  + mulsc r5.w, c225.w, r0.z
//    mad r0.xyz, r5.xyw, c15.xyz, r1.yzw
//    mul r0.xyz, r3.x, r0.xyz
//  + mulsc r1.y, c251.x, r6.y
//    mul r0.xyz, r0.xyz, c239.xyz
//  + movs r0._, r9_abs.x
//    mul r0.xyz, r0.xyz, r4.xyz
//  + adds_prev r1.z, c229.x
//    mad r0.xyz, r2.xzw, r14.xyz, r0.xyz
//    exec
//    mad r0.xyz, r10.xyz, r5.z, r0.xyz
//    mul r11.yzw, r0.xxyz, r7.xxyz
//  + movs r0._, r9_abs.y
//    add r3, r11, r8.wxyz
//  + adds_prev r1.w, c229.x
//    add_sat r0.x, r3.x, c250.x
//  + rcp r0.z, c14.x
//    mul r0.xy, r1.xy, r0.x
//  + rcp r0.w, c14.y
//    mul r1.xy, r0.xy, c230.zw
//  + rcp r0.x, r4.w
//    exec
//    dp2add r0.y, r1.wy, r0.wx, c231.z
//    dp2add r0.x, r1.zx, r0.zx, c231.z
//    max r0.xy, r0.xy, c233.xy
//    min r0.xy, r0.yx, c233.wz
//    tfetch2D r1._xyz, r0.yx, tf10
//    serialize
//    dp2add r0.y, r3.z, c12.y, c231.z
//    exec
//    dp2add r0.z, r3.w, c12.y, c231.z
//    dp2add r0.x, r3.y, c12.y, c231.z
//    add_sat r0.w, -r3.x, c231.x
//  + subsc r1.x, c231.x, r2.y
//    add_sat r1.x, r1.x, r0.w
//    add r1.yzw, -r0.xxyz, r1.yyzw
//  + rcp r0.w, c0.y
//    mad r0.xyz, r1.yzw, r1.x, r0.xyz
//    exec
//    mul r1.xyz, r0.xyz, r0.w
//    cexec b142
//    sqrt r0.x, r0_abs.x
//    sqrt r0.y, r0_abs.y
//    sqrt r0.z, r0_abs.z
//    cexec b143
//    sqrt r1.x, r1_abs.x
//    sqrt r1.y, r1_abs.y
//    sqrt r1.z, r1_abs.z
//    alloc colors
//    exece
//    mov r0.w, c0.w
//  + movs r1.w, c0.z
//    mov o0, r0
//    mov o1, r1

























    
    PS_OUTPUT_DEFAULT output;
    output.HighFrequency = export_high_frequency(float4(color, alpha));
    output.LowFrequency = export_low_frequency(float4(color, alpha));
    output.Unknown = float4(0, 0, 0, 0);
    return output;
}
