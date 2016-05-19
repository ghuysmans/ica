#!/usr/bin/env Rscript
library(audio)
suppressMessages(library(seewave))

args=commandArgs(trailingOnly=T)
for (x in args) {
	v=load.wave(x)
	n=min(1024, length(v))
	spectro(v, f=v$rate, osc=T, main=x) #, flim=c(0,5))
}
