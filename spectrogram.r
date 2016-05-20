#!/usr/bin/env Rscript
suppressMessages(library(tuneR))
suppressMessages(library(seewave))

args=commandArgs(trailingOnly=T)
for (x in args) {
	v=readWave(x)
	rate=readWave(x, header=T)$sample.rate
	n=min(1024, length(v))
	cat(x)
	print(v)
	spectro(v@left, f=rate, osc=T, main=paste(x, "(left)"))
	if (v@stereo)
		spectro(v@right, f=rate, osc=T, main=paste(x, "(right)"))
}
