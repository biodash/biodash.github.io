---
title: "S03E05: Introduction to correlation"
subtitle: "Using the _corrr_ package"
summary: "...."
authors: [stephen-opiyo]
date: "2022-02-08"
output: hugodown::md_document
toc: true
rmd_hash: 0c9919ad7ea96930

---

------------------------------------------------------------------------

## Housekeeping

#### New to Code Club?

Check out the [Code Club Computer Setup](/codeclub-setup/) instructions, which also has pointers for if you're new to R or RStudio. A few related Code Club sessions include:

-   [S03E01](/codeclub/s03e01_ttests/): T-tests
-   [S03E02](/codeclub/s03e02_anova/): ANOVA
-   [S03E03](/codeclub/s03e03_pca/): PCA
-   [S03E04](/codeclub/s03e04_anova2/): ANOVA part II

#### What will we go over today

-   We will introduce correlation.
-   Learn using the [`corrr()`](https://cran.r-project.org/web/packages/corrr/index.html) package.

#### R packages we will use

-   *corrr* -- for correlation analysis
-   *palmerpenguins* -- for the penguins data
-   *tidyverse* -- for data wrangling

<br>

------------------------------------------------------------------------

## 1 - What is correlation?

Correlation is a statistical method used to assess a linear association between two continuous variables. It is measured by a statistic called the correlation coefficient, which represents the strength of the linear association between the variables in question. It is a dimensionless quantity that takes a value in the range −1 to +1. A correlation coefficient of zero indicates that no linear relationship exists between two continuous variables, and a correlation coefficient of −1 or +1 indicates a perfect linear relationship. (The stronger the correlation, the closer the correlation coefficient comes to −1 and +1.)

**Positive coefficient**: If the coefficient is a positive number, the variables are positively related (i.e., as the value of one variable goes up, the value of the other also tends to do so).

**Negative coefficient**: If the coefficient is a negative number, the variables are inversely related (i.e., as the value of one variable goes up, the value of the other tends to go down).

**Types of correlation coefficients**: There are two main types of correlation coefficients, *Pearson's correlation coefficient* and *Spearman's rank correlation coefficient*. The correct usage of correlation coefficient type depends on the types of variables being studied.

-   *Pearson's correlation coefficient*: Pearson's correlation coefficient is denoted as **ϱ** for a population parameter and as **r** for a sample statistic. It is used when both variables being studied are normally distributed.

-   *Spearman's rank correlation coefficient*: Spearman's rank correlation coefficient is denoted as **ϱs** for a population parameter and as **rs** for a sample statistic. It is appropriate when one or both variables are skewed or ordinal.

**Rule of thumb for interpreting the size of a correlation coefficient**

-   .90 to 1.00 (−.90 to −1.00) -- Very high positive (negative) correlation
-   .70 to .90 (−.70 to −.90) -- High positive (negative) correlation
-   .50 to .70 (−.50 to −.70) -- Moderate positive (negative) correlation
-   .30 to .50 (−.30 to −.50) -- Low positive (negative) correlation
-   .00 to .30 (.00 to −.30) -- Negligible correlation

<br>

------------------------------------------------------------------------

## 2 - The *corrr* package and our data

The *corrr* package is a tool for exploring correlations. It makes it easy to perform routine tasks when exploring correlation matrices such as ignoring the diagonal, focusing on the correlations of certain variables against others, or rearranging and visualizing the matrix in terms of the strength of the correlations. The *corrr* package exists within the Comprehensive R Archive Network, or [CRAN](https://cran.r-project.org/).

Let's install it -- we only need to do this once:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"corrr"</span><span class='o'>)</span></code></pre>

</div>

To use the *corrr* package, we need to load it up using [`library()`](https://rdrr.io/r/base/library.html). We also need to load the *tidyverse* since we will be using it later:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/tidymodels/corrr'>corrr</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
<span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching packages</span> ─────────────────────────────────────── tidyverse 1.3.1 ──</span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>ggplot2</span> 3.3.5     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>purrr  </span> 0.3.4</span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tibble </span> 3.1.6     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>dplyr  </span> 1.0.7</span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tidyr  </span> 1.2.0     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>stringr</span> 1.4.0</span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>readr  </span> 2.1.2     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>forcats</span> 0.5.1</span>
<span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span> ────────────────────────────────────────── tidyverse_conflicts() ──</span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>filter()</span> masks <span style='color: #0000BB;'>stats</span>::filter()</span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>lag()</span>    masks <span style='color: #0000BB;'>stats</span>::lag()</span></code></pre>

</div>

------------------------------------------------------------------------

**Let's get set up and grab some data to work with.**

We will use the same dataset [`palmerpenguins`](https://allisonhorst.github.io/palmerpenguins/) used in the previous weeks.

If you didn't install this package previously, please do so now:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"palmerpenguins"</span><span class='o'>)</span></code></pre>

</div>

Then, to use the package, we need to use the function [`library()`](https://rdrr.io/r/base/library.html) to load it:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/'>palmerpenguins</a></span><span class='o'>)</span></code></pre>

</div>

The data we will use today is a dataframe called `penguins`, which we reference after loading the package. We will look at the structure of the data:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># look at the first 10 rows, all columns</span>
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

<br>

------------------------------------------------------------------------

## 2 - Basic usage of the *corrr* package

Now we want to use the *corrr* package to correlate variables in the `penguins` dataframe. The *corrr* package uses the [`correlate()`](https://corrr.tidymodels.org/reference/correlate.html) function and returns correlation results in a tibble output.

Now let select variables from penguins using the pipe operator `%>%` and the `select()` function. We then specify name of the variables that we want to select. In this example, we are selecting variables `bill_length_mm`, `bill_depth_mm`, `flipper_length_mm`, and `body_mass_g`.

Then, we will compute correlations among the variables:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_cor</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>   <span class='c'># Take penguins_data</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>bill_length_mm</span>, <span class='nv'>bill_depth_mm</span>, <span class='nv'>flipper_length_mm</span>, <span class='nv'>body_mass_g</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://corrr.tidymodels.org/reference/correlate.html'>correlate</a></span><span class='o'>(</span><span class='o'>)</span>       <span class='c'># Select variables and calculate their correlations</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Correlation method: 'pearson'</span>
<span class='c'>#&gt; Missing treated using: 'pairwise.complete.obs'</span>

<span class='nv'>penguins_cor</span>        <span class='c'># Correlation results in tibble</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 4 × 5</span></span>
<span class='c'>#&gt;   term              bill_length_mm bill_depth_mm flipper_length_mm body_mass_g</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>             <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> bill_length_mm            <span style='color: #BB0000;'>NA</span>            -<span style='color: #BB0000;'>0.235</span>             0.656       0.595</span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> bill_depth_mm             -<span style='color: #BB0000;'>0.235</span>        <span style='color: #BB0000;'>NA</span>                -<span style='color: #BB0000;'>0.584</span>      -<span style='color: #BB0000;'>0.472</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> flipper_length_mm          0.656        -<span style='color: #BB0000;'>0.584</span>            <span style='color: #BB0000;'>NA</span>           0.871</span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span> body_mass_g                0.595        -<span style='color: #BB0000;'>0.472</span>             0.871      <span style='color: #BB0000;'>NA</span></span></code></pre>

</div>

The output of the [`correlate()`](https://corrr.tidymodels.org/reference/correlate.html) function can be piped (`%>%`) to:

-   The [`shave()`](https://corrr.tidymodels.org/reference/shave.html) and [`rearrange()`](https://corrr.tidymodels.org/reference/rearrange.html) functions for internal changes
-   The [`focus()`](https://corrr.tidymodels.org/reference/focus.html), and [`stretch()`](https://corrr.tidymodels.org/reference/stretch.html) functions to reshape the structure
-   And the [`rplot()`](https://corrr.tidymodels.org/reference/rplot.html), [`fashion()`](https://corrr.tidymodels.org/reference/fashion.html), and [`network_plot()`](https://corrr.tidymodels.org/reference/network_plot.html) for visualizations.

*Let us start with internal changes*.

-   The [`shave()`](https://corrr.tidymodels.org/reference/shave.html) function removes values of the upper or lower triangle and sets them to `NA`.
-   The [`rearrange()`](https://corrr.tidymodels.org/reference/rearrange.html) function arranges the columns and rows based on correlation strengths.

We can apply the [`shave()`](https://corrr.tidymodels.org/reference/shave.html) function remove the top triangle:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_cor</span> <span class='o'>%&gt;%</span>   <span class='c'># Take penguins_cor results</span>
  <span class='nf'><a href='https://corrr.tidymodels.org/reference/shave.html'>shave</a></span><span class='o'>(</span><span class='o'>)</span>          <span class='c'># Remove the upper triangle</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 4 × 5</span></span>
<span class='c'>#&gt;   term              bill_length_mm bill_depth_mm flipper_length_mm body_mass_g</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>             <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> bill_length_mm            <span style='color: #BB0000;'>NA</span>            <span style='color: #BB0000;'>NA</span>                <span style='color: #BB0000;'>NA</span>              <span style='color: #BB0000;'>NA</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> bill_depth_mm             -<span style='color: #BB0000;'>0.235</span>        <span style='color: #BB0000;'>NA</span>                <span style='color: #BB0000;'>NA</span>              <span style='color: #BB0000;'>NA</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> flipper_length_mm          0.656        -<span style='color: #BB0000;'>0.584</span>            <span style='color: #BB0000;'>NA</span>              <span style='color: #BB0000;'>NA</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span> body_mass_g                0.595        -<span style='color: #BB0000;'>0.472</span>             0.871          <span style='color: #BB0000;'>NA</span></span></code></pre>

</div>

You can see that values of upper triangle are replaced by `NA`s. Now let us remove `NA`s by using the [`fashion()`](https://corrr.tidymodels.org/reference/fashion.html) function:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_cor</span> <span class='o'>%&gt;%</span>   <span class='c'># Take penguins_cor results</span>
  <span class='nv'>shave</span> <span class='o'>%&gt;%</span>        <span class='c'># Remove the upper triangle</span>
  <span class='nf'><a href='https://corrr.tidymodels.org/reference/fashion.html'>fashion</a></span><span class='o'>(</span><span class='o'>)</span>        <span class='c'># Remove NAs</span>
<span class='c'>#&gt;                term bill_length_mm bill_depth_mm flipper_length_mm body_mass_g</span>
<span class='c'>#&gt; 1    bill_length_mm                                                           </span>
<span class='c'>#&gt; 2     bill_depth_mm           -.24                                            </span>
<span class='c'>#&gt; 3 flipper_length_mm            .66          -.58                              </span>
<span class='c'>#&gt; 4       body_mass_g            .60          -.47               .87</span></code></pre>

</div>

You can see that the `NA`s have been removed, and we have a clean tibble (dataframe).

Now, let's rearrange columns based on correlation strengths:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_cor</span> <span class='o'>%&gt;%</span>   <span class='c'># Take penguins_cor results</span>
  <span class='nv'>rearrange</span> <span class='o'>%&gt;%</span>    <span class='c'># Rearrange based on correlation strengths</span>
  <span class='nv'>shave</span> <span class='o'>%&gt;%</span>        <span class='c'># Remove the upper triangle</span>
  <span class='nf'><a href='https://corrr.tidymodels.org/reference/fashion.html'>fashion</a></span><span class='o'>(</span><span class='o'>)</span>        <span class='c'># Remove NAs</span>
<span class='c'>#&gt;                term flipper_length_mm body_mass_g bill_length_mm bill_depth_mm</span>
<span class='c'>#&gt; 1 flipper_length_mm                                                           </span>
<span class='c'>#&gt; 2       body_mass_g               .87                                         </span>
<span class='c'>#&gt; 3    bill_length_mm               .66         .60                             </span>
<span class='c'>#&gt; 4     bill_depth_mm              -.58        -.47           -.24</span></code></pre>

</div>

You can see that the values are arranged based on correlation strengths.

<br>

------------------------------------------------------------------------

<div class="puzzle">

<div>

## Breakout session 1

-   From the `penguins` dataframe, create a new dataset called `penguins_biscoe` by selecting only the penguins from the island of Biscoe.

-   In the `penguins_biscoe` dataframe, what are the correlations between `bill_length_mm`, `bill_depth_mm`, `flipper_length_mm`, and `year`?

-   Remove the upper triangle and `NA`s from the results, and arrange based on correlation strengths.

<details>
<summary>
<b>Hints</b> (click here)
</summary>

<br>

Use the [`filter()`](https://rdrr.io/r/stats/filter.html) function to only select penguins from the island of Biscoe.

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

Select the penguins from the island of Biscoe:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_biscoe</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>  <span class='c'># Save results in new object</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>island</span> <span class='o'>==</span> <span class='s'>"Biscoe"</span><span class='o'>)</span>     <span class='c'># Select data from only Biscoe island  </span></code></pre>

</div>

Calculate correlation of the variables in `penguins_biscoe`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>biscoe_cor</span> <span class='o'>&lt;-</span> <span class='nv'>penguins_biscoe</span> <span class='o'>%&gt;%</span>
  <span class='c'># select bill_length_mm, bill_depth_mm, flipper_length_mm, and year</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>bill_length_mm</span>, <span class='nv'>bill_depth_mm</span>, <span class='nv'>flipper_length_mm</span>, <span class='nv'>year</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://corrr.tidymodels.org/reference/correlate.html'>correlate</a></span><span class='o'>(</span><span class='o'>)</span>        <span class='c'># Calculate correlation</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Correlation method: 'pearson'</span>
<span class='c'>#&gt; Missing treated using: 'pairwise.complete.obs'</span>

<span class='nv'>biscoe_cor</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 4 × 5</span></span>
<span class='c'>#&gt;   term              bill_length_mm bill_depth_mm flipper_length_mm    year</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>             <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> bill_length_mm           <span style='color: #BB0000;'>NA</span>             -<span style='color: #BB0000;'>0.444</span>             0.866  0.096<span style='text-decoration: underline;'>8</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> bill_depth_mm            -<span style='color: #BB0000;'>0.444</span>         <span style='color: #BB0000;'>NA</span>                -<span style='color: #BB0000;'>0.579</span>  0.138 </span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> flipper_length_mm         0.866         -<span style='color: #BB0000;'>0.579</span>            <span style='color: #BB0000;'>NA</span>      0.105 </span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span> year                      0.096<span style='text-decoration: underline;'>8</span>         0.138             0.105 <span style='color: #BB0000;'>NA</span></span></code></pre>

</div>

To remove the upper triangle and rearrange the results:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>biscoe_cor</span>  <span class='o'>%&gt;%</span>      <span class='c'># Take biscoe_cor results</span>
  <span class='nf'><a href='https://corrr.tidymodels.org/reference/rearrange.html'>rearrange</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>    <span class='c'># Rearrange based on correlation strengths</span>
  <span class='nf'><a href='https://corrr.tidymodels.org/reference/shave.html'>shave</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>        <span class='c'># Remove the upper triangle</span>
  <span class='nf'><a href='https://corrr.tidymodels.org/reference/fashion.html'>fashion</a></span><span class='o'>(</span><span class='o'>)</span>          <span class='c'># Remove NAs</span>
<span class='c'>#&gt;                term flipper_length_mm bill_length_mm year bill_depth_mm</span>
<span class='c'>#&gt; 1 flipper_length_mm                                                    </span>
<span class='c'>#&gt; 2    bill_length_mm               .87                                  </span>
<span class='c'>#&gt; 3              year               .11            .10                   </span>
<span class='c'>#&gt; 4     bill_depth_mm              -.58           -.44  .14</span></code></pre>

</div>

</details>

</div>

</div>

<br>

------------------------------------------------------------------------

## 3 - Reshaping and visualizations

The output of the [`correlate()`](https://corrr.tidymodels.org/reference/correlate.html) function can also be piped to:

-   The [`focus()`](https://corrr.tidymodels.org/reference/focus.html) and [`stretch()`](https://corrr.tidymodels.org/reference/stretch.html) functions to reshape the structure
-   And the [`rplot()`](https://corrr.tidymodels.org/reference/rplot.html), and [`network_plot()`](https://corrr.tidymodels.org/reference/network_plot.html) for visualizations.

*Reshape structure*:

-   The [`focus()`](https://corrr.tidymodels.org/reference/focus.html) function select columns or rows based on the variable specified.
-   The [`stretch()`](https://corrr.tidymodels.org/reference/stretch.html) converts correction results from a tibble into a long format.

*Visualizations*:

-   The [`rplot()`](https://corrr.tidymodels.org/reference/rplot.html) function plots correlation results
-   The [`network_plot()`](https://corrr.tidymodels.org/reference/network_plot.html) function plots a point for each variable, joined by paths for correlations

Let use the [`stretch()`](https://corrr.tidymodels.org/reference/stretch.html) function to convert our correlation results `penguins_cor` into a long format:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_cor</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://corrr.tidymodels.org/reference/stretch.html'>stretch</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 16 × 3</span></span>
<span class='c'>#&gt;    x                 y                      r</span>
<span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>             <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span> bill_length_mm    bill_length_mm    <span style='color: #BB0000;'>NA</span>    </span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span> bill_length_mm    bill_depth_mm     -<span style='color: #BB0000;'>0.235</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span> bill_length_mm    flipper_length_mm  0.656</span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span> bill_length_mm    body_mass_g        0.595</span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span> bill_depth_mm     bill_length_mm    -<span style='color: #BB0000;'>0.235</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span> bill_depth_mm     bill_depth_mm     <span style='color: #BB0000;'>NA</span>    </span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span> bill_depth_mm     flipper_length_mm -<span style='color: #BB0000;'>0.584</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span> bill_depth_mm     body_mass_g       -<span style='color: #BB0000;'>0.472</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span> flipper_length_mm bill_length_mm     0.656</span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span> flipper_length_mm bill_depth_mm     -<span style='color: #BB0000;'>0.584</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>11</span> flipper_length_mm flipper_length_mm <span style='color: #BB0000;'>NA</span>    </span>
<span class='c'>#&gt; <span style='color: #555555;'>12</span> flipper_length_mm body_mass_g        0.871</span>
<span class='c'>#&gt; <span style='color: #555555;'>13</span> body_mass_g       bill_length_mm     0.595</span>
<span class='c'>#&gt; <span style='color: #555555;'>14</span> body_mass_g       bill_depth_mm     -<span style='color: #BB0000;'>0.472</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>15</span> body_mass_g       flipper_length_mm  0.871</span>
<span class='c'>#&gt; <span style='color: #555555;'>16</span> body_mass_g       body_mass_g       <span style='color: #BB0000;'>NA</span></span></code></pre>

</div>

You can see that the results are coverted into a long format.

We can also select a column we are interested in. Let us select only correlation between "bill_depth_mm" and the rest of the variables.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_cor</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://corrr.tidymodels.org/reference/focus.html'>focus</a></span><span class='o'>(</span><span class='s'>"bill_depth_mm"</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 2</span></span>
<span class='c'>#&gt;   term              bill_depth_mm</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> bill_length_mm           -<span style='color: #BB0000;'>0.235</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> flipper_length_mm        -<span style='color: #BB0000;'>0.584</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> body_mass_g              -<span style='color: #BB0000;'>0.472</span></span></code></pre>

</div>

You can see that we selected only the correlations between `bill_depth_mm` and other variables.

We can now visualize the results:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_cor</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://corrr.tidymodels.org/reference/rearrange.html'>rearrange</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>   <span class='c'># Rearrange based on correlation strengths</span>
  <span class='nf'><a href='https://corrr.tidymodels.org/reference/rplot.html'>rplot</a></span><span class='o'>(</span><span class='o'>)</span>           <span class='c'># Plot</span>
<span class='c'>#&gt; Don't know how to automatically pick scale for object of type noquote. Defaulting to continuous.</span>
</code></pre>
<img src="figs/unnamed-chunk-15-1.png" width="700px" style="display: block; margin: auto;" />

</div>

We plotted based on correlation strengths.

<br>

------------------------------------------------------------------------

<div class="puzzle">

<div>

## Breakout session 2

Use the dataframe (`penguins_biscoe`) you created in Breakout session 1 to:

-   Calculate correlations among the variables, and present the results in a long format

-   Select the correlations that include `year`

-   Plot a correlation graph based on correlation strengths

<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>biscoe_cor</span> <span class='o'>&lt;-</span> <span class='nv'>penguins_biscoe</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>bill_length_mm</span>, <span class='nv'>bill_depth_mm</span>, <span class='nv'>flipper_length_mm</span>, <span class='nv'>year</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://corrr.tidymodels.org/reference/correlate.html'>correlate</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Correlation method: 'pearson'</span>
<span class='c'>#&gt; Missing treated using: 'pairwise.complete.obs'</span>

<span class='nv'>biscoe_cor</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://corrr.tidymodels.org/reference/stretch.html'>stretch</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 16 × 3</span></span>
<span class='c'>#&gt;    x                 y                       r</span>
<span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>             <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>               <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span> bill_length_mm    bill_length_mm    <span style='color: #BB0000;'>NA</span>     </span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span> bill_length_mm    bill_depth_mm     -<span style='color: #BB0000;'>0.444</span> </span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span> bill_length_mm    flipper_length_mm  0.866 </span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span> bill_length_mm    year               0.096<span style='text-decoration: underline;'>8</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span> bill_depth_mm     bill_length_mm    -<span style='color: #BB0000;'>0.444</span> </span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span> bill_depth_mm     bill_depth_mm     <span style='color: #BB0000;'>NA</span>     </span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span> bill_depth_mm     flipper_length_mm -<span style='color: #BB0000;'>0.579</span> </span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span> bill_depth_mm     year               0.138 </span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span> flipper_length_mm bill_length_mm     0.866 </span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span> flipper_length_mm bill_depth_mm     -<span style='color: #BB0000;'>0.579</span> </span>
<span class='c'>#&gt; <span style='color: #555555;'>11</span> flipper_length_mm flipper_length_mm <span style='color: #BB0000;'>NA</span>     </span>
<span class='c'>#&gt; <span style='color: #555555;'>12</span> flipper_length_mm year               0.105 </span>
<span class='c'>#&gt; <span style='color: #555555;'>13</span> year              bill_length_mm     0.096<span style='text-decoration: underline;'>8</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>14</span> year              bill_depth_mm      0.138 </span>
<span class='c'>#&gt; <span style='color: #555555;'>15</span> year              flipper_length_mm  0.105 </span>
<span class='c'>#&gt; <span style='color: #555555;'>16</span> year              year              <span style='color: #BB0000;'>NA</span></span></code></pre>

</div>

You can see that results are in a long format.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>biscoe_cor</span> <span class='o'>%&gt;%</span>
   <span class='nf'><a href='https://corrr.tidymodels.org/reference/focus.html'>focus</a></span><span class='o'>(</span><span class='s'>"year"</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 2</span></span>
<span class='c'>#&gt;   term                year</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> bill_length_mm    0.096<span style='text-decoration: underline;'>8</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> bill_depth_mm     0.138 </span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> flipper_length_mm 0.105</span></code></pre>

</div>

Correlations with `year`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>biscoe_cor</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://corrr.tidymodels.org/reference/rearrange.html'>rearrange</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://corrr.tidymodels.org/reference/rplot.html'>rplot</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; Don't know how to automatically pick scale for object of type noquote. Defaulting to continuous.</span>
</code></pre>
<img src="figs/unnamed-chunk-18-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

</div>

<br>

