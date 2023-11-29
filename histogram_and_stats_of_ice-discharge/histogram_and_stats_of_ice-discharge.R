# Load the 'sf' package
require(sf)

# Read the shapefile containing evaluation data about ice discharge
evaluation = st_read("/media/kaian//home/kaian/Desktop/Ice_discharge_all/ice-discharge_AP_200m_res_200m_points_carrivick_APIS/output_together/flux_gates_evaluation.shp")

# Calculate the total sum of mean ice discharges
sum_mean = sum(evaluation$mean, na.rm = TRUE)
print(paste0("The total sum of the mean ice discharges is: ", round(sum_mean, 2), " km³/y"))

# Find the maximum mean ice discharge and the corresponding glacier
max_mean = max(evaluation$mean, na.rm = TRUE)
max_glacier = as.character(evaluation$glacier[which(evaluation$mean == max_mean)])
print(paste0("The glacier with the highest ice discharge is: ", max_glacier, " with a total of: ", round(max_mean, 2), " km²/y"))

# Calculate the average mean ice discharge
mean_mean = mean(evaluation$mean, na.rm = TRUE)
print(paste0("The total average mean ice discharges is: ", round(mean_mean, 2), " km³/y"))

# Calculate the standard deviation of the mean ice discharge
sd_mean = sd(evaluation$mean, na.rm = TRUE)
print(paste0("The standard deviation of the mean is: ", round(sd_mean, 2), " km³/y"))

# Create a histogram of the ice discharge and save it as a PNG file
png("/home/kaian/Desktop/histogram_ice_discharge_mean.png")
hist(evaluation$mean, breaks = 50, ylab = "Number of glaciers", xlab = "Ice discharge per glacier (km³/y)",
     main = "Histogram of the ice discharge")
dev.off()
