

class Particle {

  //cuerpo y radio
  Body body;
  float r;
  float type;
  PImage carblue = loadImage("carblue.png");
  PImage carred = loadImage("carred.png");
  PImage carwhite = loadImage("carwhite.png");
  PImage carpolice = loadImage("carpolice.png");
  PImage sangre = loadImage("sangre.png");
  color col;


  Particle(float x, float y, float r_) {
    r = r_;
    type=random(.70);
    // esta parte pone la particula en Box2d world
    makeBody(x, y, r);
    body.setUserData(this);
    col = color(random(255));
  }

  // esto remueve particula de box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  //calavera con sangre
  boolean change() {
     image(sangre, 1, 1);
    if(type>0.2)
    return false;
    else
    return true;
  }

  
  boolean done() {
    // Encontremos la posición de pantalla de la partícula.
    Vec2 pos = box2d.getBodyPixelCoord(body);
    
    if (pos.y > height+r*2) {
      killBody();
      return true;
    }
    return false;
  }


  
  void display() {
    // Miramos cada cuerpo y obtenemos la posición de la pantalla.
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // obtengo el angulo de rotacion
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x, pos.y);
    //rotate(a);
    fill(col);
    stroke(0);
    strokeWeight(1);
    rect(0, 0, r*2, r*2);
    //Añadamos una línea para que podamos ver la rotación.
    line(0, 0, r, 0);
    popMatrix();
    if(type>0.2)
    image(carblue,pos.x-30,pos.y-30,60,60);
    if(type>0.3)
    image(carwhite,pos.x-30,pos.y-30,60,60);
    if(type>0.4)
    image(carred,pos.x-30,pos.y-30,60,60);
     if(type<0.2)
    image(carpolice,pos.x-30,pos.y-30,60,60);
     
    
  }

  // Aquí está nuestra función que agrega la partícula a la Box2D world
  void makeBody(float x, float y, float r) {
    // Defino un body
    BodyDef bd = new BodyDef();
    // esta posicion
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.createBody(bd);

    // creo el cuerpo 
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // parametros que afectan la densidd, friccion
    fd.density = .50;
    fd.friction = 1;
    fd.restitution = 0.33;

    // textura de body
    body.createFixture(fd);

    body.setAngularVelocity(random(80,250));
  }
}
