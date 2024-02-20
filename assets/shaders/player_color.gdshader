shader_type canvas_item;
uniform vec4 replace_color : source_color = vec4(1.0);
uniform float threshold : hint_range(0, 1) = 0.0;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 color = texture(TEXTURE,UV);
	if(color.a > threshold) {
		COLOR = replace_color;
	} else {
		COLOR = color;
	}
		
}
