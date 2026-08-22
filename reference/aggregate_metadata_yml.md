# Aggregate the `_metadata.yml` Inheritance Chain

Collects every `_metadata.yml` from the Quarto project root down to
`path` and merges them, so that a deeper folder overrides a shallower
one. This is the inheritance chain
[`setup_mesos()`](https://nifu-no.github.io/saros.base/reference/setup_mesos.md)
writes — project, then wave, then chapter — and the mechanism behind the
`parameters` object that generated chapters use.

Quarto's own `params` cannot provide this: it resolves to the individual
`.qmd` file's YAML and carries no inheritance.

## Usage

``` r
aggregate_metadata_yml(path = ".")
```

## Arguments

- path:

  *Folder to resolve the chain for*

  `scalar<character>` // *default:* `"."` (`optional`)

  The folder to treat as the deepest level of the chain, normally the
  one holding the `.qmd` being rendered. The default is correct at
  render time: Quarto executes a document with the working directory set
  to that document's own folder unless the project sets
  `execute-dir: project`.

## Value

A named `list` of the merged YAML, empty if nothing was found. The
`params` element is the part generated chapters use.

## Details

The walk is bounded by the Quarto project root — the nearest ancestor of
`path` holding a `_quarto.yml` or a `_quarto.yaml`. A `_metadata.yml`
above that root is not read. When no project file is found anywhere
above `path`, only `path` itself is read, so the walk can never escape
into unrelated folders.

A folder without a `_metadata.yml` does not end the walk; it simply
contributes nothing. Neither does an empty or non-mapping one, which is
what
[`setup_mesos()`](https://nifu-no.github.io/saros.base/reference/setup_mesos.md)
writes at intermediate levels.

Both `_metadata.yml` and `_metadata.yaml` are read. In the unlikely
event that one folder holds both, `_metadata.yml` is merged first, so
`_metadata.yaml` wins.

Merging is
[`utils::modifyList()`](https://rdrr.io/r/utils/modifyList.html), which
descends into nested lists: a deeper folder overriding
`params$mesos_group` leaves its siblings under `params` intact.

## Examples

``` r
project <- fs::path(tempdir(), "example_project")
fs::dir_create(fs::path(project, "Chapter"))
cat("project:\n  type: website\n", file = fs::path(project, "_quarto.yml"))
yaml::write_yaml(
  list(params = list(save = TRUE, wave = "2025")),
  file = fs::path(project, "_metadata.yml")
)
yaml::write_yaml(
  list(params = list(wave = "2026")),
  file = fs::path(project, "Chapter", "_metadata.yml")
)

# The deeper `wave` wins; `save` is inherited from the project level.
aggregate_metadata_yml(fs::path(project, "Chapter"))$params
#> $save
#> [1] TRUE
#> 
#> $wave
#> [1] "2026"
#> 
```
