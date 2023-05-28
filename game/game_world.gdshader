shader_type canvas_item;

uniform float grain_amount : hint_range(0.0, 1.0);
uniform float scanline_amount : hint_range(0.0, 1.0);
uniform float scanline_speed : hint_range(0.0, 5.0);
uniform float greyness : hint_range(0.0, 1.0) = 0.0; // new greyness uniform
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec2 resolution = vec2(384,384);

float hash(vec2 position) {
    vec2 p = fract(position * vec2(5.3983, 5.4427));
    p += dot(p, p + 158.0);
    return fract((p.x + p.y) * p.x);
}

void fragment() {
    vec4 tex = texture(SCREEN_TEXTURE, SCREEN_UV);
    float grain = hash(SCREEN_UV + TIME) * grain_amount;

    // add scanlines
    float scanlines = sin(SCREEN_UV.y * resolution.y * scanline_speed + TIME) * scanline_amount;
    
    COLOR = tex + vec4(grain, grain, grain, 1.0) + vec4(scanlines, scanlines, scanlines, 1.0);

    // apply greyness
    float grey = dot(COLOR.rgb, vec3(0.299, 0.587, 0.114)); // calculates the luminance
    COLOR.rgb = mix(COLOR.rgb, vec3(grey), greyness); // mixes the color with the greyscale version
}
