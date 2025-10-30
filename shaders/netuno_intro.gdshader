shader_type canvas_item;

uniform sampler2D gradient_tex;
uniform bool vertical = false;
uniform float glow_size : hint_range(0.0, 4.0) = 1.5;
uniform float glow_intensity : hint_range(0.0, 2.0) = 1.0;

void fragment() {
    // Base do texto
    vec4 base_color = texture(TEXTURE, UV);
    if (base_color.a < 0.01) discard;

    // Gradiente ao longo do texto inteiro
    vec2 uv_global = FRAGCOORD.xy / vec2(textureSize(TEXTURE, 0));
    float t = vertical ? uv_global.y : uv_global.x;
    vec4 grad_color = texture(gradient_tex, vec2(t, 0.5));

    // --- Glow real (amostra pixels vizinhos) ---
    float glow = 0.0;
    float samples = 8.0;
    float step = 0.004 * glow_size;

    for (float x = -samples; x <= samples; x++) {
        for (float y = -samples; y <= samples; y++) {
            vec4 s = texture(TEXTURE, UV + vec2(x, y) * step);
            glow += s.a;
        }
    }
    glow /= pow((samples * 2.0 + 1.0), 2.0);

    // mistura texto + brilho externo
    vec3 color = grad_color.rgb + grad_color.rgb * glow * glow_intensity;

    COLOR = vec4(color, base_color.a);
}
