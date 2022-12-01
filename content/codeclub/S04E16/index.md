---
output: hugodown::md_document
title: "S04E16: R for Data Science - Exploratory Data Analysis II"
subtitle: "Chapter 7.4 - 7.5: Missing Values and Covariation"
summary: "We continue with this chapter on Exploratory Data Analysis (EDA), now covering missing values (and the ifelse function to turn outliers into missing values) and covariation among variables, with a couple of new plot types: boxplots and heatmaps."
authors: [admin]
tags: [codeclub, r4ds]
date: 2022-12-01
lastmod: 2022-12-01
toc: true
rmd_hash: be02889adfbb1f5d

---

------------------------------------------------------------------------

## Setting up

Like last time, we'll mostly use *tidyverse* tools to explore the `diamonds` dataset, which is also part of the *tidyverse*.

We'll also have a quick look at the `flights` dataset, for which we'll need to load the *nycflights13* package:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>## You only need to install if you haven't previously done so</span></span>
<span><span class='c'># install.packages("tidyverse")</span></span>
<span><span class='c'># install.packages("nycflights13")</span></span>
<span></span>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span></span>
<span><span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching packages</span> ─────────────────────────────────────── tidyverse 1.3.2 ──</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>ggplot2</span> 3.3.6      <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>purrr  </span> 0.3.5 </span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tibble </span> 3.1.8      <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>dplyr  </span> 1.0.10</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tidyr  </span> 1.2.1      <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>stringr</span> 1.4.1 </span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>readr  </span> 2.1.3      <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>forcats</span> 0.5.2 </span></span>
<span><span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span> ────────────────────────────────────────── tidyverse_conflicts() ──</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>filter()</span> masks <span style='color: #0000BB;'>stats</span>::filter()</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>lag()</span>    masks <span style='color: #0000BB;'>stats</span>::lag()</span></span><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/hadley/nycflights13'>nycflights13</a></span><span class='o'>)</span></span></code></pre>

</div>

Let's again take a quick look at the `diamonds` dataset before we begin:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>diamonds</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 53,940 × 10</span></span></span>
<span><span class='c'>#&gt;    carat cut       color clarity depth table price     x     y     z</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;ord&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;ord&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;ord&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>  0.23 Ideal     E     SI2      61.5    55   326  3.95  3.98  2.43</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>  0.21 Premium   E     SI1      59.8    61   326  3.89  3.84  2.31</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>  0.23 Good      E     VS1      56.9    65   327  4.05  4.07  2.31</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>  0.29 Premium   I     VS2      62.4    58   334  4.2   4.23  2.63</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>  0.31 Good      J     SI2      63.3    58   335  4.34  4.35  2.75</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>  0.24 Very Good J     VVS2     62.8    57   336  3.94  3.96  2.48</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>  0.24 Very Good I     VVS1     62.3    57   336  3.95  3.98  2.47</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>  0.26 Very Good H     SI1      61.9    55   337  4.07  4.11  2.53</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>  0.22 Fair      E     VS2      65.1    61   337  3.87  3.78  2.49</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>  0.23 Very Good H     VS1      59.4    61   338  4     4.05  2.39</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 53,930 more rows</span></span></span></code></pre>

</div>

On each row, we have information about one individual diamond, such as its `carat` and `price` (`x`, `y`, and `z` represent the diamond's length, width, and depth, respectively.)

Finally, we'll again set a *ggplot2* "theme" that is a little better-looking than the default one (this setting will apply until you restart R/RStudio):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># This changes two things:</span></span>
<span><span class='c'># - theme_minimal() gives an overall different look, with a white background</span></span>
<span><span class='c'># - base_size = 14 will make the text relatively bigger</span></span>
<span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/theme_get.html'>theme_set</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggtheme.html'>theme_minimal</a></span><span class='o'>(</span>base_size <span class='o'>=</span> <span class='m'>14</span><span class='o'>)</span><span class='o'>)</span></span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## Chapter 7.4: Missing values

### Removing outliers

Let's assume you have established that certain outlier values in your data are untrustworthy. For instance, see the plot below for the `diamonds` data, a scatterplot of diamond width (`y`) versus depth (`z`):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>diamonds</span>,</span>
<span>       mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>z</span>, y <span class='o'>=</span> <span class='nv'>y</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_point.html'>geom_point</a></span><span class='o'>(</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-4-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Three rather extreme outliers deviate not just in their absolute values, but also in their relative values: overall, depth and width are strongly correlated, yet the extremely large `z` value does not correspond to a large `y` value at all (and so on for the other outliers).

To get rid of outliers in your dataset, you have two main options. First, you could **completely remove rows that contain outliers**, for example with *dplyr*'s [`filter()`](https://dplyr.tidyverse.org/reference/filter.html) function:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># Remove rows for which column y is smaller than 3 or larger than 20: </span></span>
<span><span class='nv'>diamonds2</span> <span class='o'>&lt;-</span> <span class='nv'>diamonds</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>y</span> <span class='o'>&lt;</span> <span class='m'>3</span> <span class='o'>|</span> <span class='nv'>y</span> <span class='o'>&gt;</span> <span class='m'>20</span><span class='o'>)</span></span></code></pre>

</div>

But you may not want throw out entire rows, because the values for the *other variables* (columns) in these rows might be valid and valuable. Therefore, and alternative is to **convert outliers to `NA`s (missing values)**, and a convenient way to do that is with the [`ifelse()`](https://rdrr.io/r/base/ifelse.html) function:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>diamonds_no_outliers</span> <span class='o'>&lt;-</span> <span class='nv'>diamonds</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>y <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='o'>(</span>test <span class='o'>=</span> <span class='nv'>y</span> <span class='o'>&lt;</span> <span class='m'>3</span> <span class='o'>|</span> <span class='nv'>y</span> <span class='o'>&gt;</span> <span class='m'>20</span>, yes <span class='o'>=</span> <span class='kc'>NA</span>, no <span class='o'>=</span> <span class='nv'>y</span><span class='o'>)</span><span class='o'>)</span></span></code></pre>

</div>

<div class="alert alert-note">

<div>

### More on `ifelse()`

To better understand [`ifelse()`](https://rdrr.io/r/base/ifelse.html), a simple example may help:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># Create a vector with integers from 1 to 10:</span></span>
<span><span class='nv'>x</span> <span class='o'>&lt;-</span> <span class='m'>1</span><span class='o'>:</span><span class='m'>10</span></span>
<span><span class='nv'>x</span></span>
<span><span class='c'>#&gt;  [1]  1  2  3  4  5  6  7  8  9 10</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># This will return a logical vector, indicating, for each value,</span></span>
<span><span class='c'># whether it is smaller than 5:</span></span>
<span><span class='nv'>x</span> <span class='o'>&lt;</span> <span class='m'>5</span></span>
<span><span class='c'>#&gt;  [1]  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># We can turn the small values into NAs, and leave big values unchanged, as follows:</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='o'>(</span>test <span class='o'>=</span> <span class='nv'>x</span> <span class='o'>&lt;</span> <span class='m'>5</span>, yes <span class='o'>=</span> <span class='kc'>NA</span>, no <span class='o'>=</span> <span class='nv'>x</span><span class='o'>)</span></span>
<span><span class='c'>#&gt;  [1] NA NA NA NA  5  6  7  8  9 10</span></span></code></pre>

</div>

</div>

</div>

### Comparing observations with and without missing data

It can be useful to compare distributions among observations with and without missing values. To do that, we can first create a new variable that indicates whether a value is missing or not. Then, we can map an aesthetic like `color` to this variable to show the two groups separately.

Below, we'll compare flights with and without missing values for departure time (`dep_time`), since the former are cancelled flights, using the geom `geom_freqpoly` that we also saw last time:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>cancelled <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/NA.html'>is.na</a></span><span class='o'>(</span><span class='nv'>dep_time</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>sched_dep_time</span>, color <span class='o'>=</span> <span class='nv'>cancelled</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_histogram.html'>geom_freqpoly</a></span><span class='o'>(</span>binwidth <span class='o'>=</span> <span class='m'>100</span><span class='o'>)</span> <span class='c'># (100 = 1 hour, so we plot by hour)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-10-1.png" width="700px" style="display: block; margin: auto;" />

</div>

However, the large difference in the absolute counts of cancelled versus not-cancelled flights makes it hard to see relative differences along the x-axis.

We can use [`geom_density()`](https://ggplot2.tidyverse.org/reference/geom_density.html) to produce a **density plot**, where the height of the lines is only determined by the relative counts, allowing us to see if cancelled flights have a different distribution:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>cancelled <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/NA.html'>is.na</a></span><span class='o'>(</span><span class='nv'>dep_time</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>sched_dep_time</span>, color <span class='o'>=</span> <span class='nv'>cancelled</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_density.html'>geom_density</a></span><span class='o'>(</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-11-1.png" width="700px" style="display: block; margin: auto;" />

</div>

It looks like flights at the end of the day are much more commonly cancelled than those early on, which is what we might have expected!

<br>

------------------------------------------------------------------------

## Chapter 7.5: Covariation

This section of the book covers the exploration of covariation among two variables. For example, is there a relationship between the cut and the price of a diamond (a categorical and continuous variable)? Or between the cut and color of a diamond (two categorical variables)? Or between the carat and the price of a diamond (two continuous variables)?

### 7.5.1: A categorical and continuous variable

In out last plot above, we actually explored the relationship between a categorical variable (cancelled & not-cancelled flights) and a continuous one (departure time).

Let's see another example, this time for the `diamonds` dataset: whether prices differ among diamond cuts:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>diamonds</span>,</span>
<span>       mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>price</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_density.html'>geom_density</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>colour <span class='o'>=</span> <span class='nv'>cut</span><span class='o'>)</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-12-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Another classic way of showing the relationship between a categorical and a continuous variable is with a **boxplot**. [The book](https://r4ds.had.co.nz/exploratory-data-analysis.html#cat-cont) has a good explanation of what the components of a boxplot (box, median line, whiskers, outliers) represent. Let's make a boxplot of diamond prices by cut:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># To make the plot better-looking, and to see the same colors as above,</span></span>
<span><span class='c'># we'll also map the fill aesthetic to cut:</span></span>
<span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>diamonds</span>,</span>
<span>       mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>cut</span>, y <span class='o'>=</span> <span class='nv'>price</span>, fill <span class='o'>=</span> <span class='nv'>cut</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_boxplot.html'>geom_boxplot</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/guides.html'>guides</a></span><span class='o'>(</span>fill <span class='o'>=</span> <span class='s'>"none"</span><span class='o'>)</span> <span class='c'># Just to turn the legend for fill off</span></span>
</code></pre>
<img src="figs/unnamed-chunk-13-1.png" width="700px" style="display: block; margin: auto;" />

</div>

A less formal, but sometimes more informative variant of this type of plot is a **violin plot**, where the width represents the number of data points:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>diamonds</span>,</span>
<span>       mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>cut</span>, y <span class='o'>=</span> <span class='nv'>price</span>, fill <span class='o'>=</span> <span class='nv'>cut</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_violin.html'>geom_violin</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/guides.html'>guides</a></span><span class='o'>(</span>fill <span class='o'>=</span> <span class='s'>"none"</span><span class='o'>)</span> <span class='c'># Just to turn the legend for fill off</span></span>
</code></pre>
<img src="figs/unnamed-chunk-14-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<br>

### 7.5.2: Two categorical variables

As the books says,

> To visualise the covariation between categorical variables, you'll need to count the number of observations for each combination.

A quick way to do that is with [`geom_count()`](https://ggplot2.tidyverse.org/reference/geom_count.html):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>diamonds</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_count.html'>geom_count</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>color</span>, y <span class='o'>=</span> <span class='nv'>cut</span><span class='o'>)</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-15-1.png" width="700px" style="display: block; margin: auto;" />

</div>

A slightly more visually appealing way to plot this is using a heatmap, which we can do with [`geom_tile()`](https://ggplot2.tidyverse.org/reference/geom_tile.html) after we calculate the counts ourselves:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>diamonds</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/count.html'>count</a></span><span class='o'>(</span><span class='nv'>color</span>, <span class='nv'>cut</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>  </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>color</span>, y <span class='o'>=</span> <span class='nv'>cut</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_tile.html'>geom_tile</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>fill <span class='o'>=</span> <span class='nv'>n</span><span class='o'>)</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-16-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<br>

### 7.5.3: Two continuous variables

Visualizing the relationship between two continuous variables is perhaps the most intuitive of the combinations. It can be done with simple scatterplots ([`geom_point()`](https://ggplot2.tidyverse.org/reference/geom_point.html)), of which we have already seen a couple of examples.

The books covers a few strategies that can be useful when dealing with large datasets, when relationships may be hidden due to overplotting. Consider the relationship between the carat (weight) and price of diamonds:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>diamonds</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_point.html'>geom_point</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>carat</span>, y <span class='o'>=</span> <span class='nv'>price</span><span class='o'>)</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-17-1.png" width="700px" style="display: block; margin: auto;" />

</div>

There is clearly some overplotting going on here, with some areas of solid black -- though this type of thing can get a lot worse and the overall pattern is still clear in this case.

Making points transparent is one strategy to more clearly see patterns in the data:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># An alpha of 1 (the default) is opaque and an alpha of 1 is transparent </span></span>
<span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>diamonds</span><span class='o'>)</span> <span class='o'>+</span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_point.html'>geom_point</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>carat</span>, y <span class='o'>=</span> <span class='nv'>price</span><span class='o'>)</span>,</span>
<span>             alpha <span class='o'>=</span> <span class='m'>0.01</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-18-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Two other strategies covered in the book are:

-   Use automated 2-dimensional binning (e.g. with `geom_bin2d`)

-   Bin one of the continuous variables, effectively turning it into a categorical variable, so that we can use plot types like boxplots. You'll try that in the exercises.

<br>

------------------------------------------------------------------------

## Breakout Rooms

All the exercises use the `diamonds` dataset. After loading the *tidyverse*, this dataset should be available to you.

<div class="puzzle">

<div>

### Exercise 1

Use the function [`cut_number()`](https://ggplot2.tidyverse.org/reference/cut_interval.html) to divide the `carat` values into 10 bins, and create a boxplot of diamond prices for each of these bins.

*Tip: If you can't read the x-axis labels (bin names) in the resulting plot * *because they overlap, consider flipping the plot:* *simply swap the `x` and `y` aesthetic assignments* *(alternatively, use the stand-alone function [`coord_flip()`](https://ggplot2.tidyverse.org/reference/coord_flip.html)).*

<details>
<summary>
<b>Hints</b> (click here)
</summary>

<br>

-   You can start by creating a binned column with [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) and `cut_width(carat, 0.1)`, *or* you can create the bins "on the fly", by simply using `cut_width(carat, 0.1)` as `x` or `y` aesthetic.

-   An alternative way of making this kind of plot would be by using [`cut_width()`](https://ggplot2.tidyverse.org/reference/cut_interval.html) instead of [`cut_number()`](https://ggplot2.tidyverse.org/reference/cut_interval.html): then, you fix the width of each bin rather than the number of data points in each bin. The disadvantage of that approach is that you may be misled by bins with very few data points, but a way to ameliorate this is by using the `varwidth = TRUE` argument of [`geom_boxplot()`](https://ggplot2.tidyverse.org/reference/geom_boxplot.html).

</details>

<br>

<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

To be able to read the axis labels, I moved `carat` to the y axis (and I also added a y-axis label):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>diamonds</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>y <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/cut_interval.html'>cut_number</a></span><span class='o'>(</span><span class='nv'>carat</span>, <span class='m'>10</span><span class='o'>)</span>, x <span class='o'>=</span> <span class='nv'>price</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_boxplot.html'>geom_boxplot</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/labs.html'>labs</a></span><span class='o'>(</span>y <span class='o'>=</span> <span class='s'>"carat (binned)"</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-19-1.png" width="700px" style="display: block; margin: auto;" />

</div>

The book has the following code to do this, which is less intuitive but has the advantage of keeping the carat axis labels as if it still were a continuous variable:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>diamonds</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>carat</span>, y <span class='o'>=</span> <span class='nv'>price</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_boxplot.html'>geom_boxplot</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>group <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/cut_interval.html'>cut_width</a></span><span class='o'>(</span><span class='nv'>carat</span>, <span class='m'>0.2</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-20-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Alternatively, you can use the [`cut_width()`](https://ggplot2.tidyverse.org/reference/cut_interval.html) function:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>diamonds</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>y <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/cut_interval.html'>cut_width</a></span><span class='o'>(</span><span class='nv'>carat</span>, <span class='m'>0.2</span><span class='o'>)</span>, x <span class='o'>=</span> <span class='nv'>price</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_boxplot.html'>geom_boxplot</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/labs.html'>labs</a></span><span class='o'>(</span>y <span class='o'>=</span> <span class='s'>"carat (binned)"</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-21-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Use `varwidth = TRUE` if you want the width of the boxplots to reflect the number of data points:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>diamonds</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>y <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/cut_interval.html'>cut_width</a></span><span class='o'>(</span><span class='nv'>carat</span>, <span class='m'>0.2</span><span class='o'>)</span>, x <span class='o'>=</span> <span class='nv'>price</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_boxplot.html'>geom_boxplot</a></span><span class='o'>(</span>varwidth <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/labs.html'>labs</a></span><span class='o'>(</span>y <span class='o'>=</span> <span class='s'>"carat (binned)"</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-22-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

</div>

<br>

<div class="puzzle">

<div>

### Exercise 2

-   Create a heatmap ([`geom_tile()`](https://ggplot2.tidyverse.org/reference/geom_tile.html)) that shows the mean diamond price for each diamond color and cut combination.

-   From your heatmap, would you say that going from color `D` =\> `J` is associated with an *increase* or a *decrease* in the mean price?

*Tip: add `+ scale_fill_viridis_c()` at the end for a much nicer color scale.*

<details>
<summary>
<b>Hints</b> (click here)
</summary>

<br>

-   In the heatmap, you'll want `color` along the `x` axis and `cut` along the `y` axis (or vice versa), and you'll want to `fill` the tiles by price.

-   You'll first have to compute the mean diamond price for each of the `color`-`cut` combinations: use [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html) and then [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html).

</details>

<br>

<details>
<summary>
<b>Solution just for getting the mean price</b> (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>diamonds</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>color</span>, <span class='nv'>cut</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span>price <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>price</span><span class='o'>)</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; `summarise()` has grouped output by 'color'. You can override using the</span></span>
<span><span class='c'>#&gt; `.groups` argument.</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 35 × 3</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># Groups:   color [7]</span></span></span>
<span><span class='c'>#&gt;    color cut       price</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;ord&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;ord&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> D     Fair      <span style='text-decoration: underline;'>4</span>291.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> D     Good      <span style='text-decoration: underline;'>3</span>405.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> D     Very Good <span style='text-decoration: underline;'>3</span>470.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> D     Premium   <span style='text-decoration: underline;'>3</span>631.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> D     Ideal     <span style='text-decoration: underline;'>2</span>629.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> E     Fair      <span style='text-decoration: underline;'>3</span>682.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> E     Good      <span style='text-decoration: underline;'>3</span>424.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> E     Very Good <span style='text-decoration: underline;'>3</span>215.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> E     Premium   <span style='text-decoration: underline;'>3</span>539.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> E     Ideal     <span style='text-decoration: underline;'>2</span>598.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 25 more rows</span></span></span></code></pre>

</div>

</details>

<br>

<details>
<summary>
<b>Full solution</b> (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>diamonds</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>color</span>, <span class='nv'>cut</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span>price <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>price</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>color</span>, y <span class='o'>=</span> <span class='nv'>cut</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_tile.html'>geom_tile</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>fill <span class='o'>=</span> <span class='nv'>price</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/scale_viridis.html'>scale_fill_viridis_c</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; `summarise()` has grouped output by 'color'. You can override using the</span></span>
<span><span class='c'>#&gt; `.groups` argument.</span></span></code></pre>
<img src="figs/unnamed-chunk-24-1.png" width="700px" style="display: block; margin: auto;" />

</div>

It looks like going from color `D` to `J` is associated with an overall increase in the mean price.

</details>

</div>

</div>

<br>

<br>

<div class="puzzle">

<div>

### Exercise 3

-   Make a plot to visualize the relationship between `color` and `carat`.

-   Seeing this relationship, and knowing that `carat` and `price` are strongly related (see the scatterplots above), do you think this might have influenced (confounded) the apparent relationship between `color` and `price`?

-   How could you quickly create a price index that controls for `carat`? Make a heatmap with that price index instead of the raw price.

-   Bonus: to better understand the relationship between `color`, `carat`, and `price`, modify the earlier scatterplot of `carat` and `price` simply by mapping diamond `color` to the color aesthetic.

<details>
<summary>
<b>Hints</b> (click here)
</summary>

<br>

-   Use a boxplot, violin plot and/or a density plot to visualize the relationship between `color` and `carat`.

-   If higher carats are causally associated with higher prices, and certain colors have higher mean carats than others, it is not fair to look at the effect of color on price without somehow taking carat into account.

-   A simple way of taking carat into account is by using price-per-carat rather than price in your heatmap.

</details>

<br>

<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

-   To visualize the relationship between `color` and `carat`, you could for example use a boxplot and/or a density plot:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>diamonds</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>color</span>, y <span class='o'>=</span> <span class='nv'>carat</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_boxplot.html'>geom_boxplot</a></span><span class='o'>(</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-25-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>diamonds</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>carat</span>, color <span class='o'>=</span> <span class='nv'>color</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_density.html'>geom_density</a></span><span class='o'>(</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-26-1.png" width="700px" style="display: block; margin: auto;" />

</div>

-   It looks like going from `D` =\> `J`, `carat` is higher.

-   Since `carat` is strongly positively associated with `price`, it is therefore not fair to compare prices among colors without controlling for `carat`.

-   A simple way to do so is dividing `price` by `carat` to create an index that represents the "price per carat". Then, you can use that index instead of the raw price in your heatmap:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>diamonds</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>color</span>, <span class='nv'>cut</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>price_per_carat <span class='o'>=</span> <span class='nv'>price</span> <span class='o'>/</span> <span class='nv'>carat</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span>price_per_carat <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>price_per_carat</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>color</span>, y <span class='o'>=</span> <span class='nv'>cut</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_tile.html'>geom_tile</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>fill <span class='o'>=</span> <span class='nv'>price_per_carat</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/scale_viridis.html'>scale_fill_viridis_c</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; `summarise()` has grouped output by 'color'. You can override using the</span></span>
<span><span class='c'>#&gt; `.groups` argument.</span></span></code></pre>
<img src="figs/unnamed-chunk-27-1.png" width="700px" style="display: block; margin: auto;" />

</div>

-   Now, it looks like going from `D` =\> `J` is associated with a **decrease** rather than an increase in the mean price!

-   A scatterplot of carat and price that includes diamond color confirms this pattern:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>diamonds</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>carat</span>, y <span class='o'>=</span> <span class='nv'>price</span>, color <span class='o'>=</span> <span class='nv'>color</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_point.html'>geom_point</a></span><span class='o'>(</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-28-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

## Bonus: (re)ordering factor levels

In the plots with diamond `cut`, you might have noticed that the cuts are ordered in a custom, sensible way rather than alphabetically. This is possible because the `cut` column has the data type `factor`.

If we convert `cut` to a regular character data type, the custom order disappears (it is now ordered alphabetically):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>diamonds</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>cut <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/character.html'>as.character</a></span><span class='o'>(</span><span class='nv'>cut</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>cut</span>, y <span class='o'>=</span> <span class='nv'>price</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_boxplot.html'>geom_boxplot</a></span><span class='o'>(</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-29-1.png" width="700px" style="display: block; margin: auto;" />

</div>

We could set a different custom order using the `levels` argument of the `factor` function (the same code would work if `cut` would not yet have been a factor):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>cut_order</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"Very Good"</span>, <span class='s'>"Fair"</span>, <span class='s'>"Good"</span>, <span class='s'>"Ideal"</span>, <span class='s'>"Premium"</span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>diamonds</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>cut <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/factor.html'>factor</a></span><span class='o'>(</span><span class='nv'>cut</span>, levels <span class='o'>=</span> <span class='nv'>cut_order</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>cut</span>, y <span class='o'>=</span> <span class='nv'>price</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_boxplot.html'>geom_boxplot</a></span><span class='o'>(</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-30-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Or, you could make the order of the factor levels depend on the data (!):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>diamonds</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>cut <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/stats/reorder.factor.html'>reorder</a></span><span class='o'>(</span><span class='nv'>cut</span>, <span class='nv'>price</span>, FUN <span class='o'>=</span> <span class='nv'>median</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>cut</span>, y <span class='o'>=</span> <span class='nv'>price</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_boxplot.html'>geom_boxplot</a></span><span class='o'>(</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-31-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<br>

