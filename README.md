# Gun Ownership Analysis

## Overview
This project analyzes gun ownership patterns from the 2018 General Social Survey (GSS) by gender and U.S. census divisions, using statistical tests and spatial visualization in R.

## Dependencies
- R (>= 4.0)
- Packages: `tidyverse`, `vcd`, `WVPlots`, `gmodels`, `tigris`, `sf`, `tmap`, `rmapshaper`
- Install: `install.packages(c("tidyverse", "vcd", "WVPlots", "gmodels", "tigris", "sf", "tmap", "rmapshaper"))`

## Data
- Source: 2018 General Social Survey (`GSS2018`)
- Location: `/data/gss2018.sav` (include file or link to source)

## Usage
1. Clone the repository: `git clone https://github.com/ShipuDebnath/gun-ownership-analysis.git`
2. Open R and set the working directory to the repo folder.
3. Load data (e.g., `GSS2018 <- haven::read_sav("data/gss2018.sav")`).
4. Run the script: `source("scripts/gun_ownership_analysis.R")`
5. Outputs:
   - Plots in `plots/` (e.g., shadow plots, map)
   - Statistical results in `results/statistical_summary.txt`

## Key Findings
- Significant association between census division and gun ownership (chi-square test).
- Spatial variation in ownership percentages visualized.

## Author
Shipu Debnath  
MS Student in Geography, Texas Tech University  
[LinkedIn](https://linkedin.com/in/shipudebnath/) | [Google Scholar](https://scholar.google.com/citations?user=WyP6KUUAAAAJ&hl=en)

## License
MIT License
