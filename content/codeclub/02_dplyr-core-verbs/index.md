---
title: "Session 2: dplyr core verbs"
subtitle: "Using select, filter, mutate, arrange, and summarize"
summary: "During this second session of Code Club, we will be learning how to use some of the most popular dplyr one-table functions, including filter, select, mutate, arrange, and summarize."  
authors: [jessica-cooperstone]
date: 2020-11-25
output: hugodown::md_document
toc: true

image: 
  caption: "Artwork by @allison_horst"
  focal_point: ""
  preview_only: false

rmd_hash: eca3ce58a4cb4b3b

---

<br> <br> <br>

------------------------------------------------------------------------

Prep homework
-------------

### Basic computer setup

-   If you didn't already do this, please follow the [Code Club Computer Setup](/codeclub-setup/) instructions, which also has pointers for if you're new to R or RStudio.

-   If you're able to do so, please open RStudio a bit before Code Club starts -- and in case you run into issues, please join the Zoom call early and we'll troubleshoot.

### New to dplyr?

If you've never used `dplyr` before (or even if you have), you may find [this cheat sheet](https://github.com/rstudio/cheatsheets/blob/master/data-transformation.pdf) useful.

<br>

----
----

### Want to download an R script with the content from todays session?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'>
<span class='nv'>todays_R_script</span> <span class='o'>&lt;-</span> <span class='s'>'https://raw.githubusercontent.com/biodash/biodash.github.io/master/content/codeclub/02_dplyr-core-verbs/2_Dplyr_one-table_verbs.R'</span>

<span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span><span class='nv'>todays_R_script</span><span class='o'>)</span>
</code></pre>

</div>

<br>

------------------------------------------------------------------------

1 - What is data wrangling?
---------------------------

It has been estimated that the process of getting your data into the appropriate formats ttakes about 80% of the total time of analysis. We will talk about formatting as tidy data (e.g., such that each column is a single variable, each row is a single observation, and each cell is a single value, you can learn more about tidy data [here](https://r4ds.had.co.nz/tidy-data.html)) in a future session of Code Club.

The package [`dplyr`](https://dplyr.tidyverse.org/), as part of the [`tidyverse`](https://www.rdocumentation.org/packages/tidyverse/versions/1.3.0) has a number of very helpful functions that will help you get your data into a format suitable for your analysis.

<br>

<div class="alert alert-note">

<div>

**What will we go over today**

These five core `dplyr()` verbs will help you get wrangling.

-   [`select()`](https://dplyr.tidyverse.org/reference/select.html) - picks variables (i.e., columns) based on their names
-   [`filter()`](https://dplyr.tidyverse.org/reference/filter.html) - picks observations (i.e., rows) based on their values
-   [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) - makes new variables, keeps existing columns
-   [`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html) - sorts rows based on values in columns
-   [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html) - reduces values down to a summary form

</div>

</div>

<br>

------------------------------------------------------------------------

2 - Get ready to wrangle
------------------------

**Let's get set up and grab some data so that we can get familiar with these verbs**

-   You can do this locally, or at OSC. You can find instructions if you are having trouble [here](/codeclub-setup/).

First load your libraries.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>

<span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching packages</span><span> ─────────────────────────────────────── tidyverse 1.3.0 ──</span></span>

<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>ggplot2</span><span> 3.3.2     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>purrr  </span><span> 0.3.4</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>tibble </span><span> 3.0.4     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>dplyr  </span><span> 1.0.2</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>tidyr  </span><span> 1.1.2     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>stringr</span><span> 1.4.0</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>readr  </span><span> 1.4.0     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>forcats</span><span> 0.5.0</span></span>

<span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span><span> ────────────────────────────────────────── tidyverse_conflicts() ──</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>filter()</span><span> masks </span><span style='color: #0000BB;'>stats</span><span>::filter()</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>lag()</span><span>    masks </span><span style='color: #0000BB;'>stats</span><span>::lag()</span></span>
</code></pre>

</div>

Then let's access the [iris](https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/iris.html) dataset that comes pre-loaded in base R. We will take that data frame and assign it to a new object called `iris_data`. Then we will look at our data.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>iris_data</span> <span class='o'>&lt;-</span> <span class='nv'>iris</span>

<span class='c'># look at the first 6 rows, all columns</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>iris_data</span><span class='o'>)</span>

<span class='c'>#&gt;   Sepal.Length Sepal.Width Petal.Length Petal.Width Species</span>
<span class='c'>#&gt; 1          5.1         3.5          1.4         0.2  setosa</span>
<span class='c'>#&gt; 2          4.9         3.0          1.4         0.2  setosa</span>
<span class='c'>#&gt; 3          4.7         3.2          1.3         0.2  setosa</span>
<span class='c'>#&gt; 4          4.6         3.1          1.5         0.2  setosa</span>
<span class='c'>#&gt; 5          5.0         3.6          1.4         0.2  setosa</span>
<span class='c'>#&gt; 6          5.4         3.9          1.7         0.4  setosa</span>


<span class='c'># check the structure of iris_data</span>
<span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>iris_data</span><span class='o'>)</span>

<span class='c'>#&gt; Rows: 150</span>
<span class='c'>#&gt; Columns: 5</span>
<span class='c'>#&gt; $ Sepal.Length <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 5.1, 4.9, 4.7, 4.6, 5.0, 5.4, 4.6, 5.0, 4.4, 4.9, 5.4, 4…</span></span>
<span class='c'>#&gt; $ Sepal.Width  <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 3.5, 3.0, 3.2, 3.1, 3.6, 3.9, 3.4, 3.4, 2.9, 3.1, 3.7, 3…</span></span>
<span class='c'>#&gt; $ Petal.Length <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 1.4, 1.4, 1.3, 1.5, 1.4, 1.7, 1.4, 1.5, 1.4, 1.5, 1.5, 1…</span></span>
<span class='c'>#&gt; $ Petal.Width  <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 0.2, 0.2, 0.2, 0.2, 0.2, 0.4, 0.3, 0.2, 0.2, 0.1, 0.2, 0…</span></span>
<span class='c'>#&gt; $ Species      <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> setosa, setosa, setosa, setosa, setosa, setosa, setosa, …</span></span>
</code></pre>

</div>

This dataset contains the measurements (in cm) of `Sepal.Length`, `Sepal.Width`, `Petal.Length`, and `Petal.Width` for three different `Species` of iris, setosa, versicolor, and virginica.

<br>

------------------------------------------------------------------------

3 - Using `select()`
--------------------

`select()` allows you to pick certain columns to be included in your data frame.

We will create a dew data frame called iris\_petals\_species that includes the columns `Species`, `Petal.Length` and `Petal.Width`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>iris_petals_species</span> <span class='o'>&lt;-</span> <span class='nv'>iris_data</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>Species</span>, <span class='nv'>Petal.Length</span>, <span class='nv'>Petal.Width</span><span class='o'>)</span>
</code></pre>

</div>

What does our new data frame look like?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>iris_petals_species</span><span class='o'>)</span>

<span class='c'>#&gt;   Species Petal.Length Petal.Width</span>
<span class='c'>#&gt; 1  setosa          1.4         0.2</span>
<span class='c'>#&gt; 2  setosa          1.4         0.2</span>
<span class='c'>#&gt; 3  setosa          1.3         0.2</span>
<span class='c'>#&gt; 4  setosa          1.5         0.2</span>
<span class='c'>#&gt; 5  setosa          1.4         0.2</span>
<span class='c'>#&gt; 6  setosa          1.7         0.4</span>
</code></pre>

</div>

**Note - look what happened to the order of the columns!**

<div class="alert alert-warning">

**This is not the only way to select columns.**

You could also subset by indexing with the square brackets, but you can see how much more readable using `select()` is. It's nice not to have to refer back to remember what column is which index.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>iris_data_indexing</span> <span class='o'>&lt;-</span> <span class='nv'>iris_data</span><span class='o'>[</span>,<span class='m'>3</span><span class='o'>:</span><span class='m'>5</span><span class='o'>]</span>

<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>iris_data_indexing</span><span class='o'>)</span>

<span class='c'>#&gt;   Petal.Length Petal.Width Species</span>
<span class='c'>#&gt; 1          1.4         0.2  setosa</span>
<span class='c'>#&gt; 2          1.4         0.2  setosa</span>
<span class='c'>#&gt; 3          1.3         0.2  setosa</span>
<span class='c'>#&gt; 4          1.5         0.2  setosa</span>
<span class='c'>#&gt; 5          1.4         0.2  setosa</span>
<span class='c'>#&gt; 6          1.7         0.4  setosa</span>
</code></pre>

</div>

</div>

<br>

------------------------------------------------------------------------

4 - Using [`filter()`](https://rdrr.io/r/stats/filter.html)
--------------------

![Artwork by @allison\_horst](https://raw.githubusercontent.com/allisonhorst/stats-illustrations/master/rstats-artwork/dplyr_filter.jpg) Artwork by \[@allison\_horst\](<a href="https://github.com/allisonhorst/stats-illustrations" class="uri">https://github.com/allisonhorst/stats-illustrations</a>).

[`filter()`](https://rdrr.io/r/stats/filter.html) allows you to pick certain obsevations (i.e, rows) based on their values to be included in your data frame.

We will create a new data frame that only includes information about the irises where their `Species` is setosa.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>iris_setosa</span> <span class='o'>&lt;-</span> <span class='nv'>iris_data</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>Species</span> <span class='o'>==</span> <span class='s'>"setosa"</span><span class='o'>)</span>
</code></pre>

</div>

Let's check the dimensions of our data frame. Remember, our whole data set is 150 observations, and we are expecting 50 observations per `Species`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>iris_setosa</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 50  5</span>
</code></pre>

</div>

<br>

------------------------------------------------------------------------

5 - Using `mutate()`
--------------------

![Artwork by @allison\_horst](https://raw.github.com/allisonhorst/stats-illustrations/master/rstats-artwork/dplyr_mutate.png) Artwork by \[@allison\_horst\](<a href="https://github.com/allisonhorst/stats-illustrations" class="uri">https://github.com/allisonhorst/stats-illustrations</a>).

`mutate()` allows you to make new variables, while keeping all your existing columns.

Let's make a new column that is the ratio of `Sepal.Length`/`Sepal.Width`

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>iris_sepal_length_to_width</span> <span class='o'>&lt;-</span> <span class='nv'>iris_data</span> <span class='o'>%&gt;%</span>
  <span class='nf'>mutate</span><span class='o'>(</span>Sepal.Length_div_Sepal.Width <span class='o'>=</span> <span class='nv'>Sepal.Length</span><span class='o'>/</span><span class='nv'>Sepal.Width</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>iris_sepal_length_to_width</span><span class='o'>)</span>

<span class='c'>#&gt;   Sepal.Length Sepal.Width Petal.Length Petal.Width Species</span>
<span class='c'>#&gt; 1          5.1         3.5          1.4         0.2  setosa</span>
<span class='c'>#&gt; 2          4.9         3.0          1.4         0.2  setosa</span>
<span class='c'>#&gt; 3          4.7         3.2          1.3         0.2  setosa</span>
<span class='c'>#&gt; 4          4.6         3.1          1.5         0.2  setosa</span>
<span class='c'>#&gt; 5          5.0         3.6          1.4         0.2  setosa</span>
<span class='c'>#&gt; 6          5.4         3.9          1.7         0.4  setosa</span>
<span class='c'>#&gt;   Sepal.Length_div_Sepal.Width</span>
<span class='c'>#&gt; 1                     1.457143</span>
<span class='c'>#&gt; 2                     1.633333</span>
<span class='c'>#&gt; 3                     1.468750</span>
<span class='c'>#&gt; 4                     1.483871</span>
<span class='c'>#&gt; 5                     1.388889</span>
<span class='c'>#&gt; 6                     1.384615</span>
</code></pre>

</div>

**Note -- see the new column location**

<br>

------------------------------------------------------------------------

6 - Using `arrange()`
---------------------

Very often you will want to order your data frame by some values. To do this, you can use `arrange()`.

Let's arrange the values in our `iris_data` by `Sepal.Length`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>iris_data</span> <span class='o'>%&gt;%</span>
  <span class='nf'>arrange</span><span class='o'>(</span><span class='nv'>Sepal.Length</span><span class='o'>)</span>

<span class='c'>#&gt;     Sepal.Length Sepal.Width Petal.Length Petal.Width    Species</span>
<span class='c'>#&gt; 1            4.3         3.0          1.1         0.1     setosa</span>
<span class='c'>#&gt; 2            4.4         2.9          1.4         0.2     setosa</span>
<span class='c'>#&gt; 3            4.4         3.0          1.3         0.2     setosa</span>
<span class='c'>#&gt; 4            4.4         3.2          1.3         0.2     setosa</span>
<span class='c'>#&gt; 5            4.5         2.3          1.3         0.3     setosa</span>
<span class='c'>#&gt; 6            4.6         3.1          1.5         0.2     setosa</span>
<span class='c'>#&gt; 7            4.6         3.4          1.4         0.3     setosa</span>
<span class='c'>#&gt; 8            4.6         3.6          1.0         0.2     setosa</span>
<span class='c'>#&gt; 9            4.6         3.2          1.4         0.2     setosa</span>
<span class='c'>#&gt; 10           4.7         3.2          1.3         0.2     setosa</span>
<span class='c'>#&gt; 11           4.7         3.2          1.6         0.2     setosa</span>
<span class='c'>#&gt; 12           4.8         3.4          1.6         0.2     setosa</span>
<span class='c'>#&gt; 13           4.8         3.0          1.4         0.1     setosa</span>
<span class='c'>#&gt; 14           4.8         3.4          1.9         0.2     setosa</span>
<span class='c'>#&gt; 15           4.8         3.1          1.6         0.2     setosa</span>
<span class='c'>#&gt; 16           4.8         3.0          1.4         0.3     setosa</span>
<span class='c'>#&gt; 17           4.9         3.0          1.4         0.2     setosa</span>
<span class='c'>#&gt; 18           4.9         3.1          1.5         0.1     setosa</span>
<span class='c'>#&gt; 19           4.9         3.1          1.5         0.2     setosa</span>
<span class='c'>#&gt; 20           4.9         3.6          1.4         0.1     setosa</span>
<span class='c'>#&gt; 21           4.9         2.4          3.3         1.0 versicolor</span>
<span class='c'>#&gt; 22           4.9         2.5          4.5         1.7  virginica</span>
<span class='c'>#&gt; 23           5.0         3.6          1.4         0.2     setosa</span>
<span class='c'>#&gt; 24           5.0         3.4          1.5         0.2     setosa</span>
<span class='c'>#&gt; 25           5.0         3.0          1.6         0.2     setosa</span>
<span class='c'>#&gt; 26           5.0         3.4          1.6         0.4     setosa</span>
<span class='c'>#&gt; 27           5.0         3.2          1.2         0.2     setosa</span>
<span class='c'>#&gt; 28           5.0         3.5          1.3         0.3     setosa</span>
<span class='c'>#&gt; 29           5.0         3.5          1.6         0.6     setosa</span>
<span class='c'>#&gt; 30           5.0         3.3          1.4         0.2     setosa</span>
<span class='c'>#&gt; 31           5.0         2.0          3.5         1.0 versicolor</span>
<span class='c'>#&gt; 32           5.0         2.3          3.3         1.0 versicolor</span>
<span class='c'>#&gt; 33           5.1         3.5          1.4         0.2     setosa</span>
<span class='c'>#&gt; 34           5.1         3.5          1.4         0.3     setosa</span>
<span class='c'>#&gt; 35           5.1         3.8          1.5         0.3     setosa</span>
<span class='c'>#&gt; 36           5.1         3.7          1.5         0.4     setosa</span>
<span class='c'>#&gt; 37           5.1         3.3          1.7         0.5     setosa</span>
<span class='c'>#&gt; 38           5.1         3.4          1.5         0.2     setosa</span>
<span class='c'>#&gt; 39           5.1         3.8          1.9         0.4     setosa</span>
<span class='c'>#&gt; 40           5.1         3.8          1.6         0.2     setosa</span>
<span class='c'>#&gt; 41           5.1         2.5          3.0         1.1 versicolor</span>
<span class='c'>#&gt; 42           5.2         3.5          1.5         0.2     setosa</span>
<span class='c'>#&gt; 43           5.2         3.4          1.4         0.2     setosa</span>
<span class='c'>#&gt; 44           5.2         4.1          1.5         0.1     setosa</span>
<span class='c'>#&gt; 45           5.2         2.7          3.9         1.4 versicolor</span>
<span class='c'>#&gt; 46           5.3         3.7          1.5         0.2     setosa</span>
<span class='c'>#&gt; 47           5.4         3.9          1.7         0.4     setosa</span>
<span class='c'>#&gt; 48           5.4         3.7          1.5         0.2     setosa</span>
<span class='c'>#&gt; 49           5.4         3.9          1.3         0.4     setosa</span>
<span class='c'>#&gt; 50           5.4         3.4          1.7         0.2     setosa</span>
<span class='c'>#&gt; 51           5.4         3.4          1.5         0.4     setosa</span>
<span class='c'>#&gt; 52           5.4         3.0          4.5         1.5 versicolor</span>
<span class='c'>#&gt; 53           5.5         4.2          1.4         0.2     setosa</span>
<span class='c'>#&gt; 54           5.5         3.5          1.3         0.2     setosa</span>
<span class='c'>#&gt; 55           5.5         2.3          4.0         1.3 versicolor</span>
<span class='c'>#&gt; 56           5.5         2.4          3.8         1.1 versicolor</span>
<span class='c'>#&gt; 57           5.5         2.4          3.7         1.0 versicolor</span>
<span class='c'>#&gt; 58           5.5         2.5          4.0         1.3 versicolor</span>
<span class='c'>#&gt; 59           5.5         2.6          4.4         1.2 versicolor</span>
<span class='c'>#&gt; 60           5.6         2.9          3.6         1.3 versicolor</span>
<span class='c'>#&gt; 61           5.6         3.0          4.5         1.5 versicolor</span>
<span class='c'>#&gt; 62           5.6         2.5          3.9         1.1 versicolor</span>
<span class='c'>#&gt; 63           5.6         3.0          4.1         1.3 versicolor</span>
<span class='c'>#&gt; 64           5.6         2.7          4.2         1.3 versicolor</span>
<span class='c'>#&gt; 65           5.6         2.8          4.9         2.0  virginica</span>
<span class='c'>#&gt; 66           5.7         4.4          1.5         0.4     setosa</span>
<span class='c'>#&gt; 67           5.7         3.8          1.7         0.3     setosa</span>
<span class='c'>#&gt; 68           5.7         2.8          4.5         1.3 versicolor</span>
<span class='c'>#&gt; 69           5.7         2.6          3.5         1.0 versicolor</span>
<span class='c'>#&gt; 70           5.7         3.0          4.2         1.2 versicolor</span>
<span class='c'>#&gt; 71           5.7         2.9          4.2         1.3 versicolor</span>
<span class='c'>#&gt; 72           5.7         2.8          4.1         1.3 versicolor</span>
<span class='c'>#&gt; 73           5.7         2.5          5.0         2.0  virginica</span>
<span class='c'>#&gt; 74           5.8         4.0          1.2         0.2     setosa</span>
<span class='c'>#&gt; 75           5.8         2.7          4.1         1.0 versicolor</span>
<span class='c'>#&gt; 76           5.8         2.7          3.9         1.2 versicolor</span>
<span class='c'>#&gt; 77           5.8         2.6          4.0         1.2 versicolor</span>
<span class='c'>#&gt; 78           5.8         2.7          5.1         1.9  virginica</span>
<span class='c'>#&gt; 79           5.8         2.8          5.1         2.4  virginica</span>
<span class='c'>#&gt; 80           5.8         2.7          5.1         1.9  virginica</span>
<span class='c'>#&gt; 81           5.9         3.0          4.2         1.5 versicolor</span>
<span class='c'>#&gt; 82           5.9         3.2          4.8         1.8 versicolor</span>
<span class='c'>#&gt; 83           5.9         3.0          5.1         1.8  virginica</span>
<span class='c'>#&gt; 84           6.0         2.2          4.0         1.0 versicolor</span>
<span class='c'>#&gt; 85           6.0         2.9          4.5         1.5 versicolor</span>
<span class='c'>#&gt; 86           6.0         2.7          5.1         1.6 versicolor</span>
<span class='c'>#&gt; 87           6.0         3.4          4.5         1.6 versicolor</span>
<span class='c'>#&gt; 88           6.0         2.2          5.0         1.5  virginica</span>
<span class='c'>#&gt; 89           6.0         3.0          4.8         1.8  virginica</span>
<span class='c'>#&gt; 90           6.1         2.9          4.7         1.4 versicolor</span>
<span class='c'>#&gt; 91           6.1         2.8          4.0         1.3 versicolor</span>
<span class='c'>#&gt; 92           6.1         2.8          4.7         1.2 versicolor</span>
<span class='c'>#&gt; 93           6.1         3.0          4.6         1.4 versicolor</span>
<span class='c'>#&gt; 94           6.1         3.0          4.9         1.8  virginica</span>
<span class='c'>#&gt; 95           6.1         2.6          5.6         1.4  virginica</span>
<span class='c'>#&gt; 96           6.2         2.2          4.5         1.5 versicolor</span>
<span class='c'>#&gt; 97           6.2         2.9          4.3         1.3 versicolor</span>
<span class='c'>#&gt; 98           6.2         2.8          4.8         1.8  virginica</span>
<span class='c'>#&gt; 99           6.2         3.4          5.4         2.3  virginica</span>
<span class='c'>#&gt; 100          6.3         3.3          4.7         1.6 versicolor</span>
<span class='c'>#&gt; 101          6.3         2.5          4.9         1.5 versicolor</span>
<span class='c'>#&gt; 102          6.3         2.3          4.4         1.3 versicolor</span>
<span class='c'>#&gt; 103          6.3         3.3          6.0         2.5  virginica</span>
<span class='c'>#&gt; 104          6.3         2.9          5.6         1.8  virginica</span>
<span class='c'>#&gt; 105          6.3         2.7          4.9         1.8  virginica</span>
<span class='c'>#&gt; 106          6.3         2.8          5.1         1.5  virginica</span>
<span class='c'>#&gt; 107          6.3         3.4          5.6         2.4  virginica</span>
<span class='c'>#&gt; 108          6.3         2.5          5.0         1.9  virginica</span>
<span class='c'>#&gt; 109          6.4         3.2          4.5         1.5 versicolor</span>
<span class='c'>#&gt; 110          6.4         2.9          4.3         1.3 versicolor</span>
<span class='c'>#&gt; 111          6.4         2.7          5.3         1.9  virginica</span>
<span class='c'>#&gt; 112          6.4         3.2          5.3         2.3  virginica</span>
<span class='c'>#&gt; 113          6.4         2.8          5.6         2.1  virginica</span>
<span class='c'>#&gt; 114          6.4         2.8          5.6         2.2  virginica</span>
<span class='c'>#&gt; 115          6.4         3.1          5.5         1.8  virginica</span>
<span class='c'>#&gt; 116          6.5         2.8          4.6         1.5 versicolor</span>
<span class='c'>#&gt; 117          6.5         3.0          5.8         2.2  virginica</span>
<span class='c'>#&gt; 118          6.5         3.2          5.1         2.0  virginica</span>
<span class='c'>#&gt; 119          6.5         3.0          5.5         1.8  virginica</span>
<span class='c'>#&gt; 120          6.5         3.0          5.2         2.0  virginica</span>
<span class='c'>#&gt; 121          6.6         2.9          4.6         1.3 versicolor</span>
<span class='c'>#&gt; 122          6.6         3.0          4.4         1.4 versicolor</span>
<span class='c'>#&gt; 123          6.7         3.1          4.4         1.4 versicolor</span>
<span class='c'>#&gt; 124          6.7         3.0          5.0         1.7 versicolor</span>
<span class='c'>#&gt; 125          6.7         3.1          4.7         1.5 versicolor</span>
<span class='c'>#&gt; 126          6.7         2.5          5.8         1.8  virginica</span>
<span class='c'>#&gt; 127          6.7         3.3          5.7         2.1  virginica</span>
<span class='c'>#&gt; 128          6.7         3.1          5.6         2.4  virginica</span>
<span class='c'>#&gt; 129          6.7         3.3          5.7         2.5  virginica</span>
<span class='c'>#&gt; 130          6.7         3.0          5.2         2.3  virginica</span>
<span class='c'>#&gt; 131          6.8         2.8          4.8         1.4 versicolor</span>
<span class='c'>#&gt; 132          6.8         3.0          5.5         2.1  virginica</span>
<span class='c'>#&gt; 133          6.8         3.2          5.9         2.3  virginica</span>
<span class='c'>#&gt; 134          6.9         3.1          4.9         1.5 versicolor</span>
<span class='c'>#&gt; 135          6.9         3.2          5.7         2.3  virginica</span>
<span class='c'>#&gt; 136          6.9         3.1          5.4         2.1  virginica</span>
<span class='c'>#&gt; 137          6.9         3.1          5.1         2.3  virginica</span>
<span class='c'>#&gt; 138          7.0         3.2          4.7         1.4 versicolor</span>
<span class='c'>#&gt; 139          7.1         3.0          5.9         2.1  virginica</span>
<span class='c'>#&gt; 140          7.2         3.6          6.1         2.5  virginica</span>
<span class='c'>#&gt; 141          7.2         3.2          6.0         1.8  virginica</span>
<span class='c'>#&gt; 142          7.2         3.0          5.8         1.6  virginica</span>
<span class='c'>#&gt; 143          7.3         2.9          6.3         1.8  virginica</span>
<span class='c'>#&gt; 144          7.4         2.8          6.1         1.9  virginica</span>
<span class='c'>#&gt; 145          7.6         3.0          6.6         2.1  virginica</span>
<span class='c'>#&gt; 146          7.7         3.8          6.7         2.2  virginica</span>
<span class='c'>#&gt; 147          7.7         2.6          6.9         2.3  virginica</span>
<span class='c'>#&gt; 148          7.7         2.8          6.7         2.0  virginica</span>
<span class='c'>#&gt; 149          7.7         3.0          6.1         2.3  virginica</span>
<span class='c'>#&gt; 150          7.9         3.8          6.4         2.0  virginica</span>
</code></pre>

</div>

What if we want to arrange by `Sepal.Length`, but within `Species`? We can do that using the helper [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>iris_data</span> <span class='o'>%&gt;%</span>
  <span class='nf'>group_by</span><span class='o'>(</span><span class='nv'>Species</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>arrange</span><span class='o'>(</span><span class='nv'>Sepal.Length</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 150 x 5</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># Groups:   Species [3]</span></span>
<span class='c'>#&gt;    Sepal.Length Sepal.Width Petal.Length Petal.Width Species</span>
<span class='c'>#&gt;           <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>        </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span>          4.3         3            1.1         0.1 setosa </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span>          4.4         2.9          1.4         0.2 setosa </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span>          4.4         3            1.3         0.2 setosa </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span>          4.4         3.2          1.3         0.2 setosa </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span>          4.5         2.3          1.3         0.3 setosa </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span>          4.6         3.1          1.5         0.2 setosa </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span>          4.6         3.4          1.4         0.3 setosa </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span>          4.6         3.6          1           0.2 setosa </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span>          4.6         3.2          1.4         0.2 setosa </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span>          4.7         3.2          1.3         0.2 setosa </span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 140 more rows</span></span>
</code></pre>

</div>

<br>

------------------------------------------------------------------------

7 - Using `summarize()`
-----------------------

By using `summarize()`, you can create a new data frame that has the summary output you have requested.

We can calculate the mean `Sepal.Length` across our dataset.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>iris_data</span> <span class='o'>%&gt;%</span>
  <span class='nf'>summarize</span><span class='o'>(</span>mean <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>Sepal.Length</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt;       mean</span>
<span class='c'>#&gt; 1 5.843333</span>
</code></pre>

</div>

What if we want to calculate means within `Species`?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>iris_data</span> <span class='o'>%&gt;%</span>
  <span class='nf'>group_by</span><span class='o'>(</span><span class='nv'>Species</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>summarize</span><span class='o'>(</span>mean <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>Sepal.Length</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; `summarise()` ungrouping output (override with `.groups` argument)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 x 2</span></span>
<span class='c'>#&gt;   Species     mean</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>      </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> setosa      5.01</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> versicolor  5.94</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> virginica   6.59</span></span>
</code></pre>

</div>

We can integrate some helper functions into our code to simply get out a variety of outputs. We can use [`across()`](https://dplyr.tidyverse.org/reference/across.html) to apply our summary aross a set of columns. I really like this function.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>iris_data</span> <span class='o'>%&gt;%</span>
  <span class='nf'>group_by</span><span class='o'>(</span><span class='nv'>Species</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>summarize</span><span class='o'>(</span><span class='nf'>across</span><span class='o'>(</span><span class='nf'>where</span><span class='o'>(</span><span class='nv'>is.numeric</span><span class='o'>)</span>, <span class='nv'>mean</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; `summarise()` ungrouping output (override with `.groups` argument)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 x 5</span></span>
<span class='c'>#&gt;   Species    Sepal.Length Sepal.Width Petal.Length Petal.Width</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>             </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>        </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> setosa             5.01        3.43         1.46       0.246</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> versicolor         5.94        2.77         4.26       1.33 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> virginica          6.59        2.97         5.55       2.03</span></span>
</code></pre>

</div>

This can also be useful for counting observations per group. Here, how many iris observations do we have per `Species`?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>iris_data</span> <span class='o'>%&gt;%</span>
  <span class='nf'>group_by</span><span class='o'>(</span><span class='nv'>Species</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>tally</span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 x 2</span></span>
<span class='c'>#&gt;   Species        n</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>      </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> setosa        50</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> versicolor    50</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> virginica     50</span></span>
</code></pre>

</div>

<br>

------------------------------------------------------------------------

8 - Breakout rooms!
-------------------

### Read in data

Now you try! We are going to use the Great Backyard Birds dataset we downloaded two weeks ago and you will apply the functions we have learned above to investigate this dataset.

If you weren't here for [Session 1](/codeclub/01_backyard-birds/), get the birds data set.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># create a directory called S02</span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>'S02'</span><span class='o'>)</span>

<span class='c'>#&gt; Warning in dir.create("S02"): 'S02' already exists</span>


<span class='c'># within S02, create a directory called data, within, a directory called birds</span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>'data/birds/'</span>, recursive <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>

<span class='c'>#&gt; Warning in dir.create("data/birds/", recursive = TRUE): 'data/birds' already exists</span>
</code></pre>

</div>

Download the file from the internet.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># set the location of the file</span>
<span class='nv'>birds_file_url</span> <span class='o'>&lt;-</span> <span class='s'>'https://raw.githubusercontent.com/biodash/biodash.github.io/master/assets/data/birds/backyard-birds_Ohio.tsv'</span>

<span class='c'># set the path for the downloaded file</span>
<span class='nv'>birds_file</span> <span class='o'>&lt;-</span> <span class='s'>'data/birds/backyard-birds_Ohio.tsv'</span>

<span class='c'># download </span>
<span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>birds_file_url</span>, destfile <span class='o'>=</span> <span class='nv'>birds_file</span><span class='o'>)</span>
</code></pre>

</div>

If you were here for [Session 1](/codeclub/01_backyard-birds/), join back in! Let's read in our data.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>birds_file</span> <span class='o'>&lt;-</span> <span class='s'>'data/birds/backyard-birds_Ohio.tsv'</span>
<span class='nv'>birds</span> <span class='o'>&lt;-</span> <span class='nf'>read_tsv</span><span class='o'>(</span><span class='nv'>birds_file</span><span class='o'>)</span>

<span class='c'>#&gt; </span>
<span class='c'>#&gt; <span style='color: #00BBBB;'>──</span><span> </span><span style='font-weight: bold;'>Column specification</span><span> </span><span style='color: #00BBBB;'>────────────────────────────────────────────────────────</span></span>
<span class='c'>#&gt; cols(</span>
<span class='c'>#&gt;   class = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   order = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   family = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   genus = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   species = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   locality = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   stateProvince = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   decimalLatitude = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   decimalLongitude = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   eventDate = <span style='color: #0000BB;'>col_datetime(format = "")</span><span>,</span></span>
<span class='c'>#&gt;   species_en = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   range = <span style='color: #BB0000;'>col_character()</span></span>
<span class='c'>#&gt; )</span>
</code></pre>

</div>

Exercises
=========

Below you can find our breakout room exercises for today.

### Take a look at the data

<div class="alert puzzle">

<div>

Investigate the structure of the birds dataset.

<details>
<summary> Solution (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>)</span>

<span class='c'>#&gt; Rows: 311,441</span>
<span class='c'>#&gt; Columns: 12</span>
<span class='c'>#&gt; $ class            <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Aves", "Aves", "Aves", "Aves", "Aves", "Aves", "Ave…</span></span>
<span class='c'>#&gt; $ order            <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Passeriformes", "Passeriformes", "Passeriformes", "…</span></span>
<span class='c'>#&gt; $ family           <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Corvidae", "Corvidae", "Corvidae", "Corvidae", "Cor…</span></span>
<span class='c'>#&gt; $ genus            <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Cyanocitta", "Cyanocitta", "Cyanocitta", "Cyanocitt…</span></span>
<span class='c'>#&gt; $ species          <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Cyanocitta cristata", "Cyanocitta cristata", "Cyano…</span></span>
<span class='c'>#&gt; $ locality         <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "44805 Ashland", "45244 Cincinnati", "44132 Euclid",…</span></span>
<span class='c'>#&gt; $ stateProvince    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Ohio", "Ohio", "Ohio", "Ohio", "Ohio", "Ohio", "Ohi…</span></span>
<span class='c'>#&gt; $ decimalLatitude  <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 40.86166, 39.10666, 41.60768, 39.24236, 39.28207, 41…</span></span>
<span class='c'>#&gt; $ decimalLongitude <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> -82.31558, -84.32972, -81.50085, -84.35545, -84.4688…</span></span>
<span class='c'>#&gt; $ eventDate        <span style='color: #555555;font-style: italic;'>&lt;dttm&gt;</span><span> 2007-02-16, 2007-02-17, 2007-02-17, 2007-02-19, 200…</span></span>
<span class='c'>#&gt; $ species_en       <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Blue Jay", "Blue Jay", "Blue Jay", "Blue Jay", "Blu…</span></span>
<span class='c'>#&gt; $ range            <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
</code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

### Create new columns

<div class="alert puzzle">

<div>

Create a new data frame that removes the column `range`.

<details>
<summary> Hints (click here) </summary> Try using select(). Remember, you can tell select() what you want to keep, and what you want to remove. <br>
</details>
<details>
<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>birds_no_range</span> <span class='o'>&lt;-</span> <span class='nv'>birds</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='o'>-</span><span class='nv'>range</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>birds_no_range</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 11</span></span>
<span class='c'>#&gt;   class order family genus species locality stateProvince decimalLatitude</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>    </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                   </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Aves  Pass… Corvi… Cyan… Cyanoc… 44805 A… Ohio                     40.9</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Aves  Pass… Corvi… Cyan… Cyanoc… 45244 C… Ohio                     39.1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Aves  Pass… Corvi… Cyan… Cyanoc… 44132 E… Ohio                     41.6</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Aves  Pass… Corvi… Cyan… Cyanoc… 45242 C… Ohio                     39.2</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> Aves  Pass… Corvi… Cyan… Cyanoc… 45246 C… Ohio                     39.3</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> Aves  Pass… Corvi… Cyan… Cyanoc… 44484 W… Ohio                     41.2</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 3 more variables: decimalLongitude </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, eventDate </span><span style='color: #555555;font-style: italic;'>&lt;dttm&gt;</span><span style='color: #555555;'>,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   species_en </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span></span>
</code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### Find number of unique birds

<div class="alert puzzle">

<div>

How many unique species of birds have been observed?.

<details>
<summary> Hints (click here) </summary> Try using summarize() with a group\_by() helper. <br>
</details>
<details>
<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># using a combo of group_by() and summarize()</span>
<span class='nv'>unique_birds</span> <span class='o'>&lt;-</span> <span class='nv'>birds</span> <span class='o'>%&gt;%</span>
  <span class='nf'>group_by</span><span class='o'>(</span><span class='nv'>species_en</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>summarize</span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#&gt; `summarise()` ungrouping output (override with `.groups` argument)</span>


<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>unique_birds</span><span class='o'>)</span> <span class='c'># question - are there really 170 different birds observed?  take a look at this summary</span>

<span class='c'>#&gt; [1] 170   1</span>


<span class='c'># a one line, base R approach</span>
<span class='nf'><a href='https://rdrr.io/r/base/length.html'>length</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/unique.html'>unique</a></span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>$</span><span class='nv'>species_en</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 170</span>
</code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### How rare are Bald Eagle sightings?

<div class="alert puzzle">

<div>

How many times have Bald Eagles been observed?.

<details>
<summary> Hints (click here) </summary> Try using filter(). Remember the syntax you need to use to indicate you are looking for a Bald Eagle. <br>
</details>
<details>
<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>birds_bald_eagle</span> <span class='o'>&lt;-</span> <span class='nv'>birds</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>species_en</span> <span class='o'>==</span> <span class='s'>"Bald Eagle"</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>birds_bald_eagle</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 381  12</span>
</code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### How rare are all eagle sightings?

<div class="alert puzzle">

<div>

How many times have any kind of eagle been observed?. Group hint: there are only Bald Eagle and Golden Eagle in this dataset.

<details>
<summary> Hints (click here) </summary> There is a way to denote OR within filter(). <br>
</details>
<details>
<summary> More Hints (click here) </summary> You denote OR by using the vertical bar. <br>
</details>
<details>
<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>birds_alleagles</span> <span class='o'>&lt;-</span> <span class='nv'>birds</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>species_en</span> <span class='o'>==</span> <span class='s'>"Bald Eagle"</span> <span class='o'>|</span> <span class='nv'>species_en</span> <span class='o'>==</span> <span class='s'>"Golden Eagle"</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>birds_alleagles</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 386  12</span>
</code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### North-est bird location?

<div class="alert puzzle">

<div>

What is the north most location of the bird observations in Ohio?

<details>
<summary> Hints (click here) </summary> Try using arrange(). Remember that you can arrange in both ascending and descending order. You can also use your Ohio knowledge to check if you've done this correctly. <br>
</details>
<details>
<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>birds_sort_lat</span> <span class='o'>&lt;-</span> <span class='nv'>birds</span> <span class='o'>%&gt;%</span>
  <span class='nf'>arrange</span><span class='o'>(</span><span class='o'>-</span><span class='nv'>decimalLatitude</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>birds_sort_lat</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 12</span></span>
<span class='c'>#&gt;   class order family genus species locality stateProvince decimalLatitude</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>    </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                   </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Aves  Pass… Cardi… Card… Cardin… Conneaut Ohio                     41.9</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Aves  Pass… Ember… Zono… Zonotr… Conneaut Ohio                     41.9</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Aves  Colu… Colum… Zena… Zenaid… Conneaut Ohio                     41.9</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Aves  Pici… Picid… Dend… Dendro… Conneaut Ohio                     41.9</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> Aves  Anse… Anati… Anas  Anas p… Conneaut Ohio                     41.9</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> Aves  Pass… Turdi… Sial… Sialia… Conneaut Ohio                     41.9</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 4 more variables: decimalLongitude </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, eventDate </span><span style='color: #555555;font-style: italic;'>&lt;dttm&gt;</span><span style='color: #555555;'>,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   species_en </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span style='color: #555555;'>, range </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span></span>
</code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### Most common sighting?

<div class="alert puzzle">

<div>

What is the most commonly observed bird in Ohio?

<details>
<summary> Hints (click here) </summary> Try using tally() and a little helper term. <br>
</details>
<details>
<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>unique_birds_tally</span> <span class='o'>&lt;-</span> <span class='nv'>birds</span> <span class='o'>%&gt;%</span>
  <span class='nf'>group_by</span><span class='o'>(</span><span class='nv'>species_en</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>tally</span><span class='o'>(</span>sort <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>unique_birds_tally</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 2</span></span>
<span class='c'>#&gt;   species_en            n</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>             </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Northern Cardinal </span><span style='text-decoration: underline;'>23</span><span>064</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Mourning Dove     </span><span style='text-decoration: underline;'>19</span><span>135</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Dark-eyed Junco   </span><span style='text-decoration: underline;'>18</span><span>203</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Downy Woodpecker  </span><span style='text-decoration: underline;'>17</span><span>196</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> House Sparrow     </span><span style='text-decoration: underline;'>15</span><span>939</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> Blue Jay          </span><span style='text-decoration: underline;'>15</span><span>611</span></span>
</code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### Rarest sightings?

<div class="alert puzzle">

<div>

What is the least commonly observed bird (or birds) in Ohio?

<details>
<summary> Hints (click here) </summary> Try using the data frame you've created in the previous exercise. <br>
</details>
<details>
<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>unique_birds_tally</span> <span class='o'>%&gt;%</span>
  <span class='nf'>arrange</span><span class='o'>(</span><span class='nv'>n</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>n</span> <span class='o'>==</span> <span class='m'>1</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 19 x 2</span></span>
<span class='c'>#&gt;    species_en                        n</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                         </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> Arctic Redpoll                    1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> Clay-colored Sparrow              1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> Dickcissel                        1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> Eurasian Wigeon                   1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> Great Egret                       1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> Green Heron                       1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> Grey Partridge                    1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> Harris's Sparrow                  1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> Lesser Yellowlegs                 1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> Lincoln's Sparrow                 1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>11</span><span> Loggerhead Shrike                 1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>12</span><span> Nelson's Sparrow                  1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>13</span><span> Northern Rough-winged Swallow     1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>14</span><span> Orchard Oriole                    1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>15</span><span> Prairie Falcon                    1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>16</span><span> Red-throated Loon                 1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>17</span><span> Ross's Goose                      1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>18</span><span> Warbling Vireo                    1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>19</span><span> Western Osprey                    1</span></span>
</code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

Bonus time!
-----------

<div class="alert puzzle">

<div>

In what year were the most Bald Eagles observed?

<details>
<summary> Hints (click here) </summary> You may want to convert your date column to a more simplified year-only date. Check out the package lubridate. <br>
</details>
<details>
<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://lubridate.tidyverse.org'>lubridate</a></span><span class='o'>)</span>

<span class='c'>#&gt; </span>
<span class='c'>#&gt; Attaching package: 'lubridate'</span>

<span class='c'>#&gt; The following objects are masked from 'package:base':</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;     date, intersect, setdiff, union</span>

<span class='nv'>birds_bald_eagle_year</span> <span class='o'>&lt;-</span> <span class='nv'>birds_bald_eagle</span> <span class='o'>%&gt;%</span>
  <span class='nf'>mutate</span><span class='o'>(</span>year <span class='o'>=</span> <span class='nf'><a href='http://lubridate.tidyverse.org/reference/year.html'>year</a></span><span class='o'>(</span><span class='nv'>eventDate</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span> <span class='c'># year() takes a date and outputs only year</span>
  <span class='nf'>group_by</span><span class='o'>(</span><span class='nv'>year</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>tally</span><span class='o'>(</span><span class='o'>)</span>

<span class='nf'>arrange</span><span class='o'>(</span><span class='nv'>birds_bald_eagle_year</span>, <span class='o'>-</span><span class='nv'>n</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 11 x 2</span></span>
<span class='c'>#&gt;     year     n</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span>  </span><span style='text-decoration: underline;'>2</span><span>008    81</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span>  </span><span style='text-decoration: underline;'>2</span><span>006    66</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span>  </span><span style='text-decoration: underline;'>2</span><span>009    58</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span>  </span><span style='text-decoration: underline;'>2</span><span>007    40</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span>  </span><span style='text-decoration: underline;'>2</span><span>005    30</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span>  </span><span style='text-decoration: underline;'>2</span><span>004    26</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span>  </span><span style='text-decoration: underline;'>2</span><span>000    23</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span>  </span><span style='text-decoration: underline;'>2</span><span>001    23</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span>  </span><span style='text-decoration: underline;'>2</span><span>003    15</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span>  </span><span style='text-decoration: underline;'>2</span><span>002    14</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>11</span><span>  </span><span style='text-decoration: underline;'>1</span><span>999     5</span></span>
</code></pre>

</div>

</details>

<br>

</div>

</div>

<br> <br> <br> <br>

