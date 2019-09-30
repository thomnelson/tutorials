#!/usr/bin/env python
#
# Get the marker names and assembly positions
#  for marker outputs from SeparateChromosomes2
#

import sys

if len(sys.argv) != 3:
    sys.stderr.write("---------------------------------------------------------\n")
    sys.stderr.write("  Usage: getMarkerPositions.py posteriors.file map.file\n")
    sys.stderr.write("---------------------------------------------------------\n")
    sys.exit()

post = open(sys.argv[1],'r')
mapfile = open(sys.argv[2],'r')

postheader = 7 # number of lines to skip
# sys.stderr.write("Assuming %s lines of header in posteriors file...\n"%(str(postheader)))
for i in range(7):
    post.readline()
positions = {} # dictionary of marker numbers and reference assembly positions

markernumber = 1
for marker in post:
    marker = marker.strip().split()
    positions[markernumber] = [marker[0],marker[1]]
    markernumber += 1
post.close()

sys.stdout.write("marker\tLG\tchr\tpos\n")
mapfile.readline() # clear commented header
markernumber = 1
for marker in mapfile:
    LG  = marker.strip()
    CHR = positions[markernumber][0]
    POS = positions[markernumber][1]
    sys.stdout.write("%s\t%s\t%s\t%s\n"%(str(markernumber),LG,CHR,POS))
    markernumber += 1
mapfile.close()
