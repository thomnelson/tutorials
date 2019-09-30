#!/bin/bash

mappingdir="./"
scriptsdir="./scripts/"
vcfFile=${mappingdir}/datafiles/SFxIM767_plate1.scaf6scaf10.vcf
ped=${mappingdir}pedigree.txt
lepmapdir="./lepMAP3/bin/"

### USE PARENTCALL MODULE TO CORRECT PARENTAL GENOTYPES
echo "Correcting parental genotypes based on offspring genotypes..."
java -cp $lepmapdir ParentCall2 \
     data=$ped \
     vcfFile=$vcfFile \
     removeNonInformative=1 1> \
     ${mappingdir}/posteriors.called \
     2> ${mappingdir}/posteriors.called.log
