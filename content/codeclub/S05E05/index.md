---
output: hugodown::md_document
title: "S05E05: R for Data Science (2e) - Ch. 8 - Data Import"
subtitle: "Today, we'll cover an essential component of working with R: how to import your data into R!"
summary: "Today, we'll cover an essential component of working with R: how to import your data into R! We'll do so with functions from one of the core tidyverse packages: readr."
authors: [admin]
tags: [codeclub, r4ds]
date: "2023-02-20"
lastmod: "2023-02-20"
toc: true
rmd_hash: c7a993995fda7542

---

<br>

------------------------------------------------------------------------

## Introduction

### Setting up

Today, we'll talk about reading data into R. We'll be using the *readr* package, which is part of the core tidyverse, and is therefore loaded by [`library(tidyverse)`](https://tidyverse.tidyverse.org):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span></span>
<span><span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching packages</span> ─────────────────────────────────────── tidyverse 1.3.2 ──</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>ggplot2</span> 3.4.0     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>purrr  </span> 1.0.1</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tibble </span> 3.1.8     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>dplyr  </span> 1.1.0</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tidyr  </span> 1.3.0     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>stringr</span> 1.5.0</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>readr  </span> 2.1.3     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>forcats</span> 1.0.0</span></span>
<span><span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span> ────────────────────────────────────────── tidyverse_conflicts() ──</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>filter()</span> masks <span style='color: #0000BB;'>stats</span>::filter()</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>lag()</span>    masks <span style='color: #0000BB;'>stats</span>::lag()</span></span></code></pre>

</div>

To clean up column names, we'll use the *janitor* package, which you can install as follows:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"janitor"</span><span class='o'>)</span></span></code></pre>

</div>

We also need to download a couple of files so that we can practice importing them:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>url_csv</span> <span class='o'>&lt;-</span> <span class='s'>"https://github.com/biodash/biodash.github.io/raw/master/content/codeclub/S05E05/students.csv"</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>url_csv</span>, destfile <span class='o'>=</span> <span class='s'>"students.csv"</span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>url_csv_noheader</span> <span class='o'>&lt;-</span> <span class='s'>"https://github.com/biodash/biodash.github.io/raw/master/content/codeclub/S05E05/students_noheader.csv"</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>url_csv_noheader</span>, destfile <span class='o'>=</span> <span class='s'>"students_noheader.csv"</span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>url_csv_meta</span> <span class='o'>&lt;-</span> <span class='s'>"https://github.com/biodash/biodash.github.io/raw/master/content/codeclub/S05E05/students_with_meta.csv"</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>url_csv_meta</span>, destfile <span class='o'>=</span> <span class='s'>"students_with_meta.csv"</span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>url_tsv</span> <span class='o'>&lt;-</span> <span class='s'>"https://github.com/biodash/biodash.github.io/raw/master/content/codeclub/S05E05/students.tsv"</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>url_tsv</span>, destfile <span class='o'>=</span> <span class='s'>"students.tsv"</span><span class='o'>)</span></span></code></pre>

</div>

### Tabular files

We'll focus on reading **tabular plain text** files, which is by far the most common input file type for R. By *tabular*, I mean that these files have rows and columns. The columns in tabular files are most commonly separated by either:

-   **Commas**: such files are often called **CSV** files, for Comma-Separated Values. They are usually saved with a `.csv` or simply a `.txt` extension.

<!-- -->

    Student ID,Full Name,favourite.food,mealPlan,AGE
    1,Sunil Huffmann,Strawberry yoghurt,Lunch only,4
    2,Barclay Lynn,French fries,Lunch only,5
    3,Jayendra Lyne,N/A,Breakfast and lunch,7
    4,Leon Rossini,Anchovies,Lunch only,
    5,Chidiegwu Dunkel,Pizza,Breakfast and lunch,five
    6,Güvenç Attila,Ice cream,Lunch only,6

-   **Tabs**: such files are often called **TSV** files, for Tab-Separated Values. They are usually saved with a `.tsv` or again, simply a `.txt` extension.

<!-- -->

    Student ID      Full Name       favourite.food  mealPlan        AGE
    1       Sunil Huffmann  Strawberry yoghurt      Lunch only      4
    2       Barclay Lynn    French fries    Lunch only      5
    3       Jayendra Lyne   N/A     Breakfast and lunch     7
    4       Leon Rossini    Anchovies       Lunch only
    5       Chidiegwu Dunkel        Pizza   Breakfast and lunch     five
    6       Güvenç Attila   Ice cream       Lunch only      6

The examples above were of a CSV and a TSV file containing same data on 6 students and the food they eat -- which we will be practicing with today.

While we'll be using the *readr* package, base R has similar functions that you may run into, like [`read.table()`](https://rdrr.io/r/utils/read.table.html). But the *readr* ones are faster and have several other nice features.

<br>

------------------------------------------------------------------------

## Basics of reading in tabular files

We'll start by reading in the `students.csv` CSV file that we saw above.

**CSV files can be read with *readr*'s [`read_csv()`](https://readr.tidyverse.org/reference/read_delim.html) function**, which is the function we'll mostly use today. But note that below, I'll often say that "*readr*" does this and that, instead of referring to the specific function. That is because the *readr* functions for different file types all behave very similarly, which is nice!

We will first use the [`read_csv()`](https://readr.tidyverse.org/reference/read_delim.html) function in the most basic possible way, that is, by only providing the filename:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>students</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_csv</a></span><span class='o'>(</span><span class='s'>"students.csv"</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='font-weight: bold;'>Rows: </span><span style='color: #0000BB;'>6</span> <span style='font-weight: bold;'>Columns: </span><span style='color: #0000BB;'>5</span></span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>──</span> <span style='font-weight: bold;'>Column specification</span> <span style='color: #00BBBB;'>────────────────────────────────────────────────────────</span></span></span>
<span><span class='c'>#&gt; <span style='font-weight: bold;'>Delimiter:</span> ","</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>chr</span> (4): Full Name, favourite.food, mealPlan, AGE</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>dbl</span> (1): Student ID</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> Use `spec()` to retrieve the full column specification for this data.</span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> Specify the column types or set `show_col_types = FALSE` to quiet this message.</span></span></code></pre>

</div>

We have saved the contents of the file in the dataframe `students`, which we'll print below. But the function is quite chatty and prints the following information about what it has done to screen:

-   How many rows and columns it read
-   Which column delimiter it used
-   How many and which columns were assigned to each data type

<div class="alert alert-note">

<div>

A column in an R dataframe can only contain a single formal data type. If a mixture of types (e.g. numbers and character strings) is present in one column, all entries will be *coerced to a single data type*. That data type is typically `chr` (character), since a number can be represented as a character string but not vice versa.

</div>

</div>

***readr* infers the column types** when you don't specify them, as above: 4 columns were interpreted as character columns (`chr`), and 1 column as numeric (`dbl` for "double", i.e. a floating point number). Let's take a look at the resulting dataframe (tibble), paying attention to the column types:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>students</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 5</span></span></span>
<span><span class='c'>#&gt;   `Student ID` `Full Name`      favourite.food     mealPlan            AGE  </span></span>
<span><span class='c'>#&gt;          <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>               <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span>            1 Sunil Huffmann   Strawberry yoghurt Lunch only          4    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span>            2 Barclay Lynn     French fries       Lunch only          5    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span>            3 Jayendra Lyne    N/A                Breakfast and lunch 7    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span>            4 Leon Rossini     Anchovies          Lunch only          <span style='color: #BB0000;'>NA</span>   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span>            5 Chidiegwu Dunkel Pizza              Breakfast and lunch five </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span>            6 Güvenç Attila    Ice cream          Lunch only          6</span></span></code></pre>

</div>

Rarely, *readr* will misinterpret column types. In that case, it's possible to **manually specify the column types**: we'll see how to do this next week.

<br>

------------------------------------------------------------------------

## Interlude: File locations

In the above example, we simply provided a file name without a location to [`read_csv()`](https://readr.tidyverse.org/reference/read_delim.html). Doing so signals to R that the file is present in your current R "working directory". For the `students.csv` file, that should have been the case, since we also downloaded it to our working directory: we provided the `download.file` also with a file name only.

But if the file is located elsewhere, that code will fail: *readr* will *not* search your computer for a file with this name.

<div class="alert alert-note">

<div>

To see what your working directory is, you can run [`getwd()`](https://rdrr.io/r/base/getwd.html):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://rdrr.io/r/base/getwd.html'>getwd</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; [1] "/home/jelmer/Dropbox/mcic/website/hugodown/content/codeclub/S05E05"</span></span></code></pre>

</div>

And your working directory is also shown at the top of the RStudio console pane.

</div>

</div>

If the file you want to read is not in your current working directory, you can:

-   Change your working directory with [`setwd()`](https://rdrr.io/r/base/getwd.html) (generally not recommended)
-   Include the *location* of the file when calling [`read_csv()`](https://readr.tidyverse.org/reference/read_delim.html) (and other functions)

If the file is in a folder "downstream" from your working directory, you can easily find it by typing a quote symbol (double `"` or single `'`) either in a script or in the console, and pressing <kdb>tab</kbd>. This allows you to browse your files starting from your working directory:

<figure>
<p align="center">
<img src=img/path_completion.png width="50%">
<figcaption>
You can browse files by opening quotes!
</figcaption>
</p>
</figure>

If that's not the case, it may be easiest to copy the location using your computer's file browser, and paste that location into your code.

Here are two examples of including folder names with a function like [`read_csv()`](https://readr.tidyverse.org/reference/read_delim.html):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_csv</a></span><span class='o'>(</span><span class='s'>"data/more_students.csv"</span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_csv</a></span><span class='o'>(</span><span class='s'>"C:/Users/jelmer/R_data/other_students.csv"</span><span class='o'>)</span></span></code></pre>

</div>

Note that in R, you can *always* use forward slashes `/` to separate folder regardless of your operating system (If you have Windows, which uses backslashes `\` instead, then backslashes will also work.)

<div class="alert alert-note">

<div>

In two weeks, we'll talk about RStudio "Projects", which can make your life a lot easier when it comes to file paths and never having to change your working directory.

</div>

</div>

<br>

------------------------------------------------------------------------

## Common challenges with input files

### No headers

Some files have no first line with column names. That leads to problems when using all the defaults:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_csv</a></span><span class='o'>(</span><span class='s'>"students_noheader.csv"</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 5 × 5</span></span></span>
<span><span class='c'>#&gt;     `1` `Sunil Huffmann` `Strawberry yoghurt` `Lunch only`        `4`  </span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>               <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span>     2 Barclay Lynn     French fries         Lunch only          5    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span>     3 Jayendra Lyne    N/A                  Breakfast and lunch 7    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span>     4 Leon Rossini     Anchovies            Lunch only          <span style='color: #BB0000;'>NA</span>   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span>     5 Chidiegwu Dunkel Pizza                Breakfast and lunch five </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span>     6 Güvenç Attila    Ice cream            Lunch only          6</span></span></code></pre>

</div>

Oops! The first row of data was interpreted as column names. We can tell *readr* to not do this by adding `col_names = FALSE`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_csv</a></span><span class='o'>(</span><span class='s'>"students_noheader.csv"</span>, col_names <span class='o'>=</span> <span class='kc'>FALSE</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 5</span></span></span>
<span><span class='c'>#&gt;      X1 X2               X3                 X4                  X5   </span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>               <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span>     1 Sunil Huffmann   Strawberry yoghurt Lunch only          4    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span>     2 Barclay Lynn     French fries       Lunch only          5    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span>     3 Jayendra Lyne    N/A                Breakfast and lunch 7    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span>     4 Leon Rossini     Anchovies          Lunch only          <span style='color: #BB0000;'>NA</span>   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span>     5 Chidiegwu Dunkel Pizza              Breakfast and lunch five </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span>     6 Güvenç Attila    Ice cream          Lunch only          6</span></span></code></pre>

</div>

That's better! But of course, we can't automatically get useful column names, and they are now named `X1`, `X2`, etc. We could set the column names after reading the file, but we can also provide a vector of column names to the `col_names` argument of [`read_csv()`](https://readr.tidyverse.org/reference/read_delim.html):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>student_colnames</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"student_id"</span>, <span class='s'>"full_name"</span>, <span class='s'>"fav_food"</span>, <span class='s'>"meal_plan"</span>, <span class='s'>"age"</span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_csv</a></span><span class='o'>(</span><span class='s'>"students_noheader.csv"</span>, col_names <span class='o'>=</span> <span class='nv'>student_colnames</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 5</span></span></span>
<span><span class='c'>#&gt;   student_id full_name        fav_food           meal_plan           age  </span></span>
<span><span class='c'>#&gt;        <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>               <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span>          1 Sunil Huffmann   Strawberry yoghurt Lunch only          4    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span>          2 Barclay Lynn     French fries       Lunch only          5    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span>          3 Jayendra Lyne    N/A                Breakfast and lunch 7    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span>          4 Leon Rossini     Anchovies          Lunch only          <span style='color: #BB0000;'>NA</span>   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span>          5 Chidiegwu Dunkel Pizza              Breakfast and lunch five </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span>          6 Güvenç Attila    Ice cream          Lunch only          6</span></span></code></pre>

</div>

### Extra header or metadata lines

Other files will contain lines at the top that are not part of the table, but contain some sort of annotations or metadata, for instance:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'>#> # This file contains important information
#> # about some of our students
#> Student ID,Full Name,favourite.food,mealPlan,AGE
#> 1,Sunil Huffmann,Strawberry yoghurt,Lunch only,4
#> 2,Barclay Lynn,French fries,Lunch only,5
#> 3,Jayendra Lyne,N/A,Breakfast and lunch,7
#> 4,Leon Rossini,Anchovies,Lunch only,
#> 5,Chidiegwu Dunkel,Pizza,Breakfast and lunch,five
#> 6,Güvenç Attila,Ice cream,Lunch only,6</code></pre>

</div>

Since there are two metadata lines, we can tell *readr* to skip those first 2 lines with the `skip = n` argument:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_csv</a></span><span class='o'>(</span><span class='s'>"students_with_meta.csv"</span>, skip <span class='o'>=</span> <span class='m'>2</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 5</span></span></span>
<span><span class='c'>#&gt;   `Student ID` `Full Name`      favourite.food     mealPlan            AGE  </span></span>
<span><span class='c'>#&gt;          <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>               <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span>            1 Sunil Huffmann   Strawberry yoghurt Lunch only          4    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span>            2 Barclay Lynn     French fries       Lunch only          5    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span>            3 Jayendra Lyne    N/A                Breakfast and lunch 7    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span>            4 Leon Rossini     Anchovies          Lunch only          <span style='color: #BB0000;'>NA</span>   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span>            5 Chidiegwu Dunkel Pizza              Breakfast and lunch five </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span>            6 Güvenç Attila    Ice cream          Lunch only          6</span></span></code></pre>

</div>

Another way of skipping lines is with the `comment` argument, which can be used when all metadata lines start with a certain character, like `#` in our case:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_csv</a></span><span class='o'>(</span><span class='s'>"students_with_meta.csv"</span>, comment <span class='o'>=</span> <span class='s'>"#"</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 5</span></span></span>
<span><span class='c'>#&gt;   `Student ID` `Full Name`      favourite.food     mealPlan            AGE  </span></span>
<span><span class='c'>#&gt;          <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>               <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span>            1 Sunil Huffmann   Strawberry yoghurt Lunch only          4    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span>            2 Barclay Lynn     French fries       Lunch only          5    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span>            3 Jayendra Lyne    N/A                Breakfast and lunch 7    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span>            4 Leon Rossini     Anchovies          Lunch only          <span style='color: #BB0000;'>NA</span>   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span>            5 Chidiegwu Dunkel Pizza              Breakfast and lunch five </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span>            6 Güvenç Attila    Ice cream          Lunch only          6</span></span></code></pre>

</div>

Why might it be preferable to use `comment` over `skip`, when possible?

### Missing values denotations

R has a special data type for missing values: `NA`. It is important for downstream analyses that missing values are actually interpreted by R as `NA`s.

The `na` argument of the *readr* functions controls which values are interpreted as `NA`. The default is to interpret *empty cells* and *cells that only contain "NA"* as `NA`. In R code, this default is `c("", "NA")`, as we can see in the [`read_csv()`](https://readr.tidyverse.org/reference/read_delim.html) help.

However, sometimes files use other symbols to denote missing values, such as `999`, `X`, `-`, or, like in the `students.csv` file, `N/A`. It turns out that our `students.csv` file uses empty cells *and* `N/A` (and even plain `NA`s...), so we'll have to tell [`read_csv()`](https://readr.tidyverse.org/reference/read_delim.html) about that as follows:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_csv</a></span><span class='o'>(</span><span class='s'>"students.csv"</span>, na <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"N/A"</span>, <span class='s'>""</span><span class='o'>)</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 5</span></span></span>
<span><span class='c'>#&gt;   `Student ID` `Full Name`      favourite.food     mealPlan            AGE  </span></span>
<span><span class='c'>#&gt;          <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>               <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span>            1 Sunil Huffmann   Strawberry yoghurt Lunch only          4    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span>            2 Barclay Lynn     French fries       Lunch only          5    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span>            3 Jayendra Lyne    <span style='color: #BB0000;'>NA</span>                 Breakfast and lunch 7    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span>            4 Leon Rossini     Anchovies          Lunch only          <span style='color: #BB0000;'>NA</span>   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span>            5 Chidiegwu Dunkel Pizza              Breakfast and lunch five </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span>            6 Güvenç Attila    Ice cream          Lunch only          6</span></span></code></pre>

</div>

Compare this to the output when reading in without specifying `na` -- pay attention the the 3rd value in the `favourite.food` column:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_csv</a></span><span class='o'>(</span><span class='s'>"students.csv"</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 5</span></span></span>
<span><span class='c'>#&gt;   `Student ID` `Full Name`      favourite.food     mealPlan            AGE  </span></span>
<span><span class='c'>#&gt;          <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>               <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span>            1 Sunil Huffmann   Strawberry yoghurt Lunch only          4    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span>            2 Barclay Lynn     French fries       Lunch only          5    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span>            3 Jayendra Lyne    N/A                Breakfast and lunch 7    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span>            4 Leon Rossini     Anchovies          Lunch only          <span style='color: #BB0000;'>NA</span>   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span>            5 Chidiegwu Dunkel Pizza              Breakfast and lunch five </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span>            6 Güvenç Attila    Ice cream          Lunch only          6</span></span></code></pre>

</div>

### Crappy column names

You might have noticed the backticks around `Student ID` and `Full Name` when we display the dataframe. This is because these column names contain spaces, which are *allowed* but quite inconvenient in R.

We could go ahead and rename columns after reading in the file, e.g.:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># You'll need to use the backticks to refer to the column name with spaces!</span></span>
<span><span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_csv</a></span><span class='o'>(</span><span class='s'>"students.csv"</span><span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/rename.html'>rename</a></span><span class='o'>(</span>student_id <span class='o'>=</span> <span class='nv'>`Student ID`</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 5</span></span></span>
<span><span class='c'>#&gt;   student_id `Full Name`      favourite.food     mealPlan            AGE  </span></span>
<span><span class='c'>#&gt;        <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>               <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span>          1 Sunil Huffmann   Strawberry yoghurt Lunch only          4    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span>          2 Barclay Lynn     French fries       Lunch only          5    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span>          3 Jayendra Lyne    N/A                Breakfast and lunch 7    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span>          4 Leon Rossini     Anchovies          Lunch only          <span style='color: #BB0000;'>NA</span>   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span>          5 Chidiegwu Dunkel Pizza              Breakfast and lunch five </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span>          6 Güvenç Attila    Ice cream          Lunch only          6</span></span></code></pre>

</div>

But the `students.csv` file has terribly inconsistent column name styling throughout, with `favourite.food` (`.` separating words), `mealPlan` ("camel case"), and `AGE` (all caps) as the other column names. Renaming all columns gets tedious quickly, and would in fact become a serious chore if the file had, say, 50 columns.

The really nice `clean_names()` function from the *janitor* package converts all column names to "snake case" style (all lowercase, words separated by underscores, as we saw last week):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_csv</a></span><span class='o'>(</span><span class='s'>"students.csv"</span><span class='o'>)</span> <span class='o'>|&gt;</span></span>
<span>  <span class='nf'>janitor</span><span class='nf'>::</span><span class='nf'><a href='https://sfirke.github.io/janitor/reference/clean_names.html'>clean_names</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 5</span></span></span>
<span><span class='c'>#&gt;   student_id full_name        favourite_food     meal_plan           age  </span></span>
<span><span class='c'>#&gt;        <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>               <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span>          1 Sunil Huffmann   Strawberry yoghurt Lunch only          4    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span>          2 Barclay Lynn     French fries       Lunch only          5    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span>          3 Jayendra Lyne    N/A                Breakfast and lunch 7    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span>          4 Leon Rossini     Anchovies          Lunch only          <span style='color: #BB0000;'>NA</span>   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span>          5 Chidiegwu Dunkel Pizza              Breakfast and lunch five </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span>          6 Güvenç Attila    Ice cream          Lunch only          6</span></span></code></pre>

</div>

<div class="alert alert-note">

<div>

The notation above with `janitor::` in front of the function name is making explicit that this function is part of the *janitor* package; also, when we use this notation, we don't need to have the package *loaded*.

</div>

</div>

<br>

------------------------------------------------------------------------

## Other file types

-   In the breakout rooms, you'll practice with a **TSV file**: as we discussed above, these are tab-delimited. They can be read with [`read_tsv()`](https://readr.tidyverse.org/reference/read_delim.html).

-   For tabular plain text files with a **different delimiter** than commas or tabs (e.g., spaces), you can use [`read_delim()`](https://readr.tidyverse.org/reference/read_delim.html) and specify the delimiter.

-   **Excel files** can be read with the *readxl* package: see the bonus exercise.

-   **Unstructured** (non-tabular) plain text files can be read with the base R [`readLines()`](https://rdrr.io/r/base/readLines.html) function.

-   Sometimes you will create complex **R objects** that aren't easily saved as a plain text file. These can be saved as binary (non-human readable) `.rds` files with [`write_rds()`](https://readr.tidyverse.org/reference/read_rds.html) and read with [`read_rds()`](https://readr.tidyverse.org/reference/read_rds.html).

<br>

------------------------------------------------------------------------

## Breakout rooms

If you haven't done so already, please download the CSV and TSV files and make sure you have *janitor* installed (see the code in the Introduction).

<div class="puzzle">

<div>

### Exercise 1: `read_tsv()`

Let's try [`read_csv()`](https://readr.tidyverse.org/reference/read_delim.html)'s counterpart for TSV (tab-separated) files: [`read_tsv()`](https://readr.tidyverse.org/reference/read_delim.html).

The `students.tsv` file that you have downloaded contains the exact same data as the `students.csv` file we've practiced with.

**Read in `students.tsv`, making sure to get the `NA`s right,** **and to clean up the column names like we did above.**

<details>
<summary>
<b>Solution</b>(click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_tsv</a></span><span class='o'>(</span><span class='s'>"students.tsv"</span>, na <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"N/A"</span>, <span class='s'>""</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>|&gt;</span></span>
<span>  <span class='nf'>janitor</span><span class='nf'>::</span><span class='nf'><a href='https://sfirke.github.io/janitor/reference/clean_names.html'>clean_names</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='font-weight: bold;'>Rows: </span><span style='color: #0000BB;'>6</span> <span style='font-weight: bold;'>Columns: </span><span style='color: #0000BB;'>5</span></span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>──</span> <span style='font-weight: bold;'>Column specification</span> <span style='color: #00BBBB;'>────────────────────────────────────────────────────────</span></span></span>
<span><span class='c'>#&gt; <span style='font-weight: bold;'>Delimiter:</span> "\t"</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>chr</span> (4): Full Name, favourite.food, mealPlan, AGE</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>dbl</span> (1): Student ID</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> Use `spec()` to retrieve the full column specification for this data.</span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> Specify the column types or set `show_col_types = FALSE` to quiet this message.</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 5</span></span></span>
<span><span class='c'>#&gt;   student_id full_name        favourite_food     meal_plan           age  </span></span>
<span><span class='c'>#&gt;        <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>               <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span>          1 Sunil Huffmann   Strawberry yoghurt Lunch only          4    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span>          2 Barclay Lynn     French fries       Lunch only          5    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span>          3 Jayendra Lyne    <span style='color: #BB0000;'>NA</span>                 Breakfast and lunch 7    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span>          4 Leon Rossini     Anchovies          Lunch only          <span style='color: #BB0000;'>NA</span>   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span>          5 Chidiegwu Dunkel Pizza              Breakfast and lunch five </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span>          6 Güvenç Attila    Ice cream          Lunch only          6</span></span></code></pre>

</div>

</details>

</div>

</div>

<br>

<div class="puzzle">

<div>

### Exercise 2: A challenging file

Start by downloading a new CSV file:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>url_tsv</span> <span class='o'>&lt;-</span> <span class='s'>"https://github.com/biodash/biodash.github.io/raw/master/content/codeclub/S05E05/exercise2.csv"</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>url_tsv</span>, destfile <span class='o'>=</span> <span class='s'>"exercise2.csv"</span><span class='o'>)</span></span></code></pre>

</div>

Now, try reading in this `exercise2.csv` file, which has the following content:

    # This file is still incomplete
    1,Sunil Huffmann,Strawberry yoghurt,Lunch only,4
    2,Barclay Lynn,French fries,Lunch only,5
    3,Jayendra Lyne,N/A,Breakfast and lunch,7
    4,Leon Rossini,Anchovies,Lunch only,
    5,Chidiegwu Dunkel,Pizza,Breakfast and lunch,five
    6,Güvenç Attila,Ice cream,Lunch only,6
    % More data will be entered soon!

<details>
<summary>
<b>Hints</b>(click here)
</summary>

<br>

-   Notice that there are metadata / comment lines both at the start and the end of the file!

-   You cannot specify multiple `comment` symbols to [`read_csv()`](https://readr.tidyverse.org/reference/read_delim.html), so you'll have to use both the `skip` *and* `comment` arguments.

-   You'll also want to take care of the fact that there is no line with column names.

</details>

<br>

<details>
<summary>
<b>Solution</b>(click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_csv</a></span><span class='o'>(</span><span class='s'>"exercise2.csv"</span>, skip <span class='o'>=</span> <span class='m'>1</span>, comment <span class='o'>=</span> <span class='s'>"%"</span>, col_names <span class='o'>=</span> <span class='kc'>FALSE</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='font-weight: bold;'>Rows: </span><span style='color: #0000BB;'>6</span> <span style='font-weight: bold;'>Columns: </span><span style='color: #0000BB;'>5</span></span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>──</span> <span style='font-weight: bold;'>Column specification</span> <span style='color: #00BBBB;'>────────────────────────────────────────────────────────</span></span></span>
<span><span class='c'>#&gt; <span style='font-weight: bold;'>Delimiter:</span> ","</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>chr</span> (4): X2, X3, X4, X5</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>dbl</span> (1): X1</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> Use `spec()` to retrieve the full column specification for this data.</span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> Specify the column types or set `show_col_types = FALSE` to quiet this message.</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 5</span></span></span>
<span><span class='c'>#&gt;      X1 X2               X3                 X4                  X5   </span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>               <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span>     1 Sunil Huffmann   Strawberry yoghurt Lunch only          4    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span>     2 Barclay Lynn     French fries       Lunch only          5    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span>     3 Jayendra Lyne    N/A                Breakfast and lunch 7    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span>     4 Leon Rossini     Anchovies          Lunch only          <span style='color: #BB0000;'>NA</span>   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span>     5 Chidiegwu Dunkel Pizza              Breakfast and lunch five </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span>     6 Güvenç Attila    Ice cream          Lunch only          6</span></span></code></pre>

</div>

Or, with descriptive column names:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>student_colnames</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"student_id"</span>, <span class='s'>"full_name"</span>, <span class='s'>"fav_food"</span>, <span class='s'>"meal_plan"</span>, <span class='s'>"age"</span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_csv</a></span><span class='o'>(</span><span class='s'>"exercise2.csv"</span>, skip <span class='o'>=</span> <span class='m'>1</span>, comment <span class='o'>=</span> <span class='s'>"%"</span>, col_names <span class='o'>=</span> <span class='nv'>student_colnames</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='font-weight: bold;'>Rows: </span><span style='color: #0000BB;'>6</span> <span style='font-weight: bold;'>Columns: </span><span style='color: #0000BB;'>5</span></span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>──</span> <span style='font-weight: bold;'>Column specification</span> <span style='color: #00BBBB;'>────────────────────────────────────────────────────────</span></span></span>
<span><span class='c'>#&gt; <span style='font-weight: bold;'>Delimiter:</span> ","</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>chr</span> (4): full_name, fav_food, meal_plan, age</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>dbl</span> (1): student_id</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> Use `spec()` to retrieve the full column specification for this data.</span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> Specify the column types or set `show_col_types = FALSE` to quiet this message.</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 5</span></span></span>
<span><span class='c'>#&gt;   student_id full_name        fav_food           meal_plan           age  </span></span>
<span><span class='c'>#&gt;        <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>               <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span>          1 Sunil Huffmann   Strawberry yoghurt Lunch only          4    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span>          2 Barclay Lynn     French fries       Lunch only          5    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span>          3 Jayendra Lyne    N/A                Breakfast and lunch 7    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span>          4 Leon Rossini     Anchovies          Lunch only          <span style='color: #BB0000;'>NA</span>   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span>          5 Chidiegwu Dunkel Pizza              Breakfast and lunch five </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span>          6 Güvenç Attila    Ice cream          Lunch only          6</span></span></code></pre>

</div>

</details>

</div>

</div>

<br>

<div class="puzzle">

<div>

### Bonus: reading an Excel file

In this exercise, you'll use a function from the *readxl* package to read an Excel file. We need to do a couple of things to get set up first.

-   You can install and then load the *readxl* package as follows:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"readxl"</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://readxl.tidyverse.org'>readxl</a></span><span class='o'>)</span></span></code></pre>

</div>

-   You can download the excel file as follows:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>url_xls</span> <span class='o'>&lt;-</span> <span class='s'>"https://github.com/biodash/biodash.github.io/raw/master/content/codeclub/S05E05/breed_ranks.xlsx"</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>url_xls</span>, destfile <span class='o'>=</span> <span class='s'>"students.xls"</span><span class='o'>)</span></span></code></pre>

</div>

Now, use the [`read_excel()`](https://readxl.tidyverse.org/reference/read_excel.html) function from the *readxl* package to read the `breed_ranks.xlsx` file.

Bonus<sup>2</sup>: There are two sheets, `Sheet1` and `Sheet2`. Can you read both in? And can you combine the resulting dataframes into a single one?

<details>
<summary>
<b>Hints</b>(click here)
</summary>

<br>

-   Take a look at the [`read_excel()`](https://readxl.tidyverse.org/reference/read_excel.html) help page (e.g., type [`?read_excel`](https://readxl.tidyverse.org/reference/read_excel.html) in the R console) to figure out the syntax.

-   When you don't specify the `sheet` argument, it will read in the first one.

-   You can "vertically" combine dataframes using the [`bind_rows()`](https://dplyr.tidyverse.org/reference/bind_rows.html) function.

</details>

<br>

<details>
<summary>
<b>Solution</b>(click here)
</summary>

<br>

You can read the first sheet with:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>breed_ranks</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://readxl.tidyverse.org/reference/read_excel.html'>read_excel</a></span><span class='o'>(</span><span class='s'>"breed_ranks.xlsx"</span><span class='o'>)</span></span>
<span></span>
<span><span class='c'># Or, equivalently:</span></span>
<span><span class='c'>#breed_ranks &lt;- read_excel("breed_ranks.xlsx", sheet = 1)</span></span></code></pre>

</div>

You can read the second sheet with:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>breed_ranks2</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://readxl.tidyverse.org/reference/read_excel.html'>read_excel</a></span><span class='o'>(</span><span class='s'>"breed_ranks.xlsx"</span>, sheet <span class='o'>=</span> <span class='m'>2</span><span class='o'>)</span></span></code></pre>

</div>

You can combine the two dataframes with:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>breed_ranks_all</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/bind_rows.html'>bind_rows</a></span><span class='o'>(</span><span class='nv'>breed_ranks</span>, <span class='nv'>breed_ranks2</span><span class='o'>)</span></span></code></pre>

</div>

Let's check the numbers of rows:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='nv'>breed_ranks</span><span class='o'>)</span> <span class='c'># From sheet 1</span></span>
<span><span class='c'>#&gt; [1] 100</span></span><span></span>
<span><span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='nv'>breed_ranks2</span><span class='o'>)</span> <span class='c'># From sheet 2</span></span>
<span><span class='c'>#&gt; [1] 94</span></span><span></span>
<span><span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='nv'>breed_ranks_all</span><span class='o'>)</span> <span class='c'># Both combined</span></span>
<span><span class='c'>#&gt; [1] 194</span></span></code></pre>

</div>

Let's take a look at the first few rows:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>breed_ranks_all</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 22</span></span></span>
<span><span class='c'>#&gt;   Breed    2013 …¹ 2014 …² 2015 …³ 2016 …⁴ 2017 …⁵ 2018 …⁶ 2019 …⁷ 2020 …⁸ links</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Retriev… 1       1       1       1       1       1       1             1 http…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> French … 11      9       6       6       4       4       4             2 http…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> German … 2       2       2       2       2       2       2             3 http…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> Retriev… 3       3       3       3       3       3       3             4 http…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> Bulldogs 5       4       4       4       5       5       5             5 http…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> Poodles  8       7       8       7       7       7       6             6 http…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 12 more variables: Image &lt;chr&gt;, `Setters (English)` &lt;chr&gt;, `91` &lt;chr&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   `89` &lt;chr&gt;, `96` &lt;chr&gt;, `102` &lt;chr&gt;, `95` &lt;chr&gt;, `94` &lt;chr&gt;, `100` &lt;chr&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   `101` &lt;dbl&gt;, `https://www.akc.org/dog-breeds/english-setter/` &lt;chr&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   `https://www.akc.org/wp-content/uploads/2017/11/English-Setter-Illo-2.jpg` &lt;chr&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   and abbreviated variable names ¹​`2013 Rank`, ²​`2014 Rank`, ³​`2015 Rank`,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   ⁴​`2016 Rank`, ⁵​`2017 Rank`, ⁶​`2018 Rank`, ⁷​`2019 Rank`, ⁸​`2020 Rank`</span></span></span></code></pre>

</div>

</details>

</div>

</div>

</div>
</div>

<br>

------------------------------------------------------------------------

<br>

