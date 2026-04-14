# scrutr

`scrutr` is an R toolkit for **scrutinizing collections of structured
datasets** (data frames). It targets workflows where you need to apply
the same inspection, profiling, or conversion procedure across many
related tables.

Two guiding ideas:

1.  **“Collections first”**: common tasks (inspecting, detecting schema
    differences, batch conversion) operate at the *collection* level,
    not one dataset at a time.
2.  **“Operational tooling”**: lightweight helpers for paths,
    duplicates, join checks, and string replacements that recur in
    production data pipelines.

------------------------------------------------------------------------

## Installation

``` r
# install.packages("devtools")
devtools::install_github("danielrak/scrutr")
```

------------------------------------------------------------------------

## API overview

| Area                        | Main intent                                                         | Key functions                                                             |
|:----------------------------|:--------------------------------------------------------------------|:--------------------------------------------------------------------------|
| Inspection & profiling      | Profile one dataset or a whole folder; export diagnostics to Excel. | inspect(), inspect_write(), inspect_vars()                                |
| Schema detection            | Detect variable presence across datasets; compare classes.          | vars_detect(), vars_compclasses(), detect_chars_structure_datasets()      |
| Batch conversion / renaming | Convert file formats or rename files at scale via Excel masks.      | convert_r(), convert_all(), mask_convert_r(), mask_rename_r(), rename_r() |
| Data hygiene                | Duplicate diagnostics, join checks, proportions.                    | dupl_show(), dupl_sources(), ljoin_checks(), table_prop()                 |
| Paths & filesystem          | Replicate folder structures, move through paths.                    | folder_structure_replicate(), path_move()                                 |
| Utilities                   | Batch string replacement.                                           | replace_multiple()                                                        |

------------------------------------------------------------------------

## Quick examples

### Inspect a single data frame

``` r
library(scrutr)
result <- inspect(CO2)
head(result)
```

### Inspect a folder of datasets and export to Excel

``` r
mydir <- file.path(tempdir(), "example")
dir.create(mydir, showWarnings = FALSE)

saveRDS(cars, file.path(mydir, "cars.rds"))
saveRDS(mtcars, file.path(mydir, "mtcars.rds"))

inspect_vars(
  input_path = mydir,
  output_path = mydir,
  output_label = "diagnostics",
  considered_extensions = "rds"
)
```

### Batch conversion with `convert_all()`

``` r
convert_all(
  input_folderpath = mydir,
  considered_extensions = "rds",
  to = "csv",
  output_folderpath = file.path(mydir, "csv_output")
)
```

### Mask-driven conversion with `convert_r()`

``` r
# 1. Generate an Excel mask template
mask_convert_r(output_path = mydir)

# 2. Fill in the mask, then run:
convert_r(
  mask_filepath = file.path(mydir, "mask_convert_r.xlsx"),
  output_path = mydir
)
```
