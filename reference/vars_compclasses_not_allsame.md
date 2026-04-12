# Variable class comparison - inconsistent types across datasets

Variable class comparison - inconsistent types across datasets

## Usage

``` r
vars_compclasses_not_allsame(vars_compclasses_table)
```

## Arguments

- vars_compclasses_table:

  Output of the [`vars_compclasses()`](vars_compclasses.md) function.

## Value

A subset of `vars_compclasses_table` containing only variables with
different classes across datasets where they appear.

## Examples

``` r
data_list <- list(cars = cars, mtcars = mtcars)
vcompclasses <- vars_compclasses(data_list)
vars_compclasses_not_allsame(vcompclasses)
#> # A tibble: 0 × 3
#> # ℹ 3 variables: vars_union <chr>, cars <chr>, mtcars <chr>
```
