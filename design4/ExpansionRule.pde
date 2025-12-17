/*--------------------------------------*
 * Written by Steven Galban, 6/23/19
 *--------------------------------------*/

import java.util.Map;
import java.util.HashMap;

class ExpansionRule {
    public char predecessor;
    private Map<String, Double> successors;
    
    public ExpansionRule(char pred) {
        predecessor = pred;
        successors = new HashMap();
    }
    
    public ExpansionRule with(String successor, double probability) {
        this.successors.put(successor, probability);
        return this;
    }
    
    public ExpansionRule with(String successor) {
        return with(successor, 1.0);
    }
    
    public String getSuccessor() {
        // I'm assuming the successors were added with a total probability of 1.0
        double p = Math.random();
        double cumulative = 0;
        for (String successor : this.successors.keySet()) {
            cumulative += successors.get(successor);
            if (p < cumulative) {
                return successor;
            }
        }
        return "";
    }
}