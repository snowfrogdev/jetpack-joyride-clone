shader_type canvas_item;

// Uniforms
uniform vec2 iResolution;

// Define palette arrays
const vec3 HP[4] = vec3[4](
    vec3(0.85, 0.1, 0.0),
    vec3(0.9, 0.3, 0.1),
    vec3(0.9, 0.5, 0.2),
    vec3(0.9, 0.9, 0.3)
);

const vec3 PF[4] = vec3[4](
    vec3(0.65625, 0.0, 0.68359375),
    vec3(0.8515625, 0.19921875, 0.703125),
    vec3(1.0, 0.59765625, 0.8359375),
    vec3(0.9375, 0.859375, 0.83203125)
);

vec3 n_rand3(vec3 p) {
    vec3 r = fract(sin(vec3(
        dot(p, vec3(127.1,311.7,371.8)),
        dot(p, vec3(269.5,183.3,456.1)),
        dot(p, vec3(352.5,207.3,198.67))
    )) * 43758.5453) * 2.0 - 1.0;
    return normalize(vec3(r.x/cos(r.x), r.y/cos(r.y), r.z/cos(r.z)));
}

float noise(vec3 p) {
    vec3 fv = fract(p);
    vec3 nv = floor(p);
    vec3 u = fv*fv*fv*(fv*(fv*6.0-15.0)+10.0);

    return mix(
        mix(
            mix(dot(n_rand3(nv + vec3(0.0,0.0,0.0)), fv - vec3(0.0,0.0,0.0)),
                dot(n_rand3(nv + vec3(1.0,0.0,0.0)), fv - vec3(1.0,0.0,0.0)),
                u.x),
            mix(dot(n_rand3(nv + vec3(0.0,1.0,0.0)), fv - vec3(0.0,1.0,0.0)),
                dot(n_rand3(nv + vec3(1.0,1.0,0.0)), fv - vec3(1.0,1.0,0.0)),
                u.x),
            u.y),
        mix(
            mix(dot(n_rand3(nv + vec3(0.0,0.0,1.0)), fv - vec3(0.0,0.0,1.0)),
                dot(n_rand3(nv + vec3(1.0,0.0,1.0)), fv - vec3(1.0,0.0,1.0)),
                u.x),
            mix(dot(n_rand3(nv + vec3(0.0,1.0,1.0)), fv - vec3(0.0,1.0,1.0)),
                dot(n_rand3(nv + vec3(1.0,1.0,1.0)), fv - vec3(1.0,1.0,1.0)),
                u.x),
            u.y),
        u.z);
}

float oct_noise(vec3 pos, float o) {
    float ns = 0.0;
    float d = 0.0;
    int io = int(o);
    float fo = fract(o);

    for (int i = 0; i <= io; i++) {
        float v = pow(2.0, float(i));
        d += 1.0/v;
        ns += noise(pos * v) * (1.0/v);
    }

    float v = pow(2.0, float(io + 1));
    d += (1.0 * fo) / v;
    ns += noise(pos * v) * (1.0 * fo / v);

    return ns / d;
}

float posterize(float v, int n) {
    float fn = float(n);
    return floor(v * fn) / (fn - 1.0);
}

float f(vec2 uv) {
    vec2 pos = uv;
    pos.x *= iResolution.x / iResolution.y;
    pos *= 10.0;

    float base = (-pow(abs(uv.y - 0.5) * 2.0, 2.0) + pow(uv.x + 0.1, 8.0) - pow(uv.x + 0.1, 10.0)) * 10.0 - pow(1.1 - uv.x, 10.0);
    float wave = oct_noise(vec3(pos + vec2(TIME * 8.0, 0.0), TIME * 0.5), (1.0 - uv.x) * 4.0) / 2.0;
    float flares = pow(sin(1.0 - (noise(vec3(pos * 2.0 + vec2(TIME * 16.0, 0.0), TIME)) * 3.141592653689)), 4.0) / 16.0;

    return base + wave + flares;
}

vec2 grad(vec2 x) {
    vec2 h = vec2(0.01, 0.0);
    return vec2(f(x + h.xy) - f(x - h.xy),
                f(x + h.yx) - f(x - h.yx)) / (2.0 * h.x);
}

float border(vec2 uv) {
    float v = f(uv);
    vec2 g = grad(uv);
    float de = abs(v) / length(g);
    float eps = 0.01;
    return smoothstep(1.0 * eps, 2.0 * eps, de);
}

void fragment() {
    vec2 uv = UV;
    vec2 pos = uv;
    pos.x *= iResolution.x / iResolution.y;
    pos *= 10.0;

    float value = f(uv);
    float b = step(0.5, border(uv));
    float alpha = step(0.0, value);

    // Palette selection
    vec3 pal = HP[int(clamp(posterize(value, 4) * 4.0, 0.0, 3.0))];
    vec3 color = pal - vec3(1.0 - alpha) - (1.0 - b);

    COLOR = vec4(alpha == 1.0 ? color : vec3(0.5), alpha);
}
