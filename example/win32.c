#include <stdio.h>
#include <stdlib.h>

#include "sigwatch.h"

int main(void){

setbuf(stdout, NULL);
/* disable default stdout buffering for clarity */

/* do ^C once to get a signal. The second time stops the program. */
int status = watchsignal(2);
printf("watchsignal 2: %d\n", status);

for(int i=0; i<10; i++){
  c_sleep(500);
  printf("lastsig=%d\n", getlastsignal());
}

printf("C: stopped watching for signals\n");

return EXIT_SUCCESS;

}
