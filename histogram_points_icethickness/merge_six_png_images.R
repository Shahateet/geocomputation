# Image Composition and Labeling Script

## Description:
# This R script loads multiple images representing histograms of ice thickness from different sources,
# arranges them into a 2x3 grid, and labels each sub-plot. The resulting composite image is saved as a PNG file.

## Input:
# - Image files for DeepBedMap, Bedmachine, Bedmap2, HF, Carrivick, and DeepBedMap with negative values.

## Output:
# - Composite image ("joined.png") containing the arranged histograms with labeled sub-plots.

## Steps:
# 1. Load required R libraries: `imager` and `png`.
# 2. Load individual images from specified file paths.
# 3. Set up a PNG device for output with a defined width and height.
# 4. Use the `imappend` function to arrange images into a 2x3 grid.
# 5. Plot the composite image with axes turned off.
# 6. Add labels ('a' to 'f') at specific coordinates on the plot.
# 7. Save the composite image as a PNG file.

## Author:
# [Your Name]

## Date:
# [Date]

## Notes:
# - Ensure that the file paths are correctly specified.
# - Adjust the width and height of the output PNG file as needed.
# - Customize labels and plot coordinates based on your preferences.

# Main Code:

# Load required libraries
library(imager)
library(png)

# Load images from file paths
deepbedmap <- load.image("/home/kaian/Desktop/hist_ready/histogram_ice_thickness_DeepBedMap_without_neg_2.png")
bedmachine <- load.image("/home/kaian/Desktop/hist_ready/histogram_ice_thickness_Bedmachine.png")
bedmap2 <- load.image("/home/kaian/Desktop/hist_ready/histogram_ice_thickness_Bedmap2.png")
HF <- load.image("/home/kaian/Desktop/hist_ready/histogram_ice_thickness_HF.png")
carrivick <- load.image("/home/kaian/Desktop/hist_ready/histogram_ice_thickness_Carrivick.png")
deepbedmap_with_neg <- load.image("/home/kaian/Desktop/hist_ready/histogram_ice_thickness_DeepBedMap_with_neg_2.png")

# Set up a PNG device for output with specified width and height
png("/home/kaian/Desktop/joined.png", width=6400, height=9000)

# Append and arrange images into a single plot using imappend
# Create a 2x3 layout and add images to specific positions
imappend(
  list(
    imappend(list(carrivick, HF), "x"),
    imappend(list(bedmap2, bedmachine), "x"),
    imappend(list(deepbedmap, deepbedmap_with_neg), "x")
  ),
  "y"
) %>% 
plot(axes=FALSE)

# Add labels at specific coordinates on the plot
text(x=80, y=80, labels=paste0("a"), cex=10, font=1)
text(x=3280, y=80, labels=paste0("b"), cex=10, font=1)
text(x=80, y=3080, labels=paste0("c"), cex=10, font=1)
text(x=3280, y=3080, labels=paste0("d"), cex=10, font=1)
text(x=80, y=6080, labels=paste0("e"), cex=10, font=1)
text(x=3280, y=6080, labels=paste0("f"), cex=10, font=1)

# Turn off the PNG device to save the plot
dev.off()
