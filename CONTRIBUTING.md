# Contributing to scrutr

This document outlines how to propose a change to `scrutr`. For
questions, please use the [discussions
page](https://github.com/danielrak/scrutr/discussions) rather than
opening an issue.

## Fixing typos

Small typos or grammatical errors in documentation may be edited
directly using the GitHub web interface, as long as the changes are made
in the **source** file.

- YES: edit a roxygen comment in a `dev/flat_*.Rmd` file.
- NO: edit a generated `.Rd` file under `man/`, or a generated `.R` file
  under `R/`.

## Bigger changes

If you want to make a bigger change, open an issue first to discuss it.
Scope creep is the single biggest cause of PRs being rejected.

### Pull request process

1.  Fork the package and clone it.
2.  Create a Git branch for your PR.
3.  `scrutr` uses [`fusen`](https://thinkr-open.github.io/fusen/) to
    generate the `R/`, `man/`, and `tests/testthat/` files from
    `dev/flat_*.Rmd`. Edit the relevant flat file, then run
    `fusen::inflate()` to regenerate.
4.  `scrutr` uses
    [`roxygen2`](https://cran.r-project.org/package=roxygen2), with
    Markdown syntax, for documentation.
5.  `scrutr` uses
    [`testthat`](https://cran.r-project.org/package=testthat).
    Contributions with test cases are easier to accept.
6.  Make sure `devtools::check()` returns 0 errors / 0 warnings / 0
    notes.
7.  Add a bullet to the top of `NEWS.md`, below the current development
    version header, describing the user-visible change in complete
    sentences.
8.  Open the pull request.

### Code style

- New code should follow the [tidyverse style
  guide](https://style.tidyverse.org).
- Use [`styler`](https://CRAN.R-project.org/package=styler) to apply
  these styles, but do not restyle code unrelated to your PR.

## Code of Conduct

Please note that the `scrutr` project is released with a [Contributor
Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project,
you agree to abide by its terms.
