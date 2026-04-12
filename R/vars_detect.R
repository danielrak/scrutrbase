#' Variable detection patterns
#'
#' Detect the presence or absence of each variable across a collection of datasets.
#'
#' @param data_frames A named list of data frames to compare.
#' @return A data frame with a \code{vars_union} column listing all variables,
#'   and one column per dataset indicating \code{"ok"} (present) or \code{"-"} (absent).
#'   Rows are sorted to highlight presence/absence patterns.
#' @examples
#' data_list <- list(cars = cars, mtcars = mtcars)
#' vars_detect(data_list)
#' @importFrom magrittr %>%
#' @export
#'
vars_detect <- function(data_frames) {

  if (!is.list(data_frames) || is.data.frame(data_frames)) {
    stop("data_frames must be a named list of data frames")
  }
  if (is.null(names(data_frames)) || any(names(data_frames) == "")) {
    stop("data_frames must be a named list (all elements must have names)")
  }

  # Get variable names per dataset

  var_lists <- purrr::map(data_frames, names)

  # Union of all variable names

  all_vars <- unique(unlist(var_lists))

  # Build presence/absence matrix
  presence <- purrr::map_dfc(var_lists, function(vars) {
    ifelse(all_vars %in% vars, "ok", "-")
  })

  out_data <- dplyr::bind_cols(
    tibble::tibble(vars_union = all_vars),
    presence
  )

  # Arrange lines to better visualize presence/absence patterns
  suppressWarnings({
    rkfirst_ok <- out_data[, -1, drop = FALSE] %>%
      apply(1, \(x) min(which(x == "ok")))

    nb_ok_conseq <- out_data %>%
      apply(1, \(x) rle(as.numeric(x == "ok"))$lengths[2])

    rkfirst_out <- out_data[, -1, drop = FALSE] %>%
      apply(1, \(x) min(which(x == "-")))

    nb_out_conseq <- out_data %>%
      apply(1, \(x) rle(as.numeric(x == "-"))$lengths[2])
  })

  out_data <- dplyr::mutate(out_data,
                            rkfirst_ok, nb_ok_conseq,
                            rkfirst_out, nb_out_conseq)

  dplyr::arrange(out_data,
                 rkfirst_ok, dplyr::desc(nb_ok_conseq),
                 dplyr::desc(rkfirst_out), dplyr::desc(nb_out_conseq)) %>%
    dplyr::select(-rkfirst_ok, -nb_ok_conseq,
                  -rkfirst_out, -nb_out_conseq)
}
