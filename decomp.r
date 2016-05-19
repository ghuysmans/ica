#!/usr/bin/env Rscript
library(audio)
library(fastICA)

args=commandArgs(trailingOnly=T)
if (length(args) < 4)
	stop("usage: decomp.r n_sources mix1 mix2 [...] output")
nsrc=as.numeric(args[1])
outfile=args[length(args)]

mixes=lapply(args[2:(length(args)-1)], function(x) {
	cat("Loading", x, "\n")
	w=load.wave(x)
	cat("OK: rate", w$rate, "duration", length(w)/w$rate, "s\n")
	return(w)
})

#validate input and assign "first"
invisible(sapply(mixes, function(x){
	if (!exists("first"))
		first <<- x
	if (first$rate != x$rate)
		stop("sampling rate mismatch!")
	if (length(first) != length(x))
		stop("input size mismatch!")
}))

cat("Running fastICA...\n")
mixes=matrix(sapply(mixes, identity), ncol=length(mixes))
R=fastICA(mixes, nsrc, row.norm=F)
out=apply(R$S, 2, function(v){
	v=v-mean(v) #center
	v/max(abs(max(v)), abs(min(v))) #scale
})

cat("Writing", outfile, "\n")
w=as.audioSample(t(out), first$rate, first$bits)
save.wave(w, outfile)

R$A
