############################################################################
#                                                                          #
# Author: Kaian Shahateet                                                  #
# Version: 1.0                                                             #
#                                                                          #
# Code to extract the viscosity generated from paraview to the flighlines  #
#                                                                          #
# Remember to adjust also the column numbers to your onw data set. It will #
# not work without adjustments and proper understand of the code. Sorry =( #
# Take a look into the data set uploaded to the parent folder              #
#                                                                          #
############################################################################

# Load required libraries
library(sf)
library(sp)
library(snow)
library(qgisprocess)

# Define file paths
path_gridded_points <- "/path/to/file/10059/merged.csv"
path_measurements_points <- "/path/to/file/input/thi_obs/OIB_2023-03-17_reduced_bash_500m_reduced500m.csv"
output_path_shp <- "/path/to/file/pvtu_flightlines.shp"
output_path_csv <- "/path/to/file/pvtu_flightlines.csv"
output_path_grid_shp <- "/path/to/file/grid.shp"
output_path_grid_csv <- "/path/to/file/grid.csv"

# Read input data
gridded_points <- st_read(path_gridded_points, options = c("X_POSSIBLE_NAMES=x", "Y_POSSIBLE_NAMES=y"), stringsAsFactors = FALSE, quiet = TRUE)
measurements_points <- st_read(path_measurements_points, options = c("X_POSSIBLE_NAMES=Lon", "Y_POSSIBLE_NAMES=Lat"), stringsAsFactors = FALSE, quiet = TRUE)

# Reduce table of gridded_points
gridded_points_simp <- gridded_points[, c(80, 81, 20, 83)]
gridded_points_tab <- gridded_points[, c(80, 81)]
gridded_points_tab <- st_drop_geometry(gridded_points_tab)

# Set coordinate reference systems (CRS)
gridded_points_simp <- st_set_crs(gridded_points_simp, 3031)  # Set CRS for gridded_points
measurements_points <- st_set_crs(measurements_points, 4326)  # Set CRS for measurements_points

# Transform and buffer measurements points
measurements_points_rep <- st_transform(measurements_points, st_crs(gridded_points))
measurements_buffered <- st_buffer(measurements_points_rep, dist = 1, endCapStyle = "ROUND")

# Run QGIS algorithm to clip gridded_points with buffered measurements
result <- qgis_run_algorithm("native:clip", INPUT = gridded_points_simp, OVERLAY = measurements_buffered)
gridded_points_flightlines <- sf::read_sf(qgis_extract_output(result, "OUTPUT"))
gridded_points_flightlines_csv <- st_drop_geometry(gridded_points_flightlines[, c(1, 2, 3)])

# Write output files
write_sf(gridded_points_flightlines, output_path_shp)
write_sf(gridded_points_simp, output_path_grid_shp)
write.table(gridded_points_tab, file = output_path_grid_csv, sep = ",", append = FALSE, quote = FALSE, col.names = TRUE, row.names = FALSE)
write.table(gridded_points_flightlines_csv, file = output_path_csv, sep = ",", append = FALSE, quote = FALSE, col.names = TRUE, row.names = FALSE)
