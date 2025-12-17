/* Modify these values to adjust the generated patterns */

final double STARTING_POS_X = 255;
final double STARTING_POS_Y = 255;
final double STARTING_ANGLE = 45;
final int STROKE_WIDTH = 2;
final int ITERATIONS = 15;
final boolean USE_CURVES = false;

// Set USE_LSYSTEM to 0, 1, or 2 for different patterns
// Each has a different degree of complexity, so you should
// change the number of iterations between them, or else it
// may take too long for some of them to generate
// Recommended Iterations:
// 0: 80
// 1: 80
// 2: 15 (Run time increases exponentially, so don't go too much higher)
final int USE_LSYSTEM = 2;

/* ---------------------------------------------------- */


LSystem lsystem;
Turtle turt;

void generate() {
    turt = new Turtle(STARTING_POS_X, STARTING_POS_Y, STARTING_ANGLE, ITERATIONS, USE_CURVES);
    
    lsystem = new LSystem("X");
    
    switch (USE_LSYSTEM) {
        case 0: setupLsystem1(lsystem); break;
        case 1: setupLsystem2(lsystem); break;
        case 2: setupLsystem3(lsystem); break;
    }
    
    strokeWeight(STROKE_WIDTH);
    lsystem.draw(ITERATIONS);
    turt.resetState(512, 512, STARTING_ANGLE + 180);
}

void setup() {
    size(512, 512);
    background(255);
    generate();
}

void setupLsystem1(LSystem lsystem) {
    lsystem.addRule('X').with("[/FB][\\FB]");
    lsystem.addRule('B').with("[/FT][\\FT]");
    lsystem.addRule('T').with("FT", 0.95).with("B", 0.05);
    lsystem.addRule('+').with("++", 0.03).with("+", 0.97);
    lsystem.addRule('-').with("--", 0.03).with("-", 0.97);
    
    
    lsystem.addRule('F', new Runnable() {public void run(){
        double moveAmount = Math.random() * 2.0 + 5;
        turt.moveForward(moveAmount);
    }});
    lsystem.addRule('+', new Runnable() {public void run(){turt.rotate(7 + Math.random() * 5);}});
    lsystem.addRule('-', new Runnable() {public void run(){turt.rotate(-7 - Math.random() * 5);}});
    lsystem.addRule('/', new Runnable() {public void run(){turt.rotate(90);}});
    lsystem.addRule('\\', new Runnable() {public void run(){turt.rotate(-90);}});
    lsystem.addRule('[', new Runnable() {public void run(){turt.branch();}});
    lsystem.addRule(']', new Runnable() {public void run(){turt.unbranch();}});
}

void setupLsystem2(LSystem lsystem) {
    lsystem.addRule('X').with("[/FB][\\FB]");
    lsystem.addRule('B').with("[+FT][-FT]");
    lsystem.addRule('T').with("FT", 0.95).with("B", 0.05);
    
    lsystem.addRule('F', new Runnable() {public void run(){
        double moveAmount = Math.random() * 2 + 5;
        turt.moveForward(moveAmount);
    }});
    lsystem.addRule('+', new Runnable() {public void run(){turt.rotate(45);}});
    lsystem.addRule('-', new Runnable() {public void run(){turt.rotate(-45);}});
    lsystem.addRule('/', new Runnable() {public void run(){turt.rotate(90);}});
    lsystem.addRule('\\', new Runnable() {public void run(){turt.rotate(-90);}});
    lsystem.addRule('[', new Runnable() {public void run(){turt.branch();}});
    lsystem.addRule(']', new Runnable() {public void run(){turt.unbranch();}});
}

void setupLsystem3(LSystem lsystem) {
    lsystem.addRule('X').with("[Ft][//Ft][////Ft][//////Ft]");
    lsystem.addRule('T').with("[+FT][-FT]", 0.75).with("F", 0.25);
    lsystem.addRule('t').with("[+FT][-FT]");
    
    lsystem.addRule('F', new Runnable() {public void run(){turt.moveForward(15);}});
    lsystem.addRule('+', new Runnable() {public void run(){turt.rotate(12 + Math.random() * 5);}});
    lsystem.addRule('-', new Runnable() {public void run(){turt.rotate(-12 - Math.random() * 5);}});
    lsystem.addRule('/', new Runnable() {public void run(){turt.rotate(45 + Math.random() * 5);}});
    lsystem.addRule('\\', new Runnable() {public void run(){turt.rotate(-45 - Math.random() * 5);}});
    lsystem.addRule('[', new Runnable() {public void run(){turt.branch();}});
    lsystem.addRule(']', new Runnable() {public void run(){turt.unbranch();}});
}

void draw() {
}

void mouseClicked() {
    background(255);
    generate();
}

void keyPressed() {
    if (key == 'p') {
        saveFrame();
    }
}