---
title: "Session 10: Faceting, multi-plots, and animating"
subtitle: "Getting up close and personal with our data"
summary: "During this tenth session of Code Club, we will be continuing to work on making visualizations using ggplot2, including faceting plots, making multi-panel figures, and animating charts."  
authors: [jessica-cooperstone]
date: "2021-02-17"
lastmod: "2021-02-17"
output: hugodown::md_document
toc: true

image: 
  caption: "Artwork by @allison_horst"
  focal_point: ""
  preview_only: false

rmd_hash: 068146305e7d05ad

---

<br> <br> <br>

------------------------------------------------------------------------

Prep homework
-------------

### Basic computer setup

-   If you didn't already do this, please follow the [Code Club Computer Setup](/codeclub-setup/04_ggplot2/) instructions, which also has pointers for if you're new to R or RStudio.

-   If you're able to do so, please open RStudio a bit before Code Club starts -- and in case you run into issues, please join the Zoom call early and we'll help you troubleshoot.

### New to ggplot?

Check out the two Code Club pages for [Session 4](/codeclub/04_ggplot2/) and [Session 5](/codeclub/05_ggplot-round-2/).

If you've never used `ggplot2` before (or even if you have), you may find [this cheat sheet](https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf) useful.

<br>

------------------------------------------------------------------------

Getting Started
---------------

### RMarkdown for today's session

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># directory for Code Club Session 2:</span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>"S10"</span><span class='o'>)</span>

<span class='c'># directory for our RMarkdown</span>
<span class='c'># ("recursive" to create two levels at once.)</span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>"S10/Rmd/"</span><span class='o'>)</span>

<span class='c'># save the url location for today's script</span>
<span class='nv'>todays_R_script</span> <span class='o'>&lt;-</span> 
  <span class='s'>'https://raw.githubusercontent.com/biodash/biodash.github.io/master/content/codeclub/10_faceting-animating/Session10_faceting_animating_multifigs.Rmd'</span>

<span class='c'># indicate the name of the new script file</span>
<span class='nv'>Session10_Rmd</span> <span class='o'>&lt;-</span> <span class='s'>"S10/Rmd/Session10_faceting_animating_multifigs.Rmd"</span>

<span class='c'># go get that file! </span>
<span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>todays_R_script</span>,
              destfile <span class='o'>=</span> <span class='nv'>Session10_Rmd</span><span class='o'>)</span></code></pre>

</div>

<br>

------------------------------------------------------------------------

1 - How can I do more with my figures?
--------------------------------------

<p align="center">
<img src=ggplot2_exploratory.png width="95%" alt="ggplot2 exploratory cartoon">
</p>

Artwork by [Allison Horst](https://github.com/allisonhorst/stats-illustrations)

Sometimes we have so much data that it is difficult to make sense of it if we look at it all at once. One way to get around this is to create [facets](https://r4ds.had.co.nz/data-visualisation.html?q=facet#facets) in your data -- small subplots that help you to see different relationships among different variables in your dataset.

Today we will be using [`ggplot2`](https://ggplot2.tidyverse.org/) to make a series of plots that help us better understand the underlying structure in our dataset.

<br>

<div class="alert alert-note">

<div>

**What will we go over today**

These functions or packages will help you to get better visualize with your data.

-   [`facet_wrap()`](https://ggplot2.tidyverse.org/reference/facet_wrap.html) and [`facet_grid()`](https://ggplot2.tidyverse.org/reference/facet_grid.html)- makes small multiple plots based on some variable.
-   set `scales` to indicate the linked or not-linked nature of your axes in a faceted plot
-   [`gghighlight()`](https://www.rdocumentation.org/packages/gghighlight/versions/0.1.0) - allows you to direct focus on a particular portion of your data.
-   [`patchwork`](https://patchwork.data-imaginist.com/) - to compose super easy multi-plot figures
-   [`gganimate`](https://gganimate.com/articles/gganimate.html) - to make your plots gif!

I will also go over a few tricks along the way.

</div>

</div>

<br>

------------------------------------------------------------------------

2 - Accessing our data
----------------------

**Let's get set up and grab some data so that we can learn more about this world (and ggplot2)**

-   You can do this locally, or at OSC. You can find instructions if you are having trouble [here](/codeclub-setup/).

First load your libraries. We are using a lot of new packages today.

If you've never downloaded these packages before, use the chunk below.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"gghighlight"</span>,
                   <span class='s'>"gganimate"</span>,
                   <span class='s'>"magick"</span>,
                   <span class='s'>"patchwork"</span>,
                   <span class='s'>"ggrepel"</span>,
                   <span class='s'>"gapminder"</span><span class='o'>)</span><span class='o'>)</span></code></pre>

</div>

Once you have the packages above downloaded, load your libraries.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/yutannihilation/gghighlight/'>gghighlight</a></span><span class='o'>)</span> <span class='c'># for bringing attention to certain parts of your plot</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://gganimate.com'>gganimate</a></span><span class='o'>)</span> <span class='c'># for animating</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://docs.ropensci.org/magick/'>magick</a></span><span class='o'>)</span> <span class='c'># for rendering gifs and saving them</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://patchwork.data-imaginist.com'>patchwork</a></span><span class='o'>)</span> <span class='c'># for making multi-panel plots</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/slowkow/ggrepel'>ggrepel</a></span><span class='o'>)</span> <span class='c'># for getting labels to not be on top of your points</span>

<span class='c'># data for today</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/jennybc/gapminder'>gapminder</a></span><span class='o'>)</span></code></pre>

</div>

Then let's access the dataset `gapminder`, which is both the name of the package, and the name of the dataset. It contains a subset of data from [Gapminder.org](https://www.gapminder.org/), an educational non-profit aimed to fight global misconceptions about statistics of our world.

<p align="center">
<img src=mega_gapminder.png width="95%" alt="a big bubble plot showing the relationship between income and health of nations, with bubble size indicated by population size, and colored by region of the world">
</p>

From [Gapminder.org](www.gapminder.org)

Let's look at the data in `gapminder`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># look at the first 6 rows, all columns</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>gapminder</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 6</span></span>
<span class='c'>#&gt;   country     continent  year lifeExp      pop gdpPercap</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>    </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Afghanistan Asia       </span><span style='text-decoration: underline;'>1</span><span>952    28.8  8</span><span style='text-decoration: underline;'>425</span><span>333      779.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Afghanistan Asia       </span><span style='text-decoration: underline;'>1</span><span>957    30.3  9</span><span style='text-decoration: underline;'>240</span><span>934      821.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Afghanistan Asia       </span><span style='text-decoration: underline;'>1</span><span>962    32.0 10</span><span style='text-decoration: underline;'>267</span><span>083      853.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Afghanistan Asia       </span><span style='text-decoration: underline;'>1</span><span>967    34.0 11</span><span style='text-decoration: underline;'>537</span><span>966      836.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> Afghanistan Asia       </span><span style='text-decoration: underline;'>1</span><span>972    36.1 13</span><span style='text-decoration: underline;'>079</span><span>460      740.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> Afghanistan Asia       </span><span style='text-decoration: underline;'>1</span><span>977    38.4 14</span><span style='text-decoration: underline;'>880</span><span>372      786.</span></span>

<span class='c'># check the structure</span>
<span class='c'># this tell us what is contained within our df</span>
<span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>gapminder</span><span class='o'>)</span>
<span class='c'>#&gt; Rows: 1,704</span>
<span class='c'>#&gt; Columns: 6</span>
<span class='c'>#&gt; $ country   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Afghanistan, Afghanistan, Afghanistan, Afghanistan, Afghani…</span></span>
<span class='c'>#&gt; $ continent <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asia,…</span></span>
<span class='c'>#&gt; $ year      <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 1952, 1957, 1962, 1967, 1972, 1977, 1982, 1987, 1992, 1997,…</span></span>
<span class='c'>#&gt; $ lifeExp   <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 28.801, 30.332, 31.997, 34.020, 36.088, 38.438, 39.854, 40.…</span></span>
<span class='c'>#&gt; $ pop       <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 8425333, 9240934, 10267083, 11537966, 13079460, 14880372, 1…</span></span>
<span class='c'>#&gt; $ gdpPercap <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 779.4453, 820.8530, 853.1007, 836.1971, 739.9811, 786.1134,…</span></span></code></pre>

</div>

This dataset contains the following measurements about the life expectancy, population, and GDP per capita for 142 countries from 1952 to 2007. It includes the following variables:

-   `country`
-   `continent`
-   `year`
-   `lifeExp`
-   `pop`
-   `gdpPercap`

*Note, this data is already in tidy-style format* meaning:

-   Each variable must have its own column.
-   Each observation must have its own row.
-   Each value must have its own cell.

Learn more about tidy data [here](https://r4ds.had.co.nz/tidy-data.html).

To make things a bit less complex, let's look at data just from the Americas (i.e., North and South America). To do that, we can use [`filter()`](https://rdrr.io/r/stats/filter.html) like we learned using `dplyr` back in [Code Club Session 2](/codeclub/02_dplyr-core-verbs/)

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># make a df with data only from the Americas</span>
<span class='nv'>gapminder_americas</span> <span class='o'>&lt;-</span> <span class='nv'>gapminder</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>continent</span> <span class='o'>==</span> <span class='s'>"Americas"</span><span class='o'>)</span>

<span class='c'># what countries do we have?</span>
<span class='nf'><a href='https://rdrr.io/r/base/unique.html'>unique</a></span><span class='o'>(</span><span class='nv'>gapminder_americas</span><span class='o'>$</span><span class='nv'>country</span><span class='o'>)</span>
<span class='c'>#&gt;  [1] Argentina           Bolivia             Brazil             </span>
<span class='c'>#&gt;  [4] Canada              Chile               Colombia           </span>
<span class='c'>#&gt;  [7] Costa Rica          Cuba                Dominican Republic </span>
<span class='c'>#&gt; [10] Ecuador             El Salvador         Guatemala          </span>
<span class='c'>#&gt; [13] Haiti               Honduras            Jamaica            </span>
<span class='c'>#&gt; [16] Mexico              Nicaragua           Panama             </span>
<span class='c'>#&gt; [19] Paraguay            Peru                Puerto Rico        </span>
<span class='c'>#&gt; [22] Trinidad and Tobago United States       Uruguay            </span>
<span class='c'>#&gt; [25] Venezuela          </span>
<span class='c'>#&gt; 142 Levels: Afghanistan Albania Algeria Angola Argentina Australia ... Zimbabwe</span></code></pre>

</div>

<br>

------------------------------------------------------------------------

3 - Life expectancy vs. time
----------------------------

We will plot the relationship between `lifeExp` and `year` with the goal of understanding how life expectancy has changed in the second half of the 20th century. We will use [`geom_line()`](https://ggplot2.tidyverse.org/reference/geom_path.html#:~:text=geom_line()%20connects%20them%20in,which%20cases%20are%20connected%20together.) to make a line plot.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>gapminder_americas</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>year</span>, y <span class='o'>=</span> <span class='nv'>lifeExp</span>, group <span class='o'>=</span> <span class='nv'>country</span>, color <span class='o'>=</span> <span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_line</span><span class='o'>(</span><span class='o'>)</span> 
</code></pre>
<img src="figs/unnamed-chunk-6-1.png" width="700px" style="display: block; margin: auto;" />

</div>

This plot has so many countries, and we can only visually distinguish colors so well, that it makes this a bit of a mess. We can do better!

<br>

------------------------------------------------------------------------

4 - Highlighting
----------------

What if we want to highlight one country of interest, with the backdrop of all the data in the Americas? We can do this using [`gghighlight()`](https://www.rdocumentation.org/packages/gghighlight/versions/0.1.0), which will distinguish our country of interest, from the rest of the countries which will be indicated in gray.

Let's highlight the United States, and since we are at it, let's also add x and y axis labels, a title, subtitle, and caption with `labs()`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>gapminder_americas</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>year</span>, y <span class='o'>=</span> <span class='nv'>lifeExp</span>, group <span class='o'>=</span> <span class='nv'>country</span>, color <span class='o'>=</span> <span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_line</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://rdrr.io/pkg/gghighlight/man/gghighlight.html'>gghighlight</a></span><span class='o'>(</span><span class='nv'>country</span> <span class='o'>==</span> <span class='s'>"United States"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Year"</span>,
       y <span class='o'>=</span> <span class='s'>"Life Expectancy (years)"</span>,
       title <span class='o'>=</span> <span class='s'>"Life Expectancy in Countries in the Americas"</span>,
       subtitle <span class='o'>=</span> <span class='s'>"From 1952 to 2007"</span>,
       caption <span class='o'>=</span> <span class='s'>"Data from gapminder.org"</span><span class='o'>)</span>
<span class='c'>#&gt; Warning: Tried to calculate with group_by(), but the calculation failed.</span>
<span class='c'>#&gt; Falling back to ungrouped filter operation...</span>
<span class='c'>#&gt; label_key: country</span>
</code></pre>
<img src="figs/unnamed-chunk-7-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<br>

------------------------------------------------------------------------

5 - Faceting
------------

What if we want to see all the data at once, but just be able to better attribute each line to the correct country? We can use the [principle of small multiples](https://en.wikipedia.org/wiki/Small_multiple#), popularized by Edward Tufte, to make a series of charts all on the same scale to allow comparison between them easily.

We can facet using [`facet_wrap`](https://ggplot2.tidyverse.org/reference/facet_wrap.html) to create small plots for each country. If you want a certain number of rows or columns you can indicate them by including `ncol` and `nrow` in the `facet_wrap()` statement.

I have also made the strip text, or the label on top of each of the facets bigger using `theme`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>gapminder_americas</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>year</span>, y <span class='o'>=</span> <span class='nv'>lifeExp</span>, color <span class='o'>=</span> <span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_line</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>strip.text.x <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>size <span class='o'>=</span> <span class='m'>14</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='nf'>vars</span><span class='o'>(</span><span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> <span class='c'># facet_wrap(~country) also works</span>
  <span class='nf'>labs</span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Year"</span>,
       y <span class='o'>=</span> <span class='s'>"Life Expectancy (years)"</span>,
       title <span class='o'>=</span> <span class='s'>"Life Expectancy in Countries in the Americas"</span>,
       subtitle <span class='o'>=</span> <span class='s'>"From 1952 to 2007"</span>,
       caption <span class='o'>=</span> <span class='s'>"Data from gapminder.org"</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-8-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Now our legend is not necessary, so let's remove it. Let's also remove the gray background since its not really doing much for us. We will also change to `theme_minimal()` to get rid of the grey background which I don't think we need.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>gapminder_americas</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>year</span>, y <span class='o'>=</span> <span class='nv'>lifeExp</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_line</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>color <span class='o'>=</span> <span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_minimal</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"none"</span>,
        strip.text.x <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>size <span class='o'>=</span> <span class='m'>14</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='o'>~</span><span class='nv'>country</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Year"</span>,
       y <span class='o'>=</span> <span class='s'>"Life Expectancy (years)"</span>,
       title <span class='o'>=</span> <span class='s'>"Life Expectancy in Countries in the Americas"</span>,
       subtitle <span class='o'>=</span> <span class='s'>"From 1952 to 2007"</span>,
       caption <span class='o'>=</span> <span class='s'>"Data from gapminder.org"</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-9-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Wow better! But now its a bit hard to contextualize the line for each country to the whole dataset. We can fix this too.

<br>

------------------------------------------------------------------------

6 - Highlighting plus faceting
------------------------------

Let's bring the rest of data back in, and highlight in each facet the country of interest. We can do this by just adding [`gghighlight()`](https://rdrr.io/pkg/gghighlight/man/gghighlight.html) to our `ggplot` call.

Note: if you want to assign something in R to an object, and then view it, you can put the whole thing in parentheses, without having to call that object back at the end.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='o'>(</span><span class='nv'>americas_lifeexp</span> <span class='o'>&lt;-</span> <span class='nv'>gapminder_americas</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>year</span>, y <span class='o'>=</span> <span class='nv'>lifeExp</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_line</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>color <span class='o'>=</span> <span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://rdrr.io/pkg/gghighlight/man/gghighlight.html'>gghighlight</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_minimal</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"none"</span>,
        strip.text.x <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>size <span class='o'>=</span> <span class='m'>14</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='o'>~</span><span class='nv'>country</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Year"</span>,
       y <span class='o'>=</span> <span class='s'>"Life Expectancy (years)"</span>,
       title <span class='o'>=</span> <span class='s'>"Life Expectancy in Countries in the Americas"</span>,
       subtitle <span class='o'>=</span> <span class='s'>"From 1952 to 2007"</span>,
       caption <span class='o'>=</span> <span class='s'>"Data from gapminder.org"</span><span class='o'>)</span><span class='o'>)</span>
<span class='c'>#&gt; label_key: country</span>
<span class='c'>#&gt; Too many data series, skip labeling</span>
</code></pre>
<img src="figs/unnamed-chunk-10-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Wow, we now have so much more information about our data!

<br>

------------------------------------------------------------------------

7 - Adjusting scales while faceting
-----------------------------------

The default in faceting is that the x and y-axes for each plot are all the same. This aids in the interpretation of each small plot in relation to the others, but sometimes you may want freedom to adjust your axes.

For example, if we wanted to plot population over time, if we used the same scale, it would be really hard to see trends within a country.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='o'>(</span><span class='nv'>americas_pop</span> <span class='o'>&lt;-</span> <span class='nv'>gapminder_americas</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>year</span>, y <span class='o'>=</span> <span class='nv'>pop</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_line</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>color <span class='o'>=</span> <span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_minimal</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"none"</span>,
        strip.text.x <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>size <span class='o'>=</span> <span class='m'>14</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='o'>~</span><span class='nv'>country</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Year"</span>,
       y <span class='o'>=</span> <span class='s'>"Population"</span>,
       title <span class='o'>=</span> <span class='s'>"Population in Countries in the Americas"</span>,
       subtitle <span class='o'>=</span> <span class='s'>"From 1952 to 2007"</span>,
       caption <span class='o'>=</span> <span class='s'>"Data from gapminder.org"</span><span class='o'>)</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-11-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Let's change the scales so that the y-axis is "free" - i.e., each plot will have an independent y-axis. Note, when you do this, you aren't really using the principle of small multiples anymore, since the data isn't all on comparable scales.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>gapminder_americas</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>year</span>, y <span class='o'>=</span> <span class='nv'>pop</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_line</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>color <span class='o'>=</span> <span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_minimal</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"none"</span>,
        strip.text.x <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>size <span class='o'>=</span> <span class='m'>14</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='o'>~</span><span class='nv'>country</span>,
             scales <span class='o'>=</span> <span class='s'>"free_y"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Year"</span>,
       y <span class='o'>=</span> <span class='s'>"Population"</span>,
       title <span class='o'>=</span> <span class='s'>"Population of Countries in the Americas"</span>,
       subtitle <span class='o'>=</span> <span class='s'>"From 1952 to 2007"</span>,
       caption <span class='o'>=</span> <span class='s'>"Data from gapminder.org"</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-12-1.png" width="700px" style="display: block; margin: auto;" />

</div>

The default for `scales` is `"fixed"`, but you can also set to be `"free_x"`, `"free_y"`, or `"free"`, which means both x and y are free.

<br>

------------------------------------------------------------------------

8 - Multi-panel plots
---------------------

What if I take plots I've already made and assemble them together? You can do that simply with the package [`patchwork()`](https://patchwork.data-imaginist.com/).

<p align="center">
<img src=patchwork_1.jpg width="95%" alt="an illustration of how to use patchwork with cute little monsters">
</p>

Artwork by [Allison Horst](https://github.com/allisonhorst/stats-illustrations)

You can use the syntax:

-   `plot1 + plot2` to get two plots next to each other
-   `plot1 / plot2` to get two plots stacked vertically
-   `plot1 | (plot2 + plot3)` to get plot1 in the first row, and plots 2 and 3 in a second row

You can use [`plot_annotation()`](https://patchwork.data-imaginist.com/reference/plot_annotation.html) to indicate your plots with letters or numbers.

I am going to make some quick plots so we can see how it works. Let's look at some plots of the United States.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># make df with just United States data</span>
<span class='nv'>gapminder_usa</span> <span class='o'>&lt;-</span> <span class='nv'>gapminder</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>country</span> <span class='o'>==</span> <span class='s'>"United States"</span><span class='o'>)</span>

<span class='c'># make some plots</span>
<span class='o'>(</span><span class='nv'>usa_lifeexp</span> <span class='o'>&lt;-</span> <span class='nv'>gapminder_usa</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>year</span>, y <span class='o'>=</span> <span class='nv'>lifeExp</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-13-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='o'>(</span><span class='nv'>usa_gdppercap</span> <span class='o'>&lt;-</span> <span class='nv'>gapminder_usa</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>year</span>, y <span class='o'>=</span> <span class='nv'>gdpPercap</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_line</span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-14-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='o'>(</span><span class='nv'>usa_pop</span> <span class='o'>&lt;-</span> <span class='nv'>gapminder_usa</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>year</span>, y <span class='o'>=</span> <span class='nv'>pop</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_col</span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-15-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Let's make multi-panel plots. If you need to wrap around a line, make sure you don't start your line with the +, it won't work (this is true for all `ggplot2` syntax).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='o'>(</span><span class='nv'>usa_lifeexp</span> <span class='o'>+</span> <span class='nv'>usa_gdppercap</span><span class='o'>)</span> <span class='o'>/</span> <span class='nv'>usa_pop</span> <span class='o'>+</span>
<span class='nf'><a href='https://patchwork.data-imaginist.com/reference/plot_annotation.html'>plot_annotation</a></span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Some plots about the United States"</span>,
                  tag_levels <span class='o'>=</span> <span class='s'>"A"</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-16-1.png" width="700px" style="display: block; margin: auto;" />

</div>

You can see how this would be really useful for publications!

<br>

------------------------------------------------------------------------

9 - Animating
-------------

<p align="center">
<img src=gganimate_fireworks.png width="95%" alt="an illustration including fireworks showing an application og gganimate to make action plots, also including cute monsters">
</p>

Artwork by [Allison Horst](https://github.com/allisonhorst/stats-illustrations)

Since we have time-scale data here, we could also build an animation that would help us look at our data. What if we wanted to look at how life expectancy (`lifeExp`) and population (`pop`) change over time? We could animate over the variable `year`, and do this by using the function [`animate()`](https://gganimate.com/reference/animate.html), and set [`transition_states()`](https://gganimate.com/reference/transition_states.html) to the variable we are giffing over.

Note, I have included `closest_state` in the subtitle so the viewer can see what is the year at any stage of the animation.

To be able to tell which dot belongs to which country, I added a [`geom_text_repel()`](https://www.rdocumentation.org/packages/ggrepel/versions/0.9.1/topics/geom_label_repel) statement, which labels each point but is smart enough to not let the labels overlap.

I have also set `pop` to be on a log10 scale.

If you want to increase the resolution of your gif, and set the code chunk to `cache = TRUE` if the chunk runs slowly, so that it doesn't re-run when knitting if nothing has been edited, you can do this in the curly brackets at the top of your chunk, like this:

`{r, cache = TRUE, dpi = 600}`

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># install.packages("transformr") </span>
<span class='c'># if you are having problems with gganimate you may need to install transformr</span>

<span class='o'>(</span><span class='nv'>p</span> <span class='o'>&lt;-</span> <span class='nf'>ggplot</span><span class='o'>(</span><span class='nv'>gapminder_americas</span>, <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>lifeExp</span>, y <span class='o'>=</span> <span class='nv'>pop</span>, fill <span class='o'>=</span> <span class='nv'>country</span>, label <span class='o'>=</span> <span class='nv'>country</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>shape <span class='o'>=</span> <span class='m'>21</span>, color <span class='o'>=</span> <span class='s'>"black"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://rdrr.io/pkg/ggrepel/man/geom_text_repel.html'>geom_text_repel</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>scale_y_log10</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_classic</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>'none'</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Population and Life Expectancy in the Americas"</span>,
       subtitle <span class='o'>=</span> <span class='s'>'Year: &#123;closest_state&#125;'</span>, 
       x <span class='o'>=</span> <span class='s'>"Life Expectancy"</span>, 
       y <span class='o'>=</span> <span class='s'>"Log10 Population"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://gganimate.com/reference/transition_states.html'>transition_states</a></span><span class='o'>(</span><span class='nv'>year</span><span class='o'>)</span><span class='o'>)</span></code></pre>

</div>

<p align="center">
<img src=gapminder_gif.gif width="95%">
</p>

There are many different ways to transition your data in `gganimate` - and you can learn more about them [here](https://gganimate.com/reference/index.html).

Saving my gif

Now I want to save my gif. We can do that simply with the function [`anim_save()`](https://gganimate.com/reference/anim_save.html) which works a lot like `ggsave()`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># set parameters for your animation</span>
<span class='nf'><a href='https://gganimate.com/reference/animate.html'>animate</a></span><span class='o'>(</span><span class='nv'>p</span>, 
        duration <span class='o'>=</span> <span class='m'>10</span>, 
        fps <span class='o'>=</span> <span class='m'>10</span>, 
        width <span class='o'>=</span> <span class='m'>700</span>, 
        height <span class='o'>=</span> <span class='m'>700</span>,
        renderer <span class='o'>=</span> <span class='nf'><a href='https://gganimate.com/reference/renderers.html'>magick_renderer</a></span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'># save it</span>
<span class='nf'><a href='https://gganimate.com/reference/anim_save.html'>anim_save</a></span><span class='o'>(</span>filename <span class='o'>=</span> <span class='s'>"gapminder_gif.gif"</span>,
          animation <span class='o'>=</span> <span class='nf'><a href='https://gganimate.com/reference/last_animation.html'>last_animation</a></span><span class='o'>(</span><span class='o'>)</span>,
          path <span class='o'>=</span> <span class='s'>"/Users/jessicacooperstoneimac"</span><span class='o'>)</span></code></pre>

</div>

------------------------------------------------------------------------

10 - Breakout rooms
-------------------

Loading data and get set up
---------------------------

Load the `palmerpenguins` dataset, look at its structure, and view the beginning of the df.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/'>palmerpenguins</a></span><span class='o'>)</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>)</span>
<span class='c'>#&gt; tibble [344 × 8] (S3: tbl_df/tbl/data.frame)</span>
<span class='c'>#&gt;  $ species          : Factor w/ 3 levels "Adelie","Chinstrap",..: 1 1 1 1 1 1 1 1 1 1 ...</span>
<span class='c'>#&gt;  $ island           : Factor w/ 3 levels "Biscoe","Dream",..: 3 3 3 3 3 3 3 3 3 3 ...</span>
<span class='c'>#&gt;  $ bill_length_mm   : num [1:344] 39.1 39.5 40.3 NA 36.7 39.3 38.9 39.2 34.1 42 ...</span>
<span class='c'>#&gt;  $ bill_depth_mm    : num [1:344] 18.7 17.4 18 NA 19.3 20.6 17.8 19.6 18.1 20.2 ...</span>
<span class='c'>#&gt;  $ flipper_length_mm: int [1:344] 181 186 195 NA 193 190 181 195 193 190 ...</span>
<span class='c'>#&gt;  $ body_mass_g      : int [1:344] 3750 3800 3250 NA 3450 3650 3625 4675 3475 4250 ...</span>
<span class='c'>#&gt;  $ sex              : Factor w/ 2 levels "female","male": 2 1 1 NA 1 2 1 2 NA NA ...</span>
<span class='c'>#&gt;  $ year             : int [1:344] 2007 2007 2007 2007 2007 2007 2007 2007 2007 2007 ...</span>
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
<span class='c'>#&gt; <span style='color: #555555;'># … with 1 more variable: year </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span></code></pre>

</div>

<br>

------------------------------------------------------------------------

### Main exercises

#### Exercise 1

<div class="puzzle">

<div>

Like we did in [Code Club 7](https://biodash.github.io/codeclub/08_pivoting/), convert the two columns about penguin bill dimensions `bill_length_mm` and `bill_depth_mm` to two columns called `bill_dimension` and `value`. Drop your NAs also. Save this as a new df called `penguins_long`.

<details>

<summary> Hints (click here) </summary>

Use a combination of `drop_na()` and `pivot_longer()`, and it's helpful if you also set `names_prefix` in your `pivot_longer()` statement but not totally necessary. <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_long</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>pivot_longer</span><span class='o'>(</span>cols <span class='o'>=</span> <span class='nv'>bill_length_mm</span><span class='o'>:</span><span class='nv'>bill_depth_mm</span>,
               names_to <span class='o'>=</span> <span class='s'>"bill_dimension"</span>,
               values_to <span class='o'>=</span> <span class='s'>"value_mm"</span>,
               names_prefix <span class='o'>=</span> <span class='s'>"bill_"</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>penguins_long</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 8</span></span>
<span class='c'>#&gt;   species island flipper_length_… body_mass_g sex    year bill_dimension</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>             </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>         </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Adelie  Torge…              181        </span><span style='text-decoration: underline;'>3</span><span>750 male   </span><span style='text-decoration: underline;'>2</span><span>007 length_mm     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Adelie  Torge…              181        </span><span style='text-decoration: underline;'>3</span><span>750 male   </span><span style='text-decoration: underline;'>2</span><span>007 depth_mm      </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Adelie  Torge…              186        </span><span style='text-decoration: underline;'>3</span><span>800 fema…  </span><span style='text-decoration: underline;'>2</span><span>007 length_mm     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Adelie  Torge…              186        </span><span style='text-decoration: underline;'>3</span><span>800 fema…  </span><span style='text-decoration: underline;'>2</span><span>007 depth_mm      </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> Adelie  Torge…              195        </span><span style='text-decoration: underline;'>3</span><span>250 fema…  </span><span style='text-decoration: underline;'>2</span><span>007 length_mm     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> Adelie  Torge…              195        </span><span style='text-decoration: underline;'>3</span><span>250 fema…  </span><span style='text-decoration: underline;'>2</span><span>007 depth_mm      </span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 1 more variable: value_mm </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span></code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

#### Exercise 2

<div class="puzzle">

<div>

Plot body mass (`body_mass_g`) as related to bill length and depth.

<details>

<summary> Hints (click here) </summary>

Faceting will be useful here. <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_long</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>body_mass_g</span>, y <span class='o'>=</span> <span class='nv'>value_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='nf'>vars</span><span class='o'>(</span><span class='nv'>bill_dimension</span><span class='o'>)</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-21-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

#### Exercise 3

<div class="puzzle">

<div>

Take your plot from Exercise 2 and make it prettier. You can do things like change your axis labels, add title, change themes as you see fit. Color your points by `sex`.

<details>

<summary> Hints (click here) </summary>

Pick a theme you like. `theme_classic()` is a good place to start, and if you want to download the package `hrbrthemes`, I really like the [`theme_ipsum_rc()`](https://rdrr.io/pkg/hrbrthemes/man/theme_ipsum_rc.html).  
<br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

I've included some code that let's you re-name the strip text, or the text that is above each of your facets. You do this with the [`labeller()`](https://ggplot2.tidyverse.org/reference/labeller.html) function.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://github.com/hrbrmstr/hrbrthemes'>hrbrthemes</a></span><span class='o'>)</span> <span class='c'># for pretty &amp; easy themes</span>

<span class='c'># formatting facet strip text labels</span>
<span class='nv'>dim_mm</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"Culman Bill Depth"</span>, <span class='s'>"Culman Bill Length"</span><span class='o'>)</span>
<span class='nf'><a href='https://rdrr.io/r/base/names.html'>names</a></span><span class='o'>(</span><span class='nv'>dim_mm</span><span class='o'>)</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"depth_mm"</span>, <span class='s'>"length_mm"</span><span class='o'>)</span>

<span class='c'># this is just one example</span>
<span class='nv'>penguins_long</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>body_mass_g</span>, y <span class='o'>=</span> <span class='nv'>value_mm</span>, color <span class='o'>=</span> <span class='nv'>sex</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://rdrr.io/pkg/hrbrthemes/man/theme_ipsum_rc.html'>theme_ipsum_rc</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>axis.title.x <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>hjust <span class='o'>=</span> <span class='m'>0.5</span><span class='o'>)</span>,
        axis.title.y <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>hjust <span class='o'>=</span> <span class='m'>0.5</span><span class='o'>)</span>,
        strip.text <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>hjust <span class='o'>=</span> <span class='m'>0.5</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Body Mass (g)"</span>,
       y <span class='o'>=</span> <span class='s'>"mm"</span>,
       title <span class='o'>=</span> <span class='s'>"Bill length and depth vs. body mass in penguins"</span>,
       color <span class='o'>=</span> <span class='s'>"Sex"</span>,
       caption <span class='o'>=</span> <span class='s'>"Data from https://allisonhorst.github.io/palmerpenguins/"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='nf'>vars</span><span class='o'>(</span><span class='nv'>bill_dimension</span><span class='o'>)</span>,
             labeller <span class='o'>=</span> <span class='nf'>labeller</span><span class='o'>(</span>bill_dimension <span class='o'>=</span> <span class='nv'>dim_mm</span><span class='o'>)</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-22-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

#### Exercise 4

<div class="puzzle">

<div>

Add a second dimension of faceting by `species`.

<details>

<summary> Hints (click here) </summary>

You do this within your `facet_wrap()` call. You might want to try the formula syntax, which works like this: `var1~var2`. <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_long</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>body_mass_g</span>, y <span class='o'>=</span> <span class='nv'>value_mm</span>, color <span class='o'>=</span> <span class='nv'>sex</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://rdrr.io/pkg/hrbrthemes/man/theme_ipsum_rc.html'>theme_ipsum_rc</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>axis.title.x <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>hjust <span class='o'>=</span> <span class='m'>0.5</span><span class='o'>)</span>,
        axis.title.y <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>hjust <span class='o'>=</span> <span class='m'>0.5</span><span class='o'>)</span>,
        strip.text <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>hjust <span class='o'>=</span> <span class='m'>0.5</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Body Mass (g)"</span>,
       y <span class='o'>=</span> <span class='s'>"mm"</span>,
       title <span class='o'>=</span> <span class='s'>"Bill length and depth vs. body mass in penguins"</span>,
       color <span class='o'>=</span> <span class='s'>"Sex"</span>,
       caption <span class='o'>=</span> <span class='s'>"Data from https://allisonhorst.github.io/palmerpenguins/"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='nv'>bill_dimension</span><span class='o'>~</span><span class='nv'>species</span>,
             labeller <span class='o'>=</span> <span class='nf'>labeller</span><span class='o'>(</span>bill_dimension <span class='o'>=</span> <span class='nv'>dim_mm</span><span class='o'>)</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-23-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

#### Exercise 5

<div class="puzzle">

<div>

Using your plot from Exercise 3, highlight the datapoints coming from Dream Island in purple.

<details>

<summary> Hints (click here) </summary>

You can use syntax inside [`gghighlight()`](https://rdrr.io/pkg/gghighlight/man/gghighlight.html) just like you do in [`filter()`](https://rdrr.io/r/stats/filter.html). <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># what are our islands?</span>
<span class='nf'><a href='https://rdrr.io/r/base/unique.html'>unique</a></span><span class='o'>(</span><span class='nv'>penguins_long</span><span class='o'>$</span><span class='nv'>island</span><span class='o'>)</span>
<span class='c'>#&gt; [1] Torgersen Biscoe    Dream    </span>
<span class='c'>#&gt; Levels: Biscoe Dream Torgersen</span>

<span class='nv'>penguins_long</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>body_mass_g</span>, y <span class='o'>=</span> <span class='nv'>value_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"purple"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://rdrr.io/pkg/gghighlight/man/gghighlight.html'>gghighlight</a></span><span class='o'>(</span><span class='nv'>island</span> <span class='o'>==</span> <span class='s'>"Dream"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='nf'>vars</span><span class='o'>(</span><span class='nv'>bill_dimension</span><span class='o'>)</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-24-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

#### Exercise 6

<div class="puzzle">

<div>

Using your sample plot for Exercise 3, highlight penguins that have a `body_mass_g` less than 3500 g, in blue.

<details>

<summary> Hints (click here) </summary>

You can use syntax inside [`gghighlight()`](https://rdrr.io/pkg/gghighlight/man/gghighlight.html) just like you do in [`filter()`](https://rdrr.io/r/stats/filter.html), and you can also use these filter functions like [`<`](https://rdrr.io/r/base/Comparison.html), [`>`](https://rdrr.io/r/base/Comparison.html), [`<=`](https://rdrr.io/r/base/Comparison.html), [`!`](https://rdrr.io/r/base/Logic.html) and `AND` inside your call. <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># what are our islands?</span>
<span class='nf'><a href='https://rdrr.io/r/base/unique.html'>unique</a></span><span class='o'>(</span><span class='nv'>penguins_long</span><span class='o'>$</span><span class='nv'>island</span><span class='o'>)</span>
<span class='c'>#&gt; [1] Torgersen Biscoe    Dream    </span>
<span class='c'>#&gt; Levels: Biscoe Dream Torgersen</span>

<span class='nv'>penguins_long</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>body_mass_g</span>, y <span class='o'>=</span> <span class='nv'>value_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"blue"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://rdrr.io/pkg/gghighlight/man/gghighlight.html'>gghighlight</a></span><span class='o'>(</span><span class='nv'>island</span> <span class='o'>==</span> <span class='s'>"Dream"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='nf'>vars</span><span class='o'>(</span><span class='nv'>bill_dimension</span><span class='o'>)</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-25-1.png" width="700px" style="display: block; margin: auto;" />

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

Plot `flipper_length_mm` vs. `body_mass_g` and animate the plot to show only one `species` at a time.

<details>

<summary> Hints (click here) </summary>

Try animating over `species`, using [`transition_states()`](https://gganimate.com/reference/transition_states.html) and set `{closest_state}` in your title or subtitle so you can tell what you're looking at. <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>flipper_by_BW</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>body_mass_g</span>, y <span class='o'>=</span> <span class='nv'>flipper_length_mm</span>, fill <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>shape <span class='o'>=</span> <span class='m'>21</span>, color <span class='o'>=</span> <span class='s'>"black"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_classic</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>'none'</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Population and Life Expectancy in the Americas"</span>,
       subtitle <span class='o'>=</span> <span class='s'>'Penguin Species: &#123;closest_state&#125;'</span>, 
       x <span class='o'>=</span> <span class='s'>"Body Mass (g)"</span>, 
       y <span class='o'>=</span> <span class='s'>"Flipper Length (mm)"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://gganimate.com/reference/transition_states.html'>transition_states</a></span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> 

<span class='nf'><a href='https://gganimate.com/reference/animate.html'>animate</a></span><span class='o'>(</span><span class='nv'>flipper_by_BW</span><span class='o'>)</span></code></pre>

</div>

<p align="center">
<img src=flippers_by_mass.gif width="95%">
</p>
</details>

<br>

</div>

</div>

------------------------------------------------------------------------

#### Bonus 2

<div class="puzzle">

<div>

You have now made an excellent gif, so save it!

<details>

<summary> Hints (click here) </summary>

Use [`anim_save()`](https://gganimate.com/reference/anim_save.html) to save your animation, which works in a similar way to [`ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html), which is another very useful function. <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># set parameters for your animation</span>
<span class='nf'><a href='https://gganimate.com/reference/animate.html'>animate</a></span><span class='o'>(</span><span class='nv'>flipper_by_BW</span>, 
        duration <span class='o'>=</span> <span class='m'>10</span>, 
        fps <span class='o'>=</span> <span class='m'>10</span>, 
        width <span class='o'>=</span> <span class='m'>700</span>, 
        height <span class='o'>=</span> <span class='m'>700</span>,
        renderer <span class='o'>=</span> <span class='nf'><a href='https://gganimate.com/reference/renderers.html'>magick_renderer</a></span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'># save it</span>
<span class='nf'><a href='https://gganimate.com/reference/anim_save.html'>anim_save</a></span><span class='o'>(</span>filename <span class='o'>=</span> <span class='s'>"flippers_by_mass.gif"</span>,
          animation <span class='o'>=</span> <span class='nf'><a href='https://gganimate.com/reference/last_animation.html'>last_animation</a></span><span class='o'>(</span><span class='o'>)</span>,
          path <span class='o'>=</span> <span class='s'>"YOUR_PATH_HERE"</span><span class='o'>)</span></code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

#### Bonus 3

<div class="puzzle">

<div>

Let's practice making multi-panel plots. Plot:

Boxplot of `body_mass_g` by `sex`

Histogram of number of observations per `island`

Distribution of `flipper_length_mm` by `species`.

Tag your plots so each has a lowercase letter associated with it.

<details>

<summary> Hints (click here) </summary>

Use the syntax from the package `patchwork`. You can learn more [here](https://patchwork.data-imaginist.com/). Also use [`plot_annotation()`](https://patchwork.data-imaginist.com/reference/plot_annotation.html). <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

-   `title` allows you to set a title
-   `tag_levels` allows you to determine how you want your panels to be tagged.

Boxplot of `body_mass_g` by `sex`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_mass_by_sex</span> <span class='o'>&lt;-</span> <span class='nv'>penguins_long</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>sex</span>, y <span class='o'>=</span> <span class='nv'>body_mass_g</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span><span class='o'>)</span>

<span class='nv'>penguins_mass_by_sex</span>
</code></pre>
<img src="figs/unnamed-chunk-28-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Histogram of number of observations per `island`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_by_island</span> <span class='o'>&lt;-</span> <span class='nv'>penguins_long</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>y <span class='o'>=</span> <span class='nv'>island</span>, fill <span class='o'>=</span> <span class='nv'>island</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_histogram</span><span class='o'>(</span>stat <span class='o'>=</span> <span class='s'>"count"</span><span class='o'>)</span>
<span class='c'>#&gt; Warning: Ignoring unknown parameters: binwidth, bins, pad</span>

<span class='nv'>penguins_by_island</span>
</code></pre>
<img src="figs/unnamed-chunk-29-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Distribution of `flipper_length_mm` by `species`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_flipper_species</span> <span class='o'>&lt;-</span> <span class='nv'>penguins_long</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>flipper_length_mm</span>, group <span class='o'>=</span> <span class='nv'>species</span>, fill <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_density</span><span class='o'>(</span>alpha <span class='o'>=</span> <span class='m'>0.5</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>scale_fill_viridis_d</span><span class='o'>(</span><span class='o'>)</span>

<span class='nv'>penguins_flipper_species</span>
</code></pre>
<img src="figs/unnamed-chunk-30-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_flipper_species</span> <span class='o'>/</span> <span class='o'>(</span><span class='nv'>penguins_mass_by_sex</span> <span class='o'>+</span> <span class='nv'>penguins_by_island</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://patchwork.data-imaginist.com/reference/plot_annotation.html'>plot_annotation</a></span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Looking at penguins..."</span>,
                  tag_levels <span class='o'>=</span> <span class='s'>"a"</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-31-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

