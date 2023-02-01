---
output: hugodown::md_document
title: "S05E02: R4DS (2e) - Ch. 6 - Tidy Data"
subtitle: "Today, we'll start with the R4DS chapter on \"tidy\" data, learning what it means for a dataframe to be in a tidy format, and how to reshape untidy into tidy data."
summary: "Today, we'll start with the R4DS chapter on \"tidy\" data, learning what it means for a dataframe to be in a tidy format, and how to reshape untidy into tidy data."
authors: [stephen-opiyo]
tags: [codeclub, r4ds]
date: "2023-02-01"
lastmod: "2023-02-01"
toc: true
rmd_hash: b93ea707d6e994e7

---

------------------------------------------------------------------------

## Introduction

Today we will learn about a consistent way to organize your data in R, using a system called **"tidy" data**.

Then we will cover the primary tool use for tidying data, **pivoting**. Pivoting allows you to change the form of your data without changing any of the values.

We will again be using *tidyverse* packages, so we'll need to load it packages for the current R session using the [`library()`](https://rdrr.io/r/base/library.html) function:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span></span>
<span></span>
<span><span class='c'># You should have the tidyverse installed, but if not, do so using:</span></span>
<span><span class='c'># install.packages("tidyverse")</span></span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## What is tidy data?

We can represent any dataset in multiple ways. Let us look at the following dataframes, each of which comes is available once you've loaded the *tidyverse*: `table1`, `table2`, `table3`, `table4a`, and `table4b`.

Each dataframe (or *tibble*, as *tidyverse*-style dataframes are called) shows the same values for four variables: `country`, `year`, `population`, and cases of TB (tuberculosis), but each dataset organizes the values in a different way:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>table1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 4</span></span></span>
<span><span class='c'>#&gt;   country      year  cases population</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Afghanistan  <span style='text-decoration: underline;'>1</span>999    745   19<span style='text-decoration: underline;'>987</span>071</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Afghanistan  <span style='text-decoration: underline;'>2</span>000   <span style='text-decoration: underline;'>2</span>666   20<span style='text-decoration: underline;'>595</span>360</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> Brazil       <span style='text-decoration: underline;'>1</span>999  <span style='text-decoration: underline;'>37</span>737  172<span style='text-decoration: underline;'>006</span>362</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> Brazil       <span style='text-decoration: underline;'>2</span>000  <span style='text-decoration: underline;'>80</span>488  174<span style='text-decoration: underline;'>504</span>898</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> China        <span style='text-decoration: underline;'>1</span>999 <span style='text-decoration: underline;'>212</span>258 <span style='text-decoration: underline;'>1</span>272<span style='text-decoration: underline;'>915</span>272</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> China        <span style='text-decoration: underline;'>2</span>000 <span style='text-decoration: underline;'>213</span>766 <span style='text-decoration: underline;'>1</span>280<span style='text-decoration: underline;'>428</span>583</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>table2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 12 × 4</span></span></span>
<span><span class='c'>#&gt;    country      year type            count</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>           <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> Afghanistan  <span style='text-decoration: underline;'>1</span>999 cases             745</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> Afghanistan  <span style='text-decoration: underline;'>1</span>999 population   19<span style='text-decoration: underline;'>987</span>071</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> Afghanistan  <span style='text-decoration: underline;'>2</span>000 cases            <span style='text-decoration: underline;'>2</span>666</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> Afghanistan  <span style='text-decoration: underline;'>2</span>000 population   20<span style='text-decoration: underline;'>595</span>360</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> Brazil       <span style='text-decoration: underline;'>1</span>999 cases           <span style='text-decoration: underline;'>37</span>737</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> Brazil       <span style='text-decoration: underline;'>1</span>999 population  172<span style='text-decoration: underline;'>006</span>362</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> Brazil       <span style='text-decoration: underline;'>2</span>000 cases           <span style='text-decoration: underline;'>80</span>488</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> Brazil       <span style='text-decoration: underline;'>2</span>000 population  174<span style='text-decoration: underline;'>504</span>898</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> China        <span style='text-decoration: underline;'>1</span>999 cases          <span style='text-decoration: underline;'>212</span>258</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> China        <span style='text-decoration: underline;'>1</span>999 population <span style='text-decoration: underline;'>1</span>272<span style='text-decoration: underline;'>915</span>272</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>11</span> China        <span style='text-decoration: underline;'>2</span>000 cases          <span style='text-decoration: underline;'>213</span>766</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>12</span> China        <span style='text-decoration: underline;'>2</span>000 population <span style='text-decoration: underline;'>1</span>280<span style='text-decoration: underline;'>428</span>583</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>table3</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 3</span></span></span>
<span><span class='c'>#&gt;   country      year rate             </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>*</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>            </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Afghanistan  <span style='text-decoration: underline;'>1</span>999 745/19987071     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Afghanistan  <span style='text-decoration: underline;'>2</span>000 2666/20595360    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> Brazil       <span style='text-decoration: underline;'>1</span>999 37737/172006362  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> Brazil       <span style='text-decoration: underline;'>2</span>000 80488/174504898  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> China        <span style='text-decoration: underline;'>1</span>999 212258/1272915272</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> China        <span style='text-decoration: underline;'>2</span>000 213766/1280428583</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>table4a</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 3</span></span></span>
<span><span class='c'>#&gt;   country     `1999` `2000`</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>*</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>        <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Afghanistan    745   <span style='text-decoration: underline;'>2</span>666</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Brazil       <span style='text-decoration: underline;'>37</span>737  <span style='text-decoration: underline;'>80</span>488</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> China       <span style='text-decoration: underline;'>212</span>258 <span style='text-decoration: underline;'>213</span>766</span></span><span></span>
<span><span class='nv'>table4b</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 3</span></span></span>
<span><span class='c'>#&gt;   country         `1999`     `2000`</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>*</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Afghanistan   19<span style='text-decoration: underline;'>987</span>071   20<span style='text-decoration: underline;'>595</span>360</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Brazil       172<span style='text-decoration: underline;'>006</span>362  174<span style='text-decoration: underline;'>504</span>898</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> China       <span style='text-decoration: underline;'>1</span>272<span style='text-decoration: underline;'>915</span>272 <span style='text-decoration: underline;'>1</span>280<span style='text-decoration: underline;'>428</span>583</span></span></code></pre>

</div>

Among these four formats, the one in `table1` is easier to work with, certainly inside the *tidyverse*, because it is "tidy".

Three rules that make a dataset tidy are:

1.  Each variable is a column; each column is a variable.

2.  Each observation is a row; each row is an observation.

3.  Each value is a cell; each cell is a single value.

### An example of a computation with a tidy dataframe

The key advantage of having your data in a tidy format is that it makes it easier to work with: compute summaries, new variables, make plots, etc.

For instance, `table1` makes it straightforward to calculate a rate of cases (cases per 10,000 people) using the [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) function:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># Compute rate per 10,000</span></span>
<span><span class='nv'>table1</span> <span class='o'>|&gt;</span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>    rate <span class='o'>=</span> <span class='nv'>cases</span> <span class='o'>/</span> <span class='nv'>population</span> <span class='o'>*</span> <span class='m'>10000</span></span>
<span>  <span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 5</span></span></span>
<span><span class='c'>#&gt;   country      year  cases population  rate</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Afghanistan  <span style='text-decoration: underline;'>1</span>999    745   19<span style='text-decoration: underline;'>987</span>071 0.373</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Afghanistan  <span style='text-decoration: underline;'>2</span>000   <span style='text-decoration: underline;'>2</span>666   20<span style='text-decoration: underline;'>595</span>360 1.29 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> Brazil       <span style='text-decoration: underline;'>1</span>999  <span style='text-decoration: underline;'>37</span>737  172<span style='text-decoration: underline;'>006</span>362 2.19 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> Brazil       <span style='text-decoration: underline;'>2</span>000  <span style='text-decoration: underline;'>80</span>488  174<span style='text-decoration: underline;'>504</span>898 4.61 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> China        <span style='text-decoration: underline;'>1</span>999 <span style='text-decoration: underline;'>212</span>258 <span style='text-decoration: underline;'>1</span>272<span style='text-decoration: underline;'>915</span>272 1.67 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> China        <span style='text-decoration: underline;'>2</span>000 <span style='text-decoration: underline;'>213</span>766 <span style='text-decoration: underline;'>1</span>280<span style='text-decoration: underline;'>428</span>583 1.67</span></span></code></pre>

</div>

Note that [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) always adds new columns at the end of your dataset -- in this case, `rate`. This function is discussed [here in R4DS Chapter 4](https://r4ds.hadley.nz/data-transform.html#sec-mutate).

The book also gives two other examples of working with a tidy dataframe, including how to make a plot with *ggplot2*.

<br>

------------------------------------------------------------------------

## Breakout Rooms 1

(These are the same as Exercises 1 and 2 in [R4DS 6.2.1](https://r4ds.hadley.nz/data-tidy.html#exercises).)

1.  Using prose, describe how the variables and observations are organised in each of the sample tables (`table1`, `table2`, etc.).

2.  Sketch out the process you'd use to calculate the `rate` for `table2`, and for `table4a` + `table4b`. You will need to perform four operations:

-   Extract the number of TB cases per country per year.
-   Extract the matching population per country per year.
-   Divide cases by population, and multiply by 10000.
-   Store back in the appropriate place.

You haven't yet learned all the functions you'd need to actually perform these  
operations, but you should still be able to think through the transformations you'd need.

<br>

------------------------------------------------------------------------

## Pivoting

In the real world, data is often untidy because of two reasons:

1.  Data is often organised to facilitate some goal other than analysis.

2.  Most people aren't familiar with the principles of tidy data.

Therefore, untidy data has to be pivot to pivot your data into a tidy form, with variables in the columns and observations in the rows.

### Two functions for pivoting data

-   **[`pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html)** makes datasets longer by increasing the number of rows, and reducing the number of columns. *Typically*, we use [`pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html) to make an untidy dataset tidy, since untidy datasets often have multiple columns for a single variable, and multiple observations in a single row.

-   **[`pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html)** makes datasets wider by increasing the number of columns, and reducing the number of rows. *Typically*, [`pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html) will make a dataset untidy -- but that can still be useful, as we'll see next week.

### How does pivoting work?

Let's start with a very simple dataset to make it easier to see what's happening:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># Row-wise tibble creation with the 'tribble()' function</span></span>
<span><span class='nv'>df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://tibble.tidyverse.org/reference/tribble.html'>tribble</a></span><span class='o'>(</span></span>
<span>  <span class='o'>~</span><span class='nv'>var</span>, <span class='o'>~</span><span class='nv'>col1</span>, <span class='o'>~</span><span class='nv'>col2</span>,</span>
<span>   <span class='s'>"A"</span>,     <span class='m'>1</span>,     <span class='m'>2</span>,</span>
<span>   <span class='s'>"B"</span>,     <span class='m'>3</span>,     <span class='m'>4</span>,</span>
<span>   <span class='s'>"C"</span>,     <span class='m'>5</span>,     <span class='m'>6</span></span>
<span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>df</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 3</span></span></span>
<span><span class='c'>#&gt;   var    col1  col2</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> A         1     2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> B         3     4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> C         5     6</span></span></code></pre>

</div>

We can tidy `df` using [`pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>df</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/pivot_longer.html'>pivot_longer</a></span><span class='o'>(</span></span>
<span>    cols <span class='o'>=</span> <span class='nv'>col1</span><span class='o'>:</span><span class='nv'>col2</span>,</span>
<span>    names_to <span class='o'>=</span> <span class='s'>"names"</span>,</span>
<span>    values_to <span class='o'>=</span> <span class='s'>"values"</span></span>
<span>  <span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 3</span></span></span>
<span><span class='c'>#&gt;   var   names values</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> A     col1       1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> A     col2       2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> B     col1       3</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> B     col2       4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> C     col1       5</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> C     col2       6</span></span></code></pre>

</div>

It's easier to see how pivot_longer works if we take it component by component. Let us look at how it works visually using Figure 6.3, Figure 6.4, and Figure 6.5 in the book.

### Example with data in column names

This example will work with the `billboard` dataframe that is loaded along with the *tidyverse*. This dataset records the billboard rank of songs in the year 2000:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>billboard</span> </span>
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

We will use [`pivot_longer()`](https://tidyr.tidyverse.org/reference/pivot_longer.html) to tidy this dataframe:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>billboard</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/pivot_longer.html'>pivot_longer</a></span><span class='o'>(</span></span>
<span>    cols <span class='o'>=</span> <span class='nf'><a href='https://tidyselect.r-lib.org/reference/starts_with.html'>starts_with</a></span><span class='o'>(</span><span class='s'>"wk"</span><span class='o'>)</span>, </span>
<span>    names_to <span class='o'>=</span> <span class='s'>"week"</span>, </span>
<span>    values_to <span class='o'>=</span> <span class='s'>"rank"</span></span>
<span>  <span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 24,092 × 5</span></span></span>
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

Pivot longer has the following key arguments:

-   `cols` -- these are the columns that should be combined into 2 columns, namely:
-   `names_to` -- the name you would like to give to the new column whose values will hold what were the *column names* in the original dataframe
-   `values_to` -- the name you would like to give to the new column whose values will hold what were the *column valies* in the original dataframe.

You can see that we get some `NA`s after pivoting. In this case, `NA`s are forced to exist because of the structure of the dataset: that is, they aren't actual missing values. It would therefore make sense to get rid of them, which we can do with `values_drop_na = TRUE`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>billboard</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/pivot_longer.html'>pivot_longer</a></span><span class='o'>(</span></span>
<span>    cols <span class='o'>=</span> <span class='nf'><a href='https://tidyselect.r-lib.org/reference/starts_with.html'>starts_with</a></span><span class='o'>(</span><span class='s'>"wk"</span><span class='o'>)</span>, </span>
<span>    names_to <span class='o'>=</span> <span class='s'>"week"</span>, </span>
<span>    values_to <span class='o'>=</span> <span class='s'>"rank"</span>,</span>
<span>    values_drop_na <span class='o'>=</span> <span class='kc'>TRUE</span></span>
<span>  <span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 5,307 × 5</span></span></span>
<span><span class='c'>#&gt;    artist  track                   date.entered week   rank</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                   <span style='color: #555555; font-style: italic;'>&lt;date&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> 2 Pac   Baby Don't Cry (Keep... 2000-02-26   wk1      87</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> 2 Pac   Baby Don't Cry (Keep... 2000-02-26   wk2      82</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> 2 Pac   Baby Don't Cry (Keep... 2000-02-26   wk3      72</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> 2 Pac   Baby Don't Cry (Keep... 2000-02-26   wk4      77</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> 2 Pac   Baby Don't Cry (Keep... 2000-02-26   wk5      87</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> 2 Pac   Baby Don't Cry (Keep... 2000-02-26   wk6      94</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> 2 Pac   Baby Don't Cry (Keep... 2000-02-26   wk7      99</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> 2Ge+her The Hardest Part Of ... 2000-09-02   wk1      91</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> 2Ge+her The Hardest Part Of ... 2000-09-02   wk2      87</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> 2Ge+her The Hardest Part Of ... 2000-09-02   wk3      92</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 5,297 more rows</span></span></span></code></pre>

</div>

This data is now tidy, but we could make future computations a bit easier by converting the values in the column `week` (`wk1`, `wk2`, etc.) into a number using [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) and [`readr::parse_number()`](https://readr.tidyverse.org/reference/parse_number.html). [`parse_number()`](https://readr.tidyverse.org/reference/parse_number.html) is a handy function that will extract the numbers from a string, removing all other characters:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>billboard_tidy</span> <span class='o'>&lt;-</span> <span class='nv'>billboard</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/pivot_longer.html'>pivot_longer</a></span><span class='o'>(</span></span>
<span>    cols <span class='o'>=</span> <span class='nf'><a href='https://tidyselect.r-lib.org/reference/starts_with.html'>starts_with</a></span><span class='o'>(</span><span class='s'>"wk"</span><span class='o'>)</span>, </span>
<span>    names_to <span class='o'>=</span> <span class='s'>"week"</span>, </span>
<span>    values_to <span class='o'>=</span> <span class='s'>"rank"</span>,</span>
<span>    values_drop_na <span class='o'>=</span> <span class='kc'>TRUE</span></span>
<span>  <span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>    week <span class='o'>=</span> <span class='nf'><a href='https://readr.tidyverse.org/reference/parse_number.html'>parse_number</a></span><span class='o'>(</span><span class='nv'>week</span><span class='o'>)</span></span>
<span>  <span class='o'>)</span></span>
<span></span>
<span><span class='nv'>billboard_tidy</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 5,307 × 5</span></span></span>
<span><span class='c'>#&gt;    artist  track                   date.entered  week  rank</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                   <span style='color: #555555; font-style: italic;'>&lt;date&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> 2 Pac   Baby Don't Cry (Keep... 2000-02-26       1    87</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> 2 Pac   Baby Don't Cry (Keep... 2000-02-26       2    82</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> 2 Pac   Baby Don't Cry (Keep... 2000-02-26       3    72</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> 2 Pac   Baby Don't Cry (Keep... 2000-02-26       4    77</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> 2 Pac   Baby Don't Cry (Keep... 2000-02-26       5    87</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> 2 Pac   Baby Don't Cry (Keep... 2000-02-26       6    94</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> 2 Pac   Baby Don't Cry (Keep... 2000-02-26       7    99</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> 2Ge+her The Hardest Part Of ... 2000-09-02       1    91</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> 2Ge+her The Hardest Part Of ... 2000-09-02       2    87</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> 2Ge+her The Hardest Part Of ... 2000-09-02       3    92</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 5,297 more rows</span></span></span></code></pre>

</div>

Now we're in a good position to look at how song ranks vary over time by drawing a plot. The code is shown below and the result is Figure 6.2.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>billboard_tidy</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>week</span>, y <span class='o'>=</span> <span class='nv'>rank</span>, group <span class='o'>=</span> <span class='nv'>track</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_path.html'>geom_line</a></span><span class='o'>(</span>alpha <span class='o'>=</span> <span class='m'>1</span><span class='o'>/</span><span class='m'>3</span><span class='o'>)</span> <span class='o'>+</span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/scale_continuous.html'>scale_y_reverse</a></span><span class='o'>(</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-13-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<br>

------------------------------------------------------------------------

## Breakout Rooms 2

### Exercise 1

1.  Create a dataset `table_pivot_long1` from `table1` with the following variables: `country`, `year`, `population`, `type`, and `count`.

Hint use starts_with("case), values_to ="count"

1.  What are the number of rows and columns of `table_pivot_long1`?

Solution question 1

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#a)</span></span>
<span><span class='nv'>table_pivot_long1</span> <span class='o'>&lt;-</span> <span class='nv'>table1</span> <span class='o'>|&gt;</span></span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/pivot_longer.html'>pivot_longer</a></span><span class='o'>(</span>cols <span class='o'>=</span> <span class='nf'><a href='https://tidyselect.r-lib.org/reference/starts_with.html'>starts_with</a></span><span class='o'>(</span><span class='s'>"cases"</span><span class='o'>)</span>, </span>
<span>                            names_to <span class='o'>=</span> <span class='s'>"type"</span>, </span>
<span>                            values_to <span class='o'>=</span> <span class='s'>"count"</span><span class='o'>)</span></span>
<span></span>
<span><span class='c'># b)The dimension of table_pivot_long1 is 6 observations and 5 variables</span></span></code></pre>

</div>

### Exercise 2

Compute the rate per 10,000 for `table_pivot_long1`, and name the new computed variable `rate`.

Hints use mutate, count, population

Solution question 2

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>table_pivot_long1</span> <span class='o'>|&gt;</span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>rate <span class='o'>=</span> <span class='nv'>count</span> <span class='o'>/</span> <span class='nv'>population</span> <span class='o'>*</span> <span class='m'>1000</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 6</span></span></span>
<span><span class='c'>#&gt;   country      year population type   count   rate</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Afghanistan  <span style='text-decoration: underline;'>1</span>999   19<span style='text-decoration: underline;'>987</span>071 cases    745 0.037<span style='text-decoration: underline;'>3</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Afghanistan  <span style='text-decoration: underline;'>2</span>000   20<span style='text-decoration: underline;'>595</span>360 cases   <span style='text-decoration: underline;'>2</span>666 0.129 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> Brazil       <span style='text-decoration: underline;'>1</span>999  172<span style='text-decoration: underline;'>006</span>362 cases  <span style='text-decoration: underline;'>37</span>737 0.219 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> Brazil       <span style='text-decoration: underline;'>2</span>000  174<span style='text-decoration: underline;'>504</span>898 cases  <span style='text-decoration: underline;'>80</span>488 0.461 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> China        <span style='text-decoration: underline;'>1</span>999 <span style='text-decoration: underline;'>1</span>272<span style='text-decoration: underline;'>915</span>272 cases <span style='text-decoration: underline;'>212</span>258 0.167 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> China        <span style='text-decoration: underline;'>2</span>000 <span style='text-decoration: underline;'>1</span>280<span style='text-decoration: underline;'>428</span>583 cases <span style='text-decoration: underline;'>213</span>766 0.167</span></span></code></pre>

</div>

<br>

------------------------------------------------------------------------

<br>

