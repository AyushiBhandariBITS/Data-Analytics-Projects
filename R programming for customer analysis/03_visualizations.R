library(ggplot2)
library(data.table)
library(plotly)
library(tidyverse)
# Load clustered RFM
rfm <- fread("rfm_clusters.csv")

# Cluster Summary
cluster_summary <- rfm %>%
  group_by(Cluster) %>%
  summarise(
    Avg_Recency = mean(Recency),
    Avg_Frequency = mean(Frequency),
    Avg_Monetary = mean(Monetary),
    Count = n()
  )

# Bar Plot – Frequency & Monetary by Cluster
ggplot(cluster_summary, aes(x = Cluster, y = Avg_Monetary, fill = Cluster)) +
  geom_bar(stat = "identity") +
  labs(title = "Avg Monetary Value per Cluster", y = "Monetary Value") +
  theme_minimal()

# Save as HTML (for dashboard use)
ggplotly()
