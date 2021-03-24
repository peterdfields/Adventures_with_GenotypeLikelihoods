# Let's start by indexing all of our bam files

ls *.bam | parallel samtools index '{}'

# Depending upon the contiguity of your assembly, assembly size, and goal of PCA analysis you may wish to do the whole genome
# or just a subset. Here I'm going to do the first 100 scaffolds for an example where the reference is still quite 
# fragmented. So we need to subset our bam files. We're going to use a script so that we can parallelize the samtools run. The
# script is called filter_bam.sh and we're going to run it with the following command:

ls *.sorted.bam | parallel -j16 -k bash filter_bam.sh {}

# now that we have the subsetted bam files we can move into generating our genotype likelihoods in beagle format
# let's create a list of input bam files in a directory that contains only the filtered bam files

ls *.bam > bam.filelist

angsd -GL 2 -out data -nThreads 15 -doGlf 2 -doMajorMinor 1 -doMaf 2 -uniqueOnly 1 -remove_bads 1 \
	-only_proper_pairs 1 -trim 0 -C 50 -baq 1  -minMapQ 20 -minQ 20 -minInd 5 -SNP_pval 1e-6 -bam bam.filelist -ref ref.fasta

# We have a couple new files now of the genotypes in beagle format, mainly data.beagle.gz and data.mafs.gz
# let's get a PCA plus a neighbor joining tree. Note, add sample list to get proper names on each tip
# It's basically the same as the bam.filelist, just use sed to get the .bam off the file

sed 's/.bam//g' bam.filelist > sample.list
python pcangsd.py -beagle data.beagle.gz -out output -threads 15 -tree -tree_samples sample.list

# You can open the file output.tree in figtree or whatever tree visualization software you wish to use
# Move to R script to generate PCA plot.




