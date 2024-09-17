## R CMD check results

0 errors | 0 warnings | 4 notes

## Note

- Fixed return values docs and removed write-by-default. 
- Remaining cat() use is merely for writing to disk (main purpose of functions) or if log file has been specified (defaults to off).
- URLs are correct (will be valid upon release). 
- rhub fails for MacOS-R-devel due to failure in building RApiSerialize 0.1.3. I have waited to see if it magically got fixed but to no avail. Pretty sure there is nothing I can do on my end, as all other runs succeed.