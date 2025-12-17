/*--------------------------------------*
 * Written by Steven Galban, 6/24/19
 *--------------------------------------*/

import java.util.Stack;

class Turtle {
    
    private class State {
        double x;
        double y;
        double angle;
        int depth;
        
        public State(double x, double y, double angle) {
            this.x = x;
            this.y = y;
            this.angle = angle % 360.0;
            this.depth = 0;
        }
        
        public State clone() {
            return new State(this.x, this.y, this.angle);
        }
    }
    
    State currentState;
    Stack<State> branchedStates;
    int maxIterations;
    boolean useCurves;
    
    public Turtle(double x, double y, double angle, int maxIterations, boolean curve) {
        currentState = new State(x, y, angle % 360);
        branchedStates = new Stack();
        this.maxIterations = maxIterations;
        this.useCurves = curve;
        beginShape();
        curveVertex((float)x, (float)y);
    }
    
    public void resetState(double x, double y, double angle) {
        currentState = new State(x, y, angle % 360);
        branchedStates = new Stack();
    }
    
    public void branch() {
        State newState = currentState.clone();
        newState.depth = currentState.depth + 1;
        branchedStates.push(newState);
        if (useCurves) {
            curveVertex((float)currentState.x, (float)currentState.y);
            curveVertex((float)currentState.x, (float)currentState.y);
            endShape();
            beginShape();
            curveVertex((float)currentState.x, (float)currentState.y);
            curveVertex((float)currentState.x, (float)currentState.y);
        }
    }
    
    public void unbranch() {
        currentState = branchedStates.pop();
        if (useCurves) {
            curveVertex((float)currentState.x, (float)currentState.y);
            curveVertex((float)currentState.x, (float)currentState.y);
            endShape();
            beginShape();
            curveVertex((float)currentState.x, (float)currentState.y);
            curveVertex((float)currentState.x, (float)currentState.y);
        };
    }
    
    public void rotate(double theta) {
        currentState.angle = (currentState.angle + theta) % 360;
    }
    
    public void moveForward(double amount) {
        float lastx = (float)currentState.x;
        float lasty = (float)currentState.y;
        double curAngle = Math.toRadians(currentState.angle);
        currentState.x += amount * Math.cos(curAngle);
        currentState.y += amount * Math.sin(curAngle);
        
        stroke(255 - (int)(Math.pow(0.9, currentState.depth) * 255));
        if (useCurves) {
            curveVertex(lastx, lasty);
        }
        else {
            line(lastx, lasty, (float)currentState.x, (float)currentState.y);
        }
    }
}