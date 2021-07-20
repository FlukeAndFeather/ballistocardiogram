read_nc <- function(nc_path) {
  stopifnot(file.exists(nc_path))
  nc <- ncdf4::nc_open(nc_path)
  fs <- ncdf4::ncatt_get(nc, "P", "sampling_rate")$value
  whaleid <- ncdf4::ncatt_get(nc, 0, "depid")$value
  tz0 <- ncdf4::ncatt_get(nc, 0, "dephist_device_tzone")$value
  tz <- sprintf("Etc/GMT%+d", -tz0)
  calc_jerk <- function(amat) {
    diff_amat <- apply(amat, 2, lead) - amat
    apply(diff_amat, 1, function(xyz) sqrt(sum(xyz^2)))
  }
  result <- tibble(
    dn = as.vector(ncdf4::ncvar_get(nc, "DN")),
    p = as.vector(ncdf4::ncvar_get(nc, "P")),
    aw = as.matrix(ncdf4::ncvar_get(nc, "Aw")),
    at = as.matrix(ncdf4::ncvar_get(nc, "At"))
  ) %>%
    mutate(dt = as.POSIXct((dn - 719529) * 86400,
                           origin = "1970-01-01",
                           tz = "UTC") %>%
             lubridate::with_tz(tz),
           secs = as.numeric(dt - min(dt), unit = "secs"),
           jerk = calc_jerk(aw))
  attr(result, "whaleid") <- whaleid
  attr(result, "fs") <- fs
  attr(result, "tz") <- tz
  result
}
