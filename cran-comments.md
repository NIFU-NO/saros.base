## R CMD check results

0 errors | 0 warnings | 2 notes

## Note

- Retry on a new release. Spellchecking is correct. URLs are correct (will be valid upon release). 
- Response to Beni regarding comment: "You submitted 3 packages which probably are only used together? Please consider to ship one package and not several if these will typically be updated at the same time. If you want to keep them seperated please let us know and we will publish them (or wait for your resubmission if needed)."
    - We have multiple reasons for the decoupling (reasons below). However, instead of saros, saros.base, saros.utils, and saros.contents we managed to compress them into two: saros and saros.base (this). We must keep some separation because:
      1) Reducing dependencies and thus fragility of the packages. 
      2) Despite the 'saros' prefix, they are meant to work completely independently from each other, and will likely receive different maintenance needs (saros.base is most stable, saros.contents has many expansions in the pipeline, and saros.utils contains a mix of useful, experimental, and temporary features - some which should be submitted in 3rd party packages at a later stage).
      3) The packages have different target users: A newbie report author should only need saros, whereas the data cleaner/editor would only need saros.base.  
