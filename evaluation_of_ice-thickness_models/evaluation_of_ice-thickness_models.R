# Script for Data Analysis
# Author: Kaian Shahateet
# Date: 2023/11/17

# Reading input CSV file
tab <- read.csv("/path/to/file/all_glacier_flux_all_models.csv")
o_csv <- "/path/to/file/evaluation.csv"

# Calculating statistics and differences for each row
for (i in 1:nrow(tab)) {
  # Calculating max, mean, median, and min values
  tab$max[i] <- max(c(tab[i, 2], tab[i, 3], tab[i, 4], tab[i, 5], tab[i, 6], tab[i, 7]))
  tab$mean[i] <- mean(c(tab[i, 2], tab[i, 3], tab[i, 4], tab[i, 5], tab[i, 6], tab[i, 7]))
  tab$median[i] <- median(c(tab[i, 2], tab[i, 3], tab[i, 4], tab[i, 5], tab[i, 6], tab[i, 7]))
  tab$min[i] <- min(c(tab[i, 2], tab[i, 3], tab[i, 4], tab[i, 5], tab[i, 6], tab[i, 7]))

  # Calculating RMSD, NRMSD_mean, NRMSD_median
  squared_sum_diff_to_mean <- 0
  for (j in 1:6) {
    squared_sum_diff_to_mean <- (tab$mean[i] - tab[i, (j + 1)])^2 + squared_sum_diff_to_mean
  }
  tab$rmsd[i] <- sqrt(squared_sum_diff_to_mean / 6)
  tab$nrmsd_mean[i] <- tab$rmsd[i] / tab$mean[i]
  tab$nrmsd_median[i] <- tab$rmsd[i] / tab$median[i]

  # Calculating differences between pairs
  tab$diff_car[i] <- abs(tab[i, 7] - tab[i, 2]) / tab$mean[i]
  tab$diff_hf[i] <- abs(tab[i, 7] - tab[i, 3]) / tab$mean[i]
  tab$diff_bmap[i] <- abs(tab[i, 7] - tab[i, 4]) / tab$mean[i]
  tab$diff_deepbmap[i] <- abs(tab[i, 7] - tab[i, 5]) / tab$mean[i]
  tab$diff_bedmachine[i] <- abs(tab[i, 7] - tab[i, 6]) / tab$mean[i]
}

# Calculating summary statistics
se <- sd(tab$sd)
se_norm_mean <- se / mean(tab$mean)
se_norm_median <- se / mean(tab$median)
sd_max <- max(tab$sd)
sd_min <- min(tab$sd)

# Writing results to output CSV
write.table(tab, file = o_csv, sep = ",", append = FALSE, quote = FALSE, col.names = TRUE, row.names = FALSE)

# Writing headers for summary statistics
head_l <- cbind("all_together", "total_flux_Carrivick", "total_flux_HF", "total_flux_bedmap2", "total_flux_deepbedmap", "total_flux_bedmachine", "total_flux_shahateet",
               "max_of_max", "sum_of_mean", "sum_of_median", "min_of_min", "mean_of_RMSD", "mean_of_NRMSD_mean", "mean_of_NRMSD_median",
               "mean_diff_car", "mean_diff_hf", "mean_diff_bmap", "mean_diff_dbm", "mean_diff_bmac")

write.table(head_l, file = o_csv, sep = ",", append = TRUE, quote = FALSE, col.names = FALSE, row.names = FALSE)

# Writing summary statistics
l <- cbind("-", sum(tab$Carrivick), sum(tab$HF), sum(tab$Bedmap2), sum(tab$Deepbedmap), sum(tab$Bedmachine), sum(tab$Shahateet),
          max(tab$max), sum(tab$mean), sum(tab$median), min(tab$min), mean(tab$rmsd), mean(tab$nrmsd_mean), mean(tab$nrmsd_median),
          mean(tab$diff_car), mean(tab$diff_hf), mean(tab$diff_bmap), mean(tab$diff_deepbmap), mean(tab$diff_bedmachine)
)

write.table(l, file = o_csv, sep = ",", append = TRUE, quote = FALSE, col.names = FALSE, row.names = FALSE)

# End of the script
