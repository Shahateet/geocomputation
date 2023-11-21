# Header: Raster Downscaling Script
# Author: Kaian Shahateet
# Date: 2023/11/21

# Load the raster library
library(raster)

# Input file path
input_name <- "/path/to/file/MAR_mean_2011-2020_downscaled_11x11_masked_corrected.tif"

# Neighborhood size for focal operation
n <- 5

# Read the input raster file
r <- raster(input_name)

# Create the output file name based on the input file name and neighborhood size
out_name <- paste0(input_name, n, "x", n, ".tif", sep = "")

# Apply focal operation to calculate the mean within a neighborhood
focal_r <- focal(r, matrix(rep(1, (n^2)), nrow = n, ncol = n), fun = "mean", na.rm = TRUE)

# Write the result to a new raster file
writeRaster(focal_r, out_name, overwrite = TRUE)
