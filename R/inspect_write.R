#' Inspect a data frame and write the output to an Excel file
#'
#' @param data_frame A data frame to inspect.
#' @param output_path Character. Folder path where the Excel output will be written.
#' @param output_label Character. Optional label for the output file.
#'   If \code{NULL}, defaults to the deparsed name of \code{data_frame}.
#' @return Invisibly returns the path to the written Excel file.
#'   The file contains the inspection table with prepended observation and variable counts.
#' @importFrom magrittr %>%
#' @export
#'
#' @examples
#' mydir <- file.path(tempdir(), "inspect_write_example")
#' dir.create(mydir)
#' inspect_write(data_frame = cars,
#'               output_path = mydir,
#'               output_label = "cars")
#' readxl::read_xlsx(file.path(mydir, "inspect_cars.xlsx"))
#' unlink(mydir, recursive = TRUE)
inspect_write <- function(data_frame, output_path, output_label = NULL) {

  if (!is.data.frame(data_frame)) {
    stop("data_frame must be a data.frame")
  }

  if (!dir.exists(output_path)) {
    stop("output_path doesn't exist. Check validity")
  }

  if (is.null(output_label)) {
    name <- deparse(substitute(data_frame))
  } else {
    name <- output_label
  }

  i <- inspect(data_frame)

  out_path <- file.path(output_path, paste0("inspect_", name, ".xlsx"))

  writexl::write_xlsx(
    rbind(
      c("Obs = ", nrow(data_frame), rep("", ncol(i) - 1)),
      c("Nvars = ", nrow(i), rep("", ncol(i) - 1)),
      cbind(1:nrow(i), i)
    ),
    out_path
  )

  invisible(out_path)
}
