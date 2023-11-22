###########################################################################
#                                                                         #
# Author: Kaian Shahateet                                                 #
# Version: 1.0                                                            #
#                                                                         #
# Code to downscale a course SMB to a DEM resolution in serial.           #
# It uses information of the local elevation to perform the downscaling.  #
#                                                                         #
# Structure:                                                              #
# - input, output and parameters must be adjusted by the user             #
# - Resolution adjustment and variable creation takes the resampled input #
# but can be defined to perform a focal mean.                             #
# - The main code uses linear regression of a sample window of the SMB as #
# Y and DEM as X to downscale the SMB within the original DEM resolution. #
###########################################################################

######################
# Required libraries #
######################
library(raster)
######################
######################

#########
# input #
#########
or_dem <- raster("/path/to/file/REMA_v2_clipped_AP_100m.tif") # original DEM
res_dem <- raster("/path/to/file/REMA_v2_clipped_AP_7500m.tif") # resampled DEM
or_smb <- raster("/path/to/file/MAR_mean_2011-2020.tif") # original SMB
#########
#########

##########
# output #
##########
out_smb <- "/path/to/file/MAR_mean_2011-2020_downscaled_test.tif" #output downscaled SMB
##########
##########

##############
# parameters #
##############
radius <- 5 # size of the sample window to calculate the linear regression. The size is (radius*2)+1. e.g. radius =5, the sample window will be 11x11
multilook_factor <- 75 # factor between or_dem and or_smb. i.e. or.dem*multilook_factor==or_smb
##############
##############

###############################################
# Resolution adjustment and variable creation #
###############################################
down_scaled_smb <- raster(vals = NA, nrow = nrow(or_dem), ncol = ncol(or_dem), ext = extent(or_dem), crs = crs(or_dem)) # creates the variable to receive the downscaled smb
focal_dem_7500 <- res_dem #focal_dem_7500 receives the resampled dem. If the multilook is active, this will be overwrite
### Multilook DEM to almost SMB resolution
#focal_dem_7500 <-focal(or_dem, w=matrix(1,multilook_factor,multilook_factor), fun=mean)
res_smb <- resample(or_smb, focal_dem_7500, method = "bilinear") # resample SMB because it does not have a integer resolution
###############################################
###############################################

#################################################
# check if the resolutions and extensions match #
#################################################
if (all.equal(res(focal_dem_7500), res(res_smb)) && all.equal(extent(focal_dem_7500), extent(res_smb))) {
  print("All good. Same resolution and extent. Proceeding to downscaling")
} else {
  stop("Stopping the code because dem and smb do not match in resolution or extent")
}
print(paste0("resolution of SMB: ", nrow(res_smb), " x ", ncol(res_smb), " pixels", sep = "")) # print resolution of or_smb
print(paste0("resolution of DEM: ", nrow(or_dem), " x ", ncol(or_dem), " pixels", sep = "")) # print resolution of or_dem
#################################################
#################################################

################################################################################
# The edges of the raster can not be used (it would lead to negative elements) #
################################################################################
m_max <- ncol(res_smb) - radius
m_min <- radius + 1
n_max <- nrow(res_smb) - radius
n_min <- radius + 1
################################################################################
################################################################################

### regression calculation
for (n in n_min:n_max){
    if (n==n_min){
      print("Starting...")
    }
  else{
    print(dtime)
  }
    print(paste0("Column ",(n-n_min+1)," out of ",n_max,sep=""))
    start_time <- Sys.time() # start time registration
    for (m in m_min:m_max){
      ##########
      # Subset #
      ##########
      small_smb <- res_smb[c((n - radius):(n + radius)), c((m - radius):(m + radius))] # small set of SMB to calculate the linear regression
      small_dem <- focal_dem_7500[c((n - radius):(n + radius)), c((m - radius):(m + radius))] # small set of the resampled DEM to calculate the linear regression
      ##########
      ##########
      
      ##############
      # Regression #
      ##############
      x <- unlist(small_dem) # take the small_dem as list
      y <- unlist(small_smb) # take the small_smb as list
      
      data <- data.frame(x = x, y = y) # put x and y as a table
      data_filtered <- data[complete.cases(data), ] # remove rows containing NAs
      
      lm_model <- lm(y ~ x, data = data_filtered) # calculate the linear regression
      
      lm_coef <- coefficients(lm_model) # take the coefficients of the linear regression
      ##############
      ##############
      
      #########################
      # Downscale calculation #
      #########################
      span_x <- multilook_factor * (n - 1) + c(1:multilook_factor) # define the elements to be updated in the downscaled smb
      span_y <- multilook_factor * (m - 1) + c(1:multilook_factor)  # define the elements to be updated in the downscaled smb
      matr <- matrix(as.numeric(lm_coef[1]) + as.numeric(lm_coef[2]) * or_dem[span_x, span_y], nrow = length(span_y), ncol = length(span_x))
      #matr <- matrix(or_dem[span_x, span_y], nrow = length(span_y), ncol = length(span_x))
      down_scaled_smb[span_x,span_y]=matr # pass the matr information to the downscaled SMB raster
      #########################
      #########################
    }
    end_time <- Sys.time() # stop time registration
    dtime=end_time-start_time # total time is stop-start
}

writeRaster(down_scaled_smb,out_smb,overwrite=TRUE)
