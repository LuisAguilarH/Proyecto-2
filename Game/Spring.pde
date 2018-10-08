

class Spring {

  // este es el objeto de box2d que crearemos
  MouseJoint mouseJoint;

  Spring() {
    // esto primero en lo que no existe
    mouseJoint = null;
  }

  // Si existe establecemos su objetivo en la ubicación del ratón.
  void update(float x, float y) {
    if (mouseJoint != null) {
      
      Vec2 mouseWorld = box2d.coordPixelsToWorld(x,y);
      mouseJoint.setTarget(mouseWorld);
    }
  }

  void display() {
    if (mouseJoint != null) {
      // podemos obtener puntos
      Vec2 v1 = new Vec2(0,0);
      mouseJoint.getAnchorA(v1);
      Vec2 v2 = new Vec2(0,0);
      mouseJoint.getAnchorB(v2);
      // Convertirlos en coordenadas de pantalla
      v1 = box2d.coordWorldToPixels(v1);
      v2 = box2d.coordWorldToPixels(v2);
      // dibujamos una linea
      stroke(0);
      strokeWeight(1);
      line(v1.x,v1.y,v2.x,v2.y);
    }
  }


 // Esta es la función clave donde adjuntamos el resorte a una x, y ubicación
   // y la ubicación del objeto Box
  void bind(float x, float y, Box box) {
    // Define el joint
    MouseJointDef md = new MouseJointDef();
    
    // El cuerpo A es solo un cuerpo falso para simplificar (no hay nada en el mouse)
    md.bodyA = box2d.getGroundBody();
    // Body 2 es la caja
    md.bodyB = box.body;
    // obtenemos la locacion del mouse
    Vec2 mp = box2d.coordPixelsToWorld(x,y);
    // y esto es el objetivo
    md.target.set(mp);
    //Algunas cosas sobre qué tan fuerte y hinchable debería ser spring
    md.maxForce = 1000.0 * box.body.m_mass;
    md.frequencyHz = 5.0;
    md.dampingRatio = 0.9;

  

    //  el joint!
    mouseJoint = (MouseJoint) box2d.world.createJoint(md);
  }

  void destroy() {
    //al soltar el raton se desase
    if (mouseJoint != null) {
      box2d.world.destroyJoint(mouseJoint);
      mouseJoint = null;
    }
  }

}
