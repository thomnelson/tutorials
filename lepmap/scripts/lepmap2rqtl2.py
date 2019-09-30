#!/usr/bin/env python

import argparse
import sys

parser = argparse.ArgumentParser(description='Convert a list of lepMAP3 output maps into input for r/qtl2')
parser.add_argument('-m','--mapfiles', nargs = '+',required=True, help='List of mapfiles.')
parser.add_argument('-p','--pedigree', required=True, help='pedigree file input into lepMAP3.')
parser.add_argument('-c','--physicalpositions',required=False,default='None',help='tsv file of physical positions of markers (markerID chr bp)')
parser.add_argument('-o','--outprefix', required=False, default="out", help='file prefix for output files.')
args=parser.parse_args()

mapfiles = args.mapfiles
ped      = args.pedigree
phys     = args.physicalpositions
outpref  = args.outprefix

inclphys = False
if phys != 'None':
    inclphys = True

### READ PEDIGREE FILE TO GET OFFSPRING NAMES AND MATRIX SIZES

sys.stderr.write("Reading cross info from %s...\n"%(ped))
sys.stderr.write("   Assuming 2 grandparents and 2 F1s included in pedigree.\n")

ped     = open(ped,'r')
nF2s    = 0
F2names = []

ped.readline()
cross = ped.readline().strip().split()
nF2s = len(cross) - 6
for s in range(6,len(cross)):
    F2names.append(cross[s])

sys.stderr.write("   %s F2s found in cross.\n"%(nF2s))
sys.stderr.write("\n")

markers         = []
markerphys      = {}
markerGenotypes = []
markerInfo      = {} # key: marker id, value: {LG,cM}

### READ IN PHYSICAL POSITIONS IF PROVIDED

if inclphys:
    phys = open(phys, 'r')
    phys.readline()
    for m in phys:
        m = m.strip().split()
        markerphys[m[0]] = {"chr":m[1],"bp":m[2]}
    phys.close()

sys.stderr.write("Reading positions and genotypes from file:\n")
nLGs = len(mapfiles)
nmarkers = 0

GTconvert = ['GG','GS','SS']

for i in range(nLGs):
    lgid = i + 1
    sys.stderr.write("   %s...\n"%(mapfiles[i]))
    gmap = open(mapfiles[i],'r')
    gmap.readline()
    gmap.readline()
    gmap.readline()
    for marker in gmap:
        nmarkers +=1
        marker = marker.strip().split()
        mID    = marker[0]
        cM     = marker[1]
        gtsraw = marker[6]
        GTs    = []
        for a in range(nF2s):
            a1 = int(gtsraw[a])
            a2 = int(gtsraw[a + nF2s])
            GTs.append(GTconvert[a1+a2])
        markerGenotypes.append(GTs)
        markers.append(mID)
        markerInfo[mID] = {"LG":lgid,"cM":cM,"chr":"NA","bp":"NA"}
        if inclphys:
            markerInfo[mID]["chr"] = markerphys[mID]["chr"]
            markerInfo[mID]["bp"] = markerphys[mID]["bp"]
        # if i + nmarkers == 1:
        #     print(gtsraw[0:nF2s])
        #     print("")
        #     print(gtsraw[nF2s:(2*nF2s)])
        #     print(GTs)
    gmap.close()

sys.stderr.write("\nPrinting outputs to:\n  %s\n  %s\n"%(outpref+".geno",outpref+".gmap"))

### WRITE .GENO HEADER
genoOUT = open(outpref+".geno",'w')
genoOUT.write("id")
for marker in markers:
    genoOUT.write(",%s"%(marker))
genoOUT.write("\n")

### WRITE GENOTYPE FILE
for f2 in range(nF2s):
    f2ID = F2names[f2]
    genoOUT.write(f2ID)
    for g in range(nmarkers):
        genoOUT.write(",%s"%(markerGenotypes[g][f2]))
    genoOUT.write("\n")
genoOUT.close()

### WRITE MAP FILE

gmapOUT = open(outpref+".gmap",'w')
gmapOUT.write("marker,LG,cM,chr,bp\n")
for marker in markers:
    lg = markerInfo[marker]["LG"]
    cM = markerInfo[marker]["cM"]
    chrom = "NA"
    bp    = "NA"
    if inclphys:
        chrom = markerInfo[marker]["chr"]
        bp    = markerInfo[marker]["bp"]
    gmapOUT.write("%s,%s,%s,%s,%s\n"%(marker,lg,cM,chrom,bp))
gmapOUT.close()

