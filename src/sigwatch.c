/*
 *    This program is free software; you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation; either version 2 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program; if not, write to the Free Software
 *    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 *    libsigwatch copyright 2003, Norman Gray
 *    http://www.astro.gla.ac.uk/users/norman/
 *    norman@astro.gla.ac.uk
 */

#include <stdlib.h>
#include <string.h>

#ifdef HAVE_SIGNAL_H
#include <signal.h>
#endif

#include "sigwatch.h"

static int lastsignal;
// consider SIGRTMAX for future
#if defined(HAVE_NSIG)
#define NSIGS NSIG
#elif defined(HAVE__NSIG)
#define NSIGS _NSIG
#else
#define NSIGS 32
#endif

static int signalresponses[NSIGS] = { -1 }; /* not-initialised flag */

static void detectsignal(int signum);
static void initresponses(void);

/*
 * Watch for the given signal.
 */
int watchsignal(int signum)
{
    sighandler_t previous;
    int rval;

    initresponses();
    previous = signal(signum, (sighandler_t)detectsignal);
    if (previous == SIG_ERR) {
        rval = -1;
    } else {
        if (signum < NSIGS)
            signalresponses[signum] = signum;
        if (previous == SIG_DFL)
            rval = 0;
        else
            /* There was a signal handler already -- warn about this */
            rval = 1;
    }
    return rval;
}


/*
 * Watch for the signal which has the given name, and when it is
 * found, have getlastsignal() return the given response.  If
 * response is 0 or *response is negative, then simply return the
 * signal number.
 *
 * The set of `named' signals is HUP, INT, USR1 and USR2.  For other
 * signals, use the numeric function, watchsignal().
 */
int watchsignalname(char *signame, int response)
{
    int signum;
    sighandler_t previous;
    int rval;

    initresponses();

    if (strncmp("INT", signame, 3) == 0)
        signum = SIGINT;
#ifndef _WIN32
    else if (strncmp("HUP", signame, 3) == 0)
        signum = SIGHUP;
    else if (strncmp("USR1", signame, 4) == 0)
        signum = SIGUSR1;
    else if (strncmp("USR2", signame, 4) == 0)
        signum = SIGUSR2;
#endif
    else
        signum = -1;

    if (signum >= 0) {
        /* All OK */
        previous = signal(signum, (sighandler_t)detectsignal);
        if (previous == SIG_ERR)
            rval = -1;
        else {
            if (signum < NSIGS) {
                if (response != 0 && response > 0)
                    signalresponses[signum] = response;
                else
                    signalresponses[signum] = signum;
            }
            if (previous == SIG_DFL)
                rval = 0;
            else
                /* There was a signal handler already -- warn about this */
                rval = 1;
        }
    } else {
        /* Unrecognised signal name */
        rval = -1;
    }
    return rval;
}

/* Return the response associated with the last signal, as registered
 * with watchsignal() or watchsignalname()
 */
int getlastsignal(void)
{
    int lastsig = lastsignal;
    lastsignal = 0;

    if (lastsig < NSIGS)
        return signalresponses[lastsig];
    else
        return lastsig;
}

int sigwatchversion(void)
{
    char *verstring = PACKAGE_VERSION;	/* format "major.minor" */
    char *endp;
    int rval;

    rval = strtoul(verstring, &endp, 10);
    rval *= 1000;
    if (*endp != '\0') {
	endp++;			/* increment past '.' */
	rval += strtoul(endp, 0, 10);
    }
    return rval;
}

/* This is the signal handler.  Simply store the signal. */
static void detectsignal(int signum)
{
    lastsignal = signum;
}

/* Initialise the signalresponses array */
static void initresponses(void)
{
    if (signalresponses[0] < 0) { /* not-initialised flag */
        int i;
        for (i=0; i<NSIGS; i++)
            signalresponses[i] = 0;
    }
}
