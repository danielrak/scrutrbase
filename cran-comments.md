## Submission type

This is a patch (0.3.1) to fix a CRAN check failure on Debian.

The detect_chars_structure_datasets() example and tests wrote an output
file to the installed package directory via system.file(), which is
read-only on CRAN's Debian check infrastructure. All file writes in
examples and tests now use tempdir() with proper cleanup via unlink().

## Test environments

- Local: Windows 11, R 4.5.x
- GitHub Actions: ubuntu-latest, macOS-latest, windows-latest (R-release)
- win-builder: R-release and R-devel

## R CMD check results

0 errors | 0 warnings | 1 note

* checking CRAN incoming feasibility ... NOTE
  Maintainer: 'Daniel Rakotomalala <rakdanielh@gmail.com>'

This NOTE is expected for an update submission.

## Downstream dependencies

There are currently no downstream dependencies for this package.
