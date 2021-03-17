---
title: "Session 14: Writing your own functions"
summary: "In this session of Code Club, we'll look at how to avoid repetition in another way by writing your own functions."
authors: [michael-broe]
date: "2021-03-16"
output: hugodown::md_document
toc: true
image: 
  caption: ""
  focal_point: ""
  preview_only: false
editor_options: 
  markdown: 
    wrap: 72
rmd_hash: dbe42acab8da4ee1

---

<br> <br> <br>

------------------------------------------------------------------------

## New To Code Club?

-   First, check out the [Code Club Computer Setup](/codeclub-setup/) instructions, which also has some pointers that might be helpful if you're new to R or RStudio.

-   Please open RStudio before Code Club to test things out -- if you run into issues, join the Zoom call early and we'll troubleshoot.

------------------------------------------------------------------------

## Session Goals

-   Learn another way to avoid repetition in your code by creating your own functions.
-   Learn the basic **template** of a function in R.
-   Learn to incorporate your own functions into `for` loops and functionals.
-   Learn all the advantages of using functions instead of code blocks.

------------------------------------------------------------------------

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>

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

## Writing your own functions

The first motivation for writing a function is when you find yourself cut-and-pasting code blocks with slight alterations each time.

Say we have the following toy tidyverse data frame, where each column is a vector of 10 random numbers from a normal distribution, with `mean = 0` and `sd = 1` (the defaults for `rnorm`):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>df</span> <span class='o'>&lt;-</span> <span class='nf'>tibble</span><span class='o'>(</span>
  a <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/stats/Normal.html'>rnorm</a></span><span class='o'>(</span><span class='m'>10</span><span class='o'>)</span>,
  b <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/stats/Normal.html'>rnorm</a></span><span class='o'>(</span><span class='m'>10</span><span class='o'>)</span>,
  c <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/stats/Normal.html'>rnorm</a></span><span class='o'>(</span><span class='m'>10</span><span class='o'>)</span>,
  d <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/stats/Normal.html'>rnorm</a></span><span class='o'>(</span><span class='m'>10</span><span class='o'>)</span>
<span class='o'>)</span>

<span class='nv'>df</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 x 4</span></span>
<span class='c'>#&gt;          a      b       c         d</span>
<span class='c'>#&gt;      <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span>  1.43    1.84  -</span><span style='color: #BB0000;'>1.06</span><span>    0.190   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span>  1.55    0.596  0.295  -</span><span style='color: #BB0000;'>0.000</span><span style='color: #BB0000;text-decoration: underline;'>830</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> -</span><span style='color: #BB0000;'>0.388</span><span>   0.357 -</span><span style='color: #BB0000;'>1.63</span><span>   -</span><span style='color: #BB0000;'>1.60</span><span>    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span>  0.868  -</span><span style='color: #BB0000;'>1.12</span><span>   0.098</span><span style='text-decoration: underline;'>9</span><span>  0.870   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> -</span><span style='color: #BB0000;'>0.071</span><span style='color: #BB0000;text-decoration: underline;'>9</span><span> -</span><span style='color: #BB0000;'>0.665</span><span>  0.310  -</span><span style='color: #BB0000;'>0.341</span><span>   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span>  0.617  -</span><span style='color: #BB0000;'>0.469</span><span>  0.073</span><span style='text-decoration: underline;'>8</span><span> -</span><span style='color: #BB0000;'>0.235</span><span>   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> -</span><span style='color: #BB0000;'>0.228</span><span>   0.412  0.165  -</span><span style='color: #BB0000;'>0.209</span><span>   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span>  1.18   -</span><span style='color: #BB0000;'>0.470</span><span> -</span><span style='color: #BB0000;'>0.175</span><span>   0.086</span><span style='text-decoration: underline;'>1</span><span>  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span>  1.38    0.176  0.847  -</span><span style='color: #BB0000;'>0.480</span><span>   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> -</span><span style='color: #BB0000;'>0.164</span><span>   1.91   0.593  -</span><span style='color: #BB0000;'>0.606</span></span>
</code></pre>

</div>

In previous CodeClubs we've seen how you can apply a built-in function like `median` to each column using a `for` loop or `apply`. But say we wanted to do something a bit fancier that is not part of core R. For example, we can *normalize* the values in a column so they range from 0 to 1 using the following code block:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>/</span> <span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt;  [1] 0.93448575 1.00000000 0.00000000 0.64688077 0.16273539 0.51751818</span>
<span class='c'>#&gt;  [7] 0.08218327 0.80535546 0.91235476 0.11515570</span>
</code></pre>

</div>

This code is a literal translation of the mathematical formula for normalization:

$$z_{i} = \frac{x_{i} - min(x)}{max(x)-min(x)}$$ OK, so how can we do this for each column? Here is a first attempt:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span> <span class='o'>&lt;-</span> <span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>/</span> <span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span><span class='o'>)</span>
<span class='nv'>df</span><span class='o'>$</span><span class='nv'>b</span> <span class='o'>&lt;-</span> <span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>b</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>/</span> <span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>b</span><span class='o'>)</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>b</span><span class='o'>)</span><span class='o'>)</span>
<span class='nv'>df</span><span class='o'>$</span><span class='nv'>c</span> <span class='o'>&lt;-</span> <span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>c</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>c</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>/</span> <span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>c</span><span class='o'>)</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>c</span><span class='o'>)</span><span class='o'>)</span>
<span class='nv'>df</span><span class='o'>$</span><span class='nv'>d</span> <span class='o'>&lt;-</span> <span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>d</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>d</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>/</span> <span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>d</span><span class='o'>)</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>d</span><span class='o'>)</span><span class='o'>)</span>

<span class='nv'>df</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 x 4</span></span>
<span class='c'>#&gt;         a       b     c     d</span>
<span class='c'>#&gt;     <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> 0.934   0.610  0.229 0.724</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> 1       0.197  0.777 0.647</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> 0       0.118  0     0    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> 0.647  -</span><span style='color: #BB0000;'>0.370</span><span>  0.698 1    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> 0.163  -</span><span style='color: #BB0000;'>0.220</span><span>  0.783 0.509</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> 0.518  -</span><span style='color: #BB0000;'>0.155</span><span>  0.688 0.552</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> 0.082</span><span style='text-decoration: underline;'>2</span><span>  0.136  0.724 0.563</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> 0.805  -</span><span style='color: #BB0000;'>0.155</span><span>  0.587 0.682</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> 0.912   0.058</span><span style='text-decoration: underline;'>1</span><span> 1     0.453</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> 0.115   0.630  0.897 0.402</span></span>
</code></pre>

</div>

This works, but it caused me mental anguish to type it out. Even with cut and paste! All those manual textual substitutions!! And manual data entry is prone to mistakes, especially repetitive tasks like this. And say you had 1,000 columns...

**And it didn't work!!** Honestly, I swear that mistake was totally real: I didn't notice it until I looked at the output. Can you spot the mistake?

It turns out R has a `range` function that returns the minimum and maximum of a vector, which somewhat simplifies the coding:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/range.html'>range</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span>
</code></pre>

</div>

The result is a vector something like [`c(-1.2129504, 2.1011248)`](https://rdrr.io/r/base/c.html) (it varies run to run, since the columns values are random) which we can index, and we so we only do the min/max computation once for each column, instead of three times, so we get the following block of code for each column:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>rng</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/range.html'>range</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span>
<span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span> <span class='o'>-</span> <span class='nv'>rng</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>)</span> <span class='o'>/</span> <span class='o'>(</span><span class='nv'>rng</span><span class='o'>[</span><span class='m'>2</span><span class='o'>]</span> <span class='o'>-</span> <span class='nv'>rng</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>)</span>
</code></pre>

</div>

Does this help?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>rng</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/range.html'>range</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span>
<span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span> <span class='o'>&lt;-</span> <span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span> <span class='o'>-</span> <span class='nv'>rng</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>)</span> <span class='o'>/</span> <span class='o'>(</span><span class='nv'>rng</span><span class='o'>[</span><span class='m'>2</span><span class='o'>]</span> <span class='o'>-</span> <span class='nv'>rng</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>)</span>

<span class='nv'>rng</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/range.html'>range</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>b</span><span class='o'>)</span>
<span class='nv'>df</span><span class='o'>$</span><span class='nv'>b</span> <span class='o'>&lt;-</span> <span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>b</span> <span class='o'>-</span> <span class='nv'>rng</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>)</span> <span class='o'>/</span> <span class='o'>(</span><span class='nv'>rng</span><span class='o'>[</span><span class='m'>2</span><span class='o'>]</span> <span class='o'>-</span> <span class='nv'>rng</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>)</span>

<span class='nv'>rng</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/range.html'>range</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>c</span><span class='o'>)</span>
<span class='nv'>df</span><span class='o'>$</span><span class='nv'>c</span> <span class='o'>&lt;-</span> <span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>c</span> <span class='o'>-</span> <span class='nv'>rng</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>)</span> <span class='o'>/</span> <span class='o'>(</span><span class='nv'>rng</span><span class='o'>[</span><span class='m'>2</span><span class='o'>]</span> <span class='o'>-</span> <span class='nv'>rng</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>)</span>

<span class='nv'>rng</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/range.html'>range</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>d</span><span class='o'>)</span>
<span class='nv'>df</span><span class='o'>$</span><span class='nv'>d</span> <span class='o'>&lt;-</span> <span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>d</span> <span class='o'>-</span> <span class='nv'>rng</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>)</span> <span class='o'>/</span> <span class='o'>(</span><span class='nv'>rng</span><span class='o'>[</span><span class='m'>2</span><span class='o'>]</span> <span class='o'>-</span> <span class='nv'>rng</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>)</span>
</code></pre>

</div>

Still pretty horrible, and arguably worse since we add a line for each column.

How can we distill this into a function to avoid all that repetition?

The secret to function writing is abstracting the *constant* from the *variable*. (Using the `range` function does throw into sharper relief what is constant and what is varying at least.) The constant part is the **body** of the function: the template or boiler-plate you use over and over again. The variable parts are the **arguments** of the function. We also need to give the function a **name**, so we can call it and reuse it. The template for a function is then:

``` r
name <- function(arg1, arg2...) {
  <body> # do something with arg1, arg2
}
```

The body is the block of code you want to reuse, and it's contained in curly brackets `{...}`.

Here's what it looks like in this case:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>normalize</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span> <span class='o'>&#123;</span>
  <span class='nv'>rng</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/range.html'>range</a></span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span>
  <span class='o'>(</span><span class='nv'>x</span> <span class='o'>-</span> <span class='nv'>rng</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>)</span> <span class='o'>/</span> <span class='o'>(</span><span class='nv'>rng</span><span class='o'>[</span><span class='m'>2</span><span class='o'>]</span> <span class='o'>-</span> <span class='nv'>rng</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>)</span>
<span class='o'>&#125;</span>
</code></pre>

</div>

Pretty cool, right? Here `normalize` is the descriptive name we give the function.

We **assign** the function to the name using [`<-`](https://rdrr.io/r/base/assignOps.html) just like any other value. This means that now `normalize` is a function object, just like you create vector objects, or list or data frame objects, when you assigned them names. This is what is meant when people say "functions are first-class citizens" in R. Notice too that in RStudio they appear in the Global Environment in a special section, and clicking on them shows the code. This means that if you have a large file of code with many functions defined, you don't have to go back searching for the function definition in the code itself.

`x` is the **argument** of the function. In the current case this is a data frame column vector, but we can potentially use this function on *any* vector, so let's not be too specific. The more generally you can write your function, the more useful it will be.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>test_vec</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>3</span>, <span class='m'>7</span>, <span class='nv'>pi</span>, <span class='m'>8.657</span>, <span class='m'>80</span><span class='o'>)</span>
<span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>test_vec</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 0.000000000 0.051948052 0.001838866 0.073467532 1.000000000</span>
</code></pre>

</div>

When we **call** the function, the value we use in the function call is **assigned** to `x` and is **passed in** to the body of the function. So if we call the function on the first column, it gets passed in to the body, and returns the result:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>df</span> <span class='o'>&lt;-</span> <span class='nf'>tibble</span><span class='o'>(</span>a <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/stats/Normal.html'>rnorm</a></span><span class='o'>(</span><span class='m'>10</span><span class='o'>)</span><span class='o'>)</span>
<span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span>

<span class='c'>#&gt;  [1] 0.2178530 0.0000000 0.1413015 0.5403319 0.5080280 0.2213932 0.6130305</span>
<span class='c'>#&gt;  [8] 0.5878434 0.7390673 1.0000000</span>
</code></pre>

</div>

A couple of things to note:

-   Including that extra line `rng <- range(x)` is no longer a problem, since we just type it once. If you are typing things out over and over you might prefer brevity. *When you write a function, you should prefer clarity.* It's good practice to break the the function down into logical steps, and name them properly. It's much easier for others to 'read' your function, and much easier for you when you come back to it in a couple of years. This is the principle of making your code 'self-annotated'.

-   There's something very important but rather subtle about this use of the argument. As noted in a CodeClub 12, once a `for` loop completes, the variable you're using *keeps the value it had* at the last iteration of the loop, which persists in the global environment. Below we'll compare that behavior to what happens with the function's `x` argument.

Our original horrible code can now be rewritten as:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span> <span class='o'>&lt;-</span> <span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span>
<span class='nv'>df</span><span class='o'>$</span><span class='nv'>b</span> <span class='o'>&lt;-</span> <span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>b</span><span class='o'>)</span>
<span class='nv'>df</span><span class='o'>$</span><span class='nv'>c</span> <span class='o'>&lt;-</span> <span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>c</span><span class='o'>)</span>
<span class='nv'>df</span><span class='o'>$</span><span class='nv'>d</span> <span class='o'>&lt;-</span> <span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>d</span><span class='o'>)</span>
</code></pre>

</div>

Which is an improvement, but the real power comes from the fact that we can use our own new function in `for` loops and `apply` statements. Here is the data from the previous couple of Clubs:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>dists_Mar4</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>17</span>, <span class='m'>93</span>, <span class='m'>56</span>, <span class='m'>19</span>, <span class='m'>175</span>, <span class='m'>40</span>, <span class='m'>69</span>, <span class='m'>267</span>, <span class='m'>4</span>, <span class='m'>91</span><span class='o'>)</span>
<span class='nv'>dists_Mar5</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>87</span>, <span class='m'>143</span>, <span class='m'>103</span>, <span class='m'>223</span>, <span class='m'>106</span>, <span class='m'>18</span>, <span class='m'>87</span>, <span class='m'>72</span>, <span class='m'>59</span>, <span class='m'>5</span><span class='o'>)</span>
<span class='nv'>dist_df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/data.frame.html'>data.frame</a></span><span class='o'>(</span><span class='nv'>dists_Mar4</span>, <span class='nv'>dists_Mar5</span><span class='o'>)</span>
</code></pre>

</div>

Let's first check that our new function behaves sensibly on these vectors, as a sanity check:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>dists_Mar4</span><span class='o'>)</span>

<span class='c'>#&gt;  [1] 0.04942966 0.33840304 0.19771863 0.05703422 0.65019011 0.13688213</span>
<span class='c'>#&gt;  [7] 0.24714829 1.00000000 0.00000000 0.33079848</span>
</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>dists_Mar5</span><span class='o'>)</span> 

<span class='c'>#&gt;  [1] 0.37614679 0.63302752 0.44954128 1.00000000 0.46330275 0.05963303</span>
<span class='c'>#&gt;  [7] 0.37614679 0.30733945 0.24770642 0.00000000</span>
</code></pre>

</div>

And while we're here, let's circle back to the assignment of the `x` argument outside and inside the function. Below we first assign a value to `x` outside the function; pass in a value to `x` inside the function; then reevaluate `x` outside the function call, to see what happened:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>x</span> <span class='o'>=</span> <span class='nv'>pi</span>
<span class='nv'>x</span>

<span class='c'>#&gt; [1] 3.141593</span>

<span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>dists_Mar5</span><span class='o'>)</span>             <span class='c'># inside the function, x &lt;- dists_Mar5</span>

<span class='c'>#&gt;  [1] 0.37614679 0.63302752 0.44954128 1.00000000 0.46330275 0.05963303</span>
<span class='c'>#&gt;  [7] 0.37614679 0.30733945 0.24770642 0.00000000</span>

<span class='nv'>x</span>

<span class='c'>#&gt; [1] 3.141593</span>
</code></pre>

</div>

Whatever value `x` has outside the function does not affect, and is not affected by, the value of `x` inside the function. In computer science terms we say the variable(s) used inside the function are **local** to the function. They are freshly minted inside it, and safely destroyed before you leave it. So there is no chance of weird or unexpected conflicts with whatever variable values are set outside. In contrast, the variable in the for loop is **global**. It 'leaks out' from where you actually used it, with perhaps unforeseen consequences. This is extremely important when you start embedding your own functions in larger programs.

### Functions in `for` loops

Here is how we can use our new function in a `for` loop over a data frame. In our previous examples of `for` loops `median` was a summary statistic and we return a single value for each column, so we created an empty vector of the desired length to hold the values for each column. Here we want to modify the original data frame with the same dimensions and column names. The following code copies the original data frame (so we don't destroy it) and then modifies it 'in place':

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>dist_df_norm</span> <span class='o'>&lt;-</span> <span class='nv'>dist_df</span>
<span class='kr'>for</span> <span class='o'>(</span><span class='nv'>column_number</span> <span class='kr'>in</span> <span class='m'>1</span><span class='o'>:</span><span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>ncol</a></span><span class='o'>(</span><span class='nv'>dist_df</span><span class='o'>)</span><span class='o'>)</span><span class='o'>&#123;</span>
  <span class='nv'>dist_df_norm</span><span class='o'>[[</span><span class='nv'>column_number</span><span class='o'>]</span><span class='o'>]</span> <span class='o'>&lt;-</span> <span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>dist_df</span><span class='o'>[[</span><span class='nv'>column_number</span><span class='o'>]</span><span class='o'>]</span><span class='o'>)</span>
<span class='o'>&#125;</span>
<span class='nv'>dist_df_norm</span>

<span class='c'>#&gt;    dists_Mar4 dists_Mar5</span>
<span class='c'>#&gt; 1  0.04942966 0.37614679</span>
<span class='c'>#&gt; 2  0.33840304 0.63302752</span>
<span class='c'>#&gt; 3  0.19771863 0.44954128</span>
<span class='c'>#&gt; 4  0.05703422 1.00000000</span>
<span class='c'>#&gt; 5  0.65019011 0.46330275</span>
<span class='c'>#&gt; 6  0.13688213 0.05963303</span>
<span class='c'>#&gt; 7  0.24714829 0.37614679</span>
<span class='c'>#&gt; 8  1.00000000 0.30733945</span>
<span class='c'>#&gt; 9  0.00000000 0.24770642</span>
<span class='c'>#&gt; 10 0.33079848 0.00000000</span>
</code></pre>

</div>

Copying an entire data frame so we can operate on it *could* take a lot of time. So we can also create an empty data frame (of the same dimensions) and populate it:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>empty_vec</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/vector.html'>vector</a></span><span class='o'>(</span>length <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='nv'>dist_df</span><span class='o'>)</span><span class='o'>)</span>
<span class='nv'>dist_df_norm_2</span> <span class='o'>&lt;-</span> <span class='nf'>tibble</span><span class='o'>(</span>norm_Mar4 <span class='o'>=</span> <span class='nv'>empty_vec</span>, norm_Mar5 <span class='o'>=</span> <span class='nv'>empty_vec</span><span class='o'>)</span>

<span class='kr'>for</span> <span class='o'>(</span><span class='nv'>column_number</span> <span class='kr'>in</span> <span class='m'>1</span><span class='o'>:</span><span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>ncol</a></span><span class='o'>(</span><span class='nv'>dist_df</span><span class='o'>)</span><span class='o'>)</span><span class='o'>&#123;</span>
  <span class='nv'>dist_df_norm_2</span><span class='o'>[[</span><span class='nv'>column_number</span><span class='o'>]</span><span class='o'>]</span> <span class='o'>&lt;-</span> <span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>dist_df</span><span class='o'>[[</span><span class='nv'>column_number</span><span class='o'>]</span><span class='o'>]</span><span class='o'>)</span>
<span class='o'>&#125;</span>
<span class='nv'>dist_df_norm_2</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 x 2</span></span>
<span class='c'>#&gt;    norm_Mar4 norm_Mar5</span>
<span class='c'>#&gt;        <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span>    0.049</span><span style='text-decoration: underline;'>4</span><span>    0.376 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span>    0.338     0.633 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span>    0.198     0.450 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span>    0.057</span><span style='text-decoration: underline;'>0</span><span>    1     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span>    0.650     0.463 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span>    0.137     0.059</span><span style='text-decoration: underline;'>6</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span>    0.247     0.376 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span>    1         0.307 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span>    0         0.248 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span>    0.331     0</span></span>
</code></pre>

</div>

By writing our own function, we've effectively extended what R can do. And this is all that packages are: libraries of new functions that extend the capabilities of base R. In fact, if there are functions you design for your particular subject area and find yourself using all the time, you can make your own package and load it, and all your favorite functions will be right there (but that's for another day...)

## Functional programming with your own functions

We saw above that you assign the function object to a name, just as you would a vector, list or data frame. In R, functions are 'first class citizens', which means you can **pass them as an arguments to another function**. This is a very powerful idea, and the part of the program of **functional programming**.

> In functional programming, functions are treated as first-class citizens, meaning that they can be bound to names..., passed as arguments, and returned from other functions, just as any other data type can.

Functions that can take other functions arguments are sometimes referred to as **functionals**.

### `lapply()`

We saw this functional in the previous CodeClub: it always returns a list:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>lapply_norm</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/lapply.html'>lapply</a></span><span class='o'>(</span><span class='nv'>dist_df</span>, <span class='nv'>normalize</span><span class='o'>)</span>
<span class='nv'>lapply_norm</span>

<span class='c'>#&gt; $dists_Mar4</span>
<span class='c'>#&gt;  [1] 0.04942966 0.33840304 0.19771863 0.05703422 0.65019011 0.13688213</span>
<span class='c'>#&gt;  [7] 0.24714829 1.00000000 0.00000000 0.33079848</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; $dists_Mar5</span>
<span class='c'>#&gt;  [1] 0.37614679 0.63302752 0.44954128 1.00000000 0.46330275 0.05963303</span>
<span class='c'>#&gt;  [7] 0.37614679 0.30733945 0.24770642 0.00000000</span>

<span class='nf'><a href='https://rdrr.io/r/base/typeof.html'>typeof</a></span><span class='o'>(</span><span class='nv'>lapply_norm</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "list"</span>

<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>lapply_norm</span><span class='o'>)</span>

<span class='c'>#&gt; List of 2</span>
<span class='c'>#&gt;  $ dists_Mar4: num [1:10] 0.0494 0.3384 0.1977 0.057 0.6502 ...</span>
<span class='c'>#&gt;  $ dists_Mar5: num [1:10] 0.376 0.633 0.45 1 0.463 ...</span>
</code></pre>

</div>

[`sapply()`](https://rdrr.io/r/base/lapply.html) attempts to simplify the outputs. Here both lists are of type `num`, and the same length, so we could simplify to a matrix data structure of a single type:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>sapply_norm</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/lapply.html'>sapply</a></span><span class='o'>(</span><span class='nv'>dist_df</span>, <span class='nv'>normalize</span><span class='o'>)</span>
<span class='nv'>sapply_norm</span>

<span class='c'>#&gt;       dists_Mar4 dists_Mar5</span>
<span class='c'>#&gt;  [1,] 0.04942966 0.37614679</span>
<span class='c'>#&gt;  [2,] 0.33840304 0.63302752</span>
<span class='c'>#&gt;  [3,] 0.19771863 0.44954128</span>
<span class='c'>#&gt;  [4,] 0.05703422 1.00000000</span>
<span class='c'>#&gt;  [5,] 0.65019011 0.46330275</span>
<span class='c'>#&gt;  [6,] 0.13688213 0.05963303</span>
<span class='c'>#&gt;  [7,] 0.24714829 0.37614679</span>
<span class='c'>#&gt;  [8,] 1.00000000 0.30733945</span>
<span class='c'>#&gt;  [9,] 0.00000000 0.24770642</span>
<span class='c'>#&gt; [10,] 0.33079848 0.00000000</span>

<span class='nf'><a href='https://rdrr.io/r/base/typeof.html'>typeof</a></span><span class='o'>(</span><span class='nv'>sapply_norm</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "double"</span>

<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>sapply_norm</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 10  2</span>

<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>sapply_norm</span><span class='o'>)</span>

<span class='c'>#&gt;  num [1:10, 1:2] 0.0494 0.3384 0.1977 0.057 0.6502 ...</span>
<span class='c'>#&gt;  - attr(*, "dimnames")=List of 2</span>
<span class='c'>#&gt;   ..$ : NULL</span>
<span class='c'>#&gt;   ..$ : chr [1:2] "dists_Mar4" "dists_Mar5"</span>
</code></pre>

</div>

The first is a named list, the second a named matrix.

### `map()`

The functional `map()` from the **purrr** package behaves the same as [`lapply()`](https://rdrr.io/r/base/lapply.html), it always returns a list:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>map_norm</span> <span class='o'>&lt;-</span> <span class='nf'>map</span><span class='o'>(</span><span class='nv'>dist_df</span>, <span class='nv'>normalize</span><span class='o'>)</span>
<span class='nv'>map_norm</span>

<span class='c'>#&gt; $dists_Mar4</span>
<span class='c'>#&gt;  [1] 0.04942966 0.33840304 0.19771863 0.05703422 0.65019011 0.13688213</span>
<span class='c'>#&gt;  [7] 0.24714829 1.00000000 0.00000000 0.33079848</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; $dists_Mar5</span>
<span class='c'>#&gt;  [1] 0.37614679 0.63302752 0.44954128 1.00000000 0.46330275 0.05963303</span>
<span class='c'>#&gt;  [7] 0.37614679 0.30733945 0.24770642 0.00000000</span>

<span class='nf'><a href='https://rdrr.io/r/base/typeof.html'>typeof</a></span><span class='o'>(</span><span class='nv'>map_norm</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "list"</span>

<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>map_norm</span><span class='o'>)</span>

<span class='c'>#&gt; List of 2</span>
<span class='c'>#&gt;  $ dists_Mar4: num [1:10] 0.0494 0.3384 0.1977 0.057 0.6502 ...</span>
<span class='c'>#&gt;  $ dists_Mar5: num [1:10] 0.376 0.633 0.45 1 0.463 ...</span>
</code></pre>

</div>

Notice another advantage of both [`lapply()`](https://rdrr.io/r/base/lapply.html) and `map()` *we don't need to explicitly preallocate any kind of data structure to collect the results*. The allocation is done behind the scenes as part of the implementation of [`lapply()`](https://rdrr.io/r/base/lapply.html) and `map()`, which makes sure they run efficiently. In fact, R implements these functionals as a `for` loop behind the scenes, and in `map()` that `for` loop is implemented in C, so it optimizes performance.

If we want the output to be a data frame to match the input, we can simply **coerce** it:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>map_norm_df</span> <span class='o'>&lt;-</span> <span class='nf'>map</span><span class='o'>(</span><span class='nv'>dist_df</span>, <span class='nv'>normalize</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nv'>as_tibble</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>map_norm_df</span><span class='o'>)</span>

<span class='c'>#&gt; tibble [10 × 2] (S3: tbl_df/tbl/data.frame)</span>
<span class='c'>#&gt;  $ dists_Mar4: num [1:10] 0.0494 0.3384 0.1977 0.057 0.6502 ...</span>
<span class='c'>#&gt;  $ dists_Mar5: num [1:10] 0.376 0.633 0.45 1 0.463 ...</span>
</code></pre>

</div>

### Advantages of using functions

Functions:

-   avoid duplication, save time
-   avoid coding errors in repetitive code
-   localize variables, avoiding unexpected assignment surprises
-   let you modify code in a single place, not multiple places
-   lets you reuse code, since a single function can often be used on multiple inputs (vectors, lists and data frames), and can be imported from a package, instead of copy and paste.

