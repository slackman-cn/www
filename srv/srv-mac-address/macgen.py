#!/usr/bin/python3
# macgen.py script to generate a MAC address for guest virtual machines
#
import random
#
def randomMAC():
        mac = [ 0x52, 0x54, 0x00,
                random.randint(0x00, 0x7f),
                random.randint(0x00, 0xff),
                random.randint(0x00, 0xff) ]
        return ':'.join(map(lambda x: "%02x" % x, mac))
#

for _ in range(5):
   print(randomMAC())
