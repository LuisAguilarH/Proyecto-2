import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
//Background
PImage background;
PImage car;
PImage start_background;
boolean state=false;

// la referencia al mundo box2d
Box2DProcessing box2d;

// solo una caja
Box box;

// Un ArrayList de partículas que caerán en la superficie.
ArrayList<Particle> particles;

//el spring que se adjuntará a la caja del ratón.
Spring spring;
Texture texture;

// Perlin valores de ruido
float xoff = 0;
float yoff = 1000;
int screen=0;
int score=0;

void setup() {
  size(962,562);
  smooth();
  background  = loadImage("fondochoque.jpg");
  start_background = loadImage("inicio.jpg");
  car  = loadImage("car.png");
  //inicialice box2d y creo el mundo
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
box2d.setGravity(0,-30);
  //para activa la colision
  box2d.listenForCollisions();

  // creo caja
  box = new Box(width/2,height/2);

  // el spring (lo voy inicializar al hacer clic)
 
  spring = new Spring();
  spring.bind(width/2,height/2,box);

  // crea la lista
  particles = new ArrayList<Particle>();


}
void draw(){
  switch(screen){
    case 0:
      background(start_background);
      textSize(30);
      text("click para comenzar a jugar",  290, 500);
      fill(255);
      if(mousePressed)
        screen = 1;
      break;
      
      case 1:
      background(0);
      textSize(24);
      text("mueve tu vehiculo con el mouse, colisiona con todo y evita las patrullas\n \n \n                                  Presiona Tab para continuar", 75, 200);
      fill(255);
      if(key == TAB)
      screen = 2;
      break;
      
    case 2:
      game();
      if(state)
        screen = 3;
      break;
      
    case 3:
        background(255,255,255);
        fill(0,0,0);
        text("Final Score: ",(width/2)-140,height/2);
        text(score,(width/2)+85,height/2);
        text( "presiona enter para reiniciar", 200,500);
        if(key == ENTER)
        screen = 0;
      break;
      
  }
}
void game() {  
  background(background);
  fill(255,255,255);
  textSize(40);
  text("Score: ",30,50);
  text(score,150,50);
  image(car, mouseX-25, mouseY-25,60,60);
   spring.update(mouseX,mouseY);
  box.body.setAngularVelocity(0);
  if (random(10) < 0.2) {
    float sz = random(10,15);
    particles.add(new Particle(random(width),0,sz));
  }
  //Atract

  box2d.step();

  // hacer cordenada en x.y 
  float x = noise(xoff)*width;
  float y = noise(yoff)*height;
  xoff += 0.01;
  yoff += 0.01;


  // todas las particulas
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.display();
    // las particulas que sales se eliminan
    if (p.done()) {
      particles.remove(i);
      break;
    }
  }
  
  // dibuja caja
  box.display();

}


// Collision 
void beginContact(Contact cp) {
  // obtener ambos fixtures
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // obtener bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();
  // obtener nuestros objetos 
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  // Si el objeto 1 es una caja, entonces el objeto 2 debe ser una partícula
   // Nota ignorare partículas en colisiones
  if (o1.getClass() == Box.class) {
    Particle p = (Particle) o2;
    state = p.change();
    score+=10;
  } 
  // Si el objeto 2 es una caja, entonces el objeto 1 debe ser una partícula
  else if (o2.getClass() == Box.class) {
    Particle p = (Particle) o1;
    state = p.change();
    score+=10;
  }
}


// los objetos dejan de tocarse
void endContact(Contact cp) {
}
