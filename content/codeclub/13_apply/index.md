---
title: "Session 13: Applying The Apply Functions"
subtitle: "Using the `apply()` functions of base R as an alternative to loops."
summary: "In this session of Code Club, we'll consider the `apply()` family of functions, which can often be used as efficient alternatives to writing some of the loops we worked with in the previous session."  
authors: [mike-sovic]
date: "2021-03-09"
output: hugodown::md_document
toc: true

image: 
  caption: "Image by ?"
  focal_point: ""
  preview_only: false

rmd_hash: 8e91edf80966a1ff

---

------------------------------------------------------------------------

## Session Goals

-   List the functions in the [`apply()`](https://rdrr.io/r/base/apply.html) family of functions from base R.
-   Describe how the [`apply()`](https://rdrr.io/r/base/apply.html) functions relate to loops in R.
-   Identify the input and output formats associated with different [`apply()`](https://rdrr.io/r/base/apply.html) functions.
-   Identify appropriate [`apply()`](https://rdrr.io/r/base/apply.html) functions for different scenarios.
-   Use [`apply()`](https://rdrr.io/r/base/apply.html) functions to explore some US state temperature data.

------------------------------------------------------------------------

## Intro: The `apply()` Functions

R is sometimes referred to as a functional programming language, and the [`apply()`](https://rdrr.io/r/base/apply.html) family of functions from base R is an example of this functional programming. Let's first take a look at some available functions - they include...

-   [`apply()`](https://rdrr.io/r/base/apply.html)
-   [`lapply()`](https://rdrr.io/r/base/lapply.html)
-   [`sapply()`](https://rdrr.io/r/base/lapply.html)
-   [`tapply()`](https://rdrr.io/r/base/tapply.html)
-   [`mapply()`](https://rdrr.io/r/base/mapply.html)

Last week in [session 12](https://biodash.github.io/codeclub/12_loops/), Jelmer introduced for loops as one method for iterating over some set of things in R. Let's briefly revisit one of his examples. First, we'll recreate his distance dataset...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#distance data (km) for two dates</span>
<span class='nv'>dists_Mar4</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>17</span>, <span class='m'>93</span>, <span class='m'>56</span>, <span class='m'>19</span>, <span class='m'>175</span>, <span class='m'>40</span>, <span class='m'>69</span>, <span class='m'>267</span>, <span class='m'>4</span>, <span class='m'>91</span><span class='o'>)</span>
<span class='nv'>dists_Mar5</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>87</span>, <span class='m'>143</span>, <span class='m'>103</span>, <span class='m'>223</span>, <span class='m'>106</span>, <span class='m'>18</span>, <span class='m'>87</span>, <span class='m'>72</span>, <span class='m'>59</span>, <span class='m'>5</span><span class='o'>)</span>

<span class='nv'>dist_df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/data.frame.html'>data.frame</a></span><span class='o'>(</span><span class='nv'>dists_Mar4</span>, <span class='nv'>dists_Mar5</span><span class='o'>)</span>

<span class='c'>#view the data frame</span>
<span class='nv'>dist_df</span>

<span class='c'>#&gt;    dists_Mar4 dists_Mar5</span>
<span class='c'>#&gt; 1          17         87</span>
<span class='c'>#&gt; 2          93        143</span>
<span class='c'>#&gt; 3          56        103</span>
<span class='c'>#&gt; 4          19        223</span>
<span class='c'>#&gt; 5         175        106</span>
<span class='c'>#&gt; 6          40         18</span>
<span class='c'>#&gt; 7          69         87</span>
<span class='c'>#&gt; 8         267         72</span>
<span class='c'>#&gt; 9           4         59</span>
<span class='c'>#&gt; 10         91          5</span>
</code></pre>

</div>

As he showed, one way to get the median distance traveled for each day (column) is to iterate over each column with a for loop, applying the [`median()`](https://rdrr.io/r/stats/median.html) function to each one...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#create object to store the loop output</span>
<span class='nv'>column_medians</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/vector.html'>vector</a></span><span class='o'>(</span>length <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>ncol</a></span><span class='o'>(</span><span class='nv'>dist_df</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#for loop to calculate median for each column</span>
<span class='kr'>for</span> <span class='o'>(</span><span class='nv'>column_number</span> <span class='kr'>in</span> <span class='m'>1</span><span class='o'>:</span><span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>ncol</a></span><span class='o'>(</span><span class='nv'>dist_df</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>&#123;</span>
  
  <span class='c'>## We extract one column using "dataframe_name[[column_number]]":</span>
  <span class='nv'>column_median</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/median.html'>median</a></span><span class='o'>(</span><span class='nv'>dist_df</span><span class='o'>[[</span><span class='nv'>column_number</span><span class='o'>]</span><span class='o'>]</span><span class='o'>)</span>
  
  <span class='c'>## We add the single-column median to its associated position</span>
  <span class='c'>## in the vector:</span>
  <span class='nv'>column_medians</span><span class='o'>[</span><span class='nv'>column_number</span><span class='o'>]</span> <span class='o'>&lt;-</span> <span class='nv'>column_median</span>
<span class='o'>&#125;</span>

<span class='c'>#view the result</span>
<span class='nv'>column_medians</span>

<span class='c'>#&gt; [1] 62.5 87.0</span>
</code></pre>

</div>

Let's think of this loop as the "programming" part of the functional programming I mentioned earlier - we've written, or programmed, some code the computer will execute for us.

Unless you're brand new to R, you've probably realized by now that there are a few data structures you find yourself working with pretty frequently. These include data frames, matrices, and lists. Not only do these get used a lot, but there are also certain operations that get performed pretty frequently on each of those types of objects. For example, doing something like iterating over either the rows or columns of a data frame and applying some function to each, like we did with the median function in the data frame above, is pretty common. That means lots of people would end up independently writing for loops that would look a lot like the one in our example. This is where the "functional" part of "functional programming" comes in. Instead of everyone independently writing that same basic loop over and over, it can be written one time in a general form and packaged into a function that can be called instead. And this is what the [`apply()`](https://rdrr.io/r/base/apply.html) functions do. Let's take a look at some examples.

<br>

------------------------------------------------------------------------

## Examples

### `apply()`

We'll start with the [`apply()`](https://rdrr.io/r/base/apply.html) function. It allows us to iterativey apply some function to the margins (rows or columns) of an object that has row x column structure. There are three arguments that have to be passed to [`apply()`](https://rdrr.io/r/base/apply.html) - the object containing the data, the margin the function will be applied to (rows are designated with '1', columns with '2'), and the function of interest.

In the example above, we used a loop to apply the [`median()`](https://rdrr.io/r/stats/median.html) function to each column of the data frame. Here, we'll do the same thing with [`apply()`](https://rdrr.io/r/base/apply.html)...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>apply_out</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/apply.html'>apply</a></span><span class='o'>(</span><span class='nv'>dist_df</span>, <span class='m'>2</span>, <span class='nv'>median</span><span class='o'>)</span>

<span class='c'>#view the result</span>
<span class='nv'>apply_out</span>

<span class='c'>#&gt; dists_Mar4 dists_Mar5 </span>
<span class='c'>#&gt;       62.5       87.0</span>
</code></pre>

</div>

Notice how much less code it required here to do the same thing we did with the for loop above!

Notice too that the output here is a vector (specifically, a named numeric vector). The [`apply()`](https://rdrr.io/r/base/apply.html) function determined this was most appropriate in this case, since the output of each iteration consisted of a single value. Here's another scenario...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>apply_out_quantiles</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/apply.html'>apply</a></span><span class='o'>(</span><span class='nv'>dist_df</span>, 
                             <span class='m'>2</span>, 
                             <span class='nv'>quantile</span>, probs <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>0.25</span>, <span class='m'>0.5</span>, <span class='m'>0.75</span>, <span class='m'>1</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#view the result</span>
<span class='nv'>apply_out_quantiles</span>

<span class='c'>#&gt;      dists_Mar4 dists_Mar5</span>
<span class='c'>#&gt; 25%       24.25      62.25</span>
<span class='c'>#&gt; 50%       62.50      87.00</span>
<span class='c'>#&gt; 75%       92.50     105.25</span>
<span class='c'>#&gt; 100%     267.00     223.00</span>
</code></pre>

</div>

This time, the function output consisted of 4 values for each iteration, or column of the data frame. In this case, the output from apply is a matrix.

So, what about the other types of [`apply()`](https://rdrr.io/r/base/apply.html) functions? Well, the different types are designed for different types of input. For example...

### `lapply()`

Remember that [`apply()`](https://rdrr.io/r/base/apply.html) requires you to define whether you'll apply the function in a row-wise or column-wise manner. But lists aren't set up as rows and columns. So, if we want to iterate over the elements of a list, [`apply()`](https://rdrr.io/r/base/apply.html) won't work. An alternative is [`lapply()`](https://rdrr.io/r/base/lapply.html).

In the next example, we'll add some new distance data in for two additional dates. The number of observations are different this time though, so the data can't be combined in a data frame (you might remember that a data frame is a special kind of list where each of the list elements are the same length). Since we have different lengths here, we'll store the data as a list...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#create a list that includes the new distance data</span>

<span class='nv'>dists_Mar11</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>45</span>, <span class='m'>34</span>, <span class='m'>100</span>, <span class='m'>40</span>, <span class='m'>29</span>, <span class='m'>88</span>, <span class='m'>84</span>, <span class='m'>102</span><span class='o'>)</span>
<span class='nv'>dists_Mar12</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>90</span>, <span class='m'>50</span>, <span class='m'>19</span>, <span class='m'>123</span>, <span class='m'>77</span>, <span class='m'>13</span>, <span class='m'>70</span><span class='o'>)</span>

<span class='nv'>dist_ls</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='nv'>dists_Mar4</span>, <span class='nv'>dists_Mar5</span>, <span class='nv'>dists_Mar11</span>, <span class='nv'>dists_Mar12</span><span class='o'>)</span>

<span class='c'>#view the list</span>
<span class='nv'>dist_ls</span>

<span class='c'>#&gt; [[1]]</span>
<span class='c'>#&gt;  [1]  17  93  56  19 175  40  69 267   4  91</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[2]]</span>
<span class='c'>#&gt;  [1]  87 143 103 223 106  18  87  72  59   5</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[3]]</span>
<span class='c'>#&gt; [1]  45  34 100  40  29  88  84 102</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[4]]</span>
<span class='c'>#&gt; [1]  90  50  19 123  77  13  70</span>
</code></pre>

</div>

Now we'll apply the [`median()`](https://rdrr.io/r/stats/median.html) function to each element of the list. Again, we could write a for loop to iterate over each list element, but [`lapply()`](https://rdrr.io/r/base/lapply.html) will do the same thing with much less code to write...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>lapply_out</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/lapply.html'>lapply</a></span><span class='o'>(</span><span class='nv'>dist_ls</span>, <span class='nv'>median</span><span class='o'>)</span>

<span class='c'>#view the output</span>
<span class='nv'>lapply_out</span>

<span class='c'>#&gt; [[1]]</span>
<span class='c'>#&gt; [1] 62.5</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[2]]</span>
<span class='c'>#&gt; [1] 87</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[3]]</span>
<span class='c'>#&gt; [1] 64.5</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[4]]</span>
<span class='c'>#&gt; [1] 70</span>
</code></pre>

</div>

This time, the output is a list - [`lapply()`](https://rdrr.io/r/base/lapply.html) always gives output in list format. But in this specific case, the output could just as easily (and maybe more simply) be stored as a vector of four values - one for each list element. [`sapply()`](https://rdrr.io/r/base/lapply.html) is an alternative to [`lapply()`](https://rdrr.io/r/base/lapply.html) that, like [`lapply()`](https://rdrr.io/r/base/lapply.html) still works on list input, but that attempts to simplify the output where possible...

### `sapply()`

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>sapply_out</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/lapply.html'>sapply</a></span><span class='o'>(</span><span class='nv'>dist_ls</span>, <span class='nv'>median</span><span class='o'>)</span>

<span class='c'>#view the output</span>
<span class='nv'>sapply_out</span>

<span class='c'>#&gt; [1] 62.5 87.0 64.5 70.0</span>
</code></pre>

</div>

Those three: [`apply()`](https://rdrr.io/r/base/apply.html), [`lapply()`](https://rdrr.io/r/base/lapply.html), and [`sapply()`](https://rdrr.io/r/base/lapply.html) are the apply functions you'll likely encounter most frequently, but there are others that apply in more specific cases - we'll take a look at at least one more later in the Bonus section.

<br>

## Breakout Rooms

We'll work with a new temperature dataset for the Breakout Room Exercises. I've filtered and cleaned these data from the original dataset that's available from [climate.gov](ftp://ftp.ncdc.noaa.gov/pub/data/cirs/climdiv/) They consist of maximum average temperature values for three states - Colorado, Ohio, and Virginia, with years in rows and months in columns. You can download the data with this code...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>

<span class='c'>#&gt; Warning: replacing previous import 'vctrs::data_frame' by 'tibble::data_frame' when loading 'dplyr'</span>

<span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching packages</span><span> ─────────────────────────────────────── tidyverse 1.3.0 ──</span></span>

<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>ggplot2</span><span> 3.3.2     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>purrr  </span><span> 0.3.4</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>tibble </span><span> 3.0.4     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>dplyr  </span><span> 1.0.0</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>tidyr  </span><span> 1.1.0     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>stringr</span><span> 1.4.0</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>readr  </span><span> 1.3.1     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>forcats</span><span> 0.5.0</span></span>

<span class='c'>#&gt; Warning: package 'ggplot2' was built under R version 3.6.2</span>

<span class='c'>#&gt; Warning: package 'tibble' was built under R version 3.6.2</span>

<span class='c'>#&gt; Warning: package 'tidyr' was built under R version 3.6.2</span>

<span class='c'>#&gt; Warning: package 'purrr' was built under R version 3.6.2</span>

<span class='c'>#&gt; Warning: package 'dplyr' was built under R version 3.6.2</span>

<span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span><span> ────────────────────────────────────────── tidyverse_conflicts() ──</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>filter()</span><span> masks </span><span style='color: #0000BB;'>stats</span><span>::filter()</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>lag()</span><span>    masks </span><span style='color: #0000BB;'>stats</span><span>::lag()</span></span>


<span class='nv'>temp_url</span> <span class='o'>&lt;-</span> <span class='s'>'https://raw.githubusercontent.com/biodash/biodash.github.io/master/assets/data/temperature/co_oh_va_max_temp.txt'</span>
<span class='nv'>temp_file</span> <span class='o'>&lt;-</span> <span class='s'>'state_max_temps.tsv'</span>
<span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>temp_url</span>, destfile <span class='o'>=</span> <span class='nv'>temp_file</span><span class='o'>)</span>
</code></pre>

</div>

### Exercise 1

<div class="alert puzzle">

<div>

First let's load the dataset and assign it to an object named 'maxtemps'. Then preview the dataset and determine its dimensions (number of rows and columns). As the '.tsv' extension on the file suggests, this is a tab delimited file.

<details>
<summary>
Hints (click here)
</summary>

<br> Use `read_tsv()` to load the dataset. The functions [`head()`](https://rdrr.io/r/utils/head.html) and `glimpse()` are a couple good options for previewing the data. If you don't get the dimensions from the function you preview the data with, the [`dim()`](https://rdrr.io/r/base/dim.html) function will provide this info. <br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>maxtemps</span> <span class='o'>&lt;-</span> <span class='nf'>read_tsv</span><span class='o'>(</span><span class='s'>"state_max_temps.tsv"</span><span class='o'>)</span>

<span class='c'>#&gt; Parsed with column specification:</span>
<span class='c'>#&gt; cols(</span>
<span class='c'>#&gt;   STATE = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   YEAR = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   JAN = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   FEB = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   MAR = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   APR = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   MAY = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   JUN = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   JUL = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   AUG = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   SEP = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   OCT = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   NOV = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   DEC = <span style='color: #00BB00;'>col_double()</span></span>
<span class='c'>#&gt; )</span>

<span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>maxtemps</span><span class='o'>)</span>

<span class='c'>#&gt; Rows: 378</span>
<span class='c'>#&gt; Columns: 14</span>
<span class='c'>#&gt; $ STATE <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "CO", "CO", "CO", "CO", "CO", "CO", "CO", "CO", "CO", "CO", "CO…</span></span>
<span class='c'>#&gt; $ YEAR  <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 1895, 1896, 1897, 1898, 1899, 1900, 1901, 1902, 1903, 1904, 190…</span></span>
<span class='c'>#&gt; $ JAN   <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 33.6, 41.2, 34.2, 32.6, 34.0, 40.8, 39.4, 38.4, 37.5, 36.6, 33.…</span></span>
<span class='c'>#&gt; $ FEB   <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 33.3, 41.3, 36.8, 43.4, 29.4, 39.1, 37.9, 43.2, 28.3, 47.3, 33.…</span></span>
<span class='c'>#&gt; $ MAR   <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 46.1, 44.8, 42.8, 43.5, 43.7, 51.9, 46.0, 44.3, 44.1, 51.4, 48.…</span></span>
<span class='c'>#&gt; $ APR   <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 60.8, 58.3, 55.8, 59.0, 58.7, 52.4, 55.5, 59.0, 55.6, 58.3, 53.…</span></span>
<span class='c'>#&gt; $ MAY   <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 66.5, 68.0, 70.5, 61.8, 66.5, 68.1, 67.6, 68.7, 63.8, 65.5, 61.…</span></span>
<span class='c'>#&gt; $ JUN   <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 74.0, 80.2, 77.4, 76.6, 77.2, 80.1, 76.8, 78.8, 69.8, 71.7, 77.…</span></span>
<span class='c'>#&gt; $ JUL   <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 77.7, 80.9, 82.0, 81.9, 80.2, 82.9, 86.7, 80.3, 80.9, 79.0, 79.…</span></span>
<span class='c'>#&gt; $ AUG   <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 80.0, 81.2, 79.6, 82.0, 79.8, 81.9, 80.7, 80.8, 80.3, 77.8, 81.…</span></span>
<span class='c'>#&gt; $ SEP   <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 75.7, 70.1, 75.2, 72.2, 74.9, 70.2, 72.7, 72.3, 70.0, 72.2, 73.…</span></span>
<span class='c'>#&gt; $ OCT   <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 60.3, 59.2, 59.8, 57.7, 58.0, 62.9, 63.1, 61.8, 62.4, 60.2, 57.…</span></span>
<span class='c'>#&gt; $ NOV   <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 42.3, 42.8, 48.5, 43.0, 50.5, 49.3, 52.9, 46.7, 49.7, 53.0, 48.…</span></span>
<span class='c'>#&gt; $ DEC   <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 33.9, 43.1, 33.4, 30.9, 35.0, 41.5, 38.6, 36.4, 41.8, 39.8, 35.…</span></span>

<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>maxtemps</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 378  14</span>
</code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

### Exercise 2

<div class="alert puzzle">

<div>

The dataset is currently in tibble form. This is the default object type created by the `read_tsv()` command (tidy). The apply functions are not associated with the tidyverse, and it turns out they sometimes don't work well with tibbles. So, before we go any further, let's convert the tibble to a data frame.

<details>
<summary>
Hints (click here)
</summary>

<br>

Use the [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html) function to convert the tibble to a data frame.

<br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>maxtemps</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/as.data.frame.html'>as.data.frame</a></span><span class='o'>(</span><span class='nv'>maxtemps</span><span class='o'>)</span>
<span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>maxtemps</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "data.frame"</span>
</code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

### Exercise 3

<div class="alert puzzle">

<div>

Calculate the average temperature for each month across the whole dataset (using the data for all three states together).

<details>
<summary>
Hints (click here)
</summary>

<br> Choose the appropriate function from the [`apply()`](https://rdrr.io/r/base/apply.html) family of functions and use the [`mean()`](https://rdrr.io/r/base/mean.html) function to calculate the mean value for each column of temperatures in the dataset (cols 3 through 14). Remember that when you're designating the margin to apply the function to, '1' means rows and '2' means columns. <br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>mean_monthly</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/apply.html'>apply</a></span><span class='o'>(</span><span class='nv'>maxtemps</span><span class='o'>[</span>,<span class='m'>3</span><span class='o'>:</span><span class='m'>14</span><span class='o'>]</span>, <span class='m'>2</span>, <span class='nv'>mean</span><span class='o'>)</span>

<span class='c'>#view results</span>
<span class='nv'>mean_monthly</span>

<span class='c'>#&gt;      JAN      FEB      MAR      APR      MAY      JUN      JUL      AUG </span>
<span class='c'>#&gt; 38.89206 41.93598 50.73148 61.35608 71.26111 79.95503 84.17460 82.23571 </span>
<span class='c'>#&gt;      SEP      OCT      NOV      DEC </span>
<span class='c'>#&gt; 75.92857 64.56296 51.49921 41.11508</span>
</code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

### Exercise 4

<div class="alert puzzle">

<div>

Now let's get the average annual (max) temperatures for Ohio for all the years available in the dataset (1895-2020). Then view the temperatures for the first 5 years of the dataset (1895-1899).

<details>
<summary>
Hints (click here)
</summary>

<br> Use the same [`apply()`](https://rdrr.io/r/base/apply.html) and [`mean()`](https://rdrr.io/r/base/mean.html) functions as above, but this time, filter the dataset for just the "OH" entries, and also apply the function by rows. Remember that a two-dimensional object like a data frame or matrix is indexed with the form \[rows, columns\]. Alternatively, you can use tidy notation (i.e. filter, select). Then index the resulting vector with the square bracket notation [(Session 9)](https://biodash.github.io/codeclub/09_subsetting/) to get the first five items.<br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#base R indexing...</span>
<span class='nv'>mean_annual_oh</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/apply.html'>apply</a></span><span class='o'>(</span><span class='nv'>maxtemps</span><span class='o'>[</span><span class='nv'>maxtemps</span><span class='o'>$</span><span class='nv'>STATE</span> <span class='o'>==</span> <span class='s'>"OH"</span>, <span class='m'>3</span><span class='o'>:</span><span class='m'>14</span><span class='o'>]</span>, <span class='m'>1</span>, <span class='nv'>mean</span><span class='o'>)</span>

<span class='c'>#OR </span>

<span class='c'>#a more tidy approach (actually a hybrid approach here - the apply function is still base R)...</span>
<span class='nv'>mean_annual_oh</span> <span class='o'>&lt;-</span> <span class='nv'>maxtemps</span> <span class='o'>%&gt;%</span> 
                  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>STATE</span> <span class='o'>==</span> <span class='s'>"OH"</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
                  <span class='nf'>select</span><span class='o'>(</span><span class='m'>3</span><span class='o'>:</span><span class='m'>14</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
                  <span class='nf'><a href='https://rdrr.io/r/base/apply.html'>apply</a></span><span class='o'>(</span><span class='m'>1</span>, <span class='nv'>mean</span><span class='o'>)</span>

<span class='c'>#get first 5 items</span>
<span class='nv'>mean_annual_oh</span><span class='o'>[</span><span class='m'>1</span><span class='o'>:</span><span class='m'>5</span><span class='o'>]</span>

<span class='c'>#&gt; [1] 60.23333 60.74167 61.20833 61.42500 61.59167</span>
</code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

### Bonus 1

<div class="alert puzzle">

<div>

What if we wanted to compare the mean max July temperatures for each of the three states? Use an appropriate [`apply()`](https://rdrr.io/r/base/apply.html) function to calculate the mean values for July separately for CO, OH, and VA.

<details>
<summary>
Hints (click here)
</summary>

<br> [`tapply()`](https://rdrr.io/r/base/tapply.html) allows you to apply a function to subsets of a vector that are defined by a set of grouping variables (factors). Check the help page for [`tapply()`](https://rdrr.io/r/base/tapply.html) and use the "STATE" column as the grouping factor. <br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/tapply.html'>tapply</a></span><span class='o'>(</span><span class='nv'>maxtemps</span><span class='o'>[</span>,<span class='s'>"JUL"</span><span class='o'>]</span>, <span class='nv'>maxtemps</span><span class='o'>$</span><span class='nv'>STATE</span>, <span class='nv'>mean</span><span class='o'>)</span>

<span class='c'>#&gt;       CO       OH       VA </span>
<span class='c'>#&gt; 82.25238 84.53810 85.73333</span>
</code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

### Bonus 2

<div class="alert puzzle">

<div>

Now, instead of focusing on just July, let's try to get the average max temperatures for each month for each of the three states separately.

<details>
<summary>
Hint 1 (click here)
</summary>

<br> The [`tapply()`](https://rdrr.io/r/base/tapply.html) function we used in Exercise 4 only works when the input is a single vector. Look toward the end of the [`tapply()`](https://rdrr.io/r/base/tapply.html) documentation for a suggested related function that might apply here. <br>

</details>
<details>
<summary>
Hint 2 (click here)
</summary>

<br> Give the [`aggregate()`](https://rdrr.io/r/stats/aggregate.html) function a try. Notice that the grouping variable (the "by" argument in the function) has to be provided in the form of a list. <br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/stats/aggregate.html'>aggregate</a></span><span class='o'>(</span><span class='nv'>maxtemps</span><span class='o'>[</span>,<span class='m'>3</span><span class='o'>:</span><span class='m'>14</span><span class='o'>]</span>, by <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='nv'>maxtemps</span><span class='o'>$</span><span class='nv'>STATE</span><span class='o'>)</span>, <span class='nv'>mean</span><span class='o'>)</span>

<span class='c'>#&gt;   Group.1      JAN      FEB      MAR      APR      MAY      JUN      JUL</span>
<span class='c'>#&gt; 1      CO 36.85238 40.45952 47.44444 56.49762 66.00952 76.75238 82.25238</span>
<span class='c'>#&gt; 2      OH 35.15476 37.99444 48.45238 61.05714 72.28571 80.70000 84.53810</span>
<span class='c'>#&gt; 3      VA 44.66905 47.35397 56.29762 66.51349 75.48810 82.41270 85.73333</span>
<span class='c'>#&gt;        AUG      SEP      OCT      NOV      DEC</span>
<span class='c'>#&gt; 1 79.99286 72.51508 60.87381 47.09365 37.73333</span>
<span class='c'>#&gt; 2 82.60952 76.72619 64.47778 50.32698 38.54365</span>
<span class='c'>#&gt; 3 84.10476 78.54444 68.33730 57.07698 47.06825</span>
</code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

## Purr: An Alternative (Tidy) Approach To `apply()` Functions

In the second exercise, we converted back from a tibble to a data frame, as the [`apply()`](https://rdrr.io/r/base/apply.html) functions we've worked with here are part of base R, and some aren't compatible with tibbles. It's worth mentioning that there are *tidy* alternatives to the apply functions - they're part of the *purr* package, which might be the topic of a future code club session. We decided to go with [`apply()`](https://rdrr.io/r/base/apply.html) in this session since there were a couple requests for it, and it still does get used enough that you're likely to at least run across it, even if you don't use it yourself. For now though, if you want more details on *purr* you can find them [here](https://purrr.tidyverse.org/).

------------------------------------------------------------------------

