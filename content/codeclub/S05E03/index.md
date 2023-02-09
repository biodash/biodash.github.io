---
output: hugodown::md_document
title: "S05E03: R4DS (2e) - Ch. 6 - Tidy Data 2"
subtitle: "Today, we will revisit tidy data, review pivot_longer() and learn pivot_wider()."
summary: "Today, we will revisit tidy data, review pivot_longer() and learn pivot_wider()."
authors: [jessica-cooperstone]
tags: [codeclub, r4ds]
date: "2023-02-09"
lastmod: "2023-02-09"
toc: true

image: 
  caption: "Illustrations from the Openscapes blog Tidy Data for reproducibility, efficiency, and collaboration by Julia Lowndes and Allison Horst"
  focal_point: ""
  preview_only: false
rmd_hash: 4a1a156ee22f8683

---

<br> <br>

------------------------------------------------------------------------

## Introduction

Today we will continue learning about a consistent way to organize your data in R, using a system called **"tidy" data**.

[Last week](https://biodash.github.io/codeclub/s05e02/) we went over [`pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html), and today we are going to:

-   refresh on tidy data
-   refresh on [`pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html)
-   learn [`pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html)

If you want to download the R script that goes along with today's code club you can do so with the following code:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># save the url location for today's script</span></span>
<span><span class='nv'>todays_R_script</span> <span class='o'>&lt;-</span> <span class='s'>'https://github.com/biodash/biodash.github.io/raw/master/content/codeclub/S05E03/r4ds_tidying2.R'</span></span>
<span></span>
<span><span class='c'># go get that file! </span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>todays_R_script</span>,</span>
<span>              destfile <span class='o'>=</span> <span class='s'>"r4ds_tidying2.R"</span><span class='o'>)</span></span>
<span></span></code></pre>

</div>

The file will be downloaded to your working directory. If you don't know where that is, you can find out by executing [`getwd()`](https://rdrr.io/r/base/getwd.html) in your console.

We will again be using tools embedded within the `tidyverse` package, so we need to load it before we can use it. We do that with the [`library()`](https://rdrr.io/r/base/library.html) function.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># you should have the tidyverse installed, but if not, do so using:</span></span>
<span><span class='c'># install.packages("tidyverse")</span></span>
<span></span>
<span><span class='c'># load the tidyverse</span></span>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span></span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## What is tidy data?

Let's briefly go over again the idea of tidy data.

<p align="center">
<img src=img/tidy_data.jpeg width="90%" alt="Stylized text providing an overview of Tidy Data. The top reads “Tidy data is a standard way of mapping the meaning of a dataset to its structure. - Hadley Wickham.” On the left reads “In tidy data: each variable forms a column; each observation forms a row; each cell is a single measurement.” There is an example table on the lower right with columns ‘id’, ‘name’ and ‘color’ with observations for different cats, illustrating tidy data structure.">
</p>

*(Illustrations from the [Openscapes](https://www.openscapes.org/) blog* *[Tidy Data for reproducibility, efficiency, and collaboration](https://www.openscapes.org/blog/2020/10/12/tidy-data/)* *by Julia Lowndes and Allison Horst.)*

This is easier to "see" 👀 than to explain. Here is an example of non-tidy data, where there is *data embedded in column names*, and one variable (the rank of a song) is spread across many columns:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>billboard</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 317 × 79</span></span></span>
<span><span class='c'>#&gt;    artist track date.ent…¹   wk1   wk2   wk3   wk4   wk5   wk6   wk7   wk8   wk9</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;date&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> 2 Pac  Baby… 2000-02-26    87    82    72    77    87    94    99    <span style='color: #BB0000;'>NA</span>    <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> 2Ge+h… The … 2000-09-02    91    87    92    <span style='color: #BB0000;'>NA</span>    <span style='color: #BB0000;'>NA</span>    <span style='color: #BB0000;'>NA</span>    <span style='color: #BB0000;'>NA</span>    <span style='color: #BB0000;'>NA</span>    <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> 3 Doo… Kryp… 2000-04-08    81    70    68    67    66    57    54    53    51</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> 3 Doo… Loser 2000-10-21    76    76    72    69    67    65    55    59    62</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> 504 B… Wobb… 2000-04-15    57    34    25    17    17    31    36    49    53</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> 98^0   Give… 2000-08-19    51    39    34    26    26    19     2     2     3</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> A*Tee… Danc… 2000-07-08    97    97    96    95   100    <span style='color: #BB0000;'>NA</span>    <span style='color: #BB0000;'>NA</span>    <span style='color: #BB0000;'>NA</span>    <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> Aaliy… I Do… 2000-01-29    84    62    51    41    38    35    35    38    38</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> Aaliy… Try … 2000-03-18    59    53    38    28    21    18    16    14    12</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> Adams… Open… 2000-08-26    76    76    74    69    68    67    61    58    57</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 307 more rows, 67 more variables: wk10 &lt;dbl&gt;, wk11 &lt;dbl&gt;, wk12 &lt;dbl&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   wk13 &lt;dbl&gt;, wk14 &lt;dbl&gt;, wk15 &lt;dbl&gt;, wk16 &lt;dbl&gt;, wk17 &lt;dbl&gt;, wk18 &lt;dbl&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   wk19 &lt;dbl&gt;, wk20 &lt;dbl&gt;, wk21 &lt;dbl&gt;, wk22 &lt;dbl&gt;, wk23 &lt;dbl&gt;, wk24 &lt;dbl&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   wk25 &lt;dbl&gt;, wk26 &lt;dbl&gt;, wk27 &lt;dbl&gt;, wk28 &lt;dbl&gt;, wk29 &lt;dbl&gt;, wk30 &lt;dbl&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   wk31 &lt;dbl&gt;, wk32 &lt;dbl&gt;, wk33 &lt;dbl&gt;, wk34 &lt;dbl&gt;, wk35 &lt;dbl&gt;, wk36 &lt;dbl&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   wk37 &lt;dbl&gt;, wk38 &lt;dbl&gt;, wk39 &lt;dbl&gt;, wk40 &lt;dbl&gt;, wk41 &lt;dbl&gt;, wk42 &lt;dbl&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   wk43 &lt;dbl&gt;, wk44 &lt;dbl&gt;, wk45 &lt;dbl&gt;, wk46 &lt;dbl&gt;, wk47 &lt;dbl&gt;, wk48 &lt;dbl&gt;, …</span></span></span></code></pre>

</div>

Here is an example of the same exact data, in a tidy format, where those data that used to be column names, are now *values coded for a particular variable*.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 24,092 × 5</span></span></span>
<span><span class='c'>#&gt;    artist track                   date.entered week   rank</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                   <span style='color: #555555; font-style: italic;'>&lt;date&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk1      87</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk2      82</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk3      72</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk4      77</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk5      87</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk6      94</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk7      99</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk8      <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk9      <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk10     <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 24,082 more rows</span></span></span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## Why should you care?

Let's go through an example where we will learn that we can't make the visualization that we want, because our data is not in tidy format.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># look at world_bank_pop using head</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>world_bank_pop</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 20</span></span></span>
<span><span class='c'>#&gt;   country indic…¹ `2000`  `2001`  `2002`  `2003`  `2004`  `2005`  `2006`  `2007`</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> ABW     SP.URB… 4.16<span style='color: #555555;'>e</span>4 4.20<span style='color: #555555;'>e</span>+4 4.22<span style='color: #555555;'>e</span>+4 4.23<span style='color: #555555;'>e</span>+4 4.23<span style='color: #555555;'>e</span>+4 4.24<span style='color: #555555;'>e</span>+4 4.26<span style='color: #555555;'>e</span>+4 4.27<span style='color: #555555;'>e</span>+4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> ABW     SP.URB… 1.66<span style='color: #555555;'>e</span>0 9.56<span style='color: #555555;'>e</span><span style='color: #BB0000;'>-1</span> 4.01<span style='color: #555555;'>e</span><span style='color: #BB0000;'>-1</span> 1.97<span style='color: #555555;'>e</span><span style='color: #BB0000;'>-1</span> 9.46<span style='color: #555555;'>e</span><span style='color: #BB0000;'>-2</span> 1.94<span style='color: #555555;'>e</span><span style='color: #BB0000;'>-1</span> 3.67<span style='color: #555555;'>e</span><span style='color: #BB0000;'>-1</span> 4.08<span style='color: #555555;'>e</span><span style='color: #BB0000;'>-1</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> ABW     SP.POP… 8.91<span style='color: #555555;'>e</span>4 9.07<span style='color: #555555;'>e</span>+4 9.18<span style='color: #555555;'>e</span>+4 9.27<span style='color: #555555;'>e</span>+4 9.35<span style='color: #555555;'>e</span>+4 9.45<span style='color: #555555;'>e</span>+4 9.56<span style='color: #555555;'>e</span>+4 9.68<span style='color: #555555;'>e</span>+4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> ABW     SP.POP… 2.54<span style='color: #555555;'>e</span>0 1.77<span style='color: #555555;'>e</span>+0 1.19<span style='color: #555555;'>e</span>+0 9.97<span style='color: #555555;'>e</span><span style='color: #BB0000;'>-1</span> 9.01<span style='color: #555555;'>e</span><span style='color: #BB0000;'>-1</span> 1.00<span style='color: #555555;'>e</span>+0 1.18<span style='color: #555555;'>e</span>+0 1.23<span style='color: #555555;'>e</span>+0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> AFE     SP.URB… 1.16<span style='color: #555555;'>e</span>8 1.20<span style='color: #555555;'>e</span>+8 1.24<span style='color: #555555;'>e</span>+8 1.29<span style='color: #555555;'>e</span>+8 1.34<span style='color: #555555;'>e</span>+8 1.39<span style='color: #555555;'>e</span>+8 1.44<span style='color: #555555;'>e</span>+8 1.49<span style='color: #555555;'>e</span>+8</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> AFE     SP.URB… 3.60<span style='color: #555555;'>e</span>0 3.66<span style='color: #555555;'>e</span>+0 3.72<span style='color: #555555;'>e</span>+0 3.71<span style='color: #555555;'>e</span>+0 3.74<span style='color: #555555;'>e</span>+0 3.81<span style='color: #555555;'>e</span>+0 3.81<span style='color: #555555;'>e</span>+0 3.61<span style='color: #555555;'>e</span>+0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 10 more variables: `2008` &lt;dbl&gt;, `2009` &lt;dbl&gt;, `2010` &lt;dbl&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   `2011` &lt;dbl&gt;, `2012` &lt;dbl&gt;, `2013` &lt;dbl&gt;, `2014` &lt;dbl&gt;, `2015` &lt;dbl&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   `2016` &lt;dbl&gt;, `2017` &lt;dbl&gt;, and abbreviated variable name ¹​indicator</span></span></span></code></pre>

</div>

What if we want to make a plot to see how population has changed (y-axis) for a specific country (say, the USA) over the duration for which data is collected (x-axis)? With the data in this format, we cannot make this plot, at least not with *ggplot2*. This is because **year** is not a column in our dataframe. This population information is spread over all of the columns that have a year as their name.

We can fix this by using [`pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>world_bank_pop_tidy</span> <span class='o'>&lt;-</span> <span class='nv'>world_bank_pop</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/pivot_longer.html'>pivot_longer</a></span><span class='o'>(</span>cols <span class='o'>=</span> <span class='o'>!</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='nv'>country</span>, <span class='nv'>indicator</span><span class='o'>)</span>, <span class='c'># which columns do we want to "pivot"</span></span>
<span>               names_to <span class='o'>=</span> <span class='s'>"year"</span>, <span class='c'># where should the column names go</span></span>
<span>               values_to <span class='o'>=</span> <span class='s'>"measure"</span><span class='o'>)</span> <span class='c'># where should the values within each cell go</span></span>
<span></span>
<span><span class='c'># check how this went</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>world_bank_pop_tidy</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 4</span></span></span>
<span><span class='c'>#&gt;   country indicator   year  measure</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> ABW     SP.URB.TOTL 2000    <span style='text-decoration: underline;'>41</span>625</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> ABW     SP.URB.TOTL 2001    <span style='text-decoration: underline;'>42</span>025</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> ABW     SP.URB.TOTL 2002    <span style='text-decoration: underline;'>42</span>194</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> ABW     SP.URB.TOTL 2003    <span style='text-decoration: underline;'>42</span>277</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> ABW     SP.URB.TOTL 2004    <span style='text-decoration: underline;'>42</span>317</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> ABW     SP.URB.TOTL 2005    <span style='text-decoration: underline;'>42</span>399</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># convert year from a character to a number so we can plot it </span></span>
<span><span class='nv'>world_bank_pop_tidy</span> <span class='o'>&lt;-</span> <span class='nv'>world_bank_pop_tidy</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>year <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/numeric.html'>as.numeric</a></span><span class='o'>(</span><span class='nv'>year</span><span class='o'>)</span><span class='o'>)</span></span>
<span></span>
<span><span class='c'># check again </span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>world_bank_pop_tidy</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 4</span></span></span>
<span><span class='c'>#&gt;   country indicator    year measure</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> ABW     SP.URB.TOTL  <span style='text-decoration: underline;'>2</span>000   <span style='text-decoration: underline;'>41</span>625</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> ABW     SP.URB.TOTL  <span style='text-decoration: underline;'>2</span>001   <span style='text-decoration: underline;'>42</span>025</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> ABW     SP.URB.TOTL  <span style='text-decoration: underline;'>2</span>002   <span style='text-decoration: underline;'>42</span>194</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> ABW     SP.URB.TOTL  <span style='text-decoration: underline;'>2</span>003   <span style='text-decoration: underline;'>42</span>277</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> ABW     SP.URB.TOTL  <span style='text-decoration: underline;'>2</span>004   <span style='text-decoration: underline;'>42</span>317</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> ABW     SP.URB.TOTL  <span style='text-decoration: underline;'>2</span>005   <span style='text-decoration: underline;'>42</span>399</span></span></code></pre>

</div>

Now we can make the plot we want. If you're not familiar with ggplot syntax you can learn more in the R4DS section called [Visualize](https://r4ds.hadley.nz/visualize.html) or in past code clubs on:

-   [ggplot](https://biodash.github.io/codeclub/s02e06_ggplot2/)
-   [ggplot some more](https://biodash.github.io/codeclub/s02e07_ggplot2_part2/)
-   [my data viz class](https://datavisualizing.netlify.app/module2.html)

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># a minimal plot</span></span>
<span><span class='nv'>world_bank_pop_tidy</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>country</span> <span class='o'>==</span> <span class='s'>"USA"</span><span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>indicator</span> <span class='o'>==</span> <span class='s'>"SP.POP.TOTL"</span><span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>year</span>, y <span class='o'>=</span> <span class='nv'>measure</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_point.html'>geom_point</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_path.html'>geom_line</a></span><span class='o'>(</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/world_bank_pop-plot-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<br>

<div class="puzzle">

<div>

<details>
<summary>
<b>If you want to see a more polished version of this plot </b>(click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># a more polished plot</span></span>
<span><span class='nv'>world_bank_pop_tidy</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>country</span> <span class='o'>==</span> <span class='s'>"USA"</span><span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>indicator</span> <span class='o'>==</span> <span class='s'>"SP.POP.TOTL"</span><span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>year</span>, y <span class='o'>=</span> <span class='nv'>measure</span>, color <span class='o'>=</span> <span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_point.html'>geom_point</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_path.html'>geom_line</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/scale_continuous.html'>scale_y_continuous</a></span><span class='o'>(</span>limits <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>0</span>, <span class='m'>4e8</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span><span class='c'># ylim(c(0, 4e8)) + # also works instead of scale_y_continuous</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggtheme.html'>theme_minimal</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/theme.html'>theme</a></span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"none"</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/labs.html'>labs</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Year"</span>,</span>
<span>       y <span class='o'>=</span> <span class='s'>"Population"</span>,</span>
<span>       title <span class='o'>=</span> <span class='s'>"Total population in the United States \nfrom 2000 to 2017"</span>,</span>
<span>       caption <span class='o'>=</span> <span class='s'>"Data from the World Bank"</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/world_bank_pop-plot-polished-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

</div>

<br>

Often it may be easier to collect your data in wide format, but analyze it in tidy (i.e., long) format.

> This does not mean you must now collect your data in tidy format! You simply need to become comfortable with switching between formats.

<br>

------------------------------------------------------------------------

## Two functions for pivoting data

[**`pivot_longer()`**](https://tidyr.tidyverse.org/reference/pivot_longer.html) pulls data that is embedded in column names, and reshapes your dataframe such this information is now embedded within the values. Or put differently, it collects variables that are spread across multiple columns into a single column. This makes your dataframes longer, i.e., increases the number of rows. *Typically*, we use [`pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html) to make an untidy dataset tidy.

[**`pivot_wider()`**](https://tidyr.tidyverse.org/reference/pivot_wider.html) takes data that is embedded in the values of your dataframe, and puts this information in variable names. Or put differently, it spreads a variable across multiple columns. This makes your dataframe "wider", i.e., increases the number of columns. *Typically*, [`pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html) will make a dataset untidy. This can be useful for certain calculations, or if you want to use a for loop to do something iteratively across columns.

<br>

### `pivot_wider()`

The opposite of [`pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html) is [`pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html). We haven't used [`pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html) get so let's try it. We are going to use the dataframe `population` which is pre-loaded with the tidyverse. This dataframe is currently in tidy format.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># what is in population?</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>population</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 3</span></span></span>
<span><span class='c'>#&gt;   country      year population</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Afghanistan  <span style='text-decoration: underline;'>1</span>995   17<span style='text-decoration: underline;'>586</span>073</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Afghanistan  <span style='text-decoration: underline;'>1</span>996   18<span style='text-decoration: underline;'>415</span>307</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> Afghanistan  <span style='text-decoration: underline;'>1</span>997   19<span style='text-decoration: underline;'>021</span>226</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> Afghanistan  <span style='text-decoration: underline;'>1</span>998   19<span style='text-decoration: underline;'>496</span>836</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> Afghanistan  <span style='text-decoration: underline;'>1</span>999   19<span style='text-decoration: underline;'>987</span>071</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> Afghanistan  <span style='text-decoration: underline;'>2</span>000   20<span style='text-decoration: underline;'>595</span>360</span></span></code></pre>

</div>

What if we wanted to adjust the data so that instead of having a column called `year`, the data for each year is its own column, and have the corresponding `population` within each cell ? We can do that with [`pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>population_wide</span> <span class='o'>&lt;-</span> <span class='nv'>population</span> <span class='o'>|&gt;</span></span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/pivot_wider.html'>pivot_wider</a></span><span class='o'>(</span>names_from <span class='o'>=</span> <span class='s'>"year"</span>,</span>
<span>              values_from <span class='o'>=</span> <span class='s'>"population"</span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>population_wide</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 20</span></span></span>
<span><span class='c'>#&gt;   country  `1995` `1996` `1997` `1998` `1999` `2000` `2001` `2002` `2003` `2004`</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Afghani… 1.76<span style='color: #555555;'>e</span>7 1.84<span style='color: #555555;'>e</span>7 1.90<span style='color: #555555;'>e</span>7 1.95<span style='color: #555555;'>e</span>7 2.00<span style='color: #555555;'>e</span>7 2.06<span style='color: #555555;'>e</span>7 2.13<span style='color: #555555;'>e</span>7 2.22<span style='color: #555555;'>e</span>7 2.31<span style='color: #555555;'>e</span>7 2.40<span style='color: #555555;'>e</span>7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Albania  3.36<span style='color: #555555;'>e</span>6 3.34<span style='color: #555555;'>e</span>6 3.33<span style='color: #555555;'>e</span>6 3.33<span style='color: #555555;'>e</span>6 3.32<span style='color: #555555;'>e</span>6 3.30<span style='color: #555555;'>e</span>6 3.29<span style='color: #555555;'>e</span>6 3.26<span style='color: #555555;'>e</span>6 3.24<span style='color: #555555;'>e</span>6 3.22<span style='color: #555555;'>e</span>6</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> Algeria  2.93<span style='color: #555555;'>e</span>7 2.98<span style='color: #555555;'>e</span>7 3.03<span style='color: #555555;'>e</span>7 3.08<span style='color: #555555;'>e</span>7 3.13<span style='color: #555555;'>e</span>7 3.17<span style='color: #555555;'>e</span>7 3.22<span style='color: #555555;'>e</span>7 3.26<span style='color: #555555;'>e</span>7 3.30<span style='color: #555555;'>e</span>7 3.35<span style='color: #555555;'>e</span>7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> America… 5.29<span style='color: #555555;'>e</span>4 5.39<span style='color: #555555;'>e</span>4 5.49<span style='color: #555555;'>e</span>4 5.59<span style='color: #555555;'>e</span>4 5.68<span style='color: #555555;'>e</span>4 5.75<span style='color: #555555;'>e</span>4 5.82<span style='color: #555555;'>e</span>4 5.87<span style='color: #555555;'>e</span>4 5.91<span style='color: #555555;'>e</span>4 5.93<span style='color: #555555;'>e</span>4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> Andorra  6.39<span style='color: #555555;'>e</span>4 6.43<span style='color: #555555;'>e</span>4 6.41<span style='color: #555555;'>e</span>4 6.38<span style='color: #555555;'>e</span>4 6.41<span style='color: #555555;'>e</span>4 6.54<span style='color: #555555;'>e</span>4 6.8 <span style='color: #555555;'>e</span>4 7.16<span style='color: #555555;'>e</span>4 7.56<span style='color: #555555;'>e</span>4 7.91<span style='color: #555555;'>e</span>4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> Angola   1.21<span style='color: #555555;'>e</span>7 1.25<span style='color: #555555;'>e</span>7 1.28<span style='color: #555555;'>e</span>7 1.31<span style='color: #555555;'>e</span>7 1.35<span style='color: #555555;'>e</span>7 1.39<span style='color: #555555;'>e</span>7 1.44<span style='color: #555555;'>e</span>7 1.49<span style='color: #555555;'>e</span>7 1.54<span style='color: #555555;'>e</span>7 1.60<span style='color: #555555;'>e</span>7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 9 more variables: `2005` &lt;dbl&gt;, `2006` &lt;dbl&gt;, `2007` &lt;dbl&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   `2008` &lt;dbl&gt;, `2009` &lt;dbl&gt;, `2010` &lt;dbl&gt;, `2011` &lt;dbl&gt;, `2012` &lt;dbl&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   `2013` &lt;dbl&gt;</span></span></span></code></pre>

</div>

### `pivot_longer()`

Let's practice using [`pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html) again. We just made a wide dataframe with [`pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html) -- can we make it long again?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>population_long</span> <span class='o'>&lt;-</span> <span class='nv'>population_wide</span> <span class='o'>|&gt;</span></span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/pivot_longer.html'>pivot_longer</a></span><span class='o'>(</span>cols <span class='o'>=</span> <span class='o'>!</span><span class='nv'>country</span>, <span class='c'># all columns except country</span></span>
<span>               names_to <span class='o'>=</span> <span class='s'>"year"</span>,</span>
<span>               values_to <span class='o'>=</span> <span class='s'>"population"</span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>population_long</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 3</span></span></span>
<span><span class='c'>#&gt;   country     year  population</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Afghanistan 1995    17<span style='text-decoration: underline;'>586</span>073</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Afghanistan 1996    18<span style='text-decoration: underline;'>415</span>307</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> Afghanistan 1997    19<span style='text-decoration: underline;'>021</span>226</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> Afghanistan 1998    19<span style='text-decoration: underline;'>496</span>836</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> Afghanistan 1999    19<span style='text-decoration: underline;'>987</span>071</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> Afghanistan 2000    20<span style='text-decoration: underline;'>595</span>360</span></span></code></pre>

</div>

There are many different ways you can code to tell R which columns you want to pivot. I'm showing below some other ways to code the same outcome, but you can find a more ocomprehensive list of [tidy-select helpers](https://tidyr.tidyverse.org/reference/tidyr_tidy_select.html) in the `tidyr` documentation page.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>population_long</span> <span class='o'>&lt;-</span> <span class='nv'>population_wide</span> <span class='o'>|&gt;</span></span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/pivot_longer.html'>pivot_longer</a></span><span class='o'>(</span>cols <span class='o'>=</span> <span class='nf'><a href='https://tidyselect.r-lib.org/reference/where.html'>where</a></span><span class='o'>(</span><span class='nv'>is.numeric</span><span class='o'>)</span>, <span class='c'># all numeric columns</span></span>
<span>               names_to <span class='o'>=</span> <span class='s'>"year"</span>,</span>
<span>               values_to <span class='o'>=</span> <span class='s'>"population"</span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>population_long</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 3</span></span></span>
<span><span class='c'>#&gt;   country     year  population</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Afghanistan 1995    17<span style='text-decoration: underline;'>586</span>073</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Afghanistan 1996    18<span style='text-decoration: underline;'>415</span>307</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> Afghanistan 1997    19<span style='text-decoration: underline;'>021</span>226</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> Afghanistan 1998    19<span style='text-decoration: underline;'>496</span>836</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> Afghanistan 1999    19<span style='text-decoration: underline;'>987</span>071</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> Afghanistan 2000    20<span style='text-decoration: underline;'>595</span>360</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>population_long</span> <span class='o'>&lt;-</span> <span class='nv'>population_wide</span> <span class='o'>|&gt;</span></span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/pivot_longer.html'>pivot_longer</a></span><span class='o'>(</span>cols <span class='o'>=</span> <span class='m'>2</span><span class='o'>:</span><span class='m'>20</span>, <span class='c'># columns 2 through 20</span></span>
<span>               names_to <span class='o'>=</span> <span class='s'>"year"</span>,</span>
<span>               values_to <span class='o'>=</span> <span class='s'>"population"</span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>population_long</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 3</span></span></span>
<span><span class='c'>#&gt;   country     year  population</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Afghanistan 1995    17<span style='text-decoration: underline;'>586</span>073</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Afghanistan 1996    18<span style='text-decoration: underline;'>415</span>307</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> Afghanistan 1997    19<span style='text-decoration: underline;'>021</span>226</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> Afghanistan 1998    19<span style='text-decoration: underline;'>496</span>836</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> Afghanistan 1999    19<span style='text-decoration: underline;'>987</span>071</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> Afghanistan 2000    20<span style='text-decoration: underline;'>595</span>360</span></span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## Breakout Rooms

We are going to use a dataset that is a part of the `#TidyTuesday` series of data activities for tidyverse/R learning. I've picked some [data](https://github.com/rfordatascience/tidytuesday/tree/master/data/2022/2022-02-01) that comes from the American Kennel Club and was compiled by [KKakey](https://github.com/kkakey/dog_traits_AKC/blob/main/README.md).

This dataset contains the popularity of dog breeds by AKC registration from 2013-2020. You can directly read this data into a dataframe using:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>breed_rank_all</span> <span class='o'>&lt;-</span> <span class='nf'>readr</span><span class='nf'>::</span><span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_csv</a></span><span class='o'>(</span><span class='s'>'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-02-01/breed_rank.csv'</span><span class='o'>)</span></span></code></pre>

</div>

Let's take a look at the data:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>breed_rank_all</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 195 × 11</span></span></span>
<span><span class='c'>#&gt;    Breed   2013 …¹ 2014 …² 2015 …³ 2016 …⁴ 2017 …⁵ 2018 …⁶ 2019 …⁷ 2020 …⁸ links</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> Retrie…       1       1       1       1       1       1       1       1 http…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> French…      11       9       6       6       4       4       4       2 http…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> German…       2       2       2       2       2       2       2       3 http…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> Retrie…       3       3       3       3       3       3       3       4 http…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> Bulldo…       5       4       4       4       5       5       5       5 http…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> Poodles       8       7       8       7       7       7       6       6 http…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> Beagles       4       5       5       5       6       6       7       7 http…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> Rottwe…       9      10       9       8       8       8       8       8 http…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> Pointe…      13      12      11      11      10       9       9       9 http…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> Dachsh…      10      11      13      13      13      12      11      10 http…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 185 more rows, 1 more variable: Image &lt;chr&gt;, and abbreviated variable</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   names ¹​`2013 Rank`, ²​`2014 Rank`, ³​`2015 Rank`, ⁴​`2016 Rank`, ⁵​`2017 Rank`,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   ⁶​`2018 Rank`, ⁷​`2019 Rank`, ⁸​`2020 Rank`</span></span></span></code></pre>

</div>

<div class="puzzle">

<div>

### Exercise 1

Convert the `breed_rank_all` dataframe from its current wide, untidy format, to a tidy, long format.

Bonus: Make sure the `year` column only contains the year number itself.

<details>
<summary>
<b>Hint</b>(click here)
</summary>

<br>

-   Use the function [`pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html). Try setting the arguments `cols =`, `names_to =` and `values_to =`.

-   You'll want to pivot the columns with years in them.

</details>

<br>

<details>
<summary>
<b>Hint for bonus </b>(click here)
</summary>

<br>

Note that the values in your resulting column with years are "\<year\> Rank" (e.g., `2020 Rank`), and not just "\<year\>" (e.g., `2020`).

You can fix this using either:

-   A [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) step after pivoting, similar to the example above -- but using [`parse_number()`](https://readr.tidyverse.org/reference/parse_number.html) instead of [`as.numeric()`](https://rdrr.io/r/base/numeric.html), since some alphabetic characters have to be removed.

-   Directly within your [`pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html) call, using the `names_transform` argument. (Visit [this link](https://www.tidyverse.org/blog/2020/05/tidyr-1.1.0/) for some help on that.)

</details>

<br>

<details>
<summary>
<b>Solution </b>(click here)
</summary>

<br>

Initial step:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>breed_rank_tidy</span> <span class='o'>&lt;-</span> <span class='nv'>breed_rank_all</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/pivot_longer.html'>pivot_longer</a></span><span class='o'>(</span>cols <span class='o'>=</span> <span class='nf'><a href='https://tidyselect.r-lib.org/reference/starts_with.html'>contains</a></span><span class='o'>(</span><span class='s'>"Rank"</span><span class='o'>)</span>,</span>
<span>               names_to <span class='o'>=</span> <span class='s'>"year"</span>,</span>
<span>               values_to <span class='o'>=</span> <span class='s'>"rank"</span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>breed_rank_tidy</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 5</span></span></span>
<span><span class='c'>#&gt;   Breed                 links                                  Image year   rank</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                 <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                                  <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Retrievers (Labrador) https://www.akc.org/dog-breeds/labrad… http… 2013…     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Retrievers (Labrador) https://www.akc.org/dog-breeds/labrad… http… 2014…     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> Retrievers (Labrador) https://www.akc.org/dog-breeds/labrad… http… 2015…     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> Retrievers (Labrador) https://www.akc.org/dog-breeds/labrad… http… 2016…     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> Retrievers (Labrador) https://www.akc.org/dog-breeds/labrad… http… 2017…     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> Retrievers (Labrador) https://www.akc.org/dog-breeds/labrad… http… 2018…     1</span></span></code></pre>

</div>

This leaves us with a suboptimal `year` column:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>breed_rank_tidy</span><span class='o'>$</span><span class='nv'>year</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; [1] "2013 Rank" "2014 Rank" "2015 Rank" "2016 Rank" "2017 Rank" "2018 Rank"</span></span></code></pre>

</div>

We can fix that as follows:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>breed_rank_tidy</span> <span class='o'>&lt;-</span> <span class='nv'>breed_rank_tidy</span> <span class='o'>|&gt;</span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>year <span class='o'>=</span> <span class='nf'><a href='https://readr.tidyverse.org/reference/parse_number.html'>parse_number</a></span><span class='o'>(</span><span class='nv'>year</span><span class='o'>)</span><span class='o'>)</span></span></code></pre>

</div>

Alternatively, it's possible to do this all at once using the `names_transform` argument of [`pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>breed_rank_tidy</span> <span class='o'>&lt;-</span> <span class='nv'>breed_rank_all</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/pivot_longer.html'>pivot_longer</a></span><span class='o'>(</span>cols <span class='o'>=</span> <span class='nf'><a href='https://tidyselect.r-lib.org/reference/starts_with.html'>contains</a></span><span class='o'>(</span><span class='s'>"Rank"</span><span class='o'>)</span>,</span>
<span>               names_to <span class='o'>=</span> <span class='s'>"year"</span>,</span>
<span>               values_to <span class='o'>=</span> <span class='s'>"rank"</span>,</span>
<span>               names_transform <span class='o'>=</span> <span class='nv'>parse_number</span><span class='o'>)</span> <span class='c'># or: 'list(year = parse_number)'</span></span>
<span></span>
<span><span class='nv'>breed_rank_tidy</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1,560 × 5</span></span></span>
<span><span class='c'>#&gt;    Breed                 links                                 Image  year  rank</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                 <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                                 <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> Retrievers (Labrador) https://www.akc.org/dog-breeds/labra… http…  <span style='text-decoration: underline;'>2</span>013     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> Retrievers (Labrador) https://www.akc.org/dog-breeds/labra… http…  <span style='text-decoration: underline;'>2</span>014     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> Retrievers (Labrador) https://www.akc.org/dog-breeds/labra… http…  <span style='text-decoration: underline;'>2</span>015     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> Retrievers (Labrador) https://www.akc.org/dog-breeds/labra… http…  <span style='text-decoration: underline;'>2</span>016     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> Retrievers (Labrador) https://www.akc.org/dog-breeds/labra… http…  <span style='text-decoration: underline;'>2</span>017     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> Retrievers (Labrador) https://www.akc.org/dog-breeds/labra… http…  <span style='text-decoration: underline;'>2</span>018     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> Retrievers (Labrador) https://www.akc.org/dog-breeds/labra… http…  <span style='text-decoration: underline;'>2</span>019     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> Retrievers (Labrador) https://www.akc.org/dog-breeds/labra… http…  <span style='text-decoration: underline;'>2</span>020     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> French Bulldogs       https://www.akc.org/dog-breeds/frenc… http…  <span style='text-decoration: underline;'>2</span>013    11</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> French Bulldogs       https://www.akc.org/dog-breeds/frenc… http…  <span style='text-decoration: underline;'>2</span>014     9</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 1,550 more rows</span></span></span></code></pre>

</div>

</details>

</div>

</div>

<br>

<div class="puzzle">

<div>

### Exercise 2

Take that new dataframe you've just made using [`pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html) and make it wide again. No, you can't just use the original dataframe 😀🐶

<details>
<summary>
<b>Hints </b>(click here)
</summary>

<br>

Try using [`pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html) and make sure you specify `names_from =` and `values_from =`.

</details>

<br>

<details>
<summary>
<b>Solution </b>(click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>breed_rank_wide</span> <span class='o'>&lt;-</span> <span class='nv'>breed_rank_tidy</span> <span class='o'>|&gt;</span></span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/pivot_wider.html'>pivot_wider</a></span><span class='o'>(</span>names_from <span class='o'>=</span> <span class='s'>"year"</span>,</span>
<span>              values_from <span class='o'>=</span> <span class='s'>"rank"</span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>breed_rank_wide</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 11</span></span></span>
<span><span class='c'>#&gt;   Breed      links Image `2013` `2014` `2015` `2016` `2017` `2018` `2019` `2020`</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Retriever… http… http…      1      1      1      1      1      1      1      1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> French Bu… http… http…     11      9      6      6      4      4      4      2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> German Sh… http… http…      2      2      2      2      2      2      2      3</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> Retriever… http… http…      3      3      3      3      3      3      3      4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> Bulldogs   http… http…      5      4      4      4      5      5      5      5</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> Poodles    http… http…      8      7      8      7      7      7      6      6</span></span></code></pre>

</div>

Note, that R is adding all your new columns to the end of your dataframe. If you want to reorder your columns, you can do that simply with [`select()`](https://dplyr.tidyverse.org/reference/select.html) which both picks and orders columns. Note, you need backticks around a variable name when that variable name is a number (as this is atypical syntax for R).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>breed_rank_wide</span> <span class='o'>&lt;-</span> <span class='nv'>breed_rank_wide</span> <span class='o'>|&gt;</span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nv'>Breed</span>, <span class='nv'>`2013`</span><span class='o'>:</span><span class='nv'>`2020`</span>, <span class='nf'><a href='https://tidyselect.r-lib.org/reference/everything.html'>everything</a></span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span> </span>
<span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>breed_rank_wide</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 11</span></span></span>
<span><span class='c'>#&gt;   Breed      `2013` `2014` `2015` `2016` `2017` `2018` `2019` `2020` links Image</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Retriever…      1      1      1      1      1      1      1      1 http… http…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> French Bu…     11      9      6      6      4      4      4      2 http… http…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> German Sh…      2      2      2      2      2      2      2      3 http… http…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> Retriever…      3      3      3      3      3      3      3      4 http… http…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> Bulldogs        5      4      4      4      5      5      5      5 http… http…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> Poodles         8      7      8      7      7      7      6      6 http… http…</span></span></code></pre>

</div>

</details>

</div>

</div>

<br>

<div class="puzzle">

<div>

### Bonus exercise

Try making a plot that shows the popularity rank of your favorite dog breeds (select up to a handful) over 2013-2020.

<details>
<summary>
<b>Hints </b>(click here)
</summary>

<br>

Use your tidy dataframe, [`filter()`](https://dplyr.tidyverse.org/reference/filter.html) to pick the `Breed`s you want to keep, and maybe a combined point ([`geom_point()`](https://ggplot2.tidyverse.org/reference/geom_point.html)) and line ([`geom_line()`](https://ggplot2.tidyverse.org/reference/geom_path.html)) plot.

</details>

<br>

<details>
<summary>
<b>Solution </b>(click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>fav_breeds</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"French Bulldogs"</span>, <span class='s'>"Poodles"</span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>breed_rank_tidy</span> <span class='o'>|&gt;</span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>Breed</span> <span class='o'><a href='https://rdrr.io/r/base/match.html'>%in%</a></span> <span class='nv'>fav_breeds</span><span class='o'>)</span> <span class='o'>|&gt;</span></span>
<span><span class='c'># filter(Breed == c("French Bulldogs", "Poodles")) |&gt; # also works</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>year</span>, y <span class='o'>=</span> <span class='nv'>rank</span>, color <span class='o'>=</span> <span class='nv'>Breed</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_point.html'>geom_point</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_path.html'>geom_line</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/labs.html'>labs</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Year"</span>, </span>
<span>       y <span class='o'>=</span> <span class='s'>"Rank (where 1 is the most popular)"</span>,</span>
<span>       title <span class='o'>=</span> <span class='s'>"AKC Popularity of Jess and Daniel's Favorite Dog Breeds"</span>,</span>
<span>       caption <span class='o'>=</span> <span class='s'>"Data from AKC/#TidyTuesday"</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/bonus-solution-1-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

</div>

<br>

