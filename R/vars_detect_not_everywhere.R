#' Variable detection - inconsistent patterns
#'
#' @param vars_detect_table Output of the \code{vars_detect()} function.
#' @return A subset of \code{vars_detect_table} containing only variables
#'   that are not present in every dataset.
#' @examples
#' data_list <- list(cars = cars, mtcars = mtcars)
#' vdetect_table <- vars_detect(data_list)
#' vars_detect_not_everywhere(vdetect_table)
#' @importFrom magrittr %>%
#' @export
#'
vars_detect_not_everywhere <- function(vars_detect_table) {

  not_everywhere <- apply(vars_detect_table, 1,
                          \(x) !identical(unique(x[-1]), "ok")) %>% unlist

  vars_detect_table[not_everywhere, ]
}
