# Ice Thickness Histogram Plotting Script
# Author: Kaian Shahateet
# Date: 2023/11/15

# This R script generates a histogram plot of ice thickness points for a specific model named "Huss & Farinotti."
# It processes the data, calculates the mean ice thickness, and provides a visual representation of the ice thickness distribution.
# The script focuses on zero thickness values and categorizes them based on velocity thresholds.

# Define the model name and set plot limits
model_name <- "Huss & Farinotti"
xlim <- c(0, 1000)
ylim <- c(0, 6000)

# Calculate the mean thickness
mean_thickness <- round(mean(tm), digits = 0)

# Replace spaces with underscores in the model name
model_name_simple <- sub(" ", "_", model_name)

# Set the output path and file name
output_path <- "/home/kaian/Desktop/"
output_file <- paste0("histogram_ice_thickness_", model_name_simple, ".png")

# Set the plot title
title <- paste0("Histogram of the ice thickness points of ", model_name)

# Count the number of zero thickness points in different velocity subsets
zero_t <- sum(is_zero_t_and_v_super_high) + sum(is_zero_t_and_v_high) + sum(is_zero_t_and_v_low)
zero_high <- sum(is_zero_t_and_v_super_high)
zero_med <- sum(is_zero_t_and_v_high)
zero_low <- sum(is_zero_t_and_v_low)

# Create the output file path
output <- paste0(output_path, output_file)

# Start a PNG device for the plot
png(output, width = 3200, height = 3000, res = 300)

# Create a histogram plot
hist(
  tm,
  breaks = 21,
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
    "Total zero thickness",
    "Zero thickness with v>0.5 m d⁻¹",
    "Zero thickness with 0.5>v>0.1 m d⁻¹",
    "Zero thickness with v<0.1 m d⁻¹"
  ),
  pch = c(21, 19, 19, 19),
  col = c("red", "green", "blue", "yellow"),
  bg = c("white", "green", "blue", "yellow"),
  cex = 2,
  box.lty = 0
)

# Add text to the plot
text(x = 700, y = 1400, paste0("mean ice thickness: ", mean_thickness, " m"), cex = 2)

# Add points to represent zero counts in different subsets
points(10, zero_t, col = "red", cex = 2)
points(20, zero_high, col = "green", pch = 19, cex = 2)
points(30, zero_med, col = "blue", pch = 19, cex = 2)
points(40, zero_low, col = "yellow", pch = 19, cex = 2)

# Close the PNG device
dev.off()
