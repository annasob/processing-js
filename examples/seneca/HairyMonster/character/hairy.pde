// Draws a hair character which can have his hair settings changed
//
import processing.opengl.*;

// TODO : make fit the screen better
// and make dependant on screen size
Curve[] hairball;
GazeControl g_gaze[] = new GazeControl[7];
Eyes g_eyes = new Eyes();
Movement g_movement = new Movement();
boolean g_drawHelp= false;

void GenHair()
{
    randomSeed(146914036);
    hairball =  GenerateCurvesOnSphere(128, 100.,20.,
                g_HairStyle.mohawk,g_HairStyle.face, g_HairStyle.messy,
                g_HairStyle.clumpStrength, g_HairStyle.clumpScale );
}
PVector g_Light;
void setup()
{
  size(700,400, P3D);//,OPENGL);//
  noStroke();
  GenHair();
  
  for (int i = 0; i < 7; i++)
    g_gaze[i] = new GazeControl();
         
  g_Light = new PVector(0.707f,-0.707f,0.1);
   g_Light.normalize();
}
HairStyle  g_HairStyle = new HairStyle();

float g_LightAngle = 0.55f;
void mouseDragged()
{
  if ( g_HairStyle.ApplyHairCutInput() )
    GenHair();
   g_LightAngle = g_HairStyle.LightAngle;
}
float glastVel = 0.;
void mouseReleased()
{
  float mx  =((float)(mouseX)/(float)width)*2.-1.;
  float my = ((float)(mouseY)/(float)height)*2.-1.;
  float d = mx*mx + my*my;
  if ( d < 0.1)
    g_movement.Hit(800);
}

boolean g_DrawBabies = false;
boolean g_HairAnim = false;
void keyPressed()
{
  if ( keyCode >='0' && keyCode <='9')
  {
    int code = keyCode-'0';
    g_HairStyle = PresetHairStyles[code%PresetHairStyles.length];
     GenHair();
    return;
  }
  if ( key =='A' || key =='a')
    g_HairAnim = !g_HairAnim ;
  else if ( keyCode =='H' || keyCode == 'h')
    g_drawHelp = !g_drawHelp;
  else if  ( keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT)
    g_DrawBabies = !g_DrawBabies;
}

PVector hairColors[]= {
new PVector(.137, .137, .137),  // poddle hair
new PVector(.81,.81,.81),
new PVector(.037, .037, .037),  // gorrilla hair
new PVector(.2, .2, .2),
new PVector(.109, .037, .007),
new PVector(.519, .325, .125),
new PVector(.3, .037, .1),
new PVector(.3, .6, .75),
new PVector(.3, .01, .3),
new PVector(.75, .4, .75),
new PVector(.1, .3, .5),
new PVector(.1, .55, .05),
};
color BackgroundColor = color(196,196,196);

void drawDropShadow(float rad, float s, PVector dir, float d  )
{
  noLights();
  beginShape(TRIANGLE_FAN);
  int c =(int)( (1.-s)*255.);
  fill(c,c,c,255);
  vertex(0.0f,100.001,0.0f);   
 fill(196,196,196,255); 
  for (float ang = 0.; ang <= (2.0f * PI+0.001); ang += 2.0f * PI/32.)
  {
    float ox = sin(ang);
    float oz = cos(ang);
    float ex = max(ox*dir.x + oz*dir.z,0.)*d;
    float r = rad + ex;
    vertex(ox*r, 100.001,oz*r);
  }
  endShape();
}
int DrawHairBall( float time,float quality, boolean isLow, GazeControl gaze , float rotateAmt, int skip )
{
  pushMatrix();
 float extraL = g_HairStyle.Length -g_movement.y;
 float shadS = constrain(extraL/40+.5,0.5,1.);
 float shadR = constrain( (120+ extraL),0,80 + g_HairStyle.Length );
  PVector nl = new PVector(-sin(PI*g_LightAngle),-0.707f,cos(PI*g_LightAngle));
   nl.normalize();
   drawDropShadow(shadR, shadS, nl, shadR);
      
 // drawDropShadow(constrain( (60+ g_HairStyle.Length -g_movement.y),0,60+ g_HairStyle.Length) );
  float vel = -g_movement.yvel*0.01;
  glastVel = 0.7*glastVel + 0.3*vel;

  // select hair color at random and blend
  float hairColorIndex = noise(time*0.05+12497)*10.;
  float hI = floor(hairColorIndex);
  float hbl = hairColorIndex - hI;
  int hl =hairColors.length;
  int hIdx0 = ((int)hI*2 )% hl;
  int hIdx1 = ((int)(hI+1)*2 )% hl;
  PVector rootColor = lerpV(hairColors[hIdx0], hairColors[hIdx1], hbl );
  PVector tipColor = lerpV(hairColors[hIdx0+1], hairColors[hIdx1+1], hbl ); 

  // rotate to face
  float rot = gaze.lx*.25+rotateAmt;
 
  PVector view = new PVector(sin(rot),0.f,-cos(rot));
  g_Light = new PVector(sin(rot+PI*g_LightAngle),-0.707f,-cos(rot+PI*g_LightAngle));
  
  float rimOffset = -.3;
  PVector g_Light2 = new PVector(sin(rot+PI*(g_LightAngle +rimOffset)),-0.707f,-cos(rot+PI*(g_LightAngle+rimOffset)));  
  g_Light.normalize();
   
   float floppyFactor = constrain((2.-g_HairStyle.stiffness)*.5,0.,1.);
   HairShader hs = new HairShader( rootColor,tipColor, 
                       new PVector(0.,0.,0.), 99.0f + g_HairStyle.Length*floppyFactor, 
                        g_Light, g_Light2);
                      
  rotateY(rot);
  
  rotateX(-gaze.ly*.25);
  translate( 0, -g_movement.y,0);

  int step = skip;
  float rw= g_HairStyle.rootWidth;
  float tw = g_HairStyle.tipWidth;
  if ( isLow )
  {
    rw *=3;
    tw *=2;
  }     
  
//  noStroke();
  beginShape(QUADS);
  int count =0;
  for(int i =0; i < hairball.length; i+=step)
    if (IsVis(hairball[i], view) )
      count +=  DrawStack(hairball[i], view, hs, rw, tw, quality );
      
  endShape(QUADS);


noStroke();
  lights();
  sphereDetail( isLow ? 8 : 16 );
  
  fill(0);
  sphere( 100.);
  g_eyes.Draw(gaze, time);  

  noLights();
  popMatrix(); 
  return count;
} 

void draw()
{  
  background(color(196,196,196));
  float time = (float)millis()/1000.;

PVector pushPoint = new PVector((float)(mouseX) - (float)width*.5,
                                  (float)(mouseY) - (float)height*9/16,
                                  0.);
  // project onto sphere
  pushPoint.z = 90.;
  
  float hopChance = pushPoint.mag()<150. ? 0.1 : 0.01;
  if ( (random(0,1) < hopChance) && g_movement.y ==0.)
      g_movement.Hit(random(10,200));
  g_movement.Update(time);
  for (int i = 0; i < 7; i++)
    g_gaze[i].update(time+ +15897*i);

  float groundH = g_movement.y+100.;
  float rotateAmt =0.f;
  if ( g_HairAnim)
  {
     float hat = time*.2;
     float hI = floor(hat);
     float hbl = hat - hI;
     hbl = hbl*hbl*(3.-2.*hbl);
     hbl = hbl*hbl*(3.-2.*hbl);
    int hl =PresetHairStyles.length;
    g_HairStyle.Lerp( PresetHairStyles[ (int)hI%hl],  PresetHairStyles[ ((int)hI+1)%hl], hbl);
    GenHair();
    rotateAmt =hat*2.*PI*.5;
  }
  
  float rot = g_gaze[0].lx*.25+rotateAmt;
  PVector view = new PVector(sin(rot),0.f,-cos(rot));
  
   ApplyVelocityToCurves( hairball,new PVector(0.f,glastVel -0.96f,0.), 
         g_HairStyle.stiffness, g_HairStyle.Length, groundH, pushPoint, view );

  translate( width/2,  height*9/16);

  int numSegs = DrawHairBall( time,32., false, g_gaze[0], rotateAmt, g_DrawBabies ? 2 : 1);

  // draw babies
  int numBabies = g_DrawBabies ? 6 :0;
  for (int i =0 ; i < numBabies;i++)
  {
    pushMatrix();
    translate( -(i*width)/8 + width/2 - 40 + ((i > 2) ? -140.: 0.), 0);
    scale(0.3);       
    numSegs +=DrawHairBall( time+15897*(i+1),100.,true,  g_gaze[i+1],  rotateAmt, 6);

    popMatrix();
  } 
  if ( g_drawHelp  )
  {
    textMode(SCREEN); 
    String hairDescription = g_HairStyle.GetDescription();
    text(  "| Fps " + (int)frameRate + "| NumSegs " + numSegs, 20,height-40);
      text(  hairDescription , 20,height-20);
  }
}

