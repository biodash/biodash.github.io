---
output: hugodown::md_document
title: "S05E05: R for Data Science (2e) - Ch. 8 - Data Import, Part II"
subtitle: "Today, we'll continue with the R4DS on data import (and export)"
summary: "Today, we'll continue with the R4DS on data import (and export)"
authors: [stephen-opiyo]
tags: [codeclub, r4ds]
date: "2023-03-02"
lastmod: "2023-03-02"
toc: true
rmd_hash: c9940b7f332b5339

---

<br>

------------------------------------------------------------------------

## Introduction

Today we will continue with the [R for Data Science chapter 8 on importing data](https://r4ds.hadley.nz/).

We will cover a few more tricks to import data with *readr*, and will also cover *exporting* data. We will talk about:

1.  Controlling column types when reading data,

2.  Reading data from multiple files, and

3.  Writing to a file.

We will again be using the `tidyverse` and `janitor` packages, so we first need make sure these packages are installed, and then load them for the current session using [`library()`](https://rdrr.io/r/base/library.html) commands:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># If you don't have these installed:</span></span>
<span><span class='c'>#install.packages("tidyverse")</span></span>
<span><span class='c'>#install.packages("janitor")</span></span>
<span></span>
<span><span class='c'># To load the packages</span></span>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span></span>
<span><span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching core tidyverse packages</span> ──────────────────────── tidyverse 2.0.0 ──</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>dplyr    </span> 1.1.0     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>readr    </span> 2.1.4</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>forcats  </span> 1.0.0     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>stringr  </span> 1.5.0</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>ggplot2  </span> 3.4.1     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tibble   </span> 3.1.8</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>lubridate</span> 1.9.2     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tidyr    </span> 1.3.0</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>purrr    </span> 1.0.1     </span></span>
<span><span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span> ────────────────────────────────────────── tidyverse_conflicts() ──</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>filter()</span> masks <span style='color: #0000BB;'>stats</span>::filter()</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>lag()</span>    masks <span style='color: #0000BB;'>stats</span>::lag()</span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> Use the <a href='http://conflicted.r-lib.org/'>conflicted package</a> to force all conflicts to become errors</span></span><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/sfirke/janitor'>janitor</a></span><span class='o'>)</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; Attaching package: 'janitor'</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; The following objects are masked from 'package:stats':</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt;     chisq.test, fisher.test</span></span></code></pre>

</div>

------------------------------------------------------------------------

<br>

## Book Chapter 8.3 and 8.4

Let's switch to [the book](https://r4ds.hadley.nz/data-import.html#sec-col-types) for this part.

------------------------------------------------------------------------

<br>

## Breakout Rooms I

We'll use the `03-sales.csv` file from the examples in the book. You can download it as follows to your current R working directory:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>url_csv</span> <span class='o'>&lt;-</span> <span class='s'>"https://github.com/biodash/biodash.github.io/raw/master/content/codeclub/S05E06/03-sales.csv"</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>url_csv</span>, destfile <span class='o'>=</span> <span class='s'>"03-sales.csv"</span><span class='o'>)</span></span></code></pre>

</div>

<div class="puzzle">

<div>

### Exercise 1

Read the `03-sales.csv` file, but with the following twist: read *all* columns as *factors*.

<details>
<summary>
<b>Hints</b>(click here)
</summary>

<br>

Use the `col_types` argument and within that, call the `cols` function and specify a `.default`.

</details>

<br>

<details>
<summary>
<b>Solution</b>(click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_csv</a></span><span class='o'>(</span><span class='s'>"03-sales.csv"</span>,</span>
<span>         col_types <span class='o'>=</span> <span class='nf'><a href='https://readr.tidyverse.org/reference/cols.html'>cols</a></span><span class='o'>(</span>.default <span class='o'>=</span> <span class='nf'><a href='https://readr.tidyverse.org/reference/parse_factor.html'>col_factor</a></span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 5</span></span></span>
<span><span class='c'>#&gt;   month year  brand item  n    </span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> March 2019  1     1234  3    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> March 2019  1     3627  1    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> March 2019  1     8820  3    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> March 2019  2     7253  1    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> March 2019  2     8766  3    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> March 2019  2     8288  6</span></span></code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

<br>

## Book Chapter 8.5 and 8.6

Let's switch back to [the book](https://r4ds.hadley.nz/data-import.html#sec-writing-to-a-file) for this part.

------------------------------------------------------------------------

<br>

## Breakout Rooms I

<div class="puzzle">

<div>

### Exercise 2

Write the dataframe that you read in Exercise 1 to a CSV file. Recall that all columns in the dataframe are stored as *factors*.

Then, read the CSV file you just created back in, without specifying any additional arguments to [`read_csv()`](https://readr.tidyverse.org/reference/read_delim.html).

Check whether the columns are still factors, and explain why.

<details>
<summary>
<b>Hints</b>(click here)
</summary>

<br>

-   Assign the initial [`read_csv()`](https://readr.tidyverse.org/reference/read_delim.html) output to a dataframe, then use [`write_csv()`](https://readr.tidyverse.org/reference/write_delim.html) to write it to a CSV file.

-   Recall that a CSV file is a plain text file. Can a plain text file store "metadata" about column types?

</details>

<br>

<details>
<summary>
<b>Solution</b>(click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>sales</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_csv</a></span><span class='o'>(</span><span class='s'>"03-sales.csv"</span>,</span>
<span>                  col_types <span class='o'>=</span> <span class='nf'><a href='https://readr.tidyverse.org/reference/cols.html'>cols</a></span><span class='o'>(</span>.default <span class='o'>=</span> <span class='nf'><a href='https://readr.tidyverse.org/reference/parse_factor.html'>col_factor</a></span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://readr.tidyverse.org/reference/write_delim.html'>write_csv</a></span><span class='o'>(</span><span class='nv'>sales</span>, <span class='s'>"sales.csv"</span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_csv</a></span><span class='o'>(</span><span class='s'>"sales.csv"</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='font-weight: bold;'>Rows: </span><span style='color: #0000BB;'>6</span> <span style='font-weight: bold;'>Columns: </span><span style='color: #0000BB;'>5</span></span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>──</span> <span style='font-weight: bold;'>Column specification</span> <span style='color: #00BBBB;'>────────────────────────────────────────────────────────</span></span></span>
<span><span class='c'>#&gt; <span style='font-weight: bold;'>Delimiter:</span> ","</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>chr</span> (1): month</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>dbl</span> (4): year, brand, item, n</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> Use `spec()` to retrieve the full column specification for this data.</span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> Specify the column types or set `show_col_types = FALSE` to quiet this message.</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 5</span></span></span>
<span><span class='c'>#&gt;   month  year brand  item     n</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> March  <span style='text-decoration: underline;'>2</span>019     1  <span style='text-decoration: underline;'>1</span>234     3</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> March  <span style='text-decoration: underline;'>2</span>019     1  <span style='text-decoration: underline;'>3</span>627     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> March  <span style='text-decoration: underline;'>2</span>019     1  <span style='text-decoration: underline;'>8</span>820     3</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> March  <span style='text-decoration: underline;'>2</span>019     2  <span style='text-decoration: underline;'>7</span>253     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> March  <span style='text-decoration: underline;'>2</span>019     2  <span style='text-decoration: underline;'>8</span>766     3</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> March  <span style='text-decoration: underline;'>2</span>019     2  <span style='text-decoration: underline;'>8</span>288     6</span></span></code></pre>

</div>

When we read the file back in, the columns are no longer factors but characters and numerics, because this sort of information is lost when writing to a plain text file.

</details>

</div>

</div>

<br>

<div class="puzzle">

<div>

### Exercise 3

Repeat what you did in Exercise 2, but now write to and read from an `RDS` file.

Again, check whether the columns are still factors, and explain why.

<details>
<summary>
<b>Hints</b>(click here)
</summary>

<br>

Use the [`write_rds()`](https://readr.tidyverse.org/reference/read_rds.html) and [`read_rds()`](https://readr.tidyverse.org/reference/read_rds.html) functions.

</details>

<br>

<details>
<summary>
<b>Solution</b>(click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>sales</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_csv</a></span><span class='o'>(</span><span class='s'>"03-sales.csv"</span>,</span>
<span>                  col_types <span class='o'>=</span> <span class='nf'><a href='https://readr.tidyverse.org/reference/cols.html'>cols</a></span><span class='o'>(</span>.default <span class='o'>=</span> <span class='nf'><a href='https://readr.tidyverse.org/reference/parse_factor.html'>col_factor</a></span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://readr.tidyverse.org/reference/read_rds.html'>write_rds</a></span><span class='o'>(</span><span class='nv'>sales</span>, <span class='s'>"sales.rds"</span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://readr.tidyverse.org/reference/read_rds.html'>read_rds</a></span><span class='o'>(</span><span class='s'>"sales.rds"</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 5</span></span></span>
<span><span class='c'>#&gt;   month year  brand item  n    </span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> March 2019  1     1234  3    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> March 2019  1     3627  1    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> March 2019  1     8820  3    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> March 2019  2     7253  1    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> March 2019  2     8766  3    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> March 2019  2     8288  6</span></span></code></pre>

</div>

The columns are still factors because RDS files preserve all information about R objects, including column type information.

</details>

</div>

</div>

