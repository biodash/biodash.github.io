# SET-UP -----------------------------------------------------------------------

# Install/load packages
if(! 'pacman' %in% installed.packages()) install.packages('pacman')

packages <- c('DESeq2',          # Differential expression analysis
              'tidyverse',       # Misc. data manipulation and plotting
              'here',            # Managing file paths
              'pheatmap')        # Heatmap plot

pacman::p_load(char = packages)

# Set ggplot theme
theme_set(theme_bw())

# Load the data
count_table_file <- here("results/count/gene_counts_all.txt")
metadata_file <- here("data/meta/metadata.txt")

## Create output dirs
outdir <- here("results/DE/")
plotdir <- here("results/DE/fig/")

if (!dir.exists(outdir)) dir.create(outdir, recursive = TRUE)
if (!dir.exists(plotdir)) dir.create(plotdir, recursive = TRUE)

# PREPARE DATA -----------------------------------------------------------------

# Load input data
raw_counts <- read.table(count_table_file,
                         sep = "\t", header = TRUE, skip = 1)

my_regex <- ".+PonceM_(.+)_V1N.+"
colnames(raw_counts) <- sub(my_regex, "\\1", colnames(raw_counts))

counts <- raw_counts[, 7:ncol(raw_counts)]
rownames(counts) <- raw_counts$Geneid

# Read metadata
metadata <- read.table(metadata_file, header = TRUE)
metadata$Treatment <- sub("Agrobacterium_", "", metadata$Treatment)

# Sum replicate samples
counts.t <- t(counts)
rownames(counts.t) <- names(raw_counts)[7:36]
sums <- rowsum(counts.t, group = rownames(counts.t))
counts <- t(sums)

## Check sample IDs
metadata <- metadata[order(metadata$SampleID), ]
counts <- counts[, order(colnames(counts))]

# Create the DESeq2 object
dds_raw <- DESeqDataSetFromMatrix(countData = counts,
                                  colData = metadata,
                                  design = ~ 1)

# Remove no-exp treatment samples
dds_raw <- dds_raw[, -which(dds_raw@colData$Treatment == "noexp")]

# DE ANALYSIS ------------------------------------------------------------------

# Create single factor from two
dds_raw$group <- factor(paste(dds_raw$AMF, dds_raw$Treatment, sep = "_"))
table(dds_raw$group)

# Set the “reference” level of the factor to double negative control
dds_raw$group <- relevel(dds_raw$group, ref = "control_mock")
dds_raw$group

# Set the analysis design:
design(dds_raw) <- formula(~ group)

# Perform the differential expression analysis with the DEseq() function
dds <- DESeq(dds_raw)

# Check the results table
res <- results(dds)
res

# CONTRAST TWO CUSTOM GROUPS ---------------------------------------------------

