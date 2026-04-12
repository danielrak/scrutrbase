# Variable detection - presence across all datasets

Variable detection - presence across all datasets

## Usage

``` r
vars_detect_everywhere(vars_detect_table)
```

## Arguments

- vars_detect_table:

  Output of the [`vars_detect()`](vars_detect.md) function.

## Value

A subset of `vars_detect_table` containing only variables present in all
datasets.

## Examples

``` r
data_list <- list(cars = cars, mtcars = mtcars)
vdetect_table <- vars_detect(data_list)
vars_detect_everywhere(vdetect_table)
#> # A tibble: 0 × 3
#> # ℹ 3 variables: vars_union <chr>, cars <chr>, mtcars <chr>
```
