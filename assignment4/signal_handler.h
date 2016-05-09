
#if !defined(_signal_handler_h_)
#define _signal_handler_h_

extern struct termios orig_settings;
extern char c;

void handle_signal(int sig)
{
  switch (sig)
  {
    case SIGINT:
      tcsetattr(STDIN_FILENO, TCSAFLUSH, &orig_settings);
      exit(0);
      break;
    case SIGIO:
      break;
  }
}

#endif // _signal_handler_h_
