# Load libraries
library(tidyverse)
library(lubridate)
library(data.table)

# Load data
df <- read.csv("Online Retail Data Set.csv", encoding = "Latin-1")
df
# Clean data
df <- df[!is.na(CustomerID) & Quantity > 0 & UnitPrice > 0]

# Convert InvoiceDate to Date format
df$InvoiceDate <- dmy_hm(df$InvoiceDate)
df$InvoiceDate <- as.Date(df$InvoiceDate)

# Create TotalAmount column
df$TotalAmount <- df$Quantity * df$UnitPrice

# Remove duplicates
df <- df[!duplicated(df), ]

# Save clean data
fwrite(df, "cleaned_retail_data.csv")
