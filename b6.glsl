uniform float iOvertoneVolume;
uniform float iGlobalBeatCount;
uniform float iActiveColor;

void main(void){
  vec2 uv=(gl_FragCoord.xy/iResolution.xy);
  uv.y=1.0-uv.y; //*sin(iGlobalBeatCount);
  vec4 cam0=texture2D(iCam0, uv);
  vec4 cam1=texture2D(iCam1, uv);
  vec4 cm1=mix(cam0, cam1, sin(iActiveColor));
  gl_FragColor=cm1;

}
