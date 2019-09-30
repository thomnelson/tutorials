#!/usr/bin/env python
#
# combine LGs from the lepMAP3 module OrderMarkers2
#  with info from getMarkerPositions.py to create a single file
#  of form "marker\tscaffold\tbp\tLG\tcM\n"
#
# Map file is a concatenation of all LGs output by OrderMarkers2
#  (e.g.
#      $ seq 8 | while read lg ; do grep -v "#" LOD16_lg${lg}.txt |cut -f 1,2 >> LOD16_lgs.txt ; done
#  )


import sys

if len(sys.argv) < 3:
    sys.stderr.write("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
    sys.stderr.write("  Usage: combineLGs.py <path/to/mapfile> <path/to/markerinfo.tsv>\n")
    sys.stderr.write("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
    sys.exit()

mapfile    = open(sys.argv[1], 'r')
markerinfo = open(sys.argv[2], 'r')

markers = {}

markerinfo.readline()
for marker in markerinfo:
    marker = marker.strip().split()
    m  = marker[0]
    lg = marker[1]
    s  = marker[2]
    bp = marker[3]
    markers[m] = {'LG':lg,'scaffold':s,'bp':bp}
markerinfo.close()

sys.stdout.write("marker\tscaffold\tbp\tLG\tcM\n")
for marker in mapfile:
    marker   = marker.strip().split()
    m        = marker[0]
    cM       = marker[1]
    info     = markers[m]
    lg       = info['LG']
    scaffold = info['scaffold']
    bp       = info['bp']
    sys.stdout.write("%s\t%s\t%s\t%s\t%s\n"%(m,scaffold,bp,lg,cM))
mapfile.close()
