---
title: "Session 8: Reshaping Your Data"
subtitle: "Using pivot functions from the tidyverse to change the shape of your data."
summary: "In this session of Code Club, we'll consider the shape of our datasets and practice with the *tidyr* functions `pivot_longer()` and `pivot_wider()`, which allow us to reformat, or reshape our data - going from a longer form to a wider form, or vice versa."  
authors: [mike-sovic]
date: "2021-02-02"
output: hugodown::md_document
toc: true

image: 
  caption: "Image by Manny Gimond http://mgimond.github.io/"
  focal_point: ""
  preview_only: false

rmd_hash: 254518aa3afac37d

---

------------------------------------------------------------------------

## Session Goals

-   Describe differences in long data vs wide data.
-   Identify scenarios where it might be helpful to have data in one format over another (longer vs. wider).
-   Use the functions pivot_longer() and pivot_wider() to reshape data.
-   Use NHANES data to address whether blood pressure values vary in a predictable way with successive measurements.

------------------------------------------------------------------------

## Intro: The Shape Of A Dataset

A single set of data can somtimes be stored in different ways, or in other words, it can have different shapes. Below is a small example. It's a hypothetical dataset that stores the number of visitors at each of two parks over a long weekend, and we'll look at two different versions of it...

### Wide Format

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#create the dataset</span>
<span class='nv'>visitors_wide</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/data.frame.html'>data.frame</a></span><span class='o'>(</span><span class='s'>"park"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"north_park"</span>, <span class='s'>"south_park"</span><span class='o'>)</span>, 
                   <span class='s'>"Fri"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>65</span>, <span class='m'>80</span><span class='o'>)</span>,
                   <span class='s'>"Sat"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>184</span>, <span class='m'>160</span><span class='o'>)</span>,
                   <span class='s'>"Sun"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>135</span>, <span class='m'>140</span><span class='o'>)</span>,
                   <span class='s'>"Mon"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>87</span>, <span class='m'>71</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#view the dataset</span>
<span class='nv'>visitors_wide</span>

<span class='c'>#&gt;         park Fri Sat Sun Mon</span>
<span class='c'>#&gt; 1 north_park  65 184 135  87</span>
<span class='c'>#&gt; 2 south_park  80 160 140  71</span>
</code></pre>

</div>

### Long Format

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#create the dataset</span>
<span class='nv'>visitors_long</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/data.frame.html'>data.frame</a></span><span class='o'>(</span><span class='s'>"park"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/rep.html'>rep</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"north_park"</span>, <span class='s'>"south_park"</span><span class='o'>)</span>, <span class='m'>4</span><span class='o'>)</span>, 
                   <span class='s'>"day"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"Fri"</span>,<span class='s'>"Fri"</span>,<span class='s'>"Sat"</span>,<span class='s'>"Sat"</span>,<span class='s'>"Sun"</span>,<span class='s'>"Sun"</span>,<span class='s'>"Mon"</span>,<span class='s'>"Mon"</span><span class='o'>)</span>,
                   <span class='s'>"visitors"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>65</span>,<span class='m'>80</span>,<span class='m'>184</span>,<span class='m'>160</span>,<span class='m'>135</span>,<span class='m'>140</span>,<span class='m'>87</span>,<span class='m'>71</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#view the dataset</span>
<span class='nv'>visitors_long</span>

<span class='c'>#&gt;         park day visitors</span>
<span class='c'>#&gt; 1 north_park Fri       65</span>
<span class='c'>#&gt; 2 south_park Fri       80</span>
<span class='c'>#&gt; 3 north_park Sat      184</span>
<span class='c'>#&gt; 4 south_park Sat      160</span>
<span class='c'>#&gt; 5 north_park Sun      135</span>
<span class='c'>#&gt; 6 south_park Sun      140</span>
<span class='c'>#&gt; 7 north_park Mon       87</span>
<span class='c'>#&gt; 8 south_park Mon       71</span>
</code></pre>

</div>

Notice that both datasets store the same information - it's just formatted differently. These two datasets can be said to have different shapes. The first has a wider shape - it has more columns, stretching it out from left to right. The second has a longer shape, as it has fewer columns and more rows. Again, importantly, **both datasets store the same information**.

## What Shape Should Your Data Be In?

The best answer to the question of what shape your data *should* be in is probably something like 'Whatever shape makes it easiest to accomplish your goals with the data at any given time'. For example, sometimes when you're entering data - say in to a spreadsheet in Excel or a similar program, you might find the data entry process easier if the dataset is in a wider format. Alternatively, if you're trying to generate plots from the data, longer formats are often better. This means that as you work with your data, you might find it helpful or even necessary to reshape the data - possibly multiple times as you continue to work with the same dataset.

## How To Reshape Data

R offers several approaches for reshaping data. Functions for doing so often come in pairs that transform from wider to longer, and longer to wider, respectively. Pairs of functions include `cast()` and `melt()`, `spread()` and `gather()`, and `pivot_longer()` and `pivot_wider()`. While any of these can be used, we'll focus on the 'pivot' pair, as they were written most recently with a goal of being the most user-friendly of the available functions so far.

## Pivoting Resources

If you want to dig in to pivoting a bit more, R offers a very useful [vignette on pivoting](https://tidyr.tidyverse.org/articles/pivot.html), which is worth a look - portions of today's breakout sessions will come from there. [Chapter 12 of "R For Data Science"](https://r4ds.had.co.nz/tidy-data.html) by Wickham and Grolemund, which covers tidy data, also includes a nice section on pivoting.

<br>

------------------------------------------------------------------------

## Examples

Let's revisit the park visitors dataset for an example of how `pivot_longer()` and `pivot_wider()` work in their most basic form. Previously, I created each of the wide and long forms of this dataset by hand. It was manageable to do that, since it's a very small dataset, but for most datasets, you're not going to want to just recreate a data frame from scratch each time you need to reshape the data. Let's start with the data in wide format...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#view the data frame</span>
<span class='nv'>visitors_wide</span>

<span class='c'>#&gt;         park Fri Sat Sun Mon</span>
<span class='c'>#&gt; 1 north_park  65 184 135  87</span>
<span class='c'>#&gt; 2 south_park  80 160 140  71</span>
</code></pre>

</div>

What if we wanted to plot the total mean number of visitors per day across both parks? To get the mean values, we might think about applying some of the functions we've been working with in previous sessions like `group_by()` and `summarize()`. For example, we might want to try grouping by *day* and then calculating the means from a column that stores the number of *visitors*. However, in it's current wide form, this dataset doesn't have the *day* and *visitors* columns we need. `pivot_longer()` can help us here. The command might look like this...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
<span class='nv'>visitors_longer</span> <span class='o'>&lt;-</span> <span class='nv'>visitors_wide</span> <span class='o'>%&gt;%</span> <span class='nf'>pivot_longer</span><span class='o'>(</span><span class='o'>-</span><span class='nv'>park</span>, 
                                                  names_to <span class='o'>=</span> <span class='s'>"day"</span>,
                                                  values_to <span class='o'>=</span> <span class='s'>"visitors"</span><span class='o'>)</span>
</code></pre>

</div>

First, we need to point it to the dataset we're interested in reshaping - I'm doing that by piping the `visitors_wide` data frame to `pivot_longer()`. Next, we need to specify what columns to use to lengthen the dataset. This argument recognizes *tidy-select* notation, which can really simplify things. Here, I'm using `-park`, which tells it to use all the column names except *park*. Those column names will be transformed to values in a single new column, which needs a name. We'll call it *day*, so `names_to = "day"`. Finally, the values in the current columns will be stacked in to a single column, and it too needs a name, so `values_to = "visitors"`. This lengthens the dataset, taking it from 5 columns down to 3.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#view the data</span>
<span class='nv'>visitors_longer</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 8 x 3</span></span>
<span class='c'>#&gt;   park       day   visitors</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>      </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>    </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> north_park Fri         65</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> north_park Sat        184</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> north_park Sun        135</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> north_park Mon         87</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> south_park Fri         80</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> south_park Sat        160</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>7</span><span> south_park Sun        140</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>8</span><span> south_park Mon         71</span></span>
</code></pre>

</div>

In this longer format, we're able to apply the `group_by()` and `summarize()` functions...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>visitors_longer</span> <span class='o'>%&gt;%</span> <span class='nf'>group_by</span><span class='o'>(</span><span class='nv'>day</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
                    <span class='nf'>summarise</span><span class='o'>(</span><span class='s'>"mean"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>visitors</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; `summarise()` ungrouping output (override with `.groups` argument)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 4 x 2</span></span>
<span class='c'>#&gt;   day    mean</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Fri    72.5</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Mon    79  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Sat   172  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Sun   138.</span></span>
</code></pre>

</div>

And we can go in the opposite direction with `pivot_wider()`...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>visitors_longer</span> <span class='o'>%&gt;%</span> <span class='nf'>pivot_wider</span><span class='o'>(</span>names_from <span class='o'>=</span> <span class='nv'>day</span>, 
                                values_from <span class='o'>=</span> <span class='nv'>visitors</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 2 x 5</span></span>
<span class='c'>#&gt;   park         Fri   Sat   Sun   Mon</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>      </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> north_park    65   184   135    87</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> south_park    80   160   140    71</span></span>
</code></pre>

</div>

The examples above represent the most basic uses of `pivot_longer()` and `pivot_wider()`. But each of these functions offer additional arguments that can help deal with more complicated situations. The next example is from the [pivoting vignette](https://tidyr.tidyverse.org/articles/pivot.html) I referenced above. It uses the billboard dataset that should already be available in your R session, and that stores weekly rankings of Billboard top 100 songs from the year 2000.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#preview billboard data</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>billboard</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 79</span></span>
<span class='c'>#&gt;   artist track date.entered   wk1   wk2   wk3   wk4   wk5   wk6   wk7   wk8</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;date&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> 2 Pac  Baby… 2000-02-26      87    82    72    77    87    94    99    </span><span style='color: #BB0000;'>NA</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> 2Ge+h… The … 2000-09-02      91    87    92    </span><span style='color: #BB0000;'>NA</span><span>    </span><span style='color: #BB0000;'>NA</span><span>    </span><span style='color: #BB0000;'>NA</span><span>    </span><span style='color: #BB0000;'>NA</span><span>    </span><span style='color: #BB0000;'>NA</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> 3 Doo… Kryp… 2000-04-08      81    70    68    67    66    57    54    53</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> 3 Doo… Loser 2000-10-21      76    76    72    69    67    65    55    59</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> 504 B… Wobb… 2000-04-15      57    34    25    17    17    31    36    49</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> 98^0   Give… 2000-08-19      51    39    34    26    26    19     2     2</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 68 more variables: wk9 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk10 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk11 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk12 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   wk13 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk14 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk15 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk16 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk17 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk18 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   wk19 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk20 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk21 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk22 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk23 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk24 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   wk25 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk26 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk27 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk28 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk29 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk30 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   wk31 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk32 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk33 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk34 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk35 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk36 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   wk37 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk38 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk39 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk40 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk41 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk42 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   wk43 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk44 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk45 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk46 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk47 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk48 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   wk49 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk50 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk51 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk52 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk53 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk54 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   wk55 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk56 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk57 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk58 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk59 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk60 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   wk61 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk62 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk63 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk64 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk65 </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span style='color: #555555;'>, wk66 </span><span style='color: #555555;font-style: italic;'>&lt;lgl&gt;</span><span style='color: #555555;'>,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   wk67 </span><span style='color: #555555;font-style: italic;'>&lt;lgl&gt;</span><span style='color: #555555;'>, wk68 </span><span style='color: #555555;font-style: italic;'>&lt;lgl&gt;</span><span style='color: #555555;'>, wk69 </span><span style='color: #555555;font-style: italic;'>&lt;lgl&gt;</span><span style='color: #555555;'>, wk70 </span><span style='color: #555555;font-style: italic;'>&lt;lgl&gt;</span><span style='color: #555555;'>, wk71 </span><span style='color: #555555;font-style: italic;'>&lt;lgl&gt;</span><span style='color: #555555;'>, wk72 </span><span style='color: #555555;font-style: italic;'>&lt;lgl&gt;</span><span style='color: #555555;'>,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   wk73 </span><span style='color: #555555;font-style: italic;'>&lt;lgl&gt;</span><span style='color: #555555;'>, wk74 </span><span style='color: #555555;font-style: italic;'>&lt;lgl&gt;</span><span style='color: #555555;'>, wk75 </span><span style='color: #555555;font-style: italic;'>&lt;lgl&gt;</span><span style='color: #555555;'>, wk76 </span><span style='color: #555555;font-style: italic;'>&lt;lgl&gt;</span></span>
</code></pre>

</div>

Notice there are columns named 'wk1' through 'wk73' that store the weekly ranking for each song. Week itself is a variable with values that could be represented in a single column. We could do something similar to our above use of `pivot_longer()`...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>billboard</span> <span class='o'>%&gt;%</span> <span class='nf'>pivot_longer</span><span class='o'>(</span>cols <span class='o'>=</span> <span class='nf'>starts_with</span><span class='o'>(</span><span class='s'>"wk"</span><span class='o'>)</span>,
                           names_to <span class='o'>=</span> <span class='s'>"week"</span>,
                           values_to <span class='o'>=</span> <span class='s'>"rank"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
              <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 5</span></span>
<span class='c'>#&gt;   artist track                   date.entered week   rank</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                   </span><span style='color: #555555;font-style: italic;'>&lt;date&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk1      87</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk2      82</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk3      72</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk4      77</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk5      87</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk6      94</span></span>
</code></pre>

</div>

This is a start - we've gone from 79 columns to just 6. But we can clean this up a bit more. Notice the values in the new *week* column all include the 'wk' prefix. Since we've labeled the column 'week', it's kind of redundant and unnecessary to have 'wk' at the beginning of each value. We can add the 'names_prefix' argument, which accepts a regular expression (regex). Characters at the beginning of column names that match the regex get removed.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>billboard</span> <span class='o'>%&gt;%</span> <span class='nf'>pivot_longer</span><span class='o'>(</span>cols <span class='o'>=</span> <span class='nf'>starts_with</span><span class='o'>(</span><span class='s'>"wk"</span><span class='o'>)</span>,
                           names_to <span class='o'>=</span> <span class='s'>"week"</span>,
                           values_to <span class='o'>=</span> <span class='s'>"rank"</span>,
                           names_prefix <span class='o'>=</span> <span class='s'>"wk"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
              <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 5</span></span>
<span class='c'>#&gt;   artist track                   date.entered week   rank</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                   </span><span style='color: #555555;font-style: italic;'>&lt;date&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> 2 Pac  Baby Don't Cry (Keep... 2000-02-26   1        87</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> 2 Pac  Baby Don't Cry (Keep... 2000-02-26   2        82</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> 2 Pac  Baby Don't Cry (Keep... 2000-02-26   3        72</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> 2 Pac  Baby Don't Cry (Keep... 2000-02-26   4        77</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> 2 Pac  Baby Don't Cry (Keep... 2000-02-26   5        87</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> 2 Pac  Baby Don't Cry (Keep... 2000-02-26   6        94</span></span>
</code></pre>

</div>

We haven't dealt with regular expressions in Code Club yet - they'll make a good topic for a future session, but if you're interested in the meantime, I did a couple short videos introducing them as part of [this set of videos on command line computing](https://youtube.com/playlist?list=PLxhIMi78eQeh-1fdS8ta7A29jCIHeZe9Q).

## Breakout Rooms

In the breakout rooms, we'll use a pivot function to analyze a portion of the NHANES dataset. We'll use the data to try to address whether successive blood pressure measurements from the same individual differ in a predictable way.

If you haven't already done it, you can install the NHANES dataset with...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"NHANES"</span>, repos <span class='o'>=</span> <span class='s'>"http://cran.us.r-project.org"</span><span class='o'>)</span>

<span class='c'>#&gt; </span>
<span class='c'>#&gt; The downloaded binary packages are in</span>
<span class='c'>#&gt;   /var/folders/s7/y_mgh3c54h9fjcyw9wqdkb8x4zs_jy/T//RtmpDh1mrD/downloaded_packages</span>
</code></pre>

</div>

### Exercise 1

<div class="alert puzzle">

<div>

First let's load and preview the NHANES dataset.

<details>
<summary>
Hints (click here)
</summary>

<br> Use [`library()`](https://rdrr.io/r/base/library.html) to load the dataset. The functions [`head()`](https://rdrr.io/r/utils/head.html) are `glimpse()` are a couple good options for previewing the data. <br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'>NHANES</span><span class='o'>)</span>
<span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>NHANES</span><span class='o'>)</span>

<span class='c'>#&gt; Rows: 10,000</span>
<span class='c'>#&gt; Columns: 76</span>
<span class='c'>#&gt; $ ID               <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 51624, 51624, 51624, 51625, 51630, 51638, 51646, 516…</span></span>
<span class='c'>#&gt; $ SurveyYr         <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> 2009_10, 2009_10, 2009_10, 2009_10, 2009_10, 2009_10…</span></span>
<span class='c'>#&gt; $ Gender           <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> male, male, male, male, female, male, male, female, …</span></span>
<span class='c'>#&gt; $ Age              <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 34, 34, 34, 4, 49, 9, 8, 45, 45, 45, 66, 58, 54, 10,…</span></span>
<span class='c'>#&gt; $ AgeDecade        <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>  30-39,  30-39,  30-39,  0-9,  40-49,  0-9,  0-9,  4…</span></span>
<span class='c'>#&gt; $ AgeMonths        <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 409, 409, 409, 49, 596, 115, 101, 541, 541, 541, 795…</span></span>
<span class='c'>#&gt; $ Race1            <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> White, White, White, Other, White, White, White, Whi…</span></span>
<span class='c'>#&gt; $ Race3            <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ Education        <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> High School, High School, High School, NA, Some Coll…</span></span>
<span class='c'>#&gt; $ MaritalStatus    <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Married, Married, Married, NA, LivePartner, NA, NA, …</span></span>
<span class='c'>#&gt; $ HHIncome         <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> 25000-34999, 25000-34999, 25000-34999, 20000-24999, …</span></span>
<span class='c'>#&gt; $ HHIncomeMid      <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 30000, 30000, 30000, 22500, 40000, 87500, 60000, 875…</span></span>
<span class='c'>#&gt; $ Poverty          <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 1.36, 1.36, 1.36, 1.07, 1.91, 1.84, 2.33, 5.00, 5.00…</span></span>
<span class='c'>#&gt; $ HomeRooms        <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 6, 6, 6, 9, 5, 6, 7, 6, 6, 6, 5, 10, 6, 10, 10, 4, 3…</span></span>
<span class='c'>#&gt; $ HomeOwn          <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Own, Own, Own, Own, Rent, Rent, Own, Own, Own, Own, …</span></span>
<span class='c'>#&gt; $ Work             <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> NotWorking, NotWorking, NotWorking, NA, NotWorking, …</span></span>
<span class='c'>#&gt; $ Weight           <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 87.4, 87.4, 87.4, 17.0, 86.7, 29.8, 35.2, 75.7, 75.7…</span></span>
<span class='c'>#&gt; $ Length           <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ HeadCirc         <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ Height           <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 164.7, 164.7, 164.7, 105.4, 168.4, 133.1, 130.6, 166…</span></span>
<span class='c'>#&gt; $ BMI              <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 32.22, 32.22, 32.22, 15.30, 30.57, 16.82, 20.64, 27.…</span></span>
<span class='c'>#&gt; $ BMICatUnder20yrs <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ BMI_WHO          <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> 30.0_plus, 30.0_plus, 30.0_plus, 12.0_18.5, 30.0_plu…</span></span>
<span class='c'>#&gt; $ Pulse            <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 70, 70, 70, NA, 86, 82, 72, 62, 62, 62, 60, 62, 76, …</span></span>
<span class='c'>#&gt; $ BPSysAve         <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 113, 113, 113, NA, 112, 86, 107, 118, 118, 118, 111,…</span></span>
<span class='c'>#&gt; $ BPDiaAve         <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 85, 85, 85, NA, 75, 47, 37, 64, 64, 64, 63, 74, 85, …</span></span>
<span class='c'>#&gt; $ BPSys1           <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 114, 114, 114, NA, 118, 84, 114, 106, 106, 106, 124,…</span></span>
<span class='c'>#&gt; $ BPDia1           <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 88, 88, 88, NA, 82, 50, 46, 62, 62, 62, 64, 76, 86, …</span></span>
<span class='c'>#&gt; $ BPSys2           <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 114, 114, 114, NA, 108, 84, 108, 118, 118, 118, 108,…</span></span>
<span class='c'>#&gt; $ BPDia2           <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 88, 88, 88, NA, 74, 50, 36, 68, 68, 68, 62, 72, 88, …</span></span>
<span class='c'>#&gt; $ BPSys3           <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 112, 112, 112, NA, 116, 88, 106, 118, 118, 118, 114,…</span></span>
<span class='c'>#&gt; $ BPDia3           <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 82, 82, 82, NA, 76, 44, 38, 60, 60, 60, 64, 76, 82, …</span></span>
<span class='c'>#&gt; $ Testosterone     <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ DirectChol       <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 1.29, 1.29, 1.29, NA, 1.16, 1.34, 1.55, 2.12, 2.12, …</span></span>
<span class='c'>#&gt; $ TotChol          <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 3.49, 3.49, 3.49, NA, 6.70, 4.86, 4.09, 5.82, 5.82, …</span></span>
<span class='c'>#&gt; $ UrineVol1        <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 352, 352, 352, NA, 77, 123, 238, 106, 106, 106, 113,…</span></span>
<span class='c'>#&gt; $ UrineFlow1       <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, NA, NA, NA, 0.094, 1.538, 1.322, 1.116, 1.116, 1…</span></span>
<span class='c'>#&gt; $ UrineVol2        <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ UrineFlow2       <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ Diabetes         <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> No, No, No, No, No, No, No, No, No, No, No, No, No, …</span></span>
<span class='c'>#&gt; $ DiabetesAge      <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ HealthGen        <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Good, Good, Good, NA, Good, NA, NA, Vgood, Vgood, Vg…</span></span>
<span class='c'>#&gt; $ DaysPhysHlthBad  <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 0, 0, 0, NA, 0, NA, NA, 0, 0, 0, 10, 0, 4, NA, NA, 0…</span></span>
<span class='c'>#&gt; $ DaysMentHlthBad  <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 15, 15, 15, NA, 10, NA, NA, 3, 3, 3, 0, 0, 0, NA, NA…</span></span>
<span class='c'>#&gt; $ LittleInterest   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Most, Most, Most, NA, Several, NA, NA, None, None, N…</span></span>
<span class='c'>#&gt; $ Depressed        <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Several, Several, Several, NA, Several, NA, NA, None…</span></span>
<span class='c'>#&gt; $ nPregnancies     <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> NA, NA, NA, NA, 2, NA, NA, 1, 1, 1, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ nBabies          <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> NA, NA, NA, NA, 2, NA, NA, NA, NA, NA, NA, NA, NA, N…</span></span>
<span class='c'>#&gt; $ Age1stBaby       <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> NA, NA, NA, NA, 27, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ SleepHrsNight    <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 4, 4, 4, NA, 8, NA, NA, 8, 8, 8, 7, 5, 4, NA, 5, 7, …</span></span>
<span class='c'>#&gt; $ SleepTrouble     <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Yes, Yes, Yes, NA, Yes, NA, NA, No, No, No, No, No, …</span></span>
<span class='c'>#&gt; $ PhysActive       <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> No, No, No, NA, No, NA, NA, Yes, Yes, Yes, Yes, Yes,…</span></span>
<span class='c'>#&gt; $ PhysActiveDays   <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, 5, 5, 5, 7, 5, 1, NA, 2,…</span></span>
<span class='c'>#&gt; $ TVHrsDay         <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ CompHrsDay       <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ TVHrsDayChild    <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> NA, NA, NA, 4, NA, 5, 1, NA, NA, NA, NA, NA, NA, 4, …</span></span>
<span class='c'>#&gt; $ CompHrsDayChild  <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> NA, NA, NA, 1, NA, 0, 6, NA, NA, NA, NA, NA, NA, 3, …</span></span>
<span class='c'>#&gt; $ Alcohol12PlusYr  <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Yes, Yes, Yes, NA, Yes, NA, NA, Yes, Yes, Yes, Yes, …</span></span>
<span class='c'>#&gt; $ AlcoholDay       <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> NA, NA, NA, NA, 2, NA, NA, 3, 3, 3, 1, 2, 6, NA, NA,…</span></span>
<span class='c'>#&gt; $ AlcoholYear      <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 0, 0, 0, NA, 20, NA, NA, 52, 52, 52, 100, 104, 364, …</span></span>
<span class='c'>#&gt; $ SmokeNow         <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> No, No, No, NA, Yes, NA, NA, NA, NA, NA, No, NA, NA,…</span></span>
<span class='c'>#&gt; $ Smoke100         <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Yes, Yes, Yes, NA, Yes, NA, NA, No, No, No, Yes, No,…</span></span>
<span class='c'>#&gt; $ Smoke100n        <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Smoker, Smoker, Smoker, NA, Smoker, NA, NA, Non-Smok…</span></span>
<span class='c'>#&gt; $ SmokeAge         <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 18, 18, 18, NA, 38, NA, NA, NA, NA, NA, 13, NA, NA, …</span></span>
<span class='c'>#&gt; $ Marijuana        <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Yes, Yes, Yes, NA, Yes, NA, NA, Yes, Yes, Yes, NA, Y…</span></span>
<span class='c'>#&gt; $ AgeFirstMarij    <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 17, 17, 17, NA, 18, NA, NA, 13, 13, 13, NA, 19, 15, …</span></span>
<span class='c'>#&gt; $ RegularMarij     <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> No, No, No, NA, No, NA, NA, No, No, No, NA, Yes, Yes…</span></span>
<span class='c'>#&gt; $ AgeRegMarij      <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 20, 15, …</span></span>
<span class='c'>#&gt; $ HardDrugs        <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Yes, Yes, Yes, NA, Yes, NA, NA, No, No, No, No, Yes,…</span></span>
<span class='c'>#&gt; $ SexEver          <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Yes, Yes, Yes, NA, Yes, NA, NA, Yes, Yes, Yes, Yes, …</span></span>
<span class='c'>#&gt; $ SexAge           <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 16, 16, 16, NA, 12, NA, NA, 13, 13, 13, 17, 22, 12, …</span></span>
<span class='c'>#&gt; $ SexNumPartnLife  <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 8, 8, 8, NA, 10, NA, NA, 20, 20, 20, 15, 7, 100, NA,…</span></span>
<span class='c'>#&gt; $ SexNumPartYear   <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 1, 1, 1, NA, 1, NA, NA, 0, 0, 0, NA, 1, 1, NA, NA, 1…</span></span>
<span class='c'>#&gt; $ SameSex          <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> No, No, No, NA, Yes, NA, NA, Yes, Yes, Yes, No, No, …</span></span>
<span class='c'>#&gt; $ SexOrientation   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Heterosexual, Heterosexual, Heterosexual, NA, Hetero…</span></span>
<span class='c'>#&gt; $ PregnantNow      <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
</code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

### Exercise 2

<div class="alert puzzle">

<div>

As you might know, blood pressure consists of two values - systolic and diastolic. Each participant in the NHANES survey had their blood pressure measured three times in succession, giving us the columns: *BPSys1*, *BPDia1*, *BPSys2*, *BPDia2*, *BPSys3*, *BPDia3*. Let's work first with just the three systolic values.

Subset the dataset to get just the columns *BPSys1*, *BPSys2*, and *BPSys3*. Name the new object 'sys_values', then get the dimensions of *sys_values* and preview it.

<details>
<summary>
Hints (click here)
</summary>

<br> Use `select()` from *dplyr* to get the three columns we want. [`dim()`](https://rdrr.io/r/base/dim.html) and `glimpse()` can be used to get the dimensions and preview the data, respectively. <br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>sys_values</span> <span class='o'>&lt;-</span> <span class='nv'>NHANES</span> <span class='o'>%&gt;%</span> <span class='nf'>select</span><span class='o'>(</span><span class='nf'>matches</span><span class='o'>(</span><span class='s'>"BPSys[123]$"</span><span class='o'>)</span><span class='o'>)</span>
<span class='c'>#I used the 'matches' helper along with a regular expression </span>
<span class='c'>#above, but there are a number of ways you could do this. </span>
<span class='c'>#One equivalent would be...</span>
<span class='c'># sys_values &lt;- NHANES %&gt;% select(BPSys1, BPSys2, BPSys3)</span>

<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>sys_values</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 10000     3</span>


<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>sys_values</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 3</span></span>
<span class='c'>#&gt;   BPSys1 BPSys2 BPSys3</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span>    114    114    112</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span>    114    114    112</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span>    114    114    112</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span>     </span><span style='color: #BB0000;'>NA</span><span>     </span><span style='color: #BB0000;'>NA</span><span>     </span><span style='color: #BB0000;'>NA</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span>    118    108    116</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span>     84     84     88</span></span>
</code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

### Exercise 3

<div class="alert puzzle">

<div>

We can see just from the preview in Exercise 2 that the dataset has some missing data - let's remove rows that have NA's. Call the new dataset 'sys_noNA'. Then check the dimensions and preview again.

<details>
<summary>
Hints (click here)
</summary>

<br> Try the `drop_na` function from *tidyr* to eliminate rows containing missing data. <br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>sys_noNA</span> <span class='o'>&lt;-</span> <span class='nv'>sys_values</span> <span class='o'>%&gt;%</span> <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>sys_noNA</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 7971    3</span>

<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>sys_noNA</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 3</span></span>
<span class='c'>#&gt;   BPSys1 BPSys2 BPSys3</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span>    114    114    112</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span>    114    114    112</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span>    114    114    112</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span>    118    108    116</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span>     84     84     88</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span>    114    108    106</span></span>
</code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

### Exercise 4

<div class="alert puzzle">

<div>

We'll explore these data a bit to see if there's any evidence of a trend in systolic blood pressure with respect to the sequence of measurements (differences among measurements 1, 2, and 3). First, lets reshape the data so we end up with just two columns named 'measurement' and 'sys_bp'. Save the new objects as 'sys_long'. Then check the dimensions and preview again.

<details>
<summary>
Hints (click here)
</summary>

<br> Use `pivot_longer()` to lengthen the dataset. You'll need to include the arguments "cols", "names_to", and "values_to". <br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>sys_long</span> <span class='o'>&lt;-</span> <span class='nv'>sys_noNA</span> <span class='o'>%&gt;%</span> <span class='nf'>pivot_longer</span><span class='o'>(</span>cols <span class='o'>=</span> <span class='nf'>starts_with</span><span class='o'>(</span><span class='s'>"BP"</span><span class='o'>)</span>,
                                      names_to <span class='o'>=</span> <span class='s'>"measurement"</span>,
                                      values_to <span class='o'>=</span> <span class='s'>"sys_bp"</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>sys_long</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 23913     2</span>


<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>sys_long</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 2</span></span>
<span class='c'>#&gt;   measurement sys_bp</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>        </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> BPSys1         114</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> BPSys2         114</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> BPSys3         112</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> BPSys1         114</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> BPSys2         114</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> BPSys3         112</span></span>
</code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

### Exercise 5

<div class="alert puzzle">

<div>

Now let's calculate and compare the mean values for each measurement.

<details>
<summary>
Hints (click here)
</summary>

<br> Use `group_by()` and `summarize()` to get a mean for each of the three measurements. <br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>sys_long</span> <span class='o'>%&gt;%</span> <span class='nf'>group_by</span><span class='o'>(</span><span class='nv'>measurement</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
             <span class='nf'>summarize</span><span class='o'>(</span><span class='s'>"mean_sys"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>sys_bp</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; `summarise()` ungrouping output (override with `.groups` argument)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 x 2</span></span>
<span class='c'>#&gt;   measurement mean_sys</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>          </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> BPSys1          119.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> BPSys2          118.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> BPSys3          118.</span></span>
</code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

### Exercise 6

<div class="alert puzzle">

<div>

The `summarise()` functions outputs a tibble. Tibbles are intended to be tidy, and as part of that, they tend to truncate/round numbers to a greater degree than they would be otherwise in R. In this case, we might want a bit more precision in the values. Repeat the above, but convert the tibble containing the means to a data frame, which will by default likely show more significant digits.

<details>
<summary>
Hints (click here)
</summary>

<br> Use the [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html) function to convert the tibble to a data frame. <br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>sys_long</span> <span class='o'>%&gt;%</span> <span class='nf'>group_by</span><span class='o'>(</span><span class='nv'>measurement</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
             <span class='nf'>summarize</span><span class='o'>(</span><span class='s'>"mean_sys"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>sys_bp</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
             <span class='nf'><a href='https://rdrr.io/r/base/as.data.frame.html'>as.data.frame</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#&gt; `summarise()` ungrouping output (override with `.groups` argument)</span>

<span class='c'>#&gt;   measurement mean_sys</span>
<span class='c'>#&gt; 1      BPSys1 119.1682</span>
<span class='c'>#&gt; 2      BPSys2 118.4333</span>
<span class='c'>#&gt; 3      BPSys3 117.8479</span>
</code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

<br>

### Bonus 1

<div class="alert puzzle">

<div>

Are those differences statistically significant? A one-way anova might be a good option to test that. Check out the help page for the function [`aov()`](https://rdrr.io/r/stats/aov.html) and try running an ANOVA.

<details>
<summary>
Hint 1 (click here)
</summary>

<br> R often uses the tilde (\~) to indicate formula notation. So, for example, you can generate a scatterplot in base R by plotting y\~x, assuming y and x are numeric vectors of equal lengths. The [`aov()`](https://rdrr.io/r/stats/aov.html) function requires a formula with the pattern values\~group. You can use the column names in the data frame to define these, but then you need to use the 'data' argument to tell the function the name of the data frame where those columns exist. <br>

</details>
<details>
<summary>
Hint 2 (click here)
</summary>

<br> Once you get the [`aov()`](https://rdrr.io/r/stats/aov.html) function to work, you can get a p-value with the `summary` function. See info under the "Value" heading on the help page for [`aov()`](https://rdrr.io/r/stats/aov.html). <br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/stats/aov.html'>aov</a></span><span class='o'>(</span><span class='nv'>sys_bp</span><span class='o'>~</span><span class='nv'>measurement</span>, data <span class='o'>=</span> <span class='nv'>sys_long</span><span class='o'>)</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/base/summary.html'>summary</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#&gt;                Df  Sum Sq Mean Sq F value   Pr(&gt;F)    </span>
<span class='c'>#&gt; measurement     2    6977    3489   11.87 7.05e-06 ***</span>
<span class='c'>#&gt; Residuals   23910 7028228     294                     </span>
<span class='c'>#&gt; ---</span>
<span class='c'>#&gt; Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1</span>
</code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

### Bonus 2

<div class="alert puzzle">

<div>

Repeat all of the above for diastolic blood pressure with a couple of modifications along the way. First, when you reshape/lengthen the data, make the values in the 'measurement' column numeric. For example, in the *sys_long* data frame we created above, the values in the measurement column were characters, and looked like "BPsys1". This time, make them a factor with the levels "1", "2", and "3".

<details>
<summary>
Hint (click here)
</summary>

<br> Use the `pivot_longer()` arguments "names_prefix" and "names_transform". <br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>dia_data</span> <span class='o'>&lt;-</span> <span class='nv'>NHANES</span> <span class='o'>%&gt;%</span> <span class='nf'>select</span><span class='o'>(</span><span class='nf'>matches</span><span class='o'>(</span><span class='s'>"BPDia[123]$"</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
            <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
            <span class='nf'>pivot_longer</span><span class='o'>(</span>cols <span class='o'>=</span> <span class='nf'>starts_with</span><span class='o'>(</span><span class='s'>"BP"</span><span class='o'>)</span>,
                         names_to <span class='o'>=</span> <span class='s'>"measurement"</span>,
                         values_to <span class='o'>=</span> <span class='s'>"dia_bp"</span>,
                         names_prefix <span class='o'>=</span> <span class='s'>"BPDia"</span>,
                         names_transform <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span>measurement <span class='o'>=</span> <span class='s'>"as.factor"</span><span class='o'>)</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>dia_data</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 2</span></span>
<span class='c'>#&gt;   measurement dia_bp</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>        </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> 1               88</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> 2               88</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> 3               82</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> 1               88</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> 2               88</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> 3               82</span></span>


<span class='nv'>dia_data</span> <span class='o'>%&gt;%</span> <span class='nf'>group_by</span><span class='o'>(</span><span class='nv'>measurement</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
             <span class='nf'>summarize</span><span class='o'>(</span><span class='s'>"mean_dia"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>dia_bp</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
             <span class='nf'><a href='https://rdrr.io/r/base/as.data.frame.html'>as.data.frame</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#&gt; `summarise()` ungrouping output (override with `.groups` argument)</span>

<span class='c'>#&gt;   measurement mean_dia</span>
<span class='c'>#&gt; 1           1 68.28830</span>
<span class='c'>#&gt; 2           2 67.46280</span>
<span class='c'>#&gt; 3           3 67.06762</span>


<span class='nf'><a href='https://rdrr.io/r/stats/aov.html'>aov</a></span><span class='o'>(</span><span class='nv'>dia_bp</span><span class='o'>~</span><span class='nv'>measurement</span>, data <span class='o'>=</span> <span class='nv'>dia_data</span><span class='o'>)</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/base/summary.html'>summary</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#&gt;                Df  Sum Sq Mean Sq F value   Pr(&gt;F)    </span>
<span class='c'>#&gt; measurement     2    6185  3092.3   14.91 3.38e-07 ***</span>
<span class='c'>#&gt; Residuals   23910 4958916   207.4                     </span>
<span class='c'>#&gt; ---</span>
<span class='c'>#&gt; Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1</span>
</code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

