# Gun Ownership Analysis by Region and Gender (2018 GSS)
# Purpose: Analyze gun ownership patterns by gender and census divisions
# Author: Shipu Debnath
# Date: August 23, 2025

# Install and load required packages
if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")
if (!requireNamespace("vcd", quietly = TRUE)) install.packages("vcd")
if (!requireNamespace("WVPlots", quietly = TRUE)) install.packages("WVPlots")
if (!requireNamespace("gmodels", quietly = TRUE)) install.packages("gmodels")
if (!requireNamespace("tigris", quietly = TRUE)) install.packages("tigris")
if (!requireNamespace("sf", quietly = TRUE)) install.packages("sf")
if (!requireNamespace("tmap", quietly = TRUE)) install.packages("tmap")
if (!requireNamespace("rmapshaper", quietly = TRUE)) install.packages("rmapshaper")

library(tidyverse)    # Data manipulation and visualization
library(vcd)          # Visualizing categorical data
library(WVPlots)      # Enhanced plotting
library(gmodels)      # Statistical models
library(tigris)       # U.S. census spatial data
library(sf)           # Spatial data handling
library(tmap)         # Thematic maps
library(rmapshaper)   # Simplify spatial data

# Load and preprocess GSS 2018 data (replace with actual source if needed)
# Assuming GSS2018 is a data frame; e.g., GSS2018 <- haven::read_sav("data/gss2018.sav")
if (!exists("GSS2018")) stop("GSS2018 dataset not found. Load or define it first.")
gun_data <- GSS2018 |> 
  select(SEX, REGION, OWNGUN) |> 
  haven::zap_label() |>  # Remove labels for consistency
  na.omit()  # Remove rows with missing values

# Filter and label factors
gun_processed <- gun_data[gun_data$OWNGUN < 3, ]  # Keep Yes/No responses (0, 1)
gun_processed$SEX <- factor(gun_processed$SEX, labels = c("Male", "Female"))
gun_processed$OWNGUN <- factor(gun_processed$OWNGUN, labels = c("Yes", "No"))

# Define census divisions
census_divs <- c("New England", "Middle Atlantic", "East North Central", 
                 "West North Central", "South Atlantic", "East South Central", 
                 "West South Central", "Mountain", "Pacific")
gun_processed$CenDiv <- factor(gun_processed$REGION, labels = census_divs)

# Summary of processed data (excluding REGION)
summary(gun_processed[, -2])

# Load and preprocess U.S. states spatial data
states <- states() %>% 
  filter(!STUSPS %in% c("HI", "AK", "PR", "GU", "VI", "AS", "MP")) %>% 
  ms_filter_islands(min_area = 12391399903)  # Remove small islands

# Aggregate to census divisions
divisions <- states %>% 
  group_by(DIVISION) %>% 
  summarize()

# Visualize gun ownership by gender
ShadowPlot(gun_processed, "SEX", "OWNGUN", title = "Gun Ownership by Gender")
ggsave("plots/gun_ownership_by_gender.png", width = 8, height 6)

# Visualize gun ownership by census division
ShadowPlot(gun_processed, "CenDiv", "OWNGUN", title = "Gun Ownership by Census Divisions")
ggsave("plots/gun_ownership_by_division.png", width = 10, height 6)

# Cross-tabulation and percentage calculation
CrossTable(gun_processed$CenDiv, gun_processed$OWNGUN, prop.chisq = FALSE, 
           prop.t = FALSE, prop.c = FALSE)
pct_gun <- round(prop.table(table(gun_processed$CenDiv, gun_processed$OWNGUN), 1) * 100, 1)
pct_gun <- cbind(Percent = pct_gun[1:9], NAME = census_divs[1:9])
map_data <- bind_cols(divisions, pct_gun)
map_data$Percent <- as.numeric(map_data$Percent)

# Create choropleth map
gun_map <- tm_shape(map_data) + 
  tm_fill(col = "Percent", n = 2, palette = "Blues") + 
  tm_borders("white") + 
  tm_text("NAME", size = 0.5) + 
  tm_layout(title = "Gun Ownership by Census Divisions",
            title.size = 1, title.position = c("center", "top"))
print(gun_map)
tmap_save(gun_map, "plots/gun_ownership_map.png")

# Chi-square test and association statistics
chi_result <- chisq.test(gun_processed$CenDiv, gun_processed$OWNGUN)
print("Chi-Square Test Result:")
print(chi_result)
print("Standardized Residuals:")
print(chi_result$stdres)

ovr_table <- table(gun_processed$OWNGUN, gun_processed$CenDiv)
assoc_stats <- assocstats(ovr_table)
print("Association Statistics:")
print(assoc_stats)

# Save statistical results
sink("results/statistical_summary.txt")
cat("Chi-Square Test and Association Results:\n")
print(chi_result)
print(chi_result$stdres)
print(assoc_stats)
sink()
