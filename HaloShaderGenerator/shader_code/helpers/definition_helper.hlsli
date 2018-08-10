/*
This file contains a list of blank definitions to help with Intellisense
*/

#ifndef _DEFINITION_HELPER_HLSLI
#define _DEFINITION_HELPER_HLSLI

// Enums

#define k_shaderstage_default 0
#define k_shaderstage_albedo 1
#define k_shaderstage_static_default 2
#define k_shaderstage_static_per_pixel 3
#define k_shaderstage_static_per_vertex 4
#define k_shaderstage_static_sh 5
#define k_shaderstage_static_prt_ambient 6
#define k_shaderstage_static_prt_linear 7
#define k_shaderstage_static_prt_quadratic 8
#define k_shaderstage_dynamic_light 9
#define k_shaderstage_shadow_generate 10
#define k_shaderstage_shadow_apply 11
#define k_shaderstage_active_camo 12
#define k_shaderstage_lightmap_debug_mode 13
#define k_shaderstage_static_per_vertex_color 14
#define k_shaderstage_water_tesselation 15
#define k_shaderstage_water_shading 16
#define k_shaderstage_dynamic_light_cinematic 17
#define k_shaderstage_z_only 18
#define k_shaderstage_sfx_distort 19
#define k_shadertype_shader 0
#define k_shadertype_beam 1
#define k_shadertype_contrail 2
#define k_shadertype_decal 3
#define k_shadertype_halogram 4
#define k_shadertype_lightvolume 5
#define k_shadertype_particle 6
#define k_shadertype_terrain 7

// Method Enums

#define k_albedo_default 0
#define k_albedo_detail_blend 1
#define k_albedo_constant_color 2
#define k_albedo_two_change_color 3
#define k_albedo_four_change_color 4
#define k_albedo_three_detail_blend 5
#define k_albedo_two_detail_overlay 6
#define k_albedo_two_detail 7
#define k_albedo_color_mask 8
#define k_albedo_two_detail_black_point 9
#define k_albedo_two_change_color_anim_overlay 10
#define k_albedo_chameleon 11
#define k_albedo_two_change_color_chameleon 12
#define k_albedo_chameleon_masked 13
#define k_albedo_color_mask_hard_light 14
#define k_albedo_two_change_color_tex_overlay 15
#define k_albedo_chameleon_albedo_masked 16
#define k_bump_mapping_off 0
#define k_bump_mapping_standard 1
#define k_bump_mapping_detail 2
#define k_bump_mapping_detail_masked 3
#define k_bump_mapping_detail_plus_detail_masked 4
#define k_alpha_test_none 0
#define k_alpha_test_simple 1
#define k_specular_mask_no_specular_mask 0
#define k_specular_mask_specular_mask_from_diffuse 1
#define k_specular_mask_specular_mask_from_texture 2
#define k_specular_mask_specular_mask_from_color_texture 3
#define k_material_model_diffuse_only 0
#define k_material_model_cook_torrance 1
#define k_material_model_two_lobe_phong 2
#define k_material_model_foliage 3
#define k_material_model_none 4
#define k_material_model_glass 5
#define k_material_model_organism 6
#define k_material_model_single_lobe_phong 7
#define k_material_model_car_paint 8
#define k_material_model_hair 9
#define k_environment_mapping_none 0
#define k_environment_mapping_per_pixel 1
#define k_environment_mapping_dynamic 2
#define k_environment_mapping_from_flat_texture 3
#define k_environment_mapping_custom_map 4
#define k_self_illumination_off 0
#define k_self_illumination_simple 1
#define k_self_illumination__3_channel_self_illum 2
#define k_self_illumination_plasma 3
#define k_self_illumination_from_diffuse 4
#define k_self_illumination_illum_detail 5
#define k_self_illumination_meter 6
#define k_self_illumination_self_illum_times_diffuse 7
#define k_self_illumination_simple_with_alpha_mask 8
#define k_self_illumination_simple_four_change_color 9
#define k_self_illumination_illum_detail_world_space_four_cc 10
#define k_blend_mode_opaque 0
#define k_blend_mode_additive 1
#define k_blend_mode_multiply 2
#define k_blend_mode_alpha_blend 3
#define k_blend_mode_double_multiply 4
#define k_blend_mode_pre_multiplied_alpha 5
#define k_parallax_off 0
#define k_parallax_simple 1
#define k_parallax_interpolated 2
#define k_parallax_simple_detail 3
#define k_misc_first_person_never 0
#define k_misc_first_person_sometimes 1
#define k_misc_first_person_always 2
#define k_misc_first_person_never_with_rotating_bitmaps 3

// Methods

//NOTE: these are defined in the methods hlsl with a default
//#define calc_albedo_ps(texcoord)
//#define calc_bumpmap_ps()
//#define calc_bumpmap_vs()
//#define calc_alpha_test_ps()
//#define calc_specular_mask_ps()
//#define calc_self_illumination_ps()
//#define calc_parallax_ps()
//#define calc_parallax_vs()
//#define material_type()
//#define envmap_type()
//#define blend_type()

// Generics
#define shaderstage 0
#define shadertype 0

// Current Method Arguments

#define albedo_arg 0
#define self_illumination_arg 0
#define material_model_arg 0
#define envmap_type_arg 0
#define blend_type_arg 0

#endif
