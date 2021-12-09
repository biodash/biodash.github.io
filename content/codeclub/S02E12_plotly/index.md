---
title: "S02E12: Plotly"
subtitle: "Making our plots interactive"
summary: "During this session of Code Club, we will learn to make interactive plots using ggplotly."  
authors: [jessica-cooperstone]
date: "2021-12-09"
output: hugodown::md_document
toc: true
rmd_hash: 04d89795a54aab53

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

-   Using [`ggplotly()`](https://www.rdocumentation.org/packages/plotly/versions/4.9.3/topics/ggplotly) - this is what we will go over today because it has the same syntax as `ggplot()` which we have already learned
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

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>pumpkins</span> <span class='o'>&lt;-</span> <span class='nf'>read_csv</span><span class='o'>(</span><span class='s'>'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-10-19/pumpkins.csv'</span><span class='o'>)</span>
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

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>pumpkins</span> <span class='o'>&lt;-</span> <span class='nv'>pumpkins</span> <span class='o'>%&gt;%</span>
  <span class='c'># separate the year column</span>
  <span class='nf'>separate</span><span class='o'>(</span>col <span class='o'>=</span> <span class='nv'>id</span>, into <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"year"</span>, <span class='s'>"vegetable"</span><span class='o'>)</span>, sep <span class='o'>=</span> <span class='s'>"-"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='c'># find and tag the rows that do not have data</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>delete <span class='o'>=</span> <span class='nf'>str_detect</span><span class='o'>(</span><span class='nv'>place</span>, <span class='s'>"\\d*\\s*Entries"</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='c'># filter out the rows that do not have data</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>delete</span><span class='o'>==</span><span class='kc'>FALSE</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='c'># remove the tagging column</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='o'>-</span><span class='nv'>delete</span><span class='o'>)</span>

<span class='c'># rename the vegetables to their actual names</span>
<span class='nv'>pumpkins</span><span class='o'>$</span><span class='nv'>vegetable</span> <span class='o'>&lt;-</span> <span class='nv'>pumpkins</span><span class='o'>$</span><span class='nv'>vegetable</span> <span class='o'>%&gt;%</span>
  <span class='nf'>str_replace</span><span class='o'>(</span><span class='s'>"^F$"</span>, <span class='s'>"Field Pumpkin"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>str_replace</span><span class='o'>(</span><span class='s'>"^P$"</span>, <span class='s'>"Giant Pumpkin"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>str_replace</span><span class='o'>(</span><span class='s'>"^S$"</span>, <span class='s'>"Giant Squash"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>str_replace</span><span class='o'>(</span><span class='s'>"^W$"</span>, <span class='s'>"Giant Watermelon"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>str_replace</span><span class='o'>(</span><span class='s'>"^L$"</span>, <span class='s'>"Long Gourd"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>str_replace</span><span class='o'>(</span><span class='s'>"^T$"</span>, <span class='s'>"Tomato"</span><span class='o'>)</span>

<span class='c'># get rid of commas in the weight_lbs column</span>
<span class='nv'>pumpkins</span><span class='o'>$</span><span class='nv'>weight_lbs</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/numeric.html'>as.numeric</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/grep.html'>gsub</a></span><span class='o'>(</span><span class='s'>","</span>,<span class='s'>""</span>,<span class='nv'>pumpkins</span><span class='o'>$</span><span class='nv'>weight_lbs</span><span class='o'>)</span><span class='o'>)</span></code></pre>

</div>

Lets look at our data structure.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>pumpkins</span><span class='o'>)</span>
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

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>pumpkins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>vegetable</span> <span class='o'>==</span> <span class='s'>"Tomato"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>country</span>, 
             y <span class='o'>=</span> <span class='nv'>weight_lbs</span>, 
             color <span class='o'>=</span> <span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_jitter</span><span class='o'>(</span><span class='o'>)</span>
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

We can do this using by using [`guide_axis()`](https://ggplot2.tidyverse.org/reference/guide_axis.html) within a `scale` function, here, `scale_x_discrete()`. To learn more about ggplot scales, click [here](https://ggplot2-book.org/scales-guides.html).  

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>pumpkins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>vegetable</span> <span class='o'>==</span> <span class='s'>"Tomato"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>country</span>, 
             y <span class='o'>=</span> <span class='nv'>weight_lbs</span>, 
             color <span class='o'>=</span> <span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_jitter</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>scale_x_discrete</span><span class='o'>(</span>guide <span class='o'>=</span> <span class='nf'>guide_axis</span><span class='o'>(</span>n.dodge <span class='o'>=</span> <span class='m'>2</span><span class='o'>)</span><span class='o'>)</span> <span class='c'># dodge every other name</span>
</code></pre>
<img src="figs/unnamed-chunk-8-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Wow that was easy. We still have some overlapping, though we have a big figure legend that is in this case, not necessary. Lets remove it.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>pumpkins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>vegetable</span> <span class='o'>==</span> <span class='s'>"Tomato"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>country</span>, 
             y <span class='o'>=</span> <span class='nv'>weight_lbs</span>, 
             color <span class='o'>=</span> <span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_jitter</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>scale_x_discrete</span><span class='o'>(</span>guide <span class='o'>=</span> <span class='nf'>guide_axis</span><span class='o'>(</span>n.dodge <span class='o'>=</span> <span class='m'>2</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"none"</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-9-1.png" width="700px" style="display: block; margin: auto;" />

</div>

This is not the only way to fix the plot to avoid label overlap. Instead, you could put the x-axis country labels on an angle by using `theme(axis.text.x = element_text(angle = 45))`.

### 2. Reduce overplotting

For the countries that have a lot of tomato entries, its hard to see some individual data points because there are just so many of them. We can add some transparency to the datapoints such that its easier to see them. I am also playing around with `color`, `fill`, and point `shape` so you can see what changing those values does to the plot.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>pumpkins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>vegetable</span> <span class='o'>==</span> <span class='s'>"Tomato"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>country</span>, 
             y <span class='o'>=</span> <span class='nv'>weight_lbs</span>, 
             fill <span class='o'>=</span> <span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_jitter</span><span class='o'>(</span>alpha <span class='o'>=</span> <span class='m'>0.5</span>, color <span class='o'>=</span> <span class='s'>"black"</span>, shape <span class='o'>=</span> <span class='m'>21</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"none"</span>,
        axis.text.x <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>angle <span class='o'>=</span> <span class='m'>45</span><span class='o'>)</span><span class='o'>)</span> 
</code></pre>
<img src="figs/unnamed-chunk-10-1.png" width="700px" style="display: block; margin: auto;" />

</div>

We still have overplotting but I think this is an improvement.

### 3. Reorder x-axis to something meaningful

Our x-axis is currently ordered alphabetically. This is really a meaningless ordering - instead lets order our data by some characteristic of the data that we want to communicate to our viewer. For example, we could order by increasing mean tomato weight. This would tell us, just by looking at the order of the x-axis, which country has on average, the biggest tomatoes. This is something that is hard to see with the data in its current form.

Remember before we saw that each of the columns except for `weight_lbs` was of the class "character." To allow reordering, we need to change `country` to be a factor. We can do this directly in the `pumpkins` dataframe, or we can do it within the ggplot call using the pipe [`%>%`](https://magrittr.tidyverse.org/reference/pipe.html).

We will use [`fct_reorder()`](https://forcats.tidyverse.org/reference/fct_reorder.html) to do this, where we provide the the column we want to reorder (here, `country`), and what we want to reorder based on (here, `weight_lbs`), and what function to use for the reordering (here, `.fun = mean`).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>pumpkins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>vegetable</span> <span class='o'>==</span> <span class='s'>"Tomato"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>country <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/factor.html'>as.factor</a></span><span class='o'>(</span><span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nf'>fct_reorder</span><span class='o'>(</span><span class='nv'>country</span>, <span class='nv'>weight_lbs</span>, .fun <span class='o'>=</span> <span class='nv'>mean</span><span class='o'>)</span>, 
             y <span class='o'>=</span> <span class='nv'>weight_lbs</span>, 
             fill <span class='o'>=</span> <span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_jitter</span><span class='o'>(</span>alpha <span class='o'>=</span> <span class='m'>0.5</span>, color <span class='o'>=</span> <span class='s'>"black"</span>, shape <span class='o'>=</span> <span class='m'>21</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"none"</span>,
        axis.text.x <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>angle <span class='o'>=</span> <span class='m'>45</span>, hjust <span class='o'>=</span> <span class='m'>1</span><span class='o'>)</span><span class='o'>)</span> 
</code></pre>
<img src="figs/unnamed-chunk-11-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Now we can see easily that Switzerland has the heaviest tomatoes on average entered into this competition.

### 4. Pretty it up

Let's fix up the aesthetics of the plot, and adjust the axis labels, and add a title. Note, in the title, adding `\n` into your title inserts a line break.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>tomato_plot</span> <span class='o'>&lt;-</span> <span class='nv'>pumpkins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>vegetable</span> <span class='o'>==</span> <span class='s'>"Tomato"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>country <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/factor.html'>as.factor</a></span><span class='o'>(</span><span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nf'>fct_reorder</span><span class='o'>(</span><span class='nv'>country</span>, <span class='nv'>weight_lbs</span>, .fun <span class='o'>=</span> <span class='nv'>mean</span><span class='o'>)</span>, 
             y <span class='o'>=</span> <span class='nv'>weight_lbs</span>, 
             fill <span class='o'>=</span> <span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_jitter</span><span class='o'>(</span>alpha <span class='o'>=</span> <span class='m'>0.5</span>, color <span class='o'>=</span> <span class='s'>"black"</span>, shape <span class='o'>=</span> <span class='m'>21</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_classic</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"none"</span>,
        axis.text.x <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>angle <span class='o'>=</span> <span class='m'>45</span>, hjust <span class='o'>=</span> <span class='m'>1</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span> <span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Country"</span>,
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

Wow that was easy! Note that when you hover over a data point you see the information mapped in your `aes()` statement -- this is the default. We will go over ways to change this.

<br>

------------------------------------------------------------------------

## 6 - Using tooltip

Using tooltip helps you to indicate what appears when you hover over different parts of your plot. You can learn more about controlling `tooltip` [here](https://plotly-r.com/controlling-tooltips.html).

What if we want to hover over each point and be able to tell who grew that tomato?

To do this, we indicate what we want to hover with using `text =` in our aesthetic mappings. Then, we indicate `tooltip = "text"` to tell [`ggplotly()`](https://rdrr.io/pkg/plotly/man/ggplotly.html) what we want to hover.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>tomato_plot</span> <span class='o'>&lt;-</span> <span class='nv'>pumpkins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>vegetable</span> <span class='o'>==</span> <span class='s'>"Tomato"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>country <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/factor.html'>as.factor</a></span><span class='o'>(</span><span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nf'>fct_reorder</span><span class='o'>(</span><span class='nv'>country</span>, <span class='nv'>weight_lbs</span>, .fun <span class='o'>=</span> <span class='nv'>mean</span><span class='o'>)</span>, 
             y <span class='o'>=</span> <span class='nv'>weight_lbs</span>, 
             fill <span class='o'>=</span> <span class='nv'>country</span>,
             text <span class='o'>=</span> <span class='nv'>grower_name</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_jitter</span><span class='o'>(</span>alpha <span class='o'>=</span> <span class='m'>0.5</span>, color <span class='o'>=</span> <span class='s'>"black"</span>, shape <span class='o'>=</span> <span class='m'>21</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_classic</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"none"</span>,
        axis.text.x <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>angle <span class='o'>=</span> <span class='m'>45</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Country"</span>,
       y <span class='o'>=</span> <span class='s'>"Weight (in lbs)"</span>,
       title <span class='o'>=</span> <span class='s'>"Weights of Tomatoes by Country Entered \nin the Great Pumpkin Commonwealth Competition"</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/pkg/plotly/man/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>tomato_plot</span>,
         tooltip <span class='o'>=</span> <span class='s'>"text"</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

</div>

`{{< chart data="tomato2" >}}`

You can play around a lot with tooltip to get it to be exactly how you want, and you can include multiple things in your hover text.

You can add multiple items to `text`, and also use the function [`glue()`](https://glue.tidyverse.org/reference/glue.html) which allows more intuitive pasting to get your hover text to in your preferred format.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>tomato_plot</span> <span class='o'>&lt;-</span> <span class='nv'>pumpkins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>vegetable</span> <span class='o'>==</span> <span class='s'>"Tomato"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>country <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/factor.html'>as.factor</a></span><span class='o'>(</span><span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nf'>fct_reorder</span><span class='o'>(</span><span class='nv'>country</span>, <span class='nv'>weight_lbs</span>, .fun <span class='o'>=</span> <span class='nv'>mean</span><span class='o'>)</span>, 
             y <span class='o'>=</span> <span class='nv'>weight_lbs</span>, 
             fill <span class='o'>=</span> <span class='nv'>country</span>,
             text <span class='o'>=</span> <span class='nf'><a href='https://glue.tidyverse.org/reference/glue.html'>glue</a></span><span class='o'>(</span><span class='s'>"Grown by &#123;grower_name&#125;
                         From &#123;city&#125;, &#123;state_prov&#125;"</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_jitter</span><span class='o'>(</span>alpha <span class='o'>=</span> <span class='m'>0.5</span>, color <span class='o'>=</span> <span class='s'>"black"</span>, shape <span class='o'>=</span> <span class='m'>21</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_classic</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"none"</span>,
        axis.text.x <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>angle <span class='o'>=</span> <span class='m'>45</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Country"</span>,
       y <span class='o'>=</span> <span class='s'>"Weight (in lbs)"</span>,
       title <span class='o'>=</span> <span class='s'>"Weights of Tomatoes by Country Entered \nin the Great Pumpkin Commonwealth Competition"</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/pkg/plotly/man/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>tomato_plot</span>,
         tooltip <span class='o'>=</span> <span class='s'>"text"</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

</div>

`{{< chart data="tomato3" >}}`

<br>

------------------------------------------------------------------------

## 7 - Hover label aesthetics

You might not like the default hover text aesthetics, and can change them! You can do this using `style` and `layout` and adding these functions using the pipe [`%>%`](https://magrittr.tidyverse.org/reference/pipe.html).

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
<span class='nf'><a href='https://rdrr.io/pkg/plotly/man/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>tomato_plot</span>, tooltip <span class='o'>=</span> <span class='s'>"text"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/pkg/plotly/man/style.html'>style</a></span><span class='o'>(</span>hoverlabel <span class='o'>=</span> <span class='nv'>label</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
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
                             tooltip <span class='o'>=</span> <span class='s'>"text"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
                      <span class='nf'><a href='https://rdrr.io/pkg/plotly/man/style.html'>style</a></span><span class='o'>(</span>hoverlabel <span class='o'>=</span> <span class='nv'>label</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
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
You can use `drop_na()` to remove NAs. The helper `any_of()` is useful for removing NAs only from certain variables. You can also just remove any NAs, it doesn't really matter here. <br>
</details>

<br>

<details>
<summary>
Solutions (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_depth_length</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='nf'>any_of</span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"bill_depth_mm"</span>, <span class='s'>"bill_length_mm"</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_depth_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span>

<span class='nv'>bill_depth_length</span>
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

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_depth_length</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='nf'>any_of</span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"bill_depth_mm"</span>, <span class='s'>"bill_length_mm"</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_depth_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Culmen Depth (mm)"</span>,
       y <span class='o'>=</span> <span class='s'>"Culmen Length (mm)"</span>,
       title <span class='o'>=</span> <span class='s'>"Exploration of penguin bill length and depth relationships"</span><span class='o'>)</span>

<span class='nv'>bill_depth_length</span>
</code></pre>
<img src="figs/unnamed-chunk-26-1.png" width="700px" style="display: block; margin: auto;" />

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
Specify what you want your "tooltip" to be by using `text` within your `aes()` statement. <br>
</details>

<br>

<details>
<summary>
Solutions (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_depth_length</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='nf'>any_of</span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"bill_depth_mm"</span>, <span class='s'>"bill_length_mm"</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_depth_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, text <span class='o'>=</span> <span class='nv'>island</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Culmen Depth (mm)"</span>,
       y <span class='o'>=</span> <span class='s'>"Culmen Length (mm)"</span>,
       title <span class='o'>=</span> <span class='s'>"Exploration of penguin bill length and depth relationships"</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/pkg/plotly/man/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>bill_depth_length</span>,
         tooltip <span class='o'>=</span> <span class='s'>"text"</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

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
You can set fonts either within your `ggplot()` call, or setting `font` within [`layout()`](https://rdrr.io/pkg/plotly/man/layout.html). You can customize the hover label with [`style()`](https://rdrr.io/pkg/plotly/man/style.html). Use [`glue()`](https://glue.tidyverse.org/reference/glue.html) to paste in some information that helps your reader know what your hover text is referring to. <br>
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

<span class='nv'>bill_depth_length</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='nf'>any_of</span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"bill_depth_mm"</span>, <span class='s'>"bill_length_mm"</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_depth_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, 
             text <span class='o'>=</span> <span class='nf'><a href='https://glue.tidyverse.org/reference/glue.html'>glue</a></span><span class='o'>(</span><span class='s'>"Island: &#123;island&#125;
                         Sex: &#123;sex&#125;"</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Culmen Depth (mm)"</span>,
       y <span class='o'>=</span> <span class='s'>"Culmen Length (mm)"</span>,
       title <span class='o'>=</span> <span class='s'>"Exploration of penguin bill length and depth relationships"</span><span class='o'>)</span>

<span class='c'># amending our ggplotly call to include new fonts and hover label specs</span>
<span class='nf'><a href='https://rdrr.io/pkg/plotly/man/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>bill_depth_length</span>, tooltip <span class='o'>=</span> <span class='s'>"text"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/pkg/plotly/man/style.html'>style</a></span><span class='o'>(</span>hoverlabel <span class='o'>=</span> <span class='nv'>penguins_label</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/pkg/plotly/man/layout.html'>layout</a></span><span class='o'>(</span>font <span class='o'>=</span> <span class='nv'>penguins_font</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

</div>

`{{< chart data="penguins2" >}}`

</details>

<br>

</div>

</div>

<br>

------------------------------------------------------------------------

