import java.util.List;
import processing.pdf.*;

// Since we're saving as a PDF, we unfortunately won't be able to see the
// generated image before saving it

// The width of the canvas in pixels
final int CANVAS_WIDTH = 512;

// The height of the canvas in pixels
final int CANVAS_HEIGHT = 512;

// NOTE: When making the PDF, the canvas width and height need to be  hard-coded
// in the size() function, so both those values and the two constants above have
// to be modified to change the canvas size

// The number of rows the grid will generate with
final int NUM_ROWS = 16;

// The number of columns the grid will generate with
final int NUM_COLUMNS = 16;

// The percentage of line segments in the grid that will draw
final double NET_DENSITY = 0.7;

// The percentage of dots that will draw
final double DOT_DENSITY = 0.50;

// The percentage of broken lines
final double BROKEN_DENSITY = 0.1;

// The potential radii of dots that can be drawn, all with equal probability
final double[] DOT_SIZES = new double[]{4, 8, 12, 14.5};
//final double[] DOT_SIZES = new double[]{4, 8, 12, 16};

// How rigid the grid is, where 1 is completely uniform
final float RIGIDITY = 0.8;

// If true, the background will be black and the grid will be white
final boolean INVERT_COLOR = false;

// If true, occasionally draw the inset circles
final boolean DRAW_INSET_DOTS = true;

// How vivid the color of the grid lines are (from 0 to 1)
final float LINE_DARKNESS = 0.3;

// If true, some intersections are displaced very slighly
final boolean USE_DISRUPTION = false;

// The maximum disruption along a single axis
final float DISRUPTION_AMOUNT = 0.0;

// The density of diagonals
final float DIAGONAL_DENSITY = 0.45;

// The percentage of faded lines
final float FADED_DENSITY = 0.20;

//void settings() {
//    size(CANVAS_WIDTH, CANVAS_HEIGHT);
//}

void setup() {
    //size(512, 512);
    size(512, 512, PDF, "image.pdf");
    generate();
    //save("7-20.tif");
    exit();
}

void generate() {
    background(INVERT_COLOR ? 0 : 255);
    double cellWidth = CANVAS_WIDTH / NUM_COLUMNS;
    double cellHeight = CANVAS_HEIGHT / NUM_ROWS;
    noStroke();
    
    List<List<Float>> xs = new ArrayList();
    List<List<Float>> ys = new ArrayList();
    
    for (int row = 0; row < NUM_ROWS; row++) {
        List<Float> curXs = new ArrayList();
        List<Float> curYs = new ArrayList();
        for (int col = 0; col < NUM_COLUMNS; col++) {
            double curCellX = col * cellWidth;
            double curCellY = row * cellHeight;
            
            float centeringOffset = (RIGIDITY) / 2.0;
            double dotX = curCellX + (centeringOffset + random(1 - RIGIDITY)) * cellWidth;
            double dotY = curCellY + (centeringOffset + random(1 - RIGIDITY)) * cellHeight;
            
            if (USE_DISRUPTION) {
                if (row != 0 && col != 0 && row < NUM_ROWS - 1 && col < NUM_COLUMNS - 1) {
                    if (Math.random() < 0.25) {
                        dotX += (Math.random() * 2.0 - 1.0) * DISRUPTION_AMOUNT;
                    }
                    
                    if (Math.random() < 0.1) {
                        dotY += (Math.random() * 2.0 - 1.0) * DISRUPTION_AMOUNT;
                    }
                }
            }
                
            curXs.add((float)dotX);
            curYs.add((float)dotY);
        }
        xs.add(curXs);
        ys.add(curYs);
    }
    
    for (int row = 0; row < NUM_ROWS; row++) {
        for (int col = 0; col < NUM_COLUMNS; col++) {
            
            // Draw the vertical lines
            if (row + 1 < NUM_ROWS && Math.random() < NET_DENSITY) {
                drawLine(xs.get(row).get(col), ys.get(row).get(col), xs.get(row + 1).get(col), ys.get(row + 1).get(col));
            }
            
            // Draw the horizontal lines
            if (col + 1 < NUM_COLUMNS && Math.random() < NET_DENSITY) {
                drawLine(xs.get(row).get(col), ys.get(row).get(col), xs.get(row).get(col + 1), ys.get(row).get(col + 1));
            }
            
            // Draw the diagonal lines
            if (Math.random() < DIAGONAL_DENSITY) {
                if (row + 1 < NUM_ROWS && col + 1 < NUM_COLUMNS) {
                    drawLine(xs.get(row).get(col), ys.get(row).get(col), xs.get(row + 1).get(col + 1), ys.get(row + 1).get(col + 1));
                }
            }
            if (Math.random() < DIAGONAL_DENSITY) {
                if (row + 1 < NUM_ROWS && col + 1 < NUM_COLUMNS) {
                    drawLine(xs.get(row).get(col + 1), ys.get(row).get(col + 1), xs.get(row + 1).get(col), ys.get(row + 1).get(col));
                }
            }
        }
    }
    
    noStroke();
    for (int row = 0; row < NUM_ROWS; row++) {
        for (int col = 0; col < NUM_COLUMNS; col++) {
            float dotX = xs.get(row).get(col);
            float dotY = ys.get(row).get(col);
            float rad = drawDot(dotX, dotY, 10000, false);
            if (DRAW_INSET_DOTS) {
                drawDot(dotX, dotY, rad, true);
            }
        }
    }
}

color getStrokeColor() {
    int whiteBgStroke = (int)(255 * LINE_DARKNESS);
    int blackBgStroke = (int)((1 - LINE_DARKNESS) * 255);
    return (INVERT_COLOR ? whiteBgStroke : blackBgStroke);
}

void drawLine(float x1, float y1, float x2, float y2) {
    if (random(1) < FADED_DENSITY) {
        stroke(getStrokeColor(), random(40, 120));
    }
    else {
        stroke(getStrokeColor());
    }
    if (random(1) < BROKEN_DENSITY) {
        float len = sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2));
        PVector dir = (new PVector(x2 - x1, y2 - y1)).normalize();
        float brokenType = random(1);
        if (brokenType < 0.25) {
            len *= random(0.35, 0.8);
            line(x1, y1, x1 + dir.x * len, y1 + dir.y * len);
        }
        else if (brokenType < 0.5) {
            len *= random(0.35, 0.8);
            dir = (new PVector(x1 - x2, y1 - y2)).normalize();
            line(x2, y2, x2 + dir.x * len, y2 + dir.y * len);
        }
        else if (brokenType < 0.75) {
            line(x1, y1, x2, y2);
            float start = random(0.2, 0.4);
            float end = random(0.6, 0.8);
            stroke(255);
            strokeWeight(2);
            line(x1 + dir.x * len * start, y1 + dir.y * len * start, x1 + dir.x * len * end, y1 + dir.y *  len * end);
            strokeWeight(1);
        }
        else {
            line(x1, y1, x2, y2);
            float start1 = random(0.1, 0.3);
            float end1 = random(0.3, 0.5);
            float start2 = random(0.6, 0.8);
            float end2 = random(0.8, 0.9);
            stroke(255, 255, 255, 255);
            strokeWeight(2);
            line(x1 + dir.x * len * start1, y1 + dir.y * len * start1, x1 + dir.x * len * end1, y1 + dir.y *  len * end1);
            line(x1 + dir.x * len * start2, y1 + dir.y * len * start2, x1 + dir.x * len * end2, y1 + dir.y *  len * end2);
            strokeWeight(1);
        }
    }
    else {
        line(x1, y1, x2, y2);
    }
}

float drawDot(float dotX, float dotY, float maxRadius, boolean inset) {
    if (maxRadius < 0) {
        return -1;
    }
    if (Math.random() < DOT_DENSITY) {
        int randIdx = (int) Math.floor(Math.random() * DOT_SIZES.length);
        float radius = (float)DOT_SIZES[randIdx];
        while (radius > maxRadius + 1) {
            radius *= 0.5;
        }
        
        float offsetX = 0;
        float offsetY = 0;
        if (inset) {
            float offsetAmount = random(radius - maxRadius, maxRadius - radius) * 0.75;
            float offsetDirection = random(0, PI * 2);
            offsetX = cos(offsetDirection) * offsetAmount;
            offsetY = sin(offsetDirection) * offsetAmount;
        }
        
        color c;
        double rand = Math.random();
        
        if (rand < 0.7) {
            c = color(INVERT_COLOR ? 255 : 0);
        }
        else if (rand < 0.8) {
            c = color(208, 10, 27);
        }
        else if (rand < 0.9) {
            c = color(128);
        }
        else {
            c = color(255, 195, 0);
        }
        
        fill(c);
        ellipse((float)dotX + offsetX, (float)dotY + offsetY, radius * 2, radius * 2);
        return radius;
    }
    else {
        return -1;
    }
}

void draw() {
    //exit();
}

void mouseClicked() {
    //background(INVERT_COLOR ? 0 : 255);
    //generate();
}

void keyPressed() {
    if (key == 'p') {
        //saveFrame();
    }
}