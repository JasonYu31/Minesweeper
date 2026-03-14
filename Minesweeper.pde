import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private final static int NUM_ROWS=20;
private final static int NUM_COLS=20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined
private boolean Lose = false;
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    mines= new ArrayList<MSButton>();
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r=0; r<NUM_ROWS; r++){
      for(int c=0; c<NUM_COLS; c++){
        buttons[r][c]= new MSButton(r,c);
      }
    }
    setMines();
}
public void setMines()
{
    //your code
    int NUM_MINES=20;
    while(mines.size()<NUM_MINES){
      int r=(int)(Math.random()*NUM_ROWS);
      int c=(int)(Math.random()*NUM_COLS);
      MSButton b = buttons[r][c];
      if(!mines.contains(b)){
        mines.add(b);
      }
    }
}

private void resetGame(){
  for(int r=0; r<NUM_ROWS; r++){
    for(int c=0; c<NUM_COLS; c++){
      MSButton b= buttons[r][c];
      b.clicked = false;
      b.flagged= false;
      b.setLabel("");
    }
  }
  mines.clear();
  setMines();
  Lose=false;
}
public void draw ()
{
 background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public void keyPressed(){
  if(key =='r' || key =='R'){
    resetGame();
  }
}
public boolean isWon()
{
    //code here
    for(int r=0; r<NUM_ROWS;r++){
      for(int c=0; c<NUM_COLS;c++){
        MSButton b = buttons[r][c];
        if(!mines.contains(b) && !b.clicked){
    return false;
        }
      }
    }
    return true;
}
public void displayLosingMessage()
{
    //your code here
    for(MSButton b : mines){
      b.setLabel(">:(");
    }
}
public void displayWinningMessage()
{
    //your code here
    for(int r=0; r<NUM_ROWS; r++){
      for(int c=0; c<NUM_COLS; c++){
        buttons[r][c].setLabel("GG");
      }
    }
}
public boolean isValid(int r, int c)
{
    return r>=0 && r<NUM_ROWS && c>=0 && c<NUM_COLS;
    
}
public int countMines(int row, int col)
{
    int numMines = 0;
   //code here
   for(int r=row-1; r<=row+1;r++){
     for(int c=col-1;c<=col+1;c++){
       if(isValid(r,c)){
         if(mines.contains(buttons[r][c]))
         numMines++;
       }
     }
   }
   if(mines.contains(buttons[row][col])){
     numMines--;
   }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        if(mouseButton==RIGHT){
          flagged= !flagged;
          if(!flagged)
          clicked=false;
          return;
    }
    clicked=true;
    
    if(mines.contains(this)){
      displayLosingMessage();
    }
    else{
      int minesNearby=countMines(myRow,myCol);
      if(minesNearby>0){
        setLabel(minesNearby);
      }else{
        for(int r=myRow-1; r<=myRow+1;r++){
          for(int c=myCol-1; c<=myCol+1;c++){
            if(isValid(r,c)){
              MSButton neighbor= buttons[r][c];
              if(!neighbor.clicked&& !neighbor.flagged && !mines.contains(neighbor)){
                neighbor.mousePressed();
              }
            }
          }
        }
      }
    }
    }
    public void draw () 
    {    
        if (flagged)
            fill(250,255,3);
         else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill(200);
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
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
