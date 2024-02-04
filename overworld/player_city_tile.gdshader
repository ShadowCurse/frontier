shader_type canvas_item;

uniform float side_width = 0.04;
uniform float border_inner_radius = 0.625;
uniform float border_outer_radius = 0.675;
uniform vec4 side_color = vec4(0.0, 0.0, 0.0, 0.5);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    float distance_to_center = length(vec2(UV.x, UV.y) - vec2(0.5, 0.5));
    if (
        // vertical bars
        // horizontal bars
        // inner circle
        ((UV.x < side_width) || ((1.0 - side_width) < UV.x)
        || (UV.y < side_width) || ((1.0 - side_width) < UV.y)
        || (border_inner_radius < distance_to_center))
        // outer circle
        && (distance_to_center < border_outer_radius)) {
        COLOR = side_color;
    } else {
        COLOR = vec4(0.0);
    }
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
