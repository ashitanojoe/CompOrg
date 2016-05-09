
// Description :  Tools for clearing screen and going to a specific
//                screen position
// Provider    :  Dr. Sergeant

#if !defined(_tools_h_)
#define _tools_h_

#define   UP          -30
#define   DOWN        -879
#define   LEFT        4928
#define   RIGHT       221
#define   MAX_COL     60
#define   MAX_ROW     24

#include <iostream>

using namespace std;

const char ESC = 27;

void move(int direction)
{
  if(direction == UP)
  {
    
  }
  gotoxy(tail.get_row(), tail.get_column());
  cout << " ";
  tail.set_column(tail.get_column() + 1);
  head.set_column(head.get_column() + 1);
  gotoxy(head.get_row(), head.get_column());
  cout << "X \n";
}

void clrscr()
{
  cout << ESC << "[2J";  
}

void gotoxy(int row, int column)
{
  cout << ESC << "[" << row << ";" << column << ";H";
}

#endif // _tools_h_
