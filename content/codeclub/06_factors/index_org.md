---
output: hugodown::md_document
title: "Session 6: Factors"
subtitle: "Getting up close and personal with our data"
summary: "In this sixth session of Code Club, we'll learn how to use factors to our advantage"
authors: [stephen-opiyo]
tags: [codeclub, factors]
date: 2021-01-18
toc: true

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: "Red-breasted Nuthatch, *Sitta canadensis*"
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
rmd_hash: 2f01172ae92802e9

---

<br> <br> <br>

------------------------------------------------------------------------

Factors form the basis for many powerful operations in R, including many performed on tabular data. The motivation for factors comes from notion of categorical variables. These variables are nonnumeric in nature corresponding to categories such as male and female, Democrat, Republican and Independent.

A factor might be viewed simply as a vector with a bit of more information added. The extra information consists of a record of distinct values in that vector called, "levels".

Let us look at some examples of factors.

We will make use of the package *forcats*, which is one of the 8 core tidyverse packages. Therefore, we start by loading the tidyverse:

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

Example 1: Factor basics
------------------------

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#### Example 1. Let us create a factor "xf" from a vector "x" using integers 5, 12, 13, 12 </span>
<span class='nv'>x</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>5</span>,<span class='m'>12</span>, <span class='m'>13</span>,<span class='m'>12</span><span class='o'>)</span>
<span class='nv'>x</span>

<span class='c'>#&gt; [1]  5 12 13 12</span>

<span class='c'>#### Create a factor xf</span>
<span class='nv'>xf</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/factor.html'>factor</a></span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span>
<span class='nv'>xf</span>

<span class='c'>#&gt; [1] 5  12 13 12</span>
<span class='c'>#&gt; Levels: 5 12 13</span>

<span class='c'>#### The distinct values in xf are 5, 12 and 13.</span>

<span class='c'>#### Let us look inside xf using R functions "str" and "unclass"</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>xf</span><span class='o'>)</span>

<span class='c'>#&gt;  Factor w/ 3 levels "5","12","13": 1 2 3 2</span>

<span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>xf</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 1 2 3 2</span>
<span class='c'>#&gt; attr(,"levels")</span>
<span class='c'>#&gt; [1] "5"  "12" "13"</span>
</code></pre>

</div>

The core of xf is not (5, 12, 13, 12) but rather (1,2,3,2).

The latter means that our data consists first of level-1 value, then level-2 and level 3 values, and finally another level-2. So, the data has been recorded by level. The levels themselves are recorded too, of course though as characters such as "5" rather than 5.

Example 2. Characters to factors
--------------------------------

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'>
<span class='c'>#### We will use democrat (D), Republican (R), Independent (I)</span>
<span class='nv'>y</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"D"</span>,<span class='s'>"R"</span>,<span class='s'>"R"</span>,<span class='s'>"I"</span>,<span class='s'>"R"</span>,<span class='s'>"I"</span>,<span class='s'>"D"</span>,<span class='s'>"I"</span><span class='o'>)</span>
<span class='nv'>y</span>

<span class='c'>#&gt; [1] "D" "R" "R" "I" "R" "I" "D" "I"</span>

<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>y</span><span class='o'>)</span>

<span class='c'>#&gt;  chr [1:8] "D" "R" "R" "I" "R" "I" "D" "I"</span>

<span class='nv'>fy</span> <span class='o'>&lt;-</span><span class='nf'><a href='https://rdrr.io/r/base/factor.html'>factor</a></span> <span class='o'>(</span><span class='nv'>y</span><span class='o'>)</span>
<span class='nv'>fy</span>

<span class='c'>#&gt; [1] D R R I R I D I</span>
<span class='c'>#&gt; Levels: D I R</span>

<span class='nf'><a href='https://rdrr.io/r/base/class.html'>unclass</a></span><span class='o'>(</span><span class='nv'>fy</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 1 3 3 2 3 2 1 2</span>
<span class='c'>#&gt; attr(,"levels")</span>
<span class='c'>#&gt; [1] "D" "I" "R"</span>
</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'>
<span class='c'>#### Application of factors in sorting</span>

<span class='c'>#### Sorting a variable that records months.</span>
<span class='nv'>m</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"Dec"</span>, <span class='s'>"Apr"</span>, <span class='s'>"Jan"</span>, <span class='s'>"Mar"</span><span class='o'>)</span>
<span class='c'>#### Sort using “sort” function</span>
<span class='nf'><a href='https://rdrr.io/r/base/sort.html'>sort</a></span><span class='o'>(</span><span class='nv'>m</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "Apr" "Dec" "Jan" "Mar"</span>


<span class='c'>#### It doesn’t sort in a useful way. The problem can be fixed with a factor.</span>
<span class='c'>#### We first create a list of the valid levels, all 12 months in a year:</span>
<span class='nv'>month_level</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"Jan"</span>, <span class='s'>"Feb"</span>, <span class='s'>"Mar"</span>, <span class='s'>"Apr"</span>, <span class='s'>"May"</span>, <span class='s'>"Jun"</span>, <span class='s'>"Jul"</span>,<span class='s'>"Aug"</span>, <span class='s'>"Sep"</span>, <span class='s'>"Oct"</span>, <span class='s'>"Nov"</span>, <span class='s'>"Dec"</span><span class='o'>)</span>
<span class='c'>#### Create a factor “m1” from “m” and “month_level”</span>
<span class='nv'>m1</span> <span class='o'>&lt;-</span><span class='nf'><a href='https://rdrr.io/r/base/factor.html'>factor</a></span><span class='o'>(</span><span class='nv'>m</span>, levels <span class='o'>=</span> <span class='nv'>month_level</span><span class='o'>)</span>
<span class='c'>#### sort m1</span>
<span class='nf'><a href='https://rdrr.io/r/base/sort.html'>sort</a></span><span class='o'>(</span><span class='nv'>m1</span><span class='o'>)</span>

<span class='c'>#&gt; [1] Jan Mar Apr Dec</span>
<span class='c'>#&gt; Levels: Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec</span>

<span class='c'>#### m1 is sorted in a useful way</span>
</code></pre>

</div>

Example 3.Use of factors in Graphs.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'>
<span class='c'>##### We will use mtcars data. The data was extracted from the 1974 Motor Trend US magazine, and comprises fuel consumption and 10 aspects of automobile design and performance for 32 automobiles (1973–74 models). A data frame with 32 observations on 11 (numeric) variables.</span>
<span class='c'>#### We will use six variables (mpg, cyl, disp, hp, wt, and gear) to create a dataset "Data".</span>
<span class='c'>#### mpg =  Miles/(US) gallon, mpg = Miles/(US) gallon, disp =  Displacement (cu.in.), wt = Weight (1000 lbs), gear  = Number of forward gears    </span>

<span class='nf'><a href='https://rdrr.io/r/utils/data.html'>data</a></span><span class='o'>(</span><span class='nv'>mtcars</span><span class='o'>)</span>
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

<span class='c'>#### Create a dataset called Data from mtcars with the following variables, mpg, cyl, disp, hp, wt </span>
<span class='nv'>Data</span> <span class='o'>&lt;-</span>  <span class='nv'>mtcars</span> <span class='o'>%&gt;%</span> <span class='nf'>select</span><span class='o'>(</span><span class='s'>"mpg"</span>, <span class='s'>"cyl"</span>, <span class='s'>"disp"</span>, <span class='s'>"hp"</span>, <span class='s'>"wt"</span><span class='o'>)</span>

<span class='c'>#Add a new column called cyl_1 by converting cyl from numerics to characters</span>
<span class='nv'>Data</span> <span class='o'>&lt;-</span> <span class='nv'>Data</span> <span class='o'>%&gt;%</span> <span class='nf'>mutate</span><span class='o'>(</span>cyl_1 <span class='o'>=</span> <span class='nf'>recode</span><span class='o'>(</span><span class='nv'>cyl</span>,`4`<span class='o'>=</span> <span class='s'>"Four"</span>, `6` <span class='o'>=</span><span class='s'>"Six"</span>, `8`<span class='o'>=</span> <span class='s'>"Eight"</span><span class='o'>)</span><span class='o'>)</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>Data</span><span class='o'>)</span>

<span class='c'>#&gt;    mpg cyl disp  hp    wt cyl_1</span>
<span class='c'>#&gt; 1 21.0   6  160 110 2.620   Six</span>
<span class='c'>#&gt; 2 21.0   6  160 110 2.875   Six</span>
<span class='c'>#&gt; 3 22.8   4  108  93 2.320  Four</span>
<span class='c'>#&gt; 4 21.4   6  258 110 3.215   Six</span>
<span class='c'>#&gt; 5 18.7   8  360 175 3.440 Eight</span>
<span class='c'>#&gt; 6 18.1   6  225 105 3.460   Six</span>


<span class='c'>#### plot a bar chart of cyl_1</span>
<span class='nf'>ggplot</span><span class='o'>(</span><span class='nv'>Data</span>, <span class='nf'>aes</span><span class='o'>(</span>x<span class='o'>=</span><span class='nv'>cyl_1</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> <span class='nf'>geom_bar</span><span class='o'>(</span><span class='o'>)</span> 

</code></pre>
<img src="figs/Example_3-1.png" width="700px" style="display: block; margin: auto;" />
<pre class='chroma'><code class='language-r' data-lang='r'>
<span class='c'>#### Output of bar graph variables arranged in alphabetical order (Eight, Four, and Six).</span>
<span class='c'>#### We want the bar graph arranged in the following order (Four, Six, and Eight) using the "fct_relevel()" function</span>
<span class='nv'>Data</span> <span class='o'>%&gt;%</span> <span class='nf'>mutate</span><span class='o'>(</span>cyl_1 <span class='o'>=</span> <span class='nf'>fct_relevel</span><span class='o'>(</span><span class='nv'>cyl_1</span>, <span class='s'>"Four"</span>, <span class='s'>"Six"</span>, <span class='s'>"Eight"</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
<span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x<span class='o'>=</span><span class='nv'>cyl_1</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
<span class='nf'>geom_bar</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span> <span class='nf'>labs</span><span class='o'>(</span>x<span class='o'>=</span><span class='s'>"Cylinder"</span>, y<span class='o'>=</span><span class='s'>"Miles/per gallon"</span><span class='o'>)</span>

</code></pre>
<img src="figs/Example_3-2.png" width="700px" style="display: block; margin: auto;" />
<pre class='chroma'><code class='language-r' data-lang='r'>
<span class='c'>#### Reordering following value of another column</span>
<span class='c'>#### Create a dataset called Data_a </span>
<span class='nv'>Data_a</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/data.frame.html'>data.frame</a></span><span class='o'>(</span>name<span class='o'>=</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"North"</span>,<span class='s'>"South"</span>,<span class='s'>"East"</span>,<span class='s'>"West"</span><span class='o'>)</span>, var<span class='o'>=</span><span class='nf'><a href='https://rdrr.io/r/base/sample.html'>sample</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/seq.html'>seq</a></span><span class='o'>(</span><span class='m'>1</span>,<span class='m'>10</span><span class='o'>)</span>, <span class='m'>4</span> <span class='o'>)</span><span class='o'>)</span>

<span class='c'>#### plot a bar chart of Data_a</span>
<span class='nv'>Data_a</span> <span class='o'>%&gt;%</span>  <span class='nf'>ggplot</span><span class='o'>(</span> <span class='nf'>aes</span><span class='o'>(</span>x<span class='o'>=</span><span class='nv'>name</span>, y<span class='o'>=</span><span class='nv'>var</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_bar</span><span class='o'>(</span>stat<span class='o'>=</span><span class='s'>"identity"</span>, fill<span class='o'>=</span><span class='s'>"#f68034"</span>, alpha<span class='o'>=</span><span class='m'>.6</span>, width<span class='o'>=</span><span class='m'>.4</span><span class='o'>)</span> 

</code></pre>
<img src="figs/Example_3-3.png" width="700px" style="display: block; margin: auto;" />
<pre class='chroma'><code class='language-r' data-lang='r'>  
<span class='c'>### Reorder following the value of another column using "fct_reorder" function and flip the plot:</span>
<span class='nv'>Data_a</span> <span class='o'>%&gt;%</span>
  <span class='nf'>mutate</span><span class='o'>(</span>name <span class='o'>=</span> <span class='nf'>fct_reorder</span><span class='o'>(</span><span class='nv'>name</span>, <span class='nv'>var</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span> <span class='nf'>aes</span><span class='o'>(</span>x<span class='o'>=</span><span class='nv'>name</span>, y<span class='o'>=</span><span class='nv'>var</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_bar</span><span class='o'>(</span>stat<span class='o'>=</span><span class='s'>"identity"</span>, fill<span class='o'>=</span><span class='s'>"#f68034"</span>, alpha<span class='o'>=</span><span class='m'>.6</span>, width<span class='o'>=</span><span class='m'>.4</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>coord_flip</span><span class='o'>(</span><span class='o'>)</span> 

</code></pre>
<img src="figs/Example_3-4.png" width="700px" style="display: block; margin: auto;" />

</div>

Breakout rooms!
---------------

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'> 
<span class='c'>#### We will datasets from "mtcars" and "gss_cat" from the package forcats for Breakout rooms exercises.</span>

<span class='c'>#### Exercise 1</span>

<span class='c'>####Convert variable "gear" from mtcars to characters and plot a bar chart for gear. Hint the the bars should be in the following order "Three", "Four", and "Five"</span>
<span class='c'>####Use "mutate", "record", and fct_relevel functions</span>
<span class='c'>####Add a column called gear_1 by converting gear from numerics to characters</span>


<span class='c'>#### Solution </span>
<span class='c'>#### dataset "mtcars"</span>
<span class='nf'><a href='https://rdrr.io/r/utils/data.html'>data</a></span><span class='o'>(</span><span class='s'>"mtcars"</span><span class='o'>)</span>

<span class='c'>#### Add column "gear_1" to "mtcars" and create a new dataset call "Gear" </span>
<span class='nv'>Gear</span> <span class='o'>&lt;-</span> <span class='nv'>mtcars</span> <span class='o'>%&gt;%</span> <span class='nf'>mutate</span><span class='o'>(</span>gear_1 <span class='o'>=</span> <span class='nf'>recode</span><span class='o'>(</span><span class='nv'>gear</span>,`3`<span class='o'>=</span> <span class='s'>"Three"</span>, `4` <span class='o'>=</span><span class='s'>"Four"</span>, `5`<span class='o'>=</span> <span class='s'>"Five"</span><span class='o'>)</span><span class='o'>)</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>Gear</span><span class='o'>)</span>

<span class='c'>#&gt;    mpg cyl disp  hp drat    wt  qsec vs am gear carb gear_1</span>
<span class='c'>#&gt; 1 21.0   6  160 110 3.90 2.620 16.46  0  1    4    4   Four</span>
<span class='c'>#&gt; 2 21.0   6  160 110 3.90 2.875 17.02  0  1    4    4   Four</span>
<span class='c'>#&gt; 3 22.8   4  108  93 3.85 2.320 18.61  1  1    4    1   Four</span>
<span class='c'>#&gt; 4 21.4   6  258 110 3.08 3.215 19.44  1  0    3    1  Three</span>
<span class='c'>#&gt; 5 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2  Three</span>
<span class='c'>#&gt; 6 18.1   6  225 105 2.76 3.460 20.22  1  0    3    1  Three</span>


<span class='c'>#### use forcats function called fct_relevel to rearrage gear_1 in nonalphabetical order and plot the bar chart using "geom_bar"</span>
    
<span class='nv'>Gear</span> <span class='o'>%&gt;%</span> <span class='nf'>mutate</span><span class='o'>(</span>gear_1 <span class='o'>=</span> <span class='nf'>fct_relevel</span><span class='o'>(</span><span class='nv'>gear_1</span>, <span class='s'>"Three"</span>, <span class='s'>"Four"</span>, <span class='s'>"Five"</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
<span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x<span class='o'>=</span><span class='nv'>gear_1</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
<span class='nf'>geom_bar</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span> <span class='nf'>labs</span><span class='o'>(</span>x<span class='o'>=</span><span class='s'>"Gear"</span>, y<span class='o'>=</span><span class='s'>"Miles/per gallon"</span><span class='o'>)</span>

</code></pre>
<img src="figs/Main_exercises-1.png" width="700px" style="display: block; margin: auto;" />
<pre class='chroma'><code class='language-r' data-lang='r'>
<span class='c'>#### Exercise 2</span>
<span class='c'>#### Using dataset gss_cat from forcats pacckage plot a scatter plot of the average number of hours spent watching TV per day accross religions. </span>

<span class='c'>#### get the dataset gss_cat by typing the following forcats::gss_cat </span>

<span class='c'>#### Hint use "mutate", "fct_recorder", and "summarize" functions</span>
<span class='c'>#### Source: (R for Data Science)</span>

<span class='c'>#### Solution</span>
<span class='c'>#### Get dataset</span>
<span class='nf'>forcats</span><span class='nf'>::</span><span class='nv'><a href='https://forcats.tidyverse.org/reference/gss_cat.html'>gss_cat</a></span>

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


<span class='c'>#### Transform the data and plot scatter plot</span>
<span class='nv'>relig</span> <span class='o'>&lt;-</span> <span class='nv'>gss_cat</span> <span class='o'>%&gt;%</span>
  <span class='nf'>group_by</span><span class='o'>(</span><span class='nv'>relig</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>summarize</span><span class='o'>(</span>
   age <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>age</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>,
   tvhours <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>tvhours</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>,
   n <span class='o'>=</span> <span class='nf'>n</span><span class='o'>(</span><span class='o'>)</span>
<span class='o'>)</span>

<span class='c'>#&gt; `summarise()` ungrouping output (override with `.groups` argument)</span>

<span class='nf'>ggplot</span><span class='o'>(</span><span class='nv'>relig</span>, <span class='nf'>aes</span><span class='o'>(</span><span class='nv'>tvhours</span>, <span class='nv'>relig</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span>

</code></pre>
<img src="figs/Main_exercises-2.png" width="700px" style="display: block; margin: auto;" />
<pre class='chroma'><code class='language-r' data-lang='r'>
<span class='c'>#### It is difficult to interpret this plot because there is no overall pattern.  We can improve the plot by reordering the level of relig using fct_reorder</span>

<span class='nv'>relig</span> <span class='o'>&lt;-</span> <span class='nv'>gss_cat</span> <span class='o'>%&gt;%</span>
  <span class='nf'>group_by</span><span class='o'>(</span><span class='nv'>relig</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>summarize</span><span class='o'>(</span>
   age <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>age</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>,
   tvhours <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>tvhours</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>,
   n <span class='o'>=</span> <span class='nf'>n</span><span class='o'>(</span><span class='o'>)</span>
<span class='o'>)</span>

<span class='c'>#&gt; `summarise()` ungrouping output (override with `.groups` argument)</span>

<span class='nv'>relig</span> <span class='o'>%&gt;%</span>
  <span class='nf'>mutate</span><span class='o'>(</span>relig <span class='o'>=</span> <span class='nf'>fct_reorder</span><span class='o'>(</span><span class='nv'>relig</span>, <span class='nv'>tvhours</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span><span class='nv'>tvhours</span>, <span class='nv'>relig</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
    <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span>

</code></pre>
<img src="figs/Main_exercises-3.png" width="700px" style="display: block; margin: auto;" />
<pre class='chroma'><code class='language-r' data-lang='r'>
<span class='c'>#### Reordering religion makes it much easier to see that people in the "Don't know" category watch much more TV.</span>
</code></pre>

</div>

