

class Box {

  //Necesitamos hacer un seguimiento de un cuerpo y una anchura y altura.
  Body body;
  float w;
  float h;

  // Constructor
  Box(float x_, float y_) {
    float x = x_;
    float y = y_;
    w = 40;
    h = 40;
    // agregar box a el box2d world
    makeBody(new Vec2(x, y), w, h);
    body.setUserData(this);
  }

  //esta funcion remueve la particula de box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  boolean contains(float x, float y) {
    Vec2 worldPoint = box2d.coordPixelsToWorld(x, y);
    Fixture f = body.getFixtureList();
    boolean inside = f.testPoint(worldPoint);
    return inside;
  }

  // dibujo la caja
  void display() {
    //Miramos el cuerpo y obtenemos la posición de la pantalla.
    Vec2 pos = box2d.getBodyPixelCoord(body);
    //obtengo el angulo de rotacion
    float a = body.getAngle();

    rectMode(PConstants.CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(0,0,0,0);
    stroke(0);
    //rect(0, 0, w, h);
    popMatrix();
  }

  // esta funcion agrega un rectangulo a box2d world
  void makeBody(Vec2 center, float w_, float h_) {
    //defino y creo el body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);

    // Defino un polygon (esto usamos para el rectangulo)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    // Defino una fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    //estos parametros controlan la colision 
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    body.createFixture(fd);


    // velocidad aleatoria
    body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    body.setAngularVelocity(random(-5, 5));
  }
}
