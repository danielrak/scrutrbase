# Inspect a data frame

Compute a summary of each variable in a data frame: class, distinct
values, missing values, void strings, character lengths, and sample
modalities.

## Usage

``` r
inspect(data_frame, nrow = FALSE)
```

## Arguments

- data_frame:

  A data frame to inspect.

- nrow:

  Logical. If `TRUE`, the number of observations is printed as a message
  in addition to the returned table.

## Value

A tibble with one row per variable and columns: `variables`, `class`,
`nb_distinct`, `prop_distinct`, `nb_na`, `prop_na`, `nb_void`,
`prop_void`, `nchars`, `modalities`.

## Examples

``` r
inspect(CO2)
#> # A tibble: 5 × 10
#>   variables class      nb_distinct prop_distinct nb_na prop_na nb_void prop_void
#>   <chr>     <chr>            <int>         <dbl> <int>   <dbl>   <int>     <dbl>
#> 1 Plant     ordered/f…          12        0.143      0       0       0         0
#> 2 Type      factor               2        0.0238     0       0       0         0
#> 3 Treatment factor               2        0.0238     0       0       0         0
#> 4 conc      numeric              7        0.0833     0       0       0         0
#> 5 uptake    numeric             76        0.905      0       0       0         0
#> # ℹ 2 more variables: nchars <chr>, modalities <chr>
```
