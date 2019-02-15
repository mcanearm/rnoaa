#' @title Generate Reader
#' @export
genReader <- function(colnames) {
    reader <- function(x) {
        splitVect <- strsplit(x, ',')
        vectors <- lapply(1:length(colnames), function(i) {
            sapply(splitVect, '[[', i)
        })
        dt <- data.table(cbind.data.frame(vectors))
        setnames(dt, colnames)
        dt
    }
}

#' @title Read WND
#' @export
read_wind <- function(wnd) {
    r <- genReader(c('wnd_dir', 'wnd_dir_q', 'obs_type_cd', 'wnd_spd', 'wnd_spd_q'))
    windSpeed <- r(wnd)
    windSpeed[, `:=` ('wnd_spd' = as.numeric(wnd_spd))]
    windSpeed
}

#' @title Read Air Quality
#' @export
read_sky_condition <- function(cig) {
    r <- genReader(c('sky_cnd_height', 'sky_cnd_q', 'sky_cnd_obs_type_cd', 'obs_cavok_cd'))
    airQuality <- r(cig)
    airQuality[, `:=` ('obs_cavok_cd' = bool_missing(obs_cavok_cd))]
    airQuality
}

#' @title Read visibility observation
#' @export
read_vis <- function(vis) {
    r <- genReader(c('vis_dist', 'vis_dist_q', 'vis_obs_var_cd', 'vis_q_var_cd'))
    visibility <- r(vis)
    visibility[, `:=` ('vis_dist' = as.numeric(vis_dist), 'vis_obs_var_cd' = bool_missing(vis_obs_var_cd))]
    visibility
}

#' @title Read temp
#' @export
read_air_temp <- function(temp) {
    r <- genReader(c('air_temp', 'air_temp_q'))
    airTemp <- r(temp)
    sign <- ifelse(grepl('+', airTemp$air_temp), 1, -1)
    airTemp[, `:=` ('air_temp' = sign * as.numeric(gsub('\\D', '', air_temp))/10)]
    airTemp
}

#' @title Convert boolean values
#' @export
bool_missing <- function(x) {
    sapply(as.character(x), switch, Y = TRUE, N = FALSE, '9' = NA, USE.NAMES = FALSE)
}

