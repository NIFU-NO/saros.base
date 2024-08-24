## R CMD check results

0 errors | 0 warnings | 3 notes

## Note

- Retry on a new release. 
- Rhub-success on 1,3,4,5,6,9,13,20,21,22,23,24. 
- Response to Beni regarding comment: "You submitted 3 packages which probably are only used together? Please consider to ship one package and not several if these will typically be updated at the same time. If you want to keep them seperated please let us know and we will publish them (or wait for your resubmission if needed)."
    - We have multiple reasons for the decoupling (do read until the end though).
      1) Reducing dependencies and thus fragility of the packages. 
      2) Despite the 'saros' prefix, they are meant to work completely independently from each other, and will likely receive different maintenance needs (saros.base is most stable, saros.contents has many expansions in the pipeline, and saros.utils contains a mix of useful, experimental, and temporary features - some which should be submitted in 3rd party packages at a later stage).
      3) The packages have different target users: A newbie report author should only need saros.contents, whereas the data cleaner/editor would only need saros.base.  
      4) There is some funding considerations involved in the saros-project - which also explaining the saros-prefix to the packages - which I could expand upon on a Zoom-call with you if requested.
    - *That said though*, I understand your concern of having four packages demanding CRAN computing resources. I will do my best to make saros.utils redundant by moving its functions to the other packages and 3rd party packages. Hence, I will not submit it to CRAN.
