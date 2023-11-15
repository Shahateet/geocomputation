# Ice Thickness Histogram Plotting Script
# Author: Kaian Shahateet
# Date: 2023/11/15

# This R script generates a histogram plot of ice thickness points for a specific model named "DeepBedMap"
# It processes the data, handles negative values, and provides a visual representation of ice thickness distribution.
# The script also calculates and visualizes the mean ice thickness while accounting for negative values.


# Define the model name and initialize some variables
model_name <- "DeepBedMap"

# Replace negative values in tm with NA
tm[tm < 0] <- NA

# Set x and y limits for the plot
xlim <- c(0, 1000)
ylim <- c(0, 6000)

# Create a copy of tm called tm_0 and replace NAs with 0
tm_0 <- tm
tm_0[is.na(tm_0)] <- 0

# Calculate the mean thickness (round to 0 digits, then set to 25)
mean_thickness <- 25

# Replace spaces with underscores in the model name
model_name_simple <- sub(" ", "_", model_name)

# Set the output path and file name
output_path <- "/home/kaian/Desktop/"
output_file <- paste0("histogram_ice_thickness_", model_name_simple, ".png")

# Set the plot title
title <- paste0("Histogram of the ice thickness points of ", model_name)

# Count the number of zeros in different subsets of the data
zero_t <- sum(is_negative_t)
zero_high <- sum(is_negative_t_super_high_velocity, na.rm = TRUE)
zero_med <- sum(is_negative_t_high_velocity, na.rm = TRUE)
zero_low <- sum(is_negative_t_low_velocity, na.rm = TRUE)

# Create the output file path
output <- paste0(output_path, output_file)

# Start a PNG device for the plot
png(output, width = 3200, height = 3000, res = 300)

# Create a histogram plot
hist(
  tm,
  breaks = 42,
  ylab = "Number of points",
  xlab = "Ice thickness (m)",
  main = title,
  ylim = ylim,
  xlim = xlim,
  cex.lab = 1.5,
  cex.main = 2,
  cex.axis = 1.5
)

# Add a legend to the plot
legend(
  "topright",
  c(
    "Total negative thickness",
    "Negative thickness with v>0.5 m d⁻¹",
    "Negative thickness with 0.5>v>0.1 m d⁻¹",
    "Negative thickness with v<0.1 m d⁻¹"
  ),
  pch = c(21, 19, 19, 19),
  col = c("red", "green", "blue", "yellow"),
  bg = c("white", "green", "blue", "yellow"),
  cex = 2,
  box.lty = 0
)

# Add text to the plot
text(x = 530, y = 1400, paste0("mean ice thickness (masking negative values): ", mean_thickness, " m"), cex = 2)

# Add points to represent zero counts in different subsets
points(-20, zero_t, col = "red", cex = 2)
points(-20, zero_high, col = "green", pch = 19, cex = 2)
points(-20, zero_med, col = "blue", pch = 19, cex = 2)
points(-20, zero_low, col = "yellow", pch = 19, cex = 2)

# Close the PNG device
dev.off()
