---
title: "Session 5: ggplot2, round 2"
subtitle: "Getting up close and personal with our data"
summary: "During this fifth session of Code Club, we will be continuing to learn to use ggplot2, including techniques that better enable us to see our true data distribution."  
authors: [jessica-cooperstone]
date: 2021-01-15
lastmod: 2021-01-15
output: hugodown::md_document
toc: true

image: 
  caption: "Artwork by @allison_horst"
  focal_point: ""
  preview_only: false

rmd_hash: 7b46ac376c4f09de

---

<br> <br> <br>

------------------------------------------------------------------------

Prep homework
-------------

### Basic computer setup

-   If you didn't already do this, please follow the [Code Club Computer Setup](/codeclub-setup/04_ggplot2/) instructions, which also has pointers for if you're new to R or RStudio.

-   If you're able to do so, please open RStudio a bit before Code Club starts -- and in case you run into issues, please join the Zoom call early and we'll troubleshoot.

### New to ggplot?

Check out the last Code Club [Session 4](/codeclub/) on Visualizing Data.

If you've never used `ggplot2` before (or even if you have), you may find [this cheat sheet](https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf) useful.

<br>

------------------------------------------------------------------------

Getting Started
---------------

### Script for today's session

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># directory for Code Club Session 2:</span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>"S05"</span><span class='o'>)</span>

<span class='c'># directory for our script</span>
<span class='c'># ("recursive" to create two levels at once.)</span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>"S05/scripts/"</span><span class='o'>)</span>

<span class='c'># save the url location for today's script</span>
<span class='nv'>todays_R_script</span> <span class='o'>&lt;-</span> <span class='s'>'https://raw.githubusercontent.com/biodash/biodash.github.io/master/content/codeclub/05_ggplot-round-2/Session5_ggplot2.R'</span>

<span class='c'># indicate the name of the new script file</span>
<span class='nv'>Session5_script</span> <span class='o'>&lt;-</span> <span class='s'>"S05/scripts/Session5_script.R"</span>

<span class='c'># go get that file! </span>
<span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>todays_R_script</span>,
              destfile <span class='o'>=</span> <span class='nv'>Session5_script</span><span class='o'>)</span>
</code></pre>

</div>

<br>

------------------------------------------------------------------------

1 - Why visualize our data?
---------------------------

<p align="center">
<img src=ggplot2_exploratory.png width="95%" alt="ggplot2 exploratory cartoon">
</p>

Artwork by [Allison Horst](https://github.com/allisonhorst/stats-illustrations)

We make data visualizations for two main reasons:

1.  To explore our data
2.  To share our data with others

Often, we think about figure generation as the last part of the scientic process, something you do as you prepare a manuscript for publication. I hope to convince you that exploring your data, and making exploratory plots is a critical part of the data analysis and interpretation process.

Today we will be using [`ggplot2`](https://ggplot2.tidyverse.org/) to make a series of plots that help us better understand the underlying structure in our dataset.

**When summary statistics don't cut it**

<p align="center">
<img src=DinoSequentialSmaller.gif width="95%">
</p>

This ["Datasaurus Dozen"](https://www.autodesk.com/research/publications/same-stats-different-graphs) shows the value of looking at your data beyond means and standard deviations. In the gif above, created by [Alberto Cairo](http://albertocairo.com/), each of these 13 datasets have identical means, standard eviations, and correlations to two decimal places. And one of the datasets is a dinosaur!

<br>

<div class="alert alert-note">

<div>

**What will we go over today**

These geoms will help you to get better acquainted with your data.

-   [`geom_col()`](https://ggplot2.tidyverse.org/reference/geom_bar.html) - makes bar plots. I will show you how to do this and then recommend that you don't.
-   [`geom_boxplot()`](https://ggplot2.tidyverse.org/reference/geom_boxplot.html) - makes infinitely useful boxplots.
-   [`geom_violin()`](https://ggplot2.tidyverse.org/reference/geom_violin.html) - makes violin plots, a hybrid between a boxplot and a density plot. Very musical.
-   [`geom_density_ridges()`](https://mran.microsoft.com/snapshot/2017-12-11/web/packages/ggridges/vignettes/introduction.html) - a density plot giving you the impression of a side view of a mountain range. Requires the package [`ggridges`](https://cran.r-project.org/web/packages/ggridges/index.html)
-   [`geom_jitter()`](https://ggplot2.tidyverse.org/reference/geom_jitter.html) - adds all datapoints to your plot, and jitters them to handle overplotting.

I will also go over a few tricks along the way, including [`coord_flip()`](https://ggplot2.tidyverse.org/reference/coord_flip.html), adding labels using [`labs()`](https://ggplot2.tidyverse.org/reference/labs.html), and changing the overall look of the plot with [`theme()`](https://ggplot2.tidyverse.org/reference/theme.html), or pre-set themes like [`theme_classic()`](https://ggplot2.tidyverse.org/reference/ggtheme.html) which is my go-to.

</div>

</div>

<br>

------------------------------------------------------------------------

2 - Accessing our data
----------------------

**Let's get set up and grab some data so that we can learn more about penguins (and ggplot2)**

-   You can do this locally, or at OSC. You can find instructions if you are having trouble [here](/codeclub-setup/).

First load your libraries.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
</code></pre>

</div>

Then let's access the wintry [palmerpenguins](https://allisonhorst.github.io/palmerpenguins/) dataset. We will then look at `penguins`, the dataset we will be using for the first part of today's Code Club. This data is collected on penguins from the [Palmer Station Antarctica Long-Term Ecological Research](https://pal.lternet.edu/) study area.

<p align="center">
<img src=penguins.png width="95%" alt="cartoon of the palmer penguins">
</p>

Artwork by [Allison Horst](https://github.com/allisonhorst/palmerpenguins)

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"palmerpenguins"</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/'>palmerpenguins</a></span><span class='o'>)</span>
</code></pre>

</div>

Let's look at the data in `penguins`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># look at the first 6 rows, all columns</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 8</span></span>
<span class='c'>#&gt;   species island bill_length_mm bill_depth_mm flipper_length_… body_mass_g sex  </span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>           </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>         </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>            </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Adelie  Torge…           39.1          18.7              181        </span><span style='text-decoration: underline;'>3</span><span>750 male </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Adelie  Torge…           39.5          17.4              186        </span><span style='text-decoration: underline;'>3</span><span>800 fema…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Adelie  Torge…           40.3          18                195        </span><span style='text-decoration: underline;'>3</span><span>250 fema…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Adelie  Torge…           </span><span style='color: #BB0000;'>NA</span><span>            </span><span style='color: #BB0000;'>NA</span><span>                 </span><span style='color: #BB0000;'>NA</span><span>          </span><span style='color: #BB0000;'>NA</span><span> </span><span style='color: #BB0000;'>NA</span><span>   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> Adelie  Torge…           36.7          19.3              193        </span><span style='text-decoration: underline;'>3</span><span>450 fema…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> Adelie  Torge…           39.3          20.6              190        </span><span style='text-decoration: underline;'>3</span><span>650 male </span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 1 more variable: year </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>


<span class='c'># check the structure</span>
<span class='c'># this tell us what is contained within our df</span>
<span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>)</span>

<span class='c'>#&gt; Rows: 344</span>
<span class='c'>#&gt; Columns: 8</span>
<span class='c'>#&gt; $ species           <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Adelie, Adelie, Adelie, Adelie, Adelie, Adelie, Ade…</span></span>
<span class='c'>#&gt; $ island            <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Torgersen, Torgersen, Torgersen, Torgersen, Torgers…</span></span>
<span class='c'>#&gt; $ bill_length_mm    <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 39.1, 39.5, 40.3, NA, 36.7, 39.3, 38.9, 39.2, 34.1,…</span></span>
<span class='c'>#&gt; $ bill_depth_mm     <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 18.7, 17.4, 18.0, NA, 19.3, 20.6, 17.8, 19.6, 18.1,…</span></span>
<span class='c'>#&gt; $ flipper_length_mm <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 181, 186, 195, NA, 193, 190, 181, 195, 193, 190, 18…</span></span>
<span class='c'>#&gt; $ body_mass_g       <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 3750, 3800, 3250, NA, 3450, 3650, 3625, 4675, 3475,…</span></span>
<span class='c'>#&gt; $ sex               <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> male, female, female, NA, female, male, female, mal…</span></span>
<span class='c'>#&gt; $ year              <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 2007, 2007, 2007, 2007, 2007, 2007, 2007, 2007, 200…</span></span>
</code></pre>

</div>

This dataset contains the following measurements about penguins at Palmer Station in Antarctica:

-   `species`
-   `island`
-   `bill_length_mm`
-   `bill_depth_mm`
-   `flipper_length_mm`
-   `body_mass_g`
-   `sex`
-   `year`

We are going to be plotting to get an understanding of `bill_length_mm` which is the length of the bill from the penguins face, protruding outwards (and more easily understood in the image below).

<p align="center">
<img src=culmen_depth.png width="95%" alt="depiction of bill length protruding from the penguins face, and bill depth, the height of the bill parallel to the ground">
</p>

Artwork by [Allison Horst](https://github.com/allisonhorst/palmerpenguins)

<br>

------------------------------------------------------------------------

3 - Removing NAs
----------------

Sometimes you will have NAs (or missing data). That might be informative to you, but here we are going to remove missing data using [`drop_na()`](https://tidyr.tidyverse.org/reference/drop_na.html), and assign it to a new dataframe called `penguins_noNA`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># check dimensions of penguins</span>
<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 344   8</span>


<span class='c'># remove NAs</span>
<span class='nv'>penguins_noNA</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>penguins_noNA</span><span class='o'>)</span> <span class='c'># we have removed 11 observations</span>

<span class='c'>#&gt; [1] 333   8</span>
</code></pre>

</div>

**Note - by removing NAs, we have gotten rid of 11 observations**

<br>

------------------------------------------------------------------------

4 - Bar charts with `geom_col()` and `stat_summary()`
-----------------------------------------------------

Often, people use bar charts, representing the height or the length of the bar as proportional to the average value that it represents. These charts are sometimes called dynamite plots because they resemble (when they have an error bar with whisker) those cartoon style dynamite sticks. Pow!

However, these bar charts, even if you add a standard deviation/error, really can hide the true distribution of your data, and for this reason, I and [others](https://simplystatistics.org/2019/02/21/dynamite-plots-must-die/) hope you don't select to make them.

I hope after today, you see that there is always a better chart type to make than a bar chart. But I will show you how to make them anyway.

Before we plot, let's calculate some summary statistics so we know what we should expect.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># calculating mean bill_length_mm by species</span>
<span class='nv'>penguins_noNA</span> <span class='o'>%&gt;%</span>
  <span class='nf'>group_by</span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>summarize</span><span class='o'>(</span>mean_bill_length <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; `summarise()` ungrouping output (override with `.groups` argument)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 x 2</span></span>
<span class='c'>#&gt;   species   mean_bill_length</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>                </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Adelie                38.8</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Chinstrap             48.8</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Gentoo                47.6</span></span>
</code></pre>

</div>

Just calling `geom_col()` does not give us what we want. Look at the y-axis scale and how out of line this is with our summary statistics.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># bar plot with geom_col()</span>
<span class='c'># this is wrong!</span>
<span class='nv'>penguins_noNA</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_col</span><span class='o'>(</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-8-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Using `geom_col()` the right way.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># bar plot, the right way with geom_col()</span>
<span class='nv'>penguins_noNA</span> <span class='o'>%&gt;%</span>
  <span class='nf'>group_by</span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>summarize</span><span class='o'>(</span>mean_bill_length <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>mean_bill_length</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_col</span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#&gt; `summarise()` ungrouping output (override with `.groups` argument)</span>

</code></pre>
<img src="figs/unnamed-chunk-9-1.png" width="700px" style="display: block; margin: auto;" />
<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># or you could do this in a less bulky way with stat_summary()</span>
<span class='nv'>penguins_noNA</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>stat_summary</span><span class='o'>(</span>fun <span class='o'>=</span> <span class='s'>"mean"</span>, geom <span class='o'>=</span> <span class='s'>"bar"</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-9-2.png" width="700px" style="display: block; margin: auto;" />

</div>

<br>

------------------------------------------------------------------------

5 - Boxplots with `geom_boxplot()`
----------------------------------

A boxplot has the benefit of showing you more than the median and the standard deviation, so you can better see the true distribution of your data. In `geom_boxplot()`:

-   lower whisker = smallest observation greater than or equal to lower hinge - 1.5 \* IQR
-   lower hinge/bottom line of box part of boxplot = 25% quantile
-   middle = median, 50% quantile
-   upper hinge/top line of box part of boxplot = 75% quantile
-   upper whisker = largest observation less than or equal to upper hinge + 1.5 \* IQR

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># vertical boxplot</span>
<span class='nv'>penguins_noNA</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-10-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Adding `coord_flip()` makes your vertical boxplot horizontal. You could do the same thing by flipping the variables on the `x` and `y` mappings.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># horizontal boxplot</span>
<span class='nv'>penguins_noNA</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>coord_flip</span><span class='o'>(</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-11-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Look at how much more information we have here than in our bar plots!

<br>

------------------------------------------------------------------------

5 - Violin plots with `geom_violin()`
-------------------------------------

A violin plot is boxplot-esque, but shows a mirrored density distribution. This type of plot is useful when you are trying to particularly show data distribution.

Note here I have also mapped `species` to `color`, within the `aes` statement so it will apply globally to this plot.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># violin plot</span>
<span class='nv'>penguins_noNA</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, color <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_violin</span><span class='o'>(</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-12-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Adding `geom_point()` lets you add another layer of all the actual data points, on top of your violin plot. Remember that this is inherent in the design of ggplot2, that you can layer your plots, of different types, on top of each other.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># violin plot with data points overlaid</span>
<span class='nv'>penguins_noNA</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, fill <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_violin</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-13-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Note, I am now mapping `species` to `fill` instead of `color`. See the difference?

This doesn't look too good because of overplotting, i.e., the smear of datapoints that doesn't give you much information about distribution.

We can add `geom_jitter()` to introduce some small amount of randomness to our points to make us able to see them better. Seeing all your data points also lets the reader easily get a sense of your sample size.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># violin plot with data points jittered</span>
<span class='nv'>penguins_noNA</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, fill <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_violin</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_jitter</span><span class='o'>(</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-14-1.png" width="700px" style="display: block; margin: auto;" />

</div>

`geom_jitter()` is a specialized version of `geom_point()`, but you could replace the `geom_jitter()` call with `geom_point(position = "jitter)` and get the same result. You can also use `geom_point(position = position_jitterdodge())` if you only want jitter in the x, and don't want any jitter in the y.

Wow, we now have so much more information about our data!

<br>

------------------------------------------------------------------------

6 - Dot plots with `geom_dotplot()`
-----------------------------------

A dot plot plots each individual datapoint, and can stack how you like. These look a lot like the SigmaPlot plots to me.

-   `binaxis` can be set to "x" or "y"
-   `stackdir` indicates how to stack the dots: "up" (default), "down", "center", "centerwhole" (centered, but with dots aligned)
-   `dotsize` indicates the size of the dots, with 1 as default

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># dotplot</span>
<span class='nv'>penguins_noNA</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, fill <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_dotplot</span><span class='o'>(</span>binaxis <span class='o'>=</span> <span class='s'>"y"</span>, stackdir <span class='o'>=</span> <span class='s'>"center"</span>, dotsize <span class='o'>=</span> <span class='m'>0.5</span><span class='o'>)</span>

<span class='c'>#&gt; `stat_bindot()` using `bins = 30`. Pick better value with `binwidth`.</span>

</code></pre>
<img src="figs/unnamed-chunk-15-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<br>

------------------------------------------------------------------------

7 - Density ridge plots with [`geom_density_ridges()`](https://wilkelab.org/ggridges/reference/geom_density_ridges.html)
----------------------------------------------------

A density ridge plots with [`geom_density_ridges()`](https://www.rdocumentation.org/packages/ggridges/versions/0.5.2/topics/geom_density_ridges) requires the packages `ggridges`, and make multiple density plots in a staggered orientation.

You can adjust `scale` within [`geom_density_ridges()`](https://wilkelab.org/ggridges/reference/geom_density_ridges.html) to adjust the size of each density plot, though I have left it on the default. Adding `alpha` sets transparency.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># install.packages("ggridges")</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://wilkelab.org/ggridges/'>ggridges</a></span><span class='o'>)</span>
<span class='nv'>penguins_noNA</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>species</span>, fill <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://wilkelab.org/ggridges/reference/geom_density_ridges.html'>geom_density_ridges</a></span><span class='o'>(</span>alpha <span class='o'>=</span> <span class='m'>0.8</span><span class='o'>)</span>

<span class='c'>#&gt; Picking joint bandwidth of 1.08</span>

</code></pre>
<img src="figs/unnamed-chunk-16-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<br>

------------------------------------------------------------------------

8 - ggplot is made for layering!
--------------------------------

I have shown you a bunch of different plot types, and you can combine many of them together. Here is an example of combining `geom_violin()` and `geom_jitter()`, while mapping new variables to aesthetics.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_noNA</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, 
             color <span class='o'>=</span> <span class='nv'>sex</span>, 
             shape <span class='o'>=</span> <span class='nv'>island</span>, 
             group <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_violin</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_jitter</span><span class='o'>(</span>position <span class='o'>=</span> <span class='nf'>position_jitterdodge</span><span class='o'>(</span>jitter.width <span class='o'>=</span> <span class='m'>2</span><span class='o'>)</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-17-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<br>

------------------------------------------------------------------------

9 - Increase clarity and visual appeal
--------------------------------------

We can quickly make our plot:

-   prettier by setting a `theme`
-   more clear by setting plot labels (eg., axes, titles, legend) with `labs`

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_noNA</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, 
             color <span class='o'>=</span> <span class='nv'>sex</span>, 
             shape <span class='o'>=</span> <span class='nv'>island</span>, 
             group <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_violin</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_jitter</span><span class='o'>(</span>position <span class='o'>=</span> <span class='nf'>position_jitterdodge</span><span class='o'>(</span>jitter.width <span class='o'>=</span> <span class='m'>2</span><span class='o'>)</span>,
              alpha <span class='o'>=</span> <span class='m'>0.7</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_classic</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Penguin Bill Length by Species, Sex and Location"</span>,
       subtitle <span class='o'>=</span> <span class='s'>"Collected at Palmer Station, Antarctica"</span>,
       x <span class='o'>=</span> <span class='s'>"Penguin Species"</span>, <span class='c'># x axis label</span>
       y <span class='o'>=</span> <span class='s'>"Bill length (mm)"</span>, <span class='c'>#  y axis label</span>
       color <span class='o'>=</span> <span class='s'>"Sex"</span>, <span class='c'># legend title</span>
       shape <span class='o'>=</span> <span class='s'>"Island"</span><span class='o'>)</span> <span class='c'># legend title</span>

</code></pre>
<img src="figs/unnamed-chunk-18-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<br>

------------------------------------------------------------------------

10 - Breakout rooms!
--------------------

### Main exercises

#### Get data

We are going to use the NHANES dataset we used in [Session 3](/codeclub/s03_joining-datasets/) on joining. What was that data about again? Let's refresh our memory.

<div class="highlight">

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'>NHANES</span><span class='o'>)</span>
<span class='nf'>knitr</span><span class='nf'>::</span><span class='nf'><a href='https://rdrr.io/pkg/knitr/man/kable.html'>kable</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>NHANES</span><span class='o'>)</span><span class='o'>)</span> 

</code></pre>

|     ID| SurveyYr | Gender |  Age| AgeDecade |  AgeMonths| Race1 | Race3 | Education    | MaritalStatus | HHIncome    |  HHIncomeMid|  Poverty|  HomeRooms| HomeOwn | Work       |  Weight|  Length|  HeadCirc|  Height|    BMI| BMICatUnder20yrs | BMI\_WHO   |  Pulse|  BPSysAve|  BPDiaAve|  BPSys1|  BPDia1|  BPSys2|  BPDia2|  BPSys3|  BPDia3|  Testosterone|  DirectChol|  TotChol|  UrineVol1|  UrineFlow1|  UrineVol2|  UrineFlow2| Diabetes |  DiabetesAge| HealthGen |  DaysPhysHlthBad|  DaysMentHlthBad| LittleInterest | Depressed |  nPregnancies|  nBabies|  Age1stBaby|  SleepHrsNight| SleepTrouble | PhysActive |  PhysActiveDays| TVHrsDay | CompHrsDay |  TVHrsDayChild|  CompHrsDayChild| Alcohol12PlusYr |  AlcoholDay|  AlcoholYear| SmokeNow | Smoke100 | Smoke100n |  SmokeAge| Marijuana |  AgeFirstMarij| RegularMarij |  AgeRegMarij| HardDrugs | SexEver |  SexAge|  SexNumPartnLife|  SexNumPartYear| SameSex | SexOrientation | PregnantNow |
|------:|:---------|:-------|----:|:----------|----------:|:------|:------|:-------------|:--------------|:------------|------------:|--------:|----------:|:--------|:-----------|-------:|-------:|---------:|-------:|------:|:-----------------|:-----------|------:|---------:|---------:|-------:|-------:|-------:|-------:|-------:|-------:|-------------:|-----------:|--------:|----------:|-----------:|----------:|-----------:|:---------|------------:|:----------|----------------:|----------------:|:---------------|:----------|-------------:|--------:|-----------:|--------------:|:-------------|:-----------|---------------:|:---------|:-----------|--------------:|----------------:|:----------------|-----------:|------------:|:---------|:---------|:----------|---------:|:----------|--------------:|:-------------|------------:|:----------|:--------|-------:|----------------:|---------------:|:--------|:---------------|:------------|
|  51624| 2009\_10 | male   |   34| 30-39     |        409| White | NA    | High School  | Married       | 25000-34999 |        30000|     1.36|          6| Own     | NotWorking |    87.4|      NA|        NA|   164.7|  32.22| NA               | 30.0\_plus |     70|       113|        85|     114|      88|     114|      88|     112|      82|            NA|        1.29|     3.49|        352|          NA|         NA|          NA| No       |           NA| Good      |                0|               15| Most           | Several   |            NA|       NA|          NA|              4| Yes          | No         |              NA| NA       | NA         |             NA|               NA| Yes             |          NA|            0| No       | Yes      | Smoker    |        18| Yes       |             17| No           |           NA| Yes       | Yes     |      16|                8|               1| No      | Heterosexual   | NA          |
|  51624| 2009\_10 | male   |   34| 30-39     |        409| White | NA    | High School  | Married       | 25000-34999 |        30000|     1.36|          6| Own     | NotWorking |    87.4|      NA|        NA|   164.7|  32.22| NA               | 30.0\_plus |     70|       113|        85|     114|      88|     114|      88|     112|      82|            NA|        1.29|     3.49|        352|          NA|         NA|          NA| No       |           NA| Good      |                0|               15| Most           | Several   |            NA|       NA|          NA|              4| Yes          | No         |              NA| NA       | NA         |             NA|               NA| Yes             |          NA|            0| No       | Yes      | Smoker    |        18| Yes       |             17| No           |           NA| Yes       | Yes     |      16|                8|               1| No      | Heterosexual   | NA          |
|  51624| 2009\_10 | male   |   34| 30-39     |        409| White | NA    | High School  | Married       | 25000-34999 |        30000|     1.36|          6| Own     | NotWorking |    87.4|      NA|        NA|   164.7|  32.22| NA               | 30.0\_plus |     70|       113|        85|     114|      88|     114|      88|     112|      82|            NA|        1.29|     3.49|        352|          NA|         NA|          NA| No       |           NA| Good      |                0|               15| Most           | Several   |            NA|       NA|          NA|              4| Yes          | No         |              NA| NA       | NA         |             NA|               NA| Yes             |          NA|            0| No       | Yes      | Smoker    |        18| Yes       |             17| No           |           NA| Yes       | Yes     |      16|                8|               1| No      | Heterosexual   | NA          |
|  51625| 2009\_10 | male   |    4| 0-9       |         49| Other | NA    | NA           | NA            | 20000-24999 |        22500|     1.07|          9| Own     | NA         |    17.0|      NA|        NA|   105.4|  15.30| NA               | 12.0\_18.5 |     NA|        NA|        NA|      NA|      NA|      NA|      NA|      NA|      NA|            NA|          NA|       NA|         NA|          NA|         NA|          NA| No       |           NA| NA        |               NA|               NA| NA             | NA        |            NA|       NA|          NA|             NA| NA           | NA         |              NA| NA       | NA         |              4|                1| NA              |          NA|           NA| NA       | NA       | NA        |        NA| NA        |             NA| NA           |           NA| NA        | NA      |      NA|               NA|              NA| NA      | NA             | NA          |
|  51630| 2009\_10 | female |   49| 40-49     |        596| White | NA    | Some College | LivePartner   | 35000-44999 |        40000|     1.91|          5| Rent    | NotWorking |    86.7|      NA|        NA|   168.4|  30.57| NA               | 30.0\_plus |     86|       112|        75|     118|      82|     108|      74|     116|      76|            NA|        1.16|     6.70|         77|       0.094|         NA|          NA| No       |           NA| Good      |                0|               10| Several        | Several   |             2|        2|          27|              8| Yes          | No         |              NA| NA       | NA         |             NA|               NA| Yes             |           2|           20| Yes      | Yes      | Smoker    |        38| Yes       |             18| No           |           NA| Yes       | Yes     |      12|               10|               1| Yes     | Heterosexual   | NA          |
|  51638| 2009\_10 | male   |    9| 0-9       |        115| White | NA    | NA           | NA            | 75000-99999 |        87500|     1.84|          6| Rent    | NA         |    29.8|      NA|        NA|   133.1|  16.82| NA               | 12.0\_18.5 |     82|        86|        47|      84|      50|      84|      50|      88|      44|            NA|        1.34|     4.86|        123|       1.538|         NA|          NA| No       |           NA| NA        |               NA|               NA| NA             | NA        |            NA|       NA|          NA|             NA| NA           | NA         |              NA| NA       | NA         |              5|                0| NA              |          NA|           NA| NA       | NA       | NA        |        NA| NA        |             NA| NA           |           NA| NA        | NA      |      NA|               NA|              NA| NA      | NA             | NA          |

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># kable just formats as a scrollable table for this website</span>
<span class='c'># you can just use head(NHANES) or glimpse(NHANES)</span>
</code></pre>

</div>

------------------------------------------------------------------------

#### Exercise 1

<div class="puzzle">

<div>

Create a new data frame includes the NHANES data only from individuals that are 20 years of age or older, and removes observations where there are NAs for either age subdivided by decade (`AgeDecade`) or total cholesterol (`TotChol`).

<details>

<summary> Hints (click here) </summary>

Try using a series of [`filter()`](https://rdrr.io/r/stats/filter.html) statements. Remember, you can tell filter what you want, or what you don't want. You can filter for if specific variables have NAs by using [`is.na()`](https://rdrr.io/r/base/NA.html) on your variable of interest. Also remember that [`!`](https://rdrr.io/r/base/Logic.html) means "not." You will notice that if you want to use `drop_NA()` you need to specific which specific variables you want to use, or you will inadvertably drop a lot of observations which have missing data for variables other than those we are plotting.. <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># here are a few ways to do this</span>
<span class='nv'>NHANES_over20_noNA</span> <span class='o'>&lt;-</span> <span class='nv'>NHANES</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>Age</span> <span class='o'>&gt;</span><span class='m'>20</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='nv'>AgeDecade</span>, <span class='nv'>TotChol</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>NHANES_over20_noNA</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 6408   76</span>


<span class='nv'>NHANES_over20_noNA</span> <span class='o'>&lt;-</span> <span class='nv'>NHANES</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>Age</span> <span class='o'>&gt;</span><span class='m'>20</span>,
         <span class='o'>!</span><span class='nf'><a href='https://rdrr.io/r/base/NA.html'>is.na</a></span><span class='o'>(</span><span class='nv'>AgeDecade</span><span class='o'>)</span>,
         <span class='o'>!</span><span class='nf'><a href='https://rdrr.io/r/base/NA.html'>is.na</a></span><span class='o'>(</span><span class='nv'>TotChol</span><span class='o'>)</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>NHANES_over20_noNA</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 6408   76</span>
</code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

#### Exercise 2

<div class="puzzle">

<div>

Create a boxplot to show the relationship between total cholesterol (`TotChol`) and age (`AgeDecade`).

<details>

<summary> Hints (click here) </summary>

Try `geom_boxplot()`. Map your variables of interest to the `x` and `y` aesthetics. Which you variable you put on `x` and `y` will determine if your boxplot is vertical or horizontal. <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>NHANES_over20_noNA</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>AgeDecade</span>, y <span class='o'>=</span> <span class='nv'>TotChol</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-22-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

#### Exercise 3

<div class="puzzle">

<div>

Take your plot from Exercise 2 and make it a violin plot instead of a boxplot. Then color by age.

<details>

<summary> Hints (click here) </summary>

The geom for a violin plot is `geom_violin()`. You can change color by mapping to `color` or to `fill`. <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

Note the difference between mapping to `color` vs. `fill`.  

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>NHANES_over20_noNA</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>AgeDecade</span>, y <span class='o'>=</span> <span class='nv'>TotChol</span>, color <span class='o'>=</span> <span class='nv'>AgeDecade</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_violin</span><span class='o'>(</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-23-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>NHANES_over20_noNA</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>AgeDecade</span>, y <span class='o'>=</span> <span class='nv'>TotChol</span>, fill <span class='o'>=</span> <span class='nv'>AgeDecade</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_violin</span><span class='o'>(</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-24-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

#### Exercise 4

<div class="puzzle">

<div>

Make add a boxplot to your violin plot from Exercise 3. Adjust the parameters so you the plot looks good to you.

<details>

<summary> Hints (click here) </summary>

In `geom_boxplot()`, you can adjust the width of the boxplot by setting `width = X`. A width of 1 is the default. <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>NHANES_over20_noNA</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>AgeDecade</span>, y <span class='o'>=</span> <span class='nv'>TotChol</span>, color <span class='o'>=</span> <span class='nv'>AgeDecade</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_violin</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>width <span class='o'>=</span> <span class='m'>0.2</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-25-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

#### Exercise 5

<div class="puzzle">

<div>

Add all of the data points on top of your boxplot from Exercise 2 of total cholesterol by age. Adjust the parameters so you the plot looks good to you. While you are at it, clean up your plot labels and give your plot a title.

<details>

<summary> Hints (click here) </summary>

Remember that ggplot layers your plots, so layers that are further down in your code, will be applied on top of those that come earlier. <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

`geom_boxplot(outlier.shape = NA)` removes the outliers from `geom_boxplot()`, since we are plotting all of the points, we do not want the outliers appearing twice.  

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>NHANES_over20_noNA</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>AgeDecade</span>, y <span class='o'>=</span> <span class='nv'>TotChol</span>, color <span class='o'>=</span> <span class='nv'>AgeDecade</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>outlier.shape <span class='o'>=</span> <span class='kc'>NA</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>geom_jitter</span><span class='o'>(</span>width <span class='o'>=</span> <span class='m'>0.3</span>, alpha <span class='o'>=</span> <span class='m'>0.1</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Total Cholesterol by Age"</span>,
       subtitle <span class='o'>=</span> <span class='s'>"Data from the National Health and Nutrition Examination Survey (NHANES)"</span>,
       x <span class='o'>=</span> <span class='s'>"Age, by Decade"</span>,
       y <span class='o'>=</span> <span class='s'>"Total Cholesterol, mmol/L"</span>,
       color <span class='o'>=</span> <span class='s'>"Age (years)"</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-26-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### Bonus exercises

#### Bonus 1

<div class="puzzle">

<div>

Make a density ridge plot for age by total cholesterol.

<details>

<summary> Hints (click here) </summary>

Try [`geom_density_ridges()`](https://wilkelab.org/ggridges/reference/geom_density_ridges.html), and remember, this is not a part of `ggplot2`, so be sure to call [`library(ggridges)`](https://wilkelab.org/ggridges/). <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># install.packages("ggridges")</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://wilkelab.org/ggridges/'>ggridges</a></span><span class='o'>)</span>
<span class='nv'>NHANES_over20_noNA</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>TotChol</span>, y <span class='o'>=</span> <span class='nv'>AgeDecade</span>, fill <span class='o'>=</span> <span class='nv'>AgeDecade</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://wilkelab.org/ggridges/reference/geom_density_ridges.html'>geom_density_ridges</a></span><span class='o'>(</span>alpha <span class='o'>=</span> <span class='m'>0.7</span><span class='o'>)</span> 

<span class='c'>#&gt; Picking joint bandwidth of 0.224</span>

</code></pre>
<img src="figs/unnamed-chunk-27-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

#### Bonus 2

<div class="puzzle">

<div>

Take your density ridge plot from Bonus 1, and try applying a theme from `hrbrthemes` to it.

<details>

<summary> Hints (click here) </summary>

`hrbrthemes` is not part of `ggplot2` so remember to install the package, and then call [`library(hrbrthemes)`](http://github.com/hrbrmstr/hrbrthemes). You can google the package to see what all your theme options are. I like [`theme_ipsum_rc()`](https://rdrr.io/pkg/hrbrthemes/man/theme_ipsum_rc.html), try that one if you like! <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># install.packages("hrbrthemes")</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://github.com/hrbrmstr/hrbrthemes'>hrbrthemes</a></span><span class='o'>)</span>

<span class='c'>#&gt; NOTE: Either Arial Narrow or Roboto Condensed fonts are required to use these themes.</span>

<span class='c'>#&gt;       Please use hrbrthemes::import_roboto_condensed() to install Roboto Condensed and</span>

<span class='c'>#&gt;       if Arial Narrow is not on your system, please see https://bit.ly/arialnarrow</span>

<span class='nv'>NHANES_over20_noNA</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>TotChol</span>, y <span class='o'>=</span> <span class='nv'>AgeDecade</span>, fill <span class='o'>=</span> <span class='nv'>AgeDecade</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://wilkelab.org/ggridges/reference/geom_density_ridges.html'>geom_density_ridges</a></span><span class='o'>(</span>alpha <span class='o'>=</span> <span class='m'>0.7</span>, scale <span class='o'>=</span> <span class='m'>0.9</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://rdrr.io/pkg/hrbrthemes/man/theme_ipsum_rc.html'>theme_ipsum_rc</a></span><span class='o'>(</span><span class='o'>)</span> 

<span class='c'>#&gt; Picking joint bandwidth of 0.224</span>

</code></pre>
<img src="figs/unnamed-chunk-28-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

#### Bonus 3

<div class="puzzle">

<div>

Tidy up your plot from Bonus 2 by giving it a title, axis labels, and try adding the median total cholesterol to each density ridge plot.

<details>

<summary> Hints (click here) </summary>

Using [`stat_summary()`](https://ggplot2.tidyverse.org/reference/stat_summary.html) will help you add the median.  
<br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

-   `theme(axis.title.x = element_text(hjust = 0.5))` makes the x-axis title center justified.
-   you can change `shape` within `stat_summary()` to be anything you like, either an R shape, a specific keyboard key, or even a pasted emoji. The default is a point.
-   when you set a `theme()`, anything that comes below will override what code comes previous, so for this reason, if you are going to amend a pre-made theme, first call the pre-made theme, and then make any changes you like below.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>NHANES_over20_noNA</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>TotChol</span>, y <span class='o'>=</span> <span class='nv'>AgeDecade</span>, fill <span class='o'>=</span> <span class='nv'>AgeDecade</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://wilkelab.org/ggridges/reference/geom_density_ridges.html'>geom_density_ridges</a></span><span class='o'>(</span>alpha <span class='o'>=</span> <span class='m'>0.7</span>, scale <span class='o'>=</span> <span class='m'>0.9</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>stat_summary</span><span class='o'>(</span>fun <span class='o'>=</span> <span class='nv'>median</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://rdrr.io/pkg/hrbrthemes/man/theme_ipsum_rc.html'>theme_ipsum_rc</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>axis.title.x <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>hjust <span class='o'>=</span> <span class='m'>0.5</span><span class='o'>)</span>,
        axis.title.y <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>hjust <span class='o'>=</span> <span class='m'>0.5</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Total Cholesterol by Age"</span>,
       subtitle <span class='o'>=</span> <span class='s'>"Data from the National Health and Nutrition Examination Survey (NHANES)"</span>,
       x <span class='o'>=</span> <span class='s'>"Total Cholesterol, mmol/L"</span>,
       y <span class='o'>=</span> <span class='s'>"Age, by Decade"</span>,
       fill <span class='o'>=</span> <span class='s'>"Age (years)"</span><span class='o'>)</span>

<span class='c'>#&gt; Picking joint bandwidth of 0.224</span>

<span class='c'>#&gt; Warning: Removed 6 rows containing missing values (geom_segment).</span>

</code></pre>
<img src="figs/unnamed-chunk-29-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

#### Bonus 4

<div class="puzzle">

<div>

Commonly used cutoffs for cholesterol are: \< 5.2 mmol/L is normal, 5.2-6.2 mmol/L is borderline high and \> 6.2 mmol is high. Add a vertical cutoff line showing the level below which cholesterol would be considered normal.

<details>

<summary> Hints (click here) </summary>

Using [`geom_vline()`](https://ggplot2.tidyverse.org/reference/geom_abline.html) will let you add a vertical line with an `xintercept` that is appropriate. <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>NHANES_over20_noNA</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>TotChol</span>, y <span class='o'>=</span> <span class='nv'>AgeDecade</span>, fill <span class='o'>=</span> <span class='nv'>AgeDecade</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://wilkelab.org/ggridges/reference/geom_density_ridges.html'>geom_density_ridges</a></span><span class='o'>(</span>alpha <span class='o'>=</span> <span class='m'>0.7</span>, scale <span class='o'>=</span> <span class='m'>0.9</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>stat_summary</span><span class='o'>(</span>fun <span class='o'>=</span> <span class='nv'>median</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_vline</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>xintercept <span class='o'>=</span> <span class='m'>5.2</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://rdrr.io/pkg/hrbrthemes/man/theme_ipsum_rc.html'>theme_ipsum_rc</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>axis.title.x <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>hjust <span class='o'>=</span> <span class='m'>0.5</span><span class='o'>)</span>,
        axis.title.y <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>hjust <span class='o'>=</span> <span class='m'>0.5</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Total Cholesterol by Age"</span>,
       subtitle <span class='o'>=</span> <span class='s'>"Data from the National Health and Nutrition Examination Survey (NHANES)"</span>,
       caption <span class='o'>=</span> <span class='s'>"Vertical line indicates upper limit of normal cholesterol"</span>,
       x <span class='o'>=</span> <span class='s'>"Total Cholesterol, mmol/L"</span>,
       y <span class='o'>=</span> <span class='s'>"Age, by Decade"</span>,
       fill <span class='o'>=</span> <span class='s'>"Age (years)"</span><span class='o'>)</span>

<span class='c'>#&gt; Picking joint bandwidth of 0.224</span>

<span class='c'>#&gt; Warning: Removed 6 rows containing missing values (geom_segment).</span>

</code></pre>
<img src="figs/unnamed-chunk-30-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

