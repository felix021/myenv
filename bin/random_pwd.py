#!/usr/bin/python

import random
import sys

alphabet = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^*()"
try:
    pw_length = int(sys.argv[1])
except:
    pw_length = 12
mypw = ""

for i in range(pw_length):
    next_index = random.randrange(len(alphabet))
    mypw = mypw + alphabet[next_index]

print(mypw)

