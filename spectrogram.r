#!/usr/bin/env Rscript
library(audio)
suppressMessages(library(signal))

args=commandArgs(trailingOnly=T)
for (x in args) {
	v=load.wave(x)
	n=min(1024, length(v))
	plot(specgram(v, n, v$rate, hanning(n)))
	title(x)
}
