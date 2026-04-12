#' Inspect a data frame
#'
#' Compute a summary of each variable in a data frame: class, distinct values,
#' missing values, void strings, character lengths, and sample modalities.
#'
#' @param data_frame A data frame to inspect.
#' @param nrow Logical. If \code{TRUE}, the number of observations is printed
#'   as a message in addition to the returned table.
#' @return A tibble with one row per variable and columns: \code{variables},
#'   \code{class}, \code{nb_distinct}, \code{prop_distinct}, \code{nb_na},
#'   \code{prop_na}, \code{nb_void}, \code{prop_void}, \code{nchars}, \code{modalities}.
#' @examples
#' inspect(CO2)
#' @importFrom magrittr %>%
#' @export
#'
inspect <- function(data_frame, nrow = FALSE) {

  if (!is.data.frame(data_frame)) {
    stop("data_frame must be an object of data.frame class")
  }

  rows <- nrow(data_frame)
  df <- data_frame %>%
    dplyr::mutate(dplyr::across(
      dplyr::where(lubridate::is.POSIXct),
      \(x) as.character(x) %>% structure(class = "Date-time")
    )) %>%
    purrr::map_df(~ {
      dplyr::tibble(
        class = class(.x),
        nb_distinct = dplyr::n_distinct(.x),
        prop_distinct = nb_distinct / rows,
        nb_na = sum(is.na(.x)),
        prop_na = nb_na / rows,
        nb_void = sum(.x == "", na.rm = TRUE),
        prop_void = nb_void / rows,
        nchars = paste(unique(sort(nchar(as.character(.x))))[
          1:min(dplyr::n_distinct(nchar(as.character(.x))), 10)],
          collapse = " / "),
        modalities = paste(sort(unique(.x))[
          1:min(dplyr::n_distinct(.x), 10)],
          collapse = " / ")
      )
    }, .id = "variables")

  if (nrow) {
    message("Number of observations: ", rows)
  }

  df
}
