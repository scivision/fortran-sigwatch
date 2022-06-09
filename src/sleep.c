extern void c_sleep(int);

#ifdef _MSC_VER

#include <windows.h>

// https://docs.microsoft.com/en-us/windows/win32/api/synchapi/nf-synchapi-sleep
void c_sleep(int milliseconds){
  Sleep(milliseconds);
}

#else

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
// https://linux.die.net/man/3/usleep
void c_sleep(int milliseconds)
{
  int ierr = usleep(milliseconds);
  if (ierr != 0){
    if (errno == EINTR){
      // printf("usleep interrupted\n");
    }
    else if(errno == EINVAL){
      fprintf(stderr, "usleep bad milliseconds value\n");
      exit(1);
    }
    else{
      fprintf(stderr, "usleep error\n");
      exit(1);
    }
  }
}

#endif
