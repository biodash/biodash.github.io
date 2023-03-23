---
title: "Chapter 10 - Visualizing Data, 1"
subtitle: "Introduction to Data Visualization with **ggplot2**"
summary: "In this session of Code Club, we'll look at how to visualize data in R using **ggplot2**."  
authors: [michael-broe, jessica-cooperstone]
date: "2023-03-23"
output: hugodown::md_document
toc: true
image: 
  caption: "Artwork by [@allison_horst](https://twitter.com/allison_horst)"
  focal_point: ""
  preview_only: false
editor_options: 
  markdown: 
    wrap: 72
rmd_hash: 4e502fd27b0016e4

---

<br> <br> <br>

------------------------------------------------------------------------

## New To Code Club?

-   First, check out the [Code Club Computer Setup](/codeclub-setup/) instructions, which also has some pointers that might be helpful if you're new to R or RStudio.

-   Please open RStudio before Code Club to test things out -- if you run into issues, join early and we'll troubleshoot.

------------------------------------------------------------------------

## Session Goals

-   Learn the philosophy of **coding** a graphic.
-   Learn the basic **template** of a **ggplot2** graphic, so you can reuse it for multiple chart types.
-   Learn how you can quickly add visual information to a graphic using **aesthetics** and **layers**.

------------------------------------------------------------------------

## Intro: The ggplot2 philosophy

We have already seen that in R, instead of manually manipulating data frames as you might do when editing Excel sheets, we **code** the operations we want to perform using **dplyr** verbs like [`select()`](https://dplyr.tidyverse.org/reference/select.html), [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html), [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html), and so on.

In a similar way when performing visualization, instead of clicking on a chart type in Excel, we **code the chart** in R.

And just as **dplyr** gives us efficient ways to manipulate data frames, **ggplot2** (which is also part of the tidyverse) gives us efficient ways to manipulate charts/plots/graphics (we use these terms interchangeably).

The **gg** in **ggplot2** stands for *grammar of graphics*, a systematic approach for designing statistical plots developed by Leland Wilkinson. The idea behind this was to think about 'pulling apart' various plots into their shared component pieces, then provide code that could put them together again. We can then create new plots like we create new sentences (once we understand this grammar).

There are two parts to this. First, the 'nouns and verbs' we need to work with plots are very different than those we need to work with data frames. **ggplot2** is like a mini-language of its own, with its own verbs and syntax.

Second, this notion of pulling apart a graphic leads to the idea of *layers*. You can build up a plot of any complexity by *overlaying* different views of the same data.

There's a learning curve here for sure, but there are a couple of things that help us.

First, every graphic shares a *common template*. This is like thinking about the sentence "The cat sat on the mat" grammatically as the template `NP V PP` (`N`oun `P`hrase "The cat", `V`erb "sat", `P`repositional `P`hrase "on the mat"). Once you understand this structure you can "say" a *lot* of different things.

(And I mean a *lot*. The [ggplot cheat sheet](https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf) lists over 40 plot-types, but because this is a language, users can create their own [extensions](https://exts.ggplot2.tidyverse.org/gallery/) that you can also utilize, adding over 80 more.)

Second, the way we put layers together is identical to the way we use pipes. You can read `%>%` as "and then": [`select()`](https://dplyr.tidyverse.org/reference/select.html) *and then* [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) *and then* [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html). In graphics, we can say "show this layer, and then *overlay* this layer, and then *overlay* this layer", etc., using a very similar syntax.

<br>

------------------------------------------------------------------------

## Examples

So how does this work in practice? We'll work through visualizing the **iris** dataset that you've seen before. This is an extremely famous [dataset](https://en.m.wikipedia.org/wiki/Iris_flower_data_set) that was first analyzed by R. A. Fisher in 1936: *The use of multiple measurements in taxonomic problems*. He was attempting to use petal and sepal measurements to discriminate one species from another.

**ggplot2** is part of the tidyverse package so we need to load that first:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># this assumes you've already installed tidyverse</span></span>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span></span>
<span><span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching packages</span> ─────────────────────────────────────── tidyverse 1.3.2 ──</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>ggplot2</span> 3.4.0      <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>purrr  </span> 1.0.1 </span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tibble </span> 3.1.8      <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>dplyr  </span> 1.0.10</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tidyr  </span> 1.2.1      <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>stringr</span> 1.5.0 </span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>readr  </span> 2.1.3      <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>forcats</span> 0.5.2 </span></span>
<span><span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span> ────────────────────────────────────────── tidyverse_conflicts() ──</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>filter()</span> masks <span style='color: #0000BB;'>stats</span>::filter()</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>lag()</span>    masks <span style='color: #0000BB;'>stats</span>::lag()</span></span></code></pre>

</div>

And recall that the **iris** dataset (3 species, 50 observations per species) is automatically available to us:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>iris</span><span class='o'>)</span></span>
<span><span class='c'>#&gt;   Sepal.Length Sepal.Width Petal.Length Petal.Width Species</span></span>
<span><span class='c'>#&gt; 1          5.1         3.5          1.4         0.2  setosa</span></span>
<span><span class='c'>#&gt; 2          4.9         3.0          1.4         0.2  setosa</span></span>
<span><span class='c'>#&gt; 3          4.7         3.2          1.3         0.2  setosa</span></span>
<span><span class='c'>#&gt; 4          4.6         3.1          1.5         0.2  setosa</span></span>
<span><span class='c'>#&gt; 5          5.0         3.6          1.4         0.2  setosa</span></span>
<span><span class='c'>#&gt; 6          5.4         3.9          1.7         0.4  setosa</span></span></code></pre>

</div>

What is the correlation between petal length and width in these species? Are longer petals also wider? We can visualize this with a scatterplot. But first let's look a the ggplot template. (Note the package is **ggplot2**, the command is `ggplot`.)

    ggplot(data = <DATA>) + 
      <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

These are the obligatory parts of any plot. The first argument to [`ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html) is the data frame:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>iris</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-3-1.png" width="700px" style="display: block; margin: auto;" />

</div>

This is not very interesting! but it's notable that it is *something*. [`ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html) has created a base coordinate system (a base layer) that we can add visual layers to. The *add a layer* operator is "**+**", which is the ggplot equivalent of the pipe symbol, and **it must occur at the end of the line**.

The next argument specifies the kind plot we want: scatterplot, bar chart, fitted line, boxplot, pie chart, etc. **ggplot2** refers to these as **geoms**: the geometrical object that a plot uses to represent data. You can see an overview of many of these geoms in the [cheat sheet](https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf). The geom for a scatterplot is [`geom_point()`](https://ggplot2.tidyverse.org/reference/geom_point.html).

But we also require a `mapping` argument, which maps the *variables* in the dataset we want to focus on to their *visual representation* in the plot.

And finally we need to specify an **aesthetic** for the geometric objects in the plot, which will control things like shape, color, transparency, etc. Perhaps surprisingly, for a scatterplot, the x and y coordinates are aesthetics, since these control, not the shape or color, but the relative position of the points in the coordinate system.

Here is our complete plot:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>iris</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_point.html'>geom_point</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>Petal.Length</span>, y <span class='o'>=</span> <span class='nv'>Petal.Width</span><span class='o'>)</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-4-1.png" width="700px" style="display: block; margin: auto;" />

</div>

There is clearly a positive correlation between length and width. And we can make this even more apparent by visually fitting a line to the data, by *overlaying* another geom in the same plot.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>iris</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_point.html'>geom_point</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>Petal.Length</span>, y <span class='o'>=</span> <span class='nv'>Petal.Width</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_smooth.html'>geom_smooth</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>Petal.Length</span>, y <span class='o'>=</span> <span class='nv'>Petal.Width</span><span class='o'>)</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; `geom_smooth()` using method = 'loess' and formula = 'y ~ x'</span></span></code></pre>
<img src="figs/unnamed-chunk-5-1.png" width="700px" style="display: block; margin: auto;" />

</div>

There is clearly some code redundancy here, and we really don't want the x, y mapping of these two layers to be independent. We can extract the common mapping information and move it to the top level:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>iris</span>, mapping <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>Petal.Length</span>, y <span class='o'>=</span> <span class='nv'>Petal.Width</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_point.html'>geom_point</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_smooth.html'>geom_smooth</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; `geom_smooth()` using method = 'loess' and formula = 'y ~ x'</span></span></code></pre>
<img src="figs/unnamed-chunk-6-1.png" width="700px" style="display: block; margin: auto;" />

</div>

So we have the possibility of *local* layer specifications, and *global* specifications. Global specifications are *inherited* by all the local layers.

### The power of aesthetics

The aim of Fisher's paper was to try to discriminate different species based on their morphological measurements. It looks from this plot that there are two distinct clusters. Do these clusters correspond to different species? There are two clusters, but three species. How can we explore this further?

Our current plot uses two numeric variables: `Petal.Length` and `Petal.width`. We can add a third categorical variable, like `Species`, to a two dimensional scatterplot by mapping it to a different visual aesthetic. We've mapped length and width to x,y coordinates. Now we'll simultaneously map species to `color` by expanding our list of aesthetics:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>iris</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='o'>(</span><span class='nv'>mapping</span> <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>Petal.Length</span>, y <span class='o'>=</span> <span class='nv'>Petal.Width</span>, color <span class='o'>=</span> <span class='nv'>Species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_point.html'>geom_point</a></span><span class='o'>(</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-7-1.png" width="700px" style="display: block; margin: auto;" />

</div>

The R help for a specific geoms will list, among other things, all the aesthetics that geom supports.

<br>

------------------------------------------------------------------------

## Breakout Rooms

In the exercises we'll be looking a little more at the **iris** data, and in addition, the NHANES data we used last week, and the left-joined bird dataset we built [some time ago](https://biodash.github.io/codeclub/03_joining-datasets/).

Please install the NHANES dataset:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"NHANES"</span>, repos <span class='o'>=</span> <span class='s'>"http://cran.us.r-project.org"</span><span class='o'>)</span></span></code></pre>

</div>

Once installed, load it with:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'>NHANES</span><span class='o'>)</span></span></code></pre>

</div>

A prebuilt joined data set on birds can be downloaded using the code below.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># create a data directory for the new file if you haven't done so yet:</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>"data/birds"</span>, recursive <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span></span>
<span></span>
<span><span class='c'># set the url</span></span>
<span><span class='nv'>joined_data_url</span> <span class='o'>&lt;-</span> <span class='s'>"https://raw.githubusercontent.com/biodash/biodash.github.io/master/content/codeclub/S05E08_ggplot-1/joined_data.tsv"</span></span>
<span></span>
<span><span class='c'># set the path for the downloaded file</span></span>
<span><span class='nv'>joined_file</span> <span class='o'>&lt;-</span> <span class='s'>"data/birds/joined_data.tsv"</span></span>
<span></span>
<span><span class='c'>#download to file</span></span>
<span><span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>joined_data_url</span>, destfile <span class='o'>=</span> <span class='nv'>joined_file</span><span class='o'>)</span></span>
<span></span>
<span><span class='c'># read file</span></span>
<span><span class='nv'>joined_data</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_tsv</a></span><span class='o'>(</span><span class='nv'>joined_file</span><span class='o'>)</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; <span style='font-weight: bold;'>Rows: </span><span style='color: #0000BB;'>311441</span> <span style='font-weight: bold;'>Columns: </span><span style='color: #0000BB;'>9</span></span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>──</span> <span style='font-weight: bold;'>Column specification</span> <span style='color: #00BBBB;'>────────────────────────────────────────────────────────</span></span></span>
<span><span class='c'>#&gt; <span style='font-weight: bold;'>Delimiter:</span> "\t"</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>chr</span>  (4): species, locality, stateProvince, species_en</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>dbl</span>  (4): adult_body_mass_g, adult_svl_cm, longevity_y, litter_or_clutch_size_n</span></span>
<span><span class='c'>#&gt; <span style='color: #0000BB;'>dttm</span> (1): eventDate</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> Use `spec()` to retrieve the full column specification for this data.</span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> Specify the column types or set `show_col_types = FALSE` to quiet this message.</span></span></code></pre>

</div>

### Exercise 1

<div class="puzzle">

Revisit the **iris** data set, and plot sepal width (y) against sepal length (x) colored by species. Which morphological character, petals or sepals, provides the greatest discrimination between species?

<details>
<summary>
Hints (click here)
</summary>
<br>Simply reuse the code we used for petals. You can often leverage code from an old plot for a new one. <br> <br>
</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>iris</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='o'>(</span><span class='nv'>mapping</span> <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>Sepal.Length</span>, y <span class='o'>=</span> <span class='nv'>Sepal.Width</span>, color <span class='o'>=</span> <span class='nv'>Species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_point.html'>geom_point</a></span><span class='o'>(</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-12-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Note this solution shows yet another way to position global mapping information: as its own layer. This can help readability and avoid too many nested parentheses.
</details>

</div>

------------------------------------------------------------------------

### Exercise 2

<div class="puzzle">

Use the NHANES data set to plot body mass index (y) against height (x). Color by gender. Which gender has the highest BMI?

<details>
<summary>
Hints (click here)
</summary>
<br><code>glimpse()</code> the dataset to identify the variable names. <br> <br>
</details>
<details>
<summary>
Solution (click here)
</summary>
<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>NHANES</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_point.html'>geom_point</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>Height</span>, y <span class='o'>=</span> <span class='nv'>BMI</span>, color <span class='o'>=</span> <span class='nv'>Gender</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; Warning: Removed 366 rows containing missing values (`geom_point()`).</span></span></code></pre>
<img src="figs/unnamed-chunk-13-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

------------------------------------------------------------------------

### Exercise 3

<div class="puzzle">

Use the same plot but now color by physical activity. How active are those people with the highest BMI?

<details>
<summary>
Hints (click here)
</summary>
<br>Again, <code>glimpse()</code> the dataset to identify the variable names. <br> <br>
</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>NHANES</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_point.html'>geom_point</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>Height</span>, y <span class='o'>=</span> <span class='nv'>BMI</span>, color <span class='o'>=</span> <span class='nv'>PhysActive</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; Warning: Removed 366 rows containing missing values (`geom_point()`).</span></span></code></pre>
<img src="figs/unnamed-chunk-14-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

------------------------------------------------------------------------

### Exercise 4

<div class="puzzle">

Often plotting the data allows us to identify outliers, which may be data-entry errors, or genuinely extreme data. Using the `joined_data` set, plot adult body mass (y) against longevity (x). Identify extreme data points at the high end of body mass. How can we identify what these points represent?

<details>
<summary>
Hints (click here)
</summary>
<br> Examine the plot to find an appropriate threshold value, and filter the data using that value. How many data points are there passing that threshold? What species are represented by these data points? How many weights are reported? Why is the plot misleading here? <br> <br>
</details>
<details>
<summary>
Solution (click here)
</summary>
<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>joined_data</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_point.html'>geom_point</a></span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>longevity_y</span>, y <span class='o'>=</span> <span class='nv'>adult_body_mass_g</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; Warning: Removed 24089 rows containing missing values (`geom_point()`).</span></span></code></pre>
<img src="figs/unnamed-chunk-15-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>joined_data</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>adult_body_mass_g</span> <span class='o'>&gt;</span> <span class='m'>10000</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 228 × 9</span></span></span>
<span><span class='c'>#&gt;    species   local…¹ state…² eventDate           speci…³ adult…⁴ adult…⁵ longe…⁶</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dttm&gt;</span>              <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> Cygnus o… Findlay Ohio    2008-02-17 <span style='color: #555555;'>00:00:00</span> Mute S…   <span style='text-decoration: underline;'>10</span>230    142.    27.7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> Cygnus o… Dundee  Ohio    2004-02-16 <span style='color: #555555;'>00:00:00</span> Mute S…   <span style='text-decoration: underline;'>10</span>230    142.    27.7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> Cygnus o… 44805 … Ohio    2006-02-18 <span style='color: #555555;'>00:00:00</span> Mute S…   <span style='text-decoration: underline;'>10</span>230    142.    27.7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> Cygnus o… 45011 … Ohio    2005-02-19 <span style='color: #555555;'>00:00:00</span> Mute S…   <span style='text-decoration: underline;'>10</span>230    142.    27.7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> Cygnus b… 45042 … Ohio    2009-02-13 <span style='color: #555555;'>00:00:00</span> Trumpe…   <span style='text-decoration: underline;'>10</span>300    159.    26.5</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> Cygnus o… 44813 … Ohio    2007-02-19 <span style='color: #555555;'>00:00:00</span> Mute S…   <span style='text-decoration: underline;'>10</span>230    142.    27.7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> Cygnus o… Spencer Ohio    2008-02-16 <span style='color: #555555;'>00:00:00</span> Mute S…   <span style='text-decoration: underline;'>10</span>230    142.    27.7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> Cygnus o… 44903 … Ohio    2009-02-16 <span style='color: #555555;'>00:00:00</span> Mute S…   <span style='text-decoration: underline;'>10</span>230    142.    27.7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> Cygnus o… 44601 … Ohio    2002-02-16 <span style='color: #555555;'>00:00:00</span> Mute S…   <span style='text-decoration: underline;'>10</span>230    142.    27.7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> Cygnus o… Avon L… Ohio    2007-02-17 <span style='color: #555555;'>00:00:00</span> Mute S…   <span style='text-decoration: underline;'>10</span>230    142.    27.7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 218 more rows, 1 more variable: litter_or_clutch_size_n &lt;dbl&gt;, and</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   abbreviated variable names ¹​locality, ²​stateProvince, ³​species_en,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   ⁴​adult_body_mass_g, ⁵​adult_svl_cm, ⁶​longevity_y</span></span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>joined_data</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>adult_body_mass_g</span> <span class='o'>&gt;</span> <span class='m'>10000</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/distinct.html'>distinct</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 2 × 1</span></span></span>
<span><span class='c'>#&gt;   species          </span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>            </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Cygnus olor      </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Cygnus buccinator</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>joined_data</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>adult_body_mass_g</span> <span class='o'>&gt;</span> <span class='m'>10000</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nv'>adult_body_mass_g</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/distinct.html'>distinct</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 2 × 1</span></span></span>
<span><span class='c'>#&gt;   adult_body_mass_g</span></span>
<span><span class='c'>#&gt;               <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span>             <span style='text-decoration: underline;'>10</span>230</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span>             <span style='text-decoration: underline;'>10</span>300</span></span></code></pre>

</div>

</details>

</div>

### Bonus exercise: a new geom!

<div class="puzzle">

Revisit the **iris** data and generate a density histogram for sepal length, categorized by species.

<details>
<summary>
Hints (click here)
</summary>
<br>Use <code>geom_density()</code>. Check the help to see what aesthetics it supports. Note that while you 'color' a point, you 'fill' an area. <br> <br>
</details>
<details>
<summary>
Solution (click here)
</summary>
<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>iris</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='o'>(</span><span class='nv'>mapping</span> <span class='o'>=</span> <span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>Sepal.Length</span>, fill <span class='o'>=</span> <span class='nv'>Species</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_density.html'>geom_density</a></span><span class='o'>(</span>alpha <span class='o'>=</span> <span class='m'>0.5</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/unnamed-chunk-19-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Note, what does the **alpha** aesthetic control? <br>

</details>

</div>

------------------------------------------------------------------------

<br> <br>

