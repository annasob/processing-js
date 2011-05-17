
PVector Average(PVector a, PVector b)
{
  return new PVector( .5*(a.x+b.x), .5*(a.y+b.y),.5*(a.z+b.z));
}

class Curve
{
  PVector[] p;
  float     v0;
  float     v1;
  float     clen;
  
  PVector   m_tan0;
  PVector   m_tan1;
  
  PVector   m_col0;
  PVector   m_col1;
  Curve() { p = new PVector[4]; }
  Curve( PVector _p[], float l )
  {
    p = _p;
    v0 =0.;
    v1 = 1.;
    clen =l;
  }

  float distancePointsToLine( PVector p0, PVector p1, PVector l1, PVector l2)
  {
    PVector ul = new PVector();
    ul.set(l2);
    ul.sub(l1);
    //ul.normalize();  - not required

    PVector dp0 = new PVector();
    dp0.set(p0);
    dp0.sub(l1);

    PVector dp1 = new PVector();
    dp1.set(p1);
    dp1.sub(l1);

    float area0 = ul.cross(dp0).mag();
    float area1 = ul.cross(dp1).mag();
    return area0 + area1;
  }
  boolean IsFlat( float pswidth)
  {
    float tol =  pswidth;
    // from http://www.antigrain.com/research/adaptive_bezier/index.html
    // simple flatness test distance of  point to line
    // Try to approximate the full cubic curve by a single straight line
    //------------------
    float dx = p[3].x-p[0].x;
    float dy = p[3].y-p[0].y;
    float dz = p[3].z-p[0].z;

    float len = (dx*dx + dy*dy + dz*dz);

    float d2pd3 = distancePointsToLine( p[1],p[2],p[0],p[1]);
    return ((d2pd3)*(d2pd3) < tol * len);
    }
  Curve[] Subdivide( )
  {
    Curve curves[] = new Curve[2];
    curves[0] = new Curve();
    curves[1] = new Curve();
    // width automatically converted
    curves[0].p[0 ] = p[0 ];
    curves[1].p[3 ] = p[3 ];
    curves[0].p[1 ] =  Average( p[0],p[1]);
    curves[1].p[2 ] =  Average( p[2 ],p[3]);

    final PVector p11 = Average(p[1],p[2]);
    curves[0].p[2] = Average(curves[0].p[1], p11);
    curves[1].p[1]=  Average(curves[1].p[2],p11);

    final PVector p30 = Average(curves[0].p[2 ], curves[1].p[1]);
    curves[0].p[3] = p30;
    curves[1].p[0] = p30;

     // Use v0 for width as well
    curves[0].v0 =v0;
    curves[1].v1 =v1;
    
    final float midV = .5*(v0+v1);
    curves[0].v1 =midV;
    curves[1].v0 =midV;
 
   curves[0].clen = clen;
   curves[1].clen = clen;
    return curves;
  }
  void DrawFirstPoint(PVector view, HairShader hs, float rootW, float tipW )
  {
     PVector delta = new PVector();
    delta.set(p[1]);
    delta.sub(p[0]);
    delta.normalize();
    
    float w0 = lerp(rootW,tipW, v0)*clen;
    PVector tangent = view.cross( delta);
    tangent.normalize();
    tangent.mult(w0);
    PVector col0  = hs.GetShade(p[0], delta,view,  v0 );
    
     
    fill( color(col0.x*255.,col0.y*255.,col0.z*255.));
    
     vertex( p[0].x - tangent.x, p[0].y - tangent.y, p[0].z - tangent.z);
    vertex( p[0].x + tangent.x, p[0].y + tangent.y, p[0].z  + tangent.z);

  }
    void DrawEndPoint2( PVector view, HairShader hs, float rootW, float tipW )
  {        
     PVector  delta =new PVector();
     delta.set(p[3]);
     delta.sub(p[2]);
     delta.normalize();
     
    float w1 = lerp(rootW,tipW, v1)*clen;
    PVector tangent2 = view.cross( delta);
    tangent2.normalize();
    tangent2.mult(w1);
    
    PVector col1 =  hs.GetShade( p[3], delta,view, v1 );           
    fill( color(col1.x*255.,col1.y*255.,col1.z*255.));
    float p0x =  p[3].x + tangent2.x;
    float p1x =  p[3].x - tangent2.x;
    float p0y =  p[3].y + tangent2.y;
    float p1y =  p[3].y - tangent2.y;
    float p0z =  p[3].z + tangent2.z;
     float p1z =  p[3].z - tangent2.z;
    vertex( p0x, p0y, p0z);
    vertex( p1x, p1y, p1z);
    vertex( p1x, p1y, p1z);
    vertex( p0x, p0y, p0z);   
  } 
  void DrawEndPoint( PVector view, HairShader hs, float rootW, float tipW )
  {  
        
     PVector  delta =new PVector();
     delta.set(p[3]);
    delta.sub(p[2]);
     delta.normalize();
     
    float w1 = lerp(rootW,tipW, v1)*clen;
    PVector tangent2 = view.cross( delta);
    tangent2.normalize();
    tangent2.mult(w1);
    
    PVector col1 =  hs.GetShade( p[3], delta,view, v1 );           
    fill( color(col1.x*255.,col1.y*255.,col1.z*255.));
    vertex( p[3].x + tangent2.x, p[3].y + tangent2.y, p[3].z + tangent2.z);
    vertex( p[3].x - tangent2.x, p[3].y - tangent2.y, p[3].z - tangent2.z);

  } 
  void Draw( PVector view, HairShader hs, float rootW, float tipW )
  {   
    DrawFirstPoint(view,hs, rootW,tipW );
    DrawEndPoint( view, hs, rootW,tipW );
  }
}
boolean IsVis( Curve cp, PVector view )
{
  PVector dir = new PVector();
  dir.set(cp.p[1]);
  dir.sub(cp.p[0]);
  return dir.dot(view) < 0.0;
}
int DrawStack(  Curve  cp, PVector view ,HairShader hs, float rootW, float tipW ,
                float quality )
{
//     beginShape(QUAD_STRIP);

   Curve[] stack = new Curve[64];
   int stptr = 0;
   int count =0;
    
   quality = quality/(float)width;
   
   //  draw first Point
   cp.DrawFirstPoint(view, hs , rootW, tipW);
   while( true)
   {
     if ( cp.IsFlat(quality)  )
     {
       // draw endpoint cp;
       count++;
       if ( stptr == 0)
       {
         cp.DrawEndPoint(view, hs , rootW, tipW);
         return count;
       }
       cp.DrawEndPoint2(view, hs , rootW, tipW);
       cp = stack[--stptr];
       continue;
     }
     // compute mid edge data
     Curve[] cps = cp.Subdivide();
     cp = cps[0];
     stack[stptr++] = cps[1];
   }
     

}
PVector lerpV( PVector a, PVector b, float t)
{
  return new PVector( lerp(a.x,b.x,t),lerp(a.y,b.y,t),lerp(a.z,b.z,t));
}
float pow6(float v)
{
  v  = v*v;
  float v4 = v*v;
  return v4*v;
}
float intSphereThickness( float r2, PVector ro, float ro2, PVector dir)
{
  float c = ro2 - r2;
  float b = ro.dot(dir);
  float t = b*b-c;
  if ( t > 0.0f) {
    float st =sqrt(t);
    float t0 = max(-b-st,0.);
    float t1=  max(-b+st,0.);
    return t1 -t0;
  }
  return 0.f;
}

class TLTable
{
  float[] vals;
  int      numVals = 256;
  
  TLTable()
  {
    vals =new float[numVals * numVals];
    for (int i =0; i < numVals;i++)
      for (int j =0; j < numVals; j++)
      {
        float fi  = ((float)i/(float)numVals ) *2.-1.;  // -> i = T.V
        float fj  = ((float)j/(float)numVals ) *2.-1.;  // ->j = T.L
        // calculate lighting val ( could use shader for this)
        float cosang =cos (abs(acos (fj) - acos (-fi )));
        float spec = max( pow6 (cosang),0.);
        vals[i*numVals + j] = spec;
      }
  }
  float GetSpec( float TdotV, float TdotL )
 {
   // convert into range
   int i = (int)(( TdotV*127.)+128.f);
   int j = (int)(( TdotL*127.)+128.f);
 //  if ( j <0 || j >255)
   //  println(" J "+j + " TdotL +"+TdotL);
     
 //   if ( i <0 || i >255)
  //   println(" J "+i + " TdotL +"+TdotV);
  // assert( i >=0 && i <=255);
  // assert( j >=0 && j <=255);
   return vals[ i*numVals + j ];
 } 
}
TLTable g_PrecomputeLighting = new TLTable();

// http://graphics.stanford.edu/lab/soft/purgatory/prman/Toolkit/AppNotes/appnote.19.html#hair
class HairShader
{
   final PVector rootcolor;
   final PVector tipcolor;
   final PVector speccolor;
   final PVector amb;   
   final PVector diffuse;
   final PVector shadSphere;
   final float   shadRadius;
   final float   shadScale;
   
    PVector L;  // normalized light direction
    PVector L1;  // normalized rim light direction
      
   HairShader( PVector _r, PVector _t, PVector _ss, float _sr, PVector _L, PVector _L1 )
   {
     tipcolor = _t;
     rootcolor = _r;
      speccolor =  new PVector( (1 + tipcolor.x)/2,(1 + tipcolor.y)/2,(1 + tipcolor.z)/2);
      
      float Ks = .5 ;
      speccolor.mult(Ks);
       
      final float Ka = 0.1;
      amb = new PVector(0.13f* Ka,0.23f* Ka,0.33f * Ka);
      
      shadSphere = _ss;
      shadScale = 1./(_sr*2);
      shadRadius = _sr*_sr;
      
      L = _L;
      L1 = _L1;
      L.normalize();
      L1.normalize();
      
       final float Kd = .6; //, roughness = .15;
      diffuse = new PVector(1.1* Kd, 0.9* Kd,0.8* Kd);

    }    
    float GetShadow( PVector o, float ro2, PVector d)
    {
        float th =1.-(intSphereThickness( shadRadius, o, ro2, d)*shadScale);
        return pow6(th);    
    }
     
PVector GetShade(
       PVector P, // position
       PVector T, // tangent along length of hair 
	PVector V,   // V is the view vector        
        float   v // normalized length along curve
  )
{
   final float ro2 = P.dot(P);
   float  v2 = sqrt(v);
     // Loop over lights, catch highlights as if this was a thin cylinder     
    float TdotV = T.dot(V);
   
   float shad0 = GetShadow( P, ro2,L);
   float shad1 = GetShadow( P, ro2, L1);
   
 /*   float TdotL = T.dot(L);  
    float acosTdotV = acos (-TdotV );
   float cosang0 =cos (abs(acos (TdotL) - acosTdotV ));
   float Cspec =shad0 * v*max( pow6 (cosang0),0.);  //, 1/roughness)     
   float cosang1 =cos (abs (acos (T.dot(L1)) - acosTdotV));
   Cspec +=shad1 * v* max(pow6 (cosang1),0.);  //, 1/roughness)     
 */  
    float Cspec = shad0 *g_PrecomputeLighting.GetSpec( TdotV, T.dot(L));    
   Cspec += shad1 *g_PrecomputeLighting.GetSpec( TdotV, T.dot(L1));    
   Cspec *=v;
  
   float Cdiff =(shad0 +shad1)*v2 ;
  
  // We multipled by v to make it darker at the roots.  This
 // assumes v=0 at the root, v=1 at the tip.
  PVector hcolor = lerpV(rootcolor, tipcolor, v);
  PVector Ci = new PVector();
  Ci.set( amb);
  Ci.mult(v);
  
  PVector Cd = new PVector();
  Cd.set(diffuse);
  Cd.mult(Cdiff);
  Ci.add( Cd);
  Ci.mult(hcolor);
  
  PVector Cs = new PVector();
  Cs.set(speccolor);
  Cs.mult(Cspec);
  Ci.add(Cs);
  //Ci.set(Cs);
   //Ci.set(shad,shad,shad);
  
  // could do this as a table?
   Ci.x = sqrt(Ci.x);
   Ci.y = sqrt(Ci.y);
   Ci.z = sqrt(Ci.z);
   
   Ci.x = constrain( Ci.x,0.,1.);
   Ci.y = constrain( Ci.y,0.,1.);
   Ci.z = constrain( Ci.z,0.,1.);
   return Ci;                 
}
};

void ApplyVelocityToCurves( Curve[]  curves, PVector vel,
      float stiffness, float clen, float groundH, PVector pushPoint, PVector viewDir )
{
  float pushRadius = 35.;
  vel.mult(stiffness);
  for (int i =0; i < curves.length; i++)
  {
    Curve cp = curves[i];
    if (!IsVis(cp, viewDir) ) 
       continue;
    // calculate expected end point
    PVector dir = new PVector();
    dir.set(cp.p[1]);
    dir.sub(cp.p[0]);
    dir.normalize();
    PVector endpoint = new PVector();
    endpoint.set(dir);
    endpoint.sub(vel);
    // renormalize to keep length
    endpoint.normalize();
    
    float len = clen * cp.clen;
    cp.p[1].set(dir);
    cp.p[1].mult(len*.25);
    cp.p[1].add(cp.p[0]);
    
    cp.p[3].set(endpoint);
    cp.p[3].mult(len);
    cp.p[3].add(cp.p[0]);
    
    cp.p[2].set(endpoint);
    cp.p[2].add(dir);
    cp.p[2].mult(len*.75*.5);
    cp.p[2].add(cp.p[0]);
    
    
    // project up to ground
    float ex = min( -(cp.p[2].y-groundH),0.);
    cp.p[2].x += ex * dir.x/dir.y;
    cp.p[2].z += ex * dir.z/dir.y;
     cp.p[2].y +=ex;
    ex = min( -(cp.p[3].y-groundH), 0.);
    cp.p[3].x += ex * dir.x/dir.y;
    cp.p[3].z += ex * dir.z/dir.y;
     cp.p[3].y +=ex;
     // project away from push point
     
     PVector pushDir = new PVector();
     pushDir.set(pushPoint);
     pushDir.sub(cp.p[3]);
     float pd = pushDir.mag();
     float pushamt = min( pd-pushRadius,0);
     pushamt = max( pushamt,-len);
     pushDir.mult(pushamt/pd);
     cp.p[3].add(pushDir);
     cp.p[2].add(pushDir);
  }
}
Curve[] GenerateCurvesOnSphere( int amt, float rad, 
          float aclength, float mohawk, float face, float messy,
         float clumpStrength, float clumpScale  )
{
  Curve[] cps = new Curve[amt*amt];
 
  PVector cut0 = new PVector(-20,-30,80.);
  PVector cut1 = new PVector(20,-30,80.);
  PVector faceCut0 = new PVector(0,20,80.);
  
  mohawk = 1.-mohawk;
  float cutSize =  28. + face *0.2f;
  float faceCutSize = face;
  float faceCutEnd = 1. - face*0.01f;
  int cnt = 0;  
  
  noiseDetail( 3,0.5);
  int amt2 = amt/2;
  for (int i = 0; i < amt; i++)
    for (int j = 0; j < amt2; j++)
    {
      float u = ((float)i + random(0,1))/(float)amt;
      float v = ((float)j + random(0,1))/(float)amt2;
      // not a good parameterizatin ( too much at the poles       

      // http://mathworld.wolfram.com/SpherePointPicking.html
      float theta = u*2.*PI;
      float phi =acos(2.*v-1.);
      
      PVector nrm = new PVector( sin(phi)*cos(theta), cos(phi), sin(phi)*sin(theta));
      PVector p = new PVector();
      p.set(nrm);
      p.mult(rad);
      
      // check for invalid areas and cut hair as appropriate
      float cut = 1.;
      cut += min( ( PVector.dist(cut1,p)- cutSize)*.5 ,0);
      cut += min(  (PVector.dist(cut0,p)- cutSize)*.5 ,0);            
      cut += min( (mohawk - abs(nrm.x) ) *4. ,0);
      cut += min( (PVector.dist(faceCut0,p)- faceCutSize)*.5 ,0);
      cut += constrain( (faceCutEnd - nrm.y ) *4. ,-1,0.);

      // tilt normal
      
      
      nrm.x += (noise(p.x*clumpScale,p.y*clumpScale,p.z*clumpScale)*2.-1 )*clumpStrength ;
      nrm.y += (noise(p.y*clumpScale,p.z*clumpScale,p.x*clumpScale)*2.-1 )*clumpStrength ;
      nrm.z += (noise(p.z*clumpScale,p.x*clumpScale,p.y*clumpScale)*2.-1 )*clumpStrength ;
      
      cut = sqrt(cut);
      float ranlen = noise(p.x*8.,p.y*8,p.z*8.)*messy + max(1.-messy,0.);
      ranlen*=cut;
     
      if ( ranlen < 0.01)  // hair too short
        continue;
      float clength = aclength*ranlen;
       
      PVector[] pts = new PVector[4];
      pts[0] = p;
      
      pts[1] = new PVector();
      pts[1].set(nrm);
      pts[1].mult(clength*.25f);
      pts[1].add(p);
        
      pts[3] = new PVector();
      pts[3].set( nrm);
      pts[3].mult(clength);
      pts[3].add(p);
      
      pts[2] = new PVector();
      pts[2].set(nrm);
      pts[2].mult(clength*.75f);
      pts[2].add(p);
       
       cps[ cnt] = new Curve( pts,ranlen);
       cnt++;
    }
    Curve[] rcps = new Curve[cnt];
    for (int i =0; i < rcps.length; i++)
    {
      rcps[i]=cps[i];
    }
   return rcps;
}
