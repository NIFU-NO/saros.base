# Get Core Chapter Structure Column Names

Returns the vector of core column names available as organize_by
options.

## Usage

``` r
get_organize_by_opts()
```

## Value

A character vector.

## Examples

``` r
get_organize_by_opts()
#>  [1] "chapter"                      ".variable_role_dep"          
#>  [3] ".variable_selection_dep"      ".variable_position_dep"      
#>  [5] ".variable_name_dep"           ".variable_name_prefix_dep"   
#>  [7] ".variable_name_suffix_dep"    ".variable_label_prefix_dep"  
#>  [9] ".variable_label_suffix_dep"   ".variable_type_dep"          
#> [11] ".variable_role_indep"         ".variable_selection_indep"   
#> [13] ".variable_position_indep"     ".variable_name_indep"        
#> [15] ".variable_name_prefix_indep"  ".variable_name_suffix_indep" 
#> [17] ".variable_label_prefix_indep" ".variable_label_suffix_indep"
#> [19] ".variable_type_indep"         ".bi_test"                    
#> [21] ".p_value"                     ".template_name"              
#> [23] ".template"                    ".variable_group_id"          
#> [25] ".n"                           ".n_range"                    
#> [27] ".n_cats_dep"                  ".max_chars_cats_dep"         
#> [29] ".max_chars_labels_dep"        ".n_dep"                      
#> [31] ".n_indep"                     ".obj_name"                   
#> [33] ".chunk_name"                  ".file_name"                  
#> [35] ".chapter_number"              ".chapter_foldername"         
```
