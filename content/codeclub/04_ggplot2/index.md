---
title: "Session 4: Visualizing Data"
subtitle: "Introduction to Data Visualization with **ggplot2**"
summary: "In this session of Code Club, we'll look at how to visualize data in R using **ggplot2**."  
authors: [michael-broe]
date: "2020-12-10"
output: hugodown::md_document
toc: true
image: 
  caption: "Image from http://r-statistics.co/ggplot2-Tutorial-With-R.html"
  focal_point: ""
  preview_only: false
editor_options: 
  markdown: 
    wrap: 72
rmd_hash: 018d9eaf0fb58ee7

---

<br> <br> <br>

------------------------------------------------------------------------

## New To Code Club?

-   First, check out the [Code Club Computer Setup](/codeclub-setup/) instructions, which also has some pointers that might be helpful if you're new to R or RStudio.

-   Please open RStudio before Code Club to test things out -- if you run into issues, join the Zoom call early and we'll troubleshoot.

------------------------------------------------------------------------

## Session Goals

-   Learn the philosophy of **coding** a graphic.
-   Learn the basic **template** of a **ggplot2** graphic, so you can reuse it for multiple chart types.
-   Learn how you can quickly add visual information to a graphic using **aesthetics** and **layers**.

------------------------------------------------------------------------

## Intro: The ggplot2 philosophy

We have already seen that in R, instead of manually manipulating data frames as you might do when editing Excel sheets, we **code** the operations we want to perform using **dplyr** verbs like `select()`, `mutate()`, `inner_join()`, and so on.

In a similar way when performing visualization, instead of clicking on a chart type in Excel, we **code the chart** in R.

And just as **dplyr** gives us efficient ways to manipulate data frames, **ggplot2** (which is also part of the **tidyverse**) gives us efficient ways to manipulate charts/plots/graphics (we use these terms interchangeably).

The **gg** in **ggplot2** stands for *grammar of graphics*, a systematic approach for designing statistical plots developed by Leland Wilkinson. The idea behind this was to think about 'pulling apart' various plots into their shared component pieces, then provide code that could put them together again. We can then create new plots like we create new sentences (once we understand this grammar).

There are two parts to this. First, the 'nouns and verbs' we need to work with plots are very different than those we need to work with data frames. **ggplot2** is like a mini-language of its own, with its own verbs and syntax.

Second, this notion of pulling apart a graphic leads to the idea of *layers*. You can build up a plot of any complexity by *overlaying* different views of the same data.

There's a learning curve here for sure, but there are a couple of things that help us.

First, every graphic shares a *common template*. This is like thinking about the sentence "The cat sat on the mat" grammatically as the template `NP V PP` (`N`oun `P`hrase "The cat", `V`erb "sat", `P`repositional `P`hrase "on the mat"). Once you understand this structure you can "say" a *lot* of different things.

(And I mean a *lot*. The [ggplot cheat sheet](https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf) lists over 40 geoms, but because this is a language, users can create their own [extensions](https://exts.ggplot2.tidyverse.org/gallery/) that you can also utilize, adding over 80 more.)

Second, the way we put layers together is identical to the way we use pipes. You can read `%>%` as "and then": `select()` and then `mutate()` and then `summarize()`. In graphics, we can say "show this layer, and then *overlay* this layer, and then *overlay* this layer", etc., using a very similar syntax.

<br>

------------------------------------------------------------------------

## Examples

So how does this work in practice? We'll work through visualizing the **iris** dataset that you've seen before. This is an extremely famous [dataset](https://en.m.wikipedia.org/wiki/Iris_flower_data_set) that was first analyzed by R. A. Fisher in 1936: *The use of multiple measurements in taxonomic problems*. He was attempting to use the petal and sepal measurements to discriminate one species from another.

**ggplot2** is part of the tidyverse package so we need to load that first:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># this assumes you've already installed tidyverse</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>

<span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching packages</span><span> ─────────────────────────────────────── tidyverse 1.3.0 ──</span></span>

<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>ggplot2</span><span> 3.3.2     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>purrr  </span><span> 0.3.4</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>tibble </span><span> 3.0.4     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>dplyr  </span><span> 0.8.5</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>tidyr  </span><span> 1.0.3     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>stringr</span><span> 1.4.0</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>readr  </span><span> 1.3.1     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>forcats</span><span> 0.5.0</span></span>

<span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span><span> ────────────────────────────────────────── tidyverse_conflicts() ──</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>filter()</span><span> masks </span><span style='color: #0000BB;'>stats</span><span>::filter()</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>lag()</span><span>    masks </span><span style='color: #0000BB;'>stats</span><span>::lag()</span></span>
</code></pre>

</div>

And recall that the **iris** dataset (3 species, 50 observations per species) is automatically available to us:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>iris</span><span class='o'>)</span>

<span class='c'>#&gt;   Sepal.Length Sepal.Width Petal.Length Petal.Width Species</span>
<span class='c'>#&gt; 1          5.1         3.5          1.4         0.2  setosa</span>
<span class='c'>#&gt; 2          4.9         3.0          1.4         0.2  setosa</span>
<span class='c'>#&gt; 3          4.7         3.2          1.3         0.2  setosa</span>
<span class='c'>#&gt; 4          4.6         3.1          1.5         0.2  setosa</span>
<span class='c'>#&gt; 5          5.0         3.6          1.4         0.2  setosa</span>
<span class='c'>#&gt; 6          5.4         3.9          1.7         0.4  setosa</span>
</code></pre>

</div>

What is the correlation between petal length and width in these species? Are longer petals also wider? We can visualize this with a scatterplot. But first let's look a the ggplot template:

    ggplot(data = <DATA>) + 
      <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

These are the obligatory parts of any plot. The first argument to `ggplot` is the data frame:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>iris</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-3-1.png" width="700px" style="display: block; margin: auto;" />

</div>

This is not very interesting! but it's notable that it is *something*. `ggplot()` has created a base coordinate system (a base layer) that we can add visual layers to. The *add a layer* operator is "**+**", which is the ggplot equivalent of the pipe symbol, and **it must occur at the end of the line**.

The next argument specifies the kind plot we want: scatterplot, bar chart, fitted line, boxplot, pie chart, etc. **ggplot2** refers to these as **geoms**: the geometrical object that a plot uses to represent data. You can see an overview of many of these geoms in the [cheat sheet](https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf). The geom for a scatterplot is `geom_point()`.

But we also require a `mapping` argument, which maps the *variables* in the dataset we want to focus on to their *visual representation* in the plot.

And finally we need to specify an **aesthetic** for the geometric objects in the plot, which will control things like shape, color, transparency, etc. Perhaps surprisingly, for a scatterplot, the x and y coordinates are aesthetics, since these control, not the shape or color, but the relative position of the points in the coordinate system.

Here is our complete plot:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>iris</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>Petal.Length</span>, y <span class='o'>=</span> <span class='nv'>Petal.Width</span><span class='o'>)</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-4-1.png" width="700px" style="display: block; margin: auto;" />

</div>

There is clearly a positive correlation between length and width. And we can make this even more apparent by visually fitting a line to the data, by *overlaying* another geom in the same plot.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>iris</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>Petal.Length</span>, y <span class='o'>=</span> <span class='nv'>Petal.Width</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_smooth</span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>Petal.Length</span>, y <span class='o'>=</span> <span class='nv'>Petal.Width</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using method = 'loess' and formula 'y ~ x'</span>

</code></pre>
<img src="figs/unnamed-chunk-5-1.png" width="700px" style="display: block; margin: auto;" />

</div>

There is clearly some code redundancy here, and we here we really don't want the mapping of these two layers to be independent. We can extract the common mapping information and move it to the top level:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>iris</span>, <span class='o'>(</span><span class='nv'>mapping</span> <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>Petal.Length</span>, y <span class='o'>=</span> <span class='nv'>Petal.Width</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_smooth</span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using method = 'loess' and formula 'y ~ x'</span>

</code></pre>
<img src="figs/unnamed-chunk-6-1.png" width="700px" style="display: block; margin: auto;" />

</div>

So we have the possibility of *local* layer specifications, and *global* specifications. Global specifications are *inherited* by all the local layers.

### The power of aesthetics

The aim of Fisher's paper was to try to discriminate different species based on their morphological measurements. It looks from this plot that there are two distinct clusters. Do these clusters correspond to different species? There are two clusters, but three species. How can we explore this further?

Our current plot uses two numeric variables: `Petal.Length` and `Petal.width`. We can add a third categorical variable, like `Species`, to a two dimensional scatterplot by mapping it to a different visual aesthetic. We've mapped length and width to x,y coordinates. Now we'll simultaneously map species to `color` by expanding our list of aesthetics:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>iris</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='o'>(</span><span class='nv'>mapping</span> <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>Petal.Length</span>, y <span class='o'>=</span> <span class='nv'>Petal.Width</span>, color <span class='o'>=</span> <span class='nv'>Species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-7-1.png" width="700px" style="display: block; margin: auto;" />

</div>

## Breakout Rooms

In the exercises we'll be looking a little more at the **iris** data, and in addition, the NHANES data we used last week, and the left-joined bird dataset we built last week in **Excercise 7**.

If you haven't installed the NHANES dataset do:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"NHANES"</span>, repos <span class='o'>=</span> <span class='s'>"http://cran.us.r-project.org"</span><span class='o'>)</span>

<span class='c'>#&gt; </span>
<span class='c'>#&gt; The downloaded binary packages are in</span>
<span class='c'>#&gt;   /var/folders/d4/h4yjqs1560zbsgvrrwbmbp5r0000gn/T//RtmpAoycXA/downloaded_packages</span>
</code></pre>

</div>

Once installed, load it with:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'>NHANES</span><span class='o'>)</span>
</code></pre>

</div>

A prebuilt joined data set has been loaded on github.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># create a data directory for the new file if you haven't done so yet:</span>
<span class='c'>#dir.create('data/birds', recursive = TRUE)</span>

<span class='c'># set the url</span>
<span class='c'>#joined_data_url &lt;- 'https://raw.githubusercontent.com/biodash/biodash.github.io/master/content/codeclub/04_ggplot2/joined_data.tsv'</span>

<span class='c'># set the path for the downloaded file</span>
<span class='c'>#joined_file &lt;- 'data/birds/joined_data.tsv'</span>

<span class='c'>#download to file</span>
<span class='c'>#download.file(url = joined_data_url, destfile = joined_file)</span>

<span class='c'># read file</span>
<span class='c'>#$joined_data &lt;- read_tsv(joined_file)</span>

<span class='nv'>joined_data</span> <span class='o'>&lt;-</span> <span class='nf'>read_tsv</span><span class='o'>(</span><span class='s'>'joined_data.tsv'</span><span class='o'>)</span>

<span class='c'>#&gt; Parsed with column specification:</span>
<span class='c'>#&gt; cols(</span>
<span class='c'>#&gt;   species = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   locality = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   stateProvince = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   eventDate = <span style='color: #0000BB;'>col_datetime(format = "")</span><span>,</span></span>
<span class='c'>#&gt;   species_en = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   adult_body_mass_g = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   adult_svl_cm = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   longevity_y = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   litter_or_clutch_size_n = <span style='color: #00BB00;'>col_double()</span></span>
<span class='c'>#&gt; )</span>
</code></pre>

</div>

## Exercise 1

<div class="puzzle">

Revisit the **iris** data set, and plot sepal width against sepal length colored by species. Which morphological character, petals or sepals, provides the greatest discrimination between species?

<details>
<summary>
Hints (click here)
</summary>
Simply reuse the code we used for petals. You can often leverage code from an old plot for a new one. <br>
</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>iris</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='o'>(</span><span class='nv'>mapping</span> <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>Sepal.Length</span>, y <span class='o'>=</span> <span class='nv'>Sepal.Width</span>, color <span class='o'>=</span> <span class='nv'>Species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-11-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Note this solution shows yet another way to position global mapping information: as its own layer. This can help readability and avoid too many nested parentheses.
</details>

</div>

------------------------------------------------------------------------

## Exercise 2

<div class="puzzle">

Use the NHANES data set to plot body mass index against height. Color by gender. Which gender has the highest BMI?

<details>
<summary>
Hints (click here)
</summary>
glimpse() the dataset to identify the variable names. <br>
</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>NHANES</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>Height</span>, y <span class='o'>=</span> <span class='nv'>BMI</span>, color <span class='o'>=</span> <span class='nv'>Gender</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; Warning: Removed 366 rows containing missing values (geom_point).</span>

</code></pre>
<img src="figs/unnamed-chunk-12-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

------------------------------------------------------------------------

## Exercise 3

<div class="puzzle">

Use the same plot but now color by physical activity. How active are those people with the highest BMI?

<details>
<summary>
Hints (click here)
</summary>
Again, glimpse() the dataset to identify the variable names. <br>
</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>NHANES</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>Height</span>, y <span class='o'>=</span> <span class='nv'>BMI</span>, color <span class='o'>=</span> <span class='nv'>PhysActive</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; Warning: Removed 366 rows containing missing values (geom_point).</span>

</code></pre>
<img src="figs/unnamed-chunk-13-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

------------------------------------------------------------------------

## Exercise 4

<div class="puzzle">

Often plotting the data allows us to identify outliers, which may be data-entry errors, or genuinely extreme data. Using the `joined_data` set, plot adult body mass against longevity. Identify extreme data points at the high end of both scales. How can we identify what these points represent?

<details>
<summary>
Hints (click here)
</summary>
Examine the plot to find an appropriate threshold value, and filter the data using that value. How many data points are there passing that threshold? What species are represented by these data points? How many weights are reported? Why is the plot misleading here? <br>
</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>joined_data</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>longevity_y</span>, y <span class='o'>=</span> <span class='nv'>adult_body_mass_g</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; Warning: Removed 24089 rows containing missing values (geom_point).</span>

</code></pre>
<img src="figs/unnamed-chunk-14-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>joined_data</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>adult_body_mass_g</span> <span class='o'>&gt;</span> <span class='m'>10000</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 228 x 9</span></span>
<span class='c'>#&gt;    species locality stateProvince eventDate           species_en</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>    </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>         </span><span style='color: #555555;font-style: italic;'>&lt;dttm&gt;</span><span>              </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> Cygnus… Findlay  Ohio          2008-02-17 </span><span style='color: #555555;'>00:00:00</span><span> Mute Swan </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> Cygnus… Dundee   Ohio          2004-02-16 </span><span style='color: #555555;'>00:00:00</span><span> Mute Swan </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> Cygnus… 44805 A… Ohio          2006-02-18 </span><span style='color: #555555;'>00:00:00</span><span> Mute Swan </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> Cygnus… 45011 H… Ohio          2005-02-19 </span><span style='color: #555555;'>00:00:00</span><span> Mute Swan </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> Cygnus… 45042 M… Ohio          2009-02-13 </span><span style='color: #555555;'>00:00:00</span><span> Trumpeter…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> Cygnus… 44813 B… Ohio          2007-02-19 </span><span style='color: #555555;'>00:00:00</span><span> Mute Swan </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> Cygnus… Spencer  Ohio          2008-02-16 </span><span style='color: #555555;'>00:00:00</span><span> Mute Swan </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> Cygnus… 44903 M… Ohio          2009-02-16 </span><span style='color: #555555;'>00:00:00</span><span> Mute Swan </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> Cygnus… 44601 A… Ohio          2002-02-16 </span><span style='color: #555555;'>00:00:00</span><span> Mute Swan </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> Cygnus… Avon La… Ohio          2007-02-17 </span><span style='color: #555555;'>00:00:00</span><span> Mute Swan </span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 218 more rows, and 4 more variables: adult_body_mass_g </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   adult_svl_cm </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, longevity_y </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, litter_or_clutch_size_n </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>joined_data</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>adult_body_mass_g</span> <span class='o'>&gt;</span> <span class='m'>10000</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>distinct</span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 2 x 1</span></span>
<span class='c'>#&gt;   species          </span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>            </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Cygnus olor      </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Cygnus buccinator</span></span>
</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>joined_data</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>adult_body_mass_g</span> <span class='o'>&gt;</span> <span class='m'>10000</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>adult_body_mass_g</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>distinct</span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 2 x 1</span></span>
<span class='c'>#&gt;   adult_body_mass_g</span>
<span class='c'>#&gt;               <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span>             </span><span style='text-decoration: underline;'>10</span><span>230</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span>             </span><span style='text-decoration: underline;'>10</span><span>300</span></span>
</code></pre>

</div>

</details>

</div>

## Bonus, a new geom!

<div class="puzzle">

Revisit the **iris** data and generate a density histogram for sepal length, categorized by species.

<details>
<summary>
Hints (click here)
</summary>
Use geom_density(). Check the help to see what aesthetics it supports. <br>
</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>iris</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='o'>(</span><span class='nv'>mapping</span> <span class='o'>=</span> <span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>Sepal.Length</span>, fill <span class='o'>=</span> <span class='nv'>Species</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_density</span><span class='o'>(</span>alpha <span class='o'>=</span> <span class='m'>0.5</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-18-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Note, what does the **alpha** aesthetic control? <br>

</details>

</div>

------------------------------------------------------------------------

<br> <br> <br> <br>

