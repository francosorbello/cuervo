shader_type canvas_item;

uniform sampler2D dissolve_texture : source_color;

void fragment(){
    vec4 main_texture = texture(TEXTURE, UV);
    float dissolve_value = mix(0.5, 0.6, sin(TIME));
    vec4 noise_texture = texture(dissolve_texture, UV+vec2(10.0*sin(TIME/5.0),10.0*cos(TIME/5.0))/5.0);
    float mult = floor(dissolve_value + min(1, noise_texture.x));
    main_texture.g *= mult;
    main_texture.r -= mult - 0.1;
    main_texture.g -= mult - 0.1;
    main_texture.b -= mult - 0.1;
    COLOR = main_texture;
}