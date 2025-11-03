shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 0.85, 0.3, 1.0); // dourado suave
uniform float blur_strength : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec2 uv = UV * 2.0 - 1.0;
    float dist = length(uv);
    float glow = smoothstep(0.8 + blur_strength, 0.0, dist);
    COLOR = glow_color * glow * 0.8;
}
