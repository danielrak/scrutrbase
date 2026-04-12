# Convert all datasets within a folder to a given file format

Scan a folder for files matching specified extensions, then convert each
one to the target format. Void character values are replaced with `NA`
and character whitespace is trimmed.

## Usage

``` r
convert_all(
  input_folderpath,
  considered_extensions,
  to,
  output_folderpath = input_folderpath
)
```

## Arguments

- input_folderpath:

  Character. Folder path containing datasets to convert.

- considered_extensions:

  Character vector. File extensions to include (must be supported by
  rio).

- to:

  Character. The target output format (must be supported by rio).

- output_folderpath:

  Character. Folder path for converted files (defaults to
  `input_folderpath`).

## Value

Invisibly returns a character vector of output file paths.

## Examples

``` r
# \donttest{
mydir <- system.file("permadir_examples_and_tests/convert_all", package = "scrutr")
outdir <- tempdir()

convert_all(input_folderpath = mydir,
            considered_extensions = c("rds"),
            to = "csv",
            output_folderpath = outdir)
#> Converting: original_cars.rds
#>   Done: original_cars.csv

list.files(outdir, pattern = "csv$")
#> [1] "original_cars.csv"
# }
```
