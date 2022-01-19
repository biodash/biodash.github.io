---
title: "S03E02: ANOVA"
subtitle: "Running ANOVAs, utilizing the R output, and 🐧"
summary: "During this session of Code Club, we will learn to run parametric and non-parametric ANOVA tests and use the output for creating plots with our statistical findings."  
authors: [jessica-cooperstone]
date: "2022-01-19"
output: hugodown::md_document
toc: true

image: 
  caption: "Artwork by @allison_horst"
  focal_point: ""
  preview_only: false
rmd_hash: a89c8edb8e479478

---

------------------------------------------------------------------------

## Prep homework

### Basic computer setup

-   If you didn't already do this, please follow the [Code Club Computer Setup](/codeclub-setup/04_ggplot2/) instructions, which also has pointers for if you're new to R or RStudio.

-   If you're able to do so, please open RStudio a bit before Code Club starts -- and in case you run into issues, please join the Zoom call early and we'll help you troubleshoot.

### New to ggplot?

This isn't a ggplot specific session, though we will be using it a bit. Check out the past Code Club sessions covering `ggplot2`:

-   [S01E04](/codeclub/04_ggplot2/): intro to ggplot2
-   [S01E05](/codeclub/05_ggplot-round-2/): intro to ggplot2 round 2
-   [S01E10](/codeclub/10_faceting-animating/): faceting and animating
-   [S02E06](/codeclub/s02e06_ggplot2/): another intro to ggplot2
-   [S02E07](/codeclub/s02e07_ggplot2_part2/): a second intro to ggplot2 round 2
-   [S02E08](/codeclub/s02e08_multiple_plots/): combining plots using faceting
-   [S02E09](/codeclub/s02e09_multiple_plots_part2/): combining plots using faceting and patchwork
-   [S02E10](/codeclub/s02e10_ggpubr/): adding statistics to plots
-   [S02E11](/codeclub/s02e12_plotly/)

If you've never used `ggplot2` before (or even if you have), you may find [this cheat sheet](https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf) useful.

### Adding statistics to plots

We had a previous session [S02E10](/codeclub/s02e10_ggpubr/) developed by Daniel Quiroz that covers the package `ggpubr` and adding statistics to ggplots.

### We already did t-tests

Mike Sovic covered in the last code club [S03E01](/codeclub/s03e01_ttests/) how to run t-tests in R. We will be building on what we learned last week.

<br>

## Getting Started

<details>
<summary>
Click here to get an Rmd (optional)
</summary>

### RMarkdown for today

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># directory </span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>"S03E02"</span><span class='o'>)</span>

<span class='c'># directory for our RMarkdown</span>
<span class='c'># ("recursive" to create two levels at once.)</span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>"S03E02/Rmd/"</span><span class='o'>)</span>

<span class='c'># save the url location for today's script</span>
<span class='nv'>todays_Rmd</span> <span class='o'>&lt;-</span> 
  <span class='s'>"https://raw.githubusercontent.com/biodash/biodash.github.io/master/content/codeclub/S03E02_anova/anova.Rmd"</span>

<span class='c'># indicate the name of the new Rmd</span>
<span class='nv'>S03E02_Rmd</span> <span class='o'>&lt;-</span> <span class='s'>"S03E02/Rmd/S03E02_anova.Rmd"</span>

<span class='c'># go get that file! </span>
<span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>todays_Rmd</span>,
              destfile <span class='o'>=</span> <span class='nv'>S03E02_Rmd</span><span class='o'>)</span></code></pre>

</div>

</details>
<br>
<div class="alert alert-note">
<div>

<br>

------------------------------------------------------------------------

### Introduction

Often people are first introduced to the R programming language when they are wanting to conduct statistical analyses. My experience is that beginners are often able to conduct the analysis they want, and print their results to the console. But, the process of locating and then using the output of their analysis tends to be more complex.

Today, we are going to go over how to:

-   test if our data is suitable for running ANOVA
-   run an ANOVA test
-   run posthoc tests to understand group differences
-   use the ANOVA data output object as a means to understand R data structure.

The purpose of today's session is more to give you practical experience with running and retrieving ANOVA analysis output, than teaching about the assumptions and background of the test itself.

If you are looking for a good statistics test, I would recommend Dr. Kristin Mercer's [HCS 8887 Experimental Design](https://hcs.osu.edu/courses/hcs-8887).

<br>

------------------------------------------------------------------------

#### - Load libraries, get data

We are going to start with our favorite dataset `palmerpenguins` to provide the input data for our analysis.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/'>palmerpenguins</a></span><span class='o'>)</span> <span class='c'># for data</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://rpkgs.datanovia.com/rstatix/'>rstatix</a></span><span class='o'>)</span> <span class='c'># for testing assumptions</span>
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

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://pillar.r-lib.org/reference/glimpse.html'>glimpse</a></span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>)</span>
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

## 2. ANOVA function

We want to see if there are any differences in bill length (`bill_length_mm`) in penguins by `sex` or by `species`. We do this using ANOVA.

<p align="center">
<img src=lter_penguins.png width="50%" alt="a cute image of three penguins, the species adelie, chinstrap, and gentoo as a part of the palmer penguins package">
</p>

Illustration by [Allison Horst](https://allisonhorst.github.io/palmerpenguins/articles/art.html)

First let's get some descriptive information about our data.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>species</span>, <span class='nv'>sex</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/count.html'>count</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 3</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># Groups:   species, sex [6]</span></span>
<span class='c'>#&gt;   species   sex        n</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie    female    73</span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> Adelie    male      73</span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> Chinstrap female    34</span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span> Chinstrap male      34</span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span> Gentoo    female    58</span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span> Gentoo    male      61</span></code></pre>

</div>

The most commonly used function to run ANOVA in R is called [`aov()`](https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/aov) which is a part of the `stats` package that is pre-loaded with base R. So no new packages need to be installed here.

If we want to learn more about the function [`aov()`](https://rdrr.io/r/stats/aov.html) we can do so using the code below. The help documentation will show up in the bottom right quadrant of your RStudio.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='o'>?</span><span class='nv'>aov</span></code></pre>

</div>

We can run an ANOVA by indicating our model, and here I'm also selecting to drop the NAs.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_length_anova</span> <span class='o'>&lt;-</span> 
  <span class='nf'><a href='https://rdrr.io/r/stats/aov.html'>aov</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span> <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span>,
      <span class='nv'>bill_length_mm</span> <span class='o'>~</span> <span class='nv'>species</span> <span class='o'>+</span> <span class='nv'>sex</span> <span class='o'>+</span> <span class='nv'>species</span><span class='o'>*</span><span class='nv'>sex</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/summary.html'>summary</a></span><span class='o'>(</span><span class='nv'>bill_length_anova</span><span class='o'>)</span>
<span class='c'>#&gt;              Df Sum Sq Mean Sq F value Pr(&gt;F)    </span>
<span class='c'>#&gt; species       2   7015    3508 654.189 &lt;2e-16 ***</span>
<span class='c'>#&gt; sex           1   1136    1136 211.807 &lt;2e-16 ***</span>
<span class='c'>#&gt; species:sex   2     24      12   2.284  0.103    </span>
<span class='c'>#&gt; Residuals   327   1753       5                   </span>
<span class='c'>#&gt; ---</span>
<span class='c'>#&gt; Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1</span></code></pre>

</div>

<p align="center">
<img src=broom_package.png width="70%" alt="an image of fuzzy monsters with the test broom: turns messy tables into tidy tibbles. the monsters going in are ragged and dirty, they get cleaned and come out sparkling ">
</p>

Illustration by [Allison Horst](https://github.com/allisonhorst/stats-illustrations)

We can take the output of our ANOVA and use the function [`tidy()`](https://generics.r-lib.org/reference/tidy.html) within the `broom` package to turn our output into a tidy table.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>tidy_anova</span> <span class='o'>&lt;-</span> <span class='nf'>broom</span><span class='nf'>::</span><span class='nf'><a href='https://generics.r-lib.org/reference/tidy.html'>tidy</a></span><span class='o'>(</span><span class='nv'>bill_length_anova</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/base/print.html'>print</a></span><span class='o'>(</span><span class='nv'>tidy_anova</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 4 × 6</span></span>
<span class='c'>#&gt;   term           df  sumsq  meansq statistic    p.value</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> species         2 <span style='text-decoration: underline;'>7</span>015.  <span style='text-decoration: underline;'>3</span>508.      654.    5.03<span style='color: #555555;'>e</span><span style='color: #BB0000;'>-115</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> sex             1 <span style='text-decoration: underline;'>1</span>136.  <span style='text-decoration: underline;'>1</span>136.      212.    2.42<span style='color: #555555;'>e</span><span style='color: #BB0000;'>- 37</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> species:sex     2   24.5   12.2       2.28  1.03<span style='color: #555555;'>e</span><span style='color: #BB0000;'>-  1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span> Residuals     327 <span style='text-decoration: underline;'>1</span>753.     5.36     <span style='color: #BB0000;'>NA</span>    <span style='color: #BB0000;'>NA</span>   <span style='color: #555555;'> </span></span></code></pre>

</div>

We can also look at our data by visually plotting it, as below.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, color <span class='o'>=</span> <span class='nv'>sex</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_boxplot.html'>geom_boxplot</a></span><span class='o'>(</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-11-1.png" width="700px" style="display: block; margin: auto;" />

</div>

## 3. Posthoc group analysis

Now that we've seen that `sex` and `species` are significant effectors of `bill_length_mm`, our next logical question might be, which groups are different from each other? We can determine this by conducting post-hoc tests. We will do our post-hoc analysis using Tukey's Honestly Significant Difference test and the function [`HSD.test()`](https://www.rdocumentation.org/packages/agricolae/versions/1.3-5/topics/HSD.test) which is a part of the useful package `agricolae`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>tukey_bill_length</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/agricolae/man/HSD.test.html'>HSD.test</a></span><span class='o'>(</span><span class='nv'>bill_length_anova</span>, 
                      trt <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"species"</span>, <span class='s'>"sex"</span><span class='o'>)</span>, 
                      console <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span> <span class='c'># prints the results to console</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Study: bill_length_anova ~ c("species", "sex")</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; HSD Test for bill_length_mm </span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Mean Square Error:  5.361892 </span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; species:sex,  means</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;                  bill_length_mm      std  r  Min  Max</span>
<span class='c'>#&gt; Adelie:female          37.25753 2.028883 73 32.1 42.2</span>
<span class='c'>#&gt; Adelie:male            40.39041 2.277131 73 34.6 46.0</span>
<span class='c'>#&gt; Chinstrap:female       46.57353 3.108669 34 40.9 58.0</span>
<span class='c'>#&gt; Chinstrap:male         51.09412 1.564558 34 48.5 55.8</span>
<span class='c'>#&gt; Gentoo:female          45.56379 2.051247 58 40.9 50.5</span>
<span class='c'>#&gt; Gentoo:male            49.47377 2.720594 61 44.4 59.6</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Alpha: 0.05 ; DF Error: 327 </span>
<span class='c'>#&gt; Critical Value of Studentized Range: 4.054126 </span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Groups according to probability of means differences and alpha level( 0.05 )</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Treatments with the same letter are not significantly different.</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;                  bill_length_mm groups</span>
<span class='c'>#&gt; Chinstrap:male         51.09412      a</span>
<span class='c'>#&gt; Gentoo:male            49.47377      b</span>
<span class='c'>#&gt; Chinstrap:female       46.57353      c</span>
<span class='c'>#&gt; Gentoo:female          45.56379      c</span>
<span class='c'>#&gt; Adelie:male            40.39041      d</span>
<span class='c'>#&gt; Adelie:female          37.25753      e</span></code></pre>

</div>

Like we did with t-tests, you can also look at the resulting HSD.test object (here, `tukey_bill_length`) in your environment pane.

Here, instead of using the `broom` package, you can convert the part of the `tukey_bill_length` object that contains the post-hoc groupings into a dataframe using [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>tidy_tukey</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/as.data.frame.html'>as.data.frame</a></span><span class='o'>(</span><span class='nv'>tukey_bill_length</span><span class='o'>$</span><span class='nv'>groups</span><span class='o'>)</span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## 4. Testing assumptions

I know I said we weren't going to talk about this, but I thought I'd be remiss if I didn't show you how to test that you aren't violating any of the assumptions needed to conduct an ANOVA. We went over this a little bit back in the session put together by Daniel Quiroz on [ggpubr](https://biodash.github.io/codeclub/s02e10_ggpubr/) and adding statistical results to ggplots.

Briefly, in order to use parametric procedures (like ANOVA), we need to be sure our data meets the assumptions for 1) normality and 2) constant variance. This can be done in a few different ways.

### Shapiro-Wilk test for normality

We are going to use the Shapiro-Wilk test (using the function [`shapiro_test()`](https://rpkgs.datanovia.com/rstatix/reference/shapiro_test.html) which is in the package `rstatix` to determine normality, but will do it groupwise. This function is a pipe-friendly wrapper for the function [`shapiro.test()`](https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/shapiro.test), which just means you can use it with pipes.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'>rstatix</span><span class='nf'>::</span><span class='nf'><a href='https://rpkgs.datanovia.com/rstatix/reference/shapiro_test.html'>shapiro_test</a></span><span class='o'>(</span><span class='nv'>bill_length_mm</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1 × 3</span></span>
<span class='c'>#&gt;   variable       statistic         p</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> bill_length_mm     0.974 0.000<span style='text-decoration: underline;'>011</span>9</span>

<span class='nv'>penguins</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>species</span>, <span class='nv'>sex</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'>rstatix</span><span class='nf'>::</span><span class='nf'><a href='https://rpkgs.datanovia.com/rstatix/reference/shapiro_test.html'>shapiro_test</a></span><span class='o'>(</span><span class='nv'>bill_length_mm</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 5</span></span>
<span class='c'>#&gt;   species   sex    variable       statistic       p</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie    female bill_length_mm     0.991 0.895  </span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> Adelie    male   bill_length_mm     0.986 0.607  </span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> Chinstrap female bill_length_mm     0.883 0.001<span style='text-decoration: underline;'>70</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span> Chinstrap male   bill_length_mm     0.955 0.177  </span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span> Gentoo    female bill_length_mm     0.989 0.895  </span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span> Gentoo    male   bill_length_mm     0.940 0.005<span style='text-decoration: underline;'>11</span></span></code></pre>

</div>

Can we visualize normality in another way?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_histogram.html'>geom_histogram</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/facet_grid.html'>facet_grid</a></span><span class='o'>(</span>cols <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/vars.html'>vars</a></span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span>,
             rows <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/vars.html'>vars</a></span><span class='o'>(</span><span class='nv'>sex</span><span class='o'>)</span><span class='o'>)</span>
<span class='c'>#&gt; `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.</span>
</code></pre>
<img src="figs/unnamed-chunk-15-1.png" width="700px" style="display: block; margin: auto;" />

</div>

### Equal variance

We can test for equal variance using Levene's test, [`levene_test()`](https://www.rdocumentation.org/packages/rstatix/versions/0.7.0/topics/levene_test) which is part of the `rstatix` package. Again, this is a pipe-friendly wrapper for the function [`levene.test()`](https://www.rdocumentation.org/packages/lawstat/versions/3.4/topics/levene.test).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>rstatix</span><span class='nf'>::</span><span class='nf'><a href='https://rpkgs.datanovia.com/rstatix/reference/levene_test.html'>levene_test</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span> <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span>,
                       <span class='nv'>bill_length_mm</span> <span class='o'>~</span> <span class='nv'>species</span><span class='o'>*</span><span class='nv'>sex</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1 × 4</span></span>
<span class='c'>#&gt;     df1   df2 statistic     p</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span>     5   327      1.40 0.222</span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## 5. Bringing it together in a plot

We already looked at a first-pass plot, but let's customize it now, and add our statistical info. Here is our base plot.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, color <span class='o'>=</span> <span class='nv'>sex</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_boxplot.html'>geom_boxplot</a></span><span class='o'>(</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-17-1.png" width="700px" style="display: block; margin: auto;" />

</div>

First let's make the plot more aesthetically pleasing.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='o'>(</span><span class='nv'>bill_length_plot</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, color <span class='o'>=</span> <span class='nv'>sex</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_boxplot.html'>geom_boxplot</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggtheme.html'>theme_classic</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/labs.html'>labs</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Species"</span>,
       y <span class='o'>=</span> <span class='s'>"Bill Length, in mm"</span>,
       color <span class='o'>=</span> <span class='s'>"Sex"</span>,
       title <span class='o'>=</span> <span class='s'>"Penguin Culmen Bill Length Among Different Species, and by Sex"</span>,
       subtitle <span class='o'>=</span> <span class='s'>"Data collected from Palmer LTER, Antarctica"</span><span class='o'>)</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-18-1.png" width="700px" style="display: block; margin: auto;" />

</div>

We want to add the letters to this plot, so we can tell which groups of species by sex are significantly different. We are going to figure out what the maximum `bill_length_mm` for each species by sex is, so it will help us determine where to put our letter labels. Then, we cna add our labels to be higher than the largest data point.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_length_max</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>species</span>, <span class='nv'>sex</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span>max_bill_length_mm <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='o'>(</span><span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span>
<span class='c'>#&gt; `summarise()` has grouped output by 'species'. You can override using the `.groups` argument.</span>

<span class='nv'>bill_length_max</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 3</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># Groups:   species [3]</span></span>
<span class='c'>#&gt;   species   sex    max_bill_length_mm</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>               <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie    female               42.2</span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> Adelie    male                 46  </span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> Chinstrap female               58  </span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span> Chinstrap male                 55.8</span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span> Gentoo    female               50.5</span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span> Gentoo    male                 59.6</span></code></pre>

</div>

Let's add our post-hoc group info to `bill_length_max`, since those two dataframes are not in the same order. We are going to use the function [`separate()`](https://tidyr.tidyverse.org/reference/separate.html) which we used back in a [previous code club](https://biodash.github.io/codeclub/20_cleaning-up/#5---separate-character-columns).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>tidier_tukey</span> <span class='o'>&lt;-</span> <span class='nv'>tidy_tukey</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://tibble.tidyverse.org/reference/rownames.html'>rownames_to_column</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/separate.html'>separate</a></span><span class='o'>(</span>col <span class='o'>=</span> <span class='nv'>rowname</span>,
           into <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"species"</span>, <span class='s'>"sex"</span><span class='o'>)</span>,
           sep <span class='o'>=</span> <span class='s'>":"</span><span class='o'>)</span>
  

<span class='nv'>bill_for_plotting</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate-joins.html'>full_join</a></span><span class='o'>(</span><span class='nv'>tidier_tukey</span>, <span class='nv'>bill_length_max</span>,
                               by <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"species"</span>, <span class='s'>"sex"</span><span class='o'>)</span><span class='o'>)</span></code></pre>

</div>

Let's plot.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_length_plot</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_text.html'>geom_text</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>bill_for_plotting</span>,
            <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>,
                y <span class='o'>=</span> <span class='m'>5</span> <span class='o'>+</span> <span class='nv'>max_bill_length_mm</span>, 
                color <span class='o'>=</span> <span class='nv'>sex</span>,
                label <span class='o'>=</span> <span class='nv'>groups</span><span class='o'>)</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-21-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Almost there. We want the letters to be over the right box plot (coloring here by `sex` helps us to see what is going on better). Let's fix it.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_length_plot</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_text.html'>geom_text</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>bill_for_plotting</span>,
            <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>,
                y <span class='o'>=</span> <span class='m'>3</span> <span class='o'>+</span> <span class='nv'>max_bill_length_mm</span>, 
                color <span class='o'>=</span> <span class='nv'>sex</span>,
                label <span class='o'>=</span> <span class='nv'>groups</span><span class='o'>)</span>,
            position <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/position_dodge.html'>position_dodge</a></span><span class='o'>(</span>width <span class='o'>=</span> <span class='m'>0.75</span><span class='o'>)</span>,
            show.legend <span class='o'>=</span> <span class='kc'>FALSE</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/labs.html'>labs</a></span><span class='o'>(</span>caption <span class='o'>=</span> <span class='s'>"Groups with different letters are statistically different using a\n two way ANOVA and Tukey's post-hoc test"</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-22-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Also remember Daniel showed us how we can do [somthing similar](https://biodash.github.io/codeclub/s02e10_ggpubr/) using the package `ggpubr`.

<br>

------------------------------------------------------------------------

## Breakout rooms

We have investigated `bill_length_mm` - but what about `body_mass_g`? Let's investigate only the male penguins.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/'>palmerpenguins</a></span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 8</span></span>
<span class='c'>#&gt;   species island bill_length_mm bill_depth_mm flipper_length_… body_mass_g sex  </span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>           <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie  Torge…           39.1          18.7              181        <span style='text-decoration: underline;'>3</span>750 male </span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> Adelie  Torge…           39.5          17.4              186        <span style='text-decoration: underline;'>3</span>800 fema…</span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> Adelie  Torge…           40.3          18                195        <span style='text-decoration: underline;'>3</span>250 fema…</span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span> Adelie  Torge…           <span style='color: #BB0000;'>NA</span>            <span style='color: #BB0000;'>NA</span>                 <span style='color: #BB0000;'>NA</span>          <span style='color: #BB0000;'>NA</span> <span style='color: #BB0000;'>NA</span>   </span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span> Adelie  Torge…           36.7          19.3              193        <span style='text-decoration: underline;'>3</span>450 fema…</span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span> Adelie  Torge…           39.3          20.6              190        <span style='text-decoration: underline;'>3</span>650 male </span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 1 more variable: year &lt;int&gt;</span></span></code></pre>

</div>

### Exercise 1

<div class="puzzle">

<div>

Test the assumptions used by ANOVA to see if it is an appropriate test for you to use in this case. If it is not, find out what the appropriate test to use is, and then use it!

<details>
<summary>
Hints (click here)
</summary>
Test for normality and equal variance using [`shapiro_test()`](https://rpkgs.datanovia.com/rstatix/reference/shapiro_test.html) and [`levene_test()`](https://rpkgs.datanovia.com/rstatix/reference/levene_test.html) respectively. <br>
</details>

<br>

<details>
<summary>
Solutions (click here)
</summary>
Testing for normality:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>sex</span> <span class='o'>==</span> <span class='s'>"male"</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'>rstatix</span><span class='nf'>::</span><span class='nf'><a href='https://rpkgs.datanovia.com/rstatix/reference/shapiro_test.html'>shapiro_test</a></span><span class='o'>(</span><span class='nv'>bill_depth_mm</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 4</span></span>
<span class='c'>#&gt;   species   variable      statistic      p</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>             <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie    bill_depth_mm     0.964 0.033<span style='text-decoration: underline;'>5</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> Chinstrap bill_depth_mm     0.983 0.863 </span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> Gentoo    bill_depth_mm     0.980 0.401</span></code></pre>

</div>

Testing for equal variance:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>rstatix</span><span class='nf'>::</span><span class='nf'><a href='https://rpkgs.datanovia.com/rstatix/reference/levene_test.html'>levene_test</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span> <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>sex</span> <span class='o'>==</span> <span class='s'>"male"</span><span class='o'>)</span>,
                       <span class='nv'>bill_depth_mm</span> <span class='o'>~</span> <span class='nv'>species</span><span class='o'>*</span><span class='nv'>sex</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1 × 4</span></span>
<span class='c'>#&gt;     df1   df2 statistic     p</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span>     2   165      2.30 0.103</span></code></pre>

</div>

We are finding non-normal distribution of the male, Adelie penguins. I will take this opportunity to show you how to run non-parametric tests as well.

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### Exercise 2

<div class="puzzle">

<div>

Conduct ANOVA or another relevant test to see if there are significant differences in `bill_depth_mm` in the Palmer penguins by by `species`.

<details>
<summary>
Hints (click here)
</summary>
The non-parametric version of a one-way ANOVA is the Kruskal-Wallis test, and you can use the `rstatix` function [`kruskal_test()`](https://www.rdocumentation.org/packages/rstatix/versions/0.7.0/topics/kruskal_test). <br>
</details>

<br>

<details>
<summary>
Solutions (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_depth_kruskal</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>sex</span> <span class='o'>==</span> <span class='s'>"male"</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://rpkgs.datanovia.com/rstatix/reference/kruskal_test.html'>kruskal_test</a></span><span class='o'>(</span><span class='nv'>bill_depth_mm</span> <span class='o'>~</span> <span class='nv'>species</span><span class='o'>)</span>

<span class='nv'>bill_depth_kruskal</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1 × 6</span></span>
<span class='c'>#&gt;   .y.               n statistic    df     p method        </span>
<span class='c'>#&gt; <span style='color: #555555;'>*</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>         </span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> bill_depth_mm   168      116.     2 6<span style='color: #555555;'>e</span><span style='color: #BB0000;'>-26</span> Kruskal-Wallis</span></code></pre>

</div>

If this were a parametric test, we could do it like this. [`aov()`](https://rdrr.io/r/stats/aov.html) is not a very pipe friendly function.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_depth_anova</span> <span class='o'>&lt;-</span> 
  <span class='nf'><a href='https://rdrr.io/r/stats/aov.html'>aov</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span> <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>sex</span> <span class='o'>==</span> <span class='s'>"male"</span><span class='o'>)</span>,
      <span class='nv'>bill_depth_mm</span> <span class='o'>~</span> <span class='nv'>species</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/base/summary.html'>summary</a></span><span class='o'>(</span><span class='nv'>bill_depth_anova</span><span class='o'>)</span>
<span class='c'>#&gt;              Df Sum Sq Mean Sq F value Pr(&gt;F)    </span>
<span class='c'>#&gt; species       2  453.0  226.51   294.7 &lt;2e-16 ***</span>
<span class='c'>#&gt; Residuals   165  126.8    0.77                   </span>
<span class='c'>#&gt; ---</span>
<span class='c'>#&gt; Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1</span></code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### Exercise 3

<div class="puzzle">

<div>

Conduct post-hoc tests to see where significant differences exist between your `species`. You can use any post-hoc test you like.

<details>
<summary>
Hints (click here)
</summary>
Check out the function [`LSD.test`](https://www.rdocumentation.org/packages/agricolae/versions/1.3-5/topics/LSD.test) and the p-value adjustment procedures. <br>
</details>

<br>

<details>
<summary>
Solutions (click here)
</summary>
Using a Bonferroni correction  

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bonferroni_bill_depth</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/agricolae/man/LSD.test.html'>LSD.test</a></span><span class='o'>(</span><span class='nv'>bill_depth_anova</span>, 
                      trt <span class='o'>=</span> <span class='s'>"species"</span>, 
                      p.adj <span class='o'>=</span> <span class='s'>"bonferroni"</span>,
                      console <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Study: bill_depth_anova ~ "species"</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; LSD t Test for bill_depth_mm </span>
<span class='c'>#&gt; P value adjustment method: bonferroni </span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Mean Square Error:  0.7686065 </span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; species,  means and individual ( 95 %) CI</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;           bill_depth_mm       std  r      LCL      UCL  Min  Max</span>
<span class='c'>#&gt; Adelie         19.07260 1.0188856 73 18.87000 19.27520 17.0 21.5</span>
<span class='c'>#&gt; Chinstrap      19.25294 0.7612730 34 18.95608 19.54981 17.5 20.8</span>
<span class='c'>#&gt; Gentoo         15.71803 0.7410596 61 15.49640 15.93966 14.1 17.3</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Alpha: 0.05 ; DF Error: 165</span>
<span class='c'>#&gt; Critical Value of t: 2.418634 </span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Groups according to probability of means differences and alpha level( 0.05 )</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Treatments with the same letter are not significantly different.</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;           bill_depth_mm groups</span>
<span class='c'>#&gt; Chinstrap      19.25294      a</span>
<span class='c'>#&gt; Adelie         19.07260      a</span>
<span class='c'>#&gt; Gentoo         15.71803      b</span></code></pre>

</div>

Using Tukey's posthoc test

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>tukey_bill_length</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/agricolae/man/HSD.test.html'>HSD.test</a></span><span class='o'>(</span><span class='nv'>bill_depth_anova</span>, 
                      trt <span class='o'>=</span> <span class='s'>"species"</span>, 
                      console <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span> <span class='c'># prints the results to console</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Study: bill_depth_anova ~ "species"</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; HSD Test for bill_depth_mm </span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Mean Square Error:  0.7686065 </span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; species,  means</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;           bill_depth_mm       std  r  Min  Max</span>
<span class='c'>#&gt; Adelie         19.07260 1.0188856 73 17.0 21.5</span>
<span class='c'>#&gt; Chinstrap      19.25294 0.7612730 34 17.5 20.8</span>
<span class='c'>#&gt; Gentoo         15.71803 0.7410596 61 14.1 17.3</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Alpha: 0.05 ; DF Error: 165 </span>
<span class='c'>#&gt; Critical Value of Studentized Range: 3.344694 </span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Groups according to probability of means differences and alpha level( 0.05 )</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Treatments with the same letter are not significantly different.</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;           bill_depth_mm groups</span>
<span class='c'>#&gt; Chinstrap      19.25294      a</span>
<span class='c'>#&gt; Adelie         19.07260      a</span>
<span class='c'>#&gt; Gentoo         15.71803      b</span></code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### Exercise 4

<div class="puzzle">

<div>

Make a plot to express your findings. I will leave it up to you to decide what this plot will look like. Add your statistical findings.

<details>
<summary>
Hints (click here)
</summary>
Review the information in section 5 of this post. You could also use the package `ggpubr`. <br>
</details>

<br>

<details>
<summary>
Solutions (click here)
</summary>
Preparing to plot.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_depth_max</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>sex</span> <span class='o'>==</span> <span class='s'>"male"</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span>max_bill_depth_mm <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='o'>(</span><span class='nv'>bill_depth_mm</span><span class='o'>)</span><span class='o'>)</span>

<span class='nv'>bill_depth_max</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 2</span></span>
<span class='c'>#&gt;   species   max_bill_depth_mm</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>                 <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie                 21.5</span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> Chinstrap              20.8</span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> Gentoo                 17.3</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># grab group information from bonferroni test</span>
<span class='c'># species is a rowname instead of column so lets change that</span>
<span class='nv'>bonferroni_bill_depth_groups</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/as.data.frame.html'>as.data.frame</a></span><span class='o'>(</span><span class='nv'>bonferroni_bill_depth</span><span class='o'>$</span><span class='nv'>groups</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
                                                <span class='nf'><a href='https://tibble.tidyverse.org/reference/rownames.html'>rownames_to_column</a></span><span class='o'>(</span>var <span class='o'>=</span> <span class='s'>"species"</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'># join dfs</span>
<span class='nv'>bill_depth_for_plotting</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate-joins.html'>full_join</a></span><span class='o'>(</span><span class='nv'>bill_depth_max</span>, <span class='nv'>bonferroni_bill_depth_groups</span>,
                                     by <span class='o'>=</span> <span class='s'>"species"</span><span class='o'>)</span>

<span class='c'># check</span>
<span class='nv'>bill_depth_for_plotting</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 4</span></span>
<span class='c'>#&gt;   species   max_bill_depth_mm bill_depth_mm groups</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                 <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> </span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie                 21.5          19.1 a     </span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> Chinstrap              20.8          19.3 a     </span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> Gentoo                 17.3          15.7 b</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='o'>(</span><span class='nv'>bill_depth_plot</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>sex</span> <span class='o'>==</span> <span class='s'>"male"</span><span class='o'>)</span> <span class='o'><a href='https://rpkgs.datanovia.com/rstatix/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span>, color <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_boxplot.html'>geom_boxplot</a></span><span class='o'>(</span>outlier.shape <span class='o'>=</span> <span class='kc'>NA</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_jitter.html'>geom_jitter</a></span><span class='o'>(</span>width <span class='o'>=</span> <span class='m'>0.2</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_text.html'>geom_text</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>bill_depth_for_plotting</span>,
            <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='m'>1</span> <span class='o'>+</span> <span class='nv'>max_bill_depth_mm</span>,
                label <span class='o'>=</span> <span class='nv'>groups</span><span class='o'>)</span>, color <span class='o'>=</span> <span class='s'>"black"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggtheme.html'>theme_classic</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/theme.html'>theme</a></span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"none"</span>,
        plot.caption <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/element.html'>element_text</a></span><span class='o'>(</span>hjust <span class='o'>=</span> <span class='m'>0</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/labs.html'>labs</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Species"</span>,
       y <span class='o'>=</span> <span class='s'>"Bill Depth, in mm"</span>,
       title <span class='o'>=</span> <span class='s'>"Penguin Culmen Bill Depth Among Different Species"</span>,
       subtitle <span class='o'>=</span> <span class='s'>"Data collected from Palmer LTER, Antarctica"</span>,
       caption <span class='o'>=</span> <span class='s'>"Species significantly affects bill depth as determined by the Kruskal-Wallis test \nwith significantly different species using Bonferroni post-hoc test at P &lt; 0.05 indicated with different letters."</span><span class='o'>)</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-32-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

<br>

</div>

</div>

<br>

------------------------------------------------------------------------

