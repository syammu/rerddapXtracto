remapCoords <- function(dataInfo, callDims, dataCoordList,  urlbase) {
  # Logic here
  #  make copies of given coordinates that can be changed if needed without changing original values
  xcoord1 <- unlist(callDims[1])
  ycoord1 <- unlist(callDims[2])
  zcoord1 <- unlist(callDims[3])
  tcoord1 <- callDims[4]
  tcoord1 <- tcoord1[[1]]

  # if the xcoord is longitude, map to longitude range of ERDDAP dataset
  if ('longitude' %in% names(callDims)) {
    lonVal <- dataInfo$alldata$longitude[dataInfo$alldata$longitude$attribute_name == "actual_range", "value"]
    lonVal2 <- as.numeric(strtrim1(strsplit(lonVal, ",")[[1]]))
    #grid is -180, 180
    if (min(lonVal2) < 0.) {xcoord1 <- make180(xcoord1)}
    if (max(lonVal2) > 180.) {xcoord1 <- make360(xcoord1)}
  }

  # if ycoord is latitude,if ERDDAP lats run north-south for 3D case change limits to reflect this. Done for each value in rxtracto case
  latSouth <- TRUE
  if ('latitude' %in% names(callDims)) {
    #       latVal <- dataInfo$alldata$latitude[dataInfo$alldata$latitude$attribute_name == "actual_range", "value"]
    #      latVal2 <- as.numeric(strtrim1(strsplit(latVal, ",")[[1]]))
    #north-south  datasets
    #      if (latVal2[1] > latVal2[2]) {latSouth <- FALSE}
    spacing_string <- unlist(strsplit(dataInfo$alldata$latitude$value[1], ","))
    spacing = unlist(strsplit(spacing_string[3], "="))
    spacing <- as.numeric(spacing[2])
    if (spacing < 0) {
      latSouth <- FALSE
      latVal <- dataInfo$alldata$latitude[dataInfo$alldata$latitude$attribute_name == "actual_range", "value"]
      latVal2 <- as.numeric(strtrim1(strsplit(latVal, ",")[[1]]))
      tempLat <- paste0(latVal2[2], ',', latVal2[1])
      dataInfo$alldata$latitude[dataInfo$alldata$latitude$attribute_name == "actual_range", "value"] <- tempLat
    }
  }
  return(list(xcoord1 = xcoord1, ycoord1 = ycoord1, zcoord1 = zcoord1, tcoord1 = tcoord1, latSouth = latSouth, dataInfo1 = dataInfo))

}
