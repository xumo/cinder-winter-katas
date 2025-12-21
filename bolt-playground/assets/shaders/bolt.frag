// frag
#version 410

in vec4 gColor;
in vec2 gTexCoord;

out vec4 outColor;

uniform float uBoltWidth = 1.0;
uniform float uBoltSpread = 5.0;

void main()
{
    
    float epsilon = uBoltWidth;
    vec2 uv = gTexCoord;
   
    float c =  exp(-(1.0 + uBoltSpread) * abs(uv.y - 0.5));
    //c = smoothstep(0.5 - epsilon, 0.5, uv.y) - smoothstep(0.5, 0.5 + epsilon, uv.y);
    //c *= 1.0 -smoothstep(0.05, 0.0, 1.0-uv.x);
    //c *= 1.0 -smoothstep(0.05, 0.0, uv.x);
    //outColor = vec4(c * gColor, c);
    outColor = c * gColor;
    //outColor = vec4(1.0) - vec4(gColor, c);
}
