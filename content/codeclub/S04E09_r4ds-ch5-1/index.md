---
output: hugodown::md_document
title: "S04E08: R for Data Science - Chapter 5.1 - 5.3"
subtitle: "Data Transformation part 1: introduction, `filter()`, and `arrange()`"
summary: "This chapter covers the manipulation of rectangular data (data frames, think data from spreadsheets) with the dplyr package that is part of the tidyverse. We'll learn about data frames & tibbles, R variable types, comparison and logical operators, and missing values (NAs) in addition to the first of the core dplyr functions: filter() and arrange()"
authors: [admin]
tags: [codeclub, r4ds]
date: "2022-09-22"
lastmod: "2022-09-22"
toc: true
rmd_hash: e1960cd2a16f9191

---

<figure>
<p align="center">
<img src=img/dplyr_filter.jpeg width="70%">
<figcaption>
Artwork by Allison Horst
</figcaption>
</p>
</figure>

------------------------------------------------------------------------

## I -- Chapter 5.1: Introduction

### Key points

-   Function name conflicts: The function [`filter()`](https://dplyr.tidyverse.org/reference/filter.html) in the *stats* package (which is loaded by default in R) will be "masked" / "overwritten" by *dplyr*'s [`filter()`](https://dplyr.tidyverse.org/reference/filter.html) function when you load the *tidyverse*. To still use a masked function (or a function from an installed-but-not-loaded package!), use the "full" notation, e.g. [`stats::filter()`](https://rdrr.io/r/stats/filter.html).

-   A *data frame* is rectangular data structure (with rows and columns), while a "tibble" is a tidyverse-style data frame. Tibbles mainly differ from regular data frames in how they are printed to screen by default. Ssee the two examples below: `cars` is a regular data frame and `flights` is a tibble.

-   The most common R data types are *integers* (tibble abbreviation: `int`), *doubles* (`dbl`), ) (`chr`), *logicals* (`lgl`), and *factors* (`fctr`).

-   The *dplyr* package is designed to work with dataframes: both the input and the output is a dataframe.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># 'mtcars' is a regular dataframe</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>mtcars</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt;                    mpg cyl disp  hp drat    wt  qsec vs am gear carb</span></span>
<span><span class='c'>#&gt; Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4</span></span>
<span><span class='c'>#&gt; Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4</span></span>
<span><span class='c'>#&gt; Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1</span></span>
<span><span class='c'>#&gt; Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1</span></span>
<span><span class='c'>#&gt; Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2</span></span>
<span><span class='c'>#&gt; Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># 'flights' is a tibble, which affects its printing behavior</span></span>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/hadley/nycflights13'>nycflights13</a></span><span class='o'>)</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>flights</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 19</span></span></span>
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
<span><span class='c'>#&gt; <span style='color: #555555;'>#   ²​dep_delay, ³​arr_time, ⁴​sched_arr_time, ⁵​arr_delay</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># ℹ Use `colnames()` to see all variable names</span></span></span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## II -- Chapter 5.2: `filter()`

### Key points

-   The [`filter()`](https://dplyr.tidyverse.org/reference/filter.html) function removes rows (observations) from a dataframe based on conditions. You specify those conditions for one or more columns.

-   When you refer to a column, don't quote its name! (e.g. in `filter(flights, month == 1)`, where `month` is the column name.)

-   Use "comparison operators" like `>` (greater than) to specify conditions. Note that *two* equals signs `==` (and not a single, `=`) signifies equality, and that `!=` means "does not equal".

-   To combine multiple conditions, use logical (Boolean) operators: `&` (and), `|` (or), and `!` (not). Separating conditions by a comma also means "and" in *dplyr*, e.g. in `filter(flights, month == 1, day == 1)`.

-   The `%in%` operator tests if the value(s) on the left-hand side are contained in the values on the right hand side, e.g. `4 %in% 1:5` asks whether 4 is contained in the sequence of numbers from 1 to 5, which will return `TRUE`.

-   Missing values are denoted by `NA`, and almost any operation with an `NA` will return another `NA`. To test if `x` is or contains `NA`s, don't use `x == NA` but `is.na(x)`. When you filter based on a column, rows with `NA`s in that column will by default be removed by [`filter()`](https://dplyr.tidyverse.org/reference/filter.html).

<div class="puzzle">

<div>

### Exercise 1

Find all flights that...

1.  Had an arrival delay of two or more hours
2.  Flew to Houston (`IAH` or `HOU`)
3.  Were operated by United (`UA`), American (`AA`), or Delta (`DL`)
4.  Departed in summer (July, August, and September)
5.  Arrived more than two hours late, but didn't leave late
6.  Were delayed by at least an hour, but made up over 30 minutes in flight
7.  Departed between midnight and 6am (inclusive)

Before you start, load the necessary packages:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/hadley/nycflights13'>nycflights13</a></span><span class='o'>)</span></span>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span></span></code></pre>

</div>

<details>
<summary>
<b>Hints</b> (click here)
</summary>

-   Delays are given in minutes.

-   Times of day are numbered from `0001` (1 minute past midnight) to `2400` (midnight).

</details>

<br>

<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

*In the solutions below, I am piping the output to [`nrow()`](https://rdrr.io/r/base/nrow.html),* *so you can check if you got the same number of rows.*

\1. Had an arrival delay (=\> `arr_delay`) of two or more hours (=\> `>= 120`):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>flights</span>,</span>
<span>       <span class='nv'>arr_delay</span> <span class='o'>&gt;=</span> <span class='m'>120</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; [1] 10200</span></span></code></pre>

</div>

\2. Flew to Houston (`IAH` or `HOU`) -- destination is the `dest` column:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>flights</span>,</span>
<span>       <span class='nv'>dest</span> <span class='o'><a href='https://rdrr.io/r/base/match.html'>%in%</a></span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"IAH"</span>, <span class='s'>"HOU"</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; [1] 9313</span></span></code></pre>

</div>

\3. Were operated by United (`UA`), American (`AA`), or Delta (`DL`) --- this information is in the `carrier` column:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>flights</span>,</span>
<span>       <span class='nv'>carrier</span> <span class='o'><a href='https://rdrr.io/r/base/match.html'>%in%</a></span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"UA"</span>, <span class='s'>"AA"</span>, <span class='s'>"DL"</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; [1] 139504</span></span></code></pre>

</div>

\4. Departed in summer (July, August, and September) --- use the `month` column:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>flights</span>,</span>
<span>       <span class='nv'>month</span> <span class='o'><a href='https://rdrr.io/r/base/match.html'>%in%</a></span> <span class='m'>7</span><span class='o'>:</span><span class='m'>9</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; [1] 86326</span></span></code></pre>

</div>

This would also work:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>flights</span>,</span>
<span>       <span class='nv'>month</span> <span class='o'>&gt;=</span> <span class='m'>7</span>, <span class='nv'>month</span> <span class='o'>&lt;=</span> <span class='m'>9</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='o'>)</span></span></code></pre>

</div>

\5. Arrived more than two hours late, but didn't leave late --- use the `arr_delay` (arrival delay) and `dep_delay` (departure delay) columns:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>flights</span>,</span>
<span>       <span class='nv'>arr_delay</span> <span class='o'>&gt;</span> <span class='m'>120</span>, <span class='nv'>dep_delay</span> <span class='o'>&lt;=</span> <span class='m'>0</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; [1] 29</span></span></code></pre>

</div>

\6. Were delayed by at least an hour, but made up over 30 minutes in flight --- use the `dep_delay` and `arr_delay` columns, and note that "making up over 30 miniutes" implies that the arrival delay was more than 30 minutes smaller than the departure delay:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>flights</span>,</span>
<span>       <span class='nv'>dep_delay</span> <span class='o'>&gt;=</span> <span class='m'>60</span>, <span class='nv'>dep_delay</span> <span class='o'>-</span> <span class='nv'>arr_delay</span> <span class='o'>&gt;</span> <span class='m'>30</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; [1] 1844</span></span></code></pre>

</div>

\7. Departed between midnight and 6am (inclusive) --- use the `dep_time` column and note that `2400` is midnight:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>flights</span>,</span>
<span>       <span class='nv'>dep_time</span> <span class='o'>&lt;=</span> <span class='m'>600</span> <span class='o'>|</span> <span class='nv'>dep_time</span> <span class='o'>==</span> <span class='m'>2400</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; [1] 9373</span></span></code></pre>

</div>

</details>

</div>

</div>

<br>

<div class="puzzle">

<div>

### Exercise 3

How many flights have a missing `dep_time`? What other variables are missing for these flights? What might these rows represent?

<details>
<summary>
<b>Hints</b> (click here)
</summary>

-   A "missing" `dep_time` means that this cell contains the value `NA`.
-   Recall that you can test if something is `NA` with the [`is.na()`](https://rdrr.io/r/base/NA.html) function!
-   To count the number of flights, you can look at the information printed along with the dataframe (`... with X more rows`), or pipe (`%>%`) the dataframe into the [`nrow()`](https://rdrr.io/r/base/nrow.html) function, which counts the number of rows.

</details>

<br>

<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

-   *How many flights have a missing `dep_time`?*

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>flights</span>,</span>
<span>       <span class='nf'><a href='https://rdrr.io/r/base/NA.html'>is.na</a></span><span class='o'>(</span><span class='nv'>dep_time</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; [1] 8255</span></span></code></pre>

</div>

-   *What other variables are missing for these flights?*

    For example, arrival times.

-   *What might these rows represent?*

    These are cancelled flights.

</details>

</div>

</div>

<br>

------------------------------------------------------------------------

## III -- Chapter 5.3: `arrange()`

Key points:

-   The [`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html) function sorts the rows in a dataframe.

-   Sorting is in ascending order (smallest values first) by default --- use `desc(column_name)` to sort in descending order.

-   `NA` are always sorted at the end.

<div class="puzzle">

<div>

### Exercise 2

-   Sort flights to find the most delayed flights.
-   Find the flights that left earliest (relative to the scheduled time).

<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

-   If you sort in *descending* order by `dep_delay`, you'll get the most delayed flights at the top:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/arrange.html'>arrange</a></span><span class='o'>(</span><span class='nv'>flights</span>, <span class='nf'><a href='https://dplyr.tidyverse.org/reference/desc.html'>desc</a></span><span class='o'>(</span><span class='nv'>dep_delay</span><span class='o'>)</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 19</span></span></span>
<span><span class='c'>#&gt;     year month   day dep_time sched_de…¹ dep_d…² arr_t…³ sched…⁴ arr_d…⁵ carrier</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>  <span style='text-decoration: underline;'>2</span>013     1     9      641        900    <span style='text-decoration: underline;'>1</span>301    <span style='text-decoration: underline;'>1</span>242    <span style='text-decoration: underline;'>1</span>530    <span style='text-decoration: underline;'>1</span>272 HA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>  <span style='text-decoration: underline;'>2</span>013     6    15     <span style='text-decoration: underline;'>1</span>432       <span style='text-decoration: underline;'>1</span>935    <span style='text-decoration: underline;'>1</span>137    <span style='text-decoration: underline;'>1</span>607    <span style='text-decoration: underline;'>2</span>120    <span style='text-decoration: underline;'>1</span>127 MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>  <span style='text-decoration: underline;'>2</span>013     1    10     <span style='text-decoration: underline;'>1</span>121       <span style='text-decoration: underline;'>1</span>635    <span style='text-decoration: underline;'>1</span>126    <span style='text-decoration: underline;'>1</span>239    <span style='text-decoration: underline;'>1</span>810    <span style='text-decoration: underline;'>1</span>109 MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>  <span style='text-decoration: underline;'>2</span>013     9    20     <span style='text-decoration: underline;'>1</span>139       <span style='text-decoration: underline;'>1</span>845    <span style='text-decoration: underline;'>1</span>014    <span style='text-decoration: underline;'>1</span>457    <span style='text-decoration: underline;'>2</span>210    <span style='text-decoration: underline;'>1</span>007 AA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>  <span style='text-decoration: underline;'>2</span>013     7    22      845       <span style='text-decoration: underline;'>1</span>600    <span style='text-decoration: underline;'>1</span>005    <span style='text-decoration: underline;'>1</span>044    <span style='text-decoration: underline;'>1</span>815     989 MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>  <span style='text-decoration: underline;'>2</span>013     4    10     <span style='text-decoration: underline;'>1</span>100       <span style='text-decoration: underline;'>1</span>900     960    <span style='text-decoration: underline;'>1</span>342    <span style='text-decoration: underline;'>2</span>211     931 DL     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>  <span style='text-decoration: underline;'>2</span>013     3    17     <span style='text-decoration: underline;'>2</span>321        810     911     135    <span style='text-decoration: underline;'>1</span>020     915 DL     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>  <span style='text-decoration: underline;'>2</span>013     6    27      959       <span style='text-decoration: underline;'>1</span>900     899    <span style='text-decoration: underline;'>1</span>236    <span style='text-decoration: underline;'>2</span>226     850 DL     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>  <span style='text-decoration: underline;'>2</span>013     7    22     <span style='text-decoration: underline;'>2</span>257        759     898     121    <span style='text-decoration: underline;'>1</span>026     895 DL     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>  <span style='text-decoration: underline;'>2</span>013    12     5      756       <span style='text-decoration: underline;'>1</span>700     896    <span style='text-decoration: underline;'>1</span>058    <span style='text-decoration: underline;'>2</span>020     878 AA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows, 9 more variables: flight &lt;int&gt;, tailnum &lt;chr&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   origin &lt;chr&gt;, dest &lt;chr&gt;, air_time &lt;dbl&gt;, distance &lt;dbl&gt;, hour &lt;dbl&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   minute &lt;dbl&gt;, time_hour &lt;dttm&gt;, and abbreviated variable names</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   ¹​sched_dep_time, ²​dep_delay, ³​arr_time, ⁴​sched_arr_time, ⁵​arr_delay</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names</span></span></span></code></pre>

</div>

-   If you sort in *ascending* order by `dep_delay`, you'll get the flights that left earliest relative to the scheduled time at the top:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/arrange.html'>arrange</a></span><span class='o'>(</span><span class='nv'>flights</span>, <span class='nf'><a href='https://dplyr.tidyverse.org/reference/desc.html'>desc</a></span><span class='o'>(</span><span class='nv'>dep_delay</span><span class='o'>)</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 19</span></span></span>
<span><span class='c'>#&gt;     year month   day dep_time sched_de…¹ dep_d…² arr_t…³ sched…⁴ arr_d…⁵ carrier</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>  <span style='text-decoration: underline;'>2</span>013     1     9      641        900    <span style='text-decoration: underline;'>1</span>301    <span style='text-decoration: underline;'>1</span>242    <span style='text-decoration: underline;'>1</span>530    <span style='text-decoration: underline;'>1</span>272 HA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>  <span style='text-decoration: underline;'>2</span>013     6    15     <span style='text-decoration: underline;'>1</span>432       <span style='text-decoration: underline;'>1</span>935    <span style='text-decoration: underline;'>1</span>137    <span style='text-decoration: underline;'>1</span>607    <span style='text-decoration: underline;'>2</span>120    <span style='text-decoration: underline;'>1</span>127 MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>  <span style='text-decoration: underline;'>2</span>013     1    10     <span style='text-decoration: underline;'>1</span>121       <span style='text-decoration: underline;'>1</span>635    <span style='text-decoration: underline;'>1</span>126    <span style='text-decoration: underline;'>1</span>239    <span style='text-decoration: underline;'>1</span>810    <span style='text-decoration: underline;'>1</span>109 MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>  <span style='text-decoration: underline;'>2</span>013     9    20     <span style='text-decoration: underline;'>1</span>139       <span style='text-decoration: underline;'>1</span>845    <span style='text-decoration: underline;'>1</span>014    <span style='text-decoration: underline;'>1</span>457    <span style='text-decoration: underline;'>2</span>210    <span style='text-decoration: underline;'>1</span>007 AA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>  <span style='text-decoration: underline;'>2</span>013     7    22      845       <span style='text-decoration: underline;'>1</span>600    <span style='text-decoration: underline;'>1</span>005    <span style='text-decoration: underline;'>1</span>044    <span style='text-decoration: underline;'>1</span>815     989 MQ     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>  <span style='text-decoration: underline;'>2</span>013     4    10     <span style='text-decoration: underline;'>1</span>100       <span style='text-decoration: underline;'>1</span>900     960    <span style='text-decoration: underline;'>1</span>342    <span style='text-decoration: underline;'>2</span>211     931 DL     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>  <span style='text-decoration: underline;'>2</span>013     3    17     <span style='text-decoration: underline;'>2</span>321        810     911     135    <span style='text-decoration: underline;'>1</span>020     915 DL     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>  <span style='text-decoration: underline;'>2</span>013     6    27      959       <span style='text-decoration: underline;'>1</span>900     899    <span style='text-decoration: underline;'>1</span>236    <span style='text-decoration: underline;'>2</span>226     850 DL     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>  <span style='text-decoration: underline;'>2</span>013     7    22     <span style='text-decoration: underline;'>2</span>257        759     898     121    <span style='text-decoration: underline;'>1</span>026     895 DL     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>  <span style='text-decoration: underline;'>2</span>013    12     5      756       <span style='text-decoration: underline;'>1</span>700     896    <span style='text-decoration: underline;'>1</span>058    <span style='text-decoration: underline;'>2</span>020     878 AA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows, 9 more variables: flight &lt;int&gt;, tailnum &lt;chr&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   origin &lt;chr&gt;, dest &lt;chr&gt;, air_time &lt;dbl&gt;, distance &lt;dbl&gt;, hour &lt;dbl&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   minute &lt;dbl&gt;, time_hour &lt;dttm&gt;, and abbreviated variable names</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   ¹​sched_dep_time, ²​dep_delay, ³​arr_time, ⁴​sched_arr_time, ⁵​arr_delay</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names</span></span></span></code></pre>

</div>

</details>

</div>

</div>

<br>

<div class="puzzle">

<div>

### Exercise 4

-   Which flights travelled the farthest?
-   Which travelled the shortest?

<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

-   *Which flights travelled the farthest?*

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/arrange.html'>arrange</a></span><span class='o'>(</span><span class='nv'>flights</span>, <span class='nf'><a href='https://dplyr.tidyverse.org/reference/desc.html'>desc</a></span><span class='o'>(</span><span class='nv'>distance</span><span class='o'>)</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 19</span></span></span>
<span><span class='c'>#&gt;     year month   day dep_time sched_de…¹ dep_d…² arr_t…³ sched…⁴ arr_d…⁵ carrier</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>  <span style='text-decoration: underline;'>2</span>013     1     1      857        900      -<span style='color: #BB0000;'>3</span>    <span style='text-decoration: underline;'>1</span>516    <span style='text-decoration: underline;'>1</span>530     -<span style='color: #BB0000;'>14</span> HA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>  <span style='text-decoration: underline;'>2</span>013     1     2      909        900       9    <span style='text-decoration: underline;'>1</span>525    <span style='text-decoration: underline;'>1</span>530      -<span style='color: #BB0000;'>5</span> HA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>  <span style='text-decoration: underline;'>2</span>013     1     3      914        900      14    <span style='text-decoration: underline;'>1</span>504    <span style='text-decoration: underline;'>1</span>530     -<span style='color: #BB0000;'>26</span> HA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>  <span style='text-decoration: underline;'>2</span>013     1     4      900        900       0    <span style='text-decoration: underline;'>1</span>516    <span style='text-decoration: underline;'>1</span>530     -<span style='color: #BB0000;'>14</span> HA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>  <span style='text-decoration: underline;'>2</span>013     1     5      858        900      -<span style='color: #BB0000;'>2</span>    <span style='text-decoration: underline;'>1</span>519    <span style='text-decoration: underline;'>1</span>530     -<span style='color: #BB0000;'>11</span> HA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>  <span style='text-decoration: underline;'>2</span>013     1     6     <span style='text-decoration: underline;'>1</span>019        900      79    <span style='text-decoration: underline;'>1</span>558    <span style='text-decoration: underline;'>1</span>530      28 HA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>  <span style='text-decoration: underline;'>2</span>013     1     7     <span style='text-decoration: underline;'>1</span>042        900     102    <span style='text-decoration: underline;'>1</span>620    <span style='text-decoration: underline;'>1</span>530      50 HA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>  <span style='text-decoration: underline;'>2</span>013     1     8      901        900       1    <span style='text-decoration: underline;'>1</span>504    <span style='text-decoration: underline;'>1</span>530     -<span style='color: #BB0000;'>26</span> HA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>  <span style='text-decoration: underline;'>2</span>013     1     9      641        900    <span style='text-decoration: underline;'>1</span>301    <span style='text-decoration: underline;'>1</span>242    <span style='text-decoration: underline;'>1</span>530    <span style='text-decoration: underline;'>1</span>272 HA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>  <span style='text-decoration: underline;'>2</span>013     1    10      859        900      -<span style='color: #BB0000;'>1</span>    <span style='text-decoration: underline;'>1</span>449    <span style='text-decoration: underline;'>1</span>530     -<span style='color: #BB0000;'>41</span> HA     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows, 9 more variables: flight &lt;int&gt;, tailnum &lt;chr&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   origin &lt;chr&gt;, dest &lt;chr&gt;, air_time &lt;dbl&gt;, distance &lt;dbl&gt;, hour &lt;dbl&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   minute &lt;dbl&gt;, time_hour &lt;dttm&gt;, and abbreviated variable names</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   ¹​sched_dep_time, ²​dep_delay, ³​arr_time, ⁴​sched_arr_time, ⁵​arr_delay</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names</span></span></span></code></pre>

</div>

-   *Which travelled the shortest?*

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/arrange.html'>arrange</a></span><span class='o'>(</span><span class='nv'>flights</span>, <span class='nv'>distance</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 336,776 × 19</span></span></span>
<span><span class='c'>#&gt;     year month   day dep_time sched_de…¹ dep_d…² arr_t…³ sched…⁴ arr_d…⁵ carrier</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>  <span style='text-decoration: underline;'>2</span>013     7    27       <span style='color: #BB0000;'>NA</span>        106      <span style='color: #BB0000;'>NA</span>      <span style='color: #BB0000;'>NA</span>     245      <span style='color: #BB0000;'>NA</span> US     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>  <span style='text-decoration: underline;'>2</span>013     1     3     <span style='text-decoration: underline;'>2</span>127       <span style='text-decoration: underline;'>2</span>129      -<span style='color: #BB0000;'>2</span>    <span style='text-decoration: underline;'>2</span>222    <span style='text-decoration: underline;'>2</span>224      -<span style='color: #BB0000;'>2</span> EV     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>  <span style='text-decoration: underline;'>2</span>013     1     4     <span style='text-decoration: underline;'>1</span>240       <span style='text-decoration: underline;'>1</span>200      40    <span style='text-decoration: underline;'>1</span>333    <span style='text-decoration: underline;'>1</span>306      27 EV     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>  <span style='text-decoration: underline;'>2</span>013     1     4     <span style='text-decoration: underline;'>1</span>829       <span style='text-decoration: underline;'>1</span>615     134    <span style='text-decoration: underline;'>1</span>937    <span style='text-decoration: underline;'>1</span>721     136 EV     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>  <span style='text-decoration: underline;'>2</span>013     1     4     <span style='text-decoration: underline;'>2</span>128       <span style='text-decoration: underline;'>2</span>129      -<span style='color: #BB0000;'>1</span>    <span style='text-decoration: underline;'>2</span>218    <span style='text-decoration: underline;'>2</span>224      -<span style='color: #BB0000;'>6</span> EV     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>  <span style='text-decoration: underline;'>2</span>013     1     5     <span style='text-decoration: underline;'>1</span>155       <span style='text-decoration: underline;'>1</span>200      -<span style='color: #BB0000;'>5</span>    <span style='text-decoration: underline;'>1</span>241    <span style='text-decoration: underline;'>1</span>306     -<span style='color: #BB0000;'>25</span> EV     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>  <span style='text-decoration: underline;'>2</span>013     1     6     <span style='text-decoration: underline;'>2</span>125       <span style='text-decoration: underline;'>2</span>129      -<span style='color: #BB0000;'>4</span>    <span style='text-decoration: underline;'>2</span>224    <span style='text-decoration: underline;'>2</span>224       0 EV     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>  <span style='text-decoration: underline;'>2</span>013     1     7     <span style='text-decoration: underline;'>2</span>124       <span style='text-decoration: underline;'>2</span>129      -<span style='color: #BB0000;'>5</span>    <span style='text-decoration: underline;'>2</span>212    <span style='text-decoration: underline;'>2</span>224     -<span style='color: #BB0000;'>12</span> EV     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>  <span style='text-decoration: underline;'>2</span>013     1     8     <span style='text-decoration: underline;'>2</span>127       <span style='text-decoration: underline;'>2</span>130      -<span style='color: #BB0000;'>3</span>    <span style='text-decoration: underline;'>2</span>304    <span style='text-decoration: underline;'>2</span>225      39 EV     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>  <span style='text-decoration: underline;'>2</span>013     1     9     <span style='text-decoration: underline;'>2</span>126       <span style='text-decoration: underline;'>2</span>129      -<span style='color: #BB0000;'>3</span>    <span style='text-decoration: underline;'>2</span>217    <span style='text-decoration: underline;'>2</span>224      -<span style='color: #BB0000;'>7</span> EV     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 336,766 more rows, 9 more variables: flight &lt;int&gt;, tailnum &lt;chr&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   origin &lt;chr&gt;, dest &lt;chr&gt;, air_time &lt;dbl&gt;, distance &lt;dbl&gt;, hour &lt;dbl&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   minute &lt;dbl&gt;, time_hour &lt;dttm&gt;, and abbreviated variable names</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   ¹​sched_dep_time, ²​dep_delay, ³​arr_time, ⁴​sched_arr_time, ⁵​arr_delay</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names</span></span></span></code></pre>

</div>

</details>

</div>

</div>

<br> <br>

