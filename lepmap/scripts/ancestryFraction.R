
### function for computing observed heterozygosity for genotypes
###    valued by dosage of alternate allele
hetO <- function (x) {
    return(length(x[x == 1]) / length(x))
}

gmap <- "/Users/thom/Dropbox/2.Fishman_Lab/Data/guttatus/stigmaClosure/F2_IM767xSF/rqtl2/full/SFxIM767.gmap"
gmap <- read.table(gmap,
                   header=T,
                   sep=",",
                   stringsAsFactors = F)
gmap$marker <- paste0("X",gmap$marker)

# geno <- "/Users/thom/Dropbox/3.Workshops/lepmap/segDistX2_0005_Missing10/LOD12/SFxIM767.geno"
geno <- "/Users/thom/Dropbox/3.Workshops/lepmap/SFxIM767_SFinv.geno"
# geno <- "/Users/thom/Dropbox/2.Fishman_Lab/Data/guttatus/stigmaClosure/F2_IM767xSF/rqtl2/full/SFxIM767.geno"
geno <- read.table(geno, 
                   header=T,
                   row.names=1, 
                   sep=",",
                   stringsAsFactors = F
                   )
### CONVERT GENOTYPES TO 0,1,2
geno[geno == "SS"] <- "0"
geno[geno == "GS"] <- "1"
geno[geno == "GG"] <- "2"
n.indiv <- dim(geno)[1]
genoMat <- apply(X=geno,MARGIN=1,FUN=as.numeric)

### ID number of alleles present per individual and per marker
###   (matrix dimensions * 2)
n.alleles.PerInd <- dim(genoMat)[1] * 2
n.alleles.PerMarker <- dim(genoMat)[2] * 2

### CALCULATE GUTTATUS ANCESTRY PER INDIVIDUAL (FOR ANCESTRY PROPORTIONS)
###    AND PER MARKER (FOR SEGREGATION DISTORTION)
guttAncPerInd <- apply(X=genoMat, MARGIN=2, FUN=sum)
guttAncPerInd <- guttAncPerInd / n.alleles.PerInd

guttAncPerMarker <- apply(X=genoMat, MARGIN=1, FUN=sum)
hetObsPerMarker  <- apply(X=genoMat,MARGIN=1,hetO)
hetExpPerMarker  <- 2 * (guttAncPerMarker/n.alleles.PerMarker) * (1 - guttAncPerMarker/n.alleles.PerMarker)

layout(matrix(1:2,1,2,byrow=T))
hist(guttAncPerInd, breaks=seq(0,1,by=0.025),main="",
     xlab="guttatus ancestry per F2")
hist(guttAncPerMarker/n.alleles.PerMarker, breaks=seq(0,1,by=0.025),main="",
     xlab = "guttatus ancestry per marker")
layout(matrix(1:1))

markerBinomP <- NULL
for(i in 1:length(guttAncPerMarker)) {
    markerBinomP <- append(markerBinomP, -1*log10(binom.test(guttAncPerMarker[i], n.alleles.PerMarker, conf.level = 0.99)$p.value))
}

LG <- 7
hetO.LG <- hetObsPerMarker[gmap$chr == LG]
pval.LG <- markerBinomP[gmap$chr == LG]
plot(1:length(hetO.LG), hetO.LG,pch=20,ylim=c(0,1),yaxt='n',
     xlab = "marker index",ylab="Obs[heterozygosity]")
    axis(2, at=seq(0,1,by=0.1),las=1)
    # par(new=T)
    # plot(1:length(hetE.7), pval.7,pch=20,xaxt="n",yaxt="n",xlab="",ylab="")








plot(hetExpPerMarker, hetObsPerMarker,pch=20, xlim=c(0,1),ylim=c(0,1))

hetE.7 <- hetExpPerMarker[gmap$chr == 7]

plot(1:length(hetE.7), hetE.7,pch=20,ylim=c(0,1))

hetsPossible <- seq(0,1,by=(1/(n.alleles.PerMarker/2)))


binom.het <- dbinom(1:n.indiv, n.indiv, 0.5)

plot(1:125, binom.het, type="l")
