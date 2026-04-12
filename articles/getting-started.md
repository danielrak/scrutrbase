# Getting started with scrutr

`scrutr` helps you inspect, profile, and convert **collections of
structured datasets**. This vignette walks through the main workflows.

## Setup

``` r
library(scrutr)
```

## Inspecting a single data frame

[`inspect()`](../reference/inspect.md) produces a one-row-per-variable
summary: class, distinct count, missing values, void strings, character
lengths, and sample modalities.

``` r
result <- inspect(CO2)
result
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

Use `nrow = TRUE` to also print the number of observations:

``` r
result <- inspect(CO2, nrow = TRUE)
#> Number of observations: 84
```

## Comparing variables across datasets

When working with several related tables, you often need to know which
variables appear where and whether their types are consistent.

``` r
data_list <- list(
  cars = cars,
  mtcars = mtcars[, c("mpg", "hp", "wt", "speed")  |> intersect(names(mtcars))],
  iris = iris
)

# Which variables are in which datasets?
vars_detect(data_list)
#> # A tibble: 10 × 4
#>    vars_union   cars  mtcars iris 
#>    <chr>        <chr> <chr>  <chr>
#>  1 speed        ok    -      -    
#>  2 dist         ok    -      -    
#>  3 mpg          -     ok     -    
#>  4 hp           -     ok     -    
#>  5 wt           -     ok     -    
#>  6 Sepal.Length -     -      ok   
#>  7 Sepal.Width  -     -      ok   
#>  8 Petal.Length -     -      ok   
#>  9 Petal.Width  -     -      ok   
#> 10 Species      -     -      ok
```

[`vars_compclasses()`](../reference/vars_compclasses.md) goes further
and compares the class of each shared variable:

``` r
# Use two datasets that share some columns
shared_list <- list(
  df1 = data.frame(x = 1:3, y = c("a", "b", "c"), stringsAsFactors = FALSE),
  df2 = data.frame(x = c(1.1, 2.2, 3.3), y = c("d", "e", "f"), stringsAsFactors = FALSE)
)

vars_compclasses(shared_list)
#> # A tibble: 2 × 3
#>   vars_union df1       df2      
#>   <chr>      <chr>     <chr>    
#> 1 x          integer   numeric  
#> 2 y          character character
```

## Inspecting a whole folder of datasets

[`inspect_vars()`](../reference/inspect_vars.md) is the main
collection-level function. Point it at a folder, and it reads all
matching files, inspects each one, then writes a comprehensive Excel
report.

``` r
# Create a temporary folder with example datasets
mydir <- file.path(tempdir(), "scrutr_demo")
dir.create(mydir, showWarnings = FALSE)

saveRDS(cars, file.path(mydir, "cars.rds"))
saveRDS(mtcars, file.path(mydir, "mtcars.rds"))
saveRDS(iris, file.path(mydir, "iris.rds"))

# Run the full inspection pipeline
inspect_vars(
  input_path = mydir,
  output_path = mydir,
  output_label = "demo",
  considered_extensions = "rds"
)

# The output Excel file contains multiple sheets:
# dims, inspect_tot, one sheet per dataset, vars_detect, vars_compclasses, etc.
list.files(mydir, pattern = "\\.xlsx$")
```

## Batch format conversion

### Simple folder conversion with `convert_all()`

Convert all matching files in a folder to another format:

``` r
convert_all(
  input_folderpath = mydir,
  considered_extensions = "rds",
  to = "csv",
  output_folderpath = file.path(mydir, "csv")
)
```

### Mask-driven conversion with `convert_r()`

For more control, use an Excel mask that specifies exactly which files
to convert and how to name the outputs:

``` r
# 1. Generate a mask template
mask_convert_r(output_path = mydir)

# 2. Edit the mask in Excel, then:
convert_r(
  mask_filepath = file.path(mydir, "mask_convert_r.xlsx"),
  output_path = mydir
)
```

## Data hygiene helpers

`scrutr` includes several utilities for common data quality checks:

``` r
# Find duplicates in a data frame
df <- data.frame(id = c(1, 2, 2, 3, 3, 3), value = letters[1:6])
dupl_show(df, "id")
#>   id value
#> 1  2     b
#> 2  2     c
#> 3  3     d
#> 4  3     e
#> 5  3     f
```

``` r
# Check a left join for key issues
left_df <- data.frame(key = c("a", "b", "c"))
right_df <- data.frame(key = c("a", "b", "b", "d"), val = 1:4)
ljoin_checks(left_df, right_df, "key")
#> Checks : 
#> ltable rows : 3
#> rtable rows :4
#> jtable rows : 4
#> key are common var names accross the two tables
#>   key val
#> 1   a   1
#> 2   b   2
#> 3   b   3
#> 4   c  NA
```

## Path utilities

``` r
paths <- c("data/raw/2024/file1.csv", "data/raw/2024/file2.csv")

# Keep only the first 2 levels
path_move(paths, "/", 2)
#> [1] "data/raw" "data/raw"

# Remove the last level (filename)
path_move(paths, "/", -1)
#> [1] "data/raw/2024" "data/raw/2024"
```
