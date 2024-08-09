## R CMD check results

0 errors | 0 warnings | 2 notes

## Note

- This is a new release. (The saros-package has been consciously decoupled into 'saros.base', 'saros.utils', and 'saros.contents', all mutually independent, with saros as the umbrella package.)
- Rhub-success on 1-5,9,20-23. Failed on clang-asan due to suggests-package installation of RcppParallel. valgrind failed on memcheck, but I cannot understand whether this is due to my code, dependencies (of which I mostly import popular tidyverse/rlib-stuff), or unstable R-version.
