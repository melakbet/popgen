#!/usr/bin/env Rscript

library(pegas)
library(adegenet)
library(poppr)

## Attempt at a DAPC structure detection and AMOVA analysis
#Read in all the loci in the file
info <- VCFloci("Fus2_canu_contigs_unmasked_filtered.vcf")
SNP <- is.snp(info)
x <- length(which(SNP))
x <- read.vcf("Fus2_canu_contigs_unmasked_filtered.vcf", from = 1, to = x)
y <- loci2genind(x)

#Change ploidy to 1 for Fusarium data
ploidy(y) <- 1

#Number of individuals for maximum number of considered clusters
#a <- nInd(y) - 1

#Find the true number of genetic clusters.
#In Fusarium, the best k = numbers of individuals so doesn't really work
#grp <- find.clusters(y, n.pca=200, max.n.clust=a)
#dapc1 <- dapc(y, grp$grp, n.pca=200)
#scatter(dapc1)


#AMOVA analysis
#Note: classification into pathogens, non-pathogens and INTERMEDIATES not more informative than just a binary one
#Classify according to if pathogenic or not
other(y)$pathogen <- c("p", "p", "np", "np", "p", "np", "np", "np", "p", "np", "np")
#Classify according to the phylogeny (only mark out A13 as outlier)
other(y)$phylo <- c("a", "a", "a", "b", "a", "a", "a", "a", "a", "a", "a")

strata_df <- data.frame(other(y))
strata(y) <- strata_df
sink(file = "amova.txt", append = T, type = c("output", "message"), split = F)
amova.pegas <- poppr.amova(y, ~pathogen, method = "pegas")
amova.pegas
#Hierarchical AMOVA
amova.pegas <- poppr.amova(y, ~phylo/pathogen, method = "pegas")
amova.pegas
sink()
