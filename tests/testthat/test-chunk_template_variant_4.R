test_that("Chunk template variant 4 exists and has expected structure", {
  templates <- get_chunk_template_defaults(4)

  expect_s3_class(templates, "data.frame")
  expect_true(nrow(templates) > 0)
  expect_named(templates, c(
    ".template_name", ".template_variable_type_dep",
    ".template_variable_type_indep", ".template"
  ))
})

test_that("Chunk template variant 4 has expected template names", {
  templates <- get_chunk_template_defaults(4)

  template_names <- unique(templates$.template_name)
  expect_true("cat_plot_html" %in% template_names)
  expect_true("int_plot_html" %in% template_names)
  expect_true("cat_table_html" %in% template_names)
  expect_true("chr_table" %in% template_names)
})

test_that("Chunk template variant 4 uses crowd_plots_as_tabset", {
  templates <- get_chunk_template_defaults(4)

  # Check that at least one template contains crowd_plots_as_tabset
  has_crowd_plots <- any(grepl("crowd_plots_as_tabset", templates$.template))
  expect_true(has_crowd_plots)
})

test_that("Chunk template variant 4 uses txt_from_cat_mesos_plots", {
  templates <- get_chunk_template_defaults(4)

  # Check that at least one template contains txt_from_cat_mesos_plots
  has_txt_from_cat <- any(grepl("txt_from_cat_mesos_plots", templates$.template))
  expect_true(has_txt_from_cat)
})

test_that("Chunk template variant 4 templates include mesos_var and mesos_group params", {
  templates <- get_chunk_template_defaults(4)

  # All templates should reference params$mesos_var and params$mesos_group
  has_mesos_var <- all(grepl("mesos_var = params\\$mesos_var", templates$.template))
  has_mesos_group <- all(grepl("mesos_group = params\\$mesos_group", templates$.template))

  expect_true(has_mesos_var)
  expect_true(has_mesos_group)
})
