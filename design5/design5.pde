import java.util.List;
import java.util.Set;
import java.util.HashSet;
import java.util.Objects;

final int CANVAS_WIDTH = 512;
final int CANVAS_HEIGHT = 512;
final int NUM_ROWS = 64;
final int NUM_COLUMNS = 64;

class Vertex {
    public float x;
    public float y;
    
    public Vertex(float x, float y) {
        this.x = x;
        this.y = y;
    }
    
    public float dist(Vertex other) {
        return (float)Math.sqrt(Math.pow(this.x - other.x, 2.0) + Math.pow(this.y - other.y, 2.0));
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(x, y);
    }
}

void settings() {
    size(CANVAS_WIDTH, CANVAS_HEIGHT);
}

int coordToIdx(int x, int y) {
    return NUM_COLUMNS * y + x;
}

public void drawLine(Vertex v1, Vertex v2) {
    strokeWeight(4);
    stroke(0, 0, 255);
    line(v1.x, v1.y, v2.x, v2.y);
    strokeWeight(1);
    stroke(0, 255, 255);
    line(v1.x, v1.y, v2.x, v2.y);
}

void generate() {
    float cellWidth = CANVAS_WIDTH / NUM_COLUMNS;
    float cellHeight = CANVAS_HEIGHT / NUM_ROWS;
    
    List<Vertex> allVerts = new ArrayList();
    Set<Vertex> availableVerts = new HashSet();
    
    for (int row = 0; row < NUM_ROWS; row++) {
        for (int col = 0; col < NUM_COLUMNS; col++) {
            float curCellX = col * cellWidth;
            float curCellY = row * cellHeight;
            float dotX = curCellX + (float)(0.25 + Math.random() * 0.5) * cellWidth;
            float dotY = curCellY + (float)(0.25 + Math.random() * 0.5) * cellHeight;
            Vertex v = new Vertex(dotX, dotY);
            allVerts.add(v);
            availableVerts.add(v);
        }
    }
    
    Vertex curVert = null;
    int curX = -1;
    int curY = -1;
    while (!availableVerts.isEmpty()) {
        if (curVert == null) {
            curX = (int)(Math.random() * NUM_COLUMNS);
            curY = (int)(Math.random() * NUM_ROWS);
            curVert = allVerts.get(coordToIdx(curX, curY));
        }
        availableVerts.remove(curVert);
        Vertex closest = null;
        float closestDist = 100000;
        int closestX = -1;
        int closestY = -1;
        for (int x = Math.max(curX - 1, 0); x <= Math.min(curX + 1, NUM_COLUMNS - 1); x++) {
            for (int y = Math.max(curY - 1, 0); y <= Math.min(curY + 1, NUM_ROWS - 1); y++) {
                Vertex v = allVerts.get(coordToIdx(x, y));
                float dist = v.dist(curVert);
                if (availableVerts.contains(v) && dist < closestDist) {
                    closest = v;
                    closestDist = dist;
                    closestX = x;
                    closestY = y;
                }
            }
        }
        if (closest != null) {
            drawLine(curVert, closest);
        }
        
        curVert = closest;
        curX = closestX;
        curY = closestY;
    }
}

void setup() {
    background(255);
    stroke(0);
    generate();
}

void draw() {}

void mouseClicked() {
    background(255);
    generate();
}

void keyPressed() {
    if (key == 'p') {
        saveFrame();
    }
}