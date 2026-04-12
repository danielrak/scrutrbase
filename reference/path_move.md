# Move through paths

Move through paths

## Usage

``` r
path_move(path_vector, path_separator = "/", move)
```

## Arguments

- path_vector:

  Character. Vector of paths with equal number of levels.

- path_separator:

  Character. Path separator (adapted to your OS, e.g. `"/"`).

- move:

  Integer. If positive, outputs path up to the specified level. If
  negative, removes the last specified level(s).

## Value

Character vector of transformed paths.

## Examples

``` r
pvector <- c(
  "level_1/level_2/level_3/file_1.ext",
  "level_1/level_2/level_3/file_2.ext"
)

path_move(path_vector = pvector,
          path_separator = "/",
          move = 1)
#> [1] "level_1" "level_1"

path_move(path_vector = pvector,
          path_separator = "/",
          move = 2)
#> [1] "level_1/level_2" "level_1/level_2"

path_move(path_vector = pvector,
          path_separator = "/",
          move = -1)
#> [1] "level_1/level_2/level_3" "level_1/level_2/level_3"

path_move(path_vector = pvector,
          path_separator = "/",
          move = -2)
#> [1] "level_1/level_2" "level_1/level_2"
```
