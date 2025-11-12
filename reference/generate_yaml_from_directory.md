# Generate YAML File from Directory Structure

Generate YAML File from Directory Structure

## Usage

``` r
generate_yaml_from_directory(
  input_path = tempdir(),
  output_yaml_path = "_project_structure_en.yaml",
  remove_prefix_numbers = FALSE
)
```

## Arguments

- input_path:

  String. The path to the directory whose structure needs to be
  captured.

- output_yaml_path:

  String. The path where the YAML file will be saved.

- remove_prefix_numbers:

  Boolean. Whether to remove numeric prefixes and any resulting leading
  non-alphanumeric characters from folder names. Defaults to FALSE.

## Value

No return value, called for side effects

## Examples

``` r
generate_yaml_from_directory(
  output_yaml_path =
    tempfile("_project_structure_en", fileext = ".yaml")
)
```
