#!/bin/sh

sample=$1
describer=$(echo ${sample} | sed 's/.sorted.bam//')

samtools view -b ${describer}.sorted.bam scaffold{00..99} > filter/${describer}.bam
