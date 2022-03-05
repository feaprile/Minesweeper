import de.bezier.guido.*;
final private int NUM_ROWS = 12;
final private int NUM_COLS = 12;
final private int numBombs = 19;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private boolean endedGame = false;

void setup ()
{
  size(600, 600);
  textAlign(CENTER, CENTER);
  // make the manager
  Interactive.make( this );

  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++)
    for (int c = 0; c < NUM_COLS; c++)
      buttons[r][c] = new MSButton(r, c);
  setMines();
}
public void setMines()
{
  while (mines.size() < numBombs) { // number here is the amount of mines
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[r][c])) {
      mines.add(buttons[r][c]);
      //System.out.println(r + "," + c); //tells where the mines are
    }
  }
}

public void draw ()
{
  background(227, 233, 255);
  if (endedGame) {
    noLoop();
  } else {
    if (isWon() == true) {
      for (int cuRow = 0; cuRow < buttons.length; cuRow++) {
        for (int cuCol = 0; cuCol < buttons[cuRow].length; cuCol++) {
          buttons[cuRow][cuCol].unFlag();
        }
      }
      endedGame = true;
      displayWinningMessage();
    }
  }
}
public boolean isWon()
{
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c  = 0; c < NUM_COLS; c++) {
      if (mines.contains(buttons[r][c]) && buttons[r][c].isFlagged() != true) {
        return false;
      } else if (!mines.contains(buttons[r][c]) && buttons[r][c].isClicked() == false) {
        return false;
      }
    }
  }
  return true;
}
public void displayLosingMessage()
{
  textSize(36);
  fill(221, 29, 29);
  text("EXPLOSION! You Lose", 300, 25);
  noLoop();
}
public void displayWinningMessage()
{
  textSize(36);
  fill(82, 219, 96);
  text("You Survived! You Win", 300, 25);
  noLoop();
}
public boolean isValid(int r, int c)
{
  if ((r >= 0 && r< NUM_ROWS) && (c >= 0 && c < NUM_COLS)) {
    return true;
  }
  return false;
}
public int countMines(int row, int col)
{
  int count = 0;
  for (int r = row-1; r <= row+1; r++) {
    for (int c = col-1; c <= col+1; c++) {
      if (r != row || c != col) {
        if (isValid(r, c)) {
          if (mines.contains(buttons[r][c])) count++;
        }
      }
    }
  }
  return count;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 500/NUM_COLS;
    height = 500/NUM_ROWS;
    myRow = row;
    myCol = col;
    x = myCol*width+54;
    y = myRow*height+54;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  public void click() {
    clicked = true;
  }

  public void unFlag() {
    flagged = false;
  }

  public boolean isClicked() {
    return clicked;
  }
  public void mousePressed ()
  {
    if (mouseButton==LEFT) {
      clicked = true;
    }
    int r = myRow;
    int c = myCol;
    if (mouseButton == RIGHT)
      flagged = !flagged;
    else if (mines.contains(this)) {
      for (int cuRow = 0; cuRow < buttons.length; cuRow++) {
        for (int cuCol = 0; cuCol < buttons[cuRow].length; cuCol++) {
          buttons[cuRow][cuCol].unFlag();
          buttons[cuRow][cuCol].click();
        }
      }
      endedGame = true;
      displayLosingMessage();
    } else if (countMines(r, c)>0)
      setLabel(countMines(r, c)+"");
    else if (countMines(r, c)==0) {
      for (int newR = r-1; newR <= r+1; newR++) {
        for (int newC = c-1; newC <= c+1; newC++) {
          if (newR != r || newC != c) {
            if (isValid(newR, newC) && !buttons[newR][newC].isClicked()) {
              buttons[newR][newC].mousePressed();
            }
          }
        }
      }
    }
  }

  public void draw ()
  {    

    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) )
      fill(201, 69, 69); // bombs
    else if (clicked)
      fill(92, 117, 216); //selected bases
    else
      fill(54, 68, 124); //base color


    stroke(227, 233, 255);
    strokeWeight(3);
    rect(x, y, width, height, 6);
    fill(255);
    text(myLabel, x+width/2, y+height/2);

    textSize(36);
    fill(47, 42, 103);
    text("M", 95, 570);
    text("I", 137, 570);
    text("N", 177, 570);
    text("E", 219, 570);
    text("S", 260, 570);
    text("W", 300, 570);
    text("E", 342, 570);
    text("E", 383, 570);
    text("P", 423, 570);
    text("E", 465, 570);
    text("R", 507, 570);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
