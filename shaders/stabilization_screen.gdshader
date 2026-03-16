shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;
uniform float intensity : hint_range(0.0,1.0) = 0.0;
uniform float time_scale = 5.0;

void fragment() {
	vec2 uv = SCREEN_UV;

	float wave = sin((uv.y + TIME * time_scale) * 20.0) * 0.01 * intensity;
	uv.x += wave;

	vec4 color = texture(SCREEN_TEXTURE, uv);

	float vignette = smoothstep(0.8, 0.3, distance(uv, vec2(0.5)));
	color.rgb *= mix(1.0, vignette, intensity);

	COLOR = color;
}