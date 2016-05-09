//	Module				:		main.cpp
//	Programmer		:		Joe Waller
//	Last Modified	:		March 15, 2003
//	Description		:		The Snake Game.  The implementation of this
//										program demonstrates signal handling, clock
//										functions, and asynchronous I/O.
//	Other Info		:		Pressing '.' will pause the game.
//										Pressing '+' will speed the snake up.
//										Pressing '-' will slow the snake down.
//										A digital clock is displayed in the upper
//										right hand corner of the game.  If the snake
//										hits this clock, the game is over.
//										CTRL-C will exit the game, displaying the score.

#include <iostream>
#include <time.h>
#include <sys/time.h>
#include <unistd.h>
#include <termios.h>
#include <signal.h>
#include <fcntl.h>
#include "snake.h"
#include "scrtools.h"
#include "signal_handler.h"
using namespace std;

struct termios orig_settings;
char c = 'x';
int direction = RIGHT;				// current direction of the snake
int score = 0;								// the player's score
timespec speed;								// the speed of the snake (pause)
timespec sleep_time;					// the length nanosleep
Position food;								// position of the food
long int vSpeedm = 0;					// vertical speed multiplier
long int hSpeedm = 0;					// horizontal speed multiplier
int speedcount = 0;						// the current speed level
bool pause_state = false;			// are we paused

int main()
{
	CSnake theSnake;						// um...the snake
	time_t current_time;
	char* strTime = new char[50];
	char displayTime[9];				// time to be displayed

	sleep_time.tv_sec = 0;
	sleep_time.tv_nsec = 200000000;
	speed = sleep_time;
	clrscr();										// clears the screen
	theSnake.DrawSnake();
	srand(time(NULL));

	while(!theSnake.MakeFood());
	gotoPos(food.row, food.column);
	cout << "O" << endl;

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
		time(&current_time);							// gets the current time
		strTime = ctime(&current_time);		// converts to string
		for(int i=0; i<8; i++)
			displayTime[i] = strTime[i+11];	// gets need parts
		displayTime[8] = '\0';
		gotoPos(1, 53);
		cout << displayTime << endl;

		timespec time_left;
		// if the nanosleep is not interrupted
		if(nanosleep(&sleep_time, &time_left) != -1)	// sleep
		{
			if (!pause_state)
			{
				theSnake.ChangeDirection(direction);
				theSnake.EraseSnake();
				theSnake.MoveSnake();
				theSnake.DrawSnake();
				if (theSnake.DetectCollision())
					break;
				sleep_time = speed;
			}
		}
		// the nanosleep was interrupted, so pickup where left off
		else
		{
			sleep_time = time_left;
		}
	}
	handle_signal(SIGINT);		// there was a collision
	return 0;
}
