#' Inspect a collection of datasets
#'
#' Read all datasets from a folder matching the specified extensions, inspect each one,
#' and write a comprehensive Excel report covering variable presence, types, and per-dataset summaries.
#'
#' @param input_path Character. Folder path containing datasets to explore.
#' @param output_path Character. Folder path where the Excel output will be written.
#' @param output_label Character. A concise label for the output file name.
#' @param considered_extensions Character vector. File extensions to include
#'   (without the dot, e.g. \code{"rds"} not \code{".rds"}).
#' @param encoding Character 1L or \code{NULL}. Encoding passed to
#'   \code{rio::import()} for text-based formats (CSV, TSV). Must be one of
#'   \code{"unknown"}, \code{"UTF-8"}, or \code{"Latin-1"}. Defaults to
#'   \code{NULL} (let \code{rio} / \code{data.table} pick the default).
#'   Ignored for binary formats (e.g. RDS, xlsx).
#' @return Invisibly returns the path to the written Excel file.
#'   The file contains sheets: dims, inspect_tot, one per dataset inspection,
#'   vars_detect, vars_detect_everywhere, vars_detect_not_everywhere,
#'   vars_compclasses, vars_compclasses_allsame, vars_compclasses_not_allsame.
#' @examples
#' mydir <- file.path(tempdir(), "inspect_vars_example")
#' dir.create(mydir)
#'
#' saveRDS(cars, file.path(mydir, "cars1.rds"))
#' saveRDS(mtcars, file.path(mydir, "cars2.rds"))
#'
#' inspect_vars(input_path = mydir, output_path = mydir,
#'              output_label = "cardata",
#'              considered_extensions = "rds")
#'
#' # Read back the 10 sheets:
#' purrr::map(1:10, function(x)
#'            rio::import(file.path(mydir, "inspect_vars_cardata.xlsx"),
#'                        sheet = x))
#'
#' unlink(mydir, recursive = TRUE)
#' @importFrom magrittr %>%
#' @importFrom stats nobs
#' @export
#'
inspect_vars <- function(input_path, output_path,
                         output_label, considered_extensions,
                         encoding = NULL) {

  if (!is.null(encoding) &&
      !encoding %in% c("unknown", "UTF-8", "Latin-1")) {
    stop("encoding must be NULL or one of 'unknown', 'UTF-8', 'Latin-1'")
  }

  # Build file list
  ext <- paste0("\\.", considered_extensions, "$") %>%
    paste0(collapse = "|")
  lfiles <- list.files(input_path) %>%
    purrr::keep(stringr::str_detect(., ext))

  if (length(lfiles) == 0) {
    stop("No files found in input_path matching the specified extensions")
  }

  # Import all datasets into a LOCAL named list (no global env pollution).
  # Encoding is only forwarded when the user set it explicitly AND the file
  # is a text-based format; otherwise rio uses its own defaults.
  text_exts <- c("csv", "tsv", "txt", "csv2", "psv")
  import_one <- function(f) {
    fpath <- file.path(input_path, f)
    f_ext <- tolower(tools::file_ext(f))
    if (!is.null(encoding) && f_ext %in% text_exts) {
      rio::import(fpath, encoding = encoding, trust = TRUE)
    } else {
      rio::import(fpath, trust = TRUE)
    }
  }

  datasets <- purrr::map(lfiles, import_one) %>%
    stats::setNames(lfiles)

  # Clean names (without extension) for labeling
  clean_names <- tools::file_path_sans_ext(lfiles)
  named_datasets <- stats::setNames(datasets, clean_names)

  # Compute inspection for each dataset
  inspections <- purrr::map(datasets, inspect)

  # Dimensions summary
  dims <- purrr::map_dfr(seq_along(datasets), function(idx) {
    df <- datasets[[idx]]
    tibble::tibble(
      datasets = clean_names[idx],
      nobs = nrow(df),
      nvar = ncol(df)
    )
  })

  # Combined inspection table
  inspect_tot <- purrr::map_dfr(seq_along(inspections), function(idx) {
    inspections[[idx]] %>%
      dplyr::mutate(datasets = clean_names[idx])
  }) %>%
    dplyr::relocate(datasets) %>%
    dplyr::left_join(dims, by = "datasets") %>%
    dplyr::relocate(nvar, nobs, .after = datasets)

  # Individual inspection sheets (with prepended dims rows for backward compat)
  inspect_sheets <- purrr::map(seq_along(inspections), function(idx) {
    df <- datasets[[idx]]
    i <- inspections[[idx]]
    rbind(
      c("Obs = ", nrow(df), rep("", ncol(i) - 1)),
      c("Nvars = ", nrow(i), rep("", ncol(i) - 1)),
      cbind(1:nrow(i), i)
    )
  }) %>%
    stats::setNames(clean_names)

  # Variable detection and type comparison
  vars_detect_data <- vars_detect(named_datasets)
  vars_detect_everywhere_data <- vars_detect_everywhere(vars_detect_data)
  vars_detect_not_everywhere_data <- vars_detect_not_everywhere(vars_detect_data)

  vars_compclasses_data <- vars_compclasses(named_datasets)
  # Reorder to match vars_detect row order
  vars_compclasses_data <- vars_compclasses_data[
    order(match(vars_compclasses_data$vars_union,
                vars_detect_data$vars_union)), ]

  vars_compclasses_allsame_data <- vars_compclasses_allsame(vars_compclasses_data)
  vars_compclasses_not_allsame_data <- vars_compclasses_not_allsame(vars_compclasses_data)

  # Assemble all sheets
  sheets <- c(
    list(dims = dims, inspect_tot = inspect_tot),
    inspect_sheets,
    list(
      vars_detect = vars_detect_data,
      vars_detect_everywhere = vars_detect_everywhere_data,
      vars_detect_not_everywhere = vars_detect_not_everywhere_data,
      vars_compclasses = vars_compclasses_data,
      vars_compclasses_allsame = vars_compclasses_allsame_data,
      vars_compclasses_not_allsame = vars_compclasses_not_allsame_data
    )
  )

  out_path <- file.path(output_path, paste0("inspect_vars_", output_label, ".xlsx"))
  writexl::write_xlsx(sheets, out_path)

  invisible(out_path)
}
