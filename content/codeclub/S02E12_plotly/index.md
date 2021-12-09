---
title: "S02E12: Plotly"
subtitle: "Making our plots interactive"
summary: "During this session of Code Club, we will learn to make interactive plots using ggplotly."  
authors: [jessica-cooperstone]
date: "2021-12-09"
output: hugodown::md_document
toc: true
rmd_hash: e0da706bb12973bc
html_dependencies:
- <script src="htmlwidgets-1.5.4/htmlwidgets.js"></script>
- <script src="plotly-binding-4.10.0/plotly.js"></script>
- <script src="typedarray-0.1/typedarray.min.js"></script>
- <script src="jquery-3.5.1/jquery.min.js"></script>
- <link href="crosstalk-1.2.0/css/crosstalk.min.css" rel="stylesheet" />
- <script src="crosstalk-1.2.0/js/crosstalk.min.js"></script>
- <link href="plotly-htmlwidgets-css-2.5.1/plotly-htmlwidgets.css" rel="stylesheet"
  />
- <script src="plotly-main-2.5.1/plotly-latest.min.js"></script>

---

------------------------------------------------------------------------

## Prep homework

### Basic computer setup

-   If you didn't already do this, please follow the [Code Club Computer Setup](/codeclub-setup/04_ggplot2/) instructions, which also has pointers for if you're new to R or RStudio.

-   If you're able to do so, please open RStudio a bit before Code Club starts -- and in case you run into issues, please join the Zoom call early and we'll help you troubleshoot.

### New to ggplot?

Check out the PAST Code Club sessions covering `ggplot2`:

-   [S01E04](/codeclub/04_ggplot2/): intro to ggplot2
-   [S01E05](/codeclub/05_ggplot-round-2/): intro to ggplot2 round 2
-   [S01E10](/codeclub/10_faceting-animating/): faceting and animating
-   [S02E06](/codeclub/s02e06_ggplot2/): another intro to ggplot2
-   [S02E07](/codeclub/s02e07_ggplot2_part2/): a second intro to ggplot2 round 2
-   [S02E08](/codeclub/s02e08_multiple_plots/): combining plots using faceting
-   [S02E09](/codeclub/s02e09_multiple_plots_part2/): combining plots using faceting and patchwork
-   [S02E10](/codeclub/s02e10_ggpubr/): adding statistics to plots

If you've never used `ggplot2` before (or even if you have), you may find [this cheat sheet](https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf) useful.

<br>

## Getting Started

### RMarkdown for today's session

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># directory for Code Club Session 15:</span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>"S02E12"</span><span class='o'>)</span>

<span class='c'># directory for our RMarkdown</span>
<span class='c'># ("recursive" to create two levels at once.)</span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>"S02E12/Rmd/"</span><span class='o'>)</span>

<span class='c'># save the url location for today's script</span>
<span class='nv'>todays_Rmd</span> <span class='o'>&lt;-</span> 
  <span class='s'>"https://raw.githubusercontent.com/biodash/biodash.github.io/master/content/codeclub/S02E12_plotly/plotly.Rmd"</span>

<span class='c'># indicate the name of the new Rmd</span>
<span class='nv'>S02E12_Rmd</span> <span class='o'>&lt;-</span> <span class='s'>"S02E12/Rmd/S02E12_plotly.Rmd"</span>

<span class='c'># go get that file! </span>
<span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>todays_Rmd</span>,
              destfile <span class='o'>=</span> <span class='nv'>S02E12_Rmd</span><span class='o'>)</span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## 1 - What is plotly?

Today we are going to talk about making interactive plots using [Plotly](https://plotly.com/). Plotly exists in a variety of programming languages, but today we will be just talking about using it in [R](https://plotly.com/r/). All of the plotly documentation can be found [here](https://cran.r-project.org/web/packages/plotly/plotly.pdf).

If you have never used `plotly` before, install it with the code below.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"plotly"</span><span class='o'>)</span></code></pre>

</div>

Here are some useful links to find info about using `ggplotly`.

-   [Basic ggplot2 charts](https://plotly.com/ggplot2/#layout-options)
-   [Plotly R library fundamentals](https://plotly.com/r/plotly-fundamentals/)
-   [Intro to `ggplotly()`](https://plotly-r.com/overview.html#intro-ggplotly)
-   [Using `layout()`](https://plotly.com/r/reference/layout/#)
-   [`ggplotly()` tooltips](https://plotly-r.com/controlling-tooltips.html#tooltip-text-ggplotly)

Before we start, there are two basic ways to use plot in R using plotly:

-   Using [`ggplotly()`](https://www.rdocumentation.org/packages/plotly/versions/4.9.3/topics/ggplotly) - this is what we will go over today because it has the same syntax as [`ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html) which we have already learned
-   Using [`plot_ly()`](https://www.rdocumentation.org/packages/plotly/versions/4.9.3/topics/plot_ly) - there is slightly more functionality in this function, but the syntax is all new, so I'd suggest if you can do what you want with [`ggplotly()`](https://rdrr.io/pkg/plotly/man/ggplotly.html), do that. The syntax is not particularly hard so don't be scared to use it if interactive plots are something you're very interested in.

When you are googling about using plotly, you will find a combination of [`ggplotly()`](https://rdrr.io/pkg/plotly/man/ggplotly.html) and [`plot_ly()`](https://rdrr.io/pkg/plotly/man/plot_ly.html) approaches, and some parts of the code are interchangable. The easiesy way to see which parts are, is to try.

Also note, Google gets a bit confused when googling "ggplotly" and often returns information about just ggplot, so read extra carefully when problem solving.

This is an example of work from my group where we have found plotly to be particularly useful.

`{{< chart data="apples" >}}` Data from [Bilbrey et al., New Phytologist 2021](https://pubmed.ncbi.nlm.nih.gov/34472097/)

<br>

------------------------------------------------------------------------

## 2 - Load libraries, get data

Lets load the libraries we are using for today.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://plotly-r.com'>plotly</a></span><span class='o'>)</span> <span class='c'># for making interactive plots</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/tidyverse/glue'>glue</a></span><span class='o'>)</span> <span class='c'># for easy pasting</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/ramnathv/htmlwidgets'>htmlwidgets</a></span><span class='o'>)</span> <span class='c'># for saving html files</span></code></pre>

</div>

We are going to continue to use the pumpkins data we downloaded last week when we were learning about [Shiny](/codeclub/S02E11_shiny_intro/).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>pumpkins</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_csv</a></span><span class='o'>(</span><span class='s'>'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-10-19/pumpkins.csv'</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='font-weight: bold;'>Rows: </span><span style='color: #0000BB;'>28065</span> <span style='font-weight: bold;'>Columns: </span><span style='color: #0000BB;'>14</span></span>
<span class='c'>#&gt; <span style='color: #00BBBB;'>──</span> <span style='font-weight: bold;'>Column specification</span> <span style='color: #00BBBB;'>────────────────────────────────────────────────────────</span></span>
<span class='c'>#&gt; <span style='font-weight: bold;'>Delimiter:</span> ","</span>
<span class='c'>#&gt; <span style='color: #BB0000;'>chr</span> (14): id, place, weight_lbs, grower_name, city, state_prov, country, gpc...</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> Use <span style='color: #000000; background-color: #BBBBBB;'>`spec()`</span> to retrieve the full column specification for this data.</span>
<span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> Specify the column types or set <span style='color: #000000; background-color: #BBBBBB;'>`show_col_types = FALSE`</span> to quiet this message.</span></code></pre>

</div>

We will start with the wrangling that Matt shared with us last week, and then go from there.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>pumpkins</span> <span class='o'>&lt;-</span> <span class='nv'>pumpkins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='c'># separate the year column</span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/separate.html'>separate</a></span><span class='o'>(</span>col <span class='o'>=</span> <span class='nv'>id</span>, into <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"year"</span>, <span class='s'>"vegetable"</span><span class='o'>)</span>, sep <span class='o'>=</span> <span class='s'>"-"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='c'># find and tag the rows that do not have data</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>delete <span class='o'>=</span> <span class='nf'><a href='https://stringr.tidyverse.org/reference/str_detect.html'>str_detect</a></span><span class='o'>(</span><span class='nv'>place</span>, <span class='s'>"\\d*\\s*Entries"</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='c'># filter out the rows that do not have data</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>delete</span><span class='o'>==</span><span class='kc'>FALSE</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='c'># remove the tagging column</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='o'>-</span><span class='nv'>delete</span><span class='o'>)</span>

<span class='c'># rename the vegetables to their actual names</span>
<span class='nv'>pumpkins</span><span class='o'>$</span><span class='nv'>vegetable</span> <span class='o'>&lt;-</span> <span class='nv'>pumpkins</span><span class='o'>$</span><span class='nv'>vegetable</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://stringr.tidyverse.org/reference/str_replace.html'>str_replace</a></span><span class='o'>(</span><span class='s'>"^F$"</span>, <span class='s'>"Field Pumpkin"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://stringr.tidyverse.org/reference/str_replace.html'>str_replace</a></span><span class='o'>(</span><span class='s'>"^P$"</span>, <span class='s'>"Giant Pumpkin"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://stringr.tidyverse.org/reference/str_replace.html'>str_replace</a></span><span class='o'>(</span><span class='s'>"^S$"</span>, <span class='s'>"Giant Squash"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://stringr.tidyverse.org/reference/str_replace.html'>str_replace</a></span><span class='o'>(</span><span class='s'>"^W$"</span>, <span class='s'>"Giant Watermelon"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://stringr.tidyverse.org/reference/str_replace.html'>str_replace</a></span><span class='o'>(</span><span class='s'>"^L$"</span>, <span class='s'>"Long Gourd"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://stringr.tidyverse.org/reference/str_replace.html'>str_replace</a></span><span class='o'>(</span><span class='s'>"^T$"</span>, <span class='s'>"Tomato"</span><span class='o'>)</span>

<span class='c'># get rid of commas in the weight_lbs column</span>
<span class='nv'>pumpkins</span><span class='o'>$</span><span class='nv'>weight_lbs</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/numeric.html'>as.numeric</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/grep.html'>gsub</a></span><span class='o'>(</span><span class='s'>","</span>,<span class='s'>""</span>,<span class='nv'>pumpkins</span><span class='o'>$</span><span class='nv'>weight_lbs</span><span class='o'>)</span><span class='o'>)</span></code></pre>

</div>

Lets look at our data structure.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://pillar.r-lib.org/reference/glimpse.html'>glimpse</a></span><span class='o'>(</span><span class='nv'>pumpkins</span><span class='o'>)</span>
<span class='c'>#&gt; Rows: 28,011</span>
<span class='c'>#&gt; Columns: 15</span>
<span class='c'>#&gt; $ year              <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "2013", "2013", "2013", "2013", "2013", "2013", "201…</span>
<span class='c'>#&gt; $ vegetable         <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "Field Pumpkin", "Field Pumpkin", "Field Pumpkin", "…</span>
<span class='c'>#&gt; $ place             <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "1", "2", "3", "4", "5", "5", "7", "8", "9", "10", "…</span>
<span class='c'>#&gt; $ weight_lbs        <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> 154.5, 146.5, 145.0, 140.8, 139.0, 139.0, 136.5, 136…</span>
<span class='c'>#&gt; $ grower_name       <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "Ellenbecker, Todd &amp; Sequoia", "Razo, Steve", "Ellen…</span>
<span class='c'>#&gt; $ city              <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "Gleason", "New Middletown", "Glenson", "Combined Lo…</span>
<span class='c'>#&gt; $ state_prov        <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "Wisconsin", "Ohio", "Wisconsin", "Wisconsin", "Wisc…</span>
<span class='c'>#&gt; $ country           <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "United States", "United States", "United States", "…</span>
<span class='c'>#&gt; $ gpc_site          <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "Nekoosa Giant Pumpkin Fest", "Ohio Valley Giant Pum…</span>
<span class='c'>#&gt; $ seed_mother       <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "209 Werner", "150.5 Snyder", "209 Werner", "109 Mar…</span>
<span class='c'>#&gt; $ pollinator_father <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "Self", NA, "103 Mackinnon", "209 Werner '12", "open…</span>
<span class='c'>#&gt; $ ott               <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "184.0", "194.0", "177.0", "194.0", "0.0", "190.0", …</span>
<span class='c'>#&gt; $ est_weight        <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "129.00", "151.00", "115.00", "151.00", "0.00", "141…</span>
<span class='c'>#&gt; $ pct_chart         <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "20.0", "-3.0", "26.0", "-7.0", "0.0", "-1.0", "-4.0…</span>
<span class='c'>#&gt; $ variety           <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></code></pre>

</div>

Note that all of the columns have the class "character" except `weight_lbs` which is numeric. We could just fix this now, but I'm going to show you an alternative way to handle this in a minute.

<br>

------------------------------------------------------------------------

## 3 - Create base ggplot object

Using the `pumpkins` dataset lets work towards creating a plot that shows the distribution of weights of tomatoes by country. I will show you here how you can use `dplyr` functions within your `ggplot2` call.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>pumpkins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>vegetable</span> <span class='o'>==</span> <span class='s'>"Tomato"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>country</span>, 
             y <span class='o'>=</span> <span class='nv'>weight_lbs</span>, 
             color <span class='o'>=</span> <span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_jitter.html'>geom_jitter</a></span><span class='o'>(</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-7-1.png" width="700px" style="display: block; margin: auto;" />

</div>

We have a plot, its not horrible but it has a number of issues.

1.  The country names are getting cut off because some are too long, and there are enough of them that we are having overlapping.
2.  We have an [overplotting](https://www.displayr.com/what-is-overplotting/) problem
3.  The x-axis countries are ordered alphabetically. We will order our axis based on something more meaningful, like a characteristic of our data (more about this later).
4.  The aesthetics need some adjustment for a more beautiful plot

We will work on making our plot a bit better, and then we will make it interactive, such that you can hover your mouse over each datapoint, and learn more about that datapoint than what is directly visualized in the plot.

<br>

------------------------------------------------------------------------

## 4 - Optimize our base plot

### 1. Prevent country name overlap

We can do this using by using [`guide_axis()`](https://ggplot2.tidyverse.org/reference/guide_axis.html) within a `scale` function, here, [`scale_x_discrete()`](https://ggplot2.tidyverse.org/reference/scale_discrete.html). To learn more about ggplot scales, click [here](https://ggplot2-book.org/scales-guides.html).  

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>pumpkins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>vegetable</span> <span class='o'>==</span> <span class='s'>"Tomato"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>country</span>, 
             y <span class='o'>=</span> <span class='nv'>weight_lbs</span>, 
             color <span class='o'>=</span> <span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_jitter.html'>geom_jitter</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/scale_discrete.html'>scale_x_discrete</a></span><span class='o'>(</span>guide <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/guide_axis.html'>guide_axis</a></span><span class='o'>(</span>n.dodge <span class='o'>=</span> <span class='m'>2</span><span class='o'>)</span><span class='o'>)</span> <span class='c'># dodge every other name</span>
</code></pre>
<img src="figs/unnamed-chunk-8-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Wow that was easy. We still have some overlapping, though we have a big figure legend that is in this case, not necessary. Lets remove it.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>pumpkins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>vegetable</span> <span class='o'>==</span> <span class='s'>"Tomato"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>country</span>, 
             y <span class='o'>=</span> <span class='nv'>weight_lbs</span>, 
             color <span class='o'>=</span> <span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_jitter.html'>geom_jitter</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/scale_discrete.html'>scale_x_discrete</a></span><span class='o'>(</span>guide <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/guide_axis.html'>guide_axis</a></span><span class='o'>(</span>n.dodge <span class='o'>=</span> <span class='m'>2</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/theme.html'>theme</a></span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"none"</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-9-1.png" width="700px" style="display: block; margin: auto;" />

</div>

This is not the only way to fix the plot to avoid label overlap. Instead, you could put the x-axis country labels on an angle by using `theme(axis.text.x = element_text(angle = 45))`.

### 2. Reduce overplotting

For the countries that have a lot of tomato entries, its hard to see some individual data points because there are just so many of them. We can add some transparency to the datapoints such that its easier to see them. I am also playing around with `color`, `fill`, and point `shape` so you can see what changing those values does to the plot.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>pumpkins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>vegetable</span> <span class='o'>==</span> <span class='s'>"Tomato"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>country</span>, 
             y <span class='o'>=</span> <span class='nv'>weight_lbs</span>, 
             fill <span class='o'>=</span> <span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_jitter.html'>geom_jitter</a></span><span class='o'>(</span>alpha <span class='o'>=</span> <span class='m'>0.5</span>, color <span class='o'>=</span> <span class='s'>"black"</span>, shape <span class='o'>=</span> <span class='m'>21</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/theme.html'>theme</a></span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"none"</span>,
        axis.text.x <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/element.html'>element_text</a></span><span class='o'>(</span>angle <span class='o'>=</span> <span class='m'>45</span><span class='o'>)</span><span class='o'>)</span> 
</code></pre>
<img src="figs/unnamed-chunk-10-1.png" width="700px" style="display: block; margin: auto;" />

</div>

We still have overplotting but I think this is an improvement.

### 3. Reorder x-axis to something meaningful

Our x-axis is currently ordered alphabetically. This is really a meaningless ordering - instead lets order our data by some characteristic of the data that we want to communicate to our viewer. For example, we could order by increasing mean tomato weight. This would tell us, just by looking at the order of the x-axis, which country has on average, the biggest tomatoes. This is something that is hard to see with the data in its current form.

Remember before we saw that each of the columns except for `weight_lbs` was of the class "character." To allow reordering, we need to change `country` to be a factor. We can do this directly in the `pumpkins` dataframe, or we can do it within the ggplot call using the pipe `%>%`.

We will use [`fct_reorder()`](https://forcats.tidyverse.org/reference/fct_reorder.html) to do this, where we provide the the column we want to reorder (here, `country`), and what we want to reorder based on (here, `weight_lbs`), and what function to use for the reordering (here, `.fun = mean`).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>pumpkins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>vegetable</span> <span class='o'>==</span> <span class='s'>"Tomato"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>country <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/factor.html'>as.factor</a></span><span class='o'>(</span><span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nf'><a href='https://forcats.tidyverse.org/reference/fct_reorder.html'>fct_reorder</a></span><span class='o'>(</span><span class='nv'>country</span>, <span class='nv'>weight_lbs</span>, .fun <span class='o'>=</span> <span class='nv'>mean</span><span class='o'>)</span>, 
             y <span class='o'>=</span> <span class='nv'>weight_lbs</span>, 
             fill <span class='o'>=</span> <span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_jitter.html'>geom_jitter</a></span><span class='o'>(</span>alpha <span class='o'>=</span> <span class='m'>0.5</span>, color <span class='o'>=</span> <span class='s'>"black"</span>, shape <span class='o'>=</span> <span class='m'>21</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/theme.html'>theme</a></span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"none"</span>,
        axis.text.x <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/element.html'>element_text</a></span><span class='o'>(</span>angle <span class='o'>=</span> <span class='m'>45</span>, hjust <span class='o'>=</span> <span class='m'>1</span><span class='o'>)</span><span class='o'>)</span> 
</code></pre>
<img src="figs/unnamed-chunk-11-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Now we can see easily that Switzerland has the heaviest tomatoes on average entered into this competition.

### 4. Pretty it up

Let's fix up the aesthetics of the plot, and adjust the axis labels, and add a title. Note, in the title, adding `\n` into your title inserts a line break.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>tomato_plot</span> <span class='o'>&lt;-</span> <span class='nv'>pumpkins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>vegetable</span> <span class='o'>==</span> <span class='s'>"Tomato"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>country <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/factor.html'>as.factor</a></span><span class='o'>(</span><span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nf'><a href='https://forcats.tidyverse.org/reference/fct_reorder.html'>fct_reorder</a></span><span class='o'>(</span><span class='nv'>country</span>, <span class='nv'>weight_lbs</span>, .fun <span class='o'>=</span> <span class='nv'>mean</span><span class='o'>)</span>, 
             y <span class='o'>=</span> <span class='nv'>weight_lbs</span>, 
             fill <span class='o'>=</span> <span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_jitter.html'>geom_jitter</a></span><span class='o'>(</span>alpha <span class='o'>=</span> <span class='m'>0.5</span>, color <span class='o'>=</span> <span class='s'>"black"</span>, shape <span class='o'>=</span> <span class='m'>21</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggtheme.html'>theme_classic</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/theme.html'>theme</a></span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"none"</span>,
        axis.text.x <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/element.html'>element_text</a></span><span class='o'>(</span>angle <span class='o'>=</span> <span class='m'>45</span>, hjust <span class='o'>=</span> <span class='m'>1</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/labs.html'>labs</a></span> <span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Country"</span>,
        y <span class='o'>=</span> <span class='s'>"Weight (in lbs)"</span>,
        title <span class='o'>=</span> <span class='s'>"Weights of Tomatoes by Country Entered \nin the Great Pumpkin Commonwealth Competition"</span><span class='o'>)</span>

<span class='nv'>tomato_plot</span>
</code></pre>
<img src="figs/unnamed-chunk-12-1.png" width="700px" style="display: block; margin: auto;" />

</div>

## 5 - Make it interactive with `ggplotly()`

You can learn more about the [`ggplotly()`](https://rdrr.io/pkg/plotly/man/ggplotly.html) function, including its arguments [here](https://www.rdocumentation.org/packages/plotly/versions/4.9.3/topics/ggplotly).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/pkg/plotly/man/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>tomato_plot</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

</div>

`{{< chart data="tomato1" >}}`

Wow that was easy! Note that when you hover over a data point you see the information mapped in your [`aes()`](https://ggplot2.tidyverse.org/reference/aes.html) statement -- this is the default. We will go over ways to change this.

<br>

------------------------------------------------------------------------

## 6 - Using tooltip

Using tooltip helps you to indicate what appears when you hover over different parts of your plot. You can learn more about controlling `tooltip` [here](https://plotly-r.com/controlling-tooltips.html).

What if we want to hover over each point and be able to tell who grew that tomato?

To do this, we indicate what we want to hover with using `text =` in our aesthetic mappings. Then, we indicate `tooltip = "text"` to tell [`ggplotly()`](https://rdrr.io/pkg/plotly/man/ggplotly.html) what we want to hover.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>tomato_plot</span> <span class='o'>&lt;-</span> <span class='nv'>pumpkins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>vegetable</span> <span class='o'>==</span> <span class='s'>"Tomato"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>country <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/factor.html'>as.factor</a></span><span class='o'>(</span><span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nf'><a href='https://forcats.tidyverse.org/reference/fct_reorder.html'>fct_reorder</a></span><span class='o'>(</span><span class='nv'>country</span>, <span class='nv'>weight_lbs</span>, .fun <span class='o'>=</span> <span class='nv'>mean</span><span class='o'>)</span>, 
             y <span class='o'>=</span> <span class='nv'>weight_lbs</span>, 
             fill <span class='o'>=</span> <span class='nv'>country</span>,
             text <span class='o'>=</span> <span class='nv'>grower_name</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_jitter.html'>geom_jitter</a></span><span class='o'>(</span>alpha <span class='o'>=</span> <span class='m'>0.5</span>, color <span class='o'>=</span> <span class='s'>"black"</span>, shape <span class='o'>=</span> <span class='m'>21</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggtheme.html'>theme_classic</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/theme.html'>theme</a></span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"none"</span>,
        axis.text.x <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/element.html'>element_text</a></span><span class='o'>(</span>angle <span class='o'>=</span> <span class='m'>45</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/labs.html'>labs</a></span> <span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Country"</span>,
        y <span class='o'>=</span> <span class='s'>"Weight (in lbs)"</span>,
        title <span class='o'>=</span> <span class='s'>"Weights of Tomatoes by Country Entered \nin the Great Pumpkin Commonwealth Competition"</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/pkg/plotly/man/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>tomato_plot</span>,
         tooltip <span class='o'>=</span> <span class='s'>"text"</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

</div>

`{{< chart data="tomato2" >}}`

You can play around a lot with tooltip to get it to be exactly how you want, and you can include multiple things in your hover text.

You can add multiple items to `text`, and also use the function [`glue()`](https://glue.tidyverse.org/reference/glue.html) which allows more intuitive pasting to get your hover text to in your preferred format.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>tomato_plot</span> <span class='o'>&lt;-</span> <span class='nv'>pumpkins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>vegetable</span> <span class='o'>==</span> <span class='s'>"Tomato"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>country <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/factor.html'>as.factor</a></span><span class='o'>(</span><span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nf'><a href='https://forcats.tidyverse.org/reference/fct_reorder.html'>fct_reorder</a></span><span class='o'>(</span><span class='nv'>country</span>, <span class='nv'>weight_lbs</span>, .fun <span class='o'>=</span> <span class='nv'>mean</span><span class='o'>)</span>, 
             y <span class='o'>=</span> <span class='nv'>weight_lbs</span>, 
             fill <span class='o'>=</span> <span class='nv'>country</span>,
             text <span class='o'>=</span> <span class='nf'><a href='https://glue.tidyverse.org/reference/glue.html'>glue</a></span><span class='o'>(</span><span class='s'>"Grown by &#123;grower_name&#125;
                         From &#123;city&#125;, &#123;state_prov&#125;"</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_jitter.html'>geom_jitter</a></span><span class='o'>(</span>alpha <span class='o'>=</span> <span class='m'>0.5</span>, color <span class='o'>=</span> <span class='s'>"black"</span>, shape <span class='o'>=</span> <span class='m'>21</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggtheme.html'>theme_classic</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/theme.html'>theme</a></span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"none"</span>,
        axis.text.x <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/element.html'>element_text</a></span><span class='o'>(</span>angle <span class='o'>=</span> <span class='m'>45</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/labs.html'>labs</a></span> <span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Country"</span>,
        y <span class='o'>=</span> <span class='s'>"Weight (in lbs)"</span>,
        title <span class='o'>=</span> <span class='s'>"Weights of Tomatoes by Country Entered \nin the Great Pumpkin Commonwealth Competition"</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/pkg/plotly/man/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>tomato_plot</span>,
         tooltip <span class='o'>=</span> <span class='s'>"text"</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

</div>

`{{< chart data="tomato3" >}}`

<br>

------------------------------------------------------------------------

## 7 - Hover label aesthetics

You might not like the default hover text aesthetics, and can change them! You can do this using `style` and `layout` and adding these functions using the pipe `%>%`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># setting fonts for the plot</span>
<span class='nv'>font</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span>
  family <span class='o'>=</span> <span class='s'>"Calibri"</span>,
  size <span class='o'>=</span> <span class='m'>15</span>,
  color <span class='o'>=</span> <span class='s'>"white"</span><span class='o'>)</span>

<span class='c'># setting hover label specs</span>
<span class='nv'>label</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span>
  bgcolor <span class='o'>=</span> <span class='s'>"#FF0000"</span>,
  bordercolor <span class='o'>=</span> <span class='s'>"transparent"</span>,
  font <span class='o'>=</span> <span class='nv'>font</span><span class='o'>)</span> <span class='c'># we can do this bc we already set font</span>

<span class='c'># amending our ggplotly call to include new fonts and hover label specs</span>
<span class='nf'><a href='https://rdrr.io/pkg/plotly/man/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>tomato_plot</span>, tooltip <span class='o'>=</span> <span class='s'>"text"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://rdrr.io/pkg/plotly/man/style.html'>style</a></span><span class='o'>(</span>hoverlabel <span class='o'>=</span> <span class='nv'>label</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://rdrr.io/pkg/plotly/man/layout.html'>layout</a></span><span class='o'>(</span>font <span class='o'>=</span> <span class='nv'>font</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

</div>

`{{< chart data="tomato4" >}}`

<br>

------------------------------------------------------------------------

## 8 - Saving your plots

Now that you've made a beautiful interactive plot, you probably want to save it.

Assign the plot you want to save to an object, and use the function [`saveWidget()`](https://rdrr.io/pkg/htmlwidgets/man/saveWidget.html) to save it. You can find the documentation [here](https://www.rdocumentation.org/packages/htmlwidgets/versions/1.5.3/topics/saveWidget).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># assign ggplotly plot to an object</span>
<span class='nv'>ggplotly_to_save</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/plotly/man/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>tomato_plot</span>,
                             tooltip <span class='o'>=</span> <span class='s'>"text"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
                      <span class='nf'><a href='https://rdrr.io/pkg/plotly/man/style.html'>style</a></span><span class='o'>(</span>hoverlabel <span class='o'>=</span> <span class='nv'>label</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
                      <span class='nf'><a href='https://rdrr.io/pkg/plotly/man/layout.html'>layout</a></span><span class='o'>(</span>font <span class='o'>=</span> <span class='nv'>font</span><span class='o'>)</span>

<span class='c'># save</span>
<span class='nf'><a href='https://rdrr.io/pkg/htmlwidgets/man/saveWidget.html'>saveWidget</a></span><span class='o'>(</span>widget <span class='o'>=</span> <span class='nv'>ggplotly_to_save</span>,
           file <span class='o'>=</span> <span class='s'>"ggplotlying.html"</span><span class='o'>)</span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## Breakout rooms

We are going to use the `palmerpenguins` dataset called `penguins`.

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

Using the `penguins` dataset and make a base scatter plot with bill length on the y, and bill depth on the x. Remove any observations with missing data.

<details>
<summary>
Hints (click here)
</summary>
You can use [`drop_na()`](https://tidyr.tidyverse.org/reference/drop_na.html) to remove NAs. The helper [`any_of()`](https://tidyselect.r-lib.org/reference/all_of.html) is useful for removing NAs only from certain variables. You can also just remove any NAs, it doesn't really matter here. <br>
</details>

<br>

<details>
<summary>
Solutions (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_depth_length</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='nf'><a href='https://tidyselect.r-lib.org/reference/all_of.html'>any_of</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"bill_depth_mm"</span>, <span class='s'>"bill_length_mm"</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_depth_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_point.html'>geom_point</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='nv'>bill_depth_length</span>
</code></pre>
<img src="figs/unnamed-chunk-23-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### Exercise 2

<div class="puzzle">

<div>

Add appropriate x and y-axis labels, and a title to your plot.

<details>
<summary>
Hints (click here)
</summary>
You can add labels for x, y, and a title using `labs().` <br>
</details>

<br>

<details>
<summary>
Solutions (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_depth_length</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='nf'><a href='https://tidyselect.r-lib.org/reference/all_of.html'>any_of</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"bill_depth_mm"</span>, <span class='s'>"bill_length_mm"</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_depth_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_point.html'>geom_point</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/labs.html'>labs</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Culmen Depth (mm)"</span>,
       y <span class='o'>=</span> <span class='s'>"Culmen Length (mm)"</span>,
       title <span class='o'>=</span> <span class='s'>"Exploration penguin bill length and depth relationships"</span><span class='o'>)</span>

<span class='nv'>bill_depth_length</span>
</code></pre>
<img src="figs/unnamed-chunk-24-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### Exercise 3

<div class="puzzle">

<div>

Make your plot interactive such that when you hover over a point, it tell you what island the penguin is from.

<details>
<summary>
Hints (click here)
</summary>
Specify what you want your "tooltip" to be by using `text` within your [`aes()`](https://ggplot2.tidyverse.org/reference/aes.html) statement. <br>
</details>

<br>

<details>
<summary>
Solutions (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_depth_length</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='nf'><a href='https://tidyselect.r-lib.org/reference/all_of.html'>any_of</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"bill_depth_mm"</span>, <span class='s'>"bill_length_mm"</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_depth_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, text <span class='o'>=</span> <span class='nv'>island</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_point.html'>geom_point</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/labs.html'>labs</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Culmen Depth (mm)"</span>,
       y <span class='o'>=</span> <span class='s'>"Culmen Length (mm)"</span>,
       title <span class='o'>=</span> <span class='s'>"Exploration penguin bill length and depth relationships"</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/pkg/plotly/man/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>bill_depth_length</span>,
         tooltip <span class='o'>=</span> <span class='s'>"text"</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

<div id="htmlwidget-f2b0a4dd19805e678c06" style="width:700px;height:415.296px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-f2b0a4dd19805e678c06">{"x":{"data":[{"x":[18.7,17.4,18,19.3,20.6,17.8,19.6,18.1,20.2,17.1,17.3,17.6,21.2,21.1,17.8,19,20.7,18.4,21.5,18.3,18.7,19.2,18.1,17.2,18.9,18.6,17.9,18.6,18.9,16.7,18.1,17.8,18.9,17,21.1,20,18.5,19.3,19.1,18,18.4,18.5,19.7,16.9,18.8,19,18.9,17.9,21.2,17.7,18.9,17.9,19.5,18.1,18.6,17.5,18.8,16.6,19.1,16.9,21.1,17,18.2,17.1,18,16.2,19.1,16.6,19.4,19,18.4,17.2,18.9,17.5,18.5,16.8,19.4,16.1,19.1,17.2,17.6,18.8,19.4,17.8,20.3,19.5,18.6,19.2,18.8,18,18.1,17.1,18.1,17.3,18.9,18.6,18.5,16.1,18.5,17.9,20,16,20,18.6,18.9,17.2,20,17,19,16.5,20.3,17.7,19.5,20.7,18.3,17,20.5,17,18.6,17.2,19.8,17,18.5,15.9,19,17.6,18.3,17.1,18,17.9,19.2,18.5,18.5,17.6,17.5,17.5,20.1,16.5,17.9,17.1,17.2,15.5,17,16.8,18.7,18.6,18.4,17.8,18.1,17.1,18.5,13.2,16.3,14.1,15.2,14.5,13.5,14.6,15.3,13.4,15.4,13.7,16.1,13.7,14.6,14.6,15.7,13.5,15.2,14.5,15.1,14.3,14.5,14.5,15.8,13.1,15.1,14.3,15,14.3,15.3,15.3,14.2,14.5,17,14.8,16.3,13.7,17.3,13.6,15.7,13.7,16,13.7,15,15.9,13.9,13.9,15.9,13.3,15.8,14.2,14.1,14.4,15,14.4,15.4,13.9,15,14.5,15.3,13.8,14.9,13.9,15.7,14.2,16.8,14.4,16.2,14.2,15,15,15.6,15.6,14.8,15,16,14.2,16.3,13.8,16.4,14.5,15.6,14.6,15.9,13.8,17.3,14.4,14.2,14,17,15,17.1,14.5,16.1,14.7,15.7,15.8,14.6,14.4,16.5,15,17,15.5,15,13.8,16.1,14.7,15.8,14,15.1,15.2,15.9,15.2,16.3,14.1,16,15.7,16.2,13.7,14.3,15.7,14.8,16.1,17.9,19.5,19.2,18.7,19.8,17.8,18.2,18.2,18.9,19.9,17.8,20.3,17.3,18.1,17.1,19.6,20,17.8,18.6,18.2,17.3,17.5,16.6,19.4,17.9,19,18.4,19,17.8,20,16.6,20.8,16.7,18.8,18.6,16.8,18.3,20.7,16.6,19.9,19.5,17.5,19.1,17,17.9,18.5,17.9,19.6,18.7,17.3,16.4,19,17.3,19.7,17.3,18.8,16.6,19.9,18.8,19.4,19.5,16.5,17,19.8,18.1,18.2,19,18.7],"y":[39.1,39.5,40.3,36.7,39.3,38.9,39.2,34.1,42,37.8,37.8,41.1,38.6,34.6,36.6,38.7,42.5,34.4,46,37.8,37.7,35.9,38.2,38.8,35.3,40.6,40.5,37.9,40.5,39.5,37.2,39.5,40.9,36.4,39.2,38.8,42.2,37.6,39.8,36.5,40.8,36,44.1,37,39.6,41.1,37.5,36,42.3,39.6,40.1,35,42,34.5,41.4,39,40.6,36.5,37.6,35.7,41.3,37.6,41.1,36.4,41.6,35.5,41.1,35.9,41.8,33.5,39.7,39.6,45.8,35.5,42.8,40.9,37.2,36.2,42.1,34.6,42.9,36.7,35.1,37.3,41.3,36.3,36.9,38.3,38.9,35.7,41.1,34,39.6,36.2,40.8,38.1,40.3,33.1,43.2,35,41,37.7,37.8,37.9,39.7,38.6,38.2,38.1,43.2,38.1,45.6,39.7,42.2,39.6,42.7,38.6,37.3,35.7,41.1,36.2,37.7,40.2,41.4,35.2,40.6,38.8,41.5,39,44.1,38.5,43.1,36.8,37.5,38.1,41.1,35.6,40.2,37,39.7,40.2,40.6,32.1,40.7,37.3,39,39.2,36.6,36,37.8,36,41.5,46.1,50,48.7,50,47.6,46.5,45.4,46.7,43.3,46.8,40.9,49,45.5,48.4,45.8,49.3,42,49.2,46.2,48.7,50.2,45.1,46.5,46.3,42.9,46.1,44.5,47.8,48.2,50,47.3,42.8,45.1,59.6,49.1,48.4,42.6,44.4,44,48.7,42.7,49.6,45.3,49.6,50.5,43.6,45.5,50.5,44.9,45.2,46.6,48.5,45.1,50.1,46.5,45,43.8,45.5,43.2,50.4,45.3,46.2,45.7,54.3,45.8,49.8,46.2,49.5,43.5,50.7,47.7,46.4,48.2,46.5,46.4,48.6,47.5,51.1,45.2,45.2,49.1,52.5,47.4,50,44.9,50.8,43.4,51.3,47.5,52.1,47.5,52.2,45.5,49.5,44.5,50.8,49.4,46.9,48.4,51.1,48.5,55.9,47.2,49.1,47.3,46.8,41.7,53.4,43.3,48.1,50.5,49.8,43.5,51.5,46.2,55.1,44.5,48.8,47.2,46.8,50.4,45.2,49.9,46.5,50,51.3,45.4,52.7,45.2,46.1,51.3,46,51.3,46.6,51.7,47,52,45.9,50.5,50.3,58,46.4,49.2,42.4,48.5,43.2,50.6,46.7,52,50.5,49.5,46.4,52.8,40.9,54.2,42.5,51,49.7,47.5,47.6,52,46.9,53.5,49,46.2,50.9,45.5,50.9,50.8,50.1,49,51.5,49.8,48.1,51.4,45.7,50.7,42.5,52.2,45.2,49.3,50.2,45.6,51.9,46.8,45.7,55.8,43.5,49.6,50.8,50.2],"text":["Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Biscoe","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream","Dream"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(0,0,0,1)","opacity":1,"size":5.66929133858268,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(0,0,0,1)"}},"hoveron":"points","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":45.3561496061829,"r":7.30593607305936,"b":41.7762409303838,"l":37.2602739726027},"plot_bgcolor":"rgba(235,235,235,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187},"title":{"text":"Exploration penguin bill length and depth relationships","font":{"color":"rgba(0,0,0,1)","family":"","size":17.5342465753425},"x":0,"xref":"paper"},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[12.68,21.92],"tickmode":"array","ticktext":["15.0","17.5","20.0"],"tickvals":[15,17.5,20],"categoryorder":"array","categoryarray":["15.0","17.5","20.0"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"y","title":{"text":"Culmen Depth (mm)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[30.725,60.975],"tickmode":"array","ticktext":["40","50","60"],"tickvals":[40,50,60],"categoryorder":"array","categoryarray":["40","50","60"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"x","title":{"text":"Culmen Length (mm)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":null,"line":{"color":null,"width":0,"linetype":[]},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":false,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.88976377952756,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.689497716895}},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"source":"A","attrs":{"7938555e7f7b":{"x":{},"y":{},"text":{},"type":"scatter"}},"cur_data":"7938555e7f7b","visdat":{"7938555e7f7b":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>

</div>

`{{< chart data="penguins1" >}}`

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### Exercise 4

<div class="puzzle">

<div>

Add the sex of the penguin to the hover text, change the hover text so that the background color is red, and make all the fonts for the plot something other than the default.

<details>
<summary>
Hints (click here)
</summary>
You can set fonts either within your [`ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html) call, or setting `font` within [`layout()`](https://rdrr.io/pkg/plotly/man/layout.html). You can customize the hover label with [`style()`](https://rdrr.io/pkg/plotly/man/style.html). Use [`glue()`](https://glue.tidyverse.org/reference/glue.html) to paste in some information that helps your reader know what your hover text is referring to. <br>
</details>

<br>

<details>
<summary>
Solutions (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># setting fonts for the plot</span>
<span class='nv'>penguins_font</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span>
  family <span class='o'>=</span> <span class='s'>"Proxima Nova"</span>, <span class='c'># this is the official OSU font</span>
  size <span class='o'>=</span> <span class='m'>15</span>,
  color <span class='o'>=</span> <span class='s'>"white"</span><span class='o'>)</span>

<span class='c'># setting hover label specs</span>
<span class='nv'>penguins_label</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span>
  bgcolor <span class='o'>=</span> <span class='s'>"blue"</span>,
  bordercolor <span class='o'>=</span> <span class='s'>"transparent"</span>,
  font <span class='o'>=</span> <span class='nv'>penguins_font</span><span class='o'>)</span> <span class='c'># we can do this bc we already set font</span>

<span class='nv'>bill_depth_length</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='nf'><a href='https://tidyselect.r-lib.org/reference/all_of.html'>any_of</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"bill_depth_mm"</span>, <span class='s'>"bill_length_mm"</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_depth_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, 
             text <span class='o'>=</span> <span class='nf'><a href='https://glue.tidyverse.org/reference/glue.html'>glue</a></span><span class='o'>(</span><span class='s'>"Island: &#123;island&#125;
                         Sex: &#123;sex&#125;"</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_point.html'>geom_point</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/labs.html'>labs</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Culmen Depth (mm)"</span>,
       y <span class='o'>=</span> <span class='s'>"Culmen Length (mm)"</span>,
       title <span class='o'>=</span> <span class='s'>"Exploration penguin bill length and depth relationships"</span><span class='o'>)</span>

<span class='c'># amending our ggplotly call to include new fonts and hover label specs</span>
<span class='nf'><a href='https://rdrr.io/pkg/plotly/man/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>bill_depth_length</span>, tooltip <span class='o'>=</span> <span class='s'>"text"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://rdrr.io/pkg/plotly/man/style.html'>style</a></span><span class='o'>(</span>hoverlabel <span class='o'>=</span> <span class='nv'>penguins_label</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://rdrr.io/pkg/plotly/man/layout.html'>layout</a></span><span class='o'>(</span>font <span class='o'>=</span> <span class='nv'>penguins_font</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

<div id="htmlwidget-487506e04afe37315640" style="width:700px;height:415.296px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-487506e04afe37315640">{"x":{"data":[{"x":[18.7,17.4,18,19.3,20.6,17.8,19.6,18.1,20.2,17.1,17.3,17.6,21.2,21.1,17.8,19,20.7,18.4,21.5,18.3,18.7,19.2,18.1,17.2,18.9,18.6,17.9,18.6,18.9,16.7,18.1,17.8,18.9,17,21.1,20,18.5,19.3,19.1,18,18.4,18.5,19.7,16.9,18.8,19,18.9,17.9,21.2,17.7,18.9,17.9,19.5,18.1,18.6,17.5,18.8,16.6,19.1,16.9,21.1,17,18.2,17.1,18,16.2,19.1,16.6,19.4,19,18.4,17.2,18.9,17.5,18.5,16.8,19.4,16.1,19.1,17.2,17.6,18.8,19.4,17.8,20.3,19.5,18.6,19.2,18.8,18,18.1,17.1,18.1,17.3,18.9,18.6,18.5,16.1,18.5,17.9,20,16,20,18.6,18.9,17.2,20,17,19,16.5,20.3,17.7,19.5,20.7,18.3,17,20.5,17,18.6,17.2,19.8,17,18.5,15.9,19,17.6,18.3,17.1,18,17.9,19.2,18.5,18.5,17.6,17.5,17.5,20.1,16.5,17.9,17.1,17.2,15.5,17,16.8,18.7,18.6,18.4,17.8,18.1,17.1,18.5,13.2,16.3,14.1,15.2,14.5,13.5,14.6,15.3,13.4,15.4,13.7,16.1,13.7,14.6,14.6,15.7,13.5,15.2,14.5,15.1,14.3,14.5,14.5,15.8,13.1,15.1,14.3,15,14.3,15.3,15.3,14.2,14.5,17,14.8,16.3,13.7,17.3,13.6,15.7,13.7,16,13.7,15,15.9,13.9,13.9,15.9,13.3,15.8,14.2,14.1,14.4,15,14.4,15.4,13.9,15,14.5,15.3,13.8,14.9,13.9,15.7,14.2,16.8,14.4,16.2,14.2,15,15,15.6,15.6,14.8,15,16,14.2,16.3,13.8,16.4,14.5,15.6,14.6,15.9,13.8,17.3,14.4,14.2,14,17,15,17.1,14.5,16.1,14.7,15.7,15.8,14.6,14.4,16.5,15,17,15.5,15,13.8,16.1,14.7,15.8,14,15.1,15.2,15.9,15.2,16.3,14.1,16,15.7,16.2,13.7,14.3,15.7,14.8,16.1,17.9,19.5,19.2,18.7,19.8,17.8,18.2,18.2,18.9,19.9,17.8,20.3,17.3,18.1,17.1,19.6,20,17.8,18.6,18.2,17.3,17.5,16.6,19.4,17.9,19,18.4,19,17.8,20,16.6,20.8,16.7,18.8,18.6,16.8,18.3,20.7,16.6,19.9,19.5,17.5,19.1,17,17.9,18.5,17.9,19.6,18.7,17.3,16.4,19,17.3,19.7,17.3,18.8,16.6,19.9,18.8,19.4,19.5,16.5,17,19.8,18.1,18.2,19,18.7],"y":[39.1,39.5,40.3,36.7,39.3,38.9,39.2,34.1,42,37.8,37.8,41.1,38.6,34.6,36.6,38.7,42.5,34.4,46,37.8,37.7,35.9,38.2,38.8,35.3,40.6,40.5,37.9,40.5,39.5,37.2,39.5,40.9,36.4,39.2,38.8,42.2,37.6,39.8,36.5,40.8,36,44.1,37,39.6,41.1,37.5,36,42.3,39.6,40.1,35,42,34.5,41.4,39,40.6,36.5,37.6,35.7,41.3,37.6,41.1,36.4,41.6,35.5,41.1,35.9,41.8,33.5,39.7,39.6,45.8,35.5,42.8,40.9,37.2,36.2,42.1,34.6,42.9,36.7,35.1,37.3,41.3,36.3,36.9,38.3,38.9,35.7,41.1,34,39.6,36.2,40.8,38.1,40.3,33.1,43.2,35,41,37.7,37.8,37.9,39.7,38.6,38.2,38.1,43.2,38.1,45.6,39.7,42.2,39.6,42.7,38.6,37.3,35.7,41.1,36.2,37.7,40.2,41.4,35.2,40.6,38.8,41.5,39,44.1,38.5,43.1,36.8,37.5,38.1,41.1,35.6,40.2,37,39.7,40.2,40.6,32.1,40.7,37.3,39,39.2,36.6,36,37.8,36,41.5,46.1,50,48.7,50,47.6,46.5,45.4,46.7,43.3,46.8,40.9,49,45.5,48.4,45.8,49.3,42,49.2,46.2,48.7,50.2,45.1,46.5,46.3,42.9,46.1,44.5,47.8,48.2,50,47.3,42.8,45.1,59.6,49.1,48.4,42.6,44.4,44,48.7,42.7,49.6,45.3,49.6,50.5,43.6,45.5,50.5,44.9,45.2,46.6,48.5,45.1,50.1,46.5,45,43.8,45.5,43.2,50.4,45.3,46.2,45.7,54.3,45.8,49.8,46.2,49.5,43.5,50.7,47.7,46.4,48.2,46.5,46.4,48.6,47.5,51.1,45.2,45.2,49.1,52.5,47.4,50,44.9,50.8,43.4,51.3,47.5,52.1,47.5,52.2,45.5,49.5,44.5,50.8,49.4,46.9,48.4,51.1,48.5,55.9,47.2,49.1,47.3,46.8,41.7,53.4,43.3,48.1,50.5,49.8,43.5,51.5,46.2,55.1,44.5,48.8,47.2,46.8,50.4,45.2,49.9,46.5,50,51.3,45.4,52.7,45.2,46.1,51.3,46,51.3,46.6,51.7,47,52,45.9,50.5,50.3,58,46.4,49.2,42.4,48.5,43.2,50.6,46.7,52,50.5,49.5,46.4,52.8,40.9,54.2,42.5,51,49.7,47.5,47.6,52,46.9,53.5,49,46.2,50.9,45.5,50.9,50.8,50.1,49,51.5,49.8,48.1,51.4,45.7,50.7,42.5,52.2,45.2,49.3,50.2,45.6,51.9,46.8,45.7,55.8,43.5,49.6,50.8,50.2],"text":["Island: Torgersen<br />Sex: male","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: male","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: male","Island: Torgersen<br />Sex: NA","Island: Torgersen<br />Sex: NA","Island: Torgersen<br />Sex: NA","Island: Torgersen<br />Sex: NA","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: male","Island: Torgersen<br />Sex: male","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: male","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: male","Island: Dream<br />Sex: NA","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: male","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: male","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: male","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: male","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: male","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: male","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: male","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: male","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: male","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: male","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: male","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: male","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: male","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: male","Island: Torgersen<br />Sex: female","Island: Torgersen<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: NA","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: NA","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: NA","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: NA","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Biscoe<br />Sex: female","Island: Biscoe<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female","Island: Dream<br />Sex: male","Island: Dream<br />Sex: male","Island: Dream<br />Sex: female"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(0,0,0,1)","opacity":1,"size":5.66929133858268,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(0,0,0,1)"}},"hoveron":"points","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null,"hoverlabel":{"bgcolor":"blue","bordercolor":"transparent","font":{"family":"Proxima Nova","size":15,"color":"white"}}}],"layout":{"margin":{"t":45.3561496061829,"r":7.30593607305936,"b":41.7762409303838,"l":37.2602739726027},"plot_bgcolor":"rgba(235,235,235,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"white","family":"Proxima Nova","size":15},"title":{"text":"Exploration penguin bill length and depth relationships","font":{"color":"rgba(0,0,0,1)","family":"","size":17.5342465753425},"x":0,"xref":"paper"},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[12.68,21.92],"tickmode":"array","ticktext":["15.0","17.5","20.0"],"tickvals":[15,17.5,20],"categoryorder":"array","categoryarray":["15.0","17.5","20.0"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"y","title":{"text":"Culmen Depth (mm)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[30.725,60.975],"tickmode":"array","ticktext":["40","50","60"],"tickvals":[40,50,60],"categoryorder":"array","categoryarray":["40","50","60"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"x","title":{"text":"Culmen Length (mm)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":null,"line":{"color":null,"width":0,"linetype":[]},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":false,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.88976377952756,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.689497716895}},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"source":"A","attrs":{"79381b390e6b":{"x":{},"y":{},"text":{},"type":"scatter"}},"cur_data":"79381b390e6b","visdat":{"79381b390e6b":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>

</div>

`{{< chart data="penguins2" >}}`

</details>

<br>

</div>

</div>

<br>

------------------------------------------------------------------------

