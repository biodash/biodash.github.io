---
output: hugodown::md_document
title: "S04E12: R for Data Science - Chapter 5.5: mutate"
subtitle: "Data Transformation with _dplyr_, part IV: `mutate()`"
summary: "Today we will cover the mutate() function to create new columns in dataframes. While this function itself is simple enough, we will get to see some interesting data manipulation techniques and operators such as those for integer division and remainder."
authors: [stephen-opiyo]
tags: [codeclub, r4ds]
date: "2022-10-26"
lastmod: "2022-10-26"
toc: true
rmd_hash: a28a00716db10838

---

<figure>
<p align="center">
<img src=img/mutate.jpeg width="70%">
<figcaption>
Artwork by Allison Horst
</figcaption>
</p>
</figure>

------------------------------------------------------------------------

## Introduction

Today we are going to cover the dplyr function [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html). You can today's topic in the R 4 Data Science book at: <https://r4ds.had.co.nz/transform.html#add-new-variables-with-mutate>.

We will again be using the `nycflights13` and `tidyverse` packages, so we first need make sure these packages are installed, and then load them for the current session by doing [`library()`](https://rdrr.io/r/base/library.html) commands:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>## Only if you haven't done so before, install the packages</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"tidyverse"</span><span class='o'>)</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"nycflights13"</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>## Load the packages</span></span>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span></span>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/hadley/nycflights13'>nycflights13</a></span><span class='o'>)</span></span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## The `mutate()` function

The [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) function always *adds* new columns at the end of your dataset. Let us create a small dataset so we can see the new variables:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights_sml</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nv'>flights</span>, </span>
<span>  <span class='nv'>year</span><span class='o'>:</span><span class='nv'>day</span>, </span>
<span>  <span class='nf'><a href='https://tidyselect.r-lib.org/reference/starts_with.html'>ends_with</a></span><span class='o'>(</span><span class='s'>"delay"</span><span class='o'>)</span>, </span>
<span>  <span class='nv'>distance</span>, </span>
<span>  <span class='nv'>air_time</span></span>
<span><span class='o'>)</span></span></code></pre>

</div>

As a first example, let's add columns `gain` (delay made up) and `speed`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 9</span></span></span>
<span><span class='c'>#&gt;     year month   day dep_delay arr_delay distance air_time  gain speed</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>  <span style='text-decoration: underline;'>2</span>013     1     1         2        11     <span style='text-decoration: underline;'>1</span>400      227    -<span style='color: #BB0000;'>9</span>  370.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>  <span style='text-decoration: underline;'>2</span>013     1     1         4        20     <span style='text-decoration: underline;'>1</span>416      227   -<span style='color: #BB0000;'>16</span>  374.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>  <span style='text-decoration: underline;'>2</span>013     1     1         2        33     <span style='text-decoration: underline;'>1</span>089      160   -<span style='color: #BB0000;'>31</span>  408.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>  <span style='text-decoration: underline;'>2</span>013     1     1        -<span style='color: #BB0000;'>1</span>       -<span style='color: #BB0000;'>18</span>     <span style='text-decoration: underline;'>1</span>576      183    17  517.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>  <span style='text-decoration: underline;'>2</span>013     1     1        -<span style='color: #BB0000;'>6</span>       -<span style='color: #BB0000;'>25</span>      762      116    19  394.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>  <span style='text-decoration: underline;'>2</span>013     1     1        -<span style='color: #BB0000;'>4</span>        12      719      150   -<span style='color: #BB0000;'>16</span>  288.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>  <span style='text-decoration: underline;'>2</span>013     1     1        -<span style='color: #BB0000;'>5</span>        19     <span style='text-decoration: underline;'>1</span>065      158   -<span style='color: #BB0000;'>24</span>  404.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>  <span style='text-decoration: underline;'>2</span>013     1     1        -<span style='color: #BB0000;'>3</span>       -<span style='color: #BB0000;'>14</span>      229       53    11  259.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>  <span style='text-decoration: underline;'>2</span>013     1     1        -<span style='color: #BB0000;'>3</span>        -<span style='color: #BB0000;'>8</span>      944      140     5  405.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>  <span style='text-decoration: underline;'>2</span>013     1     1        -<span style='color: #BB0000;'>2</span>         8      733      138   -<span style='color: #BB0000;'>10</span>  319.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows</span></span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span><span class='nv'>flights_sml</span>,</span>
<span>  gain <span class='o'>=</span> <span class='nv'>dep_delay</span> <span class='o'>-</span> <span class='nv'>arr_delay</span>,</span>
<span>  speed <span class='o'>=</span> <span class='nv'>distance</span> <span class='o'>/</span> <span class='nv'>air_time</span> <span class='o'>*</span> <span class='m'>60</span></span>
<span><span class='o'>)</span></span></code></pre>

</div>

[`transmute()`](https://dplyr.tidyverse.org/reference/mutate.html) is very similar to [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html), except the returned dataframe only contains the new variables that were created:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>transmute</a></span><span class='o'>(</span><span class='nv'>flights</span>,</span>
<span>  gain <span class='o'>=</span> <span class='nv'>dep_delay</span> <span class='o'>-</span> <span class='nv'>arr_delay</span>,</span>
<span>  hours <span class='o'>=</span> <span class='nv'>air_time</span> <span class='o'>/</span> <span class='m'>60</span>,</span>
<span>  gain_per_hour <span class='o'>=</span> <span class='nv'>gain</span> <span class='o'>/</span> <span class='nv'>hours</span></span>
<span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 3</span></span></span>
<span><span class='c'>#&gt;     gain hours gain_per_hour</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>    -<span style='color: #BB0000;'>9</span> 3.78          -<span style='color: #BB0000;'>2.38</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>   -<span style='color: #BB0000;'>16</span> 3.78          -<span style='color: #BB0000;'>4.23</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>   -<span style='color: #BB0000;'>31</span> 2.67         -<span style='color: #BB0000;'>11.6</span> </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>    17 3.05           5.57</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>    19 1.93           9.83</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>   -<span style='color: #BB0000;'>16</span> 2.5           -<span style='color: #BB0000;'>6.4</span> </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>   -<span style='color: #BB0000;'>24</span> 2.63          -<span style='color: #BB0000;'>9.11</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>    11 0.883         12.5 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>     5 2.33           2.14</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>   -<span style='color: #BB0000;'>10</span> 2.3           -<span style='color: #BB0000;'>4.35</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows</span></span></span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## Useful creation functions to use with mutate

Note that functions must be vectorised before use with [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html).

**Arithmetic operators:** `+` (addition), `-` (subtraction), `*` (multiplication), `/` (division), `^` (to the power)

**Modular arithmetic:** `%/%` (integer division) and `%%` (remainder). Modular arithmetic is a handy tool because it allows you to break integers up into pieces. For example:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>transmute</a></span><span class='o'>(</span><span class='nv'>flights</span>,</span>
<span>  <span class='nv'>dep_time</span>,</span>
<span>  hour <span class='o'>=</span> <span class='nv'>dep_time</span> <span class='o'><a href='https://rdrr.io/r/base/Arithmetic.html'>%/%</a></span> <span class='m'>100</span>,</span>
<span>  minute <span class='o'>=</span> <span class='nv'>dep_time</span> <span class='o'><a href='https://rdrr.io/r/base/Arithmetic.html'>%%</a></span> <span class='m'>100</span></span>
<span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 3</span></span></span>
<span><span class='c'>#&gt;    dep_time  hour minute</span></span>
<span><span class='c'>#&gt;       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>      517     5     17</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>      533     5     33</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>      542     5     42</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>      544     5     44</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>      554     5     54</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>      554     5     54</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>      555     5     55</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>      557     5     57</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>      557     5     57</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>      558     5     58</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows</span></span></span></code></pre>

</div>

**Logs:** [`log ()`](https://rdrr.io/r/base/Log.html), [`log2()`](https://rdrr.io/r/base/Log.html), [`log10()`](https://rdrr.io/r/base/Log.html). Logarithms are useful transformation for dealing with data that ranges across multiple orders of magnitude.

**Offsets:** [`lead()`](https://dplyr.tidyverse.org/reference/lead-lag.html) and `lag()`. These allow you to refer to leading or lagging values:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='o'>(</span><span class='nv'>x</span> <span class='o'>&lt;-</span> <span class='m'>1</span><span class='o'>:</span><span class='m'>10</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt;  [1]  1  2  3  4  5  6  7  8  9 10</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'>lag</span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt;  [1] NA  1  2  3  4  5  6  7  8  9</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/lead-lag.html'>lead</a></span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt;  [1]  2  3  4  5  6  7  8  9 10 NA</span></span></code></pre>

</div>

**Cumulative and rolling aggregates:** R provides functions for sums [`cumsum()`](https://rdrr.io/r/base/cumsum.html), products [`cumprod()`](https://rdrr.io/r/base/cumsum.html), mins [`cummin()`](https://rdrr.io/r/base/cumsum.html), and maxes [`cummax()`](https://rdrr.io/r/base/cumsum.html); and dplyr provides function for mean [`cummean()`](https://dplyr.tidyverse.org/reference/cumall.html).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>x</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt;  [1]  1  2  3  4  5  6  7  8  9 10</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://rdrr.io/r/base/cumsum.html'>cumsum</a></span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt;  [1]  1  3  6 10 15 21 28 36 45 55</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/cumall.html'>cummean</a></span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt;  [1] 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5</span></span></code></pre>

</div>

**Logical comparisons:** `<` (less than), `<=` (equal to or less than), `>` (greater than), `>=` (equal to or greater than), `!=` (not equal to), and `==` (equal to).

**Ranking:** [`min_rank()`](https://dplyr.tidyverse.org/reference/ranking.html) gives the smallest values the small rank, and `desc(x)` to give the largest values the smallest ranks.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>y</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1</span>, <span class='m'>2</span>, <span class='m'>2</span>, <span class='kc'>NA</span>, <span class='m'>3</span>, <span class='m'>4</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/ranking.html'>min_rank</a></span><span class='o'>(</span><span class='nv'>y</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; [1]  1  2  2 NA  4  5</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/ranking.html'>min_rank</a></span><span class='o'>(</span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/desc.html'>desc</a></span><span class='o'>(</span><span class='nv'>y</span><span class='o'>)</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; [1]  5  3  3 NA  2  1</span></span></code></pre>

</div>

There are other ranks functions, too, e.g., [`row_number()`](https://dplyr.tidyverse.org/reference/ranking.html), [`dense_rank()`](https://dplyr.tidyverse.org/reference/ranking.html), [`percent_rank()`](https://dplyr.tidyverse.org/reference/ranking.html), [`cume_dist()`](https://dplyr.tidyverse.org/reference/ranking.html), [`ntile()`](https://dplyr.tidyverse.org/reference/ranking.html).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/ranking.html'>row_number</a></span><span class='o'>(</span><span class='nv'>y</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; [1]  1  2  3 NA  4  5</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/ranking.html'>dense_rank</a></span><span class='o'>(</span><span class='nv'>y</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; [1]  1  2  2 NA  3  4</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/ranking.html'>percent_rank</a></span><span class='o'>(</span><span class='nv'>y</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; [1] 0.00 0.25 0.25   NA 0.75 1.00</span></span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## Breakout room exercises

These correspond to the [exercises in the R4DS book](https://r4ds.had.co.nz/transform.html#exercises-11), but we're skipping exercises 2 and 6.

### R4DS Exercise 1

Currently `dep_time` and `sched_dep_time` are convenient to look at, but hard to compute with because they're not really continuous numbers. Convert them to a more convenient representation of number of minutes since midnight.

<details>
<summary>
<b>Hints</b> (click here)
</summary>

<br>

-   You can use the following code structure (we first select only relevant columns to more easily check the results):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nv'>dep_time</span>, <span class='nv'>sched_dep_time</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>    <span class='nv'>flights_times</span>,</span>
<span>    dep_time_mins <span class='o'>=</span> <span class='nv'>YOUR_CODE_HERE</span>,</span>
<span>    sched_dep_time_mins <span class='o'>=</span> <span class='nv'>YOUR_CODE_HERE</span></span>
<span>    <span class='o'>)</span></span></code></pre>

</div>

-   Get the number of *hours* since midnight using `%/%` (as in the example in the book) and then convert this number to minutes.

-   Then, get the number of *minutes* past the hour using `%%` (again as in the example in the book), and add this number to the previous one to get the total number of minutes past midnight.

-   Now, you might think you're all done, but there is one remaining problem: midnight was originally represented as `2400`, which the code described above would convert to `1440` (`24 * 60`). But it should be `0` instead. This is a tricky one, but you can handle it using an additional `%%` calculation.

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

-   To handle the midnight case, use `%% 1440`: this would simply return the original value for all values below 1440, and would return `0` only for `1440` (midnight):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nv'>dep_time</span>, <span class='nv'>sched_dep_time</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>    dep_time_mins <span class='o'>=</span> <span class='o'>(</span><span class='nv'>dep_time</span> <span class='o'><a href='https://rdrr.io/r/base/Arithmetic.html'>%/%</a></span> <span class='m'>100</span> <span class='o'>*</span> <span class='m'>60</span> <span class='o'>+</span> <span class='nv'>dep_time</span> <span class='o'><a href='https://rdrr.io/r/base/Arithmetic.html'>%%</a></span> <span class='m'>100</span><span class='o'>)</span> <span class='o'><a href='https://rdrr.io/r/base/Arithmetic.html'>%%</a></span> <span class='m'>1440</span>,</span>
<span>    sched_dep_time_mins <span class='o'>=</span> <span class='o'>(</span><span class='nv'>sched_dep_time</span> <span class='o'><a href='https://rdrr.io/r/base/Arithmetic.html'>%/%</a></span> <span class='m'>100</span> <span class='o'>*</span> <span class='m'>60</span> <span class='o'>+</span> <span class='nv'>sched_dep_time</span> <span class='o'><a href='https://rdrr.io/r/base/Arithmetic.html'>%%</a></span> <span class='m'>100</span><span class='o'>)</span> <span class='o'><a href='https://rdrr.io/r/base/Arithmetic.html'>%%</a></span> <span class='m'>1440</span></span>
<span>    <span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 4</span></span></span>
<span><span class='c'>#&gt;    dep_time sched_dep_time dep_time_mins sched_dep_time_mins</span></span>
<span><span class='c'>#&gt;       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>          <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>               <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>      517            515           317                 315</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>      533            529           333                 329</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>      542            540           342                 340</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>      544            545           344                 345</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>      554            600           354                 360</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>      554            558           354                 358</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>      555            600           355                 360</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>      557            600           357                 360</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>      557            600           357                 360</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>      558            600           358                 360</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows</span></span></span></code></pre>

</div>

</details>

### R4DS Exercise 3

Compare `dep_time`, `sched_dep_time`, and `dep_delay`. How would you expect those three numbers to be related? Test if this is indeed the case.

<details>
<summary>
<b>Hints</b> (click here)
</summary>

<br>

-   We should expect `dep_delay` to equal the difference between `sched_dep_time` and `dep_time`.

-   To check this, the first step is to use your code from exercise 1 to create columns with the `sched_dep_time` and the `dep_time` in minutes past midnight.

-   Then, create a column with the difference in minutes between `sched_dep_time` and `dep_time` (e.g. called `our_delay_calc`).

-   Next, create a column with the difference between `our_delay_calc` and `dep_delay` (e.g. called `delay_diff`).

-   Finally, use [`filter()`](https://dplyr.tidyverse.org/reference/filter.html) to see if there are any rows where the `delay_diff` does not equal 0. Recall that we would expect no differences at all, if all is well. So what is going on with those rows?

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nv'>dep_time</span>, <span class='nv'>sched_dep_time</span>, <span class='nv'>dep_delay</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>    dep_time_min <span class='o'>=</span> <span class='o'>(</span><span class='nv'>dep_time</span> <span class='o'><a href='https://rdrr.io/r/base/Arithmetic.html'>%/%</a></span> <span class='m'>100</span> <span class='o'>*</span> <span class='m'>60</span> <span class='o'>+</span> <span class='nv'>dep_time</span> <span class='o'><a href='https://rdrr.io/r/base/Arithmetic.html'>%%</a></span> <span class='m'>100</span><span class='o'>)</span> <span class='o'><a href='https://rdrr.io/r/base/Arithmetic.html'>%%</a></span> <span class='m'>1440</span>,</span>
<span>    sched_dep_time_min <span class='o'>=</span> <span class='o'>(</span><span class='nv'>sched_dep_time</span> <span class='o'><a href='https://rdrr.io/r/base/Arithmetic.html'>%/%</a></span> <span class='m'>100</span> <span class='o'>*</span> <span class='m'>60</span> <span class='o'>+</span> <span class='nv'>sched_dep_time</span> <span class='o'><a href='https://rdrr.io/r/base/Arithmetic.html'>%%</a></span> <span class='m'>100</span><span class='o'>)</span> <span class='o'><a href='https://rdrr.io/r/base/Arithmetic.html'>%%</a></span> <span class='m'>1440</span>,</span>
<span>    our_delay_calc <span class='o'>=</span> <span class='nv'>dep_time_min</span> <span class='o'>-</span> <span class='nv'>sched_dep_time_min</span>,</span>
<span>    dep_delay_diff <span class='o'>=</span> <span class='nv'>our_delay_calc</span> <span class='o'>-</span> <span class='nv'>dep_delay</span></span>
<span>  <span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>dep_delay_diff</span> <span class='o'>!=</span> <span class='m'>0</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1,236 × 7</span></span></span>
<span><span class='c'>#&gt;    dep_time sched_dep_time dep_delay dep_time_min sched_dep_ti…¹ our_d…² dep_d…³</span></span>
<span><span class='c'>#&gt;       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>          <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>        <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>          <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>      848           <span style='text-decoration: underline;'>1</span>835       853          528           <span style='text-decoration: underline;'>1</span>115    -<span style='color: #BB0000;'>587</span>   -<span style='color: #BB0000; text-decoration: underline;'>1</span><span style='color: #BB0000;'>440</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>       42           <span style='text-decoration: underline;'>2</span>359        43           42           <span style='text-decoration: underline;'>1</span>439   -<span style='color: #BB0000; text-decoration: underline;'>1</span><span style='color: #BB0000;'>397</span>   -<span style='color: #BB0000; text-decoration: underline;'>1</span><span style='color: #BB0000;'>440</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>      126           <span style='text-decoration: underline;'>2</span>250       156           86           <span style='text-decoration: underline;'>1</span>370   -<span style='color: #BB0000; text-decoration: underline;'>1</span><span style='color: #BB0000;'>284</span>   -<span style='color: #BB0000; text-decoration: underline;'>1</span><span style='color: #BB0000;'>440</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>       32           <span style='text-decoration: underline;'>2</span>359        33           32           <span style='text-decoration: underline;'>1</span>439   -<span style='color: #BB0000; text-decoration: underline;'>1</span><span style='color: #BB0000;'>407</span>   -<span style='color: #BB0000; text-decoration: underline;'>1</span><span style='color: #BB0000;'>440</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>       50           <span style='text-decoration: underline;'>2</span>145       185           50           <span style='text-decoration: underline;'>1</span>305   -<span style='color: #BB0000; text-decoration: underline;'>1</span><span style='color: #BB0000;'>255</span>   -<span style='color: #BB0000; text-decoration: underline;'>1</span><span style='color: #BB0000;'>440</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>      235           <span style='text-decoration: underline;'>2</span>359       156          155           <span style='text-decoration: underline;'>1</span>439   -<span style='color: #BB0000; text-decoration: underline;'>1</span><span style='color: #BB0000;'>284</span>   -<span style='color: #BB0000; text-decoration: underline;'>1</span><span style='color: #BB0000;'>440</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>       25           <span style='text-decoration: underline;'>2</span>359        26           25           <span style='text-decoration: underline;'>1</span>439   -<span style='color: #BB0000; text-decoration: underline;'>1</span><span style='color: #BB0000;'>414</span>   -<span style='color: #BB0000; text-decoration: underline;'>1</span><span style='color: #BB0000;'>440</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>      106           <span style='text-decoration: underline;'>2</span>245       141           66           <span style='text-decoration: underline;'>1</span>365   -<span style='color: #BB0000; text-decoration: underline;'>1</span><span style='color: #BB0000;'>299</span>   -<span style='color: #BB0000; text-decoration: underline;'>1</span><span style='color: #BB0000;'>440</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>       14           <span style='text-decoration: underline;'>2</span>359        15           14           <span style='text-decoration: underline;'>1</span>439   -<span style='color: #BB0000; text-decoration: underline;'>1</span><span style='color: #BB0000;'>425</span>   -<span style='color: #BB0000; text-decoration: underline;'>1</span><span style='color: #BB0000;'>440</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>       37           <span style='text-decoration: underline;'>2</span>230       127           37           <span style='text-decoration: underline;'>1</span>350   -<span style='color: #BB0000; text-decoration: underline;'>1</span><span style='color: #BB0000;'>313</span>   -<span style='color: #BB0000; text-decoration: underline;'>1</span><span style='color: #BB0000;'>440</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 1,226 more rows, and abbreviated variable names ¹​sched_dep_time_min,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   ²​our_delay_calc, ³​dep_delay_diff</span></span></span></code></pre>

</div>

These `dep_delay_diff` values are all 1440 minutes (= 24 hours), and as you can see, these are flights that were scheduled to depart one day but left only the next day (past midnight).

So, for our `dep_time_min` and `sched_dep_time_min` to always work for calculations, they should also take dates into account -- and should e.g. be minutes past some date in the past.

</details>

### R4DS Exercise 4

Find the 10 most delayed flights using a ranking function. How do you want to handle ties? Carefully read the documentation for [`min_rank()`](https://dplyr.tidyverse.org/reference/ranking.html).

<details>
<summary>
<b>Hints</b> (click here)
</summary>

<br>

-   Use [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) to create a new column with the ranks, then arrange by this column and/or filter only top ranks to get the most delayed flights.

-   To see the differences in the handling of ties between [`row_number()`](https://dplyr.tidyverse.org/reference/ranking.html), [`min_rank()`](https://dplyr.tidyverse.org/reference/ranking.html), and [`dense_rank()`](https://dplyr.tidyverse.org/reference/ranking.html), take a look this:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://tibble.tidyverse.org/reference/tibble.html'>tibble</a></span><span class='o'>(</span>delays <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>3</span>, <span class='m'>5</span>, <span class='m'>5</span>, <span class='m'>5</span>, <span class='m'>130</span>, <span class='m'>276</span><span class='o'>)</span>,</span>
<span>       rank_rownr <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/ranking.html'>row_number</a></span><span class='o'>(</span><span class='nv'>delays</span><span class='o'>)</span>,</span>
<span>       rank_min <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/ranking.html'>min_rank</a></span><span class='o'>(</span><span class='nv'>delays</span><span class='o'>)</span>,</span>
<span>       rank_dense <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/ranking.html'>dense_rank</a></span><span class='o'>(</span><span class='nv'>delays</span><span class='o'>)</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 4</span></span></span>
<span><span class='c'>#&gt;   delays rank_rownr rank_min rank_dense</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span>      3          1        1          1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span>      5          2        2          2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span>      5          3        2          2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span>      5          4        2          2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span>    130          5        5          3</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span>    276          6        6          4</span></span></code></pre>

</div>

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nv'>dep_time</span>, <span class='nv'>sched_dep_time</span>, <span class='nv'>dep_delay</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>dep_delay_rank <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/ranking.html'>min_rank</a></span><span class='o'>(</span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/desc.html'>desc</a></span><span class='o'>(</span><span class='nv'>dep_delay</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>dep_delay_rank</span> <span class='o'>&lt;=</span> <span class='m'>10</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/arrange.html'>arrange</a></span><span class='o'>(</span><span class='nv'>dep_delay_rank</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 4</span></span></span>
<span><span class='c'>#&gt;    dep_time sched_dep_time dep_delay dep_delay_rank</span></span>
<span><span class='c'>#&gt;       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>          <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>          <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>      641            900      <span style='text-decoration: underline;'>1</span>301              1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>     <span style='text-decoration: underline;'>1</span>432           <span style='text-decoration: underline;'>1</span>935      <span style='text-decoration: underline;'>1</span>137              2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>     <span style='text-decoration: underline;'>1</span>121           <span style='text-decoration: underline;'>1</span>635      <span style='text-decoration: underline;'>1</span>126              3</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>     <span style='text-decoration: underline;'>1</span>139           <span style='text-decoration: underline;'>1</span>845      <span style='text-decoration: underline;'>1</span>014              4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>      845           <span style='text-decoration: underline;'>1</span>600      <span style='text-decoration: underline;'>1</span>005              5</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>     <span style='text-decoration: underline;'>1</span>100           <span style='text-decoration: underline;'>1</span>900       960              6</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>     <span style='text-decoration: underline;'>2</span>321            810       911              7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>      959           <span style='text-decoration: underline;'>1</span>900       899              8</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>     <span style='text-decoration: underline;'>2</span>257            759       898              9</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>      756           <span style='text-decoration: underline;'>1</span>700       896             10</span></span></code></pre>

</div>

</details>

### R4DS Exercise 5

What does `1:3 + 1:10` return? Why?

<details>
<summary>
<b>Hints</b> (click here)
</summary>

<br>

-   First, you should realize that `1:3` expands to a vector with the values `1`, `2`, and `3`, and similarly for `1:10`.

-   Many R operations are *vectorized*, which means that when pairing two vectors (including the case where one of those vectors is just a single value), the shorter vector will be recycled. In the example below, `3` is recycled and added to every single value in the vector `1:5`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='m'>3</span> <span class='o'>+</span> <span class='m'>1</span><span class='o'>:</span><span class='m'>5</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; [1] 4 5 6 7 8</span></span></code></pre>

</div>

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='m'>1</span><span class='o'>:</span><span class='m'>3</span> <span class='o'>+</span> <span class='m'>1</span><span class='o'>:</span><span class='m'>10</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; Warning in 1:3 + 1:10: longer object length is not a multiple of shorter object length</span></span><span><span class='c'>#&gt;  [1]  2  4  6  5  7  9  8 10 12 11</span></span></code></pre>

</div>

R gives a warning because the length of the longer vector isn't a multiple of the length of the shorter vector: it recycles `1:3` three times and is then left over with a single value from `1:3` to be paired with `10`. This kind of thing is usually not intended.

</details>

### Bonus exercise

You can use the [`paste0()`](https://rdrr.io/r/base/paste.html) function to combine strings of text, for instance:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>carrier</span> <span class='o'>&lt;-</span> <span class='s'>"UA"</span></span>
<span><span class='nv'>flight</span> <span class='o'>&lt;-</span> <span class='m'>1545</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/base/paste.html'>paste0</a></span><span class='o'>(</span><span class='s'>"The full flight number is: "</span>, <span class='nv'>carrier</span>, <span class='nv'>flight</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; [1] "The full flight number is: UA1545"</span></span></code></pre>

</div>

Use [`paste0()`](https://rdrr.io/r/base/paste.html) inside [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) to create a new column `flight_no` which has the full flight number (carrier followed by flight, like above) for each flight.

<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nv'>carrier</span>, <span class='nv'>flight</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>flight_no <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/paste.html'>paste0</a></span><span class='o'>(</span><span class='nv'>carrier</span>, <span class='nv'>flight</span><span class='o'>)</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 3</span></span></span>
<span><span class='c'>#&gt;    carrier flight flight_no</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> UA        <span style='text-decoration: underline;'>1</span>545 UA1545   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> UA        <span style='text-decoration: underline;'>1</span>714 UA1714   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> AA        <span style='text-decoration: underline;'>1</span>141 AA1141   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> B6         725 B6725    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> DL         461 DL461    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> UA        <span style='text-decoration: underline;'>1</span>696 UA1696   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> B6         507 B6507    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> EV        <span style='text-decoration: underline;'>5</span>708 EV5708   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> B6          79 B679     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> AA         301 AA301    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows</span></span></span></code></pre>

</div>

</details>

<br> <br>

------------------------------------------------------------------------

## Acknowledgements

We used <https://jrnold.github.io/r4ds-exercise-solutions> to provide hints and solutions for the exercises.

