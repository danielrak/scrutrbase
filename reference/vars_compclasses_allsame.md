# Variable class comparison - consistent types across all datasets

Variable class comparison - consistent types across all datasets

## Usage

``` r
vars_compclasses_allsame(vars_compclasses_table)
```

## Arguments

- vars_compclasses_table:

  Output of the [`vars_compclasses()`](vars_compclasses.md) function.

## Value

A subset of `vars_compclasses_table` containing only variables with the
same class across all datasets where they appear.

## Examples

``` r
data_list <- list(cars = cars, mtcars = mtcars)
vcompclasses <- vars_compclasses(data_list)
vars_compclasses_allsame(vcompclasses)
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
