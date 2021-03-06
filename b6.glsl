uniform float iOvertoneVolume;
uniform float iGlobalBeatCount;
uniform float iActiveColor;
uniform float iA;
uniform float iB;
uniform float iC;

void main(void){
  vec2 uv = (gl_FragCoord.xy / iResolution.xy);
  uv.y=1.0-uv.y;
  vec2 uv2 = (gl_FragCoord.xy / iResolution.xy);
  	vec2 p = gl_FragCoord.xy / iResolution.x;//normalized coords with some cheat
  uv2.y=1.0-uv2.y;

  float prop = iResolution.x / iResolution.y;//screen proroption
  vec2 m = vec2(0.5, 0.5 / prop);//center coords
  vec2 d = p - m;//vector from center to current fragment
  float r = sqrt(dot(d, d)); // distance of pixel from center

  float power = ( 1.0 * 3.141592 / (2.0 * sqrt(dot(m, m))) ) *
				(200*sin(1.15*iGlobalTime) / iResolution.x - 0.5);//amount of effect
  float bind;//radius of 1:1 effect
	if (power > 0.0) bind = sqrt(dot(m, m));//stick to corners
	else {if (prop < 1.0) bind = m.x; else bind = m.y;}//stick to borders
    vec2 uv3;
    if (power > 0.0)//fisheye
		uv3 = m + normalize(d) * tan(r * power) * bind / tan( bind * power);
	else if (power < 0.0)//antifisheye
		uv3 = m + normalize(d) * atan(r * -power * 10.0) * bind / atan(-power * bind * 10.0);
	else uv3 = p;//no effect for power = 1.0


  uv.x = uv.x + 5.5*sin(0.15*iGlobalTime);
  uv.y = uv.y + 2.5*cos(1.03*iGlobalTime);
  vec4 c1 = texture2D(iChannel0,uv);
  vec4 c1b =texture2D(iChannel1, uv);
  vec4 c1c =texture2D(iChannel1, uv);
  vec4 c1d =texture2D(iChannel1, uv);


  vec4 fftw=texture2D(iFftWave, uv);

  vec4 c2 = texture2D(iCam0,vec2(uv3.x, -uv3.y * prop));
  vec4 c3 = texture2D(iCam1,uv2);
  vec4 c4 = texture2D(iCam2,uv2);
  vec4 c5 = texture2D(iCam3,uv2);
  vec4 c6 = texture2D(iCam4,uv2);

  vec4 v1= texture2D(iVideo0, uv2);
  vec4 v2= texture2D(iVideo1, uv2);
  vec4 v3= texture2D(iVideo2, uv2);
  vec4 v4= texture2D(iVideo3, uv2);


  vec4 c = mix(v1,v2,0.3-sin(c1.w));  // alpha blend between two textures
  vec4 cf = mix(c4,c,1.5-sin(c1.w));  // alpha blend between two textures
  vec4 cf1 = mix(cf,c5,1.5-sin(c1.w));  // alpha blend between two textures
  vec4 cf2 = mix(c6,cf1,0.5-sin(c1.w));  // alpha blend between two textures
  //vec4 cf3 = mix(c2,v2,0.01-sin(c1.w));  // alpha blend between two textures
  vec4 cf4 = mix(v1,v3,sin(0.51*fftw.r));  // alpha blend between two textures
  vec4 cf5 = mix(cf4,fftw,iOvertoneVolume*sin(iOvertoneVolume));

  //color key

  vec4 fg=v1;
  vec4 bg=v3;

  float maxrb = max( fg.r, fg.g );
  float k = clamp( (fg.b-maxrb)*90, 0.0, 1.0 );

  float dg = fg.b;
  fg.b = min( fg.b, maxrb*0.8);
    fg += dg - fg.b;

    vec4 cf6=mix(fg, bg, k);
    vec4 cf7=mix(cf6, v1, iB);



  gl_FragColor = cf7;

}
