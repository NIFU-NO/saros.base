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


  .saros.env$ignore_args <<- c("data", "chapter_overview", "chapter_structure", "path", "...")





  .saros.env$default_chunk_templates <<-
    data.frame(.template_name = "bi_catcat_prop_plot",
               .template =
                 "
``````{{r}}
#| label: 'fig-{.chunk_name}'
#| fig-cap: '_{.variable_label_prefix_dep}_ by _{tolower(.variable_label_prefix_indep)}_. N={.n_range}. [xlsx]({.chapter_foldername}/{.file_name}.xlsx).'
#| fig-height: !expr fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_y={.max_chars_dep}, n_x={.n_indep}, n_cats_x={.n_cats_indep}, max_chars_x={.max_chars_indep})
{.obj_name} <- \n\tsaros.contents::sarosmake(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\tindep = c({.variable_name_indep}), \n\ttype='cat_prop_plot_html')
girafe(ggobj = {.obj_name})
``````

",
               .template_variable_type_dep = c("fct;ord"),
               .template_variable_type_indep = c("fct;ord")) |>

    tibble::add_row(.template_name = "uni_cat_prop_plot",
                    .template =
                      "
``````{{r}}
#| label: 'fig-{.chunk_name}'
#| fig-cap: '_{.variable_label_prefix_dep}_. N={.n_range}. [xlsx]({.chapter_foldername}/{.file_name}.xlsx).'
#| fig-height: !expr fig_height_h_barchart(n_y={.n_dep}, n_cats_y={.n_cats_dep}, max_chars_y={.max_chars_dep})
{.obj_name} <- \n\tsaros.contents::sarosmake(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\ttype = 'cat_prop_plot_html')
girafe(ggobj = {.obj_name})
``````

",
                    .template_variable_type_dep = c("fct;ord"),
                    .template_variable_type_indep = NA) |>
    tibble::add_row(.template_name = "uni_cat_prop_table",
                    .template =
                      "
``````{{r}}
#| label: 'tbl-{.chunk_name}'
#| tbl-cap: '_{.variable_label_prefix_dep}_. N={.n_range}.'
{.obj_name} <- \n\tsaros.contents::sarosmake(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\ttype = 'cat_prop_table_html')
gt(ggobj = {.obj_name})
``````

",
                    .template_variable_type_dep = c("fct;ord"),
                    .template_variable_type_indep = NA) |>
    tibble::add_row(.template_name = "uni_chr_table",
                    .template =
                      "
``````{{r}}
#| label: 'tbl-{.chunk_name}'
#| tbl-cap: '_{.variable_label_prefix_dep}_. N={.n_range}.'
{.obj_name} <- \n\tsaros.contents::sarosmake(data = data_{.chapter_foldername}, \n\tdep = c({.variable_name_dep}), \n\ttype = 'chr_table_html')
gt({.obj_name})
``````

",
                    .template_variable_type_dep = c("chr"),
                    .template_variable_type_indep = NA)

}
