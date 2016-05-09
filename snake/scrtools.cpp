#include "scrtools.h"
#include <iostream>
using namespace std;

const char ESC = 27;

void clrscr()
{
	cout << ESC << "[2J";
}

void gotoPos(int row, int column)
{
	cout << ESC << "[" << row << ";" << column << ";H";
}
