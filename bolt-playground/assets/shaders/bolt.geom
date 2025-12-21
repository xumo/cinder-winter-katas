#version 410

layout(points) in;
layout(triangle_strip, max_vertices = 128) out;

in vec2    start[];
in vec2    end[];
in int     divisions[];

out vec4   gColor;
out vec2   gTexCoord;

uniform int uNumSides = 4;
uniform float uOffset = 4.0;
uniform int uBoltDivisions = 4;
uniform float uBoltCanvasWidth = 1.0;


uniform float uTime;
vec3 theColor;

const float PI = 3.1415926;

struct Segment
{
    vec2 start;
    vec2 end;
} sSegment;

float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}


void emit(vec2 pos, vec2 texcoord) {
    gl_Position = vec4(pos, 0.0f, 1.0f);
    gTexCoord = texcoord;
    EmitVertex();
}

void segment(vec2 s, vec2 e) {
    
    vec2 direction = normalize( e - s );
    vec2 normal = ( vec2(-direction.y, direction.x) );
    float halfWidth = uBoltCanvasWidth;
    vec2 offset = normal * halfWidth;
    
    vec2 offsetD = direction * halfWidth;
    gColor = vec4(theColor, 0.0);
    emit(vec2(s - offset - offsetD), vec2(-1.0, 1.0));
    emit(vec2(s + offset - offsetD), vec2(-10.0, 0.0));
    
    gColor = vec4(theColor, 1.0);
    emit(vec2(s - offset), vec2(0.0, 1.0));
    emit(vec2(s + offset), vec2(0.0, 0.0));
    
    gColor = vec4(theColor, 1.0);
    emit(vec2(e - offset), vec2(1.0, 1.0));
    emit(vec2(e + offset), vec2(1.0, 0.0));
    
    gColor = vec4(theColor, 0.0);
    emit(vec2(e - offset + offsetD), vec2(2.0, 1.0));
    emit(vec2(e + offset + offsetD), vec2(2.0, 0.0));
}

void branch(const Segment s, float divs)
{
    if (divs < 1) return;
    float st = length(s.end - s.start) / divs;
    float nX, nY, r;
    vec2 dir, n, nDir, aV, bV;
    aV = vec2(s.start);
    
    
    
    for (int i = 0; i < divs ; i++)
    {
        r = 0.5 - rand(i * s.start);
        dir = (s.end - aV);
        st = length(dir) / ( divs - i);
        nDir =  st * normalize(dir);
        nDir += uOffset * r * dir.yx;
        bV = aV + nDir; //+ n * (0.5 - r);
        //st = length(dir) / (divs - i);
        theColor = vec3(1.0, 1.0 / (1.0 + i), 1.0 - 1.0 / (1.0 + i));
        segment(aV, bV);
        aV = bV;
    }
    theColor = vec3(0.0,0.0,1.0);
    segment(aV, s.end);
    //theColor = vec3(0.0, 1.0, 0.0);
    //segment(s.start, s.end);
}


void main()
{
    gColor = vec4(1.0, 1.0, 1.0, 1.0);
    vec2 s = start[0];
    vec2 e = end[0];
    int divs = divisions[0];
    divs = uBoltDivisions;
    vec2 aV = s;
    vec2 bV, eV, d, n;
    float m, nm, ex;
    
    float time = 0.000001* uTime;
    //float r = rand(time * s);
   
    /*float nX, nY, r;
    for (int i = 0; i < divs; i++)
    {
        //m = 0.1 + 0.4f * r;
        //nm = 0.5f - r;
        //ex = rand(e );
        //d = e - aV;
        //n = 0.4f * nm * vec2(-d.y, d.x);
        //bV = aV + m * d + n;
        //eV = aV + (bV - aV) * (1.0 + ex);
        nX = (e.x + aV.x)*0.5;
        nY = (e.y + aV.y)*0.5;
        //r = rand(vec2(time, float(i)));
        r = rand(s);
        nX += (r - 0.5) * uOffset;
        //r = rand(vec2(float(i), time));
        r = rand(vec2(i));
        nY += (r - 0.5) * uOffset;
        bV = vec2(nX, nY);
        
        segment(aV, bV);
        aV = bV;
    }
    */
    
    //theColor = vec3(1.0, 1.0, 1.0);
    //segment(s, e);
    Segment seg;
    seg.start = s;
    seg.end = e;
    theColor = vec3(1.0, 0.0, 1.0);
    branch(seg, divs);
  
    EndPrimitive();
}
