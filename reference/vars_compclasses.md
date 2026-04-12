# Collection-level variables types comparison

Compare the class of each variable across a collection of datasets.

## Usage

``` r
vars_compclasses(data_frames)
```

## Arguments

- data_frames:

  A named list of data frames to compare.

## Value

A data frame with a `vars_union` column and one column per dataset
showing the class of each variable (`"-"` if absent from that dataset).

## Examples

``` r
data_list <- list(cars = cars, mtcars = mtcars)
vars_compclasses(data_list)
#> # A tibble: 13 × 3
#>    vars_union cars    mtcars 
#>    <chr>      <chr>   <chr>  
#>  1 speed      numeric -      
#>  2 dist       numeric -      
#>  3 mpg        -       numeric
#>  4 cyl        -       numeric
#>  5 disp       -       numeric
#>  6 hp         -       numeric
#>  7 drat       -       numeric
#>  8 wt         -       numeric
#>  9 qsec       -       numeric
#> 10 vs         -       numeric
#> 11 am         -       numeric
#> 12 gear       -       numeric
#> 13 carb       -       numeric
```
