import java.util.Comparator;

public class LexicalComparison implements Comparator<PVector> {
  public LexicalComparison() {
  }

  public int compare(PVector v1, PVector v2) {
    if (v1.x > v2.x) {
      return 1;
    } 
    else if (v1.x < v2.x) {
      return -1;
    } 
    else { // x component is the same, check y
      if (v1.y > v2.y) {
        return 1;
      } 
      else {
        return -1;
      }
    }
  }
}

