#' Replace character vector values using a correspondence approach
#'
#' @param input_vector Character. Character vector on which replacements take place.
#' @param replacements Character. Named character vector defining replacement
#'   correspondences (names = patterns, values = replacements).
#' @param replace_all Logical. If \code{TRUE}, \code{stringr::str_replace_all()}
#'   is used instead of \code{stringr::str_replace()}.
#' @return Character vector with replacements applied.
#' @examples
#' input <- c("one-one", "two-two-one", "three-three-two")
#'
#' replace_multiple(input,
#'                  replacements =
#'                    c("one" = "1", "two" = "2",
#'                      "three" = "3"))
#'
#' replace_multiple(input,
#'                  replacements =
#'                    c("one" = "1", "two" = "2",
#'                      "three" = "3"),
#'                  replace_all = TRUE)
#' @importFrom magrittr %>%
#' @export
#'
replace_multiple <- function(input_vector, replacements,
                             replace_all = FALSE) {

  if (!is.character(input_vector)) {
    stop("input_vector must be a character vector")
  }

  if (!is.character(replacements)) {
    stop("replacements must be a character vector")
  }

  replace_function <- function(...) {
    if (replace_all) stringr::str_replace_all(...)
    else stringr::str_replace(...)
  }

  input <- names(replacements)

  if (length(unique(input)) != length(input)) {
    stop("Original values must be unique in the `replacements` argument.")
  }

  output <- unname(replacements)

  replace_table <- data.frame(input, output)

  dplyr::tibble(input_vector = input_vector,
                origin =
                  stringr::str_extract(input_vector,
                                       input %>% paste(collapse = "|"))) %>%
    dplyr::left_join(replace_table, by = c("origin" = "input")) %>%
    dplyr::mutate(destination = replace_function(input_vector, origin, output)) %>%
    dplyr::pull(destination)
}
