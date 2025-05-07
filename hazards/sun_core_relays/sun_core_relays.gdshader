shader_type canvas_item;
render_mode blend_add;

uniform float padding_left = 0.05;
uniform float padding_right = 0.05;
uniform float padding_top = 0.05;
uniform float padding_bottom = 0.05;
uniform float corner_radius = 0.05;

uniform float energy = 3.0;
uniform int roughness : hint_range(1, 10) = 3;
uniform int frequency = 10;

uniform float speed = 1.0;
uniform float thickness : hint_range(0.0, 0.1) = 0.006;
uniform float outline_thickness : hint_range(0.0, 0.1) = 0.03;
uniform float glow : hint_range(0.0, 3.0) = 0.0;
uniform float outline_glow : hint_range(0.0, 3.0) = 0.0;

uniform vec4 color : source_color = vec4(0.91, 1.0, 1.0, 1.0);
uniform vec4 outline_color : source_color = vec4(0.5, 1.0, 0.96, 1.0);
uniform float progress : hint_range(0.0, 1.0) = 1.0;

uniform vec2 noise_scale = vec2(1.0);

float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);
    float a = random(uv_index);
    float b = random(uv_index + vec2(1.0, 0.0));
    float c = random(uv_index + vec2(0.0, 1.0));
    float d = random(uv_index + vec2(1.0, 1.0));
    vec2 blur = smoothstep(0.0, 1.0, uv_fract);
    return mix(a, b, blur.x) + (c - a) * blur.y * (1.0 - blur.x) + (d - b) * blur.x * blur.y;
}

float fbm(float t, float time) {
    int octaves = roughness;
    float amp = 0.01 * energy * progress;
    float freq = float(frequency);
    float value = 0.0;
    for (int i = 0; i < octaves; i++) {
        value += amp * noise(vec2(t * freq, time * freq));
        amp *= 0.5;
        freq *= 2.0;
    }
    return value;
}

float sdRoundRect(vec2 p, vec2 b, float r) {
    vec2 q = abs(p) - b + vec2(r);
    return length(max(q,0.0)) + min(max(q.x,q.y),0.0) - r;
}

// Given uv in 0..1, map to rectangle
void compute_distance_and_progress(vec2 uv, out float distance, out float t) {
    float l = padding_left;
    float r = 1.0 - padding_right;
    float b = padding_bottom;
    float t_top = 1.0 - padding_top;

    vec2 rect_center = vec2((l + r) * 0.5, (b + t_top) * 0.5);
    vec2 half_size = vec2((r - l) * 0.5, (t_top - b) * 0.5);

    vec2 local = uv - rect_center;

    // Signed distance
    distance = sdRoundRect(local, half_size, corner_radius);

    // Compute progress along path
    float angle = atan(local.y, local.x);
    float norm_x = clamp((uv.x - l) / (r - l), 0.0, 1.0);
    float norm_y = clamp((uv.y - b) / (t_top - b), 0.0, 1.0);

    if (abs(local.y) >= half_size.y && abs(local.x) <= half_size.x) {
        // Top or bottom edge
        t = (uv.x - l) / (r - l);
        if (local.y < 0.0) t = 0.5 + (1.0 - t);
    }
    else if (abs(local.x) >= half_size.x && abs(local.y) <= half_size.y) {
        // Left or right edge
        t = (uv.y - b) / (t_top - b);
        if (local.x < 0.0) t = 0.75 + (1.0 - t);
        else t = 0.25 + t;
    }
    else {
        // Corner → estimate t using angle
        t = (angle + 3.14159265) / (2.0 * 3.14159265);
    }
}

vec4 compute_beam(float diff, float thickness2) {
    float beam = clamp(smoothstep(thickness2, thickness2 + 0.005 * progress, 1.0 - diff), 0.0, 1.0);
    float outline = thickness2 - outline_thickness;
    float beam_outline = clamp(smoothstep(outline, outline + 0.04, 1.0 - diff), 0.0, 1.0);
    beam_outline = clamp(beam_outline - beam, 0.0, 1.0);
    return (beam * (color + vec4(glow))) + (beam_outline * (outline_color + vec4(outline_glow)));
}

void fragment() {
    float distance_to_path;
    float progress_along_path;

    compute_distance_and_progress(UV, distance_to_path, progress_along_path);

    float n = fbm(progress_along_path, TIME * speed);
    float diff = abs(distance_to_path - n);

    float thickness2 = 1.0 - thickness;

    COLOR = compute_beam(diff, thickness2);
}
