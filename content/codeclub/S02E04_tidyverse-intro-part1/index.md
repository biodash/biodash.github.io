---
title: "Code Club S02E04: Intro to the Tidyverse (Part 1)"
subtitle: "Tidyverse, the pipe, filter, select, and 🐧"
summary: "During this session of Code Club, we will be learning about what the tidyverse is, the pipe operator, and how to use some of the most popular dplyr one-table functions, including filter and select."  
authors: [jessica-cooperstone]
date: "2021-09-15"
output: hugodown::md_document
toc: true

image: 
  caption: "Artwork by @allison_horst"
  focal_point: ""
  preview_only: false
rmd_hash: f3a1ecc0a1401973

---

<br> <br> <br>

------------------------------------------------------------------------

## Prep homework

### Basic computer setup

-   If you didn't already do this, please follow the [Code Club Computer Setup](/codeclub-setup/) instructions, which also has pointers for if you're new to R or RStudio.

-   If you're able to do so, please open RStudio a bit before Code Club starts -- and in case you run into issues, please join the Zoom call early and we'll troubleshoot.

<br>

------------------------------------------------------------------------

## Getting started

Now that you are familiar with the basics of RMarkdown [season 1](/codeclub/07_rmarkdown) and [season 2](/codeclub/s02e03_rmarkdown/), I put together a RMarkdown file you can download which has the content for today's Code Club.

### Download today's content

<details>
<summary>
Click here to get an Rmd (optional)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># directory for Code Club Session 2:</span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>"S02E04"</span><span class='o'>)</span>

<span class='c'># directory for our script</span>
<span class='c'># ("recursive" to create two levels at once.)</span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>"S02E04/Rmds/"</span><span class='o'>)</span>

<span class='c'># save the url location for today's script</span>
<span class='nv'>todays_Rmd</span> <span class='o'>&lt;-</span> <span class='s'>"https://raw.githubusercontent.com/biodash/biodash.github.io/master/content/codeclub/S02E04_tidyverse-intro-part1/intro-to-tidyverse1.Rmd"</span>

<span class='c'># indicate the name of the new Rmd file</span>
<span class='nv'>intro_tidyverse1</span> <span class='o'>&lt;-</span> <span class='s'>"S02E04/Rmds/intro-to-tidyverse1.Rmd"</span>

<span class='c'># go get that file! </span>
<span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>todays_Rmd</span>,
              destfile <span class='o'>=</span> <span class='nv'>intro_tidyverse1</span><span class='o'>)</span></code></pre>

</div>

</details>
<br>

<div class="alert alert-note">

<div>

**What will we go over today**

-   What is the tidyverse and why would I want to use it?
-   Understanding how to use ["the pipe"](https://style.tidyverse.org/pipes.html) `%>%`
-   Using [`filter()`](https://dplyr.tidyverse.org/reference/filter.html) - picks observations (i.e., rows) based on their values
-   Using [`select()`](https://dplyr.tidyverse.org/reference/select.html) - picks variables (i.e., columns) based on their names

</div>

</div>

<br>

------------------------------------------------------------------------

## 1 - What is the tidyverse, and how do I use it?

The [tidyverse](https://www.tidyverse.org/) is a collection of R packages that are designed for data science. You can certainly use R without using the tidyverse, but it has many packages that I think will make your life a lot easier. The popular package [`ggplot2`](https://ggplot2.tidyverse.org/index.html) is a part of the core tidyverse, which we have talked about in previous Code Clubs ([intro](/codeclub/04_ggplot2), [intro2](/codeclub/05_ggplot-round-2), [maps](/codeclub/11_ggplot-maps), and [ggplotly](/codeclub/15_plotly)), and will talk about in future sessions as well.

Packages contain shareable code, documentation, tests, and data. One way to download packages is using the function [`install.packages()`](https://www.rdocumentation.org/packages/utils/versions/3.6.2/topics/install.packages) which will allow you to download packages that exist within the Comprehensive R Archive Network, or [CRAN](https://cran.r-project.org/). There are packages that exist outside CRAN but that is a story for another time.

Before we talk more about the tidyverse, let's download it. We only need to do this once.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"tidyverse"</span><span class='o'>)</span></code></pre>

</div>

To use any of the packages within the tidyverse, we need to call them up using [`library()`](https://rdrr.io/r/base/library.html) anytime we want to use the code embedded within them.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
<span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching packages</span><span> ─────────────────────────────────────── tidyverse 1.3.1 ──</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>ggplot2</span><span> 3.3.3     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>purrr  </span><span> 0.3.4</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>tibble </span><span> 3.1.4     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>dplyr  </span><span> 1.0.7</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>tidyr  </span><span> 1.1.3     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>stringr</span><span> 1.4.0</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>readr  </span><span> 1.4.0     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>forcats</span><span> 0.5.1</span></span>
<span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span><span> ────────────────────────────────────────── tidyverse_conflicts() ──</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>filter()</span><span> masks </span><span style='color: #0000BB;'>stats</span><span>::filter()</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>lag()</span><span>    masks </span><span style='color: #0000BB;'>stats</span><span>::lag()</span></span></code></pre>

</div>

Let's look at this message, we can see that there are eight "attaching packages" as part of the ["core"](https://www.tidyverse.org/packages/) set of tidyverse.

We see that there are some conflicts, for example, there is a function called [`filter()`](https://rdrr.io/r/stats/filter.html) (which we will talk about today) that is part of `dplyr` (a tidyverse package) that is masking another function called [`filter()`](https://rdrr.io/r/stats/filter.html) within the `stats` package (which loads with base R).

The conflict arises from the fact that there are now two functions named [`filter()`](https://rdrr.io/r/stats/filter.html). After loading the tidyverse, the default [`filter()`](https://rdrr.io/r/stats/filter.html) will be that from `dplyr`. If we want explcitly to use the [`filter()`](https://rdrr.io/r/stats/filter.html) function from `stats`, we can do that using the double colon operator [`::`](https://rdrr.io/r/base/ns-dblcolon.html) like this: [`stats::filter()`](https://rdrr.io/r/stats/filter.html).

Now this is fine for us right now, so there is nothing to do, but it is a good habit to get into reading (and not ignoring) any warnings or messages that R gives you. (It is trying to help!)

Remember, you can learn more about any package by accessing the help documentation. The help will pop up in the Help tab of the bottom right quadrant of RStudio when you execute the code below.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='o'>?</span><span class='nv'>tidyverse</span></code></pre>

</div>

<p align="center">
<img src=tidyverse-packages.png width="90%" alt="an illustration of eight hexagons with the names of the tidyverse core packages inside, dplyr, readr, purrr, tidyverse, ggplot2, tidyr, and tibble">
</p>

By [Mine Çetinkaya-Rundel](https://education.rstudio.com/blog/2020/07/teaching-the-tidyverse-in-2020-part-1-getting-started/)

Below is a quick description of what each package is used for.

-   [`dplyr`](https://dplyr.tidyverse.org/): for data manipulation
-   [`ggplot2`](https://ggplot2.tidyverse.org/): a "grammar of graphics" for creating beautiful plots
-   [`readr`](https://readr.tidyverse.org/): for reading in rectangular data (i.e., Excel-style formatting)
-   [`tibble`](https://tibble.tidyverse.org/): using tibbles as modern/better dataframes
-   [`stringr`](https://stringr.tidyverse.org/): handling strings (i.e., text or stuff in quotes)
-   [`forcats`](https://forcats.tidyverse.org/): for handling categorical variables (i.e., factors) (meow!)
-   [`tidyr`](https://tidyr.tidyverse.org/): to make "tidy data"
-   [`purrr`](https://purrr.tidyverse.org/): for enhancing functional programming (also meow!)

If you're not understanding what some of this means, that's totally fine.

There are more tidyverse packages outside of these core eight, and you can see what they are below.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://tidyverse.tidyverse.org/reference/tidyverse_packages.html'>tidyverse_packages</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt;  [1] "broom"         "cli"           "crayon"        "dbplyr"       </span>
<span class='c'>#&gt;  [5] "dplyr"         "dtplyr"        "forcats"       "googledrive"  </span>
<span class='c'>#&gt;  [9] "googlesheets4" "ggplot2"       "haven"         "hms"          </span>
<span class='c'>#&gt; [13] "httr"          "jsonlite"      "lubridate"     "magrittr"     </span>
<span class='c'>#&gt; [17] "modelr"        "pillar"        "purrr"         "readr"        </span>
<span class='c'>#&gt; [21] "readxl"        "reprex"        "rlang"         "rstudioapi"   </span>
<span class='c'>#&gt; [25] "rvest"         "stringr"       "tibble"        "tidyr"        </span>
<span class='c'>#&gt; [29] "xml2"          "tidyverse"</span></code></pre>

</div>

**tl;dr** Tidyverse has a lot of packages that make data analysis easier. None of them are 'required' to do data analysis, but many tidyverse approaches you'll find easier than using base R.

You can find [here](https://tavareshugo.github.io/data_carpentry_extras/base-r_tidyverse_equivalents/base-r_tidyverse_equivalents.html) some examples of comparing tidyverse and base R syntax.

------------------------------------------------------------------------

## 2 - Using the pipe `%>%`

The pipe operator `%>%` is a tool that is used for expressing a series of operations. It comes from the [`magrittr`](https://cran.r-project.org/web/packages/magrittr/index.html) package, and is loaded automatically when you load the tidyverse.

The purpose of the pipe is to allow you to take the output of one operation and have it be the starting material of the next step. It also (hopefully) makes your code easier to read and interpret.

**Let's get set up and grab some data so that we have some material to work with.**

<p align="center">
<img src=palmerpenguins_hex.png width="50%" alt="a cute hexagon image of three penguins as a part of the palmer penguins package">
</p>

Illustration by [Allison Horst](https://allisonhorst.github.io/palmerpenguins/articles/art.html)

We are going to use a package called [`palmerpenguins`](https://allisonhorst.github.io/palmerpenguins/) which has some fun 🐧 data for us to play with. To get this data, we need to install the `palmerpenguins` package.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='nv'>palmerpenguins</span><span class='o'>)</span></code></pre>

</div>

[`palmerpenguins`](https://allisonhorst.github.io/palmerpenguins/index.html) is a package developed by Allison Horst, Alison Hill and Kristen Gorman, including a dataset collected by Dr. Kristen Gorman at the Palmer Station Antarctica, as part of the Long Term Ecological Research Network. It is a nice, relatively simple dataset to practice data exploration and visualization in R. Plus the penguins are v cute.

Then, to use the package, we need to use the function [`library()`](https://rdrr.io/r/base/library.html) to call the package up in R.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/'>palmerpenguins</a></span><span class='o'>)</span></code></pre>

</div>

The data we will use today is called `penguins`.

<p align="center">
<img src=culmen_depth.png width="50%" alt="a cute hexagon image of three penguins as a part of the palmer penguins package">
</p>

Illustration by [Allison Horst](https://allisonhorst.github.io/palmerpenguins/articles/art.html)

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># look at the first 6 rows, all columns</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 8</span></span>
<span class='c'>#&gt;   species island bill_length_mm bill_depth_mm flipper_length_… body_mass_g sex  </span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>           </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>         </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>            </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Adelie  Torge…           39.1          18.7              181        </span><span style='text-decoration: underline;'>3</span><span>750 male </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Adelie  Torge…           39.5          17.4              186        </span><span style='text-decoration: underline;'>3</span><span>800 fema…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Adelie  Torge…           40.3          18                195        </span><span style='text-decoration: underline;'>3</span><span>250 fema…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Adelie  Torge…           </span><span style='color: #BB0000;'>NA</span><span>            </span><span style='color: #BB0000;'>NA</span><span>                 </span><span style='color: #BB0000;'>NA</span><span>          </span><span style='color: #BB0000;'>NA</span><span> </span><span style='color: #BB0000;'>NA</span><span>   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> Adelie  Torge…           36.7          19.3              193        </span><span style='text-decoration: underline;'>3</span><span>450 fema…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> Adelie  Torge…           39.3          20.6              190        </span><span style='text-decoration: underline;'>3</span><span>650 male </span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 1 more variable: year &lt;int&gt;</span></span>

<span class='c'># check the structure of penguins_data</span>
<span class='c'># glimpse() which is a part of dplyr functions </span>
<span class='c'># similarly to str() and can be used interchangeably</span>
<span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>)</span>
<span class='c'>#&gt; Rows: 344</span>
<span class='c'>#&gt; Columns: 8</span>
<span class='c'>#&gt; $ species           <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Adelie, Adelie, Adelie, Adelie, Adelie, Adelie, Adel…</span></span>
<span class='c'>#&gt; $ island            <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Torgersen, Torgersen, Torgersen, Torgersen, Torgerse…</span></span>
<span class='c'>#&gt; $ bill_length_mm    <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 39.1, 39.5, 40.3, NA, 36.7, 39.3, 38.9, 39.2, 34.1, …</span></span>
<span class='c'>#&gt; $ bill_depth_mm     <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 18.7, 17.4, 18.0, NA, 19.3, 20.6, 17.8, 19.6, 18.1, …</span></span>
<span class='c'>#&gt; $ flipper_length_mm <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 181, 186, 195, NA, 193, 190, 181, 195, 193, 190, 186…</span></span>
<span class='c'>#&gt; $ body_mass_g       <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 3750, 3800, 3250, NA, 3450, 3650, 3625, 4675, 3475, …</span></span>
<span class='c'>#&gt; $ sex               <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> male, female, female, NA, female, male, female, male…</span></span>
<span class='c'>#&gt; $ year              <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 2007, 2007, 2007, 2007, 2007, 2007, 2007, 2007, 2007…</span></span></code></pre>

</div>

Okay now we have a sense of what the `penguins` dataset is.

If we want to know how many penguins there are of each `species` we can use the function `count().` In the `count()` function, the first argument is the dataset, and the next argument is what you want to be counted. You can always learn more about the arguments and syntax of functions by using `?yourfunction()` or googling for the documentation. This is the base R way.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>count</span><span class='o'>(</span><span class='nv'>penguins</span>, <span class='nv'>species</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 2</span></span>
<span class='c'>#&gt;   species       n</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Adelie      152</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Chinstrap    68</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Gentoo      124</span></span></code></pre>

</div>

Alternatively, we can use the pipe to send `penguins` forward through a series of steps. For example, we can use the function `count()` to figure out how many of each penguin `species` there are in our dataset.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span> <span class='c'># take penguins_data</span>
  <span class='nf'>count</span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='c'># count how many of each species there is</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 2</span></span>
<span class='c'>#&gt;   species       n</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Adelie      152</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Chinstrap    68</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Gentoo      124</span></span></code></pre>

</div>

### Comparing to base R

A main benefit of the pipe is readability, and also the ability to "pipe" many things together (which we are not doing with `count()`).

I want to stress that everything you can do with the tidyverse you can also do using base R. I tend to think the tidyverse is more intuitive than base R, which is why we have elected to teach it here first. [Here](https://tavareshugo.github.io/data_carpentry_extras/base-r_tidyverse_equivalents/base-r_tidyverse_equivalents.html) you can find a bunch fo examples comparing tidyverse to base R equivalent syntax. [Here](http://varianceexplained.org/r/teach-tidyverse/) is an interesting blogpost on the topic if this is really keeping you up at night.

I am going to show you an example of a place I think the pipe really shines, don't worry if you don't understand all the syntax, I just want you to see how the pipe can be used.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> <span class='c'># drop missing values listed as NA</span>
  <span class='nf'>group_by</span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'>%&gt;%</span> <span class='c'># group by species</span>
  <span class='nf'>summarize</span><span class='o'>(</span>mean_mass <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>body_mass_g</span><span class='o'>)</span><span class='o'>)</span> <span class='c'># summarize mass into new column called </span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 2</span></span>
<span class='c'>#&gt;   species   mean_mass</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>         </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Adelie        </span><span style='text-decoration: underline;'>3</span><span>706.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Chinstrap     </span><span style='text-decoration: underline;'>3</span><span>733.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Gentoo        </span><span style='text-decoration: underline;'>5</span><span>092.</span></span></code></pre>

</div>

We are going to continue to use the pipe `%>%` as we practice with some new `dplyr` functions. <br>

------------------------------------------------------------------------

## Breakout session 1 - install tidyverse, use the pipe

<div class="alert puzzle">

<div>

In your breakout sessions, make sure that you each have the tidyverse installed and loaded.

<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"tidyverse"</span><span class='o'>)</span>
<span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"dplyr"</span><span class='o'>)</span> <span class='c'># this is the only one of the 8 tidyverse packages we will use today</span>

<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span></code></pre>

</div>

Occasionally we see people who are having tidyverse install issues, if this happens to you, please read the warning that R gives you, you may need to download an additional package to get it to work. If you have trouble, first try restarting your R session and see if that helps, or reach out to one of the organizers or one of your fellow codeclubbers.

</details>

</div>

</div>

<div class="alert puzzle">

<div>

We will practice using the pipe. In S02E02, Mike introduced you to some new functions in [Exercise 6](/codeclub/s02e02_r-intro_part2/#breakout-rooms-ii-10-min). Take the dataset `penguins` and use the pipe to determine the dimensions of the dataframe.

<details>
<summary>
Hints (click here)
</summary>

<br> Use [`dim()`](https://rdrr.io/r/base/dim.html) to determine the dimensions

<br>
</details>
<details>
<summary>
Solution (click here)
</summary>
<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 344   8</span></code></pre>

</div>

This means the dataframe is 344 rows and 8 columns in size.

</details>

</div>

</div>

<div class="alert puzzle">

<div>

Take the dataset `penguins` and use the pipe to determine the names of the columns of the dataframe.

<details>
<summary>
Hints (click here)
</summary>

<br> Use [`names()`](https://rdrr.io/r/base/names.html) or [`colnames()`](https://rdrr.io/r/base/colnames.html) to pull the column names.

<br>
</details>
<details>
<summary>
Solution (click here)
</summary>
<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/base/names.html'>names</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; [1] "species"           "island"            "bill_length_mm"   </span>
<span class='c'>#&gt; [4] "bill_depth_mm"     "flipper_length_mm" "body_mass_g"      </span>
<span class='c'>#&gt; [7] "sex"               "year"</span>

<span class='c'># the same</span>
<span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/base/colnames.html'>colnames</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; [1] "species"           "island"            "bill_length_mm"   </span>
<span class='c'>#&gt; [4] "bill_depth_mm"     "flipper_length_mm" "body_mass_g"      </span>
<span class='c'>#&gt; [7] "sex"               "year"</span></code></pre>

</div>

These are the names of our 8 columns.

</details>

</div>

</div>

------------------------------------------------------------------------

## 3 - Using `select()`

It has been estimated that the process of getting your data into the appropriate formats takes about 80% of the total time of analysis. I find that getting data into a format that enables analysis often trips people up more than doing the actual analysis. The tidyverse packages `dplyr` has a number of functions that help in data wrangling.

The first one we will talk about is `select()`. Tidyverse is nice in that the functions are very descritpive and intuitive as to what they do: `select()` allows you to pick certain columns to be included in your data frame.

Let's try out both the `%>%` and `select()`. Let's make a new dataframe from `penguins` that contains only the variables `species`, `island` and `sex`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_only_factors</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>species</span>, <span class='nv'>island</span>, <span class='nv'>sex</span><span class='o'>)</span></code></pre>

</div>

Did it work?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>penguins_only_factors</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 3</span></span>
<span class='c'>#&gt;   species island    sex   </span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Adelie  Torgersen male  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Adelie  Torgersen female</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Adelie  Torgersen female</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Adelie  Torgersen </span><span style='color: #BB0000;'>NA</span><span>    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> Adelie  Torgersen female</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> Adelie  Torgersen male</span></span></code></pre>

</div>

Let's check the dimensions of each dataframe to make sure we have what we would expect

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># what are the dimensions of penguins?</span>
<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 344   8</span>

<span class='c'># what are the dimensions of penguins_only_factors?</span>
<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>penguins_only_factors</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 344   3</span></code></pre>

</div>

The output is ordered rows (first number) by columns (second number). Our output makes sense - we haven't removed any observation (i.e., rows), we have only selected some of the columns that we want to work with.

What if we want to pick just the first three columns? We can do that too.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>)</span> <span class='c'># what are those first three columns?</span>
<span class='c'>#&gt; tibble [344 × 8] (S3: tbl_df/tbl/data.frame)</span>
<span class='c'>#&gt;  $ species          : Factor w/ 3 levels "Adelie","Chinstrap",..: 1 1 1 1 1 1 1 1 1 1 ...</span>
<span class='c'>#&gt;  $ island           : Factor w/ 3 levels "Biscoe","Dream",..: 3 3 3 3 3 3 3 3 3 3 ...</span>
<span class='c'>#&gt;  $ bill_length_mm   : num [1:344] 39.1 39.5 40.3 NA 36.7 39.3 38.9 39.2 34.1 42 ...</span>
<span class='c'>#&gt;  $ bill_depth_mm    : num [1:344] 18.7 17.4 18 NA 19.3 20.6 17.8 19.6 18.1 20.2 ...</span>
<span class='c'>#&gt;  $ flipper_length_mm: int [1:344] 181 186 195 NA 193 190 181 195 193 190 ...</span>
<span class='c'>#&gt;  $ body_mass_g      : int [1:344] 3750 3800 3250 NA 3450 3650 3625 4675 3475 4250 ...</span>
<span class='c'>#&gt;  $ sex              : Factor w/ 2 levels "female","male": 2 1 1 NA 1 2 1 2 NA NA ...</span>
<span class='c'>#&gt;  $ year             : int [1:344] 2007 2007 2007 2007 2007 2007 2007 2007 2007 2007 ...</span>

<span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>species</span><span class='o'>:</span><span class='nv'>bill_length_mm</span><span class='o'>)</span> <span class='o'>%&gt;%</span> <span class='c'># pick columns species through bill_length_mm</span>
  <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='o'>)</span> <span class='c'># you can add head() as part of your pipe!</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 3</span></span>
<span class='c'>#&gt;   species island    bill_length_mm</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>              </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Adelie  Torgersen           39.1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Adelie  Torgersen           39.5</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Adelie  Torgersen           40.3</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Adelie  Torgersen           </span><span style='color: #BB0000;'>NA</span><span>  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> Adelie  Torgersen           36.7</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> Adelie  Torgersen           39.3</span></span></code></pre>

</div>

Note, in the above chunk, this new dataframe is not being saved because we have not assigned it to anything.

You could use slightly different syntax to get the same thing using an indexing approach.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='m'>1</span><span class='o'>:</span><span class='m'>3</span><span class='o'>)</span> <span class='o'>%&gt;%</span> <span class='c'># pick columns 1-3</span>
  <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 3</span></span>
<span class='c'>#&gt;   species island    bill_length_mm</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>              </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Adelie  Torgersen           39.1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Adelie  Torgersen           39.5</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Adelie  Torgersen           40.3</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Adelie  Torgersen           </span><span style='color: #BB0000;'>NA</span><span>  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> Adelie  Torgersen           36.7</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> Adelie  Torgersen           39.3</span></span></code></pre>

</div>

There is also convenient shorthand for indicating what you *don't* want (instead of what you do).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='o'>-</span><span class='nv'>year</span><span class='o'>)</span> <span class='o'>%&gt;%</span> <span class='c'># all the columns except year</span>
  <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 7</span></span>
<span class='c'>#&gt;   species island bill_length_mm bill_depth_mm flipper_length_… body_mass_g sex  </span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>           </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>         </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>            </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Adelie  Torge…           39.1          18.7              181        </span><span style='text-decoration: underline;'>3</span><span>750 male </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Adelie  Torge…           39.5          17.4              186        </span><span style='text-decoration: underline;'>3</span><span>800 fema…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Adelie  Torge…           40.3          18                195        </span><span style='text-decoration: underline;'>3</span><span>250 fema…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Adelie  Torge…           </span><span style='color: #BB0000;'>NA</span><span>            </span><span style='color: #BB0000;'>NA</span><span>                 </span><span style='color: #BB0000;'>NA</span><span>          </span><span style='color: #BB0000;'>NA</span><span> </span><span style='color: #BB0000;'>NA</span><span>   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> Adelie  Torge…           36.7          19.3              193        </span><span style='text-decoration: underline;'>3</span><span>450 fema…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> Adelie  Torge…           39.3          20.6              190        </span><span style='text-decoration: underline;'>3</span><span>650 male</span></span></code></pre>

</div>

Embedded within `select()` is the column order - you change use the order you denote to change the order of your columns.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>bill_length_mm</span>, <span class='nv'>island</span>, <span class='nv'>flipper_length_mm</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 3</span></span>
<span class='c'>#&gt;   bill_length_mm island    flipper_length_mm</span>
<span class='c'>#&gt;            <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>                 </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span>           39.1 Torgersen               181</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span>           39.5 Torgersen               186</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span>           40.3 Torgersen               195</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span>           </span><span style='color: #BB0000;'>NA</span><span>   Torgersen                </span><span style='color: #BB0000;'>NA</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span>           36.7 Torgersen               193</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span>           39.3 Torgersen               190</span></span></code></pre>

</div>

</div>

<br>

------------------------------------------------------------------------

## 4 - Using `filter()`

<p align="center">
<img src=dplyr_filter.jpeg width="95%">
<figcaption>
Artwork by <a href="https://github.com/allisonhorst/stats-illustrations">Allison Horst</a>.
</figcaption>
</p>

[`filter()`](https://rdrr.io/r/stats/filter.html) allows you to pick certain observations (i.e, rows) based on their values to be included in your data frame. Let's see it in action.

<p align="center">
<img src=lter_penguins.png width="90%" alt="an illustration of the three cutepenguins in the palmer penguins package, chinstrap, gentoo and adélie">
<figcaption>
Artwork by <a href="https://github.com/allisonhorst/stats-illustrations">Allison Horst</a>.
</figcaption>
</p>
We will select only the "Chinstrap" penguins.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_chinstrap</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>species</span> <span class='o'>==</span> <span class='s'>"Chinstrap"</span><span class='o'>)</span> <span class='c'># note the double equals</span>

<span class='c'># let's check that it worked</span>
<span class='nv'>penguins_chinstrap</span> <span class='o'>%&gt;%</span>
  <span class='nf'>count</span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1 × 2</span></span>
<span class='c'>#&gt;   species       n</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Chinstrap    68</span></span></code></pre>

</div>

We can also check to see if we got what we would expect by looking at the dimensions of both `penguins` and `penguins_chinstrap`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 344   8</span>
<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>penguins_chinstrap</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 68  8</span></code></pre>

</div>

Great, you can see we have kept all of the columns (denoted by the second number 8), but trimmed down or rows/observations to only the Chinstrap penguins.

You can use [`filter()`](https://rdrr.io/r/stats/filter.html) in other useful ways too. Let's make a new dataframe that has only the penguins that are over 5000 g.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>big_penguins</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>body_mass_g</span> <span class='o'>&gt;</span> <span class='m'>5000</span><span class='o'>)</span>

<span class='c'># did it work?</span>
<span class='nv'>big_penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>body_mass_g</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/base/range.html'>range</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 5050 6300</span>

<span class='c'># another faster non-tidyverse way to do this</span>
<span class='nf'><a href='https://rdrr.io/r/base/range.html'>range</a></span><span class='o'>(</span><span class='nv'>big_penguins</span><span class='o'>$</span><span class='nv'>body_mass_g</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 5050 6300</span></code></pre>

</div>

You can start stacking qualifiers to get the exact penguins you want. Let's say we are only interested in penguins that are female and on the island Dream.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>sex</span> <span class='o'>==</span> <span class='s'>"female"</span> <span class='o'>&amp;</span> <span class='nv'>island</span> <span class='o'>==</span> <span class='s'>"Dream"</span><span class='o'>)</span> 
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 61 × 8</span></span>
<span class='c'>#&gt;    species island bill_length_mm bill_depth_mm flipper_length_mm body_mass_g</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>           </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>         </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>             </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> Adelie  Dream            39.5          16.7               178        </span><span style='text-decoration: underline;'>3</span><span>250</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> Adelie  Dream            39.5          17.8               188        </span><span style='text-decoration: underline;'>3</span><span>300</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> Adelie  Dream            36.4          17                 195        </span><span style='text-decoration: underline;'>3</span><span>325</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> Adelie  Dream            42.2          18.5               180        </span><span style='text-decoration: underline;'>3</span><span>550</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> Adelie  Dream            37.6          19.3               181        </span><span style='text-decoration: underline;'>3</span><span>300</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> Adelie  Dream            36.5          18                 182        </span><span style='text-decoration: underline;'>3</span><span>150</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> Adelie  Dream            36            18.5               186        </span><span style='text-decoration: underline;'>3</span><span>100</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> Adelie  Dream            37            16.9               185        </span><span style='text-decoration: underline;'>3</span><span>000</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> Adelie  Dream            36            17.9               190        </span><span style='text-decoration: underline;'>3</span><span>450</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> Adelie  Dream            37.3          17.8               191        </span><span style='text-decoration: underline;'>3</span><span>350</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 51 more rows, and 2 more variables: sex &lt;fct&gt;, year &lt;int&gt;</span></span></code></pre>

</div>

There are lots of useful generic R operators that you can use inside functions like [`filter()`](https://rdrr.io/r/stats/filter.html) including:

-   [`==`](https://rdrr.io/r/base/Comparison.html): exactly equals to
-   [`>=`](https://rdrr.io/r/base/Comparison.html): greater than or equals to, you can also use ≥
-   [`<=`](https://rdrr.io/r/base/Comparison.html): less than or equals to, you can also use ≤
-   [`&`](https://rdrr.io/r/base/Logic.html): and
-   [`|`](https://rdrr.io/r/base/Logic.html): or
-   [`!=`](https://rdrr.io/r/base/Comparison.html): not equal to
-   `!x`: not x
-   [`is.na()`](https://rdrr.io/r/base/NA.html): is NA (i.e. missing data)

There is a longer list of helpful `select()` features [here](https://dplyr.tidyverse.org/reference/select.html).

<br>

**tl;dr, `select()` picks columns/variables and [`filter()`](https://rdrr.io/r/stats/filter.html) picks rows/observations.**

## Breakout session 2 - pipe, filter, select

### Exercise 1

<div class="alert puzzle">

<div>

Make a new dataframe called `penguins_new` that includes only the columns with numeric or integer data.

<details>
<summary>
Hints (click here)
</summary>

<br> Use [`str()`](https://rdrr.io/r/utils/str.html) or `glimpse()` to figure out which columns are numeric or integers. Then use `select()` to pick only the columns you want.

<br>
</details>
<details>
<summary>
Solution (click here)
</summary>
<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>)</span>
<span class='c'>#&gt; Rows: 344</span>
<span class='c'>#&gt; Columns: 8</span>
<span class='c'>#&gt; $ species           <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Adelie, Adelie, Adelie, Adelie, Adelie, Adelie, Adel…</span></span>
<span class='c'>#&gt; $ island            <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Torgersen, Torgersen, Torgersen, Torgersen, Torgerse…</span></span>
<span class='c'>#&gt; $ bill_length_mm    <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 39.1, 39.5, 40.3, NA, 36.7, 39.3, 38.9, 39.2, 34.1, …</span></span>
<span class='c'>#&gt; $ bill_depth_mm     <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 18.7, 17.4, 18.0, NA, 19.3, 20.6, 17.8, 19.6, 18.1, …</span></span>
<span class='c'>#&gt; $ flipper_length_mm <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 181, 186, 195, NA, 193, 190, 181, 195, 193, 190, 186…</span></span>
<span class='c'>#&gt; $ body_mass_g       <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 3750, 3800, 3250, NA, 3450, 3650, 3625, 4675, 3475, …</span></span>
<span class='c'>#&gt; $ sex               <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> male, female, female, NA, female, male, female, male…</span></span>
<span class='c'>#&gt; $ year              <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 2007, 2007, 2007, 2007, 2007, 2007, 2007, 2007, 2007…</span></span>

<span class='nv'>penguins_new</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>bill_length_mm</span><span class='o'>:</span><span class='nv'>body_mass_g</span>, <span class='nv'>year</span><span class='o'>)</span>

<span class='c'># check to see if it worked</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>penguins_new</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 5</span></span>
<span class='c'>#&gt;   bill_length_mm bill_depth_mm flipper_length_mm body_mass_g  year</span>
<span class='c'>#&gt;            <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>         </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>             </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span>           39.1          18.7               181        </span><span style='text-decoration: underline;'>3</span><span>750  </span><span style='text-decoration: underline;'>2</span><span>007</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span>           39.5          17.4               186        </span><span style='text-decoration: underline;'>3</span><span>800  </span><span style='text-decoration: underline;'>2</span><span>007</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span>           40.3          18                 195        </span><span style='text-decoration: underline;'>3</span><span>250  </span><span style='text-decoration: underline;'>2</span><span>007</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span>           </span><span style='color: #BB0000;'>NA</span><span>            </span><span style='color: #BB0000;'>NA</span><span>                  </span><span style='color: #BB0000;'>NA</span><span>          </span><span style='color: #BB0000;'>NA</span><span>  </span><span style='text-decoration: underline;'>2</span><span>007</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span>           36.7          19.3               193        </span><span style='text-decoration: underline;'>3</span><span>450  </span><span style='text-decoration: underline;'>2</span><span>007</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span>           39.3          20.6               190        </span><span style='text-decoration: underline;'>3</span><span>650  </span><span style='text-decoration: underline;'>2</span><span>007</span></span></code></pre>

</div>

<br>

Getting fancy with some more advanced options

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># this works too</span>
<span class='nv'>penguins_new2</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nf'>ends_with</span><span class='o'>(</span><span class='s'>"mm"</span><span class='o'>)</span>, <span class='nv'>body_mass_g</span>, <span class='nv'>year</span><span class='o'>)</span>

<span class='c'># this works three</span>
<span class='nv'>penguins_new3</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nf'>where</span><span class='o'>(</span><span class='nv'>is.numeric</span><span class='o'>)</span> <span class='o'>|</span> <span class='nf'>where</span><span class='o'>(</span><span class='nv'>is.integer</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'># are they all the same?</span>
<span class='nf'><a href='https://rdrr.io/r/base/all.equal.html'>all.equal</a></span><span class='o'>(</span><span class='nv'>penguins_new2</span>, <span class='nv'>penguins_new3</span><span class='o'>)</span>
<span class='c'>#&gt; [1] TRUE</span></code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

### Exercise 2

<div class="alert puzzle">

<div>

Make a new dataframe called `penguins_adelie_female` that includes only the female penguins that are of the `species` Adelie.

<details>
<summary>
Hints (click here)
</summary>

<br> Use [`filter()`](https://rdrr.io/r/stats/filter.html) to set which penguins you want to keep. Use the `%>%` and `count()` to make sure what you did worked.

<br>
</details>
<details>
<summary>
Solution (click here)
</summary>
<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_adelie</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>species</span> <span class='o'>==</span> <span class='s'>"Adelie"</span> <span class='o'>&amp;</span> <span class='nv'>sex</span> <span class='o'>==</span> <span class='s'>"female"</span><span class='o'>)</span>

<span class='c'># check to see if it worked</span>
<span class='nv'>penguins_adelie</span> <span class='o'>%&gt;%</span>
  <span class='nf'>count</span><span class='o'>(</span><span class='nv'>species</span>, <span class='nv'>sex</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1 × 3</span></span>
<span class='c'>#&gt;   species sex        n</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Adelie  female    73</span></span></code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

### Exercise 3

<div class="alert puzzle">

<div>

Make a new dataframe called `penguins_dream_or_2007` that includes only the penguins on the island dream, or from the year 2007. Then make sure the dataframe only contains those variables you have filtered on.

<details>
<summary>
Hints (click here)
</summary>

<br> Use [`filter()`](https://rdrr.io/r/stats/filter.html) to set which penguins you want to keep. Use the `%>%` and `select()` to construct your new dataframe.

<br>
</details>
<details>
<summary>
Solution (click here)
</summary>
<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_dream_or_2007</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>island</span> <span class='o'>==</span> <span class='s'>"Dream"</span> <span class='o'>|</span> <span class='nv'>year</span> <span class='o'>==</span> <span class='s'>"2007"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>island</span>, <span class='nv'>year</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>penguins_dream_or_2007</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 2</span></span>
<span class='c'>#&gt;   island     year</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Torgersen  </span><span style='text-decoration: underline;'>2</span><span>007</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Torgersen  </span><span style='text-decoration: underline;'>2</span><span>007</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Torgersen  </span><span style='text-decoration: underline;'>2</span><span>007</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Torgersen  </span><span style='text-decoration: underline;'>2</span><span>007</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> Torgersen  </span><span style='text-decoration: underline;'>2</span><span>007</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> Torgersen  </span><span style='text-decoration: underline;'>2</span><span>007</span></span>

<span class='c'># did it work?</span>
<span class='nv'>penguins_dream_or_2007</span> <span class='o'>%&gt;%</span>
  <span class='nf'>count</span><span class='o'>(</span><span class='nv'>island</span>, <span class='nv'>year</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 5 × 3</span></span>
<span class='c'>#&gt;   island     year     n</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Biscoe     </span><span style='text-decoration: underline;'>2</span><span>007    44</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Dream      </span><span style='text-decoration: underline;'>2</span><span>007    46</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Dream      </span><span style='text-decoration: underline;'>2</span><span>008    34</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Dream      </span><span style='text-decoration: underline;'>2</span><span>009    44</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> Torgersen  </span><span style='text-decoration: underline;'>2</span><span>007    20</span></span></code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

## Further reading

There are many good (free) references for the tidyverse, including the book [R for Data Science](https://r4ds.had.co.nz/) by Hadley Wickham and Garrett Grolemund.

The package [`dplyr`](https://dplyr.tidyverse.org/), as part of the [`tidyverse`](https://www.rdocumentation.org/packages/tidyverse/versions/1.3.0) has a number of very helpful functions that will help you get your data into a format suitable for your analysis.

RStudio makes very useful [cheatsheets](https://www.rstudio.com/resources/cheatsheets/), including ones on tidyverse packages like `dplyr`, `ggplot2`, and others.

