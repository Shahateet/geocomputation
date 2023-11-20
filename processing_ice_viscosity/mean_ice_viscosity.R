# R Script for Processing Ice Viscosity Data

# Load the 'sf' library for working with spatial data
library(sf)

# Specify the path to the input CSV file containing ice viscosity data
# Also found in the HPC at ~/projects/AP_500res_bckp_almost_ready/1st/geometries/10059/ice_viscosity.dat

s_path = "~/Desktop/hpc_10059_AP_500res/ice_viscosity_short.csv"


# Specify the path for the output shapefile
out_s = "~/Desktop/hpc_10059_AP_500res/test.shp"

# Set a quantile threshold for data processing
q = 0.1

# Read the spatial data from the CSV file, specifying X and Y column names
s = st_read(s_path, options = c("X_POSSIBLE_NAMES=x", "Y_POSSIBLE_NAMES=y"), stringsAsFactors = FALSE, quiet = TRUE)

# Set the coordinate reference system (CRS) for the spatial data
st_set_crs(s, 3031)

# Write the spatial data to a new shapefile
write_sf(s, out_s)

# Extract the 'visc' column from the spatial data
column_name <- "visc"
variable <- s[[column_name]]

# Convert the 'variable' to numeric, assuming it's a character column
variable <- as.numeric(variable)

# Check for any missing or non-numeric values
if (any(is.na(variable))) {
  # Handle missing values, for example:
  variable <- variable[!is.na(variable)]
}

# Calculate quantiles for data filtering
q10 = quantile(variable, 0.1)
q90 = quantile(variable, 0.9)

# Filter out extreme values based on quantiles
variable_clean = variable[!variable == (-9999)]
variable_q = variable_clean[variable_clean < q90]
variable_q = variable_q[variable_q > q10]

# Create a histogram of the filtered data
hist(variable_q, 200)

# Display information about the data processing
print(paste0("Excluding 90% quantile > ", q90, sep = ""))
print(paste0("Excluding 10% quantile < ", q10, sep = ""))
print(paste0("Mean value changed from ", mean(variable), " to ", mean(variable_q), sep = ""))
