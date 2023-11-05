#include <stdio.h>
#include <stdlib.h>

#include "sigwatch.h"

int main(void){

setbuf(stdout, NULL);
/* disable default stdout buffering for clarity */

/* Watch for signal 10 (which is USR1 on this platform) */

int status = watchsignal(10);
printf("watchsignal 10: %d\n", status);

/* Watch for HUP, too */

status = watchsignalname("HUP", 99);
printf("watchsignal HUP: %d\n", status);

for(int i=0; i<10; i++){
  c_sleep(500);
  printf("lastsig=%d\n", getlastsignal());
}

printf("C: stopped watching for signals\n");

return EXIT_SUCCESS;

}
