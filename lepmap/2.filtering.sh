#!/bin/bash

mappingdir="./"
scriptsdir="./scripts/"
vcfFile=${mappingdir}/datafiles/SFxIM767_plate1.scaf6scaf10.vcf
ped=${mappingdir}pedigree.txt
datafile=${mappingdir}/posteriors.called
lepmapdir="./lepMAP3/bin/"

### SET CHI-SQUARED CUTOFFS AND MISSING DATA RATES FOR FILTERING
x2="05
001
0005"
missing="10
"

### USE THE FILTERING MODULE TO FILTER BASED ON SEGREGATION DISTORTION TOLERANCE (CHI-SQUARED)
###   AND MISSING DATA ALLOWED
### LOOP THROUGH CHI-SQUARED CUTOFFS 
echo "Filtering markers in file: "${datafile}
echo "   file contains "$(grep -v "#" $datafile | grep -v -c "POS")" markers"
echo ""
for chi in $x2
do echo "  Filtering for segregation distortion with Chi-square cutoff of 0.${chi}..."
   ### ... AND THROUGH MISSING DATA ALLOWANCE
   for miss in $missing
   do echo "   ... and max missing data of ${miss}%."
      mkdir -p ${mappingdir}segDistX2_${chi}_Missing${miss}/
      java -cp $lepmapdir Filtering2 \
	   data=$datafile dataTolerance=0.$chi MAFLimit=0.$miss \
		  removeNonInformative=1 1> \
		  ${mappingdir}segDistX2_${chi}_Missing${miss}/posteriors.called.filtered \
		  2> ${mappingdir}segDistX2_${chi}_Missing${miss}/posteriors.called.filtered.log
      echo "       output data file: ${mappingdir}segDistX2_${chi}_Missing${miss}/posteriors.called.filtered"
      echo "       "$(grep -v "#" ${mappingdir}segDistX2_${chi}_Missing${miss}/posteriors.called.filtered | grep -v -c "POS")" markers passed filtering"
      echo ""
   done
done