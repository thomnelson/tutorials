#!/bin/bash

mappingdir="./"
scriptsdir="./scripts/"
vcfFile=${mappingdir}/datafiles/SFxIM767_plate1.scaf6scaf10.vcf
ped=${mappingdir}pedigree.txt
lepmapdir="./lepMAP3/bin/"

mapdir=${mappingdir}"segDistX2_0005_Missing10/"
datafile=$mapdir/posteriors.called.filtered

lod=12
nLGs=2

### LINK SOME DATA FILES SO THAT EVERYTHING WE NEED APPEARS IN ONE DIRECTORY
mkdir -p ${mapdir}LOD${lod}
ln -s ${mapdir}LOD${lod}.map ${mapdir}LOD${lod}/
ln -s ${mapdir}LOD${lod}.log ${mapdir}LOD${lod}/
ln -s ${datafile} ${mapdir}LOD${lod}/
ln -s ${mapdir}LOD${lod}.map.markers ${mapdir}LOD${lod}/

### RUN ORDER MARKERS

echo "Mapping with a LOD cutoff of "${lod}"."
echo "  Ordering markers for the largest "${nLGs}" LGs."
seq ${nLGs} | while read lg
do echo "Ordering markers in LG"$lg"..."
   java -cp $lepmapdir OrderMarkers2 \
	data=${datafile} \
        map=${mapdir}LOD${lod}.map \
	informativeMask=3 useKosambi=1 numThreads=1 chromosome=$lg \
	grandparentPhase=1 \
	sexAveraged=1 \
	outputPhasedData=1 \
	1> ${mapdir}LOD${lod}/LOD${lod}_lg${lg}.txt \
	2> ${mapdir}LOD${lod}/LOD${lod}_lg${lg}.log
done
