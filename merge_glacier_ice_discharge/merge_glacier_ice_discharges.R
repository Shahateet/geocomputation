library(stringr)

# Set the working directory
wd = "/path/to/file/"
setwd(wd)

# List files in the working directory that match the pattern "statistics.txt" recursively
files = list.files(wd, pattern = "statistics.txt", recursive = TRUE)

# Create header for the output file
head = cbind("glacier", "flux (km³/y)")
write.table(head, "all_glacier_flux_together.csv", sep = ",", col.names = FALSE, row.names = FALSE, append = FALSE, quote = FALSE)

# Loop through each file and extract information
for (i in 1:length(files)) {
  # Extract the glacier name from the file path
  name = str_split(files[i], pattern = "/", simplify = TRUE)[1, 1]
  
  # Read the flux value from the second row and twelfth column of the current file
  flux = read.table(files[i], stringsAsFactors = FALSE)[2, 12]
  
  # Combine glacier name and flux value into a line
  line = cbind(name, flux)
  
  # Append the line to the output file
  write.table(line, "all_glacier_flux_together.csv", sep = ",", row.names = FALSE, col.names = FALSE, append = TRUE, quote = FALSE)
}
