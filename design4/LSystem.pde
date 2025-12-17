/*--------------------------------------*
 * Written by Steven Galban, 6/23/19
 *--------------------------------------*/

import java.util.Map;
import java.util.HashMap;

class LSystem {
    private Map<Character, ExpansionRule> expansionRules;
    private Map<Character, Runnable> drawingRules;
    private String axiom;
    
    public LSystem(String axiom) {
        this.expansionRules = new HashMap();
        this.drawingRules = new HashMap();
        this.axiom = axiom;
    }
    
    public ExpansionRule addRule(char pred) {
        ExpansionRule er = new ExpansionRule(pred);
        expansionRules.put(pred, er);
        return er;
    }
    
    public void addRule(char pred, Runnable rule) {
        drawingRules.put(pred, rule);
    }
        
    private String expandChar(char c) {
        ExpansionRule rule = expansionRules.get(c);
        if (rule == null) {
            return String.valueOf(c);
        }
        else {
            return rule.getSuccessor();
        }
    }
    
    public String generateString(int iterations) {
        String curString = axiom;
        for (int curIteration = 0; curIteration < iterations; curIteration++) {
            String newString = "";
            for (int i = 0; i < curString.length(); i++) {
                char c = curString.charAt(i);
                newString += expandChar(c);
            }
            curString = newString;
        }
        return curString;
    }
    
    public void draw(int iterations) {
        String toDraw = generateString(iterations);
        for (int i = 0; i < toDraw.length(); i++) {
            Runnable drawRule = drawingRules.get(toDraw.charAt(i));
            if (drawRule != null) {
                drawRule.run();
            }
        }
    }
}