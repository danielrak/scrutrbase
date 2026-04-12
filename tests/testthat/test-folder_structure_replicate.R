test_that("folder_structure_replicate copies structure", {
  temp_src <- tempfile()
  dir.create(temp_src)
  dir.create(file.path(temp_src, "dir1"))
  dir.create(file.path(temp_src, "dir2"))
  dir.create(file.path(temp_src, "dir2", "subdir"))

  temp_out <- tempfile()
  dir.create(temp_out)

  folder_structure_replicate(dir = temp_src, to = temp_out)

  src_dirs <- list.dirs(temp_src, full.names = FALSE, recursive = TRUE)
  out_dirs <- list.dirs(temp_out, full.names = FALSE, recursive = TRUE)

  expect_equal(sort(src_dirs), sort(out_dirs))

  unlink(c(temp_src, temp_out), recursive = TRUE)
})

test_that("folder_structure_replicate errors on identical paths", {
  temp <- tempfile()
  dir.create(temp)
  on.exit(unlink(temp, recursive = TRUE))

  expect_error(
    folder_structure_replicate(dir = temp, to = temp),
    "must not be identical"
  )
})

test_that("folder_structure_replicate errors on non-empty target", {
  temp_src <- tempfile()
  dir.create(temp_src)
  dir.create(file.path(temp_src, "dir1"))

  temp_out <- tempfile()
  dir.create(temp_out)
  dir.create(file.path(temp_out, "existing"))
  on.exit(unlink(c(temp_src, temp_out), recursive = TRUE))

  expect_error(
    folder_structure_replicate(dir = temp_src, to = temp_out),
    "must be an empty directory"
  )
})
