# Prepare dataset

Although these are requirements for effective Saros use, there are also
general good recommendations for documenting data. One should therefore
implement the checkpoints from day 1, i.e. already when programming the
questionnaire, documenting the instruments used, as well as obtaining
register data used to draw samples.

## What variables do Saros need?

The data set needs the variables stated in the
**?@sec-chapter-overview**, and possibly the mesos variable if mesos
reports are created. Variables that are not used are ignored, but logged
in a txt file (and in the R console) when you run
[`saros.base::draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
so that you can check that things went as expected - maybe you entered
the wrong variable name.

## Variable name

The principles of variable names and variable labels aim to allow Saros
to automatically handle similar variables together, and different
variables separately. They may seem draconian but ensure that confusion
is avoided and Saros offer benefits by cleaning the output for you.

- R handles variable names with spaces, Nordic letters, distinguishes
  between small and capital letters, odd characters, etc. and has no
  limit on the number of characters. BUT, many other programs have such
  restrictions.

- Keep variable names to a maximum of 8-10 characters.

- Use only English (ASCII) lowercase letters, numbers and underscores.

- Variable names must start with a letter.

- Try to avoid letters that look the same in upper and lower case.

  - See **?@sec-standard-variable-names**

- Optimally, all batteries should share the same prefix in the variable
  name, which is unique from all other batteries/variables. For example,
  one can name the variables s_100-s_120 for one battery, g_121-g_129
  for another battery, etc. and specify that
  `variable_name_separator = "_"`. However, another equally fine
  approach is to name variables in a self-explanatory

## Data types

Saros will eventually contain more control checks of variables, but for
now check that the data type is the way you want Saros to handle them.

### Categorical variables

This type of data is particularly important in the social sciences, and
needs extra attention in Saros and R.

- When you load data in the formats Stata, SPSS or SAS with
  `haven::read_*`, R does not know how to handle the potential
  possibilities for *various types of missing* (e.g. not managed,
  skipped, not reached, illegible writing, etc). In R there is only one
  type of missing (NA). Categorical variables from Stata/SPSS/SAS data
  are thus set with a temporary {labelled} data type. It can be tempting
  to leave them like this as it looks nice and clear when you print out
  the variables to the console:

``` r
library(dplyr)
```

    Attaching package: 'dplyr'

    The following objects are masked from 'package:stats':

        filter, lag

    The following objects are masked from 'package:base':

        intersect, setdiff, setequal, union

``` r
library(labelled)
library(saros.base)
ex_survey |>
   mutate(b_1 = labelled::to_labelled(b_1)) |>
   count(b_1) # If your categorical variables look like this, you need to convert them
```

    # A tibble: 3 × 2
      b_1                n
      <dbl+lbl>      <int>
    1 1 [Not at all]   129
    2 2 [A bit]        143
    3 3 [A lot]         28

``` r
# This is how they ought to look
ex_survey |>
   count(b_1)
```

    # A tibble: 3 × 2
      b_1            n
      <fct>      <int>
    1 Not at all   129
    2 A bit        143
    3 A lot         28

**But the `labelled` variable type is not intended to be used more than
at the start. It will certainly cause trouble in general in R, and also
in Saros.** For example, the apparently fine overview you see above will
not be possible to display in tables or in a Quarto document like this.

Instead, use the factor type in R. One converts all categorical
variables in an SPSS/Stata/SAS from the `labelled' type to the`factor’
type as follows:

``` r
# Optionally convert all unordered to ordered factors if they are mostly that
my_data <- 
   ex_survey |> 
   mutate(across(where(~is.factor(.x)), ~factor(.x, ordered=TRUE)))
```

- Distinguishing between nominal (unordered factor) and ordinal (ordered
  factor) variables is particularly useful in Saros, as they can have
  separate color scales or output types, and that some sorting
  algorithms do not break up ordinal scales.

- Never create dummy variables for Saros. If in the future Saros should
  need it for regression, etc, it will be created automatically.

- Check that the order of all categorical variables is correct. Can be
  done with the following code. Check the values ​​column.

``` r
ex_survey |>
   look_for("^[abdep]_", details=TRUE)
```

     pos variable label                     col_type missing unique_values
     4   a_1      Do you consent to the fo~ fct      25      3

     5   a_2      Do you consent to the fo~ fct      36      3

     6   a_3      Do you consent to the fo~ fct      28      3

     7   a_4      Do you consent to the fo~ fct      25      3

     8   a_5      Do you consent to the fo~ fct      30      3

     9   a_6      Do you consent to the fo~ fct      26      3

     10  a_7      Do you consent to the fo~ fct      30      3

     11  a_8      Do you consent to the fo~ fct      31      3

     12  a_9      Do you consent to the fo~ fct      31      3

     13  b_1      How much do you like liv~ fct      0       3


     14  b_2      How much do you like liv~ fct      0       3


     15  b_3      How much do you like liv~ fct      0       3


     18  d_1      Rate your degree of conf~ fct      0       11










     19  d_2      Rate your degree of conf~ fct      0       11










     20  d_3      Rate your degree of conf~ fct      0       11










     21  d_4      Rate your degree of conf~ fct      0       11










     22  e_1      How often do you do the ~ fct      0       5




     23  e_2      How often do you do the ~ fct      0       5




     24  e_3      How often do you do the ~ fct      0       5




     25  e_4      How often do you do the ~ fct      0       5




     26  p_1      To what extent do you ag~ fct      0       4



     27  p_2      To what extent do you ag~ fct      0       4



     28  p_3      To what extent do you ag~ fct      0       4



     29  p_4      To what extent do you ag~ fct      34      5



     values                    na_values na_range
     No
     Yes
     No
     Yes
     No
     Yes
     No
     Yes
     No
     Yes
     No
     Yes
     No
     Yes
     No
     Yes
     No
     Yes
     Not at all
     A bit
     A lot
     Not at all
     A bit
     A lot
     Not at all
     A bit
     A lot
     0\nCannot do at all
     1
     2
     3
     4
     5\nModerately can do
     6
     7
     8
     9
     10\nHighly certain can do
     0\nCannot do at all
     1
     2
     3
     4
     5\nModerately can do
     6
     7
     8
     9
     10\nHighly certain can do
     0\nCannot do at all
     1
     2
     3
     4
     5\nModerately can do
     6
     7
     8
     9
     10\nHighly certain can do
     0\nCannot do at all
     1
     2
     3
     4
     5\nModerately can do
     6
     7
     8
     9
     10\nHighly certain can do
     Very rarely
     Rarely
     Sometimes
     Often
     Very often
     Very rarely
     Rarely
     Sometimes
     Often
     Very often
     Very rarely
     Rarely
     Sometimes
     Often
     Very often
     Very rarely
     Rarely
     Sometimes
     Often
     Very often
     Strongly disagree
     Somewhat disagree
     Somewhat agree
     Strongly agree
     Strongly disagree
     Somewhat disagree
     Somewhat agree
     Strongly agree
     Strongly disagree
     Somewhat disagree
     Somewhat agree
     Strongly agree
     Strongly disagree
     Somewhat disagree
     Somewhat agree
     Strongly agree                              

``` r
# Alternatively
library(purrr)
ex_survey |>
   select(where(~is.factor(.x))) |>
   map(~levels(.x))
```

    $x1_sex
    [1] "Males"   "Females"

    $x2_human
    [1] "Robot?"              "Definitely humanoid"

    $x3_nationality
    [1] "Andorra"  "Belize"   "Cameroon" "Denmark"  "Eswatini" "Fiji"     "Ghana"

    $a_1
    [1] "No"  "Yes"

    $a_2
    [1] "No"  "Yes"

    $a_3
    [1] "No"  "Yes"

    $a_4
    [1] "No"  "Yes"

    $a_5
    [1] "No"  "Yes"

    $a_6
    [1] "No"  "Yes"

    $a_7
    [1] "No"  "Yes"

    $a_8
    [1] "No"  "Yes"

    $a_9
    [1] "No"  "Yes"

    $b_1
    [1] "Not at all" "A bit"      "A lot"

    $b_2
    [1] "Not at all" "A bit"      "A lot"

    $b_3
    [1] "Not at all" "A bit"      "A lot"

    $d_1
     [1] "0\nCannot do at all"       "1"
     [3] "2"                         "3"
     [5] "4"                         "5\nModerately can do"
     [7] "6"                         "7"
     [9] "8"                         "9"
    [11] "10\nHighly certain can do"

    $d_2
     [1] "0\nCannot do at all"       "1"
     [3] "2"                         "3"
     [5] "4"                         "5\nModerately can do"
     [7] "6"                         "7"
     [9] "8"                         "9"
    [11] "10\nHighly certain can do"

    $d_3
     [1] "0\nCannot do at all"       "1"
     [3] "2"                         "3"
     [5] "4"                         "5\nModerately can do"
     [7] "6"                         "7"
     [9] "8"                         "9"
    [11] "10\nHighly certain can do"

    $d_4
     [1] "0\nCannot do at all"       "1"
     [3] "2"                         "3"
     [5] "4"                         "5\nModerately can do"
     [7] "6"                         "7"
     [9] "8"                         "9"
    [11] "10\nHighly certain can do"

    $e_1
    [1] "Very rarely" "Rarely"      "Sometimes"   "Often"       "Very often"

    $e_2
    [1] "Very rarely" "Rarely"      "Sometimes"   "Often"       "Very often"

    $e_3
    [1] "Very rarely" "Rarely"      "Sometimes"   "Often"       "Very often"

    $e_4
    [1] "Very rarely" "Rarely"      "Sometimes"   "Often"       "Very often"

    $p_1
    [1] "Strongly disagree" "Somewhat disagree" "Somewhat agree"
    [4] "Strongly agree"

    $p_2
    [1] "Strongly disagree" "Somewhat disagree" "Somewhat agree"
    [4] "Strongly agree"

    $p_3
    [1] "Strongly disagree" "Somewhat disagree" "Somewhat agree"
    [4] "Strongly agree"

    $p_4
    [1] "Strongly disagree" "Somewhat disagree" "Somewhat agree"
    [4] "Strongly agree"   

- All categorical variables should be of the factor type with all
  possible response options as its categorical levels (levels). This
  makes the graphs and tables as correct as possible. See example below
  to correct this if you receive the data as
  e.g. [`character()`](https://rdrr.io/r/base/character.html) or
  [`integer()`](https://rdrr.io/r/base/integer.html) (something you
  should definitely avoid at all costs as it is time-consuming to
  restore the data).

``` r
data <-
   ex_survey |>
   mutate(across(matches("p_"),
      ~factor(.x, levels=c(
            "Strongly disagree",
            "Somewhat disagree",
            "Somewhat agree",
            "Strongly agree"),
         ordered=TRUE))) |> # FALSE if nominal
   count(p_3)
```

\## Text variables (character, string, open text fields)

- Used for open text fields, names, etc. where there are normally more
  than 20 variants.

- You are responsible for de-identification/anonymization! Neither Saros
  nor its developers take responsibility for this. Saros will only
  display variables that you have explicitly requested to be made
  available - the rest will always be dropped. But to avoid incorrect
  use, it may be ok to remove the most personally identifying
  information - to be on the safe side.

- Use [`as.character()`](https://rdrr.io/r/base/character.html) to
  convert e.g. categorical data (factor/ordered) to text. Use the
  [stringr](https://stringr.tidyverse.org) package to work with such
  data.

- NOT FULLY IMPLEMENTED YET: Saros will issue a warning if a text
  variable contains fewer than 10 unique values, if all of these have
  string lengths of fewer than 40 characters, and there are multiple
  duplicates of one of the values. It will also give a warning if it is
  possible to convert the text variable to numbers without missing
  everything. The criteria for these warnings can be adjusted/turned
  off.

#### Mesos variable

- In order to create mesos reports (institution-specific reports), a
  variable that identifies the mesos groups (i.e., school name,
  institution name) must be prepared and cleaned. Due to file path
  length and username generation, these should have short names and
  preferably without spaces (University of Manchester =\> UoM, Ethon
  boarding school =\> Ethon). Use underscores instead of spaces or
  special characters. Best of all, stick to ASCII. The names should also
  be consistent across reports as the institution will get usernames for
  each unique spelling. “UoM_and_LSE” in one report and “UoM” in another
  report will result in two different sets of usernames/passwords.

### Number variables

- R allows two types of number variables: integers and real numbers
  (numeric/double). Saros currently does not differentiate between these
  two types.

## Variable labels {#sec-variable labels}

Variable labels are typically the actual question formulation in a
questionnaire, or a definition of how data has been collected.

- All variables to be used must have a label, this also applies to
  e.g. independent variables that you have created yourself. See the
  [`{labelled}`](https://CRAN.R-project.org/package=labelled) package
  for functions to easily set labels if something is missing.

- Note that in R, variable labels are not considered to be still valid
  if you have changed the variable’s content (with
  e.g. [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html)),
  and **the labels therefore unfortunately disappear**. However, you can
  copy them back in afterwards with
  `labelled::copy_labels_from(original_data)`.

``` r
library(forcats)
original_data <- ex_survey
modified_data <-
   original_data |>
   mutate(x1_sex = fct_rev(x1_sex)) |>
   copy_labels_from(from = original_data)
```

- All labels for the variables used must be unique (prefix+suffix in
  total).
  [`saros.base::draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
  will issue a warning if it detects multiple variables that share
  exactly identical labels. If e.g. a dependent categorical variable
  (`factor` or `ordered`) and a dependent text variable (open text
  field, `character`) have identical labels (which you cannot/do not
  want to change), you must ask saros to group the output on
  `"variable_type_dep"` as well.

- Labels for variables that are related (batteries) must have a common
  prefix (prefix and suffix are typically separated by `" - "`). Matrix
  questions in Qualtrics, SurveyXact, etc. will almost always sort this
  out for you. But does one of the questions have an extra space the
  variables will be treated as if they come from different batteries.

- The labels should not have double separators (” - “) unless intended.
  Can create a mess.

- But more importantly than with variable names, **different batteries
  must not share the same label prefix**. Do you have a lot of batteries
  with “To what extent do you agree/disagree with the following
  statements?” then you will have a problem. It can be solved by being
  more specific in the claim (“… the following claims about your work
  situation?”), or by separating the batteries also by
  [Section 2](#sec-variable-name) or data type.

## Storage of data

R handles all kinds of data formats, though some are clearly better

Format \| Labels \| Storage space \| Speed ​​\| Read/write in Stata? \|
Read/write in SPSS? \| Open Standard \| Unicode? \|

\|————-\|————————\|———- —-\|————\|———————\|——— ————\|————–\|————\| \|
sav (SPSS) \| Limitation on length \| \| \| Yes \| Yes \| No \| \| \|
dta (Stata) \| Limitation on length \| \| \| Yes \| Yes \| No \| \| \|
Parquet \| Good \| Very small \| Very fast \| No \| No \| Yes \| \| \|
qs \| Everything is possible \| Very small \| Very fast \| No \| No \|
\| \| \| Excel \| No \| Bad \| Bad \| Yes \| Yes \| No \| \| \| CSV \|
No \| Worst \| Worst \| Yes \| Yes \| Yes \| Confusing \| \| \| \| \| \|
\| \| \| \| \| \| \| \| \| \| \| \| \|

: Advantages and disadvantages of different data formats

## Complex survey designs

Is sample weighting, stratification, clustering or similar used? Contact
Stephan in good time. Saros is supposed to work on this as well, but has
not been tested yet.

## Project-specific data preparations

Sorry, we don’t have much help here.
