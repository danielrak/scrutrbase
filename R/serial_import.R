# serial_import has been removed.
# The function encouraged an anti-pattern (importing many datasets into the
# global environment simultaneously). Use rio::import() with purrr::map()
# to read files into a named list instead:
#
#   datasets <- purrr::map(file_paths, rio::import) |>
#     stats::setNames(basename(file_paths))
