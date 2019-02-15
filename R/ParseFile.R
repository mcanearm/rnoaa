#' @title Read URL of NOAA data
#' @export
#' @description Read the CSV data stored at the provided URL.
ReadURL <- function(url) {
    dt <- fread(url)

    airTemp <- read_air_temp(dt$TMP)
    airQuality <- read_sky_condition(dt$CIG)
    visibility <- read_vis(dt$VIS)
    wind <- read_wind(dt$WND)

    dtSubset <- dt[, .(
        'station' = STATION, 'date' = as.POSIXct(DATE, format = '%Y-%m-%dT%H:%M:%S'), 'source' = SOURCE,
        'latitude' = LATITUDE, 'longitude' = LONGITUDE, 'elevation' = ELEVATION, 'name' = NAME,
        'report_type' = REPORT_TYPE, 'call_sign' = CALL_SIGN, 'quality_control' = QUALITY_CONTROL
    )]

    fullDT <- cbind.data.frame(dtSubset, airTemp, airQuality, visibility, wind)
    fullDT
}
