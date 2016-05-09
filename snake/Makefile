snake : main.cpp snake.o scrtools.o signal_handler.h
					c++ snake.o scrtools.o main.cpp -o snake
snake.o : snake.h snake.cpp scrtools.o
					c++ -c snake.cpp
scrtools.o : scrtools.h scrtools.cpp
					c++ -c scrtools.cpp
clean :
					$ rm -f *.o snake core
