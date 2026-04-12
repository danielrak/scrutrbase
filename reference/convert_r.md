# Batch dataset format conversion using an Excel mask

Read an Excel mask describing files to convert, then import, clean, and
re-export each file in the desired format. Cleaning includes replacing
void character values (`""`) with `NA` and trimming whitespace.

## Usage

``` r
convert_r(mask_filepath, output_path)
```

## Arguments

- mask_filepath:

  Character. Full file path to the Excel mask. The mask must contain
  columns: `folder_path`, `file`, `converted_file`, `to_convert` (1 to
  convert, 0 to skip).

- output_path:

  Character. Folder path where converted files will be placed.

## Value

Invisibly returns a character vector of output file paths.

## Examples

``` r
mydir <- system.file("permadir_examples_and_tests/convert_r", package = "scrutr")

mask <- data.frame(
  folder_path = rep(mydir, 2),
  file = c("original_cars.rds", "original_mtcars.csv"),
  converted_file = c("converted_cars.csv", "converted_mtcars.csv"),
  to_convert = rep(1, 2)
)

# \donttest{
mask_path <- file.path(tempdir(), "mask_convert_r.xlsx")
writexl::write_xlsx(mask, mask_path)

convert_r(
  mask_filepath = mask_path,
  output_path = tempdir()
)
#> Converting: original_cars.rds
#>   Done: converted_cars.csv
#> Converting: original_mtcars.csv
#>   Done: converted_mtcars.csv

# Clean up:
file.remove(file.path(tempdir(),
  c("converted_cars.csv", "converted_mtcars.csv", "mask_convert_r.xlsx")))
#> [1] TRUE TRUE TRUE
# }
```
