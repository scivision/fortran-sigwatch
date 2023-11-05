int watchsignal    (int signum);
int watchsignalname(char *signame, int response);
int getlastsignal  (void);

typedef void (*sighandler_t)(int);

void c_sleep(int);
