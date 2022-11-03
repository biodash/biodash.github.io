---
output: hugodown::md_document
title: "S04E13: R for Data Science - Chapter 5.6: summarize"
subtitle: "The first of two parts on _dplyr_'s `summarize()` function"
summary: "Today we will introduce summarize() function. Together with group_by(), this function is extremely useful to produce summary statistics of your data by group."
authors: [mike-sovic]
tags: [codeclub, r4ds]
date: "2022-11-03"
lastmod: "2022-11-03"
toc: true
rmd_hash: 1ef3d7e5f2475716

---

------------------------------------------------------------------------

## Get the Dataset and Packages

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># Only if you haven't done so before, install the packages</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"tidyverse"</span><span class='o'>)</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"nycflights13"</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># Load the flights dataset and tidyverse</span></span>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/hadley/nycflights13'>nycflights13</a></span><span class='o'>)</span></span>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span></span></code></pre>

</div>

### Preview the Dataset

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://pillar.r-lib.org/reference/glimpse.html'>glimpse</a></span><span class='o'>(</span><span class='nv'>flights</span><span class='o'>)</span></span><span><span class='c'>#&gt; Rows: 336,776</span></span>
<span><span class='c'>#&gt; Columns: 19</span></span>
<span><span class='c'>#&gt; $ year           <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> 2013, 2013, 2013, 2013, 2013, 2013, 2013, 2013, 2013, 2…</span></span>
<span><span class='c'>#&gt; $ month          <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…</span></span>
<span><span class='c'>#&gt; $ day            <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…</span></span>
<span><span class='c'>#&gt; $ dep_time       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> 517, 533, 542, 544, 554, 554, 555, 557, 557, 558, 558, …</span></span>
<span><span class='c'>#&gt; $ sched_dep_time <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> 515, 529, 540, 545, 600, 558, 600, 600, 600, 600, 600, …</span></span>
<span><span class='c'>#&gt; $ dep_delay      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> 2, 4, 2, -1, -6, -4, -5, -3, -3, -2, -2, -2, -2, -2, -1…</span></span>
<span><span class='c'>#&gt; $ arr_time       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> 830, 850, 923, 1004, 812, 740, 913, 709, 838, 753, 849,…</span></span>
<span><span class='c'>#&gt; $ sched_arr_time <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> 819, 830, 850, 1022, 837, 728, 854, 723, 846, 745, 851,…</span></span>
<span><span class='c'>#&gt; $ arr_delay      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> 11, 20, 33, -18, -25, 12, 19, -14, -8, 8, -2, -3, 7, -1…</span></span>
<span><span class='c'>#&gt; $ carrier        <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "UA", "UA", "AA", "B6", "DL", "UA", "B6", "EV", "B6", "…</span></span>
<span><span class='c'>#&gt; $ flight         <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> 1545, 1714, 1141, 725, 461, 1696, 507, 5708, 79, 301, 4…</span></span>
<span><span class='c'>#&gt; $ tailnum        <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "N14228", "N24211", "N619AA", "N804JB", "N668DN", "N394…</span></span>
<span><span class='c'>#&gt; $ origin         <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "EWR", "LGA", "JFK", "JFK", "LGA", "EWR", "EWR", "LGA",…</span></span>
<span><span class='c'>#&gt; $ dest           <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "IAH", "IAH", "MIA", "BQN", "ATL", "ORD", "FLL", "IAD",…</span></span>
<span><span class='c'>#&gt; $ air_time       <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> 227, 227, 160, 183, 116, 150, 158, 53, 140, 138, 149, 1…</span></span>
<span><span class='c'>#&gt; $ distance       <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> 1400, 1416, 1089, 1576, 762, 719, 1065, 229, 944, 733, …</span></span>
<span><span class='c'>#&gt; $ hour           <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> 5, 5, 5, 5, 6, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 5, 6, 6, 6…</span></span>
<span><span class='c'>#&gt; $ minute         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> 15, 29, 40, 45, 0, 58, 0, 0, 0, 0, 0, 0, 0, 0, 0, 59, 0…</span></span>
<span><span class='c'>#&gt; $ time_hour      <span style='color: #555555; font-style: italic;'>&lt;dttm&gt;</span> 2013-01-01 05:00:00, 2013-01-01 05:00:00, 2013-01-01 0…</span></span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## Review of `select()`, `filter()`, `mutate()`

### `select()`

The flights tibble has 19 variables -- to keep things simple, we'll focus on just a few of these for now. Let's choose the variables (columns) `carrier`, `flight`, `air_time`, and `dep_delay`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights_exp</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nv'>flights</span>, <span class='nv'>carrier</span>, <span class='nv'>flight</span>, <span class='nv'>air_time</span>, <span class='nv'>dep_delay</span><span class='o'>)</span></span>
<span><span class='nv'>flights_exp</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 4</span></span></span>
<span><span class='c'>#&gt;    carrier flight air_time dep_delay</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> UA        <span style='text-decoration: underline;'>1</span>545      227         2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> UA        <span style='text-decoration: underline;'>1</span>714      227         4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> AA        <span style='text-decoration: underline;'>1</span>141      160         2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> B6         725      183        -<span style='color: #BB0000;'>1</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> DL         461      116        -<span style='color: #BB0000;'>6</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> UA        <span style='text-decoration: underline;'>1</span>696      150        -<span style='color: #BB0000;'>4</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> B6         507      158        -<span style='color: #BB0000;'>5</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> EV        <span style='text-decoration: underline;'>5</span>708       53        -<span style='color: #BB0000;'>3</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> B6          79      140        -<span style='color: #BB0000;'>3</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> AA         301      138        -<span style='color: #BB0000;'>2</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows</span></span></span></code></pre>

</div>

### `filter()`

There are \>336,000 observations (flights) in this dataset. Let's reduce it to just American Airlines flights:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights_exp</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>flights_exp</span>, <span class='nv'>carrier</span> <span class='o'>==</span> <span class='s'>"AA"</span><span class='o'>)</span></span>
<span><span class='nv'>flights_exp</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 32,729 × 4</span></span></span>
<span><span class='c'>#&gt;    carrier flight air_time dep_delay</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> AA        <span style='text-decoration: underline;'>1</span>141      160         2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> AA         301      138        -<span style='color: #BB0000;'>2</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> AA         707      257        -<span style='color: #BB0000;'>1</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> AA        <span style='text-decoration: underline;'>1</span>895      152        -<span style='color: #BB0000;'>4</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> AA        <span style='text-decoration: underline;'>1</span>837      153        13</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> AA         413      192        -<span style='color: #BB0000;'>2</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> AA         303      140        -<span style='color: #BB0000;'>1</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> AA         711      248         0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> AA         305      143        -<span style='color: #BB0000;'>4</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> AA        <span style='text-decoration: underline;'>1</span>815      142        -<span style='color: #BB0000;'>3</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 32,719 more rows</span></span></span></code></pre>

</div>

### `mutate()`

The column `air_time` is measured in minutes. What if we wanted a new column `air_time_hrs` that reports the air time in hours?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights_exp</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span><span class='nv'>flights_exp</span>, air_time_hrs <span class='o'>=</span> <span class='nv'>air_time</span><span class='o'>/</span><span class='m'>60</span><span class='o'>)</span></span>
<span><span class='nv'>flights_exp</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 32,729 × 5</span></span></span>
<span><span class='c'>#&gt;    carrier flight air_time dep_delay air_time_hrs</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>        <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> AA        <span style='text-decoration: underline;'>1</span>141      160         2         2.67</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> AA         301      138        -<span style='color: #BB0000;'>2</span>         2.3 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> AA         707      257        -<span style='color: #BB0000;'>1</span>         4.28</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> AA        <span style='text-decoration: underline;'>1</span>895      152        -<span style='color: #BB0000;'>4</span>         2.53</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> AA        <span style='text-decoration: underline;'>1</span>837      153        13         2.55</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> AA         413      192        -<span style='color: #BB0000;'>2</span>         3.2 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> AA         303      140        -<span style='color: #BB0000;'>1</span>         2.33</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> AA         711      248         0         4.13</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> AA         305      143        -<span style='color: #BB0000;'>4</span>         2.38</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> AA        <span style='text-decoration: underline;'>1</span>815      142        -<span style='color: #BB0000;'>3</span>         2.37</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 32,719 more rows</span></span></span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## Section 5.6: `summarise()`

Here's an example of how to use [`summarise()`](https://dplyr.tidyverse.org/reference/summarise.html) in the simplest way. Notice the similarity in syntax with [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarise</a></span><span class='o'>(</span><span class='nv'>flights</span>, delay <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>dep_delay</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1 × 1</span></span></span>
<span><span class='c'>#&gt;   delay</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span>  12.6</span></span></code></pre>

</div>

[`summarise()`](https://dplyr.tidyverse.org/reference/summarise.html) is typically combined with [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html), calculating the new summarized variable separately for each set of grouped observations in the dataset:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>by_day</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>flights</span>, <span class='nv'>year</span>, <span class='nv'>month</span>, <span class='nv'>day</span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarise</a></span><span class='o'>(</span><span class='nv'>by_day</span>, delay <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>dep_delay</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 365 × 4</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># Groups:   year, month [12]</span></span></span>
<span><span class='c'>#&gt;     year month   day delay</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>  <span style='text-decoration: underline;'>2</span>013     1     1 11.5 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>  <span style='text-decoration: underline;'>2</span>013     1     2 13.9 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>  <span style='text-decoration: underline;'>2</span>013     1     3 11.0 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>  <span style='text-decoration: underline;'>2</span>013     1     4  8.95</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>  <span style='text-decoration: underline;'>2</span>013     1     5  5.73</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>  <span style='text-decoration: underline;'>2</span>013     1     6  7.15</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>  <span style='text-decoration: underline;'>2</span>013     1     7  5.42</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>  <span style='text-decoration: underline;'>2</span>013     1     8  2.55</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>  <span style='text-decoration: underline;'>2</span>013     1     9  2.28</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>  <span style='text-decoration: underline;'>2</span>013     1    10  2.84</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 355 more rows</span></span></span></code></pre>

</div>

And more than one new summarized variable can be calculated - here, there are 3:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>by_dest</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>flights</span>, <span class='nv'>dest</span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>delay</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarise</a></span><span class='o'>(</span><span class='nv'>by_dest</span>,</span>
<span>                   count <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/context.html'>n</a></span><span class='o'>(</span><span class='o'>)</span>,</span>
<span>                   dist <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>distance</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>,</span>
<span>                   delay <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>arr_delay</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>delay</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 105 × 4</span></span></span>
<span><span class='c'>#&gt;    dest  count  dist delay</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> ABQ     254 <span style='text-decoration: underline;'>1</span>826   4.38</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> ACK     265  199   4.85</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> ALB     439  143  14.4 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> ANC       8 <span style='text-decoration: underline;'>3</span>370  -<span style='color: #BB0000;'>2.5</span> </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> ATL   <span style='text-decoration: underline;'>17</span>215  757. 11.3 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> AUS    <span style='text-decoration: underline;'>2</span>439 <span style='text-decoration: underline;'>1</span>514.  6.02</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> AVL     275  584.  8.00</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> BDL     443  116   7.05</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> BGR     375  378   8.03</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> BHM     297  866. 16.9 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 95 more rows</span></span></span></code></pre>

</div>

Let's look a bit closer at what this is doing (note, this is not in the book):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights_sub</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nv'>flights</span>, <span class='nv'>dest</span>, <span class='nv'>distance</span>, <span class='nv'>arr_delay</span><span class='o'>)</span></span>
<span><span class='nv'>flights_sub</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 3</span></span></span>
<span><span class='c'>#&gt;    dest  distance arr_delay</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> IAH       <span style='text-decoration: underline;'>1</span>400        11</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> IAH       <span style='text-decoration: underline;'>1</span>416        20</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> MIA       <span style='text-decoration: underline;'>1</span>089        33</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> BQN       <span style='text-decoration: underline;'>1</span>576       -<span style='color: #BB0000;'>18</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> ATL        762       -<span style='color: #BB0000;'>25</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> ORD        719        12</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> FLL       <span style='text-decoration: underline;'>1</span>065        19</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> IAD        229       -<span style='color: #BB0000;'>14</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> MCO        944        -<span style='color: #BB0000;'>8</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> ORD        733         8</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows</span></span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>albuquerque_data</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>flights_sub</span>, <span class='nv'>dest</span> <span class='o'>==</span> <span class='s'>"ABQ"</span><span class='o'>)</span></span>
<span><span class='nv'>albuquerque_data</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 254 × 3</span></span></span>
<span><span class='c'>#&gt;    dest  distance arr_delay</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> ABQ       <span style='text-decoration: underline;'>1</span>826       -<span style='color: #BB0000;'>35</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> ABQ       <span style='text-decoration: underline;'>1</span>826       -<span style='color: #BB0000;'>18</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> ABQ       <span style='text-decoration: underline;'>1</span>826       -<span style='color: #BB0000;'>16</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> ABQ       <span style='text-decoration: underline;'>1</span>826        16</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> ABQ       <span style='text-decoration: underline;'>1</span>826       -<span style='color: #BB0000;'>20</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> ABQ       <span style='text-decoration: underline;'>1</span>826       -<span style='color: #BB0000;'>14</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> ABQ       <span style='text-decoration: underline;'>1</span>826       -<span style='color: #BB0000;'>15</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> ABQ       <span style='text-decoration: underline;'>1</span>826       -<span style='color: #BB0000;'>32</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> ABQ       <span style='text-decoration: underline;'>1</span>826       -<span style='color: #BB0000;'>28</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> ABQ       <span style='text-decoration: underline;'>1</span>826       -<span style='color: #BB0000;'>13</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 244 more rows</span></span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>mean_albuquerque_delay</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>albuquerque_data</span><span class='o'>$</span><span class='nv'>arr_delay</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span></span>
<span><span class='nv'>mean_albuquerque_delay</span></span><span><span class='c'>#&gt; [1] 4.38189</span></span></code></pre>

</div>

Compare the value `mean_albuquerque_delay` to that in the summarized `delay` tibble created above:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>mean_albuquerque_delay</span></span><span><span class='c'>#&gt; [1] 4.38189</span></span><span></span>
<span><span class='nv'>delay</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 105 × 4</span></span></span>
<span><span class='c'>#&gt;    dest  count  dist delay</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> ABQ     254 <span style='text-decoration: underline;'>1</span>826   4.38</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> ACK     265  199   4.85</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> ALB     439  143  14.4 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> ANC       8 <span style='text-decoration: underline;'>3</span>370  -<span style='color: #BB0000;'>2.5</span> </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> ATL   <span style='text-decoration: underline;'>17</span>215  757. 11.3 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> AUS    <span style='text-decoration: underline;'>2</span>439 <span style='text-decoration: underline;'>1</span>514.  6.02</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> AVL     275  584.  8.00</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> BDL     443  116   7.05</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> BGR     375  378   8.03</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> BHM     297  866. 16.9 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 95 more rows</span></span></span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## Breakout Exercises 1

Start with the original `flights` tibble for each of the following exercises.

### Exercise 1

<div class="alert puzzle">

<div>

Overall, which carrier had the longest mean arrival delay (*arr_delay*) in 2013? (Note, all these data are from 2013.)

<details>
<summary>
Hints (click here)
</summary>

<br>

Group the tibble by the *carrier* variable, then summarise to calculate the mean *arr_delay* for each group. Remember to ignore missing values by setting `na.rm = TRUE` within the [`mean()`](https://rdrr.io/r/base/mean.html) function.

</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>carrier_grp</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>flights</span>, <span class='nv'>carrier</span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarise</a></span><span class='o'>(</span><span class='nv'>carrier_grp</span>,</span>
<span>          mean_delay <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>arr_delay</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span><span class='o'>)</span> </span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 16 × 2</span></span></span>
<span><span class='c'>#&gt;    carrier mean_delay</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>        <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> 9E           7.38 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> AA           0.364</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> AS          -<span style='color: #BB0000;'>9.93</span> </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> B6           9.46 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> DL           1.64 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> EV          15.8  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> F9          21.9  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> FL          20.1  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> HA          -<span style='color: #BB0000;'>6.92</span> </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> MQ          10.8  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>11</span> OO          11.9  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>12</span> UA           3.56 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>13</span> US           2.13 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>14</span> VX           1.76 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>15</span> WN           9.65 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>16</span> YV          15.6</span></span></code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

### Exercise 2

<div class="alert puzzle">

<div>

Evaluate arrival delay by carrier again, but this time, evaluate only for carriers who made at least 10,000 flights.

<details>
<summary>
Hints (click here)
</summary>

<br>

Include a second variable in the summarized data from above to reflect the number of observations that went in to calculating the mean value for each group, then filter on this sample size variable. Consider using the function [`n()`](https://dplyr.tidyverse.org/reference/context.html).

</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>carrier_delays</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarise</a></span><span class='o'>(</span><span class='nv'>carrier_grp</span>,</span>
<span>                            mean_delay <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>arr_delay</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>,</span>
<span>                            n <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/context.html'>n</a></span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>carrier_delays</span>, <span class='nv'>n</span> <span class='o'>&gt;=</span> <span class='m'>10000</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 9 × 3</span></span></span>
<span><span class='c'>#&gt;   carrier mean_delay     n</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>        <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> 9E           7.38  <span style='text-decoration: underline;'>18</span>460</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> AA           0.364 <span style='text-decoration: underline;'>32</span>729</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> B6           9.46  <span style='text-decoration: underline;'>54</span>635</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> DL           1.64  <span style='text-decoration: underline;'>48</span>110</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> EV          15.8   <span style='text-decoration: underline;'>54</span>173</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> MQ          10.8   <span style='text-decoration: underline;'>26</span>397</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>7</span> UA           3.56  <span style='text-decoration: underline;'>58</span>665</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>8</span> US           2.13  <span style='text-decoration: underline;'>20</span>536</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>9</span> WN           9.65  <span style='text-decoration: underline;'>12</span>275</span></span></code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

### Exercise 3

<div class="alert puzzle">

<div>

Based on these data, what airport is the worst to fly in to with regards to arriving on time? In other words, which airport (`dest`) is associated with the highest average arrival delays?

<details>
<summary>
Hints (click here)
</summary>

<br>

Group the tibble by the `dest` variable, summarise with the mean `arr_delay` for each group, then use [`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html) to sort the new variable in descending order, which can be done with [`desc()`](https://dplyr.tidyverse.org/reference/desc.html).

</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>dest_grp</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>flights</span>, <span class='nv'>dest</span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>dest_delays</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarise</a></span><span class='o'>(</span><span class='nv'>dest_grp</span>, mean_delay <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>arr_delay</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/arrange.html'>arrange</a></span><span class='o'>(</span><span class='nv'>dest_delays</span>, <span class='nf'><a href='https://dplyr.tidyverse.org/reference/desc.html'>desc</a></span><span class='o'>(</span><span class='nv'>mean_delay</span><span class='o'>)</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 105 × 2</span></span></span>
<span><span class='c'>#&gt;    dest  mean_delay</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> CAE         41.8</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> TUL         33.7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> OKC         30.6</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> JAC         28.1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> TYS         24.1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> MSN         20.2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> RIC         20.1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> CAK         19.7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> DSM         19.0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> GRR         18.2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 95 more rows</span></span></span></code></pre>

</div>

</details>

</div>

</div>

<br>

------------------------------------------------------------------------

## Using Pipes

We did this above...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>by_dest</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>flights</span>, <span class='nv'>dest</span><span class='o'>)</span></span>
<span><span class='nv'>delay</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarise</a></span><span class='o'>(</span><span class='nv'>by_dest</span>,</span>
<span>                   count <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/context.html'>n</a></span><span class='o'>(</span><span class='o'>)</span>,</span>
<span>                   dist <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>distance</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>,</span>
<span>                   delay <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>arr_delay</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span><span class='o'>)</span></span></code></pre>

</div>

That code can be rewritten with the pipe as follows...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>delays</span> <span class='o'>&lt;-</span> <span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>dest</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarise</a></span><span class='o'>(</span></span>
<span>    count <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/context.html'>n</a></span><span class='o'>(</span><span class='o'>)</span>,</span>
<span>    dist <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>distance</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>,</span>
<span>    delay <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>arr_delay</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span></span>
<span>  <span class='o'>)</span></span></code></pre>

</div>

Notice here we didn't have to create intermediate/temporary tibbles.

<br>

------------------------------------------------------------------------

## Breakout Exercises 2

Here we'll redo the same analyses as in the first breakout session, but this time using the pipe.

### Exercise 1

<div class="alert puzzle">

<div>

Overall, which carrier had the longest mean arrival delay (*arr_delay*) in 2013? (Note, all these data are from 2013.)

<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>carrier</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarise</a></span><span class='o'>(</span>mean_delay <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>arr_delay</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 16 × 2</span></span></span>
<span><span class='c'>#&gt;    carrier mean_delay</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>        <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> 9E           7.38 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> AA           0.364</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> AS          -<span style='color: #BB0000;'>9.93</span> </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> B6           9.46 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> DL           1.64 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> EV          15.8  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> F9          21.9  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> FL          20.1  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> HA          -<span style='color: #BB0000;'>6.92</span> </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> MQ          10.8  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>11</span> OO          11.9  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>12</span> UA           3.56 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>13</span> US           2.13 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>14</span> VX           1.76 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>15</span> WN           9.65 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>16</span> YV          15.6</span></span></code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

### Exercise 2

<div class="alert puzzle">

<div>

Evaluate arrival delay by carrier again, but this time, evaluate only for carriers who made at least 10,000 flights.

<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>carrier</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarise</a></span><span class='o'>(</span>mean_delay <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>arr_delay</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>,</span>
<span>            n <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/context.html'>n</a></span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>n</span> <span class='o'>&gt;</span> <span class='m'>10000</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 9 × 3</span></span></span>
<span><span class='c'>#&gt;   carrier mean_delay     n</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>        <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> 9E           7.38  <span style='text-decoration: underline;'>18</span>460</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> AA           0.364 <span style='text-decoration: underline;'>32</span>729</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> B6           9.46  <span style='text-decoration: underline;'>54</span>635</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> DL           1.64  <span style='text-decoration: underline;'>48</span>110</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> EV          15.8   <span style='text-decoration: underline;'>54</span>173</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> MQ          10.8   <span style='text-decoration: underline;'>26</span>397</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>7</span> UA           3.56  <span style='text-decoration: underline;'>58</span>665</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>8</span> US           2.13  <span style='text-decoration: underline;'>20</span>536</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>9</span> WN           9.65  <span style='text-decoration: underline;'>12</span>275</span></span></code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

### Exercise 3

<div class="alert puzzle">

<div>

Based on these data, what airport is the worst to fly in to with regards to arriving on time? In other words, which airport (`dest`) is associated with the highest average arrival delays?

<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>dest</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarise</a></span><span class='o'>(</span>mean_delay <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>arr_delay</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/arrange.html'>arrange</a></span><span class='o'>(</span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/desc.html'>desc</a></span><span class='o'>(</span><span class='nv'>mean_delay</span><span class='o'>)</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 105 × 2</span></span></span>
<span><span class='c'>#&gt;    dest  mean_delay</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> CAE         41.8</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> TUL         33.7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> OKC         30.6</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> JAC         28.1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> TYS         24.1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> MSN         20.2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> RIC         20.1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> CAK         19.7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> DSM         19.0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> GRR         18.2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 95 more rows</span></span></span></code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

