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

### if an output datafile exists from a previous run, remove it or exit the script
echo "Checking for existing LGs file..."
if [ -f ${mapdir}LOD${lod}/LOD${lod}_lgs.txt ]
then rm -i ${mapdir}LOD${lod}/LOD${lod}_lgs.txt
fi

if [ -f ${mapdir}LOD${lod}/LOD${lod}_lgs.txt ]
then exit
fi

### concatenate LGs into a single file

echo "Concatenating linkage groups to a single file..."
seq $nLGs | while read lg
do grep -v "#" ${mapdir}LOD${lod}/LOD${lod}_lg${lg}.txt | cut -f 1,2 \
	>> ${mapdir}LOD${lod}/LOD${lod}_lgs.txt
done
echo "  outputting LGs to ${mapdir}LOD${lod}/LOD${lod}_lgs.txt"
### get all the info for all markers

echo "Getting scaffold positional information for all markers..."
${scriptsdir}getLGinfo.py ${mapdir}/LOD${lod}/LOD${lod}_lgs.txt ${mapdir}/LOD${lod}.map.markers \
	 > ${mapdir}/LOD${lod}/LOD${lod}_lgs_withScaffolds.txt
echo "  outputting physical postion-matched data to ${mapdir}/LOD${lod}/LOD${lod}_lgs_withScaffolds.txt"

### CONVERT TO RQTL2 DATA FORMAT

${scriptsdir}lepmap2rqtl2.py \
   --mapfiles          $(seq $nLGs | while read lg ; do echo -n "${mapdir}/LOD${lod}/LOD${lod}_lg${lg}.txt " ; done) \
   --pedigree          ${ped} \
   --physicalpositions segDistX2_0005_Missing10/LOD12/LOD12_lgs_withScaffolds.txt \
   --outprefix         ${mapdir}/LOD${lod}/SFxIM767