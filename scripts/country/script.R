require(ggplot2)
require(RColorBrewer)
require(vegan)
require(dplyr)

data <- read.csv("italy.csv", stringsAsFactors=FALSE)

# records per year and phylum

palette <- colorRampPalette(brewer.pal(8, "Paired"))(length(unique(data$phylum)))

ggplot() +
  geom_histogram(data=data, aes(x=year, fill=phylum), binwidth=1) +
  scale_fill_manual(values=palette)

# some numbers

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

# with custom taxonomic groups

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

# rarefaction curve

data <- data %>% filter(!is.na(species) & !is.na(year))
currentyear <- as.numeric(format(Sys.Date(), "%Y"))
data$year2 <- factor(data$year, levels=seq(min(data$year), currentyear))
t <- xtabs(~ year2 + species, data=data)
acc <- specaccum(t)
plot(acc, xlab="years")
specpool(t)

accdf <- data.frame(richness=acc$richness, sd=acc$sd, years=acc$sites)

# repeat...

ggplot() + 
  geom_ribbon(data=accdf1, aes(x=years, ymin=richness-sd, ymax=richness+sd, fill="italy")) +
  geom_line(data=accdf1, aes(x=years, y=richness)) +
  geom_ribbon(data=accdf2, aes(x=years, ymin=richness-sd, ymax=richness+sd, fill="belgium")) +
  geom_line(data=accdf2, aes(x=years, y=richness)) +
  geom_ribbon(data=accdf3, aes(x=years, ymin=richness-sd, ymax=richness+sd, fill="iran")) +
  geom_line(data=accdf3, aes(x=years, y=richness)) +
  scale_fill_manual(name="EEZ", values=c("italy"="#BEC19D", "belgium"="#ECD286", "iran"="#94B8CD"), labels=c("italy"="Italy", "belgium"="Belgium", "iran"="Iran"))
