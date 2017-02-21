
uniform float time;
uniform sampler2D t_audio;

uniform sampler2D t_cube;
uniform sampler2D t_normal;
uniform sampler2D t_logo;

uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;

varying vec3 vPos;
varying vec3 vCam;
varying vec3 vNorm;

varying vec3 vMNorm;
varying vec3 vMPos;

varying vec2 vUv;
varying float vNoise;


$uvNormalMap
$semLookup


// Branch Code stolen from : https://www.shadertoy.com/view/ltlSRl
// Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License

const float MAX_TRACE_DISTANCE = 1.0;             // max trace distance
const float INTERSECTION_PRECISION = 0.001;        // precision of the intersection
const int NUM_OF_TRACE_STEPS = 15;
const float PI = 3.14159;



$smoothU
$pNoise

//--------------------------------
// Modelling 
//--------------------------------
vec2 map( vec3 pos ){  

    vec2 res = vec2( 1000000. , 0. );



    vec3 mpos = mod( pos , vec3( .006)) - vec3(.003);



    vec2 centerBlob = vec2( length( mpos  ) - .001 , 1. );
    centerBlob.x += pNoise( pos * 100. ) * .01;

    res =smoothU( res , centerBlob , .2 );

    return res;
    
}


$calcIntersection
$calcNormal
$calcAO





void main(){

  //vec3 fNorm = uvNormalMap( t_normal , vPos , vUv * 20. , vNorm , .6 , -.1 );
  vec4 logoCol = texture2D( t_logo , vUv );

  if( logoCol.g >1. ){
     if( logoCol.b > .8 ){
      discard;
     }
  }

  if( logoCol.r > .7 ){
    if( logoCol.b > (pNoise( vec3( vUv * 100. , time )) * .5 + pNoise( vec3( vUv * 300. , time * .5)) * .5) * logoCol.r ){
      discard;
    }
  }

  vec3 ro = vPos;
  vec3 rd = normalize( vPos - vCam );

  vec3 p = vec3( 0. );
  vec3 col =  vec3( 0. );

  //float m = max(0.,dot( -rd , fNorm ));

  //col += fNorm * .5 + .5;

 // vec3 refr = refract( rd , fNorm , 1. / 1.) ;

 
  vec2 res = calcIntersection( ro , rd );

//  col = fNorm * .5 + .5;


  col = texture2D(t_cube, vUv).rgb;

  if( res.y > -.5 ){

    p = ro + rd * res.x;
    vec3 n = calcNormal( p );

    //col += n * .5 + .5;

    col +=  texture2D( t_cube, semLookup( rd , n , modelViewMatrix , normalMatrix ) ).xyz;

    col *= n*.5 + .5;

    if( logoCol.g < .5 ){ col *= 2.; }
    //col *= texture2D( t_audio , vec2(  abs( n.x ) , 0. ) ).xyz;

  }




  gl_FragColor = vec4( col , 1. );

}
