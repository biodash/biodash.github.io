---
title: "Code Club S02E08: Combining Plots"
summary: "Now that we've gotten a feel for creating plots, we'll look at how they can be arranged to include multiple plots in a single figure."  
authors: [mike-sovic]
date: "2021-10-19"
output: hugodown::md_document
toc: true
rmd_hash: 187f282806da5bfa

---

<br>

## Learning objectives

> -   Continue to practice creating plots with ggplot
> -   Use faceting to divide a plot into multiple panels according to some variable.
> -   Arrange multiple plots of different types on a single figure.

<br>

------------------------------------------------------------------------

## 1 -- Intro

We'll continue in our theme on plotting by exploring some options for arranging multiple plots on a single figure. A couple scenarios where you might want to do this...

1.) You create a plot that needs to be subdivided according to some variable, possibly because accounting for that variable is important for the interpretation, or maybe there's just too much on one plot and it helps to split the data up according to some factor.

2.) You have a series of different plots that all address some related question, maybe each in a slightly different way, and you want to present them all in one figure.

We'll take a couple approaches during today's session to deal with these two scenarios. First, we'll look at some *ggplot* functions like `facet_wrap()` and `facet_grid()` that allow us to easily deal with scenario 1. Then we'll try a separate package, *patchwork*, that provides one good option for scenario 2.

Like in previous sessions, we'll use some packages from the *tidyverse* and also the *palmerpenguins* dataset. If you haven't installed either of those yet, you can do so with the following commands. If you installed them previously, you can just run the latter of the commands (library) to load them for the current session.

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

## 2 -- Faceting

Let's start by revisiting some plots Michael Broe created in his intro to ggplot a couple sessions ago. He was using the plots to investigate whether a relationship exists between the variables *bill length* and *bill depth* in these penguins. A scatterplot with a line of best fit from *ggplot*...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_smooth</span><span class='o'>(</span>method <span class='o'>=</span> <span class='s'>"lm"</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

</code></pre>
<img src="figs/unnamed-chunk-3-1.png" width="700px" style="display: block; margin: auto;" />

</div>

As Michael pointed out previously, mapping an additional aesthetic (color) to the variable *species* helps us see a relationship a little more clearly...

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

The color aesthetic partitions the data according to some variable (in this case, species), and here helps add important information to the visualization. An alternative might be to plot the data in separate panels, with each corresponding to a different species. We can do that with either of two functions from ggplot, `facet_wrap()` or `facet_grid()`. Let's start with `facet_wrap()`. This is added as an additional layer to the plot, and indicates one or more variables that will be used to split the data into separate panels. I'll facet here by species.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_smooth</span><span class='o'>(</span>method <span class='o'>=</span> <span class='s'>"lm"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='s'>"species"</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

</code></pre>
<img src="figs/unnamed-chunk-5-1.png" width="700px" style="display: block; margin: auto;" />

</div>

The effect here is similar to what we did with adding a color aesthetic to the *species* variable earlier - it allows us to evaluate the relationship between bill length and bill depth for each species separately.

------------------------------------------------------------------------

### Breakout Rooms I: Faceting

#### Exercise 1: Analyze Adelie Penguins By Island

<div class="puzzle">

<div>

Try analyzing just the data for Adelie penguins (the only species with observations from each of the three islands). For this species, try faceting by island. Does the relationship seem to be consistent across all islands?

<details>
<summary>
<b>Hint</b> (click here)
</summary>

<br> Use [`filter()`](https://rdrr.io/r/stats/filter.html) to select out Adelie penguins, then create a plot similar to the one in the example, but facet on *island* instead of *species* <br>

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
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='s'>"island"</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

</code></pre>
<img src="figs/unnamed-chunk-6-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

</div>

#### Exercise 2a: Multiple Facets

<div class="puzzle">

<div>

Now building on the plot you just created for Adelie Penguins, what if you wanted to facet on not just *island*, but a combination of *island* and *sex*? Give it a try.

<details>
<summary>
<b>Hint</b> (click here)
</summary>

<br> `facet_wrap()` accepts a character vector of column names. Use the c() function to provide a vector with two column names. <br>

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>species</span> <span class='o'>==</span> <span class='s'>"Adelie"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_smooth</span><span class='o'>(</span>method <span class='o'>=</span> <span class='s'>"lm"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"island"</span>, <span class='s'>"sex"</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing non-finite values (stat_smooth).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

</code></pre>
<img src="figs/unnamed-chunk-7-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

</div>

#### Exercise 2b: Multiple Facets

<div class="puzzle">

<div>

There are some facets coming through in that last plot that are based on NA's. Try getting rid of all observations that include missing data before creating the plot.

<details>
<summary>
<b>Hint</b> (click here)
</summary>

<br> Use the `drop_na()` function to remove observations with NA before calling ggplot. <br>

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
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"island"</span>, <span class='s'>"sex"</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

</code></pre>
<img src="figs/unnamed-chunk-8-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

</div>

#### Exercise 3: Axis Scales

<div class="puzzle">

<div>

Now let's go back to the full dataset where we faceted by species. The code we used, along with its associated plot, are below...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_smooth</span><span class='o'>(</span>method <span class='o'>=</span> <span class='s'>"lm"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='s'>"species"</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

</code></pre>
<img src="figs/unnamed-chunk-9-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Use the help page for `facet_wrap` to look in to the *scales* option. Try changing the value of this option to see what effect it has on the plot.

<details>
<summary>
<b>Hint</b> (click here)
</summary>

<br> Within the `facet_wrap()` function, set scales = "free_y". <br>

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_smooth</span><span class='o'>(</span>method <span class='o'>=</span> <span class='s'>"lm"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='s'>"species"</span>, scales <span class='o'>=</span> <span class='s'>"free"</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

<span class='c'>#&gt; Warning: Removed 2 rows containing non-finite values (stat_smooth).</span>

<span class='c'>#&gt; Warning: Removed 2 rows containing missing values (geom_point).</span>

</code></pre>
<img src="figs/unnamed-chunk-10-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

</div>

<br>

------------------------------------------------------------------------

## 3 -- Grids

In the breakout room, we tried faceting by two variables. While you can do this, `facet_wrap()` really is best suited for faceting on one variable. When you want to partition things based on more than one variable, `facet_grid()` might be a better option. Below, I'll create a plot similar to the one in the breakout room where we faceted on a combination of *island* and *sex*, but will do it with `facet_grid()` instead...

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
<img src="figs/unnamed-chunk-11-1.png" width="700px" style="display: block; margin: auto;" />

</div>

This plot's a little cleaner than what we created with `facet_wrap()`, which looked like...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>species</span> <span class='o'>==</span> <span class='s'>"Adelie"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_smooth</span><span class='o'>(</span>method <span class='o'>=</span> <span class='s'>"lm"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"island"</span>, <span class='s'>"sex"</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

</code></pre>
<img src="figs/unnamed-chunk-12-1.png" width="700px" style="display: block; margin: auto;" />

</div>

------------------------------------------------------------------------

## 4 -- Multi-Panel Plots: Patchwork

The faceting above works when you want to partition the plots based on one or more variables in the dataset. But if you want to just arrange different plots into one figure, possibly even different types of plots, one good option is the *patchwork* package. Let's install and load it...

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
<img src="figs/unnamed-chunk-16-1.png" width="700px" style="display: block; margin: auto;" />

</div>

------------------------------------------------------------------------

### Breakout Rooms II: Combining Plots

<div class="puzzle">

<div>

Use the palmerpenguin data to try to create the plot below...

<div class="highlight">

<img src="figs/unnamed-chunk-17-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<details>
<summary>
<b>Hints</b> (click here)
</summary>

<br> 1.) For the boxplot, R initially interprets the *year* variable as a continuous variable. Boxplots need a discrete x axis. Convert that variable to character or factor. You can use `mutate` along with `as.character` or `as.factor`.  
2.) For the formatting, try `theme_classic()` 3.) The title and axis labels can be specified with `labs()`, among other options. <br>

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

