# Variable detection patterns

Detect the presence or absence of each variable across a collection of
datasets.

## Usage

``` r
vars_detect(data_frames)
```

## Arguments

- data_frames:

  A named list of data frames to compare.

## Value

A data frame with a `vars_union` column listing all variables, and one
column per dataset indicating `"ok"` (present) or `"-"` (absent). Rows
are sorted to highlight presence/absence patterns.

## Examples

``` r
data_list <- list(cars = cars, mtcars = mtcars)
vars_detect(data_list)
#> # A tibble: 13 × 3
#>    vars_union cars  mtcars
#>    <chr>      <chr> <chr> 
#>  1 speed      ok    -     
#>  2 dist       ok    -     
#>  3 mpg        -     ok    
#>  4 cyl        -     ok    
#>  5 disp       -     ok    
#>  6 hp         -     ok    
#>  7 drat       -     ok    
#>  8 wt         -     ok    
#>  9 qsec       -     ok    
#> 10 vs         -     ok    
#> 11 am         -     ok    
#> 12 gear       -     ok    
#> 13 carb       -     ok    
```
