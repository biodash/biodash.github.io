---
title: "S02E07: Intro to ggplot2 (part 2)"
subtitle: "Boxplots -- and layering, formatting and saving plots."
summary: "During this second part of an introduction to ggplot2, we will get a better understanding of using geoms, with boxplots as an example, and will also learn about formatting and saving plots."
authors: [admin]
date: 2021-10-05
output: hugodown::md_document
toc: true

rmd_hash: a514fae3f9f37bf3

---

<br>

------------------------------------------------------------------------

## New to Code Club?

-   First, check out the [Code Club Computer Setup](/codeclub-setup/) instructions, which also has pointers for if you're new to R or RStudio.

-   Please open RStudio before Code Club starts to test things out -- and in case you run into issues, please join the Zoom call early and we'll troubleshoot.

#### New to *ggplot2*?

-   Check out the [last Code Club Session](/codeclub/S02E06_ggplot2/), which was the first of this two-part introduction to *ggplot2*.

-   You may find [this *ggplot2* cheat sheet](https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf) useful!

<br>

------------------------------------------------------------------------

## Introduction

#### Session goals

-   Get more familiar with building and layering plots using geoms, using a new geom, [`geom_boxplot()`](https://ggplot2.tidyverse.org/reference/geom_boxplot.html), as our starting point.

-   Learn to format plots using [`theme()`](https://ggplot2.tidyverse.org/reference/theme.html) and [`labs()`](https://ggplot2.tidyverse.org/reference/labs.html).

<br>

#### Getting set up

We will continue to work with the data contained in the Palmer Penguins package. You only have to install it if you didn't do so in a previous session:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"palmerpenguins"</span><span class='o'>)</span></code></pre>

</div>

If the package has been installed, you do need to always load it with the [`library()`](https://rdrr.io/r/base/library.html) function -- and we'll also load the *tidyverse*, which includes the *ggplot2* package.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/'>palmerpenguins</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span></code></pre>

</div>

<br>

#### Penguin bill length

We are going to mostly be plotting `bill_length_mm`, which is the "horizontal" length of the bill: see the image below.

<figure>
<p align="center">
<img src=figs/culmen_depth.png width="75%" alt="depiction of bill length protruding from the penguins face, and bill depth, the height of the bill">
<figcaption>
Artwork by Allison Horst
</figcaption>
</p>
</figure>

<br>

------------------------------------------------------------------------

## 1 - A geom for boxplots

#### Geom recap

*ggplot2*'s "geoms" are basically plot types of which there are quite a few available (see the [cheatsheet](https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf)). Last week, we saw two geoms: `geom_point()` to plot individual data points, and `geom_smooth()` to fit a line to data points.

While doing so, we also saw two other properties of *ggplot2* and its geoms:

-   Geoms can be layered on top of each other.

-   Geoms can simply plot the data "as is" (`geom_point()`) or can perform computations under the hood, and show the results of those computations (`geom_smooth()`).

Let's use a new geom to get a little more fluent with *ggplot2* basics.

#### Boxplots

A boxplot is a very useful type of plot that shows you the median as well as the variation of a distribution. *ggplot2* has the geom `geom_boxplot()` to create boxplots -- another example of a geom that does calculations for us prior to plotting.

Let's make a boxplot that shows the distribution of penguin bill length (column `bill_length_mm` in our `penguins` dataframe) along the y-axis -- recall that we use `aes()` to refer to a column in the data frame from which the data should be taken:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>y <span class='o'>=</span> <span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing non-finite values (stat_boxplot).</span>
</code></pre>
<img src="figs/unnamed-chunk-3-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<details>
<summary>
<b>Why do we get the warning shown above?</b> (click here)
</summary>

<br>

We got the following warning:

> `#> Warning: Removed 2 rows containing non-finite values (stat_boxplot).`

We get this warning because 2 rows contain `NA`s for the variable we are plotting, `bill_length_mm`.

We could take a look at those rows as follows:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/NA.html'>is.na</a></span><span class='o'>(</span><span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 2 × 8</span></span>
<span class='c'>#&gt;   species island bill_length_mm bill_depth_mm flipper_length_… body_mass_g sex  </span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>           <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>            <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> Adelie  Torge…             <span style='color: #BB0000;'>NA</span>            <span style='color: #BB0000;'>NA</span>               <span style='color: #BB0000;'>NA</span>          <span style='color: #BB0000;'>NA</span> <span style='color: #BB0000;'>NA</span>   </span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> Gentoo  Biscoe             <span style='color: #BB0000;'>NA</span>            <span style='color: #BB0000;'>NA</span>               <span style='color: #BB0000;'>NA</span>          <span style='color: #BB0000;'>NA</span> <span style='color: #BB0000;'>NA</span>   </span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 1 more variable: year &lt;int&gt;</span></span></code></pre>

</div>

And we could *remove* those rows as follows, saving the results in a new dataframe:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>## By negating the `is.na` condition:</span>
<span class='nv'>penguins_noNA</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='o'>!</span><span class='nf'><a href='https://rdrr.io/r/base/NA.html'>is.na</a></span><span class='o'>(</span><span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>## Or using the specialized `drop_na` function:</span>
<span class='nv'>penguins_noNA</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span> <span class='nf'>drop_na</span><span class='o'>(</span><span class='nv'>bill_length_mm</span><span class='o'>)</span></code></pre>

</div>

</details>
<details>
<summary>
The nitty-gritty of boxplots: what is shown exactly? (click here)
</summary>

<br>

-   Lower whisker = smallest observation greater than or equal to lower hinge - 1.5 \* IQR
-   Lower hinge/bottom line of box part of boxplot = 25% quantile
-   Middle line = median = 50% quantile
-   Upper hinge/top line of box part of boxplot = 75% quantile
-   Upper whisker = largest observation less than or equal to upper hinge + 1.5 \* IQR

</details>

<br>

That worked, but the plot shows the distribution of bill lengths across all 3 species together, which is not that informative. To separate species along the x-axis, we can map the `species` column to x:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, x <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing non-finite values (stat_boxplot).</span>
</code></pre>
<img src="figs/unnamed-chunk-6-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Great! We can see, at a glance, that Adelie Penguins tend to have considerably shorter bills than the other two species. Chinstrap's bills are just a bit longer than those of Gentoos, but the longest-billed bird is a Gentoo.

<br>

------------------------------------------------------------------------

## 2 - Adding a plot layer

To get an even better sense of the distribution of bill lengths, and also of our sample sizes, we may want to add the raw data points to our boxplot:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, x <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span>,
               outlier.shape <span class='o'>=</span> <span class='kc'>NA</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing non-finite values (stat_boxplot).</span>
<span class='c'>#&gt; Error: geom_point requires the following missing aesthetics: x and y</span></code></pre>

</div>

Why did this not work?

We had previously set the aesthetics inside the `geom_boxplot()` call -- that is, we set it for that geom only, and not for the entire plot. To add a `geom_point()` layer with the same aesthetics, we can do one of two things:

-   Move the `aes()` specification into the `ggplot()` call, or
-   Specify the `aes()` *also* inside `geom_point()`.

Let's do the latter, so we are not repeating ourselves:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, x <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>outlier.shape <span class='o'>=</span> <span class='kc'>NA</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing non-finite values (stat_boxplot).</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing missing values (geom_point).</span>
</code></pre>
<img src="figs/unnamed-chunk-8-1.png" width="700px" style="display: block; margin: auto;" />

</div>

This doesn't look too good because many of the points are plotted on top of each other. We can use a few arguments to `geom_point()` to make some changes:

-   Add `position = "jitter"` to the `geom_point()` call to introduce a small amount of randomness to our points to make us able to see them better.

-   Add `size = 1` to make the point size a little smaller (1.5 is the default).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, x <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>outlier.shape <span class='o'>=</span> <span class='kc'>NA</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>position <span class='o'>=</span> <span class='s'>"jitter"</span>, size <span class='o'>=</span> <span class='m'>1</span><span class='o'>)</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing non-finite values (stat_boxplot).</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing missing values (geom_point).</span>
</code></pre>
<img src="figs/unnamed-chunk-9-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Note that `position = "jitter"` and `size = 1` are *not* specified as mappings (i.e., not inside `mapping = aes()`): here, we are not mapping data to the plot, but are just changing some "settings".

<div class="alert alert-note">

<div>

Because jittering is so common, there is also a specialized jittering geom available: `geom_jitter()` is shorthand for `geom_point(position = "jitter")`.

So, we could have also used the following code to create the same plot:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, x <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>outlier.shape <span class='o'>=</span> <span class='kc'>NA</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_jitter</span><span class='o'>(</span>size <span class='o'>=</span> <span class='m'>1</span><span class='o'>)</span></code></pre>

</div>

</div>

</div>

<br>

------------------------------------------------------------------------

## Breakout Rooms I

<div class="puzzle">
<div>

### Exercise 1

-   Run the code below and figure out what the problem is.  
    (And why do you think *ggplot2* creates a legend with the item "blue", instead of throwing an error?)

-   Modify the code to get the originally intended effect: blue points.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span>,
       <span class='nf'>aes</span><span class='o'>(</span>y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, x <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>outlier.shape <span class='o'>=</span> <span class='kc'>NA</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"blue"</span><span class='o'>)</span>,
             position <span class='o'>=</span> <span class='s'>"jitter"</span><span class='o'>)</span></code></pre>

</div>

<details>
<summary>
Hints (click here)
</summary>

<br>

-   Here is the botched plot:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span>,
       <span class='nf'>aes</span><span class='o'>(</span>y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, x <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>outlier.shape <span class='o'>=</span> <span class='kc'>NA</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"blue"</span><span class='o'>)</span>,
             position <span class='o'>=</span> <span class='s'>"jitter"</span><span class='o'>)</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing non-finite values (stat_boxplot).</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing missing values (geom_point).</span>
</code></pre>
<img src="figs/unnamed-chunk-12-1.png" width="700px" style="display: block; margin: auto;" />

</div>

-   Should `color = "blue"` be a mapping, that is, should it be part of the `mapping = aes()` argument?

</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

-   **The problem with the original code** is that `color = "blue"` should *not* be a mapping.

-   **Why *ggplot2* does not throw an error:** the `mapping` argument is used to map data to an aesthetic like point color. Normally, that data is a column in the dataframe, but because the code quotes "blue" (`color = "blue"` instead of `color = blue`), *ggplot2* does not assume it is a column and instead creates a variable on the fly that just contains the value "blue".

-   **The correct code to color points blue**:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, x <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>outlier.shape <span class='o'>=</span> <span class='kc'>NA</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"blue"</span>,
             position <span class='o'>=</span> <span class='s'>"jitter"</span><span class='o'>)</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing non-finite values (stat_boxplot).</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing missing values (geom_point).</span>
</code></pre>
<img src="figs/unnamed-chunk-13-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</div>
</div>

<br>

<div class="puzzle">

<div>

### Exercise 2

Violin plots are somewhat similar to boxplots, but show a density distribution. Using Google, find out which *ggplot2* geom creates a violin plot, and then make one plotting bill length by species like we have done for boxplots.

<details>
<summary>
Hints (click here)
</summary>

<br>

-   `geom_violin()` is the geom that creates violin plots.

-   Other than the geom function, you can leave the code the same as in the previous examples.

</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>y <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, x <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_violin</span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing non-finite values (stat_ydensity).</span>
</code></pre>
<img src="figs/unnamed-chunk-14-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

<br>

</div>

</div>

<br>

------------------------------------------------------------------------

## 3 - Intro to formatting plots

So far, we have mostly been concerned with *what* we are plotting, and haven't paid much attention to how our plot looks. But I, for one, dislike that gray background to the plot, and perhaps the axis labels are a little small?

*ggplot2* offers *many* options to modify the look of our plot. There are so many that it isn't really possible to remember even the majority of them. Therefore, even for daily users *ggplot2*, creating a publication-ready figure will usually involve some Googling or checking the [ggplot2 documentation](https://ggplot2.tidyverse.org/).

Let's have a look at some of the most commonly used options to change the look of *ggplot2* plots.

#### A starting plot

We'll start with the following plot, similar to one we have created before:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>outlier.shape <span class='o'>=</span> <span class='kc'>NA</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>position <span class='o'>=</span> <span class='s'>"jitter"</span>, size <span class='o'>=</span> <span class='m'>1</span>, color <span class='o'>=</span> <span class='s'>"grey70"</span><span class='o'>)</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing non-finite values (stat_boxplot).</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing missing values (geom_point).</span>
</code></pre>
<img src="figs/unnamed-chunk-15-1.png" width="700px" style="display: block; margin: auto;" />

</div>

(Note the addition of `color = "grey70"` to make the points less dominant in the plot.  
See [this PDF for an overview of named colors in R](http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf).)

<br>

------------------------------------------------------------------------

## 4 - Formatting with `theme()` and more

The quickest way to modify the overall look and feel of our plot is by using a different "complete theme". The default theme is `theme_gray()`, which comes with that gray background and many other settings that control what the plot looks like.

The *ggplot2* documentation has [a list of complete themes](https://ggplot2.tidyverse.org/reference/ggtheme.html) that shows you what they look like.

Let's switch to a different theme, `theme_classic()`, for our penguin boxplot:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>outlier.shape <span class='o'>=</span> <span class='kc'>NA</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>position <span class='o'>=</span> <span class='s'>"jitter"</span>, size <span class='o'>=</span> <span class='m'>1</span>, color <span class='o'>=</span> <span class='s'>"grey70"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_classic</span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing non-finite values (stat_boxplot).</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing missing values (geom_point).</span>
</code></pre>
<img src="figs/unnamed-chunk-16-1.png" width="700px" style="display: block; margin: auto;" />

</div>

These complete theme functions (`theme_<theme-name>`) also take a few arguments --  
`base_size` is very useful if we want to simultaneously change the size of all text labels:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>outlier.shape <span class='o'>=</span> <span class='kc'>NA</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>position <span class='o'>=</span> <span class='s'>"jitter"</span>, size <span class='o'>=</span> <span class='m'>1</span>, color <span class='o'>=</span> <span class='s'>"grey70"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_classic</span><span class='o'>(</span>base_size <span class='o'>=</span> <span class='m'>14</span><span class='o'>)</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing non-finite values (stat_boxplot).</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing missing values (geom_point).</span>
</code></pre>
<img src="figs/unnamed-chunk-17-1.png" width="700px" style="display: block; margin: auto;" />

</div>

This retains the relative sizes of different labels. For instance, note that in both plots, the "axis titles" (`species` on x, `bill_lenth_mm` on y) are larger than the "axis text" (the labels at the tick marks).

If we wanted to change individual theme components like those, we would need to use the `theme()` function (check [its documentation page](https://ggplot2.tidyverse.org/reference/theme.html) to see the -many!- possible arguments).

For example, to make axis titles and axis text/labels the same size:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>outlier.shape <span class='o'>=</span> <span class='kc'>NA</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>position <span class='o'>=</span> <span class='s'>"jitter"</span>, size <span class='o'>=</span> <span class='m'>1</span>, color <span class='o'>=</span> <span class='s'>"grey70"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_classic</span><span class='o'>(</span>base_size <span class='o'>=</span> <span class='m'>14</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>axis.text <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>size <span class='o'>=</span> <span class='m'>14</span><span class='o'>)</span>,
        axis.title <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>size <span class='o'>=</span> <span class='m'>14</span><span class='o'>)</span><span class='o'>)</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing non-finite values (stat_boxplot).</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing missing values (geom_point).</span>
</code></pre>
<img src="figs/unnamed-chunk-18-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<br>

------------------------------------------------------------------------

## 5 - Adding labels to our plot

Right now, the axis titles are simply the names of the columns that we used in the mapping. The y-axis title in particular (`bill_length_mm`) could be improved. We might also want to add a title and even a subtitle to our plot.

We can do all of this with the `labs()` function as follows:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>outlier.shape <span class='o'>=</span> <span class='kc'>NA</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>position <span class='o'>=</span> <span class='s'>"jitter"</span>, size <span class='o'>=</span> <span class='m'>1</span>, color <span class='o'>=</span> <span class='s'>"grey70"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_classic</span><span class='o'>(</span>base_size <span class='o'>=</span> <span class='m'>14</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Penguin Bill Length by Species and Sex"</span>,
       subtitle <span class='o'>=</span> <span class='s'>"Collected at Palmer Station, Antarctica"</span>,
       x <span class='o'>=</span> <span class='s'>"Penguin Species"</span>,     <span class='c'># x-axis label</span>
       y <span class='o'>=</span> <span class='s'>"Bill length (mm)"</span><span class='o'>)</span>    <span class='c'># y-axis label</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing non-finite values (stat_boxplot).</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing missing values (geom_point).</span>
</code></pre>
<img src="figs/unnamed-chunk-19-1.png" width="700px" style="display: block; margin: auto;" />

</div>

------------------------------------------------------------------------

## Breakout Rooms II

<div class="puzzle">

<div>

### Exercise 3

-   Modify the code used to produce the last plot (just above this exercise) to try several of the themes from the [list of complete themes](https://ggplot2.tidyverse.org/reference/ggtheme.html). Any preferences?

The [list of complete themes](https://ggplot2.tidyverse.org/reference/ggtheme.html) also shows that these functions have a few more arguments than the `base_size` one we explored.

-   Bonus: Change the `base_line_size`. What does it do?

-   Bonus (**may not work out of the box on Windows**): Using a different font family can nicely shake things up -- this is the `base_family` argument. Most standard font family names (e.g. see [this list](https://www.w3.org/Style/Examples/007/fonts.en.html)) should work. For instance, you can try `Optima`, `Verdana`, `Times New Roman`, `Courier`, or `cursive`.

<details>
<summary>
Example solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>outlier.shape <span class='o'>=</span> <span class='kc'>NA</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>position <span class='o'>=</span> <span class='s'>"jitter"</span>, size <span class='o'>=</span> <span class='m'>1</span>, color <span class='o'>=</span> <span class='s'>"grey70"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_classic</span><span class='o'>(</span>base_size <span class='o'>=</span> <span class='m'>14</span>,
                base_line_size <span class='o'>=</span> <span class='m'>1</span>,
                base_family <span class='o'>=</span> <span class='s'>"Optima"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Penguin Bill Length by Species and Sex"</span>,
       subtitle <span class='o'>=</span> <span class='s'>"Collected at Palmer Station, Antarctica"</span>,
       x <span class='o'>=</span> <span class='s'>"Penguin Species"</span>,     <span class='c'># x-axis label</span>
       y <span class='o'>=</span> <span class='s'>"Bill length (mm)"</span><span class='o'>)</span>    <span class='c'># y-axis label</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing non-finite values (stat_boxplot).</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing missing values (geom_point).</span>
</code></pre>
<img src="figs/unnamed-chunk-20-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

<br>

</div>

</div>

<br>

<div class="puzzle">

<div>

### Exercise 4

-   Modify your code from Exercise 3 (or the code used to produce the last plot above Exercise 3) to color the jittered points, but not the boxplots, according to sex.

As we also saw last week, a legend should have automatically appeared when mapping color to a variable. What if we wanted to move the legend from the right to the top of the plot?

-   Scroll through the [`theme()` documentation](https://ggplot2.tidyverse.org/reference/theme.html) and try and find the argument that controls the position of the legend. Then, use this argument to move the legend to the top.

<details>
<summary>
Hints (click here)
</summary>

<br>

-   To color points by sex, but not modify the boxplots, use the `mapping = aes()` argument inside the `geom_point()` call instead of inside the `ggplot()` call.

-   To move the legend, use the `legend.position` argument of `theme()`.

</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

-   Color points by sex:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>outlier.shape <span class='o'>=</span> <span class='kc'>NA</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>position <span class='o'>=</span> <span class='s'>"jitter"</span>, size <span class='o'>=</span> <span class='m'>1</span>,
             mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>color <span class='o'>=</span> <span class='nv'>sex</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_classic</span><span class='o'>(</span>base_size <span class='o'>=</span> <span class='m'>14</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Penguin Bill Length by Species and Sex"</span>,
       subtitle <span class='o'>=</span> <span class='s'>"Collected at Palmer Station, Antarctica"</span>,
       x <span class='o'>=</span> <span class='s'>"Penguin Species"</span>,     <span class='c'># x-axis label</span>
       y <span class='o'>=</span> <span class='s'>"Bill length (mm)"</span><span class='o'>)</span>    <span class='c'># y-axis label</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing non-finite values (stat_boxplot).</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing missing values (geom_point).</span>
</code></pre>
<img src="figs/unnamed-chunk-21-1.png" width="700px" style="display: block; margin: auto;" />

</div>

-   Move the legend to the top:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>species</span>, y <span class='o'>=</span> <span class='nv'>bill_length_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_boxplot</span><span class='o'>(</span>outlier.shape <span class='o'>=</span> <span class='kc'>NA</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>position <span class='o'>=</span> <span class='s'>"jitter"</span>, size <span class='o'>=</span> <span class='m'>1</span>,
             mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>color <span class='o'>=</span> <span class='nv'>sex</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_classic</span><span class='o'>(</span>base_size <span class='o'>=</span> <span class='m'>14</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"top"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Penguin Bill Length by Species and Sex"</span>,
       subtitle <span class='o'>=</span> <span class='s'>"Collected at Palmer Station, Antarctica"</span>,
       x <span class='o'>=</span> <span class='s'>"Penguin Species"</span>,     <span class='c'># x-axis label</span>
       y <span class='o'>=</span> <span class='s'>"Bill length (mm)"</span><span class='o'>)</span>    <span class='c'># y-axis label</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing non-finite values (stat_boxplot).</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing missing values (geom_point).</span>
</code></pre>
<img src="figs/unnamed-chunk-22-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

<br>

</div>

</div>

<br>

