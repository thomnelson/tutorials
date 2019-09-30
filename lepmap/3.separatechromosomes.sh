#!/bin/bash

mappingdir="./"
scriptsdir="./scripts/"
vcfFile=${mappingdir}/datafiles/SFxIM767_plate1.scaf6scaf10.vcf
lepmapdir="./lepMAP3/bin/"
mapdir=${mappingdir}"segDistX2_0005_Missing10/"
datafile=$mapdir/posteriors.called.filtered

### SEPARATE LGS BASED ON LOD CUTOFF

lodmin=5
lodmax=19
lodstep=1

### SEPARATE CHROMOSOMES MODULE TO SPLIT INTO LGS BY LOD SCORE

seq $lodmin $lodstep $lodmax | while read lod
do echo "separating LGs at a LOD cutoff of "$lod"..."
   java -cp $lepmapdir SeparateChromosomes2 \
	data=${datafile} \
	lodLimit=$lod distortionLod=1 \
	informativeMask=3 \
	numThreads=8 \
	1> ${mapdir}LOD${lod}.map \
	2> ${mapdir}LOD${lod}.log
   echo "  ... getting physical positions for all markers"
   echo "  ... outputting matched physical positions to: ${mapdir}LOD${lod}.map.markers"
   ${scriptsdir}getMarkerPositions.py ${datafile} ${mapdir}LOD${lod}.map > ${mapdir}LOD${lod}.map.markers
done

### CHECK OUT MARKER ASSIGNMENT TO LGS BASED ON LOD CUTOFF
echo ""
seq $lodmin $lodstep $lodmax | while read lod
do echo "LOD cutoff: "${lod}
   grep -v "#" $mapdir/LOD${lod}.map | \
       sort -n | uniq -c | \
       sed -E 's/[ ]+/ /g' | sed 's/^ //' | awk '{print $2, $1}' | \
       sed 's/ /: /'| sed 's/^/  LG /' | sed 's/$/ markers/' | sed 's/LG 0/unassigned/'
   echo ""
done

