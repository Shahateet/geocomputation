###########################################################################
#                                                                         #
# Author: Kaian Shahateet                                                 #
# Version: 1.0                                                            #
#                                                                         #
# Code to downscale a course SMB to a DEM resolution in parallel.         #
# It uses information of the local elevation to perform the downscaling.  #
#                                                                         #
# Structure:                                                              #
# - input, output and parameters must be adjusted by the user             #
# - list all files (recursively) that matches pattern                     #
# - save overwrite the the "merged" variable where there is data on the   #
# second step which is being evaluated. Do it iterectvely to all          #
###########################################################################

# Load the raster library for working with raster data
library(raster)

# Define file paths
first_name = "/path/to/file/1st_step/10059_v100_poi_hsia_final.tif"
second_path = "/path/to/file/2nd_all/2nd_PP_thr200m/"
out_name = "/path/to/file/Shahateet_1st_2nd_PP_merged_200m_threshold.tif"

# Read the first step solution
merged = raster(first_name)

# List all files matching with thickness_final.tif in the second path
second_list = list.files(
  path = second_path,
  pattern = "v500_poi_thickness_final.tif",
  all.files = FALSE,
  full.names = TRUE,
  recursive = TRUE,
  ignore.case = TRUE,
  include.dirs = TRUE
)

# Iterate through all second step solutions
for (i in 1:length(second_list)) {
  
  # Print progress information
  print(paste0("Merging ", second_list[i], ". ", i, " out of ", length(second_list), ".", sep = ""))
  
  # Read the current second step solution
  second = raster(second_list[i])
  
  # Check if the maximum thickness exceeds 5000m
  if (cellStats(second, "max") > 5000) {
    print("Thickness exceeds 5000m")
  }
  
  # Extend the second step solution to match the first step solution
  second_extended = extend(second, merged, value = -9999, snap = "near")
  
  # Update the merged solution
  merged = (second_extended > (-1)) * second_extended + (second_extended < (-1)) * merged
}

# Write the final merged solution to a new raster file
writeRaster(merged, out_name)
