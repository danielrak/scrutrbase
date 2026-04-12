#' Collection-level variables types comparison
#'
#' Compare the class of each variable across a collection of datasets.
#'
#' @param data_frames A named list of data frames to compare.
#' @return A data frame with a \code{vars_union} column and one column per dataset
#'   showing the class of each variable (\code{"-"} if absent from that dataset).
#' @examples
#' data_list <- list(cars = cars, mtcars = mtcars)
#' vars_compclasses(data_list)
#' @importFrom magrittr %>%
#' @export
#'
vars_compclasses <- function(data_frames) {

  if (!is.list(data_frames) || is.data.frame(data_frames)) {
    stop("data_frames must be a named list of data frames")
  }
  if (is.null(names(data_frames)) || any(names(data_frames) == "")) {
    stop("data_frames must be a named list (all elements must have names)")
  }

  all_vars <- unique(unlist(purrr::map(data_frames, names)))

  classes <- purrr::map_dfc(data_frames, function(df) {
    purrr::map_chr(all_vars, function(v) {
      if (v %in% names(df)) {
        paste(class(df[[v]]), collapse = "/")
      } else {
        "-"
      }
    })
  })

  dplyr::bind_cols(
    tibble::tibble(vars_union = all_vars),
    classes
  )
}
