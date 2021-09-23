---
title: "Code Club S02E05: Intro to the Tidyverse (Part 2)"
summary: "In this session of Code Club, we will be learning some more about data wrangling in the tidyverse."
author: [stephen-opiyo]
date: "2021-09-22"
output: hugodown::md_document
toc: true
rmd_hash: 25870e4d3771d59a

---

------------------------------------------------------------------------

## Prep homework

### Basic computer setup

-   If you didn't already do this, please follow the [Code Club Computer Setup](/codeclub-setup/) instructions, which also has pointers for if you're new to R or RStudio.

-   If you're able to do so, please open RStudio a bit before Code Club starts -- and in case you run into issues, please join the Zoom call early and we'll troubleshoot.

<br>

------------------------------------------------------------------------

## Introduction

**What will we go over today**

-   We will continue using *dplyr* package of the *tidyverse* introduced last week.
-   Learn using [`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html) - orders the rows of a data frame by the values of selected columns.
-   Learn using [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) - adds new variables and preserves existing ones.

<br>

------------------------------------------------------------------------

## 1 - What is the dplyr package?

[*dplyr*](https://dplyr.tidyverse.org/index.html) is one of the *tidyverse* packages that are designed for data science. *dplyr* provides functions for data manipulation.

Functions for row-wise operations include:

-   [`filter()`](https://dplyr.tidyverse.org/reference/filter.html) - chooses rows based on column values.
-   [`slice()`](https://dplyr.tidyverse.org/reference/slice.html) - chooses rows based on location.
-   [`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html) - orders the rows of a data frame by the values of selected columns.

Functions for column-wise operations include:

-   [`select()`](https://dplyr.tidyverse.org/reference/select.html) - changes whether or not a column is included.
-   [`rename`()](https://dplyr.tidyverse.org/reference/rename.html) - changes the name of columns.
-   [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) - changes the values of columns and creates new columns
-   [`relocate`()](https://dplyr.tidyverse.org/reference/relocate.html) - changes the order of the columns.

Functions for *groups* of rows include:

-   [`summarise()`](https://dplyr.tidyverse.org/reference/summarise.html) - collapses a group into a single row.

Last week, we got introduced to the *tidyverse* and covered the pipe, `select()`, and `filter`. We also discussed *tidyverse* packages such as [`ggplot2`](https://ggplot2.tidyverse.org/index.html), a part of the core tidyverse, which we have talked about in previous Code Clubs ([intro](/codeclub/04_ggplot2), [intro2](/codeclub/05_ggplot-round-2), [maps](/codeclub/11_ggplot-maps), and [ggplotly](/codeclub/15_plotly)), and others.

We also saw that packages are basically R add-ons that contain additional functions or datasets we can use. Using the function [`install.packages()`](https://www.rdocumentation.org/packages/utils/versions/3.6.2/topics/install.packages), we can install packages that are available at the Comprehensive R Archive Network, or [CRAN](https://cran.r-project.org/).

For those who have not installed the *tidyverse*, let's install it. We only need to do this once, so if you did this last week, you don't need to now.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"tidyverse"</span><span class='o'>)</span></code></pre>

</div>

To use the *dplyr* package within the *tidyverse*, we need to call it up using [`library()`](https://rdrr.io/r/base/library.html).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
<span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching packages</span> ─────────────────────────────────────── tidyverse 1.3.1 ──</span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>ggplot2</span> 3.3.5     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>purrr  </span> 0.3.4</span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tibble </span> 3.1.4     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>dplyr  </span> 1.0.7</span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tidyr  </span> 1.1.3     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>stringr</span> 1.4.0</span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>readr  </span> 2.0.1     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>forcats</span> 0.5.1</span>
<span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span> ────────────────────────────────────────── tidyverse_conflicts() ──</span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>filter()</span> masks <span style='color: #0000BB;'>stats</span>::filter()</span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>lag()</span>    masks <span style='color: #0000BB;'>stats</span>::lag()</span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## 2 - Using the `arrange()` function

We will learn how to use the `arrange()` function from *dplyr* to sort a data frame in multiple ways. First, we will sort a dataframe by values of a single variable, and then we will learn how to sort a dataframe by more than one variable in the dataframe. By default, *dplyr*'s `arrange()` sorts in *ascending* order.

**Let's get set up and grab some data so that we have some material to work with.**

We will use the same dataset [`palmerpenguins`](https://allisonhorst.github.io/palmerpenguins/) we used last week. To get this data, we need to install the *palmerpenguins* package (no need to do this if you did so last week):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"palmerpenguins"</span><span class='o'>)</span></code></pre>

</div>

Then, to use the package, we need to use the function [`library()`](https://rdrr.io/r/base/library.html) to load the package in R:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/'>palmerpenguins</a></span><span class='o'>)</span></code></pre>

</div>

The dataframe we will use today is called `penguins`. Let's take a look at the structure of the data:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># look at the first 10 rows and all columns</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>penguins</span>, <span class='m'>10</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 8</span></span>
<span class='c'>#&gt;    species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g</span>
<span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>             <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span> Adelie  Torgersen           39.1          18.7               181        <span style='text-decoration: underline;'>3</span>750</span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span> Adelie  Torgersen           39.5          17.4               186        <span style='text-decoration: underline;'>3</span>800</span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span> Adelie  Torgersen           40.3          18                 195        <span style='text-decoration: underline;'>3</span>250</span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span> Adelie  Torgersen           <span style='color: #BB0000;'>NA</span>            <span style='color: #BB0000;'>NA</span>                  <span style='color: #BB0000;'>NA</span>          <span style='color: #BB0000;'>NA</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span> Adelie  Torgersen           36.7          19.3               193        <span style='text-decoration: underline;'>3</span>450</span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span> Adelie  Torgersen           39.3          20.6               190        <span style='text-decoration: underline;'>3</span>650</span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span> Adelie  Torgersen           38.9          17.8               181        <span style='text-decoration: underline;'>3</span>625</span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span> Adelie  Torgersen           39.2          19.6               195        <span style='text-decoration: underline;'>4</span>675</span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span> Adelie  Torgersen           34.1          18.1               193        <span style='text-decoration: underline;'>3</span>475</span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span> Adelie  Torgersen           42            20.2               190        <span style='text-decoration: underline;'>4</span>250</span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 2 more variables: sex &lt;fct&gt;, year &lt;int&gt;</span></span>
<span class='c'># check the structure of penguins_data</span>
<span class='c'># glimpse() which is a part of dplyr functions </span>
<span class='c'># similarly to str() and can be used interchangeably</span>
<span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>)</span>
<span class='c'>#&gt; Rows: 344</span>
<span class='c'>#&gt; Columns: 8</span>
<span class='c'>#&gt; $ species           <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span> Adelie, Adelie, Adelie, Adelie, Adelie, Adelie, Adel…</span>
<span class='c'>#&gt; $ island            <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span> Torgersen, Torgersen, Torgersen, Torgersen, Torgerse…</span>
<span class='c'>#&gt; $ bill_length_mm    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> 39.1, 39.5, 40.3, NA, 36.7, 39.3, 38.9, 39.2, 34.1, …</span>
<span class='c'>#&gt; $ bill_depth_mm     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> 18.7, 17.4, 18.0, NA, 19.3, 20.6, 17.8, 19.6, 18.1, …</span>
<span class='c'>#&gt; $ flipper_length_mm <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> 181, 186, 195, NA, 193, 190, 181, 195, 193, 190, 186…</span>
<span class='c'>#&gt; $ body_mass_g       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> 3750, 3800, 3250, NA, 3450, 3650, 3625, 4675, 3475, …</span>
<span class='c'>#&gt; $ sex               <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span> male, female, female, NA, female, male, female, male…</span>
<span class='c'>#&gt; $ year              <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> 2007, 2007, 2007, 2007, 2007, 2007, 2007, 2007, 2007…</span></code></pre>

</div>

Okay, now we have a sense of what the `penguins` dataset is.

Now we want to sort `penguins` dataframe by body mass to quickly learn about the lightest penguin and its relations to other variables. We will use the pipe operator `%>%` to feed the data to the `arrange()` function. We then specify name of the variable that we want to sort the dataframe by.

In this example, we are sorting by variable `body_mass_g`, so we will see the lightest penguins at the top of the dataframe:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span>           <span class='c'># take the penguins_data</span>
  <span class='nf'>arrange</span><span class='o'>(</span><span class='nv'>body_mass_g</span><span class='o'>)</span> <span class='c'># sort the dataframe in ascending order based on body mass</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 344 × 8</span></span>
<span class='c'>#&gt;    species   island    bill_length_mm bill_depth_mm flipper_length_… body_mass_g</span>
<span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span> Chinstrap Dream               46.9          16.6              192        <span style='text-decoration: underline;'>2</span>700</span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span> Adelie    Biscoe              36.5          16.6              181        <span style='text-decoration: underline;'>2</span>850</span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span> Adelie    Biscoe              36.4          17.1              184        <span style='text-decoration: underline;'>2</span>850</span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span> Adelie    Biscoe              34.5          18.1              187        <span style='text-decoration: underline;'>2</span>900</span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span> Adelie    Dream               33.1          16.1              178        <span style='text-decoration: underline;'>2</span>900</span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span> Adelie    Torgersen           38.6          17                188        <span style='text-decoration: underline;'>2</span>900</span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span> Chinstrap Dream               43.2          16.6              187        <span style='text-decoration: underline;'>2</span>900</span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span> Adelie    Biscoe              37.9          18.6              193        <span style='text-decoration: underline;'>2</span>925</span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span> Adelie    Dream               37.5          18.9              179        <span style='text-decoration: underline;'>2</span>975</span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span> Adelie    Dream               37            16.9              185        <span style='text-decoration: underline;'>3</span>000</span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 334 more rows, and 2 more variables: sex &lt;fct&gt;, year &lt;int&gt;</span></span></code></pre>

</div>

If we wanted to sort descendingly, such that the heaviest penguin are on top, we can add a [`-`](https://rdrr.io/r/base/Arithmetic.html) in front of the variable:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span>             <span class='c'># take the penguins_data</span>
  <span class='nf'>arrange</span><span class='o'>(</span><span class='o'>-</span><span class='nv'>body_mass_g</span><span class='o'>)</span>  <span class='c'># sort the dataframe in descending order based on body mass</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 344 × 8</span></span>
<span class='c'>#&gt;    species island bill_length_mm bill_depth_mm flipper_length_mm body_mass_g</span>
<span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>           <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>             <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span> Gentoo  Biscoe           49.2          15.2               221        <span style='text-decoration: underline;'>6</span>300</span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span> Gentoo  Biscoe           59.6          17                 230        <span style='text-decoration: underline;'>6</span>050</span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span> Gentoo  Biscoe           51.1          16.3               220        <span style='text-decoration: underline;'>6</span>000</span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span> Gentoo  Biscoe           48.8          16.2               222        <span style='text-decoration: underline;'>6</span>000</span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span> Gentoo  Biscoe           45.2          16.4               223        <span style='text-decoration: underline;'>5</span>950</span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span> Gentoo  Biscoe           49.8          15.9               229        <span style='text-decoration: underline;'>5</span>950</span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span> Gentoo  Biscoe           48.4          14.6               213        <span style='text-decoration: underline;'>5</span>850</span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span> Gentoo  Biscoe           49.3          15.7               217        <span style='text-decoration: underline;'>5</span>850</span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span> Gentoo  Biscoe           55.1          16                 230        <span style='text-decoration: underline;'>5</span>850</span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span> Gentoo  Biscoe           49.5          16.2               229        <span style='text-decoration: underline;'>5</span>800</span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 334 more rows, and 2 more variables: sex &lt;fct&gt;, year &lt;int&gt;</span></span></code></pre>

</div>

We can also pipe the results into the [`filter()`](https://rdrr.io/r/stats/filter.html) function covered last week, to select only penguins weighing more than 5000 g:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_new</span> <span class='o'>&lt;-</span>     <span class='c'># assign the results to a dataframe `penguins_new`</span>
  <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>                               <span class='c'># take the penguins data</span>
  <span class='nf'>arrange</span><span class='o'>(</span><span class='nv'>bill_length_mm</span>, <span class='nv'>bill_depth_mm</span><span class='o'>)</span> <span class='o'>%&gt;%</span> <span class='c'># sort by bill length followed by bill depth</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>body_mass_g</span> <span class='o'>&gt;</span> <span class='m'>5000</span><span class='o'>)</span>                 <span class='c'># select species greater with mass &gt; 5000 g.</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>penguins_new</span>, <span class='m'>5</span><span class='o'>)</span>     <span class='c'># look at the top 5 </span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 5 × 8</span></span>
<span class='c'>#&gt;   species island bill_length_mm bill_depth_mm flipper_length_… body_mass_g sex  </span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>           <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> Gentoo  Biscoe           44.4          17.3              219        <span style='text-decoration: underline;'>5</span>250 male </span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> Gentoo  Biscoe           44.9          13.3              213        <span style='text-decoration: underline;'>5</span>100 fema…</span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> Gentoo  Biscoe           45            15.4              220        <span style='text-decoration: underline;'>5</span>050 male </span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span> Gentoo  Biscoe           45.1          14.5              207        <span style='text-decoration: underline;'>5</span>050 fema…</span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span> Gentoo  Biscoe           45.2          14.8              212        <span style='text-decoration: underline;'>5</span>200 fema…</span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 1 more variable: year &lt;int&gt;</span></span></code></pre>

</div>

Let's check the counts of different species and islands among our new dataset:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_new</span> <span class='o'>%&gt;%</span>
  <span class='nf'>count</span><span class='o'>(</span><span class='nv'>species</span>, .drop <span class='o'>=</span> <span class='kc'>FALSE</span><span class='o'>)</span>   <span class='c'># .drop=FALSE will keep values of 0</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 2</span></span>
<span class='c'>#&gt;   species       n</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie        0</span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> Chinstrap     0</span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> Gentoo       61</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_new</span> <span class='o'>%&gt;%</span>
  <span class='nf'>count</span><span class='o'>(</span><span class='nv'>island</span>, .drop <span class='o'>=</span> <span class='kc'>FALSE</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 2</span></span>
<span class='c'>#&gt;   island        n</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> Biscoe       61</span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> Dream         0</span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> Torgersen     0</span></code></pre>

</div>

You can see that we have only retained Gentoo Penguins from the island of Biscoe.

<br>

------------------------------------------------------------------------

## Breakout session 1 - `arrange()`

<div class="alert puzzle">

<div>

### Exercise 1

With the `penguins` dataset, answer the following questions:

-   Create a new dataset called `penguins_shortflippers` from the `penguins` dataset with the 20 penguins with the shortest flippers.

-   How many penguins of each species are found in `penguins_shortflippers`?

-   Which islands do they come from?

<details>
<summary>
Hints
</summary>

<br>

-   To create `penguins_shortflippers`, first use `arrange()` to sort by flipper lengths, and pipe the results into the [`head()`](https://rdrr.io/r/utils/head.html) function to get the top 20.

-   To get the species and island composition, use the `count()` function.

</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

-   To create a dataframe with the 20 penguins with the shortest flippers:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_shortflippers</span> <span class='o'>&lt;-</span>        <span class='c'># assign the results</span>
  <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>                   <span class='c'># take penguins_data</span>
  <span class='nf'>arrange</span><span class='o'>(</span><span class='nv'>flipper_length_mm</span><span class='o'>)</span> <span class='o'>%&gt;%</span> <span class='c'># sort the data by bill flipper length </span>
  <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='m'>20</span><span class='o'>)</span>                       <span class='c'># take the top 20</span></code></pre>

</div>

-   To see the species composition in `penguins_shortflippers`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_shortflippers</span> <span class='o'>%&gt;%</span>
  <span class='nf'>count</span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 2 × 2</span></span>
<span class='c'>#&gt;   species       n</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie       17</span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> Chinstrap     3</span></code></pre>

</div>

-   To see the island composition in `penguins_shortflippers`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_shortflippers</span> <span class='o'>%&gt;%</span>
  <span class='nf'>count</span><span class='o'>(</span><span class='nv'>island</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 2</span></span>
<span class='c'>#&gt;   island        n</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> Biscoe        7</span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> Dream         9</span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> Torgersen     4</span></code></pre>

</div>

</details>

</div>

</div>

<br>

------------------------------------------------------------------------

## 3 - Using `mutate()`

Besides selecting sets of existing columns, it's often useful to add new columns that are derived from existing columns. The `mutate()` function create new variables, usually by manipulating existing variables.

`mutate()` always adds new columns at the end of the dataframe. When you use `mutate()`, you need typically to specify 3 things:

-   the name of the dataframe you want to modify
-   the name of the new column that you'll create
-   the values to be inserted in the new column

We will be working with the penguins dataset to learn the `mutate()` function. We will create a new dataframe called `mutate_penguins`, with a new column called `body_mass_g_new`.

The first argument (dataset to be piped) is the dataframe we're going to modify, `penguins`. After that, we have the name-value pair for our new variable.

Here, the name of the new variable is `size` and the values are `body_mass_g` multiplied by `flipper_length_mm`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>mutate_penguins</span> <span class='o'>&lt;-</span>  <span class='c'># assign the results to a dataframe `mutate_penguins`</span>
  <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>      <span class='c'># take the penguins_data</span>
  <span class='nf'>mutate</span><span class='o'>(</span>size <span class='o'>=</span> <span class='nv'>body_mass_g</span> <span class='o'>*</span> <span class='nv'>flipper_length_mm</span><span class='o'>)</span> <span class='c'># create a new column</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>mutate_penguins</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='m'>6</span><span class='o'>:</span><span class='m'>9</span><span class='o'>)</span>       <span class='c'># show the first rows of columns 6-9</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 4</span></span>
<span class='c'>#&gt;   body_mass_g sex     year   size</span>
<span class='c'>#&gt;         <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span>        <span style='text-decoration: underline;'>3</span>750 male    <span style='text-decoration: underline;'>2</span>007 <span style='text-decoration: underline;'>678</span>750</span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span>        <span style='text-decoration: underline;'>3</span>800 female  <span style='text-decoration: underline;'>2</span>007 <span style='text-decoration: underline;'>706</span>800</span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span>        <span style='text-decoration: underline;'>3</span>250 female  <span style='text-decoration: underline;'>2</span>007 <span style='text-decoration: underline;'>633</span>750</span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span>          <span style='color: #BB0000;'>NA</span> <span style='color: #BB0000;'>NA</span>      <span style='text-decoration: underline;'>2</span>007     <span style='color: #BB0000;'>NA</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span>        <span style='text-decoration: underline;'>3</span>450 female  <span style='text-decoration: underline;'>2</span>007 <span style='text-decoration: underline;'>665</span>850</span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span>        <span style='text-decoration: underline;'>3</span>650 male    <span style='text-decoration: underline;'>2</span>007 <span style='text-decoration: underline;'>693</span>500</span></code></pre>

</div>

You can see that we created data with a new column called `size`.

<br>

------------------------------------------------------------------------

## Breakout session 2 - `mutate()`

<div class="alert puzzle">

<div>

### Exercise 2

-   Create a new dataframe called `penguins_bills` with a new column called `bill_shape` by dividing bill length by bill depth.

-   What is the species composition of the 20 penguins with the *largest* values for `bill_shape`?

<details>
<summary>
Hints (click here)
</summary>

<br>

To get the species composition of the top 20, first use `arrange()` (think about the direction you need to sort in!), then [`head()`](https://rdrr.io/r/utils/head.html), and then `count()`.

</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

-   New dataframe with a bill shape variable:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_bills</span> <span class='o'>&lt;-</span>
  <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>      <span class='c'># take the penguins_data</span>
  <span class='nf'>mutate</span><span class='o'>(</span>bill_shape <span class='o'>=</span> <span class='nv'>bill_length_mm</span> <span class='o'>/</span> <span class='nv'>bill_depth_mm</span><span class='o'>)</span> <span class='c'># Create a new column `bill_shape`   </span></code></pre>

</div>

-   Species composition of the 20 penguins with the largest `bill_shape` values:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_bills</span> <span class='o'>%&gt;%</span>
  <span class='nf'>arrange</span><span class='o'>(</span><span class='o'>-</span><span class='nv'>bill_shape</span><span class='o'>)</span> <span class='o'>%&gt;%</span>  <span class='c'># sort by bill_shape in descending order</span>
  <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='m'>20</span><span class='o'>)</span> <span class='o'>%&gt;%</span>              <span class='c'># take the top 20</span>
  <span class='nf'>count</span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span>            <span class='c'># create a frequency table</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1 × 2</span></span>
<span class='c'>#&gt;   species     n</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> Gentoo     20</span></code></pre>

</div>

They are all Gentoo penguins!

</details>

</div>

</div>

<div class="alert puzzle">

<div>

### Exercise 3

Create a new dataframe called `penguins_year`:

-   with only penguins sampled after 2007,
-   with a new column called `year_nr` which has a year number that starts counting from 2008 (i.e., 2008 = year 1, 2009 = year 2, etc.)
-   sorted by `year_nr`.

<details>
<summary>
Hint (click here)
</summary>

Not all values you pass to `mutate()` need to be variables! You can subtract `year` by a fixed number.

</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_year</span> <span class='o'>&lt;-</span>
  <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>year</span> <span class='o'>&gt;</span> <span class='m'>2007</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>mutate</span><span class='o'>(</span>year_nr <span class='o'>=</span> <span class='nv'>year</span> <span class='o'>-</span> <span class='m'>2007</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>arrange</span><span class='o'>(</span><span class='nv'>year_nr</span><span class='o'>)</span></code></pre>

</div>

</details>

</div>

</div>

<br>

------------------------------------------------------------------------

