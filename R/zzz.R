if(!exists(".saros.env")) .saros.env <- NULL
.onLoad <- function(libname, pkgname) {
  # Initialize the .saros.env environment if not already set
  if (!exists(".saros.env")) .saros.env <<- new.env(parent = emptyenv())


  .saros.env$core_chapter_structure_cols <<-
    c("chapter",
      paste0(c(".variable_role", ".variable_selection", ".variable_position",
               ".variable_name", ".variable_name_prefix", ".variable_name_suffix",
               ".variable_label_prefix", ".variable_label_suffix",
               ".variable_type"), "_dep"),
      paste0(c(".variable_role", ".variable_selection", ".variable_position",
               ".variable_name", ".variable_name_prefix", ".variable_name_suffix",
               ".variable_label_prefix", ".variable_label_suffix",
               ".variable_type"), "_indep"),
      ".variable_group_id",
      ".template_name", ".template")
  # These actually do not exist in this form, but contain some suffixes
  .saros.env$core_chapter_structure_pattern <<-
    "\\.template_variable_type_dep|\\.template_variable_type_indep"


  .saros.env$ignore_args <<- c("data",
                               "dep",
                               "indep",
                               "chapter_overview",
                               "chapter_structure",
                               "call",
                               "...")



################################################################################
# for a single crowd only, no mesos
  .saros.env$default_chunk_templates_1 <<-
    data.frame(.template_name = character(),
               .template = character(),
               .template_variable_type_dep = character(),
               .template_variable_type_indep = character()) |>
    tibble::add_row(.template_name = "cat_plot_html",
               .template =
                 "
::: {{#fig-{.chunk_name}}}

```{{r}}
#| fig-height: !expr fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_y={.max_chars_dep}, n_x={.n_indep}, n_cats_x={.n_cats_indep}, max_chars_x={.max_chars_indep})
{.obj_name} <- \n\tmakeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep}), \n\t\ttype = 'cat_plot_html')
nrange <- n_range(data = data_{.chapter_foldername}, dep = c({.variable_name_dep}), indep = c({.variable_name_indep}))
link <- make_link(data = {.obj_name}$data)
link_plot <- make_link(data = {.obj_name}, \n\t\tfile_suffix = '.png', link_prefix='[PNG](', \n\t\tsave_fn = ggsaver, width=12, height=12, units='cm')
ggiraph::girafe(ggobj = {.obj_name})
```

_{.variable_label_prefix_dep}_ by _{tolower(.variable_label_prefix_indep)}_. N=`{{r}} nrange`. `{{r}} link`. `{{r}} link_plot`.

:::


",
               .template_variable_type_dep = "fct;ord",
               .template_variable_type_indep = "fct;ord") |>

    tibble::add_row(.template_name = "cat_plot_html",
                    .template =
                      "
::: {{#fig-{.chunk_name}}}

```{{r}}
#| fig-height: !expr fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_y={.max_chars_dep})
{.obj_name} <- \n\tmakeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\ttype = 'cat_plot_html')
nrange <- n_range(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}))
link <- make_link(data={.obj_name}$data)
link_plot <- make_link(data = {.obj_name}, file_suffix='.png', link_prefix='[PNG](', save_fn = ggsaver, width=12, height=12, units='cm')
ggiraph::girafe(ggobj = {.obj_name})
```

_{.variable_label_prefix_dep}_. N=`{{r}} nrange`. `{{r}} link`. `{{r}} link_plot`.

:::

",
                    .template_variable_type_dep = "fct;ord",
                    .template_variable_type_indep = NA_character_) |>



    tibble::add_row(.template_name = "cat_table_html",
                    .template =
                      "
::: {{#tbl-{.chunk_name}}}

```{{r}}
{.obj_name} <- \n\tmakeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}),  \n\tindep = c({.variable_name_indep}), \n\ttype = 'cat_prop_table_html')
nrange <- n_range(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\tindep = c({.variable_name_indep}))
link <- make_link(data={.obj_name})
gt::gt(ggobj = {.obj_name})
```

_{.variable_label_prefix_dep}_. N=`{{r}} nrange`. `{{r}} link`.

:::


",
                    .template_variable_type_dep = "fct;ord",
                    .template_variable_type_indep = "fct;ord") |>



    tibble::add_row(.template_name = "cat_table_html",
                    .template =
                      "
::: {{#tbl-{.chunk_name}}}

```{{r}}
{.obj_name} <- \n\tmakeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\ttype = 'cat_prop_table_html')
nrange <- n_range(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}))
link <- make_link(data={.obj_name})
gt::gt(ggobj = {.obj_name})
```

_{.variable_label_prefix_dep}_. N=`{{r}} nrange`. `{{r}} link`.

:::


",
                    .template_variable_type_dep = "fct;ord",
                    .template_variable_type_indep = NA_character_) |>


    tibble::add_row(.template_name = "chr_table",
                    .template =
                      "
::: {{#tbl-{.chunk_name}}}

```{{r}}
{.obj_name} <- \n\tmakeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\ttype = 'chr_table_html')
gt::gt({.obj_name})
```

_{.variable_label_prefix_dep}_.

:::


",
                    .template_variable_type_dep = "chr",
                    .template_variable_type_indep = NA_character_) #|>

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
    data.frame(.template_name = character(),
               .template = character(),
               .template_variable_type_dep = character(),
               .template_variable_type_indep = character()) |>
    tibble::add_row(.template_name = "cat_plot_html",
                    .template =
                      "
::: {{#fig-{.chunk_name}}}

```{{r}}
#| output: asis
#| panel: tabset
plots <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep}), \n\t\ttype='cat_plot_html', \n\t\tcrowd=c('target', 'others'), \n\t\tmesos_var = params$mesos_var, \n\t\tmesos_group = params$mesos_group)
if(!all(sapply(plots, is.null))) {{
lapply(names(plots), function(.x) {{
  knitr::knit_child(text = c(
    '##### `r .x`',
    '',
    '```{{r, fig.height = saros.contents::fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_y={.max_chars_dep}, n_x={.n_indep}, n_cats_x={.n_cats_indep}, max_chars_x={.max_chars_indep})}}',
    'library(ggplot2)',
    'library(ggiraph)',
    'library(saros.contents)',
    'nrange <- n_range2(plots[[.x]])',
    'link <- make_link(data = plots[[.x]]$data)',
    'link_plot <- make_link(data = plots[[.x]], link_prefix=\\'[PNG](\\', file_suffix = \\'.png\\', save_fn = ggsaver)',
    'x <- I(paste0(\\'N = \\', nrange, \\', \\', link, \\', \\', link_plot))',
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


",
                    .template_variable_type_dep = "fct;ord",
                    .template_variable_type_indep = "fct;ord") |>

    tibble::add_row(.template_name = "cat_plot_html",
                    .template =
                      "
::: {{#fig-{.chunk_name}}}

```{{r}}
#| output: asis
#| panel: tabset
plots <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\ttype='cat_plot_html', \n\tcrowd=c('target', 'others'), \n\tmesos_var = params$mesos_var, \n\tmesos_group = params$mesos_group)
if(!all(sapply(plots, is.null))) {{

lapply(names(plots), function(.x) {{
  knitr::knit_child(text = c(
    '##### `r .x`',
    '',
    '```{{r, fig.height = saros.contents::fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_y={.max_chars_dep})}}',
    'library(ggplot2)',
    'library(ggiraph)',
    'library(saros.contents)',
    'nrange <- n_range2(plots[[.x]])',
    'link <- make_link(data = plots[[.x]]$data)',
    'link_plot <- make_link(data = plots[[.x]], link_prefix=\\'[PNG](\\', file_suffix = \\'.png\\', save_fn = ggsaver)',
    'x <- I(paste0(\\'N = \\', nrange, \\', \\', link, \\', \\', link_plot))',
    'girafe(ggobj = plots[[.x]])',
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


",
                    .template_variable_type_dep = "fct;ord",
                    .template_variable_type_indep = NA_character_) |>


    tibble::add_row(.template_name = "cat_table_html",
                    .template =
                      "
::: {{#fig-{.chunk_name}}}

```{{r}}
#| output: asis
#| panel: tabset
tbls <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep}), \n\t\ttype='cat_table_html', \n\t\tcrowd=c('target', 'others'), \n\t\tmesos_var = params$mesos_var, \n\t\tmesos_group = params$mesos_group)
if(!all(sapply(tbls, is.null))) {{

lapply(names(tbls), function(.x) {{
  knitr::knit_child(text = c(
    '##### `r .x`',
    '',
    '```{{r}}',
    'library(gt)',
    'library(saros.contents)',
    'nrange <- n_range(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep}))',
    'link <- make_link(data = tbls[[.x]])',
    'x <- I(paste0(\\'N = \\', nrange, \\', \\', link, \\', \\', link_plot))',
    'gt(ggobj = tbls[[.x]])',
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


",
                    .template_variable_type_dep = "fct;ord",
                    .template_variable_type_indep = "fct;ord") |>

    tibble::add_row(.template_name = "cat_table_html",
                    .template =
                      "
::: {{#fig-{.chunk_name}}}

```{{r}}
#| output: asis
#| panel: tabset
tbls <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\ttype='cat_table_html', \n\t\tcrowd=c('target', 'others'), \n\t\tmesos_var = params$mesos_var, \n\t\tmesos_group = params$mesos_group)
if(!all(sapply(tbls, is.null))) {{

lapply(names(tbls), function(.x) {{
  knitr::knit_child(text = c(
    '##### `r .x`',
    '',
    '```{{r}}',
    'library(gt)',
    'library(saros.contents)',
    'nrange <- n_range(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep})',
    'link <- make_link(data = tbls[[.x]])',
    'x <- I(paste0(\\'N = \\', nrange, \\', \\', link, \\', \\', link_plot))',
    'gt(ggobj = tbls[[.x]])',
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


",
                    .template_variable_type_dep = "fct;ord",
                    .template_variable_type_indep = NA_character_) |>

    tibble::add_row(.template_name = "chr_table",
                    .template =
                      "
::: {{#tbl-{.chunk_name}}}

```{{r}}
{.obj_name} <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\ttype = 'chr_table_html', \n\tcrowd=c('target'), \n\tmesos_var = 'f_uni', \n\tmesos_group = params$mesos_group)
gt::gt({.obj_name})
```

_{.variable_label_prefix_dep}_ for `{{r}} params$mesos_group`.

:::


",
                    .template_variable_type_dep = "chr",
                    .template_variable_type_indep = NA_character_)

##################################################################################################################################
  # For crowd = c("target", "others") when ggiraph has limitations in loops: manual solution
  .saros.env$default_chunk_templates_3 <<-
    data.frame(.template_name = character(),
               .template = character(),
               .template_variable_type_dep = character(),
               .template_variable_type_indep = character()) |>
    tibble::add_row(.template_name = "cat_plot_html",
                    .template =
                      "
::: {{.panel-tabset}}

## Target

::: {{#fig-{.chunk_name}-target}}

```{{r}}
#| fig-height: !expr saros.contents::fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_y={.max_chars_dep}, n_x={.n_indep}, n_cats_x={.n_cats_indep}, max_chars_x={.max_chars_indep})
x <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep}), \n\t\ttype='cat_plot_html', \n\t\tcrowd='target', \n\t\tmesos_var = params$mesos_var, \n\t\tmesos_group = params$mesos_group)
nrange <- saros.contents::n_range(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep}))
link <- saros.contents::make_link(data = {.obj_name}$data)
link_plot <- saros.contents::make_link(data = {.obj_name}, link_prefix='[PNG](', save_fn = ggsaver)
caption <-  I(paste0('N=', nrange, ', ', link, ', ', link_plot))
ggiraph::girafe(ggobj = x)
```

_{.variable_label_prefix_dep}_ by _{tolower(.variable_label_prefix_indep)}_ for _`{{r}} params$mesos_group}}`_. `{{r}} caption`.

:::


## Others

::: {{#fig-{.chunk_name}-others}}

```{{r}}
#| fig-height: !expr saros.contents::fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_y={.max_chars_dep}, n_x={.n_indep}, n_cats_x={.n_cats_indep}, max_chars_x={.max_chars_indep})
x <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep}), \n\t\ttype='cat_plot_html', \n\t\tcrowd='others', \n\t\tmesos_var = params$mesos_var, \n\t\tmesos_group = params$mesos_group)
nrange <- saros.contents::n_range(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep}))
link <- saros.contents::make_link(data = {.obj_name}$data)
link_plot <- saros.contents::make_link(data = {.obj_name}, link_prefix='[PNG](', save_fn = ggsaver)
caption <-  I(paste0('N=', nrange, ', ', link, ', ', link_plot))
ggiraph::girafe(ggobj = x)

```

_{.variable_label_prefix_dep}_ by _{tolower(.variable_label_prefix_indep)}_ for _others_. `{{r}} caption`.

:::
:::


",
                    .template_variable_type_dep = "fct;ord",
                    .template_variable_type_indep = "fct;ord") |>

    tibble::add_row(.template_name = "cat_plot_html",
                    .template =
                      "
::: {{.panel-tabset}}

## Target

::: {{#fig-{.chunk_name}-target}}

```{{r}}
#| fig-height: !expr saros.contents::fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_y={.max_chars_dep})
x <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\ttype='cat_plot_html', \n\tcrowd='target', \n\tmesos_var = 'f_uni', \n\tmesos_group = params$mesos_group)
nrange <- saros.contents::n_range(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}))
link <- saros.contents::make_link(data = {.obj_name}$data)
link_plot <- saros.contents::make_link(data = {.obj_name}, link_prefix='[PNG](', save_fn = ggsaver)
caption <-  paste0('N=', nrange, ', ', link, ', ', link_plot)
ggiraph::girafe(ggobj = x)
```

_{.variable_label_prefix_dep}_ by _{tolower(.variable_label_prefix_indep)}_ for _`{{r}} params$mesos_group}}`_. `{{r}} caption`.

:::


## Others

::: {{#fig-{.chunk_name}-others}}

```{{r}}
#| fig-height: !expr saros.contents::fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_y={.max_chars_dep})
x <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\ttype='cat_plot_html', \n\t\tcrowd='others', \n\t\tmesos_var = params$mesos_var, \n\t\tmesos_group = params$mesos_group)
nrange <- saros.contents::n_range(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}))
link <- saros.contents::make_link(data = {.obj_name}$data)
link_plot <- saros.contents::make_link(data = {.obj_name}, link_prefix='[PNG](', save_fn = ggsaver)
caption <-  paste0('N=', nrange, ', ', link, ', ', link_plot)
ggiraph::girafe(ggobj = x)

```

_{.variable_label_prefix_dep}_ by _{tolower(.variable_label_prefix_indep)}_ for _others_. `{{r}} caption`.

:::
:::


",
                    .template_variable_type_dep = "fct;ord",
                    .template_variable_type_indep = NA_character_) |>

    tibble::add_row(.template_name = "cat_table_html",
                    .template =
                      "
::: {{.panel-tabset}}

## Target

::: {{#fig-{.chunk_name}-target}}

```{{r}}
x <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep}), \n\t\ttype='cat_table_html', \n\t\tcrowd='target', \n\t\tmesos_var = params$mesos_var, \n\t\tmesos_group = params$mesos_group)
nrange <- saros.contents::n_range(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep}))
caption <- I(paste0('N=', nrange))
gt::gt(ggobj = x)
```

_{.variable_label_prefix_dep}_ for _`{{r}} params$mesos_group}}`_. `{{r}} caption`.

:::


## Others

::: {{#fig-{.chunk_name}-others}}

```{{r}}
x <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep}), \n\t\ttype='cat_table_html', \n\tcrowd='others', \n\t\tmesos_var = params$mesos_var, \n\t\tmesos_group = params$mesos_group)
nrange <- saros.contents::n_range(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\t\tindep = c({.variable_name_indep}))
caption <-  I(paste0('N=', nrange))
gt::gt(ggobj = x)

```

_{.variable_label_prefix_dep}_ for _others_. `{{r}} caption`.

:::
:::


",
                    .template_variable_type_dep = "fct;ord",
                    .template_variable_type_indep = "fct;ord") |>


    tibble::add_row(.template_name = "cat_table_html",
                    .template =
                      "
::: {{.panel-tabset}}

## Target

::: {{#fig-{.chunk_name}-target}}

```{{r}}
x <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\ttype='cat_table_html', \n\t\tcrowd='target', \n\t\tmesos_var = params$mesos_var, \n\t\tmesos_group = params$mesos_group)
nrange <- saros.contents::n_range(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}))
caption <- I(paste0('N=', nrange))
gt::gt(ggobj = x)
```

_{.variable_label_prefix_dep}_ for _`{{r}} params$mesos_group}}`_. `{{r}} caption`.

:::


## Others

::: {{#fig-{.chunk_name}-others}}

```{{r}}
x <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\ttype='cat_table_html', \n\tcrowd='others', \n\t\tmesos_var = params$mesos_var, \n\t\tmesos_group = params$mesos_group)
nrange <- saros.contents::n_range(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}))
caption <-  I(paste0('N=', nrange))
gt::gt(ggobj = x)

```

_{.variable_label_prefix_dep}_ for _others_. `{{r}} caption`.

:::
:::

",
                    .template_variable_type_dep = "fct;ord",
                    .template_variable_type_indep = NA_character_) |>



    tibble::add_row(.template_name = "chr_table",
                    .template =
                      "
::: {{#tbl-{.chunk_name}-target}}

```{{r}}
{.obj_name} <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\t\tdep = c({.variable_name_dep}), \n\t\ttype = 'chr_table_html', \n\t\tcrowd='target', \n\t\tmesos_var = params$mesos_group, \n\t\tmesos_group = params$mesos_group)
gt::gt({.obj_name})
```

_{.variable_label_prefix_dep}_ for `{{r}} params$mesos_group`.

:::


",
                    .template_variable_type_dep = "chr",
                    .template_variable_type_indep = NA_character_)

}
