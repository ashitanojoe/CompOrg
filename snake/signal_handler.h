// Programmer			:	Joe Waller
// Module					: signal_handler.h
// Description		: Handles all signals for the snake program


#if !defined(_signal_handler_h_)
#define _signal_handler_h_

#include <vector>
#include "snake.h"

extern struct termios orig_settings;
extern char c;
extern int direction;
extern int score;
extern long int vSpeedm, hSpeedm;
extern timespec speed;
extern int speedcount;
extern bool pause_state;

void handle_signal(int sig)
{
	switch (sig)
	{
		// case of CTRL-C
		case SIGINT:
			tcsetattr(STDIN_FILENO, TCSAFLUSH, &orig_settings);
			gotoPos(20, 10);
			cout << "Score: " << score << endl;
			exit(0);
			break;
		// handle I/O signals
		case SIGIO:
			vector<int> key;
			if(read(STDIN_FILENO, &c, 1) > 0)
			{
				key.push_back((int)c);
				while(read(STDIN_FILENO, &c, 1) > 0)
					key.push_back((int)c);
			}
			int size = key.size();
			if(size == 1)
			{
				// slows down the snake
				if(key[0] == 45)			// the minus key
				{
					if (speedcount < 4)
					{
						vSpeedm += 90000000;
						hSpeedm += 60000000;
						speedcount++;
					}
					if ((direction == UP) || (direction == DOWN))
						speed.tv_nsec = 300000000 + vSpeedm;
					else					
						speed.tv_nsec = 200000000 + hSpeedm;
				}
				// speeds up the snake
				if(key[0] == 43)			// the plus key
				{
					if (speedcount > -4)
					{
						vSpeedm -= 90000000;
						hSpeedm -= 60000000;
						speedcount--;
					}
					if ((direction == UP) || (direction == DOWN))
						speed.tv_nsec = 300000000 + vSpeedm;
					else					
						speed.tv_nsec = 200000000 + hSpeedm;
				}
				// Pauses or unpauses the game
				if(key[0] == 46)			// the period key
				{
					pause_state = !pause_state;
				}
			}
			if(size == 3)
			{
				if((key[0] == 27) && (key[1] == 91))
				{
					// signal for UP arrow
					if(key[2] == 65)
					{
						direction = UP;
						speed.tv_nsec = 300000000 + vSpeedm;
					}
					// signal for DOWN arrow
					else if (key[2] == 66)
					{
						direction = DOWN;
						speed.tv_nsec = 300000000 + vSpeedm;
					}
					// signal for RIGHT arrow
					else if (key[2] == 67)
					{
						direction = RIGHT;
						speed.tv_nsec = 200000000 + hSpeedm;
					}
					// signal for LEFT arrow
					else if (key[2] == 68)
					{
						direction = LEFT;
						speed.tv_nsec = 200000000 + hSpeedm;
					}
				}
			}
			break;
	}
}

#endif // _signal_handler_h_
