#' Batch dataset format conversion using an Excel mask
#'
#' Read an Excel mask describing files to convert, then import, clean, and
#' re-export each file in the desired format. Cleaning includes replacing void
#' character values (\code{""}) with \code{NA} and trimming whitespace.
#'
#' @param mask_filepath Character. Full file path to the Excel mask.
#'   The mask must contain columns: \code{folder_path}, \code{file},
#'   \code{converted_file}, \code{to_convert} (1 to convert, 0 to skip).
#' @param output_path Character. Folder path where converted files will be placed.
#' @return Invisibly returns a character vector of output file paths.
#' @importFrom magrittr %>%
#' @export
#'
#' @examples
#' mydir <- system.file("permadir_examples_and_tests/convert_r", package = "industtry")
#'
#' mask <- data.frame(
#'   folder_path = rep(mydir, 2),
#'   file = c("original_cars.rds", "original_mtcars.csv"),
#'   converted_file = c("converted_cars.parquet", "converted_mtcars.parquet"),
#'   to_convert = rep(1, 2)
#' )
#'
#' \donttest{
#' mask_path <- file.path(tempdir(), "mask_convert_r.xlsx")
#' writexl::write_xlsx(mask, mask_path)
#'
#' convert_r(
#'   mask_filepath = mask_path,
#'   output_path = tempdir()
#' )
#'
#' # Clean up:
#' file.remove(file.path(tempdir(),
#'   c("converted_cars.parquet", "converted_mtcars.parquet", "mask_convert_r.xlsx")))
#' }
convert_r <- function(mask_filepath, output_path) {

  if (!file.exists(mask_filepath)) {
    stop("mask_filepath doesn't exist. It must be a valid and full path including the xlsx file.")
  }

  if (!dir.exists(output_path)) {
    stop("output_path doesn't exist. Check path validity.")
  }

  prm <- rio::import(mask_filepath)
  prm <- dplyr::filter(prm, to_convert == 1)

  if (nrow(prm) == 0) {
    message("No files marked for conversion (to_convert == 1).")
    return(invisible(character(0)))
  }

  out_paths <- character(nrow(prm))

  for (i in seq_len(nrow(prm))) {
    row <- prm[i, ]
    message("Converting: ", row$file)

    data <- rio::import(file.path(row$folder_path, row$file))
    data <- dplyr::mutate(data, dplyr::across(
      dplyr::everything(),
      \(y) { y[nchar(as.character(y)) == 0] <- NA; y }
    ))
    data <- dplyr::mutate(data, dplyr::across(
      dplyr::where(is.character),
      stringr::str_trim
    ))

    out_file <- file.path(output_path, row$converted_file)
    rio::export(data, out_file)
    out_paths[i] <- out_file
    message("  Done: ", row$converted_file)
  }

  invisible(out_paths)
}
