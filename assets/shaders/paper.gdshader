shader_type canvas_item;

uniform float amount = 0.03;

uniform vec4 tint_color : source_color = vec4(1.0);

void fragment() {
    // Noise-based UV distortion
    vec2 offset = vec2(
        sin(UV.y * 50.0) * amount,
        sin(UV.x * 50.0) * amount
    );

    vec4 col = texture(TEXTURE, UV + offset)  * tint_color;

    // Fake shadowing
    float shade = sin((UV.x + UV.y) * 40.0) * 0.05;

    COLOR = col - shade;
}
