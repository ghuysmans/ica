#!/usr/bin/env Rscript
library(audio)
library(fastICA)
library(signal)

args=commandArgs(trailingOnly=T)
f1=load.wave(args[1])
f2=load.wave(args[2])
if (f1$rate != f2$rate) {
	f1$rate
	f2$rate
	stop("sampling rate mismatch!")
}
rate=f1$rate
if (length(f1) != length(f2)) {
	paste(length(f1)/rate, "s")
	paste(length(f2)/rate, "s")
	stop("input size mismatch!")
}

X=matrix(c(f1, f2), ncol=2)
R=fastICA(X, 2, row.norm=F)
to_samples=function(v){
	#center and scale
	v=v-mean(v)
	v=v/max(abs(max(v)), abs(min(v)))
}
s1=to_samples(R$S[,1])
s2=to_samples(R$S[,2])

m=matrix(c(s1, s2), nrow=2, byrow=T)
w=as.audioSample(m, rate, min(f1$bits, f2$bits))
save.wave(w, args[3])

R$A
