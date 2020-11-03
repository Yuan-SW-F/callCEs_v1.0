#!/bin/env Rscript

require(graphics)
args<-commandArgs(TRUE)

da <- read.table(args[1])
pvalue <- da$V7
fdr <- p.adjust(pvalue,method='fdr')
da$V8 <- fdr
#write.table(da,file='test',sep ="\t",row.names =FALSE,col.names =TRUE,quote =FALSE)
write.table(da,file=args[2],sep ="\t",row.names =FALSE,col.names =FALSE,quote =FALSE)
