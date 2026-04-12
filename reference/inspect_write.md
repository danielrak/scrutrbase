# Inspect a data frame and write the output to an Excel file

Inspect a data frame and write the output to an Excel file

## Usage

``` r
inspect_write(data_frame, output_path, output_label = NULL)
```

## Arguments

- data_frame:

  A data frame to inspect.

- output_path:

  Character. Folder path where the Excel output will be written.

- output_label:

  Character. Optional label for the output file. If `NULL`, defaults to
  the deparsed name of `data_frame`.

## Value

Invisibly returns the path to the written Excel file. The file contains
the inspection table with prepended observation and variable counts.

## Examples

``` r
mydir <- file.path(tempdir(), "inspect_write_example")
dir.create(mydir)
inspect_write(data_frame = cars,
              output_path = mydir,
              output_label = "cars")
readxl::read_xlsx(file.path(mydir, "inspect_cars.xlsx"))
#> # A tibble: 4 × 11
#>   `1:nrow(i)` variables class   nb_distinct prop_distinct nb_na prop_na nb_void
#>   <chr>       <chr>     <chr>   <chr>       <chr>         <chr> <chr>   <chr>  
#> 1 Obs =       50        NA      NA          NA            NA    NA      NA     
#> 2 Nvars =     2         NA      NA          NA            NA    NA      NA     
#> 3 1           speed     numeric 19          0.38          0     0       0      
#> 4 2           dist      numeric 35          0.7           0     0       0      
#> # ℹ 3 more variables: prop_void <chr>, nchars <chr>, modalities <chr>
unlink(mydir, recursive = TRUE)
```
