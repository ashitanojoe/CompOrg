// Description:			Member functions for the CSnake class for use
//									with the snake program.
// Programmer:			Joe Waller

#include "snake.h"
#include <iostream>
#include "scrtools.h"
using namespace std;

extern Position food;
extern int score;

// Constructor ------------------------------------
// Initializes the snake size and position.  Also
// set direction value and whether or not the snake is
// currently growing
CSnake::CSnake()
{
	Position initPos;

	initPos.column = 30;
	initPos.row = 12;
	m_snake.push_back(initPos);
	initPos.column++;
	m_snake.push_back(initPos);
	initPos.column++;
	m_snake.push_back(initPos);
	initPos.column++;
	m_snake.push_back(initPos);
	initPos.column++;
	m_snake.push_back(initPos);

	direction = RIGHT;
	grow = 0;
}

// Destructor ---------------------------------------
CSnake::~CSnake()
{

}

// DrawSnake
// Draws the snake by going to each point on the snake
// and drawing and X
void CSnake::DrawSnake()
{
	int size = m_snake.size();
	for(int i=0; i<size; i++)
	{
		gotoPos(m_snake[i].row, m_snake[i].column);
		cout << "X";
	}
	cout << endl;
}

// EraseSnake
// Erases the snake by going to each of the snake's points
// and outputting a space
void CSnake::EraseSnake()
{
	int size = m_snake.size();
	for(int i=0; i<size; i++)
	{
		gotoPos(m_snake[i].row, m_snake[i].column);
		cout << " ";
	}
	cout << endl;
}

// Moves the snake.  Also grows the snake in an event that food is
// eaten.  Will remake food if it is eaten by calling the MakeFood
// member function.
void CSnake::MoveSnake()
{
	int size = m_snake.size();

	switch (direction)
	{
		case RIGHT:
			if (grow > 0)			// if the snake needs to grow
			{
				Position newPos;		// the new position on the snake
				newPos = m_snake[size-1];
				newPos.column++;
				size++;
				m_snake.push_back(newPos);	// add the point to the snake
				grow--;
			}
			else if (grow == 0)			// if it doesn't need to grow then move
			{												// it
				for(int i=0; i<size-1; i++)
					m_snake[i] = m_snake[i+1];
				m_snake[size-1].column++;
			}
			// if food was eaten
			if ((m_snake[size-1].column == food.column) &&
					(m_snake[size-1].row == food.row))
			{
				score++;							// increment score
				while(!MakeFood());		// make food
				gotoPos(food.row, food.column);	// draw food on screen
				cout << "O\n";
				grow += 5;
			}
			break;
		case LEFT:								// the same as the other, except
			if (grow > 0)						// for moving left
			{
				Position newPos;
				newPos = m_snake[size-1];
				size++;
				newPos.column--;
				m_snake.push_back(newPos);
				grow--;
			}
			else if (grow == 0)
			{
				for(int i=0; i<size-1; i++)
					m_snake[i] = m_snake[i+1];
				m_snake[size-1].column--;
			}
			if ((m_snake[size-1].column == food.column) &&
					(m_snake[size-1].row == food.row))
			{
				score++;
				while(!MakeFood());
				gotoPos(food.row, food.column);
				cout << "O\n";
				grow += 5;
			}
			break;
		case UP:												// for moving up
			if (grow > 0)
			{
				Position newPos;
				newPos = m_snake[size-1];
				newPos.row--;
				size++;
				m_snake.push_back(newPos);
				grow--;
			}
			else if (grow == 0)
			{
				for(int i=0; i<size-1; i++)
					m_snake[i] = m_snake[i+1];
				m_snake[size-1].row--;
			}
			if ((m_snake[size-1].column == food.column) &&
					(m_snake[size-1].row == food.row))
			{
				score++;
				while(!MakeFood());
				gotoPos(food.row, food.column);
				cout << "O\n";
				grow += 5;
			}
			break;
		case DOWN:						// for moving down
			if (grow > 0)
			{
				Position newPos = m_snake[size-1];
				newPos.row++;
				size++;
				m_snake.push_back(newPos);
				grow--;
			}
			else if (grow == 0)
			{
				for(int i=0; i<size-1; i++)
					m_snake[i] = m_snake[i+1];
				m_snake[size-1].row++;
			}
			if ((m_snake[size-1].column == food.column) &&
					(m_snake[size-1].row == food.row))
			{
				score++;
				while(!MakeFood());
				gotoPos(food.row, food.column);
				cout << "O\n";
				grow += 5;
			}
			break;
	}
	// wrap around the screen code
	if(m_snake[size-1].column > 60)
		m_snake[size-1].column = 1;
	if(m_snake[size-1].row < 1)
		m_snake[size-1].row = 24;
	if(m_snake[size-1].column < 1)
		m_snake[size-1].column = 60;
	if(m_snake[size-1].row > 24)
		m_snake[size-1].row = 1;
}

// Changes the direction of the snake
void CSnake::ChangeDirection(int newDirection)
{
	direction = newDirection;
}

// Detects when a snake has collided with itself or with
// the clock in the upper right part of the screen
bool CSnake::DetectCollision()
{
	int size = m_snake.size();
	Position head = m_snake[size-1];

	// Check for collision with self
	for(int i=0; i<size-1; i++)
	{
		if ((head.row == m_snake[i].row) &&
				(head.column == m_snake[i].column))
			return true;
	}

	// Check for collision with clock
	int col = 53;
	for(int i=0; i<8; i++)
		if ((head.row == 1) && (head.column == (col + i)))
			return true;
	return false;
}

// Get a new position for food.  Checks to make sure the food
// is not placed in an occupied position.
bool CSnake::MakeFood()
{
	food.row = rand() % 24;
	food.column = rand() % 60;
	if (food.row == 0)
		food.row = 1;
	if (food.column == 0)
		food.column = 1;
	if (food.row == 1)
		for(int i=53; i<61; i++)
			if (food.column == i)
				return false;
	int size = m_snake.size();
	for(int i=0; i<size; i++)
		if((food.row == m_snake[i].row) &&
			 (food.column == m_snake[i].column))
			return false;
	return true;
}
