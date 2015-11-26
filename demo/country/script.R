require(ggplot2)
require(RColorBrewer)

data <- read.csv("belgium.csv", stringsAsFactors=FALSE)

# Records per year and phylum

palette <- colorRampPalette(brewer.pal(8, "Paired"))(length(unique(data$phylum)))

ggplot() +
  geom_histogram(data=data, aes(x=year, fill=phylum), binwidth=1) +
  scale_fill_manual(values=palette)

# Some numbers

records <- nrow(data)
species <- length(unique(data$species))
phyla <- length(unique(data$phylum))
years <- length(unique(data$year))
datasets <- length(unique(data$resource_id))

cat("Number of records:", records)
cat("Number of species:", species)
cat("Number of phyla:", phyla)
cat("Number of years:", years)
cat("Number of datasets:", datasets)

# Custom taxonomic groups

groups <- c("Nematoda", "Bivalvia", "Gastropoda")

data$group <- "Other"
classification <- apply(data[,c("phylum", "class", "order", "family")], 1, paste, collapse=";")
matches <- sapply(groups, function(x) { grep(x, classification) })
for (g in groups) {
  data$group[matches[[g]]] <- g
}

palette <- brewer.pal(length(groups) + 1, "Paired")
ggplot() +
  geom_histogram(data=data, aes(x=year, fill=group), binwidth=1) +
  scale_fill_manual(values=palette)

