---
output: hugodown::md_document
title: "Session 6: Factors"
subtitle: "Learn how to use them to your advantage!"
summary: "In this sixth session of Code Club, we'll learn how to use factors to our advantage"
authors: [stephen-opiyo]
tags: [codeclub, factors]
date: 2021-01-18
lastmod: 2021-01-18
toc: true

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: "Artwork by @allison_horst"
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
rmd_hash: 8a71e7bb1069da40

---

<br> <br>

------------------------------------------------------------------------

Factors form the basis for many powerful operations in R, including many performed on tabular data. The motivation for factors comes from the notion of categorical variables. These variables are non-numeric in nature corresponding to categories such as male and female, or Democrat, Republican and Independent.

**A factor might be viewed simply as a vector with a bit of more information added.** The extra information consists of a record of distinct values in that vector, which are called: ***levels***.

Let us look at some examples of factors. We will make use of the package *forcats*, which is one of the 8 core *tidyverse* packages. Therefore, we start by loading the *tidyverse*:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>

<span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching packages</span><span> ─────────────────────────────────────── tidyverse 1.3.0 ──</span></span>

<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>ggplot2</span><span> 3.3.3     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>purrr  </span><span> 0.3.4</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>tibble </span><span> 3.0.4     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>dplyr  </span><span> 1.0.2</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>tidyr  </span><span> 1.1.2     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>stringr</span><span> 1.4.0</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>readr  </span><span> 1.4.0     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>forcats</span><span> 0.5.0</span></span>

<span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span><span> ────────────────────────────────────────── tidyverse_conflicts() ──</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>filter()</span><span> masks </span><span style='color: #0000BB;'>stats</span><span>::filter()</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>lag()</span><span>    masks </span><span style='color: #0000BB;'>stats</span><span>::lag()</span></span>


<span class='c'>## Check whether "forcats" is listed among the loaded packages.</span>
<span class='c'>## Alternatively, you could load "forcats" (and "ggplot2") separately:</span>
<span class='c'># install.packages("forcats")</span>
<span class='c'># library(forcats)</span>
<span class='c'># library(ggplot2)</span>
</code></pre>

</div>

<br>

------------------------------------------------------------------------

Example 1: From a numeric vector to a factor
--------------------------------------------

Let us create a factor `xf` from a vector `x` with the numbers `5`, `12`, `13`, and `12`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>x</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>5</span>,<span class='m'>12</span>, <span class='m'>13</span>,<span class='m'>12</span><span class='o'>)</span>
<span class='nv'>x</span>

<span class='c'>#&gt; [1]  5 12 13 12</span>


<span class='c'># Convert the vector to a factor:</span>
<span class='nv'>xf</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/factor.html'>factor</a></span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span>
<span class='nv'>xf</span>

<span class='c'>#&gt; [1] 5  12 13 12</span>
<span class='c'>#&gt; Levels: 5 12 13</span>
</code></pre>

</div>

The *distinct values* in `xf` are `5`, `12` and `13`, and are listed as *levels*.

Let us look in a bit more details at our factor using the R functions `str` and `unclass`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>xf</span><span class='o'>)</span>

<span class='c'>#&gt;  Factor w/ 3 levels "5","12","13": 1 2 3 2</span>

<span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>xf</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 1 2 3 2</span>
<span class='c'>#&gt; attr(,"levels")</span>
<span class='c'>#&gt; [1] "5"  "12" "13"</span>
</code></pre>

</div>

Notice that the values in the factor are not stored as `(5, 12, 13, 12)`, but rather as `(1, 2, 3, 2)`!

This means that our data consists first of a level-1 value, then level-2 and level 3 values, and finally another level-2 value. So, the data has been recorded by level.

The values attached to each level are recorded too, but as *characters* such as `"5"` rather than as numbers such as `5`.

<br>

------------------------------------------------------------------------

Example 2: From a character vector to a factor
----------------------------------------------

We will use the levels Democrat (`D`), Republican (`R`), and Independent (`I`). First, we save a *vector*:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>y</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"D"</span>, <span class='s'>"R"</span>, <span class='s'>"R"</span>, <span class='s'>"I"</span>, <span class='s'>"R"</span>, <span class='s'>"I"</span>, <span class='s'>"D"</span>, <span class='s'>"I"</span><span class='o'>)</span>
<span class='nv'>y</span>

<span class='c'>#&gt; [1] "D" "R" "R" "I" "R" "I" "D" "I"</span>

<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>y</span><span class='o'>)</span>

<span class='c'>#&gt;  chr [1:8] "D" "R" "R" "I" "R" "I" "D" "I"</span>
</code></pre>

</div>

Then, we again convert the *vector* to a *factor*, and look at the levels:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>fy</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/factor.html'>factor</a></span><span class='o'>(</span><span class='nv'>y</span><span class='o'>)</span>
<span class='nv'>fy</span>

<span class='c'>#&gt; [1] D R R I R I D I</span>
<span class='c'>#&gt; Levels: D I R</span>

<span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>fy</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 1 3 3 2 3 2 1 2</span>
<span class='c'>#&gt; attr(,"levels")</span>
<span class='c'>#&gt; [1] "D" "I" "R"</span>
</code></pre>

</div>

<br>

------------------------------------------------------------------------

Example 3: Ordering factor levels
---------------------------------

Some variables can be challenging to sort automatically, because the desired sorting order is not alphabetical or numeric.

For instance, months that are listed using characters:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>months_vector</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"Dec"</span>, <span class='s'>"Apr"</span>, <span class='s'>"Jan"</span>, <span class='s'>"Mar"</span><span class='o'>)</span>

<span class='c'># Try to sort using the `sort` function</span>
<span class='nf'><a href='https://rdrr.io/r/base/sort.html'>sort</a></span><span class='o'>(</span><span class='nv'>months_vector</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "Apr" "Dec" "Jan" "Mar"</span>
</code></pre>

</div>

That didn't sort in a useful way. **But, the problem can be fixed by using a factor.**

First, we create a list of the valid levels, which are all 12 months in a year:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>month_levels</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"Jan"</span>, <span class='s'>"Feb"</span>, <span class='s'>"Mar"</span>, <span class='s'>"Apr"</span>, <span class='s'>"May"</span>, <span class='s'>"Jun"</span>,
                  <span class='s'>"Jul"</span>, <span class='s'>"Aug"</span>, <span class='s'>"Sep"</span>, <span class='s'>"Oct"</span>, <span class='s'>"Nov"</span>, <span class='s'>"Dec"</span><span class='o'>)</span>
</code></pre>

</div>

Then we convert the vector into a factor, like before, but now we additionally specify the desired levels of the factor, **in order**, using the `levels` argument:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>months_factor</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/factor.html'>factor</a></span><span class='o'>(</span><span class='nv'>months_vector</span>, levels <span class='o'>=</span> <span class='nv'>month_levels</span><span class='o'>)</span>
</code></pre>

</div>

Now it sorts the way we want to!

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/sort.html'>sort</a></span><span class='o'>(</span><span class='nv'>months_factor</span><span class='o'>)</span>

<span class='c'>#&gt; [1] Jan Mar Apr Dec</span>
<span class='c'>#&gt; Levels: Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec</span>
</code></pre>

</div>

<br>

------------------------------------------------------------------------

Example 4: Use of factors in plots with *forcats*
-------------------------------------------------

### 4A: Plot after reordering manually with `fct_relevel()`

We will use the *mtcars* data, which was extracted from the 1974 Motor Trend US magazine, and comprises fuel consumption and 10 aspects of automobile design and performance for 32 automobiles (1973--74 models) -- a data frame with 32 observations for 11 (numeric) variables,

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/data.html'>data</a></span><span class='o'>(</span><span class='nv'>mtcars</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/base/names.html'>names</a></span><span class='o'>(</span><span class='nv'>mtcars</span><span class='o'>)</span>

<span class='c'>#&gt;  [1] "mpg"  "cyl"  "disp" "hp"   "drat" "wt"   "qsec" "vs"   "am"   "gear"</span>
<span class='c'>#&gt; [11] "carb"</span>

<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>mtcars</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 32 11</span>

<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>mtcars</span><span class='o'>)</span>

<span class='c'>#&gt; 'data.frame':  32 obs. of  11 variables:</span>
<span class='c'>#&gt;  $ mpg : num  21 21 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 ...</span>
<span class='c'>#&gt;  $ cyl : num  6 6 4 6 8 6 8 4 4 6 ...</span>
<span class='c'>#&gt;  $ disp: num  160 160 108 258 360 ...</span>
<span class='c'>#&gt;  $ hp  : num  110 110 93 110 175 105 245 62 95 123 ...</span>
<span class='c'>#&gt;  $ drat: num  3.9 3.9 3.85 3.08 3.15 2.76 3.21 3.69 3.92 3.92 ...</span>
<span class='c'>#&gt;  $ wt  : num  2.62 2.88 2.32 3.21 3.44 ...</span>
<span class='c'>#&gt;  $ qsec: num  16.5 17 18.6 19.4 17 ...</span>
<span class='c'>#&gt;  $ vs  : num  0 0 1 1 0 1 0 1 1 1 ...</span>
<span class='c'>#&gt;  $ am  : num  1 1 1 0 0 0 0 0 0 0 ...</span>
<span class='c'>#&gt;  $ gear: num  4 4 4 3 3 3 3 4 4 4 ...</span>
<span class='c'>#&gt;  $ carb: num  4 4 1 1 2 1 4 2 2 4 ...</span>
</code></pre>

</div>

we will select six variables (`mpg`, `cyl`, `disp`, `hp`, and `wt`) to create a dataset `Data`.

-   `mpg`: Miles per (US) gallon,
-   `cyl`: Number of cylinders
-   `disp`: Displacement (cu.in.)
-   `hp`: Horse power
-   `wt`: Weight (in 1000 lbs)

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>Data</span> <span class='o'>&lt;-</span> <span class='nv'>mtcars</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='s'>"mpg"</span>, <span class='s'>"cyl"</span>, <span class='s'>"disp"</span>, <span class='s'>"hp"</span>, <span class='s'>"wt"</span><span class='o'>)</span>
</code></pre>

</div>

Now, we'll add a new column `cyl_chr` by converting `cyl` from *numeric* to *character*:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>Data</span> <span class='o'>&lt;-</span> <span class='nv'>Data</span> <span class='o'>%&gt;%</span>
  <span class='nf'>mutate</span><span class='o'>(</span>cyl_chr <span class='o'>=</span> <span class='nf'>recode</span><span class='o'>(</span><span class='nv'>cyl</span>,`4` <span class='o'>=</span> <span class='s'>"Four"</span>, `6` <span class='o'>=</span> <span class='s'>"Six"</span>, `8` <span class='o'>=</span> <span class='s'>"Eight"</span><span class='o'>)</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>Data</span><span class='o'>)</span>

<span class='c'>#&gt;    mpg cyl disp  hp    wt cyl_chr</span>
<span class='c'>#&gt; 1 21.0   6  160 110 2.620     Six</span>
<span class='c'>#&gt; 2 21.0   6  160 110 2.875     Six</span>
<span class='c'>#&gt; 3 22.8   4  108  93 2.320    Four</span>
<span class='c'>#&gt; 4 21.4   6  258 110 3.215     Six</span>
<span class='c'>#&gt; 5 18.7   8  360 175 3.440   Eight</span>
<span class='c'>#&gt; 6 18.1   6  225 105 3.460     Six</span>
</code></pre>

</div>

We plot a bar chart for `cyl_chr`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>Data</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>cyl_chr</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_bar</span><span class='o'>(</span><span class='o'>)</span> 

</code></pre>
<img src="figs/unnamed-chunk-13-1.png" width="700px" style="display: block; margin: auto;" />

</div>

In the plot, the levels of the factor were arranged in alphabetical order (`Eight`, `Four`, and `Six`).

Instead, we want the bar graph arranged in the order `Four`, `Six`, and `Eight`.

An alternative to using [`factor(levels = ...)`](https://rdrr.io/r/base/factor.html) like we did above, is to use the `fct_relevel()` function from the *forcats* package:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>Data</span> <span class='o'>%&gt;%</span>
  <span class='nf'>mutate</span><span class='o'>(</span>cyl_chr <span class='o'>=</span> <span class='nf'>fct_relevel</span><span class='o'>(</span><span class='nv'>cyl_chr</span>, <span class='s'>"Four"</span>, <span class='s'>"Six"</span>, <span class='s'>"Eight"</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>cyl_chr</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_bar</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Cylinder"</span>, y <span class='o'>=</span> <span class='s'>"Miles/per gallon"</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-14-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<br>

### 4B: Plot after reordering by the value of another column (`fct_reorder`)

Create a dataset called `Data_a`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>Data_a</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/data.frame.html'>data.frame</a></span><span class='o'>(</span>name <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"North"</span>, <span class='s'>"South"</span>, <span class='s'>"East"</span>, <span class='s'>"West"</span><span class='o'>)</span>,
                     var <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/sample.html'>sample</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/seq.html'>seq</a></span><span class='o'>(</span><span class='m'>1</span>, <span class='m'>10</span><span class='o'>)</span>, <span class='m'>4</span><span class='o'>)</span><span class='o'>)</span>
</code></pre>

</div>

Plot a bar chart of `Data_a`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>Data_a</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>name</span>, y <span class='o'>=</span> <span class='nv'>var</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_bar</span><span class='o'>(</span>stat <span class='o'>=</span> <span class='s'>"identity"</span>, fill <span class='o'>=</span> <span class='s'>"#f68034"</span>, alpha <span class='o'>=</span> <span class='m'>0.6</span>, width <span class='o'>=</span> <span class='m'>0.4</span><span class='o'>)</span> 

</code></pre>
<img src="figs/unnamed-chunk-16-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Reorder following the value of another column using the `fct_reorder()` function, and flip the plot:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>Data_a</span> <span class='o'>%&gt;%</span>
  <span class='nf'>mutate</span><span class='o'>(</span>name <span class='o'>=</span> <span class='nf'>fct_reorder</span><span class='o'>(</span><span class='nv'>name</span>, <span class='nv'>var</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>name</span>, y <span class='o'>=</span> <span class='nv'>var</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_bar</span><span class='o'>(</span>stat <span class='o'>=</span> <span class='s'>"identity"</span>, fill <span class='o'>=</span> <span class='s'>"#f68034"</span>, alpha <span class='o'>=</span> <span class='m'>0.6</span>, width <span class='o'>=</span> <span class='m'>0.4</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>coord_flip</span><span class='o'>(</span><span class='o'>)</span> 

</code></pre>
<img src="figs/unnamed-chunk-17-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<br>

There are several more convenient reordering functions in the *forcats* package, including:

-   `fact_infreq()` to reorder by occurrence frequencies of each level (see the picture at the top of the post).

-   `fct_inorder()` to reorder by order of appearance in the dataframe. This can be useful, for example, if your dataframe has already been sorted properly, and you just need to prevent automatic alphabetic reordering when plotting.

<br>

------------------------------------------------------------------------

Breakout rooms!
---------------

For the Breakout room exercises, we will use datasets from *mtcars* and the `gss_cat` dataset from the *forcats* package.

### Exercise 1

<div class="puzzle">

<div>

Convert the variable `gear` from *mtcars* to a character vector with words for each number (link in example 4A), and plot a bar chart.

Then, use a factor to reorder the bars to appear in the regular "numeric" order: "Three" then "Four" then "Five".

<details>
<summary> Hints (click here) </summary>
<p>

-   First, create a dataframe with a column that codes the gears as words, using the `mutate()` and `recode()` functions.

-   Then, create a factor from this modified gear column, and order it manually using the `fct_relevel()` function.

</p>
</details>

<br>

<details>

<summary> Solutions (click here) </summary> <br>

-   Start by loading the dataset:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/data.html'>data</a></span><span class='o'>(</span><span class='s'>"mtcars"</span><span class='o'>)</span>
</code></pre>

</div>

<br>

-   Now, create a new dataset `Gear` from *mtcars*, adding a column `gear_chr`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>gear_df</span> <span class='o'>&lt;-</span> <span class='nv'>mtcars</span> <span class='o'>%&gt;%</span>
  <span class='nf'>mutate</span><span class='o'>(</span>gear_chr <span class='o'>=</span> <span class='nf'>recode</span><span class='o'>(</span><span class='nv'>gear</span>,
                         `3`<span class='o'>=</span> <span class='s'>"Three"</span>,
                         `4` <span class='o'>=</span><span class='s'>"Four"</span>,
                         `5`<span class='o'>=</span> <span class='s'>"Five"</span><span class='o'>)</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>gear_df</span><span class='o'>)</span>

<span class='c'>#&gt;    mpg cyl disp  hp drat    wt  qsec vs am gear carb gear_chr</span>
<span class='c'>#&gt; 1 21.0   6  160 110 3.90 2.620 16.46  0  1    4    4     Four</span>
<span class='c'>#&gt; 2 21.0   6  160 110 3.90 2.875 17.02  0  1    4    4     Four</span>
<span class='c'>#&gt; 3 22.8   4  108  93 3.85 2.320 18.61  1  1    4    1     Four</span>
<span class='c'>#&gt; 4 21.4   6  258 110 3.08 3.215 19.44  1  0    3    1    Three</span>
<span class='c'>#&gt; 5 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2    Three</span>
<span class='c'>#&gt; 6 18.1   6  225 105 2.76 3.460 20.22  1  0    3    1    Three</span>
</code></pre>

</div>

<br>

-   Finally, use the *forcats* function `fct_relevel()` to rearrange `gear_chr` in nonalphabetical order, and plot the barchart using `geom_bar()`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>gear_df</span> <span class='o'>%&gt;%</span>
  <span class='nf'>mutate</span><span class='o'>(</span>gear_fct <span class='o'>=</span> <span class='nf'>fct_relevel</span><span class='o'>(</span><span class='nv'>gear_chr</span>, <span class='s'>"Three"</span>, <span class='s'>"Four"</span>, <span class='s'>"Five"</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>gear_fct</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_bar</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Gear"</span>, y <span class='o'>=</span> <span class='s'>"Miles/per gallon"</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-20-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<br>
</details>

</div>

</div>

<br>

------------------------------------------------------------------------

### Exercise 2

<div class="puzzle">

<div>

Using the `gss_cat` dataset from the *forcats* package (available as `gsscat` in your environment), create a plot that compares the average number of hours spent watching TV per day across religions, and where *religions are ordered by the average number of hours*.

(Despite what we've learned last week, start by merely plotting the mean, and no distributions, using a barplot or with `geom_point()`.)

*Source: (R for Data Science)*

<details>

<summary> Hints (click here) </summary> <br> In order to be able to order the factor by the average number of hours spent watching TV, first compute this average per religion, and save the results in a dataframe (use `mutate()` and `summarize()`).

Then, use `fct_recorder()` to reorder the factor.

</details>

<br>

<details>

<summary> Solutions (click here) </summary> <br>

First, have a look at the dataset:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>forcats</span><span class='nf'>::</span><span class='nv'><a href='https://forcats.tidyverse.org/reference/gss_cat.html'>gss_cat</a></span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 21,483 x 9</span></span>
<span class='c'>#&gt;     year marital     age race  rincome    partyid     relig     denom    tvhours</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>      </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>      </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span>  </span><span style='text-decoration: underline;'>2</span><span>000 Never ma…    26 White $8000 to … Ind,near r… Protesta… Souther…      12</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span>  </span><span style='text-decoration: underline;'>2</span><span>000 Divorced     48 White $8000 to … Not str re… Protesta… Baptist…      </span><span style='color: #BB0000;'>NA</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span>  </span><span style='text-decoration: underline;'>2</span><span>000 Widowed      67 White Not appli… Independent Protesta… No deno…       2</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span>  </span><span style='text-decoration: underline;'>2</span><span>000 Never ma…    39 White Not appli… Ind,near r… Orthodox… Not app…       4</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span>  </span><span style='text-decoration: underline;'>2</span><span>000 Divorced     25 White Not appli… Not str de… None      Not app…       1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span>  </span><span style='text-decoration: underline;'>2</span><span>000 Married      25 White $20000 - … Strong dem… Protesta… Souther…      </span><span style='color: #BB0000;'>NA</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span>  </span><span style='text-decoration: underline;'>2</span><span>000 Never ma…    36 White $25000 or… Not str re… Christian Not app…       3</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span>  </span><span style='text-decoration: underline;'>2</span><span>000 Divorced     44 White $7000 to … Ind,near d… Protesta… Luthera…      </span><span style='color: #BB0000;'>NA</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span>  </span><span style='text-decoration: underline;'>2</span><span>000 Married      44 White $25000 or… Not str de… Protesta… Other          0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span>  </span><span style='text-decoration: underline;'>2</span><span>000 Married      47 White $25000 or… Strong rep… Protesta… Souther…       3</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 21,473 more rows</span></span>
</code></pre>

</div>

Then, calculate the mean number of tv-hours and create a plot:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>relig</span> <span class='o'>&lt;-</span> <span class='nv'>gss_cat</span> <span class='o'>%&gt;%</span>
  <span class='nf'>group_by</span><span class='o'>(</span><span class='nv'>relig</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>summarize</span><span class='o'>(</span>tvhours <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>tvhours</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; `summarise()` ungrouping output (override with `.groups` argument)</span>


<span class='nf'>ggplot</span><span class='o'>(</span><span class='nv'>relig</span>, <span class='nf'>aes</span><span class='o'>(</span><span class='nv'>tvhours</span>, <span class='nv'>relig</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-22-1.png" width="700px" style="display: block; margin: auto;" />

</div>

It is difficult to interpret this plot because there is no overall pattern.

We can improve the plot by reordering the level of religion using `fct_reorder()`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>relig</span> <span class='o'>&lt;-</span> <span class='nv'>gss_cat</span> <span class='o'>%&gt;%</span>
  <span class='nf'>group_by</span><span class='o'>(</span><span class='nv'>relig</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>summarize</span><span class='o'>(</span>tvhours <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>tvhours</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; `summarise()` ungrouping output (override with `.groups` argument)</span>


<span class='nv'>relig</span> <span class='o'>%&gt;%</span>
  <span class='nf'>mutate</span><span class='o'>(</span>relig <span class='o'>=</span> <span class='nf'>fct_reorder</span><span class='o'>(</span><span class='nv'>relig</span>, <span class='nv'>tvhours</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span><span class='nv'>tvhours</span>, <span class='nv'>relig</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-23-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Reordering religion makes it much easier to see that people in the "Don't know" category watch much more TV.

<br>
</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### Bonus: Exercise 3

<div class="puzzle">

<div>

In exercise 2, we saw large differences in the *average* time spent watching TV across religions, but we should perhaps have a closer look at the data by plotting distributions.

Go back to the [previous Code Club session](https://biodash.github.io/codeclub/05_ggplot-round-2/) and decide which type of plot could be ideal with so many categories.

<details>
<summary> Hints (click here) </summary> <br> [`geom_density_ridges()`](https://wilkelab.org/ggridges/reference/geom_density_ridges.html) from the *ggridges* package is very well suited for a plot with so many categories.
</details>
<br>
<details>

<summary> Solutions (click here) </summary> <br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://wilkelab.org/ggridges/'>ggridges</a></span><span class='o'>)</span>

<span class='nf'>ggplot</span><span class='o'>(</span><span class='nv'>gss_cat</span>, <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>tvhours</span>, y <span class='o'>=</span> <span class='nv'>relig</span>, fill <span class='o'>=</span> <span class='nv'>relig</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://wilkelab.org/ggridges/reference/geom_density_ridges.html'>geom_density_ridges</a></span><span class='o'>(</span>alpha <span class='o'>=</span> <span class='m'>0.8</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>'Number of hours spent watching TV'</span>, y <span class='o'>=</span> <span class='s'>'Religion'</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>guides</span><span class='o'>(</span>fill <span class='o'>=</span> <span class='kc'>FALSE</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_minimal</span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#&gt; Picking joint bandwidth of 0.586</span>

<span class='c'>#&gt; Warning: Removed 10146 rows containing non-finite values (stat_density_ridges).</span>

</code></pre>
<img src="figs/unnamed-chunk-24-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

</div>

<br>

