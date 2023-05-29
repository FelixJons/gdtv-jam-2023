shader_type canvas_item;

uniform float progress;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 uv = SCREEN_UV;
    float mask = 1.0 - abs(0.5 - uv.y);
    mask = smoothstep(0.0, 1.0, mask / progress);
    vec4 col = texture(SCREEN_TEXTURE, uv);
    COLOR = vec4(col.rgb, mask);
}
