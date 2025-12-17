import java.util.List;
import processing.pdf.*;

final int CANVAS_WIDTH = 512;
final int CANVAS_HEIGHT = 512;
final int NUM_ROWS = 32;
final int NUM_COLUMNS = 32;
final double MIN_RADIUS = 2;
final double MAX_RADIUS = 4;
final double NET_DENSITY = 0.5;
final boolean IS_UNIFORM = false;

int foregroundColor = color(255, 255, 255);
int backgroundColor = color(0, 0, 0);

void settings() {
    size(CANVAS_WIDTH, CANVAS_HEIGHT);
}

void generatePdf() {
    beginRecord(PDF, "output.pdf");
    generate();
    endRecord();
}

void generate() {
    background(backgroundColor);
    double cellWidth = CANVAS_WIDTH / NUM_COLUMNS;
    double cellHeight = CANVAS_HEIGHT / NUM_ROWS;
    noStroke();
    fill(foregroundColor);
    
    List<List<Float>> xs = new ArrayList();
    List<List<Float>> ys = new ArrayList();
    
    for (int row = 0; row < NUM_ROWS; row++) {
        List<Float> curXs = new ArrayList();
        List<Float> curYs = new ArrayList();
        for (int col = 0; col < NUM_COLUMNS; col++) {
            double curCellX = col * cellWidth;
            double curCellY = row * cellHeight;
            
            double dotX;
            if (!IS_UNIFORM) {
                dotX = curCellX + (0.25 + Math.random() * 0.5) * cellWidth;
            }
            else {
                dotX = curCellX + 0.5 * cellWidth;
            }
            double dotY;
            if (!IS_UNIFORM) {
                dotY = curCellY + (0.25 + Math.random() * 0.5) * cellHeight;
            }
            else {
                dotY = curCellY + 0.5 * cellHeight;
            }
            curXs.add((float)dotX);
            curYs.add((float)dotY);
            
            float radius = (float)(Math.random() * (MAX_RADIUS - MIN_RADIUS) + MIN_RADIUS);
            ellipse((float)dotX, (float)dotY, radius * 2, radius * 2);
        }
        xs.add(curXs);
        ys.add(curYs);
    }
    
    stroke(foregroundColor);
    for (int row = 0; row < NUM_ROWS; row++) {
        for (int col = 0; col < NUM_COLUMNS; col++) {
            if (Math.random() < NET_DENSITY) {
                if (row + 1 < NUM_ROWS) {
                    line(xs.get(row).get(col), ys.get(row).get(col), xs.get(row + 1).get(col), ys.get(row + 1).get(col));
                }
                if (col + 1 < NUM_COLUMNS) {
                    line(xs.get(row).get(col), ys.get(row).get(col), xs.get(row).get(col + 1), ys.get(row).get(col + 1));
                }
            }
        }
    }
}

void setup() {
    generatePdf();
}

void draw() {}

void mouseClicked() {
    generatePdf();
}

void keyPressed() {
    if (key == 'i') {
        int temp = foregroundColor;
        foregroundColor = backgroundColor;
        backgroundColor = temp;
        generatePdf();
    }
}