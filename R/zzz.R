utils::globalVariables(names = c(".", ".data", ".env"))

if (!exists(".saros.env")) .saros.env <- NULL
.onLoad <- function(libname, pkgname) {
  # Initialize the .saros.env environment if not already set
  if (!exists(".saros.env")) .saros.env <<- new.env(parent = emptyenv())


  .saros.env$core_chapter_structure_cols <<-
    c(
      "chapter",
      paste0(c(
        ".variable_role", ".variable_selection", ".variable_position",
        ".variable_name", ".variable_name_prefix", ".variable_name_suffix",
        ".variable_label_prefix", ".variable_label_suffix",
        ".variable_type"
      ), "_dep"),
      paste0(c(
        ".variable_role", ".variable_selection", ".variable_position",
        ".variable_name", ".variable_name_prefix", ".variable_name_suffix",
        ".variable_label_prefix", ".variable_label_suffix",
        ".variable_type"
      ), "_indep"),
      ".bi_test",
      ".p_value",
      ".template_name",
      ".template", ".variable_group_id", ".n", ".n_range", ".n_cats_dep",
      ".max_chars_cats_dep",
      ".max_chars_labels_dep", ".n_dep",
      ".n_indep",
      ".obj_name", ".chunk_name", ".file_name", ".chapter_number",
      ".chapter_foldername"
    )

  .saros.env$peripheral_chapter_structure_cols <<-
    c(
      ".keep_indep",
      ".keep_bi_rows",
      ".n_cats_indep",
      ".max_chars_cats_indep",
      ".max_chars_labels_indep"
    )

  # These actually do not exist in this form, but contain some suffixes
  .saros.env$core_chapter_structure_pattern <<-
    "\\.template_variable_type_dep|\\.template_variable_type_indep"


  .saros.env$ignore_args <<- c(
    "data",
    "dep",
    "indep",
    "chapter_overview",
    "chapter_structure",
    "call",
    "..."
  )



  ################################################################################
  # for a single crowd only, no mesos
  .saros.env$default_chunk_templates_1 <<-
    data.frame(
      .template_name = character(),
      .template_variable_type_dep = character(),
      .template_variable_type_indep = character(),
      .template = character()
    ) |>
    tibble::add_row(
      .template_name = "cat_plot_html",
      .template_variable_type_dep = "fct;ord",
      .template_variable_type_indep = "fct;ord",
      .template =
        "
::: {{#fig-{.chunk_name}}}

```{{r, fig.height=fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_cats_y={.max_chars_cats_dep}, max_chars_labels_y={.max_chars_labels_dep}, n_x={.n_indep}, n_cats_x={.n_cats_indep}, max_chars_cats_x={.max_chars_cats_indep}, max_chars_labels_x={.max_chars_labels_indep})}}
{.obj_name} <- \n\tdata_{.chapter_foldername} |>\n\t\tmakeme(dep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep}), \n\t\ttype = 'cat_plot_html')
nrange <- stringi::stri_c('N = ', n_range2({.obj_name}))
link <- make_link(data = {.obj_name}$data)
link_plot <- make_link(data = {.obj_name}, \n\t\tfile_suffix = '.png', link_prefix='[PNG](', \n\t\tsave_fn = ggsaver)
x <- I(paste0(c(nrange, link, link_plot), collapse=', '))
girafe(ggobj = {.obj_name})
```

_{.variable_label_prefix_dep}_ by _{tolower(.variable_label_prefix_indep)}_. `{{r}} x`.

:::


"
    ) |>
    tibble::add_row(
      .template_name = "cat_plot_html",
      .template_variable_type_dep = "fct;ord",
      .template_variable_type_indep = NA_character_,
      .template =
        "
::: {{#fig-{.chunk_name}}}

```{{r, fig.height=fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_labels_y={.max_chars_labels_dep}, max_chars_cats_y={.max_chars_cats_dep})}}
{.obj_name} <- \n\tdata_{.chapter_foldername} |>\n\t\tmakeme(dep = c({.variable_name_dep}), \n\t\ttype = 'cat_plot_html')
nrange <- stringi::stri_c('N = ', n_range2({.obj_name}))
link <- make_link(data = {.obj_name}$data)
link_plot <- make_link(data = {.obj_name}, \n\t\tfile_suffix = '.png', link_prefix='[PNG](', \n\t\tsave_fn = ggsaver)
x <- I(paste0(c(nrange, link, link_plot), collapse=', '))
girafe(ggobj = {.obj_name})
```

_{.variable_label_prefix_dep}_. `{{r}} x`.

:::

"
    ) |>
    tibble::add_row(
      .template_name = "cat_table_html",
      .template_variable_type_dep = "fct;ord",
      .template_variable_type_indep = "fct;ord",
      .template =
        "
::: {{#tbl-{.chunk_name}}}

```{{r}}
{.obj_name} <- \n\tdata_{.chapter_foldername} |>\n\t\tmakeme(dep = c({.variable_name_dep}),  \n\t\tindep = c({.variable_name_indep}), \n\t\ttype = 'cat_table_html')
nrange <- stringi::stri_c('N = ', n_range(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\tindep = c({.variable_name_indep})))
link <- make_link(data={.obj_name})
x <- I(paste0(c(nrange, link), collapse=', '))
gt({.obj_name})
```

_{.variable_label_prefix_dep}_ by _{tolower(.variable_label_prefix_indep)}_. `{{r}} x`.

:::


"
    ) |>
    tibble::add_row(
      .template_name = "cat_table_html",
      .template_variable_type_dep = "fct;ord",
      .template_variable_type_indep = NA_character_,
      .template =
        "
::: {{#tbl-{.chunk_name}}}

```{{r}}
{.obj_name} <- \n\tdata_{.chapter_foldername} |>\n\t\tmakeme(dep = c({.variable_name_dep}), \n\t\ttype = 'cat_table_html')
nrange <- stringi::stri_c('N = ', n_range(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep})))
link <- make_link(data={.obj_name})
x <- I(paste0(c(nrange, link), collapse=', '))
gt({.obj_name})
```

_{.variable_label_prefix_dep}_. N=`{{r}} x`.

:::


"
    ) |>
    tibble::add_row(
      .template_name = "chr_table",
      .template_variable_type_dep = "chr",
      .template_variable_type_indep = NA_character_,
      .template =
        "
::: {{#tbl-{.chunk_name}}}

```{{r}}
{.obj_name} <- \n\tmakeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\ttype = 'chr_table_html')
gt({.obj_name})
```

_{.variable_label_prefix_dep}_.

:::


"
    ) #|>

  #     tibble::add_row(.template_name = "sigtest_table_html",
  #                     .template =
  #                       "
  # ::: {{#tbl-{.chunk_name}}}
  #
  # ```{{r}}
  # {.obj_name} <- \n\tmakeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep}), \n\t\ttype = 'sigtest_table_html')
  # gt::gt({.obj_name})
  # ```
  #
  # _Significance tests_.
  #
  # :::
  #
  #
  # ",
  #                     .template_variable_type_dep = "fct;ord;int;dbl",
  #                     .template_variable_type_indep = "fct;ord;int;dbl")

  #######################################################################################################################
  #### For crowd = c("target", "others") (and/or "all") in a tidy way

  .saros.env$default_chunk_templates_2 <<-
    data.frame(
      .template_name = character(),
      .template_variable_type_dep = character(),
      .template_variable_type_indep = character(),
      .template = character()
    ) |>
    tibble::add_row(
      .template_name = "cat_plot_html",
      .template_variable_type_dep = "fct;ord",
      .template_variable_type_indep = "fct;ord",
      .template =
        "
::: {{#fig-{.chunk_name}}}

```{{r}}
#| output: asis
#| panel: tabset
plots <- \n\tsaros::makeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep}), \n\t\ttype='cat_plot_html', \n\t\tcrowd=c('target', 'others'), \n\t\tmesos_var = params$mesos_var, \n\t\tmesos_group = params$mesos_group)

if(!all(sapply(plots, is.null))) {{

  lapply(names(plots), function(.x) {{
    knitr::knit_child(text = c(
      '##### `r .x`',
      '```{{r}}',
      'library(saros)',
      'knitr::opts_template$set(fig = list(fig.height = fig_height_h_barchart2(plots[[.x]])))',
      '```',
      '',
      '```{{r, opts.label=\\'fig\\'}}',
      'library(ggplot2)',
      'library(ggiraph)',
      'nrange <- stringi::stri_c(\\'N = \\', n_range2(plots[[.x]]))',
      'link <- make_link(data = plots[[.x]]$data)',
      'link_plot <- make_link(data = plots[[.x]], link_prefix=\\'[PNG](\\', file_suffix = \\'.png\\', save_fn = ggsaver)',
      'x <- I(paste0(c(nrange, link, link_plot), collapse=\\', \\'))',
      'girafe(ggobj = plots[[.x]])',
      '```',
      '',
      '`r x`',
      ''
      ), envir = environment(), quiet = TRUE)
  }}) |> unlist() |> cat(sep = '\\n')
}}
```

_{.variable_label_prefix_dep}_ by _{tolower(.variable_label_prefix_indep)}_.

:::


"
    ) |>
    tibble::add_row(
      .template_name = "cat_plot_html",
      .template_variable_type_dep = "fct;ord",
      .template_variable_type_indep = NA_character_,
      .template =
        "
::: {{#fig-{.chunk_name}}}

```{{r}}
#| output: asis
#| panel: tabset
plots <- \n\tsaros::makeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\ttype='cat_plot_html', \n\t\tcrowd=c('target', 'others'), \n\t\tmesos_var = params$mesos_var, \n\t\tmesos_group = params$mesos_group)

if(!all(sapply(plots, is.null))) {{

  lapply(names(plots), function(.x) {{
    knitr::knit_child(text = c(
      '##### `r .x`',
      '',
      '',
      '```{{r}}',
      'library(saros)',
      'knitr::opts_template$set(fig = list(fig.height = fig_height_h_barchart2(plots[[.x]])))',
      '',
      '```',
      '',
      '```{{r, opts.label=\\'fig\\'}}',
      'library(ggplot2)',
      'library(ggiraph)',
      'nrange <- stringi::stri_c(\\'N = \\', n_range2(plots[[.x]]))',
      'link <- make_link(data = plots[[.x]]$data)',
      'link_plot <- make_link(data = plots[[.x]], link_prefix=\\'[PNG](\\', file_suffix = \\'.png\\', save_fn = ggsaver)',
      'x <- I(paste0(c(nrange, link, link_plot), collapse=\\', \\'))',
      'girafe(ggobj = plots[[.x]])',
      '```',
      '',
      '`r x`'
      ), envir = environment(), quiet = TRUE)
  }}) |> unlist() |> cat(sep = '\\n')
}}
```

_{.variable_label_prefix_dep}_.

:::

"
    ) |>
    tibble::add_row(
      .template_name = "cat_table_html",
      .template_variable_type_dep = "fct;ord",
      .template_variable_type_indep = "fct;ord",
      .template =
        "
::: {{#tbl-{.chunk_name}}}

```{{r}}
#| output: asis
#| panel: tabset
tbls <- \n\tsaros::makeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep}), \n\t\ttype='cat_table_html', \n\t\tcrowd=c('target', 'others'), \n\t\tmesos_var = params$mesos_var, \n\t\tmesos_group = params$mesos_group)
if(!all(sapply(tbls, is.null))) {{

lapply(names(tbls), function(.x) {{
  knitr::knit_child(text = c(
    '##### `r .x`',
    '',
    '```{{r}}',
    'library(gt)',
    'library(saros)',
    'nrange <- stringi::stri_c(\\'N = \\', n_range(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep})))',
    'link <- make_link(data = tbls[[.x]])',
    'x <- I(paste0(c(nrange, link), collapse=\\', \\')',
    'gt(tbls[[.x]])',
    '```',
    '',
    '`r x`',
    ''
    ), envir = environment(), quiet = TRUE)
}}) |> unlist() |> cat(sep = '\\n')
}}
```

_{.variable_label_prefix_dep}_.

:::


"
    ) |>
    tibble::add_row(
      .template_name = "cat_table_html",
      .template_variable_type_dep = "fct;ord",
      .template_variable_type_indep = NA_character_,
      .template =
        "
::: {{#tbl-{.chunk_name}}}

```{{r}}
#| output: asis
#| panel: tabset
tbls <- \n\tsaros::makeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\ttype='cat_table_html', \n\t\tcrowd=c('target', 'others'), \n\t\tmesos_var = params$mesos_var, \n\t\tmesos_group = params$mesos_group)
if(!all(sapply(tbls, is.null))) {{

lapply(names(tbls), function(.x) {{
  knitr::knit_child(text = c(
    '##### `r .x`',
    '',
    '```{{r}}',
    'library(gt)',
    'library(saros)',
    'nrange <- stringi::stri_c(\\'N = \\', n_range(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep})))',
    'link <- make_link(data = tbls[[.x]])',
    'x <- I(paste0(c(nrange, link), collapse=\\', \\')',
    'gt(tbls[[.x]])',
    '```',
    '',
    '`r x`',
    ''
    ), envir = environment(), quiet = TRUE)
}}) |> unlist() |> cat(sep = '\\n')
}}
```

_{.variable_label_prefix_dep}_.

:::


"
    ) |>
    tibble::add_row(
      .template_name = "chr_table",
      .template_variable_type_dep = "chr",
      .template_variable_type_indep = NA_character_,
      .template =
        "
::: {{#tbl-{.chunk_name}}}

```{{r}}
library(gt)
{.obj_name} <- \n\tsaros::makeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\ttype = 'chr_table_html', \n\tcrowd=c('target'), \n\tmesos_var = params$mesos_var, \n\tmesos_group = params$mesos_group)
gt({.obj_name})
```

_{.variable_label_prefix_dep}_ for `{{r}} params$mesos_group`.

:::


"
    )

  ##################################################################################################################################
  # For crowd = c("target", "others") when ggiraph has limitations in loops: manual solution
  .saros.env$default_chunk_templates_3 <<-
    data.frame(
      .template_name = character(),
      .template_variable_type_dep = character(),
      .template_variable_type_indep = character(),
      .template = character()
    ) |>
    tibble::add_row(
      .template_name = "cat_plot_html",
      .template_variable_type_dep = "fct;ord",
      .template_variable_type_indep = "fct;ord",
      .template =
        "
::: {{.panel-tabset}}

## Target

::: {{#fig-{.chunk_name}-target}}

```{{r, fig.height=saros::fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_labels_y={.max_chars_labels_dep}, max_chars_cats_y={.max_chars_cats_dep}, n_x={.n_indep}, n_cats_x={.n_cats_indep}, max_chars_labels_x={.max_chars_labels_indep}, max_chars_cats_x={.max_chars_cats_indep})}}
library(saros)
library(ggiraph)
plot <- \n\tmakeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep}), \n\t\ttype='cat_plot_html', \n\t\tcrowd='target', \n\t\tmesos_var = params$mesos_var, \n\t\tmesos_group = params$mesos_group)
nrange <- stringi::stri_c('N = ', n_range2(plot))
link <- make_link(data = plot$data)
link_plot <- make_link(data = plot, link_prefix='[PNG](', save_fn = ggsaver)
x <-  I(paste0(c(nrange, link, link_plot), collapse = ', '))
girafe(ggobj = plot)
```

`{{r}} x`.

:::


## Others

::: {{#fig-{.chunk_name}-others}}

```{{r, fig.height=saros::fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_labels_y={.max_chars_labels_dep}, max_chars_cats_y={.max_chars_cats_dep}, n_x={.n_indep}, n_cats_x={.n_cats_indep}, max_chars_labels_x={.max_chars_labels_indep}, max_chars_cats_x={.max_chars_cats_indep})}}
library(saros)
library(ggiraph)
plot <- \n\tmakeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep}), \n\t\ttype='cat_plot_html', \n\t\tcrowd='others', \n\t\tmesos_var = params$mesos_var, \n\t\tmesos_group = params$mesos_group)
nrange <- stringi::stri_c('N = ', n_range2(plot))
link <- make_link(data = plot$data)
link_plot <- make_link(data = plot, link_prefix='[PNG](', save_fn = ggsaver)
x <-  I(paste0(c(nrange, link, link_plot), collapse = ', '))
girafe(ggobj = plot)

```

`{{r}} x`.

:::

_{.variable_label_prefix_dep}_ by _{tolower(.variable_label_prefix_indep)}_.

:::


"
    ) |>
    tibble::add_row(
      .template_name = "cat_plot_html",
      .template_variable_type_dep = "fct;ord",
      .template_variable_type_indep = NA_character_,
      .template =
        "
::: {{.panel-tabset}}

## Target

::: {{#fig-{.chunk_name}-target}}

```{{r, fig.height=saros::fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_labels_y={.max_chars_labels_dep}, max_chars_cats_y={.max_chars_cats_dep})}}
library(saros)
library(ggiraph)
plot <- \n\tmakeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\ttype='cat_plot_html', \n\tcrowd='target', \n\tmesos_var = params$mesos_var, \n\tmesos_group = params$mesos_group)
nrange <- stringi::stri_c('N = ', n_range2(plot))
link <- make_link(data = plot$data)
link_plot <- make_link(data = plot, link_prefix='[PNG](', save_fn = ggsaver)
x <-  I(paste0(c(nrange, link, link_plot), collapse = ', '))
girafe(ggobj = plot)
```

`{{r}} x`.

:::


## Others

::: {{#fig-{.chunk_name}-others}}

```{{r, fig.height=saros::fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_labels_y={.max_chars_labels_dep}, max_chars_cats_y={.max_chars_cats_dep})}}
library(saros)
library(ggiraph)
plot <- \n\tmakeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\ttype='cat_plot_html', \n\tcrowd='others', \n\tmesos_var = params$mesos_var, \n\tmesos_group = params$mesos_group)
nrange <- stringi::stri_c('N = ', n_range2(plot))
link <- make_link(data = plot$data)
link_plot <- make_link(data = plot, link_prefix='[PNG](', save_fn = ggsaver)
x <-  I(paste0(c(nrange, link, link_plot), collapse = ', '))
girafe(ggobj = plot)
```

`{{r}} x`.

:::

_{.variable_label_prefix_dep}_ by _{tolower(.variable_label_prefix_indep)}_

:::


"
    ) |>
    tibble::add_row(
      .template_name = "cat_table_html",
      .template_variable_type_dep = "fct;ord",
      .template_variable_type_indep = "fct;ord",
      .template =
        "
::: {{.panel-tabset}}

## Target

::: {{#tbl-{.chunk_name}-target}}

```{{r}}
library(saros)
library(gt)
table <- \n\tmakeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep}), \n\t\ttype='cat_table_html', \n\t\tcrowd='target', \n\t\tmesos_var = params$mesos_var, \n\t\tmesos_group = params$mesos_group)
nrange <- n_range(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep}))
x <-  I(paste0(c(nrange, link), collapse = ', '))
gt(table)
```

`{{r}} x`.

:::


## Others

::: {{#tbl-{.chunk_name}-others}}

```{{r}}
library(saros)
library(gt)
table <- \n\tmakeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep}), \n\t\ttype='cat_table_html', \n\tcrowd='others', \n\t\tmesos_var = params$mesos_var, \n\t\tmesos_group = params$mesos_group)
nrange <- n_range(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep}))
x <-  I(paste0(c(nrange, link), collapse = ', '))
gt(table)

```

`{{r}} x`.

:::

_{.variable_label_prefix_dep}_

:::


"
    ) |>
    tibble::add_row(
      .template_name = "cat_table_html",
      .template_variable_type_dep = "fct;ord",
      .template_variable_type_indep = NA_character_,
      .template =
        "
::: {{.panel-tabset}}

## Target

::: {{#tbl-{.chunk_name}-target}}

```{{r}}
library(saros)
library(gt)
table <- \n\tmakeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\ttype='cat_table_html', \n\t\tcrowd='target', \n\t\tmesos_var = params$mesos_var, \n\t\tmesos_group = params$mesos_group)
nrange <- n_range(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}))
x <-  I(paste0(c(nrange, link), collapse = ', '))
gt(table)
```

`{{r}} x`.

:::


## Others

::: {{#tbl-{.chunk_name}-others}}

```{{r}}
table <- \n\tmakeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\ttype='cat_table_html', \n\tcrowd='others', \n\t\tmesos_var = params$mesos_var, \n\t\tmesos_group = params$mesos_group)
nrange <- n_range(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}))
x <-  I(paste0(c(nrange, link), collapse = ', '))
gt(table)

```

`{{r}} x`.

:::

_{.variable_label_prefix_dep}_

:::

"
    ) |>
    tibble::add_row(
      .template_name = "chr_table",
      .template_variable_type_dep = "chr",
      .template_variable_type_indep = NA_character_,
      .template =
        "
::: {{#tbl-{.chunk_name}-target}}

```{{r}}
library(saros)
library(gt)
table <- \n\tmakeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\ttype = 'chr_table_html', \n\t\tcrowd='target', \n\t\tmesos_var = params$mesos_var, \n\t\tmesos_group = params$mesos_group)
gt(table)
```

_{.variable_label_prefix_dep}_ for `{{r}} params$mesos_group`.

:::


"
    )
}
