/*
  FSOSS 2010
  Andor Salga
  Core
*/

var sounds = {};
setTimeout(function() {
  sounds.hit = sfxr.createEffect("3,0.039,0.280,0.795,,0.341,,-0.354,-0.073,0.088,0.046,0.182,0.636,0.087,-0.025,,-0.251,-0.124,0.987,-0.008,0.028,0.049,-0.088,0.500");
  sounds.deflect = sfxr.createEffect("0,,0.114,,0.144,0.439,,,,,,,,0.433,,,,,1.000,,,0.100,,0.500");
  sounds.lose = sfxr.createEffect("2,0.993,0.050,0.139,0.224,0.879,,-0.456,-0.131,0.133,0.064,-0.607,-0.803,0.528,-0.007,0.785,-0.087,-0.034,0.997,-0.015,0.229,0.912,0.128,0.649");
}, 500);

PFont font;
boolean gameOver = false;

/*
*/
class Paddle{
  private PVector direction;
  
  Paddle(){
    direction = new PVector(0, 0);
  }
  
  void render(){
    pushMatrix();
    translate(width/2, height/2);
   
    PVector top = new PVector(1, 0);
    float d = top.dot(direction);
    
    if(direction.y < 0){
      rotate(-acos(d));
    }
    else{
      rotate(acos(d));
    }
    
    strokeWeight(5);
    stroke(99, 33, 33);
    
    // Prevent it from looking like a pie
    noFill();
    
    //
    arc(0, 0, 100, 100, -PI/2 + PI/6, PI/2 - PI/6 );
    popMatrix();
  }
  
  void setDirection(PVector dir){
    direction = dir;
  }
  
  PVector getDirection(){
    return direction;
  }
}

/*
*/
class Core{
  private float health;
  private float lastSize;
  private float op;
  private boolean regenerating;
  
  Core(){
    health = 50.0;
    regenerating = false;
  }
  
  float getHealth(){
    return health;
  }
  
  void render(){
  
    op -= 5;
    if(op < 0){
      op = 0;
    }
    lastSize += 0.5;

    // draw fading ellipse
    strokeWeight(1);
    stroke(66, 33, 33, op);
    fill(66, 33, 33, op);
    
    ellipse(width/2, height/2, lastSize, lastSize);

    if(regenerating){
      stroke(33, 99, 33, 255);
      fill(33, 99, 33, 100);
    }
    else{
      // draw the core
      stroke(33, 66, 99, 255);
      fill(33, 66, 99, 100);
    }
    
    ellipse(width/2, height/2, health, health);
  }

  void hit(float amt){
    lastSize = health;
    op = 250;
    health -= amt;
    
    if(sounds.hit){sounds.hit.play();}
    
    if(health < 0){
      health = 0;
    }
  }
  
  void regen(float f){
    if(f + health < 50){
      health += f;
      regenerating = true;
    }
    else{
      regenerating = false;
    }
  }
  
  float getSize(){
    return health;
  }
  
  PVector getPos(){
    return new PVector(width/2, height/2);
  }
}

class Missle{
  private PVector pos;
  private PVector vel;
  float size;
  
  Missle(){
    pos = new PVector(0, 0);
    vel = new PVector(0, 0);
    size = 5;
    
    setRandom();
  }
  
  Missle(PVector p, PVector v, float s){
    pos = p;
    vel = v;
    size = s;
  }
  
  PVector getPos(){
    return pos;
  }
  
  PVector getVel(){
    return vel;
  }
  
  float getSize(){
    return size;
  }
  
  void render(){
    noStroke();
    fill(99, 66, 33);
    ellipse(pos.x, pos.y, size, size);
  }
  
  void setRandom(){
    PVector v = new PVector( random(-1,1), random(-1,1));
    v.normalize();
    
    PVector t = new PVector(v.x, v.y);
    float rand = random(1.5, 2);
    t.mult(width * random(1,3)/rand);
    
    pos.x = t.x + width/2;
    pos.y = t.y + height/2;
    
    PVector pp = new PVector(-t.x, -t.y);
    pp.normalize();

    // pixels/second
    float speed = random(50, 80);
 
    vel.x = pp.x * speed;
    vel.y = pp.y * speed;
  }
  
  void update(float delta){
    pos.x += vel.x * delta;
    pos.y += vel.y * delta;
   }
}

// Global vars
int blocked = 0;
int lastTimeTaken = 0;
Paddle paddle;
Core c;
ArrayList missles;
ParticleSystem Psys;

class Particle{
  private PVector position;
  private PVector velocity;
  private float ageInSeconds;
  private float lifeTimeInSeconds;
  private boolean alive;
  
  Particle(){
    reset();
  }
  
  void reset(){
    position = new PVector(0, 0);
    velocity = new PVector(0, 0);
    alive = false;
    ageInSeconds = 0;
    lifeTimeInSeconds = 0;
  }
  
  void setAge(float a){
    if(a >= 0){
      ageInSeconds = a;
    }
  }
  void setLifeTime(float l){
    if(l > 0){
      lifeTimeInSeconds = l;
    }
  }
  
  void setVelocity(PVector v){velocity = v;}
  void setPosition(PVector p){position = p;}
  
  boolean isAlive(){
    return alive;
  }
  
  void render(){
    strokeWeight(3);
    stroke(99, 66, 33, 255 * (1-(ageInSeconds/lifeTimeInSeconds)));
    point(position.x, position.y);
  }
  
  void setAlive(boolean a){alive = a;}
  
  void update(float delta){
    position.x += velocity.x * delta;
    position.y += velocity.y * delta;
    
    ageInSeconds += delta;
    
    if(ageInSeconds > lifeTimeInSeconds){
      alive = false;
    }
  }
}

void setup(){
  size(2500,1400);
  
  font = createFont("verdana", 40);
  textFont(font, 50);
  
  c = new Core();
  paddle = new Paddle();
  missles = new ArrayList();
  
  Psys = new ParticleSystem(420);
  
  for(int i = 0; i < 20; i++){
    missles.add(new Missle());
  }
}


/*
  Update all scene objects
*/
void update(float deltaTime){

  // Remove the following lines if using in P5
  
  c.regen(0.1);
    
  for(int i = 0; i < missles.size(); i++){
    Missle m = (Missle)missles.get(i);
    m.update(deltaTime);
  
    //
    if(m.getPos().x < 0 || m.getPos().y < 0 || m.getPos().x > width || m.getPos().y > height){
       m.setRandom();
    }
   
    // first check
    // 
    if( circleCollision(m.getPos(), m.getSize()/2, c.getPos(), 50) &&
        !circleCollision(m.getPos(), m.getSize()/2, c.getPos(), 45) ){
      
      PVector d = new PVector(paddle.getDirection().x, paddle.getDirection().y);
      d.normalize();
      
      PVector mDir = new PVector(m.getVel().x, m.getVel().y);
      mDir.normalize();
      mDir.mult(-1);
      
      float test = d.dot(mDir);
      
      if(acos(test) < 1.1){
        blocked++;

        Psys.setPosition(m.getPos());
        
        PVector vtest = m.getVel();
        vtest.normalize();
                
        // perp
        PVector perp1 = new PVector(vtest.y, -vtest.x);
        PVector perp2 = new PVector(-vtest.y, vtest.x);
        
        PVector ab = new PVector(perp1.x-vtest.x/2.0f, perp1.y-vtest.y/2.0f);
        PVector ab2 = new PVector(perp2.x-vtest.x/2.0f, perp2.y-vtest.y/2.0f);
        
        //println(vtest);
        ab.mult(30);
        ab2.mult(30);
                
        Psys.setVelocityRange(ab.get(), ab2.get());
        Psys.setLifeTimeRange(0.5,1.8);
        Psys.emit(10);

        if(sounds.deflect){sounds.deflect.play();}
        m.setRandom();
      }
    }
    
    // check if missle hit the core
    if(circleCollision(m.getPos(), m.getSize()/2, c.getPos(), c.getSize()/2 ) ){
      m.setRandom();
      c.hit(10);
     }
   }
   
   PVector dir = new PVector(mouseX- width/2, mouseY-height/2);
   dir.normalize();
   paddle.setDirection(dir);
}

class ParticleSystem{
  private ArrayList particles;

  private PVector position;
  private int numParticles;
  
  private PVector velocityMin;
  private PVector velocityMax;
  
  private float lifeTimeMin;
  private float lifeTimeMax;
  
  ParticleSystem(int count){
    position = new PVector(0, 0);
  
    particles = new ArrayList();
    
    velocityMin = new PVector(0, 0);
    velocityMax = new PVector(0, 0);
    
    lifeTimeMin = 0.0f;
    lifeTimeMax = 0.0f;

    numParticles = count;
    for(int i = 0; i < count; i++){
      particles.add(new Particle());
    }
  }
  
  void update(float delta){
    for(int i = 0; i < particles.size(); i++){
      Particle p = (Particle)particles.get(i);
      if(p.isAlive()){
        p.update(delta);
      }
    }
  }
  
  void setLifeTimeRange(float min, float max){
    lifeTimeMin = min;
    lifeTimeMax = max;
  }

  float getRandomLifeTime(){
    return random(lifeTimeMin, lifeTimeMax);
  }  

  PVector getRandomVelocity(){
    return new PVector( random(velocityMin.x, velocityMax.x), 
                        random(velocityMin.y, velocityMax.y));
  }
  
  void setVelocityRange(PVector pmin, PVector pmax){
    velocityMin = pmin;
    velocityMax = pmax;
  }
  
  void emit(int toEmit){
    int emitCount = 0;
    if(toEmit > 0){
      for(int i = 0; emitCount < toEmit && i < particles.size(); i++){
        Particle p = (Particle)particles.get(i);
        if(p.isAlive() == false){
            p.setVelocity(getRandomVelocity());
            p.setPosition(position.get());
            p.setAge(0);
            p.setAlive(true);
            p.setLifeTime(getRandomLifeTime());
            emitCount++;
        }
      }
    }
  }
  
  void setPosition(PVector pos){
    position = pos;
  }
  
  void render(){
    for(int i = 0; i < particles.size(); i++){
      Particle p = (Particle)particles.get(i);
      if(p.isAlive()){
        p.render();
      }
    }
  }
}

float getDeltaInSeconds(){
  int deltaInMillis = millis() - lastTimeTaken;
  float deltaInSeconds = deltaInMillis/1000.0f;
  lastTimeTaken = millis();
  return deltaInSeconds;
}

/*
  Gets called by Pjs
*/
void draw(){
  scale(3);
  translate(-900, -500);
  if(!gameOver){
    float deltaInSeconds = getDeltaInSeconds();
    update(deltaInSeconds);
    Psys.update(deltaInSeconds);
    
    background(0);
  
    Psys.render();
    
    for(int i = 0; i < missles.size(); i++){
      Missle m = (Missle)missles.get(i);
      m.render();
    }
   
    c.render();
    paddle.render();
    
    if(c.getHealth() < 1){
      fill(255, 255, 255, 20);
      rect(0, 0, width, height);
      gameOver = true;
      fill(255);
      text("Game Over", width/2 - textWidth("Game Over")/2, height/2);
      
      if(sounds.lose){sounds.lose.play();}
    }
    
    fill(255);
    text( "" + blocked * 100, 20, 40);
  }
}

/*
  test circle/circle collision
  returns true if circles collided
*/
boolean circleCollision(PVector cPos1, float cSize1, PVector cPos2, float cSize2){
  PVector vec = new PVector(cPos1.x - cPos2.x, cPos1.y - cPos2.y);
  return (vec.mag() < cSize1 + cSize2);
}

