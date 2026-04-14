#' Replace character vector values using a correspondence approach
#'
#' Names of \code{replacements} are matched literally (not as regular
#' expressions). Elements of \code{input_vector} that match none of the
#' patterns are returned unchanged.
#'
#' @param input_vector Character. Character vector on which replacements take place.
#' @param replacements Character. Named character vector defining replacement
#'   correspondences (names = patterns, values = replacements). Names are
#'   treated as literal strings (regex metacharacters such as \code{.},
#'   \code{(}, \code{+} are not interpreted).
#' @param replace_all Logical. If \code{TRUE}, \code{stringr::str_replace_all()}
#'   is used instead of \code{stringr::str_replace()}.
#' @return Character vector with replacements applied.
#' @section Overlapping patterns:
#' When several patterns can match the same element, the first match found
#' in \code{input_vector} (scanned left to right) is used. When patterns
#' start at the same position, the one listed first in \code{replacements}
#' wins, not the longest. Order \code{replacements} accordingly if some
#' patterns are prefixes of others.
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
#'
#' # Unmatched elements are returned as-is:
#' replace_multiple(c("one", "unmatched"), c("one" = "1"))
#'
#' # Regex metacharacters are matched literally:
#' replace_multiple(c("a.b", "aXb"), c("." = "DOT"))
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

  # Escape regex metacharacters so that names of `replacements` are matched
  # as literal strings both during extraction and during replacement.
  escaped_input <- stringr::str_escape(input)

  dplyr::tibble(input_vector = input_vector,
                origin =
                  stringr::str_extract(input_vector,
                                       escaped_input %>% paste(collapse = "|"))) %>%
    dplyr::left_join(replace_table, by = c("origin" = "input")) %>%
    dplyr::mutate(destination = dplyr::if_else(
      is.na(origin),
      input_vector,
      replace_function(input_vector, stringr::fixed(origin), output))) %>%
    dplyr::pull(destination)
}
