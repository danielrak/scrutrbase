# Variable detection - inconsistent patterns

Variable detection - inconsistent patterns

## Usage

``` r
vars_detect_not_everywhere(vars_detect_table)
```

## Arguments

- vars_detect_table:

  Output of the [`vars_detect()`](vars_detect.md) function.

## Value

A subset of `vars_detect_table` containing only variables that are not
present in every dataset.

## Examples

``` r
data_list <- list(cars = cars, mtcars = mtcars)
vdetect_table <- vars_detect(data_list)
vars_detect_not_everywhere(vdetect_table)
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
