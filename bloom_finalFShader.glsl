#version 330 core
out vec4 FragColor;

in vec2 TexCoords;

uniform sampler2D scene;
uniform sampler2D bloomBlur;
uniform bool bloom;
uniform float exposure = 1.0;
uniform float bleed = 1.0;

void main()
{             
    const float gamma = 2.2;
    vec3 hdrColor = texture(scene, TexCoords).rgb;      
    vec3 bloomColor = texture(bloomBlur, TexCoords).rgb;
    if(bloom)
        //hdrColor += 1.5 * bloomColor; // additive blending
        //hdrColor += 2 * bloomColor; // additive blending
        bloomColor = pow(bloomColor, vec3(1.0 / gamma));
        //hdrColor = bloomColor;
        hdrColor += bleed * bloomColor; // additive blending
    // tone mapping
    vec3 result = vec3(1.0) - exp(-hdrColor * exposure);
    // also gamma correct while we're at it       
    //result = pow(result, vec3(1.0 / gamma));
    FragColor = vec4(result, 1.0);
}