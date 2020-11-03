#!/usr/bin/R
warnings('off')

args<-commandArgs(TRUE)

da <- read.table(args[1], header=F, sep="\t")

fet_p <- rep(0,length(da[,1]))
for (i in 1:length(da[,1])){
        fet_p[i]=fisher.test(matrix(c(da[i,2], da[i,3], (26-da[i,2]), (34-da[i,3])),nrow = 2))$p.value  
}

fet_po <- rep(0,length(da[,1]))
for (i in 1:length(da[,1])){
        fet_po[i]=fisher.test(matrix(c((da[i,2]+da[i,3]), da[i,4], (60-da[i,2]-da[i,3]), (13-da[i,4])),nrow = 2))$p.value  
}


fdr_p <-p.adjust(fet_p, method="fdr")
fdr_po <-p.adjust(fet_po, method="fdr")

out <- cbind(da,fet_p,fet_po);
#filt_out <- subset(out, out[,12]<0.05)

write.table(out, file=args[2], sep="\t", col.names=FALSE, row.names=FALSE, quote=FALSE)

