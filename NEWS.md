# scrutr 0.3.0

## Breaking changes

- Package renamed from `industtry` to `scrutr`.
- Removed `serial_import()`, `parallel_import()`, `assign_to_global()`, and `current_script_location()`. These relied on global environment side effects or RStudio-only dependencies.
- `inspect_vars()` now returns a named list of data frames instead of assigning to the global environment.
- `vars_detect()`, `vars_compclasses()`, and related functions now accept a named list of data frames instead of character vectors of object names.
- `inspect_write()` now takes a data frame object directly (`data_frame`) instead of a string name (`data_frame_name`).

## Improvements

- Removed non-CRAN dependencies: `job`, `plyr`, `rstudioapi`.
- Eliminated all global environment pollution (`assign()`, `get()`, `<<-`).
- `convert_all()` is now synchronous (no longer requires RStudio background jobs).
- `inspect()` collapses multi-element class vectors (e.g. `ordered/factor`) into a single string per variable.
- `path_move()` uses `fixed = TRUE` in `strsplit()` for correct separator handling.
- Modernised deprecated `dplyr::mutate_if()`/`mutate_all()` to `dplyr::across()`.
- Comprehensive test suite rewritten for the new API.

# scrutr 0.2.0

- Enhancements of short docs. 
- Add long docs. 
- Polish. 

# scrutr 0.1.0

Dev enchancements : 

- Add examples and tests as far as possible. 
- Correction of warnings and notes. 
- Before complete documentation. 
