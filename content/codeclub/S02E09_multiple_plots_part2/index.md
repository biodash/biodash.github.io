---
title: "Code Club S02E09: Combining Plots - Part 2"
summary: "In a continuation from the previous session, we'll look at additional approaches for combining plots with a focus on `facet_grid()` and the *patchwork* package."  
authors: [mike-sovic]
date: "2021-10-26"
output: hugodown::md_document
toc: true
rmd_hash: b2c9369c9ab834b4

---

<br>

## Learning objectives

> -   Continue to practice creating plots with ggplot
> -   Compare the ggplot functions `facet_grid()` and `facet_wrap()`
> -   Arrange multiple plots of different types on a single figure

<br>

------------------------------------------------------------------------

## 1 -- Intro

In the previous session we worked with the `facet_wrap()` function from ggplot, which allowed us to use some variable (column) in the dataset to partition data into multiple panels of a single plot. In this session, we'll see how the `facet_wrap()` approach compares to a similar function, `facet_grid()`, and also explore the *patchwork* package, which offers more control and flexibility in arranging multiple plots in a single figure.

We'll continue to use *tidyverse* functions and data from *palmerpenguins*, so install those if you need to. If you already have them installed, just load them into your current R session with the [`library()`](https://rdrr.io/r/base/library.html) functions below...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"tidyverse"</span><span class='o'>)</span>
<span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"palmerpenguins"</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/'>palmerpenguins</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
</code></pre>

</div>

And now let's preview/explore the penguins dataset just to remind ourselves of what's in there...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 8</span></span>
<span class='c'>#&gt;   species island bill_length_mm bill_depth_mm flipper_length_… body_mass_g sex  </span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>           </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>         </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>            </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Adelie  Torge…           39.1          18.7              181        </span><span style='text-decoration: underline;'>3</span><span>750 male </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Adelie  Torge…           39.5          17.4              186        </span><span style='text-decoration: underline;'>3</span><span>800 fema…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Adelie  Torge…           40.3          18                195        </span><span style='text-decoration: underline;'>3</span><span>250 fema…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Adelie  Torge…           </span><span style='color: #BB0000;'>NA</span><span>            </span><span style='color: #BB0000;'>NA</span><span>                 </span><span style='color: #BB0000;'>NA</span><span>          </span><span style='color: #BB0000;'>NA</span><span> </span><span style='color: #BB0000;'>NA</span><span>   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> Adelie  Torge…           36.7          19.3              193        </span><span style='text-decoration: underline;'>3</span><span>450 fema…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> Adelie  Torge…           39.3          20.6              190        </span><span style='text-decoration: underline;'>3</span><span>650 male </span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 1 more variable: year &lt;int&gt;</span></span>

<span class='nf'><a href='https://rdrr.io/r/base/summary.html'>summary</a></span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>)</span>

<span class='c'>#&gt;       species          island    bill_length_mm  bill_depth_mm  </span>
<span class='c'>#&gt;  Adelie   :152   Biscoe   :168   Min.   :32.10   Min.   :13.10  </span>
<span class='c'>#&gt;  Chinstrap: 68   Dream    :124   1st Qu.:39.23   1st Qu.:15.60  </span>
<span class='c'>#&gt;  Gentoo   :124   Torgersen: 52   Median :44.45   Median :17.30  </span>
<span class='c'>#&gt;                                  Mean   :43.92   Mean   :17.15  </span>
<span class='c'>#&gt;                                  3rd Qu.:48.50   3rd Qu.:18.70  </span>
<span class='c'>#&gt;                                  Max.   :59.60   Max.   :21.50  </span>
<span class='c'>#&gt;                                  NA's   :2       NA's   :2      </span>
<span class='c'>#&gt;  flipper_length_mm  body_mass_g       sex           year     </span>
<span class='c'>#&gt;  Min.   :172.0     Min.   :2700   female:165   Min.   :2007  </span>
<span class='c'>#&gt;  1st Qu.:190.0     1st Qu.:3550   male  :168   1st Qu.:2007  </span>
<span class='c'>#&gt;  Median :197.0     Median :4050   NA's  : 11   Median :2008  </span>
<span class='c'>#&gt;  Mean   :200.9     Mean   :4202                Mean   :2008  </span>
<span class='c'>#&gt;  3rd Qu.:213.0     3rd Qu.:4750                3rd Qu.:2009  </span>
<span class='c'>#&gt;  Max.   :231.0     Max.   :6300                Max.   :2009  </span>
<span class='c'>#&gt;  NA's   :2         NA's   :2</span>
</code></pre>

</div>

## 2 -- Review Of `facet_wrap()`

Last week we started with a plot Michael Broe had previously constructed...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span>, color <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_smooth</span><span class='o'>(</span>method <span class='o'>=</span> <span class='s'>"lm"</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

</code></pre>
<img src="figs/unnamed-chunk-4-1.png" width="700px" style="display: block; margin: auto;" />

</div>

We then used `facet_wrap()` to present the data for the three species in separate panels, in place of using color...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_smooth</span><span class='o'>(</span>method <span class='o'>=</span> <span class='s'>"lm"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='nf'>vars</span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

</code></pre>
<img src="figs/unnamed-chunk-5-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Then as part of the breakout rooms, we tried faceting on more than one variable - we subsetted the dataset for only Adelie penguins, then plotted the relationship between bill length and bill depth faceted across both *island* and *sex*...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>species</span> <span class='o'>==</span> <span class='s'>"Adelie"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_smooth</span><span class='o'>(</span>method <span class='o'>=</span> <span class='s'>"lm"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='nf'>vars</span><span class='o'>(</span><span class='nv'>island</span>, <span class='nv'>sex</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

</code></pre>
<img src="figs/unnamed-chunk-6-1.png" width="700px" style="display: block; margin: auto;" />

</div>

## 3 -- `facet_grid()`

While you can use `facet_wrap()` as above, `facet_grid()` is often a better option when faceting on two variables. Here's what the example above looks like with `facet_grid()`...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>species</span> <span class='o'>==</span> <span class='s'>"Adelie"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_smooth</span><span class='o'>(</span>method <span class='o'>=</span> <span class='s'>"lm"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_grid</span><span class='o'>(</span>rows <span class='o'>=</span> <span class='nf'>vars</span><span class='o'>(</span><span class='nv'>sex</span><span class='o'>)</span>, cols <span class='o'>=</span> <span class='nf'>vars</span><span class='o'>(</span><span class='nv'>island</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

</code></pre>
<img src="figs/unnamed-chunk-7-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Notice that with `facet_grid()` we specify which variable defines the rows and which variable defines the columns.

------------------------------------------------------------------------

### Breakout Rooms I: Facet Grids

#### Exercise 1

<div class="puzzle">

<div>

Try analyzing the relationship between Adelie penguin bill length and bill depth separately for each combination of *year* and *sex*. Make the columns represent male/female, and the rows represent the different years (in this case, 2007-2009).

<details>
<summary>
<b>Hint</b> (click here)
</summary>

<br> Use [`filter()`](https://rdrr.io/r/stats/filter.html) to select out Adelie penguins, then create a scatter plot similar to the one in the `facet_grid()` example. Assign the rows as *year* and the columns as *sex*. <br>

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>species</span> <span class='o'>==</span> <span class='s'>"Adelie"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_smooth</span><span class='o'>(</span>method <span class='o'>=</span> <span class='s'>"lm"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_grid</span><span class='o'>(</span>rows <span class='o'>=</span> <span class='nf'>vars</span><span class='o'>(</span><span class='nv'>year</span><span class='o'>)</span>, cols <span class='o'>=</span> <span class='nf'>vars</span><span class='o'>(</span><span class='nv'>sex</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

</code></pre>
<img src="figs/unnamed-chunk-8-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

</div>

#### Exercise 2

<div class="puzzle">

<div>

Now let's modify the plot you just created a bit. Add the title "Bill Dimensions Of Adelie Penguins", and move the year labels from the right side to the left side of the plot.

<details>
<summary>
<b>Hint</b> (click here)
</summary>

<br> Check out the *switch* option in the `facet_grid()` documentation for moving the year labels. For the title, consider `labs()` or `ggtitle()`. <br>

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>species</span> <span class='o'>==</span> <span class='s'>"Adelie"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_smooth</span><span class='o'>(</span>method <span class='o'>=</span> <span class='s'>"lm"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_grid</span><span class='o'>(</span>rows <span class='o'>=</span> <span class='nf'>vars</span><span class='o'>(</span><span class='nv'>year</span><span class='o'>)</span>, cols <span class='o'>=</span> <span class='nf'>vars</span><span class='o'>(</span><span class='nv'>sex</span><span class='o'>)</span>, switch <span class='o'>=</span> <span class='s'>"y"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>ggtitle</span><span class='o'>(</span><span class='s'>"Bill Dimensions Of Adelie Penguins"</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

</code></pre>
<img src="figs/unnamed-chunk-9-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

## 4 -- Multi-Panel Plots: Patchwork

Faceting with `facet_wrap()` or `facet_grid()` works when you want to partition the plots based on one or more variables in the dataset. But if you want to arrange multiple plots into one figure, possibly even different types of plots, one good option is the *patchwork* package. Let's install and load it...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"patchwork"</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://patchwork.data-imaginist.com'>patchwork</a></span><span class='o'>)</span>
</code></pre>

</div>

With *patchwork*, you create and save each plot as a separate object. Then, once you've made the plots, you just tell patchwork how to arrange them. The syntax to define the layout is based on common mathematical operators.

Some examples:

-   `plot1 + plot2` puts two plots side-by-side
-   `plot1 / plot2` stacks two plots vertically
-   `plot1 / (plot2 + plot3)` gives plot1 on a top row, and plots 2 and 3 on a bottom row

In the examples above, *plot1*, *plot2*, and *plot3* represent plots that have been saved as objects with those names.

Below is an example from *palmerpenguins*. First we create the plots, saving each as a new object...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>avg_island_lgth</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>group_by</span><span class='o'>(</span><span class='nv'>island</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>summarize</span><span class='o'>(</span><span class='s'>"mean_bill_length"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>island</span>, y <span class='o'>=</span> <span class='nv'>mean_bill_length</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_col</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>ggtitle</span><span class='o'>(</span><span class='s'>"Average Penguin Bill Length"</span><span class='o'>)</span>

<span class='nv'>mass_by_sex</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>sex</span>, y <span class='o'>=</span> <span class='nv'>body_mass_g</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>ggtitle</span><span class='o'>(</span><span class='s'>"Effect of Sex on Penguin Size"</span><span class='o'>)</span>

<span class='nv'>lgth_by_depth</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_smooth</span><span class='o'>(</span>method <span class='o'>=</span> <span class='s'>"lm"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='s'>"species"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>ggtitle</span><span class='o'>(</span><span class='s'>"Relationship Between Bill Length and Bill Depth"</span><span class='o'>)</span>
</code></pre>

</div>

Then we simply use the patchwork syntax to define how these 3 plots will be arranged. In this case, the first (faceted) plot on top, with the other two side-by-side below it...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>lgth_by_depth</span> <span class='o'>/</span> <span class='o'>(</span><span class='nv'>avg_island_lgth</span> <span class='o'>+</span> <span class='nv'>mass_by_sex</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

</code></pre>
<img src="figs/unnamed-chunk-13-1.png" width="700px" style="display: block; margin: auto;" />

</div>

------------------------------------------------------------------------

### Breakout Rooms II: Combining Plots

<div class="puzzle">

<div>

Use the palmerpenguin data to try to create the plot below...

<div class="highlight">

<img src="figs/unnamed-chunk-14-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<details>
<summary>
<b>Hint 1 (Boxplot)</b> (click here)
</summary>

<br> For the boxplot, use `geom_boxplot()`. <br>

</details>
<details>
<summary>
<b>Hint 2 (Boxplot)</b> (click here)
</summary>

<br> Notice that R initially interprets the *year* variable as a continuous variable, but boxplots need a discrete x axis. Convert that variable to character or factor. You can use `mutate` along with `as.character` or `as.factor`. <br>

</details>
<details>
<summary>
<b>Hint 3 (Plot Formatting)</b> (click here)
</summary>

<br> For the formatting, try `theme_classic()` <br>

</details>
<details>
<summary>
<b>Hint 4 (Labels 1)</b> (click here)
</summary>

<br> The title and axis labels can be specified with `labs()`, among other options. <br>

</details>
<details>
<summary>
<b>Hint 5 (Labels 2)</b> (click here)
</summary>

<br> To get the 'A' and 'B' plot annotations, check out the help page for the [`plot_annotation()`](https://patchwork.data-imaginist.com/reference/plot_annotation.html) function within *patchwork*. <br>

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_flipper</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>flipper_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='s'>"species"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_smooth</span><span class='o'>(</span>method <span class='o'>=</span> <span class='s'>"lm"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_classic</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Relationship Between Bill Length and Flipper Length"</span>,
       x <span class='o'>=</span> <span class='s'>"Bill Length (mm)"</span>,
       y <span class='o'>=</span> <span class='s'>"Flipper Length (mm)"</span><span class='o'>)</span>
  
<span class='nv'>mass_yr</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>mutate</span><span class='o'>(</span><span class='s'>"year"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/character.html'>as.character</a></span><span class='o'>(</span><span class='nv'>year</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>year</span>, y <span class='o'>=</span> <span class='nv'>body_mass_g</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>theme_classic</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Penguin Size Over Time"</span>,
       x <span class='o'>=</span> <span class='s'>"Body Mass (g)"</span>,
       y <span class='o'>=</span> <span class='s'>"Year"</span><span class='o'>)</span>

<span class='nv'>bill_flipper</span> <span class='o'>/</span> <span class='nv'>mass_yr</span> <span class='o'>+</span> 
  <span class='nf'><a href='https://patchwork.data-imaginist.com/reference/plot_annotation.html'>plot_annotation</a></span><span class='o'>(</span>tag_levels <span class='o'>=</span> <span class='s'>'A'</span><span class='o'>)</span>
</code></pre>

</div>

</details>

</div>

</div>

<br>

------------------------------------------------------------------------

