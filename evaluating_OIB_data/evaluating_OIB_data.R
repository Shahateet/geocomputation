###########################################################################                                                                         #
# Author: Kaian Shahateet                                                 #
# Version: 1.0                                                            #
#                                                                         #
# Code to evaluate the ice thickness measurements of OIB comparing to     #
# Huss and Farinotti and Carrivick.                                       #
#                                                                         #
# This code is not well structured                                        #
###########################################################################

# Load required libraries
library(sf)
library(raster)
library(dplyr)
library(stringr)  # For working with strings (pattern matching)
library(spData)
library(tidyr)
library(rgdal)
library(starsExtra)

# Load raster data
carrivick = raster("/media/kaian/Data/desktop_framheim/Ice_discharge_all/ice-discharge_AP_200m_res_200m_points_carrivick_APIS/ice-thickness_200m_res/Carrivick/carrivick_200m_masked_rock_outcrops_filled_cropped_NA_as_zero.tif")
huss = raster("/media/kaian/Data/desktop_framheim/Ice_discharge_all/ice-discharge_AP_200m_res_200m_points_carrivick_APIS/ice-thickness_200m_res/H_and_F/thickness_reprojected_200m.tif")
dem = raster("/media/kaian/Kaian_data/Backups/Grobin_and_Framheim/data/REMA/rema_mosaic_100m_v2.0_filled_cop30/rema_mosaic_100m_v2.0_filled_cop30_dem.tif")

# Read shapefile data
mask = read_sf("/media/kaian/Kaian_data/Backups/Grobin_and_Framheim/Home_grobin/Desktop/Ice_thickness_inversion/projects/AP/vault__input_and_meshing/input_orig-res_3031/z-extra/mask_AP70.shp")

# Mask DEM using the shapefile
dem_cut = raster::mask(dem, mask)
starsExtra::slope(dem)

# Read CSV data using sf
pol_csv = ("/media/kaian/Kaian_data/Backups/Grobin_and_Framheim/Home_grobin/Desktop/Ice_thickness_inversion/scripts_use_example/processed/OIB_all_together_AP_cleaned_reduced_ks_500_no_head_JFF_reduced500m_with_source_comma.csv")
pol = st_read(pol_csv, options = c("X_POSSIBLE_NAMES=LON", "Y_POSSIBLE_NAMES=LAT"), stringsAsFactors = FALSE, quiet = TRUE)
st_crs(pol) = 4326

# Convert pol to sf and create point centroids
pol = st_as_sf(pol)
pt = st_as_sf(st_centroid(pol))

# Extract values from raster data at point locations
ex_car = raster::extract(carrivick, pt, sp = TRUE)
ex_car_huss = raster::extract(huss, ex_car, sp = TRUE)

# Rename columns for clarity
n = names(ex_car_huss)
n[9] = "Carrivick"
n[10] = "HF"
names(ex_car_huss) = n

# Calculate differences between thickness and Carrivick/HF values
ex_car_huss$diff_to_car = (as.numeric(ex_car_huss$THICK) - as.numeric(ex_car_huss$Carrivick))
ex_car_huss$diff_to_HF = (as.numeric(ex_car_huss$THICK) - as.numeric(ex_car_huss$HF))

# Write the result to a CSV file
write.table(ex_car_huss, "/home/kaian/Desktop/OIB_extracted.csv", row.names = FALSE)
