---
title: "Code Club S02E08: Combining Plots"
summary: "Now that we've gotten a feel for creating plots, we'll look at how they can be arranged to include multiple plots in a single figure."  
authors: [mike-sovic]
date: "2021-10-19"
output: hugodown::md_document
toc: true
rmd_hash: 46e5ddfd42d51b83

---

<br>

## Learning objectives

> -   Continue to practice creating plots with ggplot
> -   Use faceting to divide a plot into multiple panels according to some variable.
> -   Arrange multiple plots of different types on a single figure.

<br>

------------------------------------------------------------------------

## 1 -- Intro

We'll continue with our theme on plotting by exploring some options for arranging multiple plots on a single figure. A couple scenarios where you might want to do this...

1.) You create a plot that needs to be subdivided according to some variable, possibly because accounting for that variable is important for the interpretation, or maybe there's just too much on one plot and it helps to split the data up according to some factor.

2.) You have a series of different plots that all address some related question, maybe each in a slightly different way, and you want to present them all in one figure.

We'll take a couple approaches during this and next week's sessions to deal with these two scenarios. Today we'll look at some *ggplot* functions like `facet_wrap()` and `facet_grid()` that allow us to easily deal with scenario 1. Then in the next session we'll try a separate package, *patchwork*, that offers one good option for scenario 2.

Like in previous sessions, we'll use some packages from the *tidyverse* and also the *palmerpenguins* dataset. If you haven't installed either of those yet, you can do so with the following commands. If you installed them previously, you can just run the latter of the commands ([`library()`](https://rdrr.io/r/base/library.html)) to load them for the current session.

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

## 2 -- Faceting

Let's start by revisiting some plots Michael Broe created in his intro to ggplot a couple sessions ago. He was using the plots to investigate whether a relationship exists between the variables *bill length* and *bill depth* in these penguins. A scatterplot with a line of best fit from *ggplot*...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_smooth</span><span class='o'>(</span>method <span class='o'>=</span> <span class='s'>"lm"</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

<span class='c'>#&gt; Warning: Removed 2 rows containing non-finite values (stat_smooth).</span>

<span class='c'>#&gt; Warning: Removed 2 rows containing missing values (geom_point).</span>

</code></pre>
<img src="figs/unnamed-chunk-4-1.png" width="700px" style="display: block; margin: auto;" />

</div>

As Michael pointed out previously, mapping an additional aesthetic (color) to the variable *species* helps us see a relationship a little more clearly...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span>, color <span class='o'>=</span> <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_smooth</span><span class='o'>(</span>method <span class='o'>=</span> <span class='s'>"lm"</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

<span class='c'>#&gt; Warning: Removed 2 rows containing non-finite values (stat_smooth).</span>

<span class='c'>#&gt; Warning: Removed 2 rows containing missing values (geom_point).</span>

</code></pre>
<img src="figs/unnamed-chunk-5-1.png" width="700px" style="display: block; margin: auto;" />

</div>

The color aesthetic partitions the data according to some variable (in this case, species), and here helps add important information to the visualization. An alternative might be to plot the data in separate panels, with each corresponding to a different species. We can do that with either of two functions from ggplot, `facet_wrap()` or `facet_grid()`. Let's start with `facet_wrap()`. This is added as an additional layer to the plot, and indicates one or more variables that will be used to split the data into separate panels. I'll facet here by species.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_smooth</span><span class='o'>(</span>method <span class='o'>=</span> <span class='s'>"lm"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='s'>"species"</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

<span class='c'>#&gt; Warning: Removed 2 rows containing non-finite values (stat_smooth).</span>

<span class='c'>#&gt; Warning: Removed 2 rows containing missing values (geom_point).</span>

</code></pre>
<img src="figs/unnamed-chunk-6-1.png" width="700px" style="display: block; margin: auto;" />

</div>

The effect here is similar to what we did with adding a color aesthetic to the *species* variable earlier - it allows us to evaluate the relationship between bill length and bill depth for each species separately.

------------------------------------------------------------------------

### Breakout Rooms: Faceting

#### Exercise 1: Analyze Adelie Penguins By Island

<div class="puzzle">

<div>

Try analyzing the relationship between bill length and bill depth for just the Adelie penguins (the only species with observations from each of the three islands). For this species, try faceting by island. Does the relationship seem to be consistent across all islands?

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
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>species</span> <span class='o'>==</span> <span class='s'>"Adelie"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_smooth</span><span class='o'>(</span>method <span class='o'>=</span> <span class='s'>"lm"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='s'>"island"</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing non-finite values (stat_smooth).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

</code></pre>
<img src="figs/unnamed-chunk-7-1.png" width="700px" style="display: block; margin: auto;" />

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
<img src="figs/unnamed-chunk-8-1.png" width="700px" style="display: block; margin: auto;" />

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
<img src="figs/unnamed-chunk-9-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

</div>

#### Exercise 3: Axis Scales

<div class="puzzle">

<div>

Now let's go back to the full dataset where we faceted by species. The code we used (with the `drop_na` function added), along with its associated plot, are below...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_smooth</span><span class='o'>(</span>method <span class='o'>=</span> <span class='s'>"lm"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='s'>"species"</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

</code></pre>
<img src="figs/unnamed-chunk-10-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Use the help page for `facet_wrap` to look in to the *scales* option. Try changing the value of this option to see what effect it has on the plot.

<details>
<summary>
<b>Hint 1</b> (click here)
</summary>

<br> Use `?facet_wrap` to get the help page for the function, and find information about the *scales* option. <br>

</details>
<details>
<summary>
<b>Hint 2</b> (click here)
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
<img src="figs/unnamed-chunk-11-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

</div>

<br>

------------------------------------------------------------------------

In next week's session, we'll use `facet_grid()`, which has some similarities to `facet_wrap()`, and then check out the *patchwork* package, which gives you more control over how multiple plots are combined in a single figure.

