# R Script to process raster data and create shapefiles for maximum values in each year

# Load required libraries
library(ncdf4)
library(raster)
library(dplyr)
library(sf)

# Set years of interest
years = c(2011:2020)

# Set input folder and get a list of files
in_folder = "/media/kaian/Kaian_data/Backups/Grobin_and_Framheim/data/AP_data/SMB_AP_Dethinne_2008-2022_processed_KAIAN/processed_KAIAN_new/"
files = list.files(in_folder, pattern = ".tif", full.names = TRUE)

# Loop through each year
for (i in 1:length(years)) {
  # Load raster file for the current year
  eval(parse(text = paste("tif_", years[i], " = raster('", files[i], "')", sep = "")))

  # Get the maximum value for the current year
  tif_i = raster(files[i])
  max_i = cellStats(eval(parse(text = paste("tif_", years[i], sep = ""))), stat = 'max', na.rm = TRUE)

  # Assign the maximum value to a variable with the year
  eval(parse(text = paste("max_", years[i], " = max_i", sep = "")))

  # Get the location (cell) of the maximum value
  cell_max = raster::Which(tif_i == max_i, cells = TRUE)
  xy_i = xyFromCell(eval(parse(text = paste("tif_", years[i], sep = ""))), cell_max)

  # Create a data frame with coordinates and maximum value
  dd <- data.frame(x = xy_i[1],
                   y = xy_i[2],
                   value = max_i)

  # Convert data frame to spatial features (sf) object
  sf <- sf::st_as_sf(dd, coords = c("x", "y"))

  # Set the coordinate reference system (CRS) for the sf object
  st_crs(sf) = raster::proj4string(eval(parse(text = paste("tif_", years[i], sep = ""))))

  # Create a name for the shapefile
  shp_name = paste0(in_folder, "max_shp_", years[i], ".shp", sep = "")

  # Write the shapefile to disk
  write_sf(sf, shp_name)
}

# End of script
