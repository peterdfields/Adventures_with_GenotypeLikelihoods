# read the data into R

cov <- as.matrix(read.table("output.cov"))

# let's estimate eigenvectors and values from the covariance matrix create by PCAngsd

e<-eigen(cov)

# let's import a table that can provide population IDs for each of the sample we ran the PCA on

ID<-read.table("pop.list.tsv",head=T)

# now we can make the simple plot

pdf("PCAngsdDemo.pdf")

plot(e$vectors[,1:2],col=ID$POP)

dev.off()

# we can also get an estimate of variance explained by the different eigenvalues

example <- prcomp(cov, scale = TRUE)
eigenvals <- example$sdev^2
eigenvals/sum(eigenvals)

