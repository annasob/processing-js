


var particleCount = 100; 
var particles = new ArrayList(particleCount+1);; 
var maxLines = 7000; 
var angle = 1.57; 
var canvas = new Canvas(); 
var col = 30; 


processing.setup = function setup() {
  size(500,500); 
  colorMode(HSB,100); 
                      
  for (var i = particleCount; i >= 0; i--) { 
    particles[i] = new Particle();
  }
  frameRate(30); 
};


processing.draw = function draw() {
  translate(width/2,height/2); 
  background(0); 
  angle -= 0.01; 
  if (canvas.lines.size() < maxLines) { 
    col += 0.7; 
    if (col > 99) { col = 0; } 
    for (var i = particleCount; i >= 0; i--) { 
      var particle =  particles[i]; 
                                                   
                                                   
      particle.update(); 
    } 
  }
  canvas.draw(); 
};


function Particle() {
 this.current = new PVector();
this.speed = 0;
this.phi = 0;
this.theta = 0;
this.far = false;

addMethod(this, 'update', (function(public) { return function() {
    if (!public.far) { 
      if (dist(public.current.x,public.current.y,public.current.z, 0,0,0) < 250) { 
        public.phi += random(-0.05, 0.2);  
        public.theta += random(-0.3, 0.3); 
        var previous = public.current.get(); 
        var sctheta = public.speed * cos(public.theta); 
        public.current.add(new PVector(sctheta * cos(public.phi) - 0.035 * public.current.z,
                                public.speed * sin(public.theta),
                                sctheta * sin(public.phi) + 0.035 * public.current.x)); 
                                                                          
        canvas.addLine(new Line(public.current,previous)); 
      }
      else {
        public.far = true; 
      }
    }
  };})(this));var update = this.update;

if ( arguments.length === 0 ) {

    this.theta = random(0,6.28); 
    this.phi = random(0,3.14);   
    this.speed = random(2,7);    
      
      
      
      
  }

}


function Line() {
 this.preA  = new PVector();
this.preB  = new PVector();
this.postA = new PVector();
this.postB = new PVector();
this.lineHue = 0;
this.lineBrightness = 0;

addMethod(this, 'draw', (function(public) { return function() {
    
    
    public.postA.set(public.preA);
    public.postB.set(public.preB);
    
    rotateVector(public.postA, angle, angle * 0.7);
    rotateVector(public.postB, angle, angle * 0.7);
    
    public.postA.mult(1.8 + cos(angle * 2));
    public.postB.mult(1.8 + cos(angle * 2));
    
    var temp1 = new PVector(int(public.postA.x - public.postA.z), int((public.postA.x + public.postA.z)/2 - public.postA.y));
    var temp2 = new PVector(int(public.postB.x - public.postB.z), int((public.postB.x + public.postB.z)/2 - public.postB.y));
    stroke(public.lineHue, 100, public.lineBrightness); 
    line(temp1.x, temp1.y, temp2.x, temp2.y); 
    public.lineHue -= 0.8; 
    if (public.lineHue < 1) { 
      public.lineHue = 100;
    }
  };})(this));var draw = this.draw;
addMethod(this, 'added', (function(public) { return function() {
    return public.postA.x + public.postA.y + public.postA.z + public.postB.x + public.postB.y + public.postB.z;
  };})(this));var added = this.added;

if ( arguments.length === 2 ) {
 var point1 = arguments[0];
 var  point2 = arguments[1];

    
    this.preA.set(point1);
    this.preB.set(point2);
    this.lineHue = int(col + random(-3,3)); 
                                       
    this.lineBrightness = 125 - dist((this.preA.x + this.preB.x) / 2,(this.preA.y + this.preB.y) / 2,(this.preA.z + this.preB.z) / 2, 0,0,0) * 0.5; 
                                                                                                                 
  }

}


processing.rotateVector = function rotateVector(coord, xzAngle, yzAngle) { 
  
  var c = cos(xzAngle);
  var s = sin(xzAngle);
  coord.set(c * coord.x - s * coord.z, coord.y, s * coord.x + c * coord.z); 
  
  c = cos(yzAngle);
  s = sin(yzAngle);
  coord.set(coord.x, c * coord.y - s * coord.z, s * coord.y + c * coord.z); 
};


function Canvas() {
 this.lines = new Vector();

addMethod(this, 'addLine', (function(public) { return function(a) {
    public.lines.addElement(a); 
  };})(this));var addLine = this.addLine;
addMethod(this, 'draw', (function(public) { return function() {
    if (frameCount % 30 == 0) { 
      public.lines = zBuffer(public.lines); 
    }
    for (var i = (public.lines.size() - 1); i >= 0; i--) { 
      ( public.lines.get(i)).draw();
    }
    
    
  };})(this));var draw = this.draw;

if ( arguments.length === 0 ) {
 }

}


processing.zBuffer = function zBuffer(lines) {
  Collections.sort(lines, new ZComparator()); 
  return lines;
};


function ZComparator() {
 this.__psj_classs = new ArrayList(["Comparator"]);

addMethod(this, 'compare', (function(public) { return function(o1, o2) {
    
    var item1 = ( o1).added();
    var item2 = ( o2).added();
    return item1.compareTo(item2);
  };})(this));var compare = this.compare;


}


processing.keyPressed = function keyPressed() {
  canvas = new Canvas(); 
  
  for (var x = particleCount; x >= 0; x--) {
    particles[x] = new Particle();
  }
};
;
