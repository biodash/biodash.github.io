---
title: "S03E04: ANOVA 2"
subtitle: "Testing assumptions, non-parametric ANOVA, utilizing the R output, and 🐧"
summary: "During this second session of Code Club on ANOVA, we will learn to test whether our data meetings assumptions needed for ANOVA, run non-parametric ANOVA tests and use the output for creating plots with our statistical findings."  
authors: [jessica-cooperstone]
date: "2022-02-03"
output: hugodown::md_document
toc: true

image: 
  caption: "Artwork by @allison_horst"
  focal_point: ""
  preview_only: false
rmd_hash: 3bbd7d41454b9703

---

------------------------------------------------------------------------

## Prep homework

#### Basic computer setup

-   If you didn't already do this, please follow the [Code Club Computer Setup](/codeclub-setup/04_ggplot2/) instructions, which also has pointers for if you're new to R or RStudio.

-   If you're able to do so, please open RStudio a bit before Code Club starts -- and in case you run into issues, please join the Zoom call early and we'll help you troubleshoot.

#### New to ggplot?

This isn't a ggplot specific session, though we will be using it a bit. Check out the past Code Club sessions covering `ggplot2`:

-   [S01E04](/codeclub/04_ggplot2/): intro to ggplot2
-   [S01E05](/codeclub/05_ggplot-round-2/): intro to ggplot2 round 2
-   [S01E10](/codeclub/10_faceting-animating/): faceting and animating
-   [S02E06](/codeclub/s02e06_ggplot2/): another intro to ggplot2
-   [S02E07](/codeclub/s02e07_ggplot2_part2/): a second intro to ggplot2 round 2
-   [S02E08](/codeclub/s02e08_multiple_plots/): combining plots using faceting
-   [S02E09](/codeclub/s02e09_multiple_plots_part2/): combining plots using faceting and patchwork
-   [S02E10](/codeclub/s02e10_ggpubr/): adding statistics to plots
-   [S02E11](/codeclub/s02e12_plotly/): making interactive plots with plotly

If you've never used `ggplot2` before (or even if you have), you may find [this cheat sheet](https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf) useful.

#### Adding statistics to plots

We had a previous session [S02E10](/codeclub/s02e10_ggpubr/) developed by Daniel Quiroz that covers the package `ggpubr` and adding statistics to ggplots.

#### We already did t-tests and ANOVA part 1

Mike Sovic covered in code club [S03E01](/codeclub/s03e01_ttests/) how to run t-tests in R. I covered ANOVA two weeks ago [S03E02](/codeclub/s03e02_anova/) and we will be building off that session today.

<br>

#### Getting an R Markdown

<details>
<summary>
Click here to get an Rmd (optional)
</summary>

#### RMarkdown for today

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># directory </span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>"S03E04"</span><span class='o'>)</span>

<span class='c'># directory for our RMarkdown</span>
<span class='c'># ("recursive" to create two levels at once.)</span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>"S03E04/Rmd/"</span><span class='o'>)</span>

<span class='c'># save the url location for today's script</span>
<span class='nv'>todays_Rmd</span> <span class='o'>&lt;-</span> 
  <span class='s'>"https://raw.githubusercontent.com/biodash/biodash.github.io/master/content/codeclub/S03E04_anova2/anova2.Rmd"</span>

<span class='c'># indicate the name of the new Rmd</span>
<span class='nv'>S03E04_Rmd</span> <span class='o'>&lt;-</span> <span class='s'>"S03E04/Rmd/S03E04_anova2.Rmd"</span>

<span class='c'># go get that file! </span>
<span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>todays_Rmd</span>,
              destfile <span class='o'>=</span> <span class='nv'>S03E04_Rmd</span><span class='o'>)</span></code></pre>

</div>

</details>
<br>
<div>

<br>

------------------------------------------------------------------------

## Introduction

We have gone through a first pass of running ANOVAs in [Code Club a couple weeks ago](/codeclub/content/S03E02_anova/) but didn't have the time to go through all of the content. We are going to re-visit that material today.

Often people are first introduced to the R programming language when they are wanting to conduct statistical analyses. My experience is that beginners are often able to conduct the analysis they want, and print their results to the console. But, the process of locating and then using the output of their analysis tends to be more complex.

Today, we are going to go over how to:

-   test if our data is suitable for running ANOVA
-   run an ANOVA (parametric) or Kruskal Wallis (non-parametric) test
-   run posthoc tests to understand group differences
-   use the ANOVA data output object as a means to understand R data structure.

If you are looking for a good statistics class, I would recommend Dr. Kristin Mercer's [HCS 8887 Experimental Design](https://hcs.osu.edu/courses/hcs-8887).

<br>

------------------------------------------------------------------------

#### Load packages, get data

We are going to start with our favorite dataset `palmerpenguins` to provide the input data for our analysis.

If you don't have any of the packages below, use [`install.packages()`](https://rdrr.io/r/utils/install.packages.html) to download them.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/'>palmerpenguins</a></span><span class='o'>)</span> <span class='c'># for data</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://rpkgs.datanovia.com/rstatix/'>rstatix</a></span><span class='o'>)</span> <span class='c'># for testing assumptions and running tests</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'>agricolae</span><span class='o'>)</span> <span class='c'># for post-hoc comparison of groups</span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## 1 - Getting acclimated

Some words on syntax: the dataset `penguins` is an object within the `palmerpenguins` package. If you call the object `penguins` (after executing [`library(palmerpenguins)`](https://allisonhorst.github.io/palmerpenguins/)), you will be able to see what is contained within that dataframe.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 344 × 8</span></span>
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
<span class='c'>#&gt; <span style='color: #555555;'># … with 334 more rows, and 2 more variables: sex &lt;fct&gt;, year &lt;int&gt;</span></span></code></pre>

</div>

However, `penguins` will not be in your environment tab because it is not in your local environment. You can use it without it being in your local environment, but if you are bothered by this, you can save a copy in your local environment such it shows up in that top right pane.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span></code></pre>

</div>

What is within this dataset?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>)</span>
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

<p align="center">
<img src=palmerpenguins_hex.png width="30%" alt="a cute hexagon image of three penguins as a part of the palmer penguins package">
</p>

Illustration by [Allison Horst](https://allisonhorst.github.io/palmerpenguins/articles/art.html)

<br>

------------------------------------------------------------------------

## 2. Testing assumptions

I'd be remiss if I didn't show you how to test that you aren't violating any of the assumptions needed to conduct an ANOVA. We went over this a little bit back in the session put together by Daniel Quiroz on [ggpubr](https://biodash.github.io/codeclub/s02e10_ggpubr/) and adding statistical results to ggplots.

Briefly, in order to use parametric procedures (like ANOVA), we need to be sure our data meets the assumptions for 1) normality and 2) constant variance. This can be done in a few different ways.

<p align="center">
<img src=featured.png width="70%" alt="a cartoon of two distributions, one is normal (bell shaped curve) and one is not (dimodal, two peaks, with the one on the right being higher">
</p>

Illustration by [Allison Horst](https://allisonhorst.github.io/palmerpenguins/articles/art.html)

#### Shapiro-Wilk test for normality

We are going to use the Shapiro-Wilk test (using the function [`shapiro_test()`](https://rpkgs.datanovia.com/rstatix/reference/shapiro_test.html) which is in the package `rstatix` to determine normality, but will do it groupwise. This function is a pipe-friendly wrapper for the function [`shapiro.test()`](https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/shapiro.test), which just means you can use it with pipes.

Our question is:

-   Does `bill_length_mm` vary by `species` in female penguins?

<figure>
<p align="center">
<img src=culmen_depth.png width="50%" alt="a cute image showing the bill length as the horizontal (sticking out from the face) length of the penguin bill, and the bill depth as the vertical (perpendicular to the ground) bill depth">
<figcaption>
Illustration by <a href="https://allisonhorst.github.io/palmerpenguins/articles/art.html">Allison Horst</a>
</figcaption>
</p>
</figure>
Caputuring some descriptive statistics

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>sex</span> <span class='o'>==</span> <span class='s'>"female"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>count</span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 2</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># Groups:   species [3]</span></span>
<span class='c'>#&gt;   species       n</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie       73</span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> Chinstrap    34</span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> Gentoo       58</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># testing for all female penguins together</span>
<span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>sex</span> <span class='o'>==</span> <span class='s'>"female"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>rstatix</span><span class='nf'>::</span><span class='nf'><a href='https://rpkgs.datanovia.com/rstatix/reference/shapiro_test.html'>shapiro_test</a></span><span class='o'>(</span><span class='nv'>bill_length_mm</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1 × 3</span></span>
<span class='c'>#&gt;   variable       statistic         p</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> bill_length_mm     0.950 0.000<span style='text-decoration: underline;'>014</span>0</span>

<span class='c'># testing by species</span>
<span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>sex</span> <span class='o'>==</span> <span class='s'>"female"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>rstatix</span><span class='nf'>::</span><span class='nf'><a href='https://rpkgs.datanovia.com/rstatix/reference/shapiro_test.html'>shapiro_test</a></span><span class='o'>(</span><span class='nv'>bill_length_mm</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 4</span></span>
<span class='c'>#&gt;   species   variable       statistic       p</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie    bill_length_mm     0.991 0.895  </span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> Chinstrap bill_length_mm     0.883 0.001<span style='text-decoration: underline;'>70</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> Gentoo    bill_length_mm     0.989 0.895</span></code></pre>

</div>

Note that if we test all the penguins together, it looks like we do not have normal data. If we test by species, we see that two speces have normal data distribution and one (Chinstrap) does not.

Can we visualize normality in another way?

Let's quickly make a new dataframe that includes only the female penguins, and drop missing values, so that we don't have to keep including the [`filter()`](https://dplyr.tidyverse.org/reference/filter.html) and [`drop_na()`](https://tidyr.tidyverse.org/reference/drop_na.html) statements.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>female_penguins</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>sex</span> <span class='o'>==</span> <span class='s'>"female"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span></code></pre>

</div>

Visualizing with a histogram by `species`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>female_penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_histogram</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_grid</span><span class='o'>(</span>cols <span class='o'>=</span> <span class='nf'>vars</span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span>
<span class='c'>#&gt; `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.</span>
</code></pre>
<img src="figs/unnamed-chunk-9-1.png" width="700px" style="display: block; margin: auto;" />

</div>

We can see here too that the Chinstrap penguins look maybe not that normal (and we saw earlier they have the fewest numbers of observations). This is consistent with the results from the Shapiro test.

##### Log transforming

Would our data look more normal if we log transformed it? Let's see. We can use the function [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) to create a new column called `bill_length_mm_log2` which will have the data from `bill_length_mm` but log transformed using base 2 (using the base R function [`log2()`](https://www.rdocumentation.org/packages/SparkR/versions/2.1.2/topics/log2)).

<p align="center">
<img src=dplyr_mutate.png width="50%" alt="Cartoon of cute fuzzy monsters dressed up as different X-men characters, working together to add a new column to an existing data frame. Stylized title text reads “dplyr::mutate - add columns, keep existing.">
</p>

Illustration by [Allison Horst](https://allisonhorst.github.io/palmerpenguins/articles/art.html)

The syntax of [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) is like this:

-   `mutate(new_variable = function(existing_variable))`

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>log_female_penguins</span> <span class='o'>&lt;-</span> <span class='nv'>female_penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>bill_length_mm_log2 <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/Log.html'>log2</a></span><span class='o'>(</span><span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span></code></pre>

</div>

Testing using [`shapiro_test()`](https://rpkgs.datanovia.com/rstatix/reference/shapiro_test.html) again.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>log_female_penguins</span> <span class='o'>%&gt;%</span> 
  <span class='c'># don't need drop_na() because we already did that</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rpkgs.datanovia.com/rstatix/reference/shapiro_test.html'>shapiro_test</a></span><span class='o'>(</span><span class='nv'>bill_length_mm_log2</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 4</span></span>
<span class='c'>#&gt;   species   variable            statistic       p</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie    bill_length_mm_log2     0.991 0.868  </span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> Chinstrap bill_length_mm_log2     0.911 0.009<span style='text-decoration: underline;'>00</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> Gentoo    bill_length_mm_log2     0.988 0.841</span></code></pre>

</div>

Still not passing the test for normality. Let's still look at this visually.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>log_female_penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm_log2</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_histogram</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_grid</span><span class='o'>(</span>cols <span class='o'>=</span> <span class='nf'>vars</span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span>
<span class='c'>#&gt; `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.</span>
</code></pre>
<img src="figs/unnamed-chunk-12-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Doesn't look very different from the non-log2 transformed data. Ok, well we tried.

#### Equal variance

We can test for equal variance using Levene's test, [`levene_test()`](https://www.rdocumentation.org/packages/rstatix/versions/0.7.0/topics/levene_test) which is part of the `rstatix` package. Again, this is a pipe-friendly wrapper for the function [`levene.test()`](https://www.rdocumentation.org/packages/lawstat/versions/3.4/topics/levene.test).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>female_penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rpkgs.datanovia.com/rstatix/reference/levene_test.html'>levene_test</a></span><span class='o'>(</span><span class='nv'>bill_length_mm</span> <span class='o'>~</span> <span class='nv'>species</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1 × 4</span></span>
<span class='c'>#&gt;     df1   df2 statistic     p</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span>     2   162     0.819 0.442</span></code></pre>

</div>

Our data meets the assumption for equal variance, but not for normality, so we will need to be sure to select a test that does not have an assumption of normality.

<br>

------------------------------------------------------------------------

## 3. Kruskal Wallis test

The Kruskal Wallis test is the non-parametric version of a one-way ANOVA. This non-parametric test tests whether samples are coming from the same distribution, but uses ranks instead of means.

We want to see if there are any differences in bill length (`bill_length_mm`) in penguins by `species`. Since our data violates the assumptions of normality, we should do this using a test that does not require normality, and we can use the [Kruskal Wallis test](https://en.wikipedia.org/wiki/Kruskal%E2%80%93Wallis_one-way_analysis_of_variance). The Kruskal-Wallis test, can be run using the `rstatix` function [`kruskal_test()`](https://www.rdocumentation.org/packages/rstatix/versions/0.7.0/topics/kruskal_test).

First let's get some descriptive information about our data.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>female_penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>count</span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 2</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># Groups:   species [3]</span></span>
<span class='c'>#&gt;   species       n</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie       73</span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> Chinstrap    34</span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> Gentoo       58</span></code></pre>

</div>

If we want to learn more about the function [`kruskal_test()`](https://rpkgs.datanovia.com/rstatix/reference/kruskal_test.html) we can do so using the code below. The help documentation will show up in the bottom right quadrant of your RStudio.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='o'>?</span><span class='nf'><a href='https://rpkgs.datanovia.com/rstatix/reference/kruskal_test.html'>kruskal_test</a></span><span class='o'>(</span><span class='o'>)</span></code></pre>

</div>

We can run a Kruskal-Wallis test by indicating our model.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_length_kruskal</span> <span class='o'>&lt;-</span> <span class='nv'>female_penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rpkgs.datanovia.com/rstatix/reference/kruskal_test.html'>kruskal_test</a></span><span class='o'>(</span><span class='nv'>bill_length_mm</span> <span class='o'>~</span> <span class='nv'>species</span><span class='o'>)</span></code></pre>

</div>

The function [`kruskal_test()`](https://rpkgs.datanovia.com/rstatix/reference/kruskal_test.html) already puts the output of the function into a tidy format, so we can simply view it.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/View.html'>View</a></span><span class='o'>(</span><span class='nv'>bill_length_kruskal</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

| .y.            |   n | statistic |  df |   p | method         |
|:---------------|----:|----------:|----:|----:|:---------------|
| bill_length_mm | 165 |  121.6214 |   2 |   0 | Kruskal-Wallis |

</div>

We can also look at our data visually by plotting it, as below.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>female_penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>outlier.shape <span class='o'>=</span> <span class='kc'>NA</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_jitter</span><span class='o'>(</span>width <span class='o'>=</span> <span class='m'>0.3</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-19-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<br>

------------------------------------------------------------------------

## Breakout rooms 1

We want to know if there are any significant differences in `bill_depth_mm` by `species` in male penguins.

### Exercise 1

<div class="puzzle">

<div>

Test your assumptions for normality to determine what would be the appropriate test to do to assess means separation.

<details>
<summary>
Hints (click here)
</summary>
<br> Use the function [`shapiro_test()`](https://rpkgs.datanovia.com/rstatix/reference/shapiro_test.html) to test normality. If your data is non-normal, you can check to see if log transforming it makes it normal. <br>
</details>

<br>

<details>
<summary>
Solutions (click here)
</summary>
Shapiro-Wilk Test

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># create df with male penguins and no NAs</span>
<span class='nv'>male_penguins</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>sex</span> <span class='o'>==</span> <span class='s'>"male"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># run shapiro test</span>
<span class='nv'>male_penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>rstatix</span><span class='nf'>::</span><span class='nf'><a href='https://rpkgs.datanovia.com/rstatix/reference/shapiro_test.html'>shapiro_test</a></span><span class='o'>(</span><span class='nv'>bill_depth_mm</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 4</span></span>
<span class='c'>#&gt;   species   variable      statistic      p</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>             <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie    bill_depth_mm     0.964 0.033<span style='text-decoration: underline;'>5</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> Chinstrap bill_depth_mm     0.983 0.863 </span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> Gentoo    bill_depth_mm     0.980 0.401</span></code></pre>

</div>

Visualize

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>male_penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_depth_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_histogram</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_grid</span><span class='o'>(</span>cols <span class='o'>=</span> <span class='nf'>vars</span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span>
<span class='c'>#&gt; `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.</span>
</code></pre>
<img src="figs/unnamed-chunk-22-1.png" width="700px" style="display: block; margin: auto;" />

</div>

See if log-transforming your data would allow you to use parametric tests.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>log_male_penguins</span> <span class='o'>&lt;-</span> <span class='nv'>male_penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>bill_depth_mm_log2 <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/Log.html'>log2</a></span><span class='o'>(</span><span class='nv'>bill_depth_mm</span><span class='o'>)</span><span class='o'>)</span></code></pre>

</div>

Testing using [`shapiro_test()`](https://rpkgs.datanovia.com/rstatix/reference/shapiro_test.html) again.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>log_male_penguins</span> <span class='o'>%&gt;%</span> 
  <span class='c'># don't need drop_na() because we already did that</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rpkgs.datanovia.com/rstatix/reference/shapiro_test.html'>shapiro_test</a></span><span class='o'>(</span><span class='nv'>bill_depth_mm_log2</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 4</span></span>
<span class='c'>#&gt;   species   variable           statistic      p</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie    bill_depth_mm_log2     0.971 0.091<span style='text-decoration: underline;'>4</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> Chinstrap bill_depth_mm_log2     0.981 0.814 </span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> Gentoo    bill_depth_mm_log2     0.980 0.438</span></code></pre>

</div>

Ok! We could use log2 transformed data

Visualize.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>log_male_penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_depth_mm_log2</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_histogram</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_grid</span><span class='o'>(</span>cols <span class='o'>=</span> <span class='nf'>vars</span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span>
<span class='c'>#&gt; `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.</span>
</code></pre>
<img src="figs/unnamed-chunk-25-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### Exercise 2

<div class="puzzle">

<div>

Test your assumptions for equal variance to determine what would be the appropriate test to do to assess means separation.

<details>
<summary>
Hints (click here)
</summary>
<br> You can use the function [`levene_test()`](https://rpkgs.datanovia.com/rstatix/reference/levene_test.html) to test for equal variance. <br>
</details>

<br>

<details>
<summary>
Solutions (click here)
</summary>
Equal variance

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>male_penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rpkgs.datanovia.com/rstatix/reference/levene_test.html'>levene_test</a></span><span class='o'>(</span><span class='nv'>bill_depth_mm</span> <span class='o'>~</span> <span class='nv'>species</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1 × 4</span></span>
<span class='c'>#&gt;     df1   df2 statistic     p</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span>     2   165      2.30 0.103</span></code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### Exercise 3

<div class="puzzle">

<div>

Conduct your Kruskal-Wallis test or ANOVA to see if there is any overall significant effect of `species` on `bill_depth_mm` of male penguins.

<details>
<summary>
Hints (click here)
</summary>
<br> Review the information in section 3 of this post. You could also use the package `ggpubr`. <br>
</details>

<br>

<details>
<summary>
Solutions (click here)
</summary>
Kruskal-Wallis

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_depth_kruskal</span> <span class='o'>&lt;-</span> <span class='nv'>male_penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rpkgs.datanovia.com/rstatix/reference/kruskal_test.html'>kruskal_test</a></span><span class='o'>(</span><span class='nv'>bill_depth_mm</span> <span class='o'>~</span> <span class='nv'>species</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/View.html'>View</a></span><span class='o'>(</span><span class='nv'>bill_depth_kruskal</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

| .y.           |   n | statistic |  df |   p | method         |
|:--------------|----:|----------:|----:|----:|:---------------|
| bill_depth_mm | 168 |   116.152 |   2 |   0 | Kruskal-Wallis |

</div>

ANOVA - to use this you need to be using normal data (here, the log transformed data).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_depth_anova</span> <span class='o'>&lt;-</span> 
  <span class='nf'><a href='https://rdrr.io/r/stats/aov.html'>aov</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>log_male_penguins</span>,
      formula <span class='o'>=</span> <span class='nv'>bill_depth_mm_log2</span> <span class='o'>~</span> <span class='nv'>species</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/summary.html'>summary</a></span><span class='o'>(</span><span class='nv'>bill_depth_anova</span><span class='o'>)</span>
<span class='c'>#&gt;              Df Sum Sq Mean Sq F value Pr(&gt;F)    </span>
<span class='c'>#&gt; species       2 3.1221  1.5610   319.8 &lt;2e-16 ***</span>
<span class='c'>#&gt; Residuals   165 0.8053  0.0049                   </span>
<span class='c'>#&gt; ---</span>
<span class='c'>#&gt; Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1</span></code></pre>

</div>

</details>

<br>

</div>

</div>

<br>

------------------------------------------------------------------------

## 4. Posthoc group analysis

Now that we've seen that `species` are significant effectors of `bill_length_mm`, our next logical question might be, which species specifically are different from each other? We can determine this by conducting a post-hoc test. We will do our post-hoc analysis using Dunn's test (which is for specifically ranked data) and the function [`dunn_test()`](https://rdrr.io/cran/rstatix/man/dunn_test.html) which is a part of `rstatix`. In the example below, we are using the Benjamini Hochberg method of pvalue adjustment for multiple corrections.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>dunn_bill_length</span> <span class='o'>&lt;-</span> <span class='nv'>female_penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rpkgs.datanovia.com/rstatix/reference/dunn_test.html'>dunn_test</a></span><span class='o'>(</span><span class='nv'>bill_length_mm</span> <span class='o'>~</span> <span class='nv'>species</span>,
            p.adjust.method <span class='o'>=</span> <span class='s'>"BH"</span><span class='o'>)</span> <span class='c'># there are others too</span></code></pre>

</div>

Like we did with t-tests, you can also look at the resulting [`dunn_test()`](https://rpkgs.datanovia.com/rstatix/reference/dunn_test.html) object (here, `dunn_bill_length`) in your environment pane.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/View.html'>View</a></span><span class='o'>(</span><span class='nv'>dunn_bill_length</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

| .y.            | group1    | group2    |  n1 |  n2 |  statistic |         p |     p.adj | p.adj.signif |
|:---------------|:----------|:----------|----:|----:|-----------:|----------:|----------:|:-------------|
| bill_length_mm | Adelie    | Chinstrap |  73 |  34 |  8.8609532 | 0.0000000 | 0.0000000 | \*\*\*\*     |
| bill_length_mm | Adelie    | Gentoo    |  73 |  58 |  9.4096815 | 0.0000000 | 0.0000000 | \*\*\*\*     |
| bill_length_mm | Chinstrap | Gentoo    |  34 |  58 | -0.8549426 | 0.3925829 | 0.3925829 | ns           |

</div>

From this result, we can see that Adelie is significantly different than Chinstrap and Gentoo, but Chinstrap and Gentoo are not significantly different from each other.

The structure of this resulting object `dunn_bill_length` can be determined using the code below.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>dunn_bill_length</span><span class='o'>)</span>
<span class='c'>#&gt; rstatix_test [3 × 9] (S3: rstatix_test/dunn_test/tbl_df/tbl/data.frame)</span>
<span class='c'>#&gt;  $ .y.         : chr [1:3] "bill_length_mm" "bill_length_mm" "bill_length_mm"</span>
<span class='c'>#&gt;  $ group1      : chr [1:3] "Adelie" "Adelie" "Chinstrap"</span>
<span class='c'>#&gt;  $ group2      : chr [1:3] "Chinstrap" "Gentoo" "Gentoo"</span>
<span class='c'>#&gt;  $ n1          : Named int [1:3] 73 73 34</span>
<span class='c'>#&gt;   ..- attr(*, "names")= chr [1:3] "Adelie" "Adelie" "Chinstrap"</span>
<span class='c'>#&gt;  $ n2          : Named int [1:3] 34 58 58</span>
<span class='c'>#&gt;   ..- attr(*, "names")= chr [1:3] "Chinstrap" "Gentoo" "Gentoo"</span>
<span class='c'>#&gt;  $ statistic   : num [1:3] 8.861 9.41 -0.855</span>
<span class='c'>#&gt;  $ p           : num [1:3] 7.93e-19 4.98e-21 3.93e-01</span>
<span class='c'>#&gt;  $ p.adj       : num [1:3] 1.19e-18 1.49e-20 3.93e-01</span>
<span class='c'>#&gt;  $ p.adj.signif: chr [1:3] "****" "****" "ns"</span>
<span class='c'>#&gt;  - attr(*, "na.action")= 'omit' Named int 3</span>
<span class='c'>#&gt;   ..- attr(*, "names")= chr "3"</span>
<span class='c'>#&gt;  - attr(*, "args")=List of 5</span>
<span class='c'>#&gt;   ..$ data           : tibble [165 × 8] (S3: tbl_df/tbl/data.frame)</span>
<span class='c'>#&gt;   .. ..$ species          : Factor w/ 3 levels "Adelie","Chinstrap",..: 1 1 1 1 1 1 1 1 1 1 ...</span>
<span class='c'>#&gt;   .. ..$ island           : Factor w/ 3 levels "Biscoe","Dream",..: 3 3 3 3 3 3 3 3 1 1 ...</span>
<span class='c'>#&gt;   .. ..$ bill_length_mm   : num [1:165] 39.5 40.3 36.7 38.9 41.1 36.6 38.7 34.4 37.8 35.9 ...</span>
<span class='c'>#&gt;   .. ..$ bill_depth_mm    : num [1:165] 17.4 18 19.3 17.8 17.6 17.8 19 18.4 18.3 19.2 ...</span>
<span class='c'>#&gt;   .. ..$ flipper_length_mm: int [1:165] 186 195 193 181 182 185 195 184 174 189 ...</span>
<span class='c'>#&gt;   .. ..$ body_mass_g      : int [1:165] 3800 3250 3450 3625 3200 3700 3450 3325 3400 3800 ...</span>
<span class='c'>#&gt;   .. ..$ sex              : Factor w/ 2 levels "female","male": 1 1 1 1 1 1 1 1 1 1 ...</span>
<span class='c'>#&gt;   .. ..$ year             : int [1:165] 2007 2007 2007 2007 2007 2007 2007 2007 2007 2007 ...</span>
<span class='c'>#&gt;   ..$ formula        :Class 'formula'  language bill_length_mm ~ species</span>
<span class='c'>#&gt;   .. .. ..- attr(*, ".Environment")=&lt;environment: 0x561e79ddb100&gt; </span>
<span class='c'>#&gt;   ..$ p.adjust.method: chr "BH"</span>
<span class='c'>#&gt;   ..$ detailed       : logi FALSE</span>
<span class='c'>#&gt;   ..$ method         : chr "dunn_test"</span></code></pre>

</div>

This df does not have a 'groups' column, but if we want to plot in the same way, we can make a new object which we use for plotting. I'm going to show you here how to do this manually.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>dunn_for_plotting</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/data.frame.html'>data.frame</a></span><span class='o'>(</span>species <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"Adelie"</span>, <span class='s'>"Chinstrap"</span>, <span class='s'>"Gentoo"</span><span class='o'>)</span>,
                                groups <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"a"</span>, <span class='s'>"b"</span>, <span class='s'>"b"</span><span class='o'>)</span><span class='o'>)</span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## 5. Bringing it together in a plot

We already looked at a first-pass plot, but let's customize it now, and add our statistical info. Here is our base plot.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>female_penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>outlier.shape <span class='o'>=</span> <span class='kc'>NA</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_jitter</span><span class='o'>(</span>width <span class='o'>=</span> <span class='m'>0.3</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-37-1.png" width="700px" style="display: block; margin: auto;" />

</div>

First let's make the plot more aesthetically pleasing.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='o'>(</span><span class='nv'>bill_length_plot</span> <span class='o'>&lt;-</span> <span class='nv'>female_penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, color <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>outlier.shape <span class='o'>=</span> <span class='kc'>NA</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_jitter</span><span class='o'>(</span>width <span class='o'>=</span> <span class='m'>0.3</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_classic</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"none"</span><span class='o'>)</span> <span class='o'>+</span> <span class='c'># remove legend bc we don't need it</span>
  <span class='nf'>labs</span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Species"</span>,
       y <span class='o'>=</span> <span class='s'>"Bill Length, in mm"</span>,
       title <span class='o'>=</span> <span class='s'>"Penguin Culmen Bill Length Among Different Species"</span>,
       subtitle <span class='o'>=</span> <span class='s'>"Data collected from Palmer LTER, Antarctica"</span><span class='o'>)</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-38-1.png" width="700px" style="display: block; margin: auto;" />

</div>

We want to add the letters to this plot, so we can tell which groups of species by sex are significantly different. We are going to figure out what the maximum `bill_length_mm` for each species by sex is, so it will help us determine where to put our letter labels. Then, we cna add our labels to be higher than the largest data point.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_length_max</span> <span class='o'>&lt;-</span> <span class='nv'>female_penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>summarize</span><span class='o'>(</span>max_bill_length_mm <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='o'>(</span><span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span>

<span class='nv'>bill_length_max</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 2</span></span>
<span class='c'>#&gt;   species   max_bill_length_mm</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>                  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie                  42.2</span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> Chinstrap               58  </span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> Gentoo                  50.5</span></code></pre>

</div>

Let's add our `bill_length_max` back to the df with our post-hoc groups `dunn_for_plotting`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_for_plotting</span> <span class='o'>&lt;-</span> <span class='nf'>full_join</span><span class='o'>(</span><span class='nv'>dunn_for_plotting</span>, <span class='nv'>bill_length_max</span>,
                               by <span class='o'>=</span> <span class='s'>"species"</span><span class='o'>)</span>

<span class='nv'>bill_for_plotting</span>
<span class='c'>#&gt;     species groups max_bill_length_mm</span>
<span class='c'>#&gt; 1    Adelie      a               42.2</span>
<span class='c'>#&gt; 2 Chinstrap      b               58.0</span>
<span class='c'>#&gt; 3    Gentoo      b               50.5</span></code></pre>

</div>

Let's plot.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_length_plot</span> <span class='o'>+</span>
  <span class='nf'>geom_text</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>bill_for_plotting</span>,
            <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>,
                y <span class='o'>=</span> <span class='m'>3</span> <span class='o'>+</span> <span class='nv'>max_bill_length_mm</span>, 
                color <span class='o'>=</span> <span class='nv'>species</span>,
                label <span class='o'>=</span> <span class='nv'>groups</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>caption <span class='o'>=</span> <span class='s'>"Different letters indicate significant difference as determined by \na Kruskal-Wallis test with Dunn's post-hoc means separation"</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-41-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Also remember Daniel showed us how we can do [somthing similar](https://biodash.github.io/codeclub/s02e10_ggpubr/) using the package `ggpubr`.

<br>

------------------------------------------------------------------------

## Breakout rooms 2

### Exercise 4

<div class="puzzle">

<div>

Conduct a post-hoc analysis to understand which male penguin `species` have significantly different `bill_depth_mm`.

<details>
<summary>
Hints (click here)
</summary>
<br> Using the results from your assumption testing in Exercise 3, pick an appropriate post-hoc test to answer your question. <br>
</details>

<br>

<details>
<summary>
Solutions (click here)
</summary>
Dunn's test

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>dunn_bill_depth</span> <span class='o'>&lt;-</span> <span class='nv'>male_penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rpkgs.datanovia.com/rstatix/reference/dunn_test.html'>dunn_test</a></span><span class='o'>(</span><span class='nv'>bill_depth_mm</span> <span class='o'>~</span> <span class='nv'>species</span>,
            p.adjust.method <span class='o'>=</span> <span class='s'>"BH"</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/View.html'>View</a></span><span class='o'>(</span><span class='nv'>dunn_bill_depth</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

| .y.           | group1    | group2    |  n1 |  n2 |  statistic |        p |    p.adj | p.adj.signif |
|:--------------|:----------|:----------|----:|----:|-----------:|---------:|---------:|:-------------|
| bill_depth_mm | Adelie    | Chinstrap |  73 |  34 |  0.9039517 | 0.366021 | 0.366021 | ns           |
| bill_depth_mm | Adelie    | Gentoo    |  73 |  61 | -9.5885513 | 0.000000 | 0.000000 | \*\*\*\*     |
| bill_depth_mm | Chinstrap | Gentoo    |  34 |  61 | -8.6487581 | 0.000000 | 0.000000 | \*\*\*\*     |

</div>

Parametric post-hoc test

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bonferroni_bill_depth</span> <span class='o'>&lt;-</span> <span class='nf'>agricolae</span><span class='nf'>::</span><span class='nf'><a href='https://rdrr.io/pkg/agricolae/man/LSD.test.html'>LSD.test</a></span><span class='o'>(</span><span class='nv'>bill_depth_anova</span>, 
                                             trt <span class='o'>=</span> <span class='s'>"species"</span>, 
                                             p.adj <span class='o'>=</span> <span class='s'>"bonferroni"</span>,
                                             console <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Study: bill_depth_anova ~ "species"</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; LSD t Test for bill_depth_mm_log2 </span>
<span class='c'>#&gt; P value adjustment method: bonferroni </span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Mean Square Error:  0.004880851 </span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; species,  means and individual ( 95 %) CI</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;           bill_depth_mm_log2        std  r      LCL      UCL      Min      Max</span>
<span class='c'>#&gt; Adelie              4.251426 0.07632273 73 4.235282 4.267571 4.087463 4.426265</span>
<span class='c'>#&gt; Chinstrap           4.265907 0.05726112 34 4.242250 4.289564 4.129283 4.378512</span>
<span class='c'>#&gt; Gentoo              3.972772 0.06803521 61 3.955110 3.990433 3.817623 4.112700</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Alpha: 0.05 ; DF Error: 165</span>
<span class='c'>#&gt; Critical Value of t: 2.418634 </span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Groups according to probability of means differences and alpha level( 0.05 )</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Treatments with the same letter are not significantly different.</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;           bill_depth_mm_log2 groups</span>
<span class='c'>#&gt; Chinstrap           4.265907      a</span>
<span class='c'>#&gt; Adelie              4.251426      a</span>
<span class='c'>#&gt; Gentoo              3.972772      b</span></code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### Exercise 5

<div class="puzzle">

<div>

Bring it all together in a plot.

<details>
<summary>
Hints (click here)
</summary>
<br> Think about what you'd like to display and go back to section 5 for more help. <br>
</details>

<br>

<details>
<summary>
Solutions (click here)
</summary>
Using Kruskal-Wallis and Dunn's post-hoc test

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='o'>(</span><span class='nv'>bill_depth_plot_kruskal</span> <span class='o'>&lt;-</span> <span class='nv'>male_penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span>, color <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>outlier.shape <span class='o'>=</span> <span class='kc'>NA</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_jitter</span><span class='o'>(</span>width <span class='o'>=</span> <span class='m'>0.3</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_classic</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"none"</span><span class='o'>)</span> <span class='o'>+</span> <span class='c'># remove legend bc we don't need it</span>
  <span class='nf'>labs</span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Species"</span>,
       y <span class='o'>=</span> <span class='s'>"Bill Depth, in mm"</span>,
       title <span class='o'>=</span> <span class='s'>"Penguin Culmen Bill Depth Among Different Species"</span>,
       subtitle <span class='o'>=</span> <span class='s'>"Data collected from Palmer LTER, Antarctica"</span><span class='o'>)</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-46-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_depth_max</span> <span class='o'>&lt;-</span> <span class='nv'>male_penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>summarize</span><span class='o'>(</span>max_bill_depth_mm <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='o'>(</span><span class='nv'>bill_depth_mm</span><span class='o'>)</span><span class='o'>)</span>

<span class='nv'>bill_depth_max</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 2</span></span>
<span class='c'>#&gt;   species   max_bill_depth_mm</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>                 <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie                 21.5</span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> Chinstrap              20.8</span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> Gentoo                 17.3</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/View.html'>View</a></span><span class='o'>(</span><span class='nv'>dunn_bill_depth</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

| .y.           | group1    | group2    |  n1 |  n2 |  statistic |        p |    p.adj | p.adj.signif |
|:--------------|:----------|:----------|----:|----:|-----------:|---------:|---------:|:-------------|
| bill_depth_mm | Adelie    | Chinstrap |  73 |  34 |  0.9039517 | 0.366021 | 0.366021 | ns           |
| bill_depth_mm | Adelie    | Gentoo    |  73 |  61 | -9.5885513 | 0.000000 | 0.000000 | \*\*\*\*     |
| bill_depth_mm | Chinstrap | Gentoo    |  34 |  61 | -8.6487581 | 0.000000 | 0.000000 | \*\*\*\*     |

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>dunn_depth_for_plotting</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/data.frame.html'>data.frame</a></span><span class='o'>(</span>species <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"Adelie"</span>, <span class='s'>"Chinstrap"</span>, <span class='s'>"Gentoo"</span><span class='o'>)</span>,
                                groups <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"a"</span>, <span class='s'>"a"</span>, <span class='s'>"b"</span><span class='o'>)</span><span class='o'>)</span>

<span class='nv'>depth_for_plotting_kruskal</span> <span class='o'>&lt;-</span> <span class='nf'>full_join</span><span class='o'>(</span><span class='nv'>dunn_depth_for_plotting</span>, <span class='nv'>bill_depth_max</span>,
                               by <span class='o'>=</span> <span class='s'>"species"</span><span class='o'>)</span>

<span class='nv'>depth_for_plotting_kruskal</span>
<span class='c'>#&gt;     species groups max_bill_depth_mm</span>
<span class='c'>#&gt; 1    Adelie      a              21.5</span>
<span class='c'>#&gt; 2 Chinstrap      a              20.8</span>
<span class='c'>#&gt; 3    Gentoo      b              17.3</span></code></pre>

</div>

Let's plot.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_depth_plot_kruskal</span> <span class='o'>+</span>
  <span class='nf'>geom_text</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>depth_for_plotting_kruskal</span>,
            <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>,
                y <span class='o'>=</span> <span class='m'>1</span> <span class='o'>+</span> <span class='nv'>max_bill_depth_mm</span>, 
                color <span class='o'>=</span> <span class='nv'>species</span>,
                label <span class='o'>=</span> <span class='nv'>groups</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>caption <span class='o'>=</span> <span class='s'>"Different letters indicate significant difference as determined by \nthe Kruskal Wallis with Dunn's test for post-hoc means separation"</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-51-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Using ANOVA and Bonferroni post-hoc test

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bonferroni_bill_depth</span><span class='o'>$</span><span class='nv'>groups</span>
<span class='c'>#&gt;           bill_depth_mm_log2 groups</span>
<span class='c'>#&gt; Chinstrap           4.265907      a</span>
<span class='c'>#&gt; Adelie              4.251426      a</span>
<span class='c'>#&gt; Gentoo              3.972772      b</span>

<span class='nv'>bonferroni_bill_depth_plotting</span> <span class='o'>&lt;-</span> <span class='nv'>bonferroni_bill_depth</span><span class='o'>$</span><span class='nv'>groups</span> <span class='o'>%&gt;%</span>
  <span class='nf'>rownames_to_column</span><span class='o'>(</span>var <span class='o'>=</span> <span class='s'>"species"</span><span class='o'>)</span>

<span class='nv'>bonferroni_bill_depth_plotting</span>
<span class='c'>#&gt;     species bill_depth_mm_log2 groups</span>
<span class='c'>#&gt; 1 Chinstrap           4.265907      a</span>
<span class='c'>#&gt; 2    Adelie           4.251426      a</span>
<span class='c'>#&gt; 3    Gentoo           3.972772      b</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bonferroni_bill_depth_plotting</span> <span class='o'>&lt;-</span> <span class='nf'>full_join</span><span class='o'>(</span><span class='nv'>bonferroni_bill_depth_plotting</span>, <span class='nv'>bill_depth_max</span>,
                               by <span class='o'>=</span> <span class='s'>"species"</span><span class='o'>)</span>

<span class='nv'>bonferroni_bill_depth_plotting</span>
<span class='c'>#&gt;     species bill_depth_mm_log2 groups max_bill_depth_mm</span>
<span class='c'>#&gt; 1 Chinstrap           4.265907      a              20.8</span>
<span class='c'>#&gt; 2    Adelie           4.251426      a              21.5</span>
<span class='c'>#&gt; 3    Gentoo           3.972772      b              17.3</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='o'>(</span><span class='nv'>bill_depth_plot_bonf</span> <span class='o'>&lt;-</span> <span class='nv'>male_penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span>, color <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>outlier.shape <span class='o'>=</span> <span class='kc'>NA</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_jitter</span><span class='o'>(</span>width <span class='o'>=</span> <span class='m'>0.3</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_text</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>bonferroni_bill_depth_plotting</span>,
            <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>,
                y <span class='o'>=</span> <span class='m'>1</span> <span class='o'>+</span> <span class='nv'>max_bill_depth_mm</span>, 
                color <span class='o'>=</span> <span class='nv'>species</span>,
                label <span class='o'>=</span> <span class='nv'>groups</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_classic</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"none"</span><span class='o'>)</span> <span class='o'>+</span> <span class='c'># remove legend bc we don't need it</span>
  <span class='nf'>labs</span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Species"</span>,
       y <span class='o'>=</span> <span class='s'>"Bill Depth, in mm"</span>,
       title <span class='o'>=</span> <span class='s'>"Penguin Culmen Bill Depth Among Different Species"</span>,
       subtitle <span class='o'>=</span> <span class='s'>"Data collected from Palmer LTER, Antarctica"</span>,
       caption <span class='o'>=</span> <span class='s'>"Different letters indicate significant difference as determined by \none-way ANOVA with Bonferroni post-hoc means separation"</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-54-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

