## Release summary

This is a minor release (1.2.0) with new features, bug fixes, and improvements.

## Major changes in this version

### New features
- Added file logging for excluded/ignored variables in `refine_chapter_overview()`
- Added `detect_malformed_quarto_project()` for diagnosing malformed Quarto projects
- New `check_variable_labels()` function for validating variable labels
- New `sanitize_chr_vec()` function for cleaning character vectors
- Added chunk template variant 4 for mesos reports using new saros package functions

### Bug fixes
- Fixed critical sorting bug in `refine_chapter_overview()` where output was sorted by variable labels instead of positions
- Fixed regex bugs in `check_variable_labels()`
- Fixed tidyselect warnings in `look_for_extended()`
- Improved robustness of `setup_mesos()`

### Code quality improvements
- Refactored long functions by extracting helper functions
- Vectorized password lookup for better performance
- Added comprehensive tests (now 611 tests total)

## Test environments
* local: Windows 11, R 4.5.1
* GitHub Actions: 
  - windows-latest (R-release)
  - macOS-latest (R-release)
  - ubuntu-latest (R-devel, R-release, R-oldrel-1)

## R CMD check results

0 errors | 0 warnings | 0 notes

