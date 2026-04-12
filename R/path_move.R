#' Move through paths
#'
#' @param path_vector Character. Vector of paths with equal number of levels.
#' @param path_separator Character. Path separator
#'   (adapted to your OS, e.g. \code{"/"}).
#' @param move Integer. If positive, outputs path up to the specified level.
#'   If negative, removes the last specified level(s).
#'
#' @return Character vector of transformed paths.
#' @importFrom magrittr %>%
#' @importFrom glue glue
#' @export
#'
#' @examples
#' pvector <- c(
#'   "level_1/level_2/level_3/file_1.ext",
#'   "level_1/level_2/level_3/file_2.ext"
#' )
#'
#' path_move(path_vector = pvector,
#'           path_separator = "/",
#'           move = 1)
#'
#' path_move(path_vector = pvector,
#'           path_separator = "/",
#'           move = 2)
#'
#' path_move(path_vector = pvector,
#'           path_separator = "/",
#'           move = -1)
#'
#' path_move(path_vector = pvector,
#'           path_separator = "/",
#'           move = -2)
path_move <- function(path_vector, path_separator = "/", move) {

  if (!is.character(path_vector)) {
    stop("path_vector must be a character vector")
  }

  if (!is.numeric(move)) {
    stop("move must be a numeric")
  }

  if (move == 0) {
    stop("move must be different from 0")
  }

  split <- strsplit(path_vector, path_separator)
  plevels <- purrr::map_dbl(split, length)

  if (length(rle(plevels)$values) != 1) {
    df_error <- data.frame(path_vector = path_vector,
                           number_of_levels = plevels)
    message(paste(utils::capture.output(print(df_error)), collapse = "\n"))
    stop("All path_vector elements must have the same number of levels")
  }

  pmatrix <- split %>% do.call(what = rbind)
  ncol <- ncol(pmatrix)
  move <- as.integer(move)

  if (move > 0) {
    if (!move %in% 1:ncol) {
      stop(glue::glue("level must be comprised between one of these values : {
                      paste(1:ncol, collapse = ', ')}"))
    }

    pmatrix[, 1:move, drop = FALSE] %>%
      apply(1, \(x) paste(x, collapse = path_separator))

  } else {
    if (abs(move) >= ncol(pmatrix)) {
      stop(glue::glue(
        "move absolute value must be strictly positive and strictly lesser than {ncol}"))
    }

    pmatrix[, -(ncol(pmatrix):(ncol(pmatrix) + move + 1)), drop = FALSE] %>%
      apply(1, \(x) paste(x, collapse = path_separator))
  }
}
