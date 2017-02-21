function beginLoad(){
  loadShaders();
  loadAudio();
  loadOBJS();
  G.logo = loadImage("ren.png");
  G.cube = loadImage("rough-aluminium.jpg");


  
  //loadCubeMap();
}

function loadShaders(){

  //shaders.load( 'ss-curlFront'    , 'sim'    , 'simulation' );

  G.loading.neededToLoad ++;

  G.shaders.load( 'fs-trace2'  , 'trace' , 'fragment' );
  G.shaders.load( 'vs-trace'  , 'trace' , 'vertex'   );

  
  G.shaders.shaderSetLoaded = function(){
    onLoad();
  }

}

function loadOBJS(){
  G.modelLoader = new THREE.OBJLoader();
  loadOBJ( "face" , "face.obj" );
}


function loadOBJ(name, url){

  G.loading.neededToLoad ++;


  G.modelLoader.load(url, function ( object ) {
    object.traverse( function ( child ) {
      //if ( child instanceof THREE.Mesh ) {
        //child.material.map = texture;
        onLoad();
        G.models[name] = child;
        print("hels");
      //}
    } );

  }, onProgress, onError );

}

function onProgress(){}
function onError(){}


function loadImage(url){

  G.loading.neededToLoad ++;
  var r = THREE.RepeatWrapping;

  var t = THREE.ImageUtils.loadTexture(url, r , onLoad, onError);
  t.wrapT = t.wrapS = THREE.RepeatWrapping;
  return t;

}


function loadAudio(){

  //loadBuffer( "loveLoopBuffer"  , "audio/love.mp3"      );
  //loadBuffer( "painLoopBuffer"  , "audio/pain.mp3"      );
  //loadBuffer( "normLoopBuffer"  , "audio/norm.mp3"      );
//
  //loadBuffer( "clickNoteBuffer" , "audio/switch.mp3"    );
  //loadBuffer( "startNoteBuffer" , "audio/startNote.mp3" );
  //loadBuffer( "jestNoteBuffer"  , "audio/jest.mp3" );



}

function loadBuffer(name , bufferFile){

  var aBuff = new AudioBuffer( G.audio , bufferFile);
  G[name] = aBuff;
  G.loading.neededToLoad += 1;
  aBuff.addLoadEvent(function(){
    onLoad();
  })

}

function onLoad(){

  G.loading.loaded ++;

  console.log( G.loading );


  if( G.loading.loaded == G.loading.neededToLoad ){

    finishedLoading();

  }

}

// TODO: these catch?
function onProgress(e){
  console.log( e );
}

function onError(e){
  console.log( e );
}

function finishedLoading(){

  console.log("WFTASAD");
  G.init(); 
  G.animate();
}