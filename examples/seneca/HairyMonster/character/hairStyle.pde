class HairStyle
{
  float Length = 20.f;
  float stiffness = 0.5f;
  float rootWidth = 2.f;
  float tipWidth = 0.5f;
  float mohawk = 0.;
  float face = 0.;
  float messy = 0.3f;
  float LightAngle = 0.55f;
  
  float clumpStrength = 1.;
   float clumpScale = 0.1;
      
HairStyle()
{}

  HairStyle( float _s, float _l, float _r, float _t, float _m, float _f, float _mes, float _cstr, float _csc)
  {
    Length = _l;
    stiffness = _s;
    rootWidth = _r;
    tipWidth = _t;
    mohawk = _m;
    face = _f;
    messy = _mes;
    clumpStrength = _cstr;
    clumpScale = _csc;
    
  }
  void Lerp(HairStyle a, HairStyle b, float t)
  {
    Length = lerp(a.Length,b.Length,  t);
    stiffness= lerp(a.stiffness, b.stiffness,t);
    rootWidth= lerp(a.rootWidth,b.rootWidth,t);
    tipWidth= lerp( a.tipWidth,b.tipWidth,t);
    mohawk= lerp(a.mohawk,b.mohawk,t);
    face= lerp(a.face, b.face,t);
    messy= lerp( a.messy, b.messy,t);    
    clumpStrength = lerp( a.clumpStrength, b.clumpStrength,t);
    clumpScale =  lerp( a.clumpScale, b.clumpScale,t);
  }
  boolean ApplyHairCutInput()
  {
     float dx  = ((float)((float)(mouseX-pmouseX)/(float)width));
    float dy = ( (float)((float)(mouseY-pmouseY)/(float)height));
    if ( keyPressed && keyCode == CONTROL)
    {
      mohawk = max( mohawk + dx*.5, 0.);
      face = max( face + -dy*20., 0.);
      return true;
    }
    else if ( keyPressed && keyCode == SHIFT)
    {
       rootWidth+=dx;
       tipWidth+=dy;
       return true;
    }
   else if ( keyPressed && keyCode == ALT)
    {
      // messy = max( messy + dx, 0.);    
      // LightAngle += dy;
      clumpStrength  = max(clumpStrength + dx, 0.);    
      clumpScale  = max(clumpScale -dy*0.1, 0.);    
       return true;
    }
    else
    { 
      Length =max(  Length +dx*20., 0.05);
     stiffness =max( stiffness+ dy, 0.);
     return false;
    }
  }
  String GetDescription()
  {
     return "| Stiffness " + nf(stiffness,2,2) +"| Length "+nf(Length,3,1) +"| Root Width " + nf(rootWidth,2,2)
    + "| Tip Width " +nf(tipWidth,2,2) + "|Side Cut " +   nf(mohawk,1,2)  + "|Face Cut " + nf(face,3,1) + "| Messiness " + nf(messy,1,2);
  }
}
// add a new hair style here
 HairStyle PresetHairStyles[]= {
  new HairStyle( 0.37,39.4,1.71,0.3,  0.25,0.f,0.3f, 1.,3.),
  new HairStyle(0.49,60.78,1.23,0.168,0.f,0.f,0.3f, 1.,3.),
   new HairStyle(0.42,99.7,1.23,0.17,0.7f,60.f,0.3f, 1.,3.),
  new HairStyle(0.88,28.81,2.67,1.67,0.f,0.f,0.3f, 1.,3.),
   new HairStyle(0.99,19.3,2.62,0.49,0.34f,32.f,1.89f, 1.,3.),
   new HairStyle(0.61,27.5,2.62,0.49,0.0,46.f,1.89f, 1.,3.)
   
};

