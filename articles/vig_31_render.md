# Render

The idea behind the Saros concept is that you can create temporary
documents for internal quality assurance, but that the main point is to
compile the interactive website at the same time as creating the reports
in PDF and Word (where all the chapters are merged and automatically
added to the cover page, colophon, etc). In principle, several ways to
start this process, but for now this is what works best:

- In `000_initialize_project.R` under `paths$site`, you use a folder on
  your machine, outside of OneDrive/Sharepoint/Teams. An example is
  “C:/Users/%HOMEPATH%/AppData/Local/Saros”.
- Why not in a folder for cloud storage? Well, Sharepoint/Microsoft has
  a silly limitation on the number of characters in file paths of
  approx. 260 characters, and spaces count for 3 characters (%20). If
  you use caching in Quarto, you run the risk of Windows not finding the
  files…
- The website files can add up to many MB and it is good not to store
  this in the common area’s storage space.
- This obviously entails disadvantages, such as navigating to these
  files and sharing across project members…
