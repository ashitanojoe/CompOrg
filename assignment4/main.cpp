
#define   MAX_COL     60
#define   MAX_ROW     24
#define   UP          -30
#define   DOWN        -879
#define   LEFT        4928
#define   RIGHT       221

#include <time.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <termios.h>
#include <fcntl.h>
#include "tools.h"
#include "signal_handler.h"
#include "CPoint.h"
#include <iostream.h>

using namespace std;

struct termios orig_settings;
char c = 'x';
CPoint head;
CPoint tail;

int main()
{
  timespec sleep_time;

  sleep_time.tv_sec = 0;
  sleep_time.tv_nsec = 200000000;   
  clrscr();
  gotoxy((MAX_ROW / 2), (MAX_COL / 2));
  cout << "XXXXX\n";
  head.set_both((MAX_ROW / 2), ((MAX_COL / 2) + 4));
  tail.set_both((MAX_ROW / 2), (MAX_COL / 2)); 

  struct termios async;  
  tcgetattr(STDIN_FILENO, &orig_settings);
  async = orig_settings;
  async.c_lflag &= ~(ICANON|ECHO);
  tcsetattr(STDIN_FILENO, TCSAFLUSH, &async);
  fcntl(STDIN_FILENO, F_SETOWN, getpid());
  fcntl(STDIN_FILENO, F_SETFL, (O_ASYNC|O_NONBLOCK));
  signal(SIGINT, handle_signal);
  signal(SIGIO, handle_signal);
  while(true)
  {
    timespec time_left;
    if(nanosleep(&sleep_time, &time_left) != -1)
    {
      gotoxy(tail.get_row(), tail.get_column());
      cout << " ";
      tail.set_column(tail.get_column() + 1);
      head.set_column(head.get_column() + 1);
      gotoxy(head.get_row(), head.get_column());
      cout << "X \n";
      sleep_time.tv_nsec = 50000000;
    }
    else
    {
      sleep_time = time_left;
    }
  } 
  return 0;
}


