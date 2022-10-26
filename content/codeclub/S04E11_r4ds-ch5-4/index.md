---
output: hugodown::md_document
title: "S04E9 and S04E10: R for Data Science - Chapters 5.3 and 5.4"
subtitle: "Data Transformation with _dplyr_, parts II and III: `arrange()` and `filter()`."
summary: "In these two sessions of Code Club, we look at sorting dataframes with arrange() and filtering rows of a dataframe based on certain conditions with filter()."
authors: [michael-broe]
tags: [codeclub, r4ds]
date: "2022-10-26"
lastmod: "2022-10-26"
toc: true
rmd_hash: 3a425837555da376

---

<br>

------------------------------------------------------------------------

## Introduction

Use this to download the R Markdown:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>rmd_file</span> <span class='o'>&lt;-</span> <span class='s'>"https://raw.githubusercontent.com/biodash/biodash.github.io/master/assets/scripts/Arrange%2C%20Select.Rmd"</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span><span class='nv'>rmd_file</span>, destfile <span class='o'>=</span> <span class='s'>"arrange_select.Rmd"</span><span class='o'>)</span></span></code></pre>

</div>

Today we are going to finish off the material on the dplyr function [`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html) that we didn't get to last week, and introduce a new dplyr function [`select()`](https://dplyr.tidyverse.org/reference/select.html).

The way I am presenting this is through an RMarkdown document, to interactively explore the material in these two sections of Chapter 5, Data transformation

Recall that for all dplyr data manipulation functions there is a common template:

-   the first argument of the function is the input data frame

-   the next arguments say what you want to do with that data frame, using variable names (no quotes)

-   the result is a new dataframe

The fact that all these functions have a common template makes it possible to chain steps together, to make complex code chunks out of simple steps, one step at a time, as we will see below.

We will again be using the `nycflights13` and `tidyverse` packages, so we first need make sure these packages are installed, and then load them for the current session by doing [`library()`](https://rdrr.io/r/base/library.html) commands:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span></span>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/hadley/nycflights13'>nycflights13</a></span><span class='o'>)</span></span></code></pre>

</div>

## `arrange()`

Refer to the biodash page to see where we left off:

[S04E08: R for Data Science - Chapter 5.1 - 5.3](https://biodash.github.io/codeclub/s04e09_r4ds-ch5-1/)

[`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html) is the equivalent of the Excel `sort` command.

So what happens if just 'arrange' flights (the data frame) with no other arguments?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/arrange.html'>arrange</a></span><span class='o'>(</span><span class='nv'>flights</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 19</span></span></span>
<span><span class='c'>#&gt;     year month   day dep_time sched_de…¹ dep_d…² arr_t…³ sched…⁴ arr_d…⁵ carrier</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>  <span style='text-decoration: underline;'>2</span>013     1     1      517        515       2     830     819      11 UA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>  <span style='text-decoration: underline;'>2</span>013     1     1      533        529       4     850     830      20 UA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>  <span style='text-decoration: underline;'>2</span>013     1     1      542        540       2     923     850      33 AA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>  <span style='text-decoration: underline;'>2</span>013     1     1      544        545      -<span style='color: #BB0000;'>1</span>    <span style='text-decoration: underline;'>1</span>004    <span style='text-decoration: underline;'>1</span>022     -<span style='color: #BB0000;'>18</span> B6     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>  <span style='text-decoration: underline;'>2</span>013     1     1      554        600      -<span style='color: #BB0000;'>6</span>     812     837     -<span style='color: #BB0000;'>25</span> DL     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>  <span style='text-decoration: underline;'>2</span>013     1     1      554        558      -<span style='color: #BB0000;'>4</span>     740     728      12 UA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>  <span style='text-decoration: underline;'>2</span>013     1     1      555        600      -<span style='color: #BB0000;'>5</span>     913     854      19 B6     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>  <span style='text-decoration: underline;'>2</span>013     1     1      557        600      -<span style='color: #BB0000;'>3</span>     709     723     -<span style='color: #BB0000;'>14</span> EV     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>  <span style='text-decoration: underline;'>2</span>013     1     1      557        600      -<span style='color: #BB0000;'>3</span>     838     846      -<span style='color: #BB0000;'>8</span> B6     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>  <span style='text-decoration: underline;'>2</span>013     1     1      558        600      -<span style='color: #BB0000;'>2</span>     753     745       8 AA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows, 9 more variables: flight &lt;int&gt;, tailnum &lt;chr&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   origin &lt;chr&gt;, dest &lt;chr&gt;, air_time &lt;dbl&gt;, distance &lt;dbl&gt;, hour &lt;dbl&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   minute &lt;dbl&gt;, time_hour &lt;dttm&gt;, and abbreviated variable names</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   ¹​sched_dep_time, ²​dep_delay, ³​arr_time, ⁴​sched_arr_time, ⁵​arr_delay</span></span></span></code></pre>

</div>

Nothing changes. This is identical to the original data frame:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>flights</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 19</span></span></span>
<span><span class='c'>#&gt;    year month   day dep_time sched_dep…¹ dep_d…² arr_t…³ sched…⁴ arr_d…⁵ carrier</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span>  <span style='text-decoration: underline;'>2</span>013     1     1      517         515       2     830     819      11 UA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span>  <span style='text-decoration: underline;'>2</span>013     1     1      533         529       4     850     830      20 UA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span>  <span style='text-decoration: underline;'>2</span>013     1     1      542         540       2     923     850      33 AA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span>  <span style='text-decoration: underline;'>2</span>013     1     1      544         545      -<span style='color: #BB0000;'>1</span>    <span style='text-decoration: underline;'>1</span>004    <span style='text-decoration: underline;'>1</span>022     -<span style='color: #BB0000;'>18</span> B6     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span>  <span style='text-decoration: underline;'>2</span>013     1     1      554         600      -<span style='color: #BB0000;'>6</span>     812     837     -<span style='color: #BB0000;'>25</span> DL     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span>  <span style='text-decoration: underline;'>2</span>013     1     1      554         558      -<span style='color: #BB0000;'>4</span>     740     728      12 UA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 9 more variables: flight &lt;int&gt;, tailnum &lt;chr&gt;, origin &lt;chr&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   dest &lt;chr&gt;, air_time &lt;dbl&gt;, distance &lt;dbl&gt;, hour &lt;dbl&gt;, minute &lt;dbl&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   time_hour &lt;dttm&gt;, and abbreviated variable names ¹​sched_dep_time,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   ²​dep_delay, ³​arr_time, ⁴​sched_arr_time, ⁵​arr_delay</span></span></span></code></pre>

</div>

But there a whole bunch of variables we can sort by. An easy way to see them is using the [`glimpse()`](https://pillar.r-lib.org/reference/glimpse.html) function, which basically puts the 'columns into rows', so you can see them more easily, without scrolling off the screen. This is a great way to see just what the columns are in a complex data frame that you inherit from someone or other.

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

(Notice there are 19 columns).

Say we wanted to sort by month, and pull all the 'Christmassy' flights to the top. We can arrange by month, *and* sort descending:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/arrange.html'>arrange</a></span><span class='o'>(</span><span class='nv'>flights</span>, <span class='nf'><a href='https://dplyr.tidyverse.org/reference/desc.html'>desc</a></span><span class='o'>(</span><span class='nv'>month</span><span class='o'>)</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 19</span></span></span>
<span><span class='c'>#&gt;     year month   day dep_time sched_de…¹ dep_d…² arr_t…³ sched…⁴ arr_d…⁵ carrier</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>  <span style='text-decoration: underline;'>2</span>013    12     1       13       <span style='text-decoration: underline;'>2</span>359      14     446     445       1 B6     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>  <span style='text-decoration: underline;'>2</span>013    12     1       17       <span style='text-decoration: underline;'>2</span>359      18     443     437       6 B6     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>  <span style='text-decoration: underline;'>2</span>013    12     1      453        500      -<span style='color: #BB0000;'>7</span>     636     651     -<span style='color: #BB0000;'>15</span> US     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>  <span style='text-decoration: underline;'>2</span>013    12     1      520        515       5     749     808     -<span style='color: #BB0000;'>19</span> UA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>  <span style='text-decoration: underline;'>2</span>013    12     1      536        540      -<span style='color: #BB0000;'>4</span>     845     850      -<span style='color: #BB0000;'>5</span> AA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>  <span style='text-decoration: underline;'>2</span>013    12     1      540        550     -<span style='color: #BB0000;'>10</span>    <span style='text-decoration: underline;'>1</span>005    <span style='text-decoration: underline;'>1</span>027     -<span style='color: #BB0000;'>22</span> B6     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>  <span style='text-decoration: underline;'>2</span>013    12     1      541        545      -<span style='color: #BB0000;'>4</span>     734     755     -<span style='color: #BB0000;'>21</span> EV     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>  <span style='text-decoration: underline;'>2</span>013    12     1      546        545       1     826     835      -<span style='color: #BB0000;'>9</span> UA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>  <span style='text-decoration: underline;'>2</span>013    12     1      549        600     -<span style='color: #BB0000;'>11</span>     648     659     -<span style='color: #BB0000;'>11</span> US     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>  <span style='text-decoration: underline;'>2</span>013    12     1      550        600     -<span style='color: #BB0000;'>10</span>     825     854     -<span style='color: #BB0000;'>29</span> B6     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows, 9 more variables: flight &lt;int&gt;, tailnum &lt;chr&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   origin &lt;chr&gt;, dest &lt;chr&gt;, air_time &lt;dbl&gt;, distance &lt;dbl&gt;, hour &lt;dbl&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   minute &lt;dbl&gt;, time_hour &lt;dttm&gt;, and abbreviated variable names</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   ¹​sched_dep_time, ²​dep_delay, ³​arr_time, ⁴​sched_arr_time, ⁵​arr_delay</span></span></span></code></pre>

</div>

And now say we want to just order the Christmas flights coming into Columbus. We can first [`filter()`](https://dplyr.tidyverse.org/reference/filter.html) on `CMH`, and then chain (pipe) that filter statement into arrange, using the **pipe** notation.

First filter on destination `CMH`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>flights</span>, <span class='nv'>dest</span> <span class='o'>==</span> <span class='s'>"CMH"</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3,524 × 19</span></span></span>
<span><span class='c'>#&gt;     year month   day dep_time sched_de…¹ dep_d…² arr_t…³ sched…⁴ arr_d…⁵ carrier</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>  <span style='text-decoration: underline;'>2</span>013     1     1      805        815     -<span style='color: #BB0000;'>10</span>    <span style='text-decoration: underline;'>1</span>006    <span style='text-decoration: underline;'>1</span>010      -<span style='color: #BB0000;'>4</span> MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>  <span style='text-decoration: underline;'>2</span>013     1     1     <span style='text-decoration: underline;'>1</span>107       <span style='text-decoration: underline;'>1</span>115      -<span style='color: #BB0000;'>8</span>    <span style='text-decoration: underline;'>1</span>305    <span style='text-decoration: underline;'>1</span>310      -<span style='color: #BB0000;'>5</span> MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>  <span style='text-decoration: underline;'>2</span>013     1     1     <span style='text-decoration: underline;'>1</span>153       <span style='text-decoration: underline;'>1</span>159      -<span style='color: #BB0000;'>6</span>    <span style='text-decoration: underline;'>1</span>350    <span style='text-decoration: underline;'>1</span>341       9 EV     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>  <span style='text-decoration: underline;'>2</span>013     1     1     <span style='text-decoration: underline;'>1</span>257       <span style='text-decoration: underline;'>1</span>300      -<span style='color: #BB0000;'>3</span>    <span style='text-decoration: underline;'>1</span>454    <span style='text-decoration: underline;'>1</span>450       4 MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>  <span style='text-decoration: underline;'>2</span>013     1     1     <span style='text-decoration: underline;'>1</span>458       <span style='text-decoration: underline;'>1</span>500      -<span style='color: #BB0000;'>2</span>    <span style='text-decoration: underline;'>1</span>658    <span style='text-decoration: underline;'>1</span>655       3 MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>  <span style='text-decoration: underline;'>2</span>013     1     1     <span style='text-decoration: underline;'>1</span>459       <span style='text-decoration: underline;'>1</span>501      -<span style='color: #BB0000;'>2</span>    <span style='text-decoration: underline;'>1</span>651    <span style='text-decoration: underline;'>1</span>651       0 EV     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>  <span style='text-decoration: underline;'>2</span>013     1     1     <span style='text-decoration: underline;'>1</span>522       <span style='text-decoration: underline;'>1</span>530      -<span style='color: #BB0000;'>8</span>    <span style='text-decoration: underline;'>1</span>731    <span style='text-decoration: underline;'>1</span>725       6 MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>  <span style='text-decoration: underline;'>2</span>013     1     1     <span style='text-decoration: underline;'>1</span>759       <span style='text-decoration: underline;'>1</span>759       0    <span style='text-decoration: underline;'>1</span>957    <span style='text-decoration: underline;'>1</span>949       8 EV     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>  <span style='text-decoration: underline;'>2</span>013     1     1     <span style='text-decoration: underline;'>1</span>816       <span style='text-decoration: underline;'>1</span>805      11    <span style='text-decoration: underline;'>2</span>013    <span style='text-decoration: underline;'>1</span>955      18 MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>  <span style='text-decoration: underline;'>2</span>013     1     1     <span style='text-decoration: underline;'>2</span>008       <span style='text-decoration: underline;'>2</span>015      -<span style='color: #BB0000;'>7</span>    <span style='text-decoration: underline;'>2</span>206    <span style='text-decoration: underline;'>2</span>210      -<span style='color: #BB0000;'>4</span> MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 3,514 more rows, 9 more variables: flight &lt;int&gt;, tailnum &lt;chr&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   origin &lt;chr&gt;, dest &lt;chr&gt;, air_time &lt;dbl&gt;, distance &lt;dbl&gt;, hour &lt;dbl&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   minute &lt;dbl&gt;, time_hour &lt;dttm&gt;, and abbreviated variable names</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   ¹​sched_dep_time, ²​dep_delay, ³​arr_time, ⁴​sched_arr_time, ⁵​arr_delay</span></span></span></code></pre>

</div>

(Notice we now have only 3,524 rows, as opposed to 336,776 in the full data frame).

We can pass that output data frame on to [`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html) using the 'pipe symbol' `%>%`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>flights</span>, <span class='nv'>dest</span> <span class='o'>==</span> <span class='s'>"CMH"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/arrange.html'>arrange</a></span><span class='o'>(</span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/desc.html'>desc</a></span><span class='o'>(</span><span class='nv'>month</span><span class='o'>)</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3,524 × 19</span></span></span>
<span><span class='c'>#&gt;     year month   day dep_time sched_de…¹ dep_d…² arr_t…³ sched…⁴ arr_d…⁵ carrier</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>  <span style='text-decoration: underline;'>2</span>013    12     1      644        614      30     836     805      31 EV     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>  <span style='text-decoration: underline;'>2</span>013    12     1     <span style='text-decoration: underline;'>1</span>129       <span style='text-decoration: underline;'>1</span>135      -<span style='color: #BB0000;'>6</span>    <span style='text-decoration: underline;'>1</span>316    <span style='text-decoration: underline;'>1</span>330     -<span style='color: #BB0000;'>14</span> MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>  <span style='text-decoration: underline;'>2</span>013    12     1     <span style='text-decoration: underline;'>1</span>253       <span style='text-decoration: underline;'>1</span>259      -<span style='color: #BB0000;'>6</span>    <span style='text-decoration: underline;'>1</span>435    <span style='text-decoration: underline;'>1</span>454     -<span style='color: #BB0000;'>19</span> MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>  <span style='text-decoration: underline;'>2</span>013    12     1     <span style='text-decoration: underline;'>1</span>328       <span style='text-decoration: underline;'>1</span>326       2    <span style='text-decoration: underline;'>1</span>507    <span style='text-decoration: underline;'>1</span>524     -<span style='color: #BB0000;'>17</span> EV     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>  <span style='text-decoration: underline;'>2</span>013    12     1     <span style='text-decoration: underline;'>1</span>513       <span style='text-decoration: underline;'>1</span>515      -<span style='color: #BB0000;'>2</span>    <span style='text-decoration: underline;'>1</span>709    <span style='text-decoration: underline;'>1</span>720     -<span style='color: #BB0000;'>11</span> MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>  <span style='text-decoration: underline;'>2</span>013    12     1     <span style='text-decoration: underline;'>1</span>629       <span style='text-decoration: underline;'>1</span>455      94    <span style='text-decoration: underline;'>1</span>822    <span style='text-decoration: underline;'>1</span>650      92 MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>  <span style='text-decoration: underline;'>2</span>013    12     1     <span style='text-decoration: underline;'>1</span>728       <span style='text-decoration: underline;'>1</span>730      -<span style='color: #BB0000;'>2</span>    <span style='text-decoration: underline;'>1</span>918    <span style='text-decoration: underline;'>1</span>925      -<span style='color: #BB0000;'>7</span> MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>  <span style='text-decoration: underline;'>2</span>013    12     1     <span style='text-decoration: underline;'>1</span>922       <span style='text-decoration: underline;'>1</span>930      -<span style='color: #BB0000;'>8</span>    <span style='text-decoration: underline;'>2</span>102    <span style='text-decoration: underline;'>2</span>130     -<span style='color: #BB0000;'>28</span> MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>  <span style='text-decoration: underline;'>2</span>013    12     1     <span style='text-decoration: underline;'>1</span>951       <span style='text-decoration: underline;'>1</span>930      21    <span style='text-decoration: underline;'>2</span>121    <span style='text-decoration: underline;'>2</span>115       6 MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>  <span style='text-decoration: underline;'>2</span>013    12     2      622        610      12     759     801      -<span style='color: #BB0000;'>2</span> EV     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 3,514 more rows, 9 more variables: flight &lt;int&gt;, tailnum &lt;chr&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   origin &lt;chr&gt;, dest &lt;chr&gt;, air_time &lt;dbl&gt;, distance &lt;dbl&gt;, hour &lt;dbl&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   minute &lt;dbl&gt;, time_hour &lt;dttm&gt;, and abbreviated variable names</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   ¹​sched_dep_time, ²​dep_delay, ³​arr_time, ⁴​sched_arr_time, ⁵​arr_delay</span></span></span></code></pre>

</div>

So this is a first example of chaining together simple steps, to get a more complex result.

Finally, with arrange, you can add other variables to 'break ties'. In the following example, we first sort on `month` (descending), and *then* sort on `dep_delay`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>flights</span>, <span class='nv'>dest</span> <span class='o'>==</span> <span class='s'>"CMH"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/arrange.html'>arrange</a></span><span class='o'>(</span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/desc.html'>desc</a></span><span class='o'>(</span><span class='nv'>month</span><span class='o'>)</span>, <span class='nv'>dep_delay</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3,524 × 19</span></span></span>
<span><span class='c'>#&gt;     year month   day dep_time sched_de…¹ dep_d…² arr_t…³ sched…⁴ arr_d…⁵ carrier</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>  <span style='text-decoration: underline;'>2</span>013    12     4     <span style='text-decoration: underline;'>1</span>910       <span style='text-decoration: underline;'>1</span>930     -<span style='color: #BB0000;'>20</span>    <span style='text-decoration: underline;'>2</span>101    <span style='text-decoration: underline;'>2</span>130     -<span style='color: #BB0000;'>29</span> MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>  <span style='text-decoration: underline;'>2</span>013    12     7     <span style='text-decoration: underline;'>1</span>243       <span style='text-decoration: underline;'>1</span>259     -<span style='color: #BB0000;'>16</span>    <span style='text-decoration: underline;'>1</span>434    <span style='text-decoration: underline;'>1</span>454     -<span style='color: #BB0000;'>20</span> MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>  <span style='text-decoration: underline;'>2</span>013    12    18     <span style='text-decoration: underline;'>1</span>715       <span style='text-decoration: underline;'>1</span>730     -<span style='color: #BB0000;'>15</span>    <span style='text-decoration: underline;'>1</span>919    <span style='text-decoration: underline;'>1</span>925      -<span style='color: #BB0000;'>6</span> MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>  <span style='text-decoration: underline;'>2</span>013    12    26     <span style='text-decoration: underline;'>1</span>918       <span style='text-decoration: underline;'>1</span>930     -<span style='color: #BB0000;'>12</span>    <span style='text-decoration: underline;'>2</span>116    <span style='text-decoration: underline;'>2</span>130     -<span style='color: #BB0000;'>14</span> MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>  <span style='text-decoration: underline;'>2</span>013    12    27     <span style='text-decoration: underline;'>1</span>918       <span style='text-decoration: underline;'>1</span>930     -<span style='color: #BB0000;'>12</span>    <span style='text-decoration: underline;'>2</span>057    <span style='text-decoration: underline;'>2</span>130     -<span style='color: #BB0000;'>33</span> MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>  <span style='text-decoration: underline;'>2</span>013    12    10     <span style='text-decoration: underline;'>1</span>504       <span style='text-decoration: underline;'>1</span>515     -<span style='color: #BB0000;'>11</span>    <span style='text-decoration: underline;'>1</span>731    <span style='text-decoration: underline;'>1</span>720      11 MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>  <span style='text-decoration: underline;'>2</span>013    12    12     <span style='text-decoration: underline;'>1</span>719       <span style='text-decoration: underline;'>1</span>730     -<span style='color: #BB0000;'>11</span>    <span style='text-decoration: underline;'>1</span>937    <span style='text-decoration: underline;'>1</span>925      12 MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>  <span style='text-decoration: underline;'>2</span>013    12    16     <span style='text-decoration: underline;'>1</span>919       <span style='text-decoration: underline;'>1</span>930     -<span style='color: #BB0000;'>11</span>    <span style='text-decoration: underline;'>2</span>108    <span style='text-decoration: underline;'>2</span>130     -<span style='color: #BB0000;'>22</span> MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>  <span style='text-decoration: underline;'>2</span>013    12    31     <span style='text-decoration: underline;'>1</span>444       <span style='text-decoration: underline;'>1</span>455     -<span style='color: #BB0000;'>11</span>    <span style='text-decoration: underline;'>1</span>637    <span style='text-decoration: underline;'>1</span>650     -<span style='color: #BB0000;'>13</span> MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>  <span style='text-decoration: underline;'>2</span>013    12    12     <span style='text-decoration: underline;'>1</span>125       <span style='text-decoration: underline;'>1</span>135     -<span style='color: #BB0000;'>10</span>    <span style='text-decoration: underline;'>1</span>321    <span style='text-decoration: underline;'>1</span>330      -<span style='color: #BB0000;'>9</span> MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 3,514 more rows, 9 more variables: flight &lt;int&gt;, tailnum &lt;chr&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   origin &lt;chr&gt;, dest &lt;chr&gt;, air_time &lt;dbl&gt;, distance &lt;dbl&gt;, hour &lt;dbl&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   minute &lt;dbl&gt;, time_hour &lt;dttm&gt;, and abbreviated variable names</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   ¹​sched_dep_time, ²​dep_delay, ³​arr_time, ⁴​sched_arr_time, ⁵​arr_delay</span></span></span></code></pre>

</div>

## Break out exercises:

Again, see here: [S04E08: R for Data Science - Chapter 5.1 - 5.3](https://biodash.github.io/codeclub/s04e09_r4ds-ch5-1/)

at the bottom of the page, under **III -- Chapter 5.3: arrange()**.

## `select()`

The previous data manipulation functions we've looked at, [`filter()`](https://dplyr.tidyverse.org/reference/filter.html) and [`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html), work on observations (i.e. rows).

The next function we'll look at, [`select()`](https://dplyr.tidyverse.org/reference/select.html), works on directly on variables (i.e. columns).

If you have hundreds of columns in a data frame (many of which you may not be interested in for the current analysis) you can **subset** the columns. We saw above that `flights` has 19 columns. This is a serious example in terms of rows (336,776), but pretty trivial in terms of columns. But it's still a good toy example.

It will be useful to import this example data frame into our local Environment so we can visualize it in RStudio (at the moment it is just 'floating' out there in the system: we can access it, but we can't see it).

So after:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/hadley/nycflights13'>nycflights13</a></span><span class='o'>)</span></span></code></pre>

</div>

We want to do:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>my_flights</span> <span class='o'>&lt;-</span> <span class='nv'>flights</span></span></code></pre>

</div>

(We've just created a personal 'local object' data frame in our current session, pulling in data from the `nycflights13` package). And it should appear in the Environment tab in RStudio.

So, how can we focus on a subset of variables in the flights data frame? One way is to explicitly name the columns you want to **keep** using the [`select()`](https://dplyr.tidyverse.org/reference/select.html) function (remember, the first argument is the data frame; the following arguments are the column names):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nv'>flights</span>, <span class='nv'>year</span>, <span class='nv'>month</span>, <span class='nv'>day</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 3</span></span></span>
<span><span class='c'>#&gt;     year month   day</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows</span></span></span></code></pre>

</div>

Often this is fine, but as you move on to larger data sets, you might want to use various *selection features* instead of just explictly listing want you want to keep.

These are listed if you do:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='o'>?</span><span class='nv'>select</span></span></code></pre>

</div>

These use the same syntax and semantics as [`filter()`](https://dplyr.tidyverse.org/reference/filter.html) for rows, using the same logical combinations.

#### Selection features

##### `:` 'range'

You can select a **range** of columns using the `:` range operator. This is really only efficient if the original data frame is organized in a way that is useful for your purposes. The good news is that don't have to select all varibles explicitly, one by one. The range operator selects *consecutive* variables in the data frame.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nv'>flights</span>, <span class='nv'>year</span><span class='o'>:</span><span class='nv'>day</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 3</span></span></span>
<span><span class='c'>#&gt;     year month   day</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows</span></span></span></code></pre>

</div>

Notice that the `month` variable is automatically included, even though it's not mentioned in the select statement.

But there is more organization in this data frame. Say we wanted to drill down just into the departure and arrival times:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nv'>flights</span>, <span class='nv'>dep_time</span><span class='o'>:</span><span class='nv'>arr_delay</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 6</span></span></span>
<span><span class='c'>#&gt;    dep_time sched_dep_time dep_delay arr_time sched_arr_time arr_delay</span></span>
<span><span class='c'>#&gt;       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>          <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>          <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>      517            515         2      830            819        11</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>      533            529         4      850            830        20</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>      542            540         2      923            850        33</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>      544            545        -<span style='color: #BB0000;'>1</span>     <span style='text-decoration: underline;'>1</span>004           <span style='text-decoration: underline;'>1</span>022       -<span style='color: #BB0000;'>18</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>      554            600        -<span style='color: #BB0000;'>6</span>      812            837       -<span style='color: #BB0000;'>25</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>      554            558        -<span style='color: #BB0000;'>4</span>      740            728        12</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>      555            600        -<span style='color: #BB0000;'>5</span>      913            854        19</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>      557            600        -<span style='color: #BB0000;'>3</span>      709            723       -<span style='color: #BB0000;'>14</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>      557            600        -<span style='color: #BB0000;'>3</span>      838            846        -<span style='color: #BB0000;'>8</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>      558            600        -<span style='color: #BB0000;'>2</span>      753            745         8</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows</span></span></span></code></pre>

</div>

##### `!` 'complement'

You can also drop columns (and ranges of columns) using the logical `complement` sign:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nv'>flights</span>, <span class='o'>!</span><span class='o'>(</span><span class='nv'>year</span><span class='o'>:</span><span class='nv'>day</span><span class='o'>)</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 16</span></span></span>
<span><span class='c'>#&gt;    dep_t…¹ sched…² dep_d…³ arr_t…⁴ sched…⁵ arr_d…⁶ carrier flight tailnum origin</span></span>
<span><span class='c'>#&gt;      <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>     517     515       2     830     819      11 UA        <span style='text-decoration: underline;'>1</span>545 N14228  EWR   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>     533     529       4     850     830      20 UA        <span style='text-decoration: underline;'>1</span>714 N24211  LGA   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>     542     540       2     923     850      33 AA        <span style='text-decoration: underline;'>1</span>141 N619AA  JFK   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>     544     545      -<span style='color: #BB0000;'>1</span>    <span style='text-decoration: underline;'>1</span>004    <span style='text-decoration: underline;'>1</span>022     -<span style='color: #BB0000;'>18</span> B6         725 N804JB  JFK   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>     554     600      -<span style='color: #BB0000;'>6</span>     812     837     -<span style='color: #BB0000;'>25</span> DL         461 N668DN  LGA   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>     554     558      -<span style='color: #BB0000;'>4</span>     740     728      12 UA        <span style='text-decoration: underline;'>1</span>696 N39463  EWR   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>     555     600      -<span style='color: #BB0000;'>5</span>     913     854      19 B6         507 N516JB  EWR   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>     557     600      -<span style='color: #BB0000;'>3</span>     709     723     -<span style='color: #BB0000;'>14</span> EV        <span style='text-decoration: underline;'>5</span>708 N829AS  LGA   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>     557     600      -<span style='color: #BB0000;'>3</span>     838     846      -<span style='color: #BB0000;'>8</span> B6          79 N593JB  JFK   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>     558     600      -<span style='color: #BB0000;'>2</span>     753     745       8 AA         301 N3ALAA  LGA   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows, 6 more variables: dest &lt;chr&gt;, air_time &lt;dbl&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   distance &lt;dbl&gt;, hour &lt;dbl&gt;, minute &lt;dbl&gt;, time_hour &lt;dttm&gt;, and abbreviated</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   variable names ¹​dep_time, ²​sched_dep_time, ³​dep_delay, ⁴​arr_time,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   ⁵​sched_arr_time, ⁶​arr_delay</span></span></span></code></pre>

</div>

Now we just have 16 columns, as opposed to the original 19.

**Just a note**. In the text we are using, the syntax is:

``` r
select(flights, -(year:day))
```

But based on this:

[select.R](https://dplyr.tidyverse.org/reference/select.html)

I get the sense that `!` is the current recommendation for taking the complement in [`select()`](https://dplyr.tidyverse.org/reference/select.html) statements and that `-` is deprecated. And FYI: documentation *always* lags behind implementation.

We can do exactly the same thing by explicitly listing the columns we want to drop, *but*, there is a gotcha here.

This (which was my first guess) does not work:

``` r
select(flights, !(year, month, day)
```

Instead, we need to wrap the dropped columns in a [`c()`](https://rdrr.io/r/base/c.html) vector:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nv'>flights</span>, <span class='o'>!</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='nv'>year</span>, <span class='nv'>month</span>, <span class='nv'>day</span><span class='o'>)</span><span class='o'>)</span> </span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 16</span></span></span>
<span><span class='c'>#&gt;    dep_t…¹ sched…² dep_d…³ arr_t…⁴ sched…⁵ arr_d…⁶ carrier flight tailnum origin</span></span>
<span><span class='c'>#&gt;      <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>     517     515       2     830     819      11 UA        <span style='text-decoration: underline;'>1</span>545 N14228  EWR   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>     533     529       4     850     830      20 UA        <span style='text-decoration: underline;'>1</span>714 N24211  LGA   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>     542     540       2     923     850      33 AA        <span style='text-decoration: underline;'>1</span>141 N619AA  JFK   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>     544     545      -<span style='color: #BB0000;'>1</span>    <span style='text-decoration: underline;'>1</span>004    <span style='text-decoration: underline;'>1</span>022     -<span style='color: #BB0000;'>18</span> B6         725 N804JB  JFK   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>     554     600      -<span style='color: #BB0000;'>6</span>     812     837     -<span style='color: #BB0000;'>25</span> DL         461 N668DN  LGA   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>     554     558      -<span style='color: #BB0000;'>4</span>     740     728      12 UA        <span style='text-decoration: underline;'>1</span>696 N39463  EWR   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>     555     600      -<span style='color: #BB0000;'>5</span>     913     854      19 B6         507 N516JB  EWR   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>     557     600      -<span style='color: #BB0000;'>3</span>     709     723     -<span style='color: #BB0000;'>14</span> EV        <span style='text-decoration: underline;'>5</span>708 N829AS  LGA   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>     557     600      -<span style='color: #BB0000;'>3</span>     838     846      -<span style='color: #BB0000;'>8</span> B6          79 N593JB  JFK   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>     558     600      -<span style='color: #BB0000;'>2</span>     753     745       8 AA         301 N3ALAA  LGA   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows, 6 more variables: dest &lt;chr&gt;, air_time &lt;dbl&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   distance &lt;dbl&gt;, hour &lt;dbl&gt;, minute &lt;dbl&gt;, time_hour &lt;dttm&gt;, and abbreviated</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   variable names ¹​dep_time, ²​sched_dep_time, ³​dep_delay, ⁴​arr_time,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   ⁵​sched_arr_time, ⁶​arr_delay</span></span></span></code></pre>

</div>

This is the syntax for *combining selections* in the current dplyr package.

Let's check if it works on positive selections:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nv'>flights</span>, <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='nv'>year</span>, <span class='nv'>month</span>, <span class='nv'>day</span><span class='o'>)</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 3</span></span></span>
<span><span class='c'>#&gt;     year month   day</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>  <span style='text-decoration: underline;'>2</span>013     1     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows</span></span></span></code></pre>

</div>

Yep, all the same.

So it seems it's *optional* for positive selections, but *necessary* for negative selections.

#### Selection helpers

There are other ways to select columns efficiently without explicitly naming them.

Here are some examples of helpers which select variables by pattern-matching over the names. Note that the search term must be wrapped in quotes (since we are searching on text in the column name):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nf'><a href='https://tidyselect.r-lib.org/reference/starts_with.html'>ends_with</a></span><span class='o'>(</span><span class='s'>"time"</span><span class='o'>)</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 5</span></span></span>
<span><span class='c'>#&gt;    dep_time sched_dep_time arr_time sched_arr_time air_time</span></span>
<span><span class='c'>#&gt;       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>          <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>          <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>      517            515      830            819      227</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>      533            529      850            830      227</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>      542            540      923            850      160</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>      544            545     <span style='text-decoration: underline;'>1</span>004           <span style='text-decoration: underline;'>1</span>022      183</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>      554            600      812            837      116</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>      554            558      740            728      150</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>      555            600      913            854      158</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>      557            600      709            723       53</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>      557            600      838            846      140</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>      558            600      753            745      138</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows</span></span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nf'><a href='https://tidyselect.r-lib.org/reference/starts_with.html'>starts_with</a></span><span class='o'>(</span><span class='s'>"time"</span><span class='o'>)</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 1</span></span></span>
<span><span class='c'>#&gt;    time_hour          </span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;dttm&gt;</span>             </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> 2013-01-01 <span style='color: #555555;'>05:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> 2013-01-01 <span style='color: #555555;'>05:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> 2013-01-01 <span style='color: #555555;'>05:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> 2013-01-01 <span style='color: #555555;'>05:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> 2013-01-01 <span style='color: #555555;'>06:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> 2013-01-01 <span style='color: #555555;'>05:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> 2013-01-01 <span style='color: #555555;'>06:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> 2013-01-01 <span style='color: #555555;'>06:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> 2013-01-01 <span style='color: #555555;'>06:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> 2013-01-01 <span style='color: #555555;'>06:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows</span></span></span></code></pre>

</div>

We can combine these two helpers (you can also think of them as 'filters' or 'constraints' to make contact with other programming languages) using logical operators. Here is an 'OR' statement using the `|` syntax. It means the selection returns *all* selections that match *either* columns that end with "time" or start with "time".

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nf'><a href='https://tidyselect.r-lib.org/reference/starts_with.html'>ends_with</a></span><span class='o'>(</span><span class='s'>"time"</span><span class='o'>)</span> <span class='o'>|</span> <span class='nf'><a href='https://tidyselect.r-lib.org/reference/starts_with.html'>starts_with</a></span><span class='o'>(</span><span class='s'>"time"</span><span class='o'>)</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 6</span></span></span>
<span><span class='c'>#&gt;    dep_time sched_dep_time arr_time sched_arr_time air_time time_hour          </span></span>
<span><span class='c'>#&gt;       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>          <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>          <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dttm&gt;</span>             </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>      517            515      830            819      227 2013-01-01 <span style='color: #555555;'>05:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>      533            529      850            830      227 2013-01-01 <span style='color: #555555;'>05:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>      542            540      923            850      160 2013-01-01 <span style='color: #555555;'>05:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>      544            545     <span style='text-decoration: underline;'>1</span>004           <span style='text-decoration: underline;'>1</span>022      183 2013-01-01 <span style='color: #555555;'>05:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>      554            600      812            837      116 2013-01-01 <span style='color: #555555;'>06:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>      554            558      740            728      150 2013-01-01 <span style='color: #555555;'>05:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>      555            600      913            854      158 2013-01-01 <span style='color: #555555;'>06:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>      557            600      709            723       53 2013-01-01 <span style='color: #555555;'>06:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>      557            600      838            846      140 2013-01-01 <span style='color: #555555;'>06:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>      558            600      753            745      138 2013-01-01 <span style='color: #555555;'>06:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows</span></span></span></code></pre>

</div>

In this particular case there is a more compact way to get the same result, using the [`contains()`](https://tidyselect.r-lib.org/reference/starts_with.html) helper. But this solution has lower resolution, since "time" could be anywhere in the column name.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nf'><a href='https://tidyselect.r-lib.org/reference/starts_with.html'>contains</a></span><span class='o'>(</span><span class='s'>"time"</span><span class='o'>)</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 6</span></span></span>
<span><span class='c'>#&gt;    dep_time sched_dep_time arr_time sched_arr_time air_time time_hour          </span></span>
<span><span class='c'>#&gt;       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>          <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>          <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dttm&gt;</span>             </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>      517            515      830            819      227 2013-01-01 <span style='color: #555555;'>05:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>      533            529      850            830      227 2013-01-01 <span style='color: #555555;'>05:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>      542            540      923            850      160 2013-01-01 <span style='color: #555555;'>05:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>      544            545     <span style='text-decoration: underline;'>1</span>004           <span style='text-decoration: underline;'>1</span>022      183 2013-01-01 <span style='color: #555555;'>05:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>      554            600      812            837      116 2013-01-01 <span style='color: #555555;'>06:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>      554            558      740            728      150 2013-01-01 <span style='color: #555555;'>05:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>      555            600      913            854      158 2013-01-01 <span style='color: #555555;'>06:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>      557            600      709            723       53 2013-01-01 <span style='color: #555555;'>06:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>      557            600      838            846      140 2013-01-01 <span style='color: #555555;'>06:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>      558            600      753            745      138 2013-01-01 <span style='color: #555555;'>06:00:00</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows</span></span></span></code></pre>

</div>

But you get the idea. The usefulness of these 'selection helpers' depends on the column naming conventions you create (or most likely inherit) from a colleague or online.

## Break out exercises:

See 5.4.1 in the text.

But just state with these:

Create a couple of select queries which pull out dep_time, dep_delay, arr_time, and arr_delay from flights, just using what we learned above.

One should be explicit, and others (at least slightly!) more efficient.

If you get through these with no issues, feel free to explore more of the execises in 5.4.1.

