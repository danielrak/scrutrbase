#' Convert all datasets within a folder to a given file format
#'
#' Scan a folder for files matching specified extensions, then convert each one
#' to the target format. Void character values are replaced with \code{NA} and
#' character whitespace is trimmed.
#'
#' @param input_folderpath Character. Folder path containing datasets to convert.
#' @param considered_extensions Character vector. File extensions to include
#'   (must be supported by \pkg{rio}).
#' @param to Character. The target output format (must be supported by \pkg{rio}).
#' @param output_folderpath Character. Folder path for converted files
#'   (defaults to \code{input_folderpath}).
#' @return Invisibly returns a character vector of output file paths.
#' @export
#'
#' @examples
#' \donttest{
#' mydir <- system.file("permadir_examples_and_tests/convert_all", package = "industtry")
#' outdir <- tempdir()
#'
#' convert_all(input_folderpath = mydir,
#'             considered_extensions = c("rds"),
#'             to = "csv",
#'             output_folderpath = outdir)
#'
#' list.files(outdir, pattern = "csv$")
#' }
convert_all <- function(input_folderpath, considered_extensions,
                        to, output_folderpath = input_folderpath) {

  if (!dir.exists(input_folderpath)) stop("input_folderpath must be a valid path")
  if (!is.character(considered_extensions)) stop("considered_extensions must be a character vector")
  if (!is.character(to) || length(to) != 1) stop("to must be a 1L character vector")
  if (!dir.exists(output_folderpath)) stop("output_folderpath must be a valid path")

  ext <- paste0(paste0("\\.", considered_extensions, "$"), collapse = "|")

  lfiles <- list.files(input_folderpath, full.names = TRUE)
  lfiles <- lfiles[grepl(ext, lfiles)]

  if (length(lfiles) == 0) {
    message("No files found matching the specified extensions.")
    return(invisible(character(0)))
  }

  out_paths <- character(length(lfiles))

  for (i in seq_along(lfiles)) {
    filepath <- lfiles[i]
    message("Converting: ", basename(filepath))

    data <- rio::import(filepath, trust = TRUE)
    data <- dplyr::mutate(data, dplyr::across(
      dplyr::everything(),
      \(y) { y[nchar(as.character(y)) == 0] <- NA; y }
    ))
    data <- dplyr::mutate(data, dplyr::across(
      dplyr::where(is.character),
      stringr::str_trim
    ))

    outname <- gsub(ext, paste0(".", to), basename(filepath))
    out_file <- file.path(output_folderpath, outname)
    rio::export(data, out_file)
    out_paths[i] <- out_file
    message("  Done: ", outname)
  }

  invisible(out_paths)
}
