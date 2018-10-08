

class Attractor {
  
  // Necesitamos hacer un seguimiento de un cuerpo y un radio.
  Body body;
  float r;

  Attractor(float r_, float x, float y) {
    r = r_;
    // Defino un body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    // su posicion
    bd.position = box2d.coordPixelsToWorld(x,y);
    body = box2d.world.createBody(bd);

    // Haz de la forma del cuerpo un círculo.
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    
    body.createFixture(cs,1);

  }

// Fórmula para la atracción gravitacional
   // voy a calcular esto en coordenadas de "mundo"
   // No hay necesidad de convertir a píxeles y volver
  Vec2 attract(Particle m) {
    float G = 100;
    // Fuerza de fuerza
     // clone () nos hace una copia
    Vec2 pos = body.getWorldCenter();    
    Vec2 moverPos = m.body.getWorldCenter();
    // Vector apuntando para mover el atractor
    Vec2 force = pos.sub(moverPos);
    float distance = force.length();
    // Mantener la fuerza dentro de los límites.
    distance = constrain(distance,1,5);
    force.normalize();
    //la masa del atractor es 0 porque está fija, por lo que no se puede usar
    float strength = (G * 1 * m.body.m_mass) / (distance * distance); // calcular la fuerza de gravedad
    force.mulLocal(strength);         // obtener vector fuerza --> magnitud * direcion
    return force;
  }

  void display() {
   // Miramos cada cuerpo y obtenemos la posición de la pantalla.
    Vec2 pos = box2d.getBodyPixelCoord(body);
   //consigo angulo de rotacion
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    fill(0);
    stroke(0);
    strokeWeight(1);
    ellipse(0,0,r*2,r*2);
    popMatrix();
  }
}
