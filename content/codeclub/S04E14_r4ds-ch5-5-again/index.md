---
output: hugodown::md_document
title: "S04E14: R for Data Science - Chapter 5.6: summarize, some more"
subtitle: "Continuing to use summarize() to extract information from our data"
summary: "Today we will continue to investigate the summarize() function. Together with group_by(), this function is extremely useful to produce summary statistics of your data by group."
authors: [jessica-cooperstone]
tags: [codeclub, r4ds]
date: "2022-11-10"
lastmod: "2022-11-10"
toc: true
rmd_hash: 4fe3ffb10ce648b3

---

------------------------------------------------------------------------

## Get data and package

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># only if you haven't done so before, install the packages</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"tidyverse"</span><span class='o'>)</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"nycflights13"</span><span class='o'>)</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"palmerpenguins"</span><span class='o'>)</span></span></code></pre>

</div>

Load libraries

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span> <span class='c'># for everything</span></span>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/'>palmerpenguins</a></span><span class='o'>)</span> <span class='c'># for penguins data</span></span>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/hadley/nycflights13'>nycflights13</a></span><span class='o'>)</span> <span class='c'># for flights data</span></span></code></pre>

</div>

### Preview the Dataset

We are going to start with the penguins.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://pillar.r-lib.org/reference/glimpse.html'>glimpse</a></span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; Rows: 344</span></span>
<span><span class='c'>#&gt; Columns: 8</span></span>
<span><span class='c'>#&gt; $ species           <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span> Adelie, Adelie, Adelie, Adelie, Adelie, Adelie, Adel…</span></span>
<span><span class='c'>#&gt; $ island            <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span> Torgersen, Torgersen, Torgersen, Torgersen, Torgerse…</span></span>
<span><span class='c'>#&gt; $ bill_length_mm    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> 39.1, 39.5, 40.3, NA, 36.7, 39.3, 38.9, 39.2, 34.1, …</span></span>
<span><span class='c'>#&gt; $ bill_depth_mm     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> 18.7, 17.4, 18.0, NA, 19.3, 20.6, 17.8, 19.6, 18.1, …</span></span>
<span><span class='c'>#&gt; $ flipper_length_mm <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> 181, 186, 195, NA, 193, 190, 181, 195, 193, 190, 186…</span></span>
<span><span class='c'>#&gt; $ body_mass_g       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> 3750, 3800, 3250, NA, 3450, 3650, 3625, 4675, 3475, …</span></span>
<span><span class='c'>#&gt; $ sex               <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span> male, female, female, NA, female, male, female, male…</span></span>
<span><span class='c'>#&gt; $ year              <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> 2007, 2007, 2007, 2007, 2007, 2007, 2007, 2007, 2007…</span></span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## Review of `summarize()`

Different from [`select()`](https://dplyr.tidyverse.org/reference/select.html) (which picks columns but retains all rows) and [`filter()`](https://dplyr.tidyverse.org/reference/filter.html) (which picks observations but retains all columns), [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html) creates a wholly new dataframe by making calculations or pulling parts of your original dataframe.

For example, if we want to know the mean `body_mass_g` across all penguins in the dataset, we can calculate that like this:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>penguins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span>mean_body_mass <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>body_mass_g</span>, <span class='c'># calculate mean body mass</span></span>
<span>                                  na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span><span class='o'>)</span> <span class='c'># remove the NAs</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1 × 1</span></span></span>
<span><span class='c'>#&gt;   mean_body_mass</span></span>
<span><span class='c'>#&gt;            <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span>          <span style='text-decoration: underline;'>4</span>202.</span></span></code></pre>

</div>

But we may actually be interested in the different mean `body_mass_g` calculated separately for the different `species` of penguins. We can do that by adding the function [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html) like this:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>penguins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='c'># group by species</span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span>mean_body_mass <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>body_mass_g</span>, <span class='c'># calculate mean body mass by species</span></span>
<span>                                  na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span><span class='o'>)</span> <span class='c'># remove the NAs</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 2</span></span></span>
<span><span class='c'>#&gt;   species   mean_body_mass</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie             <span style='text-decoration: underline;'>3</span>701.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Chinstrap          <span style='text-decoration: underline;'>3</span>733.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> Gentoo             <span style='text-decoration: underline;'>5</span>076.</span></span></code></pre>

</div>

And, you can also add more than one [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html) factor, for example, by the full combination `species` and `sex` variables.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>penguins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>species</span>, <span class='nv'>sex</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='c'># group by species and sex combos</span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span>mean_body_mass <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>body_mass_g</span>, <span class='c'># calculate mean body mass by species</span></span>
<span>                                  na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span><span class='o'>)</span> <span class='c'># remove the NAs</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 8 × 3</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># Groups:   species [3]</span></span></span>
<span><span class='c'>#&gt;   species   sex    mean_body_mass</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>           <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie    female          <span style='text-decoration: underline;'>3</span>369.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Adelie    male            <span style='text-decoration: underline;'>4</span>043.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> Adelie    <span style='color: #BB0000;'>NA</span>              <span style='text-decoration: underline;'>3</span>540 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> Chinstrap female          <span style='text-decoration: underline;'>3</span>527.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> Chinstrap male            <span style='text-decoration: underline;'>3</span>939.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> Gentoo    female          <span style='text-decoration: underline;'>4</span>680.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>7</span> Gentoo    male            <span style='text-decoration: underline;'>5</span>485.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>8</span> Gentoo    <span style='color: #BB0000;'>NA</span>              <span style='text-decoration: underline;'>4</span>588.</span></span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## Using more functions in `summarize()`

Last week we went over using a few different functions within [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html).

-   [`mean()`](https://rdrr.io/r/base/mean.html): calculates the mean (set `na.rm = TRUE` if you was the NAs to be removed before calculating)
-   [`n()`](https://dplyr.tidyverse.org/reference/context.html): counts the number of observations

But, there are lots more functions you might be interested to add into [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html), including:

-   [`median()`](https://rdrr.io/r/stats/median.html): when you want to calculate the median instead of the mean
-   [`sd()`](https://rdrr.io/r/stats/sd.html): calculates the standard deviation
-   [`IQR()`](https://rdrr.io/r/stats/IQR.html): calculates the interquartile range
-   [`sum()`](https://rdrr.io/r/base/sum.html): calculates the sum
-   [`min()`](https://rdrr.io/r/base/Extremes.html): calculates the minimum
-   [`max()`](https://rdrr.io/r/base/Extremes.html): calculates the maximum
-   [`n_distinct()`](https://dplyr.tidyverse.org/reference/n_distinct.html): calculates the number of distinct or unique occurences

You can always combine functions or write your own functions to use within [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html) as well. For example, let's say you wanted the standard error of the mean, but there isn't a function built into tidyverse or base R that does that. You can still get your standard error but using a combination of other functions!

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>penguins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='nv'>species</span>, <span class='nv'>body_mass_g</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='c'># dropping observations with missing values</span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span>mean_body_mass <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>body_mass_g</span><span class='o'>)</span>, <span class='c'># mean body mass</span></span>
<span>            n_observations <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/context.html'>n</a></span><span class='o'>(</span><span class='o'>)</span>, <span class='c'># how many observations are there</span></span>
<span>            std_error_body_mass <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/stats/sd.html'>sd</a></span><span class='o'>(</span><span class='nv'>body_mass_g</span><span class='o'>)</span><span class='o'>/</span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/MathFun.html'>sqrt</a></span><span class='o'>(</span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/context.html'>n</a></span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='c'># sd/sqrt(n)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 4</span></span></span>
<span><span class='c'>#&gt;   species   mean_body_mass n_observations std_error_body_mass</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>          <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>               <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie             <span style='text-decoration: underline;'>3</span>701.            151                37.3</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Chinstrap          <span style='text-decoration: underline;'>3</span>733.             68                46.6</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> Gentoo             <span style='text-decoration: underline;'>5</span>076.            123                45.5</span></span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## Breakout Exercises 1

Back to the `flights` tibble for each of the following exercises.

### Exercise 1.1

<div class="alert puzzle">

<div>

Determine the mean, standard deviation, min, and max departure delay for each airport of origin. Also determine how many observations you have for each airport of origin.

<details>
<summary>
Hints (click here)
</summary>

<br>

Group the tibble by `origin`. Summarize for each summary you want to calculate. Make sure you exclude missing data.

</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>origin</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='nv'>dep_delay</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span>mean_dep_delay <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>dep_delay</span><span class='o'>)</span>,</span>
<span>            sd_dep_delay <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/stats/sd.html'>sd</a></span><span class='o'>(</span><span class='nv'>dep_delay</span><span class='o'>)</span>,</span>
<span>            min_dep_delay <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='nv'>dep_delay</span><span class='o'>)</span>,</span>
<span>            max_dep_delay <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='o'>(</span><span class='nv'>dep_delay</span><span class='o'>)</span>,</span>
<span>            n_dep_delay <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/context.html'>n</a></span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 6</span></span></span>
<span><span class='c'>#&gt;   origin mean_dep_delay sd_dep_delay min_dep_delay max_dep_delay n_dep_delay</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>           <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>        <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> EWR              15.1         41.3           -<span style='color: #BB0000;'>25</span>          <span style='text-decoration: underline;'>1</span>126      <span style='text-decoration: underline;'>117</span>596</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> JFK              12.1         39.0           -<span style='color: #BB0000;'>43</span>          <span style='text-decoration: underline;'>1</span>301      <span style='text-decoration: underline;'>109</span>416</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> LGA              10.3         40.0           -<span style='color: #BB0000;'>33</span>           911      <span style='text-decoration: underline;'>101</span>509</span></span></code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

### Exercise 1.2

<div class="alert puzzle">

<div>

How many distinct destinations are there to fly from for each EWR, JFK, and LGA?

<details>
<summary>
Hints (click here)
</summary>

<br>

Think about what you want to [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html) and what of the new functions we talked about today you could use in [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html).

</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>origin</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span>n_distinct_dest <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/n_distinct.html'>n_distinct</a></span><span class='o'>(</span><span class='nv'>dest</span><span class='o'>)</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 2</span></span></span>
<span><span class='c'>#&gt;   origin n_distinct_dest</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> EWR                 86</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> JFK                 70</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> LGA                 68</span></span></code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

## Using `slice_()`

Using [`slice_()`](https://dplyr.tidyverse.org/reference/slice.html) you can subset rows based on their position.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>penguins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='nv'>species</span>, <span class='nv'>body_mass_g</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='c'># dropping observations with missing values</span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span>mean_body_mass <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>body_mass_g</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/slice.html'>slice_min</a></span><span class='o'>(</span><span class='nv'>mean_body_mass</span>, n <span class='o'>=</span> <span class='m'>1</span><span class='o'>)</span> <span class='c'># min based on mean_body_mass, just give me 1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1 × 2</span></span></span>
<span><span class='c'>#&gt;   species mean_body_mass</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie           <span style='text-decoration: underline;'>3</span>701.</span></span></code></pre>

</div>

-   [`slice()`](https://dplyr.tidyverse.org/reference/slice.html) allows you to pick rows by the position (i.e., indexing, e.g., `slice(4)` will give you the 4th row of that df)
-   [`slice_head()`](https://dplyr.tidyverse.org/reference/slice.html) and [`slice_tail()`](https://dplyr.tidyverse.org/reference/slice.html) select the first or last rows.
-   [`slice_sample()`](https://dplyr.tidyverse.org/reference/slice.html) randomly selects rows.
-   [`slice_min()`](https://dplyr.tidyverse.org/reference/slice.html) and [`slice_max()`](https://dplyr.tidyverse.org/reference/slice.html) select rows with highest or lowest values of a variable.

You can use [`slice_()`](https://dplyr.tidyverse.org/reference/se-deprecated.html) functions on dataframes themselves (not just on summarized data).

For example:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>penguins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='nv'>body_mass_g</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='c'># dropping observations with missing values</span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/slice.html'>slice_max</a></span><span class='o'>(</span><span class='nv'>body_mass_g</span>, n <span class='o'>=</span> <span class='m'>10</span><span class='o'>)</span> <span class='c'># the 10 heaviest penguins</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 11 × 8</span></span></span>
<span><span class='c'>#&gt;    species island bill_length_mm bill_depth_mm flipper_len…¹ body_…² sex    year</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>           <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> Gentoo  Biscoe           49.2          15.2           221    <span style='text-decoration: underline;'>6</span>300 male   <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> Gentoo  Biscoe           59.6          17             230    <span style='text-decoration: underline;'>6</span>050 male   <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> Gentoo  Biscoe           51.1          16.3           220    <span style='text-decoration: underline;'>6</span>000 male   <span style='text-decoration: underline;'>2</span>008</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> Gentoo  Biscoe           48.8          16.2           222    <span style='text-decoration: underline;'>6</span>000 male   <span style='text-decoration: underline;'>2</span>009</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> Gentoo  Biscoe           45.2          16.4           223    <span style='text-decoration: underline;'>5</span>950 male   <span style='text-decoration: underline;'>2</span>008</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> Gentoo  Biscoe           49.8          15.9           229    <span style='text-decoration: underline;'>5</span>950 male   <span style='text-decoration: underline;'>2</span>009</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> Gentoo  Biscoe           48.4          14.6           213    <span style='text-decoration: underline;'>5</span>850 male   <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> Gentoo  Biscoe           49.3          15.7           217    <span style='text-decoration: underline;'>5</span>850 male   <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> Gentoo  Biscoe           55.1          16             230    <span style='text-decoration: underline;'>5</span>850 male   <span style='text-decoration: underline;'>2</span>009</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> Gentoo  Biscoe           49.5          16.2           229    <span style='text-decoration: underline;'>5</span>800 male   <span style='text-decoration: underline;'>2</span>008</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>11</span> Gentoo  Biscoe           48.6          16             230    <span style='text-decoration: underline;'>5</span>800 male   <span style='text-decoration: underline;'>2</span>008</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with abbreviated variable names ¹​flipper_length_mm, ²​body_mass_g</span></span></span></code></pre>

</div>

Note, we actually got 11, that is because in 10th place there is a tie. Ties are kept by default, but can be turned off by setting `with_ties = FALSE`.

You can also set the proportion of results to return using `prop =`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>penguins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='nv'>body_mass_g</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='c'># dropping observations with missing values</span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/slice.html'>slice_max</a></span><span class='o'>(</span><span class='nv'>body_mass_g</span>, prop <span class='o'>=</span> <span class='m'>0.1</span><span class='o'>)</span> <span class='c'># the top 10% heaviest penguins</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 34 × 8</span></span></span>
<span><span class='c'>#&gt;    species island bill_length_mm bill_depth_mm flipper_len…¹ body_…² sex    year</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>           <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> Gentoo  Biscoe           49.2          15.2           221    <span style='text-decoration: underline;'>6</span>300 male   <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> Gentoo  Biscoe           59.6          17             230    <span style='text-decoration: underline;'>6</span>050 male   <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> Gentoo  Biscoe           51.1          16.3           220    <span style='text-decoration: underline;'>6</span>000 male   <span style='text-decoration: underline;'>2</span>008</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> Gentoo  Biscoe           48.8          16.2           222    <span style='text-decoration: underline;'>6</span>000 male   <span style='text-decoration: underline;'>2</span>009</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> Gentoo  Biscoe           45.2          16.4           223    <span style='text-decoration: underline;'>5</span>950 male   <span style='text-decoration: underline;'>2</span>008</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> Gentoo  Biscoe           49.8          15.9           229    <span style='text-decoration: underline;'>5</span>950 male   <span style='text-decoration: underline;'>2</span>009</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> Gentoo  Biscoe           48.4          14.6           213    <span style='text-decoration: underline;'>5</span>850 male   <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> Gentoo  Biscoe           49.3          15.7           217    <span style='text-decoration: underline;'>5</span>850 male   <span style='text-decoration: underline;'>2</span>007</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> Gentoo  Biscoe           55.1          16             230    <span style='text-decoration: underline;'>5</span>850 male   <span style='text-decoration: underline;'>2</span>009</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> Gentoo  Biscoe           49.5          16.2           229    <span style='text-decoration: underline;'>5</span>800 male   <span style='text-decoration: underline;'>2</span>008</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 24 more rows, and abbreviated variable names ¹​flipper_length_mm,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   ²​body_mass_g</span></span></span></code></pre>

</div>

If data are grouped, the operation will be performed group wise, like we see below.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>penguins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='nv'>body_mass_g</span>, <span class='nv'>species</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='c'># dropping observations with missing values</span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/slice.html'>slice_min</a></span><span class='o'>(</span><span class='nv'>body_mass_g</span>, n <span class='o'>=</span> <span class='m'>1</span><span class='o'>)</span> </span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 4 × 8</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># Groups:   species [3]</span></span></span>
<span><span class='c'>#&gt;   species   island bill_length_mm bill_depth_mm flipper_le…¹ body_…² sex    year</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>           <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>        <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie    Biscoe           36.5          16.6          181    <span style='text-decoration: underline;'>2</span>850 fema…  <span style='text-decoration: underline;'>2</span>008</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Adelie    Biscoe           36.4          17.1          184    <span style='text-decoration: underline;'>2</span>850 fema…  <span style='text-decoration: underline;'>2</span>008</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> Chinstrap Dream            46.9          16.6          192    <span style='text-decoration: underline;'>2</span>700 fema…  <span style='text-decoration: underline;'>2</span>008</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> Gentoo    Biscoe           42.7          13.7          208    <span style='text-decoration: underline;'>3</span>950 fema…  <span style='text-decoration: underline;'>2</span>008</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with abbreviated variable names ¹​flipper_length_mm, ²​body_mass_g</span></span></span></code></pre>

</div>

We get the minimum `body_mass_g` for each `species`, and in this case we get 2 for Adelie penguins because there is a tie.

<br>

------------------------------------------------------------------------

## Using `summarize()` with `across()`

There are also ways that you can combine [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html) to function [`across()`](https://dplyr.tidyverse.org/reference/across.html) your different variables. The function [`where()`](https://tidyselect.r-lib.org/reference/where.html) allows you to pick variables where the function is `TRUE`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>penguins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/across.html'>across</a></span><span class='o'>(</span><span class='nf'>where</span><span class='o'>(</span><span class='nv'>is.numeric</span><span class='o'>)</span>, <span class='nv'>mean</span><span class='o'>)</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 6</span></span></span>
<span><span class='c'>#&gt;   species   bill_length_mm bill_depth_mm flipper_length_mm body_mass_g  year</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>             <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie              38.8          18.3              190.       <span style='text-decoration: underline;'>3</span>706. <span style='text-decoration: underline;'>2</span>008.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Chinstrap           48.8          18.4              196.       <span style='text-decoration: underline;'>3</span>733. <span style='text-decoration: underline;'>2</span>008.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> Gentoo              47.6          15.0              217.       <span style='text-decoration: underline;'>5</span>092. <span style='text-decoration: underline;'>2</span>008.</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># from column bill_length_mm to column flipper_length_mm</span></span>
<span><span class='nv'>penguins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/across.html'>across</a></span><span class='o'>(</span><span class='nv'>bill_length_mm</span><span class='o'>:</span><span class='nv'>flipper_length_mm</span>, <span class='nv'>mean</span><span class='o'>)</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 4</span></span></span>
<span><span class='c'>#&gt;   species   bill_length_mm bill_depth_mm flipper_length_mm</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>             <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie              38.8          18.3              190.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Chinstrap           48.8          18.4              196.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> Gentoo              47.6          15.0              217.</span></span><span></span>
<span><span class='c'># using the helper contains()</span></span>
<span><span class='nv'>penguins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/across.html'>across</a></span><span class='o'>(</span><span class='nf'><a href='https://tidyselect.r-lib.org/reference/starts_with.html'>contains</a></span><span class='o'>(</span><span class='s'>"mm"</span><span class='o'>)</span>, <span class='nv'>mean</span><span class='o'>)</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 4</span></span></span>
<span><span class='c'>#&gt;   species   bill_length_mm bill_depth_mm flipper_length_mm</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>             <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie              38.8          18.3              190.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Chinstrap           48.8          18.4              196.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> Gentoo              47.6          15.0              217.</span></span></code></pre>

</div>

All of these [helper functions](https://tidyselect.r-lib.org/reference/language.html) can be used outside of [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html) too.

<br>

------------------------------------------------------------------------

## Breakout Exercises 2

Let's practice using [`slice()`](https://dplyr.tidyverse.org/reference/slice.html) and [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html) with [`across()`](https://dplyr.tidyverse.org/reference/across.html), still using the `flights` data.

### Exercise 2.1

<div class="alert puzzle">

<div>

What is the tail number (`tailnum`) for the plane that has, on average, the least arrival delay?? What about the most arrival delay? How many flights did this plane take in this dataset? How would your answer change if you required that a plane take at least 50 flights?

<details>
<summary>
Hints (click here)
</summary>

<br>

Group the tibble by the `tailnum` variable, and summarize to get mean `arr_delay` and also [`n()`](https://dplyr.tidyverse.org/reference/context.html). Then pick the right [`filter()`](https://dplyr.tidyverse.org/reference/filter.html) parameters if necessary, and the appropriate [`slice_()`](https://dplyr.tidyverse.org/reference/se-deprecated.html) function.

</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

Least delayed flights

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># any number of flights</span></span>
<span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>tailnum</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span>mean_arr_delay <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>arr_delay</span><span class='o'>)</span>,</span>
<span>            n_flights <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/context.html'>n</a></span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/slice.html'>slice_min</a></span><span class='o'>(</span><span class='nv'>mean_arr_delay</span>, n <span class='o'>=</span> <span class='m'>1</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1 × 3</span></span></span>
<span><span class='c'>#&gt;   tailnum mean_arr_delay n_flights</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> N560AS             -<span style='color: #BB0000;'>53</span>         1</span></span><span></span>
<span><span class='c'># at least 50 flights</span></span>
<span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>tailnum</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span>mean_arr_delay <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>arr_delay</span><span class='o'>)</span>,</span>
<span>            n_flights <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/context.html'>n</a></span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>n_flights</span> <span class='o'>&gt;=</span> <span class='m'>50</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/slice.html'>slice_min</a></span><span class='o'>(</span><span class='nv'>mean_arr_delay</span>, n <span class='o'>=</span> <span class='m'>1</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1 × 3</span></span></span>
<span><span class='c'>#&gt;   tailnum mean_arr_delay n_flights</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> N548UW           -<span style='color: #BB0000;'>13.0</span>        52</span></span></code></pre>

</div>

Most delayed flights

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># any number of flights</span></span>
<span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>tailnum</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span>mean_arr_delay <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>arr_delay</span><span class='o'>)</span>,</span>
<span>            n_flights <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/context.html'>n</a></span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/slice.html'>slice_max</a></span><span class='o'>(</span><span class='nv'>mean_arr_delay</span>, n <span class='o'>=</span> <span class='m'>1</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1 × 3</span></span></span>
<span><span class='c'>#&gt;   tailnum mean_arr_delay n_flights</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> N844MH             320         1</span></span><span></span>
<span><span class='c'># at least 50 flights</span></span>
<span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>tailnum</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span>mean_arr_delay <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>arr_delay</span><span class='o'>)</span>,</span>
<span>            n_flights <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/context.html'>n</a></span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>n_flights</span> <span class='o'>&gt;=</span> <span class='m'>50</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/slice.html'>slice_max</a></span><span class='o'>(</span><span class='nv'>mean_arr_delay</span>, n <span class='o'>=</span> <span class='m'>1</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1 × 3</span></span></span>
<span><span class='c'>#&gt;   tailnum mean_arr_delay n_flights</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> N8698A            27.5        57</span></span></code></pre>

</div>

</details>

</div>

</div>

<br>

------------------------------------------------------------------------

### Exercise 2.2

<div class="alert puzzle">

<div>

Calculate the median for `air_time`, `arr_delay` and `dep_delay` by `origin`. Try to not do each manually.

<details>
<summary>
Hints (click here)
</summary>

<br>

Group the tibble by the `origin` variable, and combine [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html) and [`across()`](https://dplyr.tidyverse.org/reference/across.html) to get the median for each variable. Try listing them together using [`c()`](https://rdrr.io/r/base/c.html).

</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='nv'>air_time</span>, <span class='nv'>arr_delay</span>, <span class='nv'>dep_delay</span>, <span class='nv'>origin</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>origin</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/across.html'>across</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='nv'>air_time</span>, <span class='nv'>arr_delay</span>, <span class='nv'>dep_delay</span><span class='o'>)</span>, <span class='nv'>median</span>, </span>
<span>                   .names <span class='o'>=</span> <span class='s'>"&#123;col&#125;_median"</span><span class='o'>)</span><span class='o'>)</span> <span class='c'># extra fun thing to rename columns</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 4</span></span></span>
<span><span class='c'>#&gt;   origin air_time_median arr_delay_median dep_delay_median</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> EWR                130               -<span style='color: #BB0000;'>4</span>               -<span style='color: #BB0000;'>1</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> JFK                149               -<span style='color: #BB0000;'>6</span>               -<span style='color: #BB0000;'>1</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> LGA                115               -<span style='color: #BB0000;'>5</span>               -<span style='color: #BB0000;'>3</span></span></span></code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

### Exercise 2.3

<div class="alert puzzle">

<div>

Which destinations have the longest maximum arrival delay? Which destinations have the shortest? Pull data for the top 10 for both the longest and shortest maximum arrival delay. Keep track of how many flights there are to each location in case that might be useful information.

<details>
<summary>
Hints (click here)
</summary>

<br>

Group the tibble by the `dest` variable, and summarize to get max `arr_delay` and also [`n()`](https://dplyr.tidyverse.org/reference/context.html). Then pick the right [`slice_()`](https://dplyr.tidyverse.org/reference/se-deprecated.html) function.

</details>
<details>
<summary>
Solution (click here)
</summary>
Least delayed

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='nv'>dest</span>, <span class='nv'>arr_delay</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>dest</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span>max_arr_delay <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='o'>(</span><span class='nv'>arr_delay</span><span class='o'>)</span>,</span>
<span>            n_flights <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/context.html'>n</a></span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/slice.html'>slice_min</a></span><span class='o'>(</span><span class='nv'>max_arr_delay</span>, n <span class='o'>=</span> <span class='m'>10</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 3</span></span></span>
<span><span class='c'>#&gt;    dest  max_arr_delay n_flights</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> LEX             -<span style='color: #BB0000;'>22</span>         1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> PSP              17        18</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> ANC              39         8</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> HDN              43        14</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> EYW              45        17</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> SBN              53        10</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> MTJ             101        14</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> ILM             143       107</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> ABQ             153       254</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> BZN             154        35</span></span></code></pre>

</div>

Most delayed

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>flights</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='nv'>dest</span>, <span class='nv'>arr_delay</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>dest</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span>max_arr_delay <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='o'>(</span><span class='nv'>arr_delay</span><span class='o'>)</span>,</span>
<span>            n_flights <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/context.html'>n</a></span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/slice.html'>slice_max</a></span><span class='o'>(</span><span class='nv'>max_arr_delay</span>, n <span class='o'>=</span> <span class='m'>10</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 3</span></span></span>
<span><span class='c'>#&gt;    dest  max_arr_delay n_flights</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> HNL            <span style='text-decoration: underline;'>1</span>272       701</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> CMH            <span style='text-decoration: underline;'>1</span>127      <span style='text-decoration: underline;'>3</span>326</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> ORD            <span style='text-decoration: underline;'>1</span>109     <span style='text-decoration: underline;'>16</span>566</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> SFO            <span style='text-decoration: underline;'>1</span>007     <span style='text-decoration: underline;'>13</span>173</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> CVG             989      <span style='text-decoration: underline;'>3</span>725</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> TPA             931      <span style='text-decoration: underline;'>7</span>390</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> MSP             915      <span style='text-decoration: underline;'>6</span>929</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> ATL             895     <span style='text-decoration: underline;'>16</span>837</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> MIA             878     <span style='text-decoration: underline;'>11</span>593</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> LAS             852      <span style='text-decoration: underline;'>5</span>952</span></span></code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

