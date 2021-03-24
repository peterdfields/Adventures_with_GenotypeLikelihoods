# Let's start by indexing all of our bam files

ls *.bam | parallel samtools index '{}'

# Depending upon the contiguity of your assembly, assembly size, and goal of PCA analysis you may wish to do the whole genome
# or just a subset. Here I'm going to do the first 100 scaffolds for an example where the reference is still quite 
# fragmented. So we need to subset our bam files. We're going to use a script so that we can parallelize the samtools run. The
# script is called filter_bam.sh and we're going to run it with the following command:

ls *.sorted.bam | parallel -j16 -k bash filter_bam.sh {}

# now that we have the subsetted bam files we can move into generating a file with allele frequencies (angsdput.mafs.gz) 
# and a file with genotype likelihoods (angsdput.glf.gz)
# let's create a list of input bam files in a directory that contains only the filtered bam files

ls *.bam > bam.filelist

angsd -b bam.filelist -nThreads 12 -gl 2 -domajorminor 1 -snp_pval 1e-6 -domaf 1 -minmaf 0.05 -doGlf 3

# We extract the frequency column from the allele frequency file and remove the header (to make it in the format NgsRelate needs)

zcat angsdput.mafs.gz | cut -f5 |sed 1d >freq

# now we can run ngsRelate; note that the number after '-n' needs to be the number of individuals genotyped

ngsrelate  -g angsdput.glf.gz -n 100 -f freq  -O newres

# the file 'newres' provides the necessary information to get different types of relatedness from each pairwise comparison

