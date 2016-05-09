// Description:			Class definition of the CSnake class for
//									use in the snake program.
// Programmer:			Joe Waller
// Last Modified:		March 15, 2003

#if !defined(_snake_h_)
#define _snake_h_
#define UP		1
#define DOWN	-1
#define LEFT	-2
#define RIGHT	2

#include <vector>
using namespace std;

struct Position
{
	int column;
	int row;
};

class CSnake
{
	public:
		CSnake();
		~CSnake();
		void DrawSnake();
		void EraseSnake();
		void MoveSnake();
		void ChangeDirection(int newDirection);
		bool DetectCollision();
		bool MakeFood();

	private:
		vector<Position> m_snake;
		int direction;
		int grow;
};

#endif // _snake_h_
