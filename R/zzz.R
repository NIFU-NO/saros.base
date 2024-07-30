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
                               "chapter_overview",
                               "chapter_structure",
                               "call",
                               "...")





  .saros.env$default_chunk_templates_1 <<-
    data.frame(.template_name = character(),
               .template = character(),
               .template_variable_type_dep = character(),
               .template_variable_type_indep = character()) |>
    tibble::add_row(.template_name = "cat_prop_plot_html",
               .template =
                 "
::: {{#fig-{.chunk_name} }}

```{{r}}
#| fig-height: !expr fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_y={.max_chars_dep}, n_x={.n_indep}, n_cats_x={.n_cats_indep}, max_chars_x={.max_chars_indep})
{.obj_name} <- \n\tmakeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\tindep = c({.variable_name_indep}), \n\ttype='cat_prop_plot_html')
nrange <- n_range(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\tindep = c({.variable_name_indep}))
link <- make_link(data = {.obj_name}$data)
link_plot <- make_link(data = {.obj_name}, file_suffix='.png', link_prefix='[download PNG](', save_fn = ggsaver, width=12, height=12, units='cm')
girafe(ggobj = {.obj_name})
```

_{.variable_label_prefix_dep}_ by _{tolower(.variable_label_prefix_indep)}_. N=`{{r}} nrange`. `{{r}} link`. `{{r}} link_plot`.

:::
",
               .template_variable_type_dep = "fct;ord",
               .template_variable_type_indep = "fct;ord") |>

    tibble::add_row(.template_name = "cat_prop_plot_html",
                    .template =
                      "
::: {{#fig-{.chunk_name} }}

```{{r}}
#| fig-height: !expr fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_y={.max_chars_dep})
{.obj_name} <- \n\tmakeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\ttype = 'cat_prop_plot_html')
nrange <- n_range(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\tindep = c({.variable_name_indep}))
link <- make_link(data={.obj_name}$data)
link_plot <- make_link(data = {.obj_name}, file_suffix='.png', link_prefix='[download PNG](', save_fn = ggsaver, width=12, height=12, units='cm')
girafe(ggobj = {.obj_name})
```

_{.variable_label_prefix_dep}_. N=`{{r}} nrange`. `{{r}} link`. `{{r}} link_plot`.

:::

",
                    .template_variable_type_dep = "fct;ord",
                    .template_variable_type_indep = NA_character_) |>

    tibble::add_row(.template_name = "cat_table_html",
                    .template =
                      "
::: {{#tbl-{.chunk_name} }}

```{{r}}
{.obj_name} <- \n\tmakeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\ttype = 'cat_prop_table_html')
nrange <- n_range(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\tindep = c({.variable_name_indep}))
link <- make_link(data={.obj_name})
gt(ggobj = {.obj_name})
```

_{.variable_label_prefix_dep}_. N=`{{r}} nrange`. `{{r}} link`.

:::


",
                    .template_variable_type_dep = "fct;ord",
                    .template_variable_type_indep = NA_character_) |>

    tibble::add_row(.template_name = "chr_table",
                    .template =
                      "
::: {{#tbl-{.chunk_name} }}

```{{r}}
{.obj_name} <- \n\tmakeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\ttype = 'chr_table_html')
gt({.obj_name})
```

_{.variable_label_prefix_dep}_.

:::


",
                    .template_variable_type_dep = "chr",
                    .template_variable_type_indep = NA_character_) |>

    tibble::add_row(.template_name = "sigtest_table_html",
                    .template =
                      "
::: {{#tbl-{.chunk_name} }}

```{{r}}
{.obj_name} <- \n\tmakeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\tindep = c({.variable_name_indep}), \n\ttype = 'sigtest_table_html')
gt({.obj_name})
```

_Significance tests_.

:::


",
                    .template_variable_type_dep = "fct;ord;int;dbl",
                    .template_variable_type_indep = "fct;ord;int;dbl")



  .saros.env$default_chunk_templates_2 <<-
    data.frame(.template_name = character(),
               .template = character(),
               .template_variable_type_dep = character(),
               .template_variable_type_indep = character()) |>
    tibble::add_row(.template_name = "cat_prop_plot_html",
                    .template =
                      "
::: {{#fig-{.chunk_name} }}

```{{r}}
#| fig-height: !expr saros.contents::fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_y={.max_chars_dep}, n_x={.n_indep}, n_cats_x={.n_cats_indep}, max_chars_x={.max_chars_indep})
{.obj_name} <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\tindep = c({.variable_name_indep}), \n\ttype='cat_prop_plot_html', \n\tcrowd=c('target', 'others'), \n\tmesos_var = 'f_uni', \n\tmesos_group = params$mesos_group)
captions <- purrr::map2_chr(seq_along({.obj_name}), .fn = {
\t  nrange <- saros.contents::n_range(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\tindep = c({.variable_name_indep}))
\t  link <- saros.contents::make_link(data = .x$data)
\t  link_plot <- saros.contents::make_link(data = .x, link_prefix='[download PNG](', save_fn = ggsaver)
\t  paste0('N=', nrange, ', ', link, ', ', link_plot)
}) |> paste0(collapse = '; ')
purrr::walk({.obj_name}, ~ggiraph::girafe(ggobj = .x))
```

_{.variable_label_prefix_dep}_ by _{tolower(.variable_label_prefix_indep)}_. `{{r}} captions`.

:::
",
                    .template_variable_type_dep = "fct;ord",
                    .template_variable_type_indep = "fct;ord") |>

    tibble::add_row(.template_name = "cat_prop_plot_html",
                    .template =
                      "
::: {{#fig-{.chunk_name} }}

```{{r}}
#| fig-height: !expr fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_y={.max_chars_dep})
{.obj_name} <- \n\tmakeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\ttype = 'cat_prop_plot_html', \n\tcrowd=c('target', 'others'), \n\tmesos_var = 'f_uni', \n\tmesos_group = params$mesos_group)
captions <- purrr::map2_chr(seq_along({.obj_name}), .fn = {
\t  nrange <- saros.contents::n_range(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}))
\t  link <- saros.contents::make_link(data = .x$data)
\t  link_plot <- saros.contents::make_link(data = .x, link_prefix='[download PNG](', save_fn = ggsaver)
\t  paste0('N=', nrange, ', ', link, ', ', link_plot)
}) |> paste0(collapse = '; ')
purrr::walk({.obj_name}, ~ggiraph::girafe(ggobj = .x))
```

_{.variable_label_prefix_dep}_. `{{r}} captions`.
:::

",
                    .template_variable_type_dep = "fct;ord",
                    .template_variable_type_indep = NA_character_) |>

    tibble::add_row(.template_name = "cat_table_html",
                    .template =
                      "
::: {{#tbl-{.chunk_name} }}

```{{r}}
{.obj_name} <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\ttype = 'cat_prop_table_html', \n\tcrowd=c('target', 'others'), \n\tmesos_var = 'f_uni', \n\tmesos_group = params$mesos_group)
captions <- purrr::map2_chr(seq_along({.obj_name}), .fn = {
\t  nrange <- saros.contents::n_range(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}))
\t  link <- saros.contents::make_link(data = .x$data)
\t  link_plot <- saros.contents::make_link(data = .x, link_prefix='[download PNG](', save_fn = ggsaver)
\t  paste0('N=', nrange, ', ', link, ', ', link_plot)
}) |> paste0(collapse = '; ')
purrr::walk({.obj_name}, ~gt::gt(ggobj = .x))
```

_{.variable_label_prefix_dep}_. N=`{{r}} nrange`. `{{r}} link`.

:::


",
                    .template_variable_type_dep = "fct;ord",
                    .template_variable_type_indep = NA_character_) |>

    tibble::add_row(.template_name = "chr_table",
                    .template =
                      "
::: {{#tbl-{.chunk_name} }}

```{{r}}
{.obj_name} <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\ttype = 'chr_table_html', \n\tcrowd=c('target'), \n\tmesos_var = 'f_uni', \n\tmesos_group = params$mesos_group)
gt::gt({.obj_name})
```

_{.variable_label_prefix_dep}_.

:::


",
                    .template_variable_type_dep = "chr",
                    .template_variable_type_indep = NA_character_)

##################################################################################################################################
  # For crowd = c("target", "others") when ggiraph has limitations in loops
  .saros.env$default_chunk_templates_3 <<-
    data.frame(.template_name = character(),
               .template = character(),
               .template_variable_type_dep = character(),
               .template_variable_type_indep = character()) |>
    tibble::add_row(.template_name = "cat_prop_plot_html",
                    .template =
                      "
::: {{.panel-tabset}}

## Target

::: {{#fig-{.chunk_name}-target }}

```{{r}}
#| fig-height: !expr saros.contents::fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_y={.max_chars_dep}, n_x={.n_indep}, n_cats_x={.n_cats_indep}, max_chars_x={.max_chars_indep})
x <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\tindep = c({.variable_name_indep}), \n\ttype='cat_prop_plot_html', \n\tcrowd='target', \n\tmesos_var = 'f_uni', \n\tmesos_group = params$mesos_group)
nrange <- saros.contents::n_range(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\tindep = c({.variable_name_indep}))
link <- saros.contents::make_link(data = {.obj_name}$data)
link_plot <- saros.contents::make_link(data = {.obj_name}, link_prefix='[download PNG](', save_fn = ggsaver)
caption <-  I(paste0('N=', nrange, ', ', link, ', ', link_plot))
ggiraph::girafe(ggobj = x)
```

_{.variable_label_prefix_dep}_ by _{tolower(.variable_label_prefix_indep)}_ for _`{{r}} params$mesos_group}}`_. `{{r}} caption`.

:::


## Others

::: {{#fig-{.chunk_name} }}

```{{r}}
#| fig-height: !expr saros.contents::fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_y={.max_chars_dep}, n_x={.n_indep}, n_cats_x={.n_cats_indep}, max_chars_x={.max_chars_indep})
x <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\tindep = c({.variable_name_indep}), \n\ttype='cat_prop_plot_html', \n\tcrowd='others', \n\tmesos_var = 'f_uni', \n\tmesos_group = params$mesos_group)
nrange <- saros.contents::n_range(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\tindep = c({.variable_name_indep}))
link <- saros.contents::make_link(data = {.obj_name}$data)
link_plot <- saros.contents::make_link(data = {.obj_name}, link_prefix='[download PNG](', save_fn = ggsaver)
caption <-  I(paste0('N=', nrange, ', ', link, ', ', link_plot))
ggiraph::girafe(ggobj = x)

```

_{.variable_label_prefix_dep}_ by _{tolower(.variable_label_prefix_indep)}_ for _others_. `{{r}} caption`.

:::
:::
",
                    .template_variable_type_dep = "fct;ord",
                    .template_variable_type_indep = "fct;ord") |>

    tibble::add_row(.template_name = "cat_prop_plot_html",
                    .template =
                      "
::: {{.panel-tabset}}

## Target

::: {{#fig-{.chunk_name}-target }}

```{{r}}
#| fig-height: !expr saros.contents::fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_y={.max_chars_dep}, n_x={.n_indep}, n_cats_x={.n_cats_indep}, max_chars_x={.max_chars_indep})
x <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\ttype='cat_prop_plot_html', \n\tcrowd='target', \n\tmesos_var = 'f_uni', \n\tmesos_group = params$mesos_group)
nrange <- saros.contents::n_range(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}))
link <- saros.contents::make_link(data = {.obj_name}$data)
link_plot <- saros.contents::make_link(data = {.obj_name}, link_prefix='[download PNG](', save_fn = ggsaver)
caption <-  paste0('N=', nrange, ', ', link, ', ', link_plot)
ggiraph::girafe(ggobj = x)
```

_{.variable_label_prefix_dep}_ for _`{{r}} params$mesos_group}}`_. `{{r}} caption`.

:::


## Others

::: {{#fig-{.chunk_name} }}

```{{r}}
#| fig-height: !expr saros.contents::fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_y={.max_chars_dep}, n_x={.n_indep}, n_cats_x={.n_cats_indep}, max_chars_x={.max_chars_indep})
x <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\ttype='cat_prop_plot_html', \n\tcrowd='others', \n\tmesos_var = 'f_uni', \n\tmesos_group = params$mesos_group)
nrange <- saros.contents::n_range(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}))
link <- saros.contents::make_link(data = {.obj_name}$data)
link_plot <- saros.contents::make_link(data = {.obj_name}, link_prefix='[download PNG](', save_fn = ggsaver)
caption <-  paste0('N=', nrange, ', ', link, ', ', link_plot)
ggiraph::girafe(ggobj = x)

```

_{.variable_label_prefix_dep}_ for _others_. `{{r}} caption`.

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

::: {{#fig-{.chunk_name}-target }}

```{{r}}
#| fig-height: !expr saros.contents::fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_y={.max_chars_dep}, n_x={.n_indep}, n_cats_x={.n_cats_indep}, max_chars_x={.max_chars_indep})
x <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\ttype='cat_table_html', \n\tcrowd='target', \n\tmesos_var = 'f_uni', \n\tmesos_group = params$mesos_group)
nrange <- saros.contents::n_range(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}))
caption <-  paste0('N=', nrange)
gt::gt(ggobj = x)
```

_{.variable_label_prefix_dep}_ for _`{{r}} params$mesos_group}}`_. `{{r}} caption`.

:::


## Others

::: {{#fig-{.chunk_name} }}

```{{r}}
#| fig-height: !expr saros.contents::fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_y={.max_chars_dep}, n_x={.n_indep}, n_cats_x={.n_cats_indep}, max_chars_x={.max_chars_indep})
x <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\ttype='cat_table_html', \n\tcrowd='others', \n\tmesos_var = 'f_uni', \n\tmesos_group = params$mesos_group)
nrange <- saros.contents::n_range(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}))
caption <-  paste0('N=', nrange)
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
::: {{#tbl-{.chunk_name} }}

```{{r}}
{.obj_name} <- \n\tsaros.contents::makeme(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\ttype = 'chr_table_html', \n\tcrowd='target', \n\tmesos_var = 'f_uni', \n\tmesos_group = params$mesos_group)
gt::gt({.obj_name})
```

_{.variable_label_prefix_dep}_.

:::


",
                    .template_variable_type_dep = "chr",
                    .template_variable_type_indep = NA_character_)

}
