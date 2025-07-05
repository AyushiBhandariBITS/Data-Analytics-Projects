library(tidyverse)
library(cluster)
library(factoextra)
library(NbClust)
library(scales)

# Load clean data
df <- fread("cleaned_retail_data.csv")

# Reference date
snapshot_date <- max(df$InvoiceDate) + 1

# RFM Calculation
rfm <- df %>%
  group_by(CustomerID) %>%
  summarise(
    Recency = as.numeric(snapshot_date - max(InvoiceDate)),
    Frequency = n_distinct(InvoiceNo),
    Monetary = sum(TotalAmount)
  )

# Scale RFM
rfm_scaled <- scale(rfm[, 2:4])

# Elbow method to find k
fviz_nbclust(rfm_scaled, kmeans, method = "wss")

# Apply K-Means
set.seed(123)
k_model <- kmeans(rfm_scaled, centers = 4, nstart = 25)

# Add cluster to RFM
rfm$Cluster <- as.factor(k_model$cluster)

# Save
fwrite(rfm, "rfm_clusters.csv")

