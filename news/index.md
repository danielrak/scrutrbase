# Changelog

## scrutr (development version)

## scrutr 0.3.0

CRAN release: 2026-04-22

### Breaking changes

- Package renamed from `industtry` to `scrutr`.
- Removed `serial_import()`, `parallel_import()`, `assign_to_global()`,
  and `current_script_location()`. These relied on global environment
  side effects or RStudio-only dependencies.
- [`inspect_vars()`](../reference/inspect_vars.md) now returns a named
  list of data frames instead of assigning to the global environment.
- [`vars_detect()`](../reference/vars_detect.md),
  [`vars_compclasses()`](../reference/vars_compclasses.md), and related
  functions now accept a named list of data frames instead of character
  vectors of object names.
- [`inspect_write()`](../reference/inspect_write.md) now takes a data
  frame object directly (`data_frame`) instead of a string name
  (`data_frame_name`).

### Improvements

- Removed non-CRAN dependencies: `job`, `plyr`, `rstudioapi`.
- Eliminated all global environment pollution
  ([`assign()`](https://rdrr.io/r/base/assign.html),
  [`get()`](https://rdrr.io/r/base/get.html), `<<-`).
- [`convert_all()`](../reference/convert_all.md) is now synchronous (no
  longer requires RStudio background jobs).
- [`inspect()`](../reference/inspect.md) collapses multi-element class
  vectors (e.g. `ordered/factor`) into a single string per variable.
- [`path_move()`](../reference/path_move.md) uses `fixed = TRUE` in
  [`strsplit()`](https://rdrr.io/r/base/strsplit.html) for correct
  separator handling.
- Modernized deprecated
  [`dplyr::mutate_if()`](https://dplyr.tidyverse.org/reference/mutate_all.html)/`mutate_all()`
  to
  [`dplyr::across()`](https://dplyr.tidyverse.org/reference/across.html).
- Comprehensive test suite rewritten for the new API.

## scrutr 0.2.0

- Enhancements of short docs.
- Add long docs.
- Polish.

## scrutr 0.1.0

Development enhancements:

- Add examples and tests as far as possible.
- Correction of warnings and notes.
- Before complete documentation.
