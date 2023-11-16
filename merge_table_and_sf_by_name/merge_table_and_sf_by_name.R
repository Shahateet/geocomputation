# Ice Thickness Model Evaluation Script

# File Paths
tab_file = "/path/to/file/evaluation_2.csv"
shp_file = "/path/to/file/flux_gates_Shahateet_et_al_2023.gpkg"
o_file = "/path/to/file/evaluation_with_fluxgates_2.shp"

# Load Libraries
library(sf)
library(dplyr)

# Read Data
tab = read.table(tab_file, stringsAsFactors = FALSE, header = TRUE, sep = ",") # read table
shp = read_sf(shp_file) # read shapefile
shp_short = shp[, c("id", "geom")] #get only the id and geometry of the shapefile

# Merge Data
shp_full_data = right_join(tab, shp_short, by = c("glacier" = "id")) 

# Write Output Shapefile
write_sf(shp_full_data, o_file)
