#!/usr/bin/env Rscript
# File Name: /vol3/asbc/CHENGSHIFENG_GROUP/fuyuan/02.Nfix/00.81species_CNE/05.CNE/04.distribution/R.R
# Author: fuyuan, 907569282@qq.com
# Created Time: 2019-11-26 17:57:07

args <- commandArgs(T)
file <- read.table(args[1])
files = 0
a <- t(file[1])
b <- t(file[2])

file <- read.table(args[2])
c <- t(file[1])
d <- t(file[2])

#print (a[0:500])

ins <- c(1:99)
i_i = (d[1]-d[101])/100
print (d[1])
ins[1] = d[1] + i_i
for (i in 2:99){
	ins[i] = ins[i-1] + i_i
}
#print (ins)
e <- c(a[1:500], 0,     c[52:101],ins, c[1:50], 0,     a[502:1001])
f <- c(b[1:500], d[52], d[52:101],ins, d[1:50], d[50], b[502:1001])

print (e)
pdf (paste(args[1],'.pdf',sep = ''))
nm <- strsplit(args[1], split='.', fixed=TRUE)
nm <- unlist(lapply(nm,head,1))

#pdf ('test.pdf')
par(mar=c(20,2,1.5,1))
plot(c(1:1201), f, type='l',col='blue', lwd=1, xaxt = "n", yaxt ="n", tcl = 0.2, xlab = "" )
x_seq <- c(1, 101, 201, 301, 401, 501, 551, 651, 701, 801, 901, 1001, 1101, 1201)
l_seq <- c(-50000, -40000, -30000, -20000, -1000, 'TSS', 5000, -5000, 'TES', 10000, 20000, 30000, 40000, 50000)
axis(1, at= seq(1,1201,10), cex.axis = 0.01, tcl = 0.1)

axis(1, at= x_seq, label=l_seq, cex.axis = 0.5, xlab = 'distence', tcl = 0.2, las = 1)
#axis(1, at= seq(1,1201,100), cex.axis = 0.01, tcl = 0.1)
axis(2, mgp = c(0, 0, 0), cex.axis = 0.5, tcl = 0.2)
title(xlab = "Distance of CNE to genes (100bp windows)", ylab = "CNE Number", line = 0.5, cex.lab=0.5, main = nm, cex.main = 1)

