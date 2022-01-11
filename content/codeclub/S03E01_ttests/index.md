---
title: "Code Club S03E01: t-tests In R"
summary: "We'll start off our series on statistical tests by running some basic t-tests, extracting the results, and creating some visualizations."  
authors: [mike-sovic]
date: "2022-01-10"
output: hugodown::md_document
toc: true
rmd_hash: 702ffe7438a6ac51

---

<br>

## Learning objectives

> -   Identify the types of data structures underlying the inputs and outputs of a basic t-test in R, with focus on vectors, lists, and data frames.
> -   Use a helper tidy package (broom) to clean up t-test results.
> -   Create some t-test-related visualizations.
> -   Practice with some basic tidyverse/dplyr functions (select, filter)

<br>

------------------------------------------------------------------------

## 1 -- Intro

Starting today, the upcoming block of Code Club sessions will center around performing some common statistical tests in R. We don't plan to dive in to a lot of statistical details, but will instead focus on practical aspects of running the tests/analyses. We'll pay particular attention to things like the types/classes of data that need to go in to each test, the structure of the results that come out, and since R is so good with visualization, we'll probably do a fair amount of plotting along the way too. Let's go ahead and load the tidyverse before we get started...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
</code></pre>

</div>

In this session we'll do t-tests with the [`t.test()`](https://rdrr.io/r/stats/t.test.html) function. First I'm going to use the [`rnorm()`](https://rdrr.io/r/stats/Normal.html) function to get some example data to work with by generating random samples (N=20) for each of two populations from a normal distribution with a mean of 10 and standard deviation of 3.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#generate a sample for population 1</span>
<span class='nv'>pop1</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/Normal.html'>rnorm</a></span><span class='o'>(</span>n <span class='o'>=</span> <span class='m'>20</span>, mean <span class='o'>=</span> <span class='m'>10</span>, sd <span class='o'>=</span> <span class='m'>3</span><span class='o'>)</span>
<span class='c'>#view the population 1 data</span>
<span class='nv'>pop1</span>

<span class='c'>#&gt;  [1]  5.768260  8.557372 10.971429 10.649832  8.088188 14.940798 12.890222</span>
<span class='c'>#&gt;  [8] 11.976135 11.202048 12.652296 12.290697  8.053090  9.374655 11.088953</span>
<span class='c'>#&gt; [15]  7.866983  7.948705 12.953359 11.017880  8.615094  3.599791</span>


<span class='c'>#generate a sample for population 2</span>
<span class='nv'>pop2</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/Normal.html'>rnorm</a></span><span class='o'>(</span>n <span class='o'>=</span> <span class='m'>20</span>, mean <span class='o'>=</span> <span class='m'>10</span>, sd <span class='o'>=</span> <span class='m'>3</span><span class='o'>)</span>
<span class='c'>#view the population 2 data</span>
<span class='nv'>pop2</span>

<span class='c'>#&gt;  [1]  7.905270  3.495405 14.574270 13.983999  6.879837  6.010075  4.481750</span>
<span class='c'>#&gt;  [8]  5.499168 11.481124 12.772900 13.914296 15.452734 11.653593 17.513278</span>
<span class='c'>#&gt; [15] 13.021984  8.409504 12.502958  8.316560  8.356185  9.599970</span>
</code></pre>

</div>

A t-test is a good choice here if we want to use our samples to draw inference around whether the true means of these two populations are different. First we can check the means of the samples...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>pop1</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 10.02529</span>

<span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>pop2</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 10.29124</span>
</code></pre>

</div>

The sample means are a bit different, but given they're random samples, that's not surprising even if they were drawn from the same population. The question is whether the observed difference in the means is large enough that, at some given level of confidence, we can infer that the true population means are different. Let's take a look at the documentation for the [`t.test()`](https://rdrr.io/r/stats/t.test.html) function...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='o'>?</span><span class='nv'>t.test</span>
</code></pre>

</div>

![ttest help](images/ttest1.png)

Like documentation for all R functions, this gives us some information on how to use [`t.test()`](https://rdrr.io/r/stats/t.test.html). In its most basic form, the only thing that has to be provided is the 'x' argument, though since we have a two-sample test, we'll need to provide both 'x' and 'y'. According to the documentation, these need to be numeric vectors. Let's check that they are...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/numeric.html'>is.numeric</a></span><span class='o'>(</span><span class='nv'>pop1</span><span class='o'>)</span>

<span class='c'>#&gt; [1] TRUE</span>

<span class='nf'><a href='https://rdrr.io/r/base/vector.html'>is.vector</a></span><span class='o'>(</span><span class='nv'>pop1</span><span class='o'>)</span>

<span class='c'>#&gt; [1] TRUE</span>


<span class='nf'><a href='https://rdrr.io/r/base/numeric.html'>is.numeric</a></span><span class='o'>(</span><span class='nv'>pop2</span><span class='o'>)</span>

<span class='c'>#&gt; [1] TRUE</span>

<span class='nf'><a href='https://rdrr.io/r/base/vector.html'>is.vector</a></span><span class='o'>(</span><span class='nv'>pop2</span><span class='o'>)</span>

<span class='c'>#&gt; [1] TRUE</span>
</code></pre>

</div>

Looks like our two sets of data are in the right format, so we can run the t-test...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#run the t-test</span>
<span class='nf'><a href='https://rdrr.io/r/stats/t.test.html'>t.test</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>pop1</span>, y <span class='o'>=</span> <span class='nv'>pop2</span><span class='o'>)</span>

<span class='c'>#&gt; </span>
<span class='c'>#&gt;   Welch Two Sample t-test</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; data:  pop1 and pop2</span>
<span class='c'>#&gt; t = -0.2477, df = 33.833, p-value = 0.8059</span>
<span class='c'>#&gt; alternative hypothesis: true difference in means is not equal to 0</span>
<span class='c'>#&gt; 95 percent confidence interval:</span>
<span class='c'>#&gt;  -2.448338  1.916431</span>
<span class='c'>#&gt; sample estimates:</span>
<span class='c'>#&gt; mean of x mean of y </span>
<span class='c'>#&gt;  10.02529  10.29124</span>
</code></pre>

</div>

This result gives us several pieces of information. If it's not immediately apparent, we can again get some information about these results from the help, where the "Value" section tells us about what's returned by the function...

![ttest help2](images/ttest2.png)

It says the result is a list, which is a flexible data structure in R that allows you to store multiple items of different types. This particular list has 10 entries. We can see details with the [`str()`](https://rdrr.io/r/utils/str.html) command. First we'll rerun [`t.test()`](https://rdrr.io/r/stats/t.test.html) and this time save the results as an object named *tresult*...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#run t.test and save output to 'tresult'</span>
<span class='nv'>tresult</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/t.test.html'>t.test</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>pop1</span>, y <span class='o'>=</span> <span class='nv'>pop2</span><span class='o'>)</span>
<span class='c'>#get the structure of 'tresult'</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>tresult</span><span class='o'>)</span>

<span class='c'>#&gt; List of 10</span>
<span class='c'>#&gt;  $ statistic  : Named num -0.248</span>
<span class='c'>#&gt;   ..- attr(*, "names")= chr "t"</span>
<span class='c'>#&gt;  $ parameter  : Named num 33.8</span>
<span class='c'>#&gt;   ..- attr(*, "names")= chr "df"</span>
<span class='c'>#&gt;  $ p.value    : num 0.806</span>
<span class='c'>#&gt;  $ conf.int   : num [1:2] -2.45 1.92</span>
<span class='c'>#&gt;   ..- attr(*, "conf.level")= num 0.95</span>
<span class='c'>#&gt;  $ estimate   : Named num [1:2] 10 10.3</span>
<span class='c'>#&gt;   ..- attr(*, "names")= chr [1:2] "mean of x" "mean of y"</span>
<span class='c'>#&gt;  $ null.value : Named num 0</span>
<span class='c'>#&gt;   ..- attr(*, "names")= chr "difference in means"</span>
<span class='c'>#&gt;  $ stderr     : num 1.07</span>
<span class='c'>#&gt;  $ alternative: chr "two.sided"</span>
<span class='c'>#&gt;  $ method     : chr "Welch Two Sample t-test"</span>
<span class='c'>#&gt;  $ data.name  : chr "pop1 and pop2"</span>
<span class='c'>#&gt;  - attr(*, "class")= chr "htest"</span>
</code></pre>

</div>

From this we see that the list of 10 items consists of a mixture of numerics and characters. Each of the list entries has a name, and the '\$' can be used with the name of the entry to extract an item from the list (this applies to lists in general in R - not just this one). Alternatively, the square bracket notation can be used to index (pull out) items from the list. Let's try several options for pulling out the pvalue, which is the 3rd entry...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>tresult</span><span class='o'>$</span><span class='nv'>p.value</span>

<span class='c'>#&gt; [1] 0.805862</span>

<span class='nv'>tresult</span><span class='o'>[</span><span class='m'>3</span><span class='o'>]</span>

<span class='c'>#&gt; $p.value</span>
<span class='c'>#&gt; [1] 0.805862</span>

<span class='nv'>tresult</span><span class='o'>[[</span><span class='m'>3</span><span class='o'>]</span><span class='o'>]</span>

<span class='c'>#&gt; [1] 0.805862</span>
</code></pre>

</div>

We've talked in a number of previous Code Club sessions about working with tidy data - this list doesn't fall in to that category, but can be converted to a tidy object with the `tidy()` function from the broom package, which is installed as part of the tidyverse (though not loaded).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>tidytresult</span> <span class='o'>&lt;-</span> <span class='nf'>broom</span><span class='nf'>::</span><span class='nf'><a href='https://rdrr.io/pkg/generics/man/tidy.html'>tidy</a></span><span class='o'>(</span><span class='nv'>tresult</span><span class='o'>)</span>
<span class='nv'>tidytresult</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1 x 10</span></span>
<span class='c'>#&gt;   estimate estimate1 estimate2 statistic p.value parameter conf.low conf.high</span>
<span class='c'>#&gt;      <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>    </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span>   -</span><span style='color: #BB0000;'>0.266</span><span>      10.0      10.3    -</span><span style='color: #BB0000;'>0.248</span><span>   0.806      33.8    -</span><span style='color: #BB0000;'>2.45</span><span>      1.92</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 2 more variables: method &lt;chr&gt;, alternative &lt;chr&gt;</span></span>
</code></pre>

</div>

The `tidy()` function from broom takes results from a number of base R functions and makes them tidy. Now instead of a list we have a data frame (which actually is just a special kind of list) with 10 columns (though note they don't correspond directly to the 10 entries of the original list).

Having results in this tidy format allows you to use the tidy approaches we've worked with in the past. Let's try plotting the means of the two samples as a simple bar (column) plot. The two sample means are in the *estimate1* and *estimate2* columns. First we'll create a separate data frame that stores those means in long format (the values in one column and associated labels in a separate column).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#get popualation 1 mean</span>
<span class='nv'>pop1_mean</span> <span class='o'>&lt;-</span> <span class='nv'>tidytresult</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>estimate1</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/base/unlist.html'>unlist</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#view population 1 mean</span>
<span class='nv'>pop1_mean</span>

<span class='c'>#&gt; estimate1 </span>
<span class='c'>#&gt;  10.02529</span>


<span class='c'>#get popualation 1 mean</span>
<span class='nv'>pop2_mean</span> <span class='o'>&lt;-</span> <span class='nv'>tidytresult</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>estimate2</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/base/unlist.html'>unlist</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#view population 2 mean</span>
<span class='nv'>pop2_mean</span>

<span class='c'>#&gt; estimate2 </span>
<span class='c'>#&gt;  10.29124</span>


<span class='nv'>means_to_plot</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/data.frame.html'>data.frame</a></span><span class='o'>(</span><span class='s'>"mean"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='nv'>pop1_mean</span>, <span class='nv'>pop2_mean</span><span class='o'>)</span>,
                            <span class='s'>"sample"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"Population 1"</span>, <span class='s'>"Population 2"</span><span class='o'>)</span><span class='o'>)</span>
  
<span class='nv'>means_to_plot</span>

<span class='c'>#&gt;               mean       sample</span>
<span class='c'>#&gt; estimate1 10.02529 Population 1</span>
<span class='c'>#&gt; estimate2 10.29124 Population 2</span>
</code></pre>

</div>

Now we can use that data frame to create the plot with *ggplot2*.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#get a basic plot</span>
<span class='nv'>means_to_plot</span> <span class='o'>%&gt;%</span> <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>sample</span>, y <span class='o'>=</span> <span class='nv'>mean</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_col</span><span class='o'>(</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-11-1.png" width="700px" style="display: block; margin: auto;" />

</div>

And we can do a little customization...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#customize the plot a bit</span>
<span class='nv'>means_to_plot</span> <span class='o'>%&gt;%</span> <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>sample</span>, y <span class='o'>=</span> <span class='nv'>mean</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_col</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_classic</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Mean Values From Random Samples"</span>, 
       x <span class='o'>=</span> <span class='kc'>NULL</span>,
       y <span class='o'>=</span> <span class='s'>"Mean Value"</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-12-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Now let's work with some real data. R has a small example dataset named *mtcars* already built in. It's a data frame with data on different models of car. It can be called with `mtcars`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>mtcars</span>

<span class='c'>#&gt;                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb</span>
<span class='c'>#&gt; Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4</span>
<span class='c'>#&gt; Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4</span>
<span class='c'>#&gt; Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1</span>
<span class='c'>#&gt; Hornet 4 Drive      21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1</span>
<span class='c'>#&gt; Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2</span>
<span class='c'>#&gt; Valiant             18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1</span>
<span class='c'>#&gt; Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4</span>
<span class='c'>#&gt; Merc 240D           24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2</span>
<span class='c'>#&gt; Merc 230            22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2</span>
<span class='c'>#&gt; Merc 280            19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4</span>
<span class='c'>#&gt; Merc 280C           17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4</span>
<span class='c'>#&gt; Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3</span>
<span class='c'>#&gt; Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3</span>
<span class='c'>#&gt; Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3</span>
<span class='c'>#&gt; Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4</span>
<span class='c'>#&gt; Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4</span>
<span class='c'>#&gt; Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4</span>
<span class='c'>#&gt; Fiat 128            32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1</span>
<span class='c'>#&gt; Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2</span>
<span class='c'>#&gt; Toyota Corolla      33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1</span>
<span class='c'>#&gt; Toyota Corona       21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1</span>
<span class='c'>#&gt; Dodge Challenger    15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2</span>
<span class='c'>#&gt; AMC Javelin         15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2</span>
<span class='c'>#&gt; Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4</span>
<span class='c'>#&gt; Pontiac Firebird    19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2</span>
<span class='c'>#&gt; Fiat X1-9           27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1</span>
<span class='c'>#&gt; Porsche 914-2       26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2</span>
<span class='c'>#&gt; Lotus Europa        30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2</span>
<span class='c'>#&gt; Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4</span>
<span class='c'>#&gt; Ferrari Dino        19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6</span>
<span class='c'>#&gt; Maserati Bora       15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8</span>
<span class='c'>#&gt; Volvo 142E          21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2</span>
</code></pre>

</div>

As a quick reminder, `select()` allows you to choose columns of a data frame by name, while [`filter()`](https://rdrr.io/r/stats/filter.html) allows you to select rows based on one or more logical (True/False) expressions.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#example of "select()"</span>
<span class='nv'>mtcars</span> <span class='o'>%&gt;%</span> <span class='nf'>select</span><span class='o'>(</span><span class='nv'>mpg</span>, <span class='nv'>disp</span>, <span class='nv'>carb</span><span class='o'>)</span>

<span class='c'>#&gt;                      mpg  disp carb</span>
<span class='c'>#&gt; Mazda RX4           21.0 160.0    4</span>
<span class='c'>#&gt; Mazda RX4 Wag       21.0 160.0    4</span>
<span class='c'>#&gt; Datsun 710          22.8 108.0    1</span>
<span class='c'>#&gt; Hornet 4 Drive      21.4 258.0    1</span>
<span class='c'>#&gt; Hornet Sportabout   18.7 360.0    2</span>
<span class='c'>#&gt; Valiant             18.1 225.0    1</span>
<span class='c'>#&gt; Duster 360          14.3 360.0    4</span>
<span class='c'>#&gt; Merc 240D           24.4 146.7    2</span>
<span class='c'>#&gt; Merc 230            22.8 140.8    2</span>
<span class='c'>#&gt; Merc 280            19.2 167.6    4</span>
<span class='c'>#&gt; Merc 280C           17.8 167.6    4</span>
<span class='c'>#&gt; Merc 450SE          16.4 275.8    3</span>
<span class='c'>#&gt; Merc 450SL          17.3 275.8    3</span>
<span class='c'>#&gt; Merc 450SLC         15.2 275.8    3</span>
<span class='c'>#&gt; Cadillac Fleetwood  10.4 472.0    4</span>
<span class='c'>#&gt; Lincoln Continental 10.4 460.0    4</span>
<span class='c'>#&gt; Chrysler Imperial   14.7 440.0    4</span>
<span class='c'>#&gt; Fiat 128            32.4  78.7    1</span>
<span class='c'>#&gt; Honda Civic         30.4  75.7    2</span>
<span class='c'>#&gt; Toyota Corolla      33.9  71.1    1</span>
<span class='c'>#&gt; Toyota Corona       21.5 120.1    1</span>
<span class='c'>#&gt; Dodge Challenger    15.5 318.0    2</span>
<span class='c'>#&gt; AMC Javelin         15.2 304.0    2</span>
<span class='c'>#&gt; Camaro Z28          13.3 350.0    4</span>
<span class='c'>#&gt; Pontiac Firebird    19.2 400.0    2</span>
<span class='c'>#&gt; Fiat X1-9           27.3  79.0    1</span>
<span class='c'>#&gt; Porsche 914-2       26.0 120.3    2</span>
<span class='c'>#&gt; Lotus Europa        30.4  95.1    2</span>
<span class='c'>#&gt; Ford Pantera L      15.8 351.0    4</span>
<span class='c'>#&gt; Ferrari Dino        19.7 145.0    6</span>
<span class='c'>#&gt; Maserati Bora       15.0 301.0    8</span>
<span class='c'>#&gt; Volvo 142E          21.4 121.0    2</span>


<span class='c'>#example of "filter()"</span>
<span class='nv'>mtcars</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>wt</span> <span class='o'>&gt;</span> <span class='m'>4</span><span class='o'>)</span>

<span class='c'>#&gt;                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb</span>
<span class='c'>#&gt; Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3</span>
<span class='c'>#&gt; Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4</span>
<span class='c'>#&gt; Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4</span>
<span class='c'>#&gt; Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4</span>
</code></pre>

</div>

We'll focus on just a couple of the variables in this dataset: Horsepower (hp) and 1/4 mile time in seconds (qsec). Note that in some cases I've provided a couple equivalent solutions that represent a tidy way of doing things (generally preferred) and a non-tidy (aka base R) way of doing things, just so you can see the difference if you are interested. If this is likely to confuse you, feel free to ignore the alternative (non-tidy) parts.

------------------------------------------------------------------------

### Breakout Room: Does Average 1/4-mile Speed Differ For High And Low Horsepower Cars?

<div class="puzzle">

<div>

We'll define "low" horsepower cars as those with \<120 hp, and "high" horsepower cars as \>=120 hp. First let's get the average 1/4-mile times (qsec) for each of these groups. Save these mean times as the objects 'low_hp_time' and 'high_hp_time'.

<details>
<summary>
<b>Hint</b> (click here)
</summary>

<br> Use [`filter()`](https://rdrr.io/r/stats/filter.html), `select()`, and [`unlist()`](https://rdrr.io/r/base/unlist.html) to pull out the appropriate sets of numeric values for each group, and then [`mean()`](https://rdrr.io/r/base/mean.html) to get the averages. Note that [`unlist()`](https://rdrr.io/r/base/unlist.html) takes a list or data frame object and "flattens" it, or in other words, simplifies it down to, in this case, a numeric vector. <br>

</details>
<details>
<summary>
<b>Solution 1 (tidy)</b> (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>low_hp_time</span> <span class='o'>&lt;-</span> <span class='nv'>mtcars</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>hp</span> <span class='o'>&lt;</span> <span class='m'>120</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>qsec</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/base/unlist.html'>unlist</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='nv'>low_hp_time</span>

<span class='c'>#&gt; [1] 18.91</span>


<span class='nv'>high_hp_time</span> <span class='o'>&lt;-</span> <span class='nv'>mtcars</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>hp</span> <span class='o'>&gt;=</span> <span class='m'>120</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>qsec</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/base/unlist.html'>unlist</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='nv'>high_hp_time</span>

<span class='c'>#&gt; [1] 16.91235</span>
</code></pre>

</div>

</details>
<details>
<summary>
<b>Solution 2 (not tidy) </b> (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>low_hp_time</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>mtcars</span><span class='o'>$</span><span class='nv'>qsec</span><span class='o'>[</span><span class='nv'>mtcars</span><span class='o'>$</span><span class='nv'>hp</span> <span class='o'>&lt;</span> <span class='m'>120</span><span class='o'>]</span><span class='o'>)</span> 

<span class='nv'>low_hp_time</span>

<span class='c'>#&gt; [1] 18.91</span>


<span class='nv'>high_hp_time</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>mtcars</span><span class='o'>$</span><span class='nv'>qsec</span><span class='o'>[</span><span class='nv'>mtcars</span><span class='o'>$</span><span class='nv'>hp</span> <span class='o'>&gt;=</span> <span class='m'>120</span><span class='o'>]</span><span class='o'>)</span>

<span class='nv'>high_hp_time</span>

<span class='c'>#&gt; [1] 16.91235</span>
</code></pre>

</div>

</details>

</div>

</div>

<div class="puzzle">

<div>

<br>

Now let's plot those mean values with a bar plot (`geom_col()`).

<details>
<summary>
<b>Hint</b> (click here)
</summary>

<br> All ggplots (`geom_col()` is a ggplot function) need input data from a data frame (or tibble, which is just a special data frame). First create a data frame named "time_df" that has a column named "time" that stores the average qsec values and a column named "hp_class" that indicates whether the corresponding time is for "High HP" or "Low HP" cars. Then map the ggplot "x" aesthetic to the "hp_class" column and the "y" aesthetic to the "time" column and add a `geom_col()` layer.<br>

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>time_df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/data.frame.html'>data.frame</a></span><span class='o'>(</span><span class='s'>"time"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='nv'>low_hp_time</span>, <span class='nv'>high_hp_time</span><span class='o'>)</span>,
                      <span class='s'>"hp_class"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"Low HP"</span>, <span class='s'>"High HP"</span><span class='o'>)</span><span class='o'>)</span>

<span class='nv'>time_df</span>

<span class='c'>#&gt;       time hp_class</span>
<span class='c'>#&gt; 1 18.91000   Low HP</span>
<span class='c'>#&gt; 2 16.91235  High HP</span>


<span class='nv'>time_df</span> <span class='o'>%&gt;%</span> <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>hp_class</span>, y <span class='o'>=</span> <span class='nv'>time</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_col</span><span class='o'>(</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-17-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

</div>

<div class="puzzle">

<div>

<br>

So, do these data provide evidence for true differences in 1/4 mile speed between high and low horsepower cars? Try running a t-test to test for differences in the two groups of 1/4 mile times, and save the pvalue as an object named *speed_p*.

<details>
<summary>
<b>Hint</b> (click here)
</summary>

<br> Use the [`t.test()`](https://rdrr.io/r/stats/t.test.html) function. Remember that the "x" and "y" arguments each need to be numeric vectors. <br>

</details>
<details>
<summary>
<b>Solution 1 (tidy)</b> (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#get the values for low-horsepower cars</span>
<span class='nv'>low_hp_vals</span> <span class='o'>&lt;-</span> <span class='nv'>mtcars</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>hp</span> <span class='o'>&lt;</span> <span class='m'>120</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>qsec</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/base/unlist.html'>unlist</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#get the values for high-horsepower cars</span>
<span class='nv'>high_hp_vals</span> <span class='o'>&lt;-</span> <span class='nv'>mtcars</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>hp</span> <span class='o'>&gt;=</span> <span class='m'>120</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>qsec</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/base/unlist.html'>unlist</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#run the t-test and save the results</span>
<span class='nv'>speed_res</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/t.test.html'>t.test</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>low_hp_vals</span>, y <span class='o'>=</span> <span class='nv'>high_hp_vals</span><span class='o'>)</span>

<span class='nv'>speed_p</span> <span class='o'>&lt;-</span> <span class='nv'>speed_res</span><span class='o'>$</span><span class='nv'>p.value</span>

<span class='nv'>speed_p</span>

<span class='c'>#&gt; [1] 0.001007059</span>
</code></pre>

</div>

</details>
<details>
<summary>
<b>Solution 2 (not tidy)</b> (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#get the values for low-horsepower cars</span>
<span class='nv'>low_hp_vals</span> <span class='o'>&lt;-</span> <span class='nv'>mtcars</span><span class='o'>$</span><span class='nv'>qsec</span><span class='o'>[</span><span class='nv'>mtcars</span><span class='o'>$</span><span class='nv'>hp</span> <span class='o'>&lt;</span> <span class='m'>120</span><span class='o'>]</span>

<span class='c'>#get the values for high-horsepower cars</span>
<span class='nv'>high_hp_vals</span> <span class='o'>&lt;-</span> <span class='nv'>mtcars</span><span class='o'>$</span><span class='nv'>qsec</span><span class='o'>[</span><span class='nv'>mtcars</span><span class='o'>$</span><span class='nv'>hp</span> <span class='o'>&gt;=</span> <span class='m'>120</span><span class='o'>]</span>

<span class='c'>#run the t-test and save the results</span>
<span class='nv'>speed_res</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/t.test.html'>t.test</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>low_hp_vals</span>, y <span class='o'>=</span> <span class='nv'>high_hp_vals</span><span class='o'>)</span>

<span class='nv'>speed_p</span> <span class='o'>&lt;-</span> <span class='nv'>speed_res</span><span class='o'>$</span><span class='nv'>p.value</span>

<span class='nv'>speed_p</span>

<span class='c'>#&gt; [1] 0.001007059</span>
</code></pre>

</div>

</details>

</div>

</div>

<div class="puzzle">

<div>

<br>

Try running the same test as above, but this time, do it as a one-sided test, with the alternative hypothesis that the 1/4-mile time for the high-horsepower group will be lower than that for the low-horsepower group. How does the p-value from this test compare to the previous (two-sided) test?

<details>
<summary>
<b>Hint</b> (click here)
</summary>

<br> Check out the *alternative* argument on the t.test help page, along with information in the **Details** section of that same page. <br>

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#run the t-test and save the results</span>
<span class='nv'>speed_res</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/t.test.html'>t.test</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>low_hp_vals</span>, y <span class='o'>=</span> <span class='nv'>high_hp_vals</span>, alternative <span class='o'>=</span> <span class='s'>"greater"</span><span class='o'>)</span>

<span class='nv'>speed_p</span> <span class='o'>&lt;-</span> <span class='nv'>speed_res</span><span class='o'>$</span><span class='nv'>p.value</span>

<span class='nv'>speed_p</span>

<span class='c'>#&gt; [1] 0.0005035295</span>
</code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

### Bonus

<div class="puzzle">

<div>

<br>

Let's try to visualize the data in a different way? This time, let's try plotting the distribution of values in each of the samples together on a single plot. See if you can recreate the plot below...

<div class="highlight">

<img src="figs/unnamed-chunk-21-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<details>
<summary>
<b>Hint</b> (click here)
</summary>

<br> First obtain a long data frame with the raw values for both groups in one column, and an identifier (high-hp, low-hp) in another column. You can do this by hand, using similar methods as we used in exercises above, or you can go back to the original *mtcars* data frame and use `mutate()` in combination with either [`ifelse()`](https://rdrr.io/r/base/ifelse.html) or `case_when()` to add the identifier column. Then use `geom_histogram()`, adjusting the *alpha* and *position* arguments, and customize the theme and the labels. <br>

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>mtcars</span> <span class='o'>%&gt;%</span> <span class='nf'>mutate</span><span class='o'>(</span><span class='s'>"hp_class"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='o'>(</span><span class='nv'>hp</span> <span class='o'>&lt;</span> <span class='m'>120</span>, <span class='s'>"Low_HP"</span>, <span class='s'>"High_HP"</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>qsec</span>, fill <span class='o'>=</span> <span class='nv'>hp_class</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_histogram</span><span class='o'>(</span>alpha <span class='o'>=</span> <span class='m'>0.7</span>, position <span class='o'>=</span> <span class='s'>"identity"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_classic</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Time (seconds)"</span>,
       y <span class='o'>=</span> <span class='s'>"Count"</span>,
       title <span class='o'>=</span> <span class='s'>"Distribution of 1/4 Mile Times By Horsepower Class"</span><span class='o'>)</span>

<span class='c'>#&gt; `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.</span>

</code></pre>
<img src="figs/unnamed-chunk-22-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

</div>

<br>

------------------------------------------------------------------------

