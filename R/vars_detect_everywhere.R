#' Variable detection - presence across all datasets
#'
#' @param vars_detect_table Output of the \code{vars_detect()} function.
#' @return A subset of \code{vars_detect_table} containing only variables
#'   present in all datasets.
#' @examples
#' data_list <- list(cars = cars, mtcars = mtcars)
#' vdetect_table <- vars_detect(data_list)
#' vars_detect_everywhere(vdetect_table)
#' @importFrom magrittr %>%
#' @export
#'
vars_detect_everywhere <- function(vars_detect_table) {

  everywhere <- apply(vars_detect_table, 1,
                      \(x) identical(unique(x[-1]), "ok")) %>% unlist

  vars_detect_table[everywhere, ]
}
