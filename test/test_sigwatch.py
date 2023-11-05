#!/usr/bin/env python3
"""
This does NOT work yet--the executable doesn't receive the signal.
Needs further investigation.
"""
import subprocess
import argparse
import time
import signal
import os

parser = argparse.ArgumentParser()
parser.add_argument("exe", help="test executable")
parser.add_argument("sleep", help="sleep time",
                    nargs="?", type=float, default=0.5)
args = parser.parse_args()

proc = subprocess.Popen(
    [args.exe],
    shell=True,
)
# creationflags=subprocess.CREATE_NEW_PROCESS_GROUP if os.name == "nt" else 0)
# CREATE_NEW_PROCESS_GROUP  still didn't work -- no signals received
# shell True or False didn't make a difference

time.sleep(args.sleep)

if os.name == "nt":
    try:
        print("Python: send SIGBREAK", signal.SIGBREAK)  # type: ignore
        proc.send_signal(signal.SIGBREAK)  # type: ignore
    except ValueError as e:
        print(f"Python failed: {e}")
else:
    print("Python: send SIGHUP", signal.SIGHUP)
    proc.send_signal(signal.SIGHUP)
    time.sleep(args.sleep)

    print("Python: send SIGINT", signal.SIGINT)
    proc.send_signal(signal.SIGINT)
    time.sleep(args.sleep)

    print("Python: send SIGUSR1", signal.SIGUSR1)  # type: ignore
    proc.send_signal(signal.SIGUSR1)  # type: ignore
time.sleep(args.sleep)

print("Python: send SIGTERM", signal.SIGTERM)
proc.send_signal(signal.SIGTERM)
time.sleep(args.sleep)

proc.wait(timeout=10.0)
