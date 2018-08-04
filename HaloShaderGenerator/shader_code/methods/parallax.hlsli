#include <helpers\math.hlsli>

void calc_parallax_off_ps()
{

}

void calc_parallax_simple_ps()
{

}

void calc_parallax_interpolated_ps()
{

}

void calc_parallax_simple_detail_ps()
{

}

void calc_parallax_off_vs()
{

}

void calc_parallax_simple_vs()
{

}

void calc_parallax_interpolated_vs()
{

}

// fixups
#define calc_parallax_simple_detail_vs calc_parallax_simple_vs

#ifndef calc_parallax_ps
#define calc_parallax_ps calc_parallax_off_ps
#endif
#ifndef calc_parallax_vs
#define calc_parallax_vs calc_parallax_off_vs
#endif
