#' Variable class comparison - inconsistent types across datasets
#'
#' @param vars_compclasses_table Output of the \code{vars_compclasses()} function.
#' @return A subset of \code{vars_compclasses_table} containing only variables
#'   with different classes across datasets where they appear.
#' @examples
#' data_list <- list(cars = cars, mtcars = mtcars)
#' vcompclasses <- vars_compclasses(data_list)
#' vars_compclasses_not_allsame(vcompclasses)
#' @importFrom magrittr %>%
#' @export
#'
vars_compclasses_not_allsame <- function(vars_compclasses_table) {

  not_allsame <- apply(vars_compclasses_table, 1, function(x) {
    classes <- unique(x[-1])
    classes <- classes[classes != "-"]
    length(classes) != 1
  }) %>% unlist

  vars_compclasses_table[not_allsame, ]
}
