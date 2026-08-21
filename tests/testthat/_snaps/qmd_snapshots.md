# the set of generated files is stable

    Code
      cat(relative_files(path), sep = "\n")
    Output
      1_Trivsel.qmd
      1_Trivsel/data_1_Trivsel.rds
      2_Bakgrunn.qmd
      2_Bakgrunn/data_2_Bakgrunn.rds
      index.qmd
      report.qmd

# index.qmd and report.qmd carry the report title

    Code
      print_file(path, "index.qmd")
    Output
      == index.qmd ==
      ---
      title: Eksempelrapport
      format: html
      echo: false
      fig-dpi: 800.0
      
      ---
      
      
    Code
      print_file(path, "report.qmd")
    Output
      == report.qmd ==
      ---
      title: Eksempelrapport
      format: html
      echo: false
      fig-dpi: 800.0
      
      ---
      
      

# a whole chapter file is stable

    Code
      print_file(path, "1_Bakgrunn.qmd")
    Output
      == 1_Bakgrunn.qmd ==
      ---
      title: Bakgrunn
      format: html
      echo: false
      fig-dpi: 800.0
      number-offset: 0.0
      
      ---
      # Bakgrunn
      ```{r}
      #| label: 'Setup for 1_Bakgrunn'
      #| include: false
      library(saros)
      library(gt)
      ```
      ```{r}
      #| label: 'Import data for 1_Bakgrunn'
      data_1_Bakgrunn <- readRDS('1_Bakgrunn/data_1_Bakgrunn.rds')
      ```
      
      ## Gender{#sec-Gender-3314e4}
      
      
      ::: {#fig-x1-sex-cat-plot-html}
      
      ```{r, fig.height=saros::fig_height_h_barchart(n_y=1, n_cats_y=2, max_chars_labels_y=6, max_chars_cats_y=7)}
      x1_sex_cat_plot_html <- 
      	data_1_Bakgrunn |>
      		saros::makeme(dep = c(x1_sex), 
      		type = 'cat_plot_html')
      nrange <- stringi::stri_c('N = ', saros::n_range2(x1_sex_cat_plot_html))
      link <- saros::make_link(data = x1_sex_cat_plot_html$data)
      link_plot <- saros::make_link(data = x1_sex_cat_plot_html, 
      		file_suffix = '.png', link_prefix='[PNG](', 
      		save_fn = saros::ggsaver)
      x <- I(paste0(c(nrange, link, link_plot), collapse=', '))
      saros::girafe(ggobj = x1_sex_cat_plot_html)
      ```
      
      _Gender_. `{r} x`.
      
      :::
      
      
      ::: {#tbl-x1-sex-cat-table-html}
      
      ```{r}
      x1_sex_cat_table_html <- 
      	data_1_Bakgrunn |>
      		saros::makeme(dep = c(x1_sex), 
      		type = 'cat_table_html')
      nrange <- stringi::stri_c('N = ', saros::n_range(data = data_1_Bakgrunn, 
      		dep = c(x1_sex)))
      link <- saros::make_link(data=x1_sex_cat_table_html)
      x <- I(paste0(c(nrange, link), collapse=', '))
      gt::gt(x1_sex_cat_table_html)
      ```
      
      _Gender_. N=`{r} x`.
      
      :::
      
      

# chapter structure -- headings, anchors and float ids

    Code
      skeleton(path, "1_Trivsel.qmd")
    Output
      == 1_Trivsel.qmd ==
      ---
      title: Trivsel
      format: html
      echo: false
      fig-dpi: 800.0
      number-offset: 0.0
      
      ---
      # Trivsel
      ## Do you consent to the following?{#sec-Do-you-consent-to-the-following-f0e1a9}
      ::: {#fig-a-cat-plot-html}
      ::: {#tbl-a-cat-table-html}
      ### Gender{#sec-x1-sex-21446e}
      ::: {#fig-a-x1-sex-cat-plot-html}
      ::: {#tbl-a-x1-sex-cat-table-html}
      ## How much do you like living in{#sec-How-much-do-you-like-living-in-962a6c}
      ::: {#fig-b-1-cat-plot-html}
      ::: {#tbl-b-1-cat-table-html}
      ### Gender{#sec-x1-sex-3a2d01}
      ::: {#fig-b-1-x1-sex-cat-plot-html}
      ::: {#tbl-b-1-x1-sex-cat-table-html}
      
    Code
      skeleton(path, "2_Bakgrunn.qmd")
    Output
      == 2_Bakgrunn.qmd ==
      ---
      title: Bakgrunn
      format: html
      echo: false
      fig-dpi: 800.0
      number-offset: 1.0
      
      ---
      # Bakgrunn
      ## Gender{#sec-Gender-b4e6c9}
      ::: {#fig-x1-sex-cat-plot-html}
      ::: {#tbl-x1-sex-cat-table-html}
      

# variant 2 (tabset) output is stable -- univariate

    Code
      print_file(path, "1_Bakgrunn.qmd")
    Output
      == 1_Bakgrunn.qmd ==
      ---
      title: Bakgrunn
      format: html
      echo: false
      fig-dpi: 800.0
      number-offset: 0.0
      
      ---
      # Bakgrunn
      ```{r}
      #| label: 'Setup for 1_Bakgrunn'
      #| include: false
      library(saros)
      library(gt)
      ```
      ```{r}
      #| label: 'Import data for 1_Bakgrunn'
      data_1_Bakgrunn <- readRDS('1_Bakgrunn/data_1_Bakgrunn.rds')
      ```
      
      ## Gender{#sec-Gender-3314e4}
      
      
      ::: {#fig-x1-sex-cat-plot-html}
      
      ```{r}
      #| output: asis
      #| panel: tabset
      plots <- 
      	saros::makeme(data = data_1_Bakgrunn, 
      		dep = c(x1_sex), 
      		type='cat_plot_html', 
      		crowd=c('target', 'others'), 
      		mesos_var = params$mesos_var, 
      		mesos_group = params$mesos_group)
      
      if(!all(vapply(plots, is.null, logical(1)))) {
      
        lapply(names(plots), function(.x) {
          knitr::knit_child(text = c(
            '',
            '',
            '##### `r .x`',
            '',
            '',
            '```{r}',
            'library(saros)',
            'knitr::opts_template$set(fig = list(fig.height = saros::fig_height_h_barchart2(plots[[.x]])))',
            '',
            '```',
            '',
            '```{r, opts.label=\'fig\'}',
            'library(ggplot2)',
            'library(ggiraph)',
            'nrange <- stringi::stri_c(\'N = \', saros::n_range2(plots[[.x]]))',
            'link <- saros::make_link(data = plots[[.x]]$data)',
            'link_plot <- saros::make_link(data = plots[[.x]], link_prefix=\'[PNG](\', file_suffix = \'.png\', save_fn = saros::ggsaver)',
            'x <- I(paste0(c(nrange, link, link_plot), collapse=\', \'))',
            'saros::girafe(ggobj = plots[[.x]])',
            '```',
            '',
            '`r x`'
            ), envir = environment(), quiet = TRUE)
        }) |> unlist() |> cat(sep = '\n')
      }
      ```
      
      _Gender_.
      
      :::
      
      
      ::: {#tbl-x1-sex-cat-table-html}
      
      ```{r}
      #| output: asis
      #| panel: tabset
      tbls <- 
      	saros::makeme(data = data_1_Bakgrunn, 
      		dep = c(x1_sex), 
      		type='cat_table_html', 
      		crowd=c('target', 'others'), 
      		mesos_var = params$mesos_var, 
      		mesos_group = params$mesos_group)
      if(!all(vapply(tbls, is.null, logical(1)))) {
      
      lapply(names(tbls), function(.x) {
        knitr::knit_child(text = c(
            '',
            '',
          '##### `r .x`',
          '',
          '```{r}',
          'library(gt)',
          'library(saros)',
          'nrange <- stringi::stri_c(\'N = \', saros::n_range(data = data_1_Bakgrunn, 
      		dep = c(x1_sex)))',
          'link <- saros::make_link(data = tbls[[.x]])',
          'x <- I(paste0(c(nrange, link), collapse=\', \'))',
          'gt::gt(tbls[[.x]])',
          '```',
          '',
          '`r x`',
          ''
          ), envir = environment(), quiet = TRUE)
      }) |> unlist() |> cat(sep = '\n')
      }
      ```
      
      _Gender_.
      
      :::
      
      

# variant 2 (tabset) output is stable -- bivariate

    Code
      skeleton(path, "1_Trivsel.qmd")
    Output
      == 1_Trivsel.qmd ==
      ---
      title: Trivsel
      format: html
      echo: false
      fig-dpi: 800.0
      number-offset: 0.0
      
      ---
      # Trivsel
      ## Do you consent to the following?{#sec-Do-you-consent-to-the-following-f0e1a9}
      ::: {#fig-a-cat-plot-html}
      ::: {#tbl-a-cat-table-html}
      ### Gender{#sec-x1-sex-21446e}
      ::: {#fig-a-x1-sex-cat-plot-html}
      ::: {#tbl-a-x1-sex-cat-table-html}
      ## How much do you like living in{#sec-How-much-do-you-like-living-in-962a6c}
      ::: {#fig-b-1-cat-plot-html}
      ::: {#tbl-b-1-cat-table-html}
      ### Gender{#sec-x1-sex-3a2d01}
      ::: {#fig-b-1-x1-sex-cat-plot-html}
      ::: {#tbl-b-1-x1-sex-cat-table-html}
      
    Code
      skeleton(path, "2_Bakgrunn.qmd")
    Output
      == 2_Bakgrunn.qmd ==
      ---
      title: Bakgrunn
      format: html
      echo: false
      fig-dpi: 800.0
      number-offset: 1.0
      
      ---
      # Bakgrunn
      ## Gender{#sec-Gender-b4e6c9}
      ::: {#fig-x1-sex-cat-plot-html}
      ::: {#tbl-x1-sex-cat-table-html}
      

# headings are whitespace-normalised with a bare separator

    Code
      cat(headings, sep = "\n")
    Output
      # Trivsel
      ## Do you consent to the following?{#sec-Do-you-consent-to-the-following-f0e1a9}
      ### Agreement #1{#sec-Agreement-1-713dfd}
      #### Gender{#sec-x1-sex-0cf217}
      ### Agreement #2{#sec-Agreement-2-3bee20}
      #### Gender{#sec-x1-sex-42cd8b}
      ## How much do you like living in{#sec-How-much-do-you-like-living-in-962a6c}
      ### Bejing{#sec-Bejing-211e6f}
      #### Gender{#sec-x1-sex-19c095}
      # Bakgrunn
      ## Gender{#sec-Gender-b4e6c9}
      ### Gender{#sec-Gender-740b46}

# the numeric chapter is stable -- variants 1 and 5

    Code
      cat("---- variant 1 (default) ----\n")
    Output
      ---- variant 1 (default) ----
    Code
      print_file(default_variant, "1_Num.qmd")
    Output
      == 1_Num.qmd ==
      ---
      title: Num
      format: html
      echo: false
      fig-dpi: 800.0
      number-offset: 0.0
      
      ---
      # Num
      ```{r}
      #| label: 'Setup for 1_Num'
      #| include: false
      library(saros)
      library(gt)
      ```
      ```{r}
      #| label: 'Import data for 1_Num'
      data_1_Num <- readRDS('1_Num/data_1_Num.rds')
      ```
      
      ## How many years of experience do you have in{#sec-How-many-years-of-experience-do-you-have-in-9c9145}
      
      
      ::: {#tbl-c-int-table-html}
      
      ```{r}
      c_int_table_html <- 
      	data_1_Num |>
      		saros::makeme(dep = c(c_1,c_2), 
      		type = 'int_table_html')
      link <- saros::make_link(data = c_int_table_html)
      x <- I(link)
      gt::gt(c_int_table_html)
      ```
      
      _How many years of experience do you have in_. `{r} x`.
      
      :::
      
      
    Code
      cat("---- variant 5 ----\n")
    Output
      ---- variant 5 ----
    Code
      print_file(variant_5, "1_Num.qmd")
    Output
      == 1_Num.qmd ==
      ---
      title: Num
      format: html
      echo: false
      fig-dpi: 800.0
      number-offset: 0.0
      
      ---
      # Num
      ```{r}
      #| label: 'Setup for 1_Num'
      #| include: false
      library(saros)
      library(gt)
      ```
      ```{r}
      #| label: 'Import data for 1_Num'
      data_1_Num <- readRDS('1_Num/data_1_Num.rds')
      ```
      
      ## How many years of experience do you have in{#sec-How-many-years-of-experience-do-you-have-in-9c9145}
      
      
      ::: {#fig-c-int-plot-html}
      
      ```{r}
      plot <- 
      	data_1_Num |>
      		saros::makeme(dep = c(c_1,c_2), 
      		type = 'int_plot_html')
      x <- saros::get_fig_title_suffix_from_ggplot(plot, save = parameters$save)
      saros::girafe(ggobj = plot)
      ```
      
      _How many years of experience do you have in_. `{r} x`.
      
      :::
      
      

