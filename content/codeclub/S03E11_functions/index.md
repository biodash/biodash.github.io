---
title: "Session S03E11: Writing your own Functions"
summary: "In this session of Code Club, we'll look at how to avoid repeating yourself in another way by writing your own functions."
authors: [michael-broe]
date: "2022-03-28"
output: hugodown::md_document
toc: true
image: 
  caption: ""
  focal_point: ""
  preview_only: false
editor_options: 
  markdown: 
    wrap: 72
rmd_hash: 6436138db4d6885b

---

<br> <br> <br>

------------------------------------------------------------------------

## New To Code Club?

-   First, check out the [Code Club Computer Setup](/codeclub-setup/) instructions, which also has some pointers that might be helpful if you're new to R or RStudio.

-   Please open RStudio before Code Club to test things out -- if you run into issues, join the Zoom call early and we'll troubleshoot.

------------------------------------------------------------------------

## Session Goals

-   Learn the basic **template** of a function in R.
-   Learn another way to avoid repetition in your code by creating your own functions.
-   Learn all the advantages of using functions instead of copied code blocks.

------------------------------------------------------------------------

We'll be using [`tibble()`](https://tibble.tidyverse.org/reference/tibble.html) from the tidyverse package, so we need to load that first.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
<span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching packages</span> ─────────────────────────────────────── tidyverse 1.3.1 ──</span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>ggplot2</span> 3.3.5     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>purrr  </span> 0.3.4</span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tibble </span> 3.1.6     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>dplyr  </span> 1.0.8</span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tidyr  </span> 1.2.0     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>stringr</span> 1.4.0</span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>readr  </span> 2.1.2     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>forcats</span> 0.5.1</span>
<span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span> ────────────────────────────────────────── tidyverse_conflicts() ──</span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>filter()</span> masks <span style='color: #0000BB;'>stats</span>::filter()</span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>lag()</span>    masks <span style='color: #0000BB;'>stats</span>::lag()</span></code></pre>

</div>

## What is an R function?

A good way to understand this is to translate knowledge you already have from math directly into R. 'Once upon a time' you probably met something like this:

$$y = 2x +3$$

which relates an `expression` involving $x$ (on the right hand side) to an equivalent value $y$.

In mathematics, a function is just a 'rule' that relates `inputs` to `outputs` (with certain constraints).

Later you may have come across this formulation:

$$f(x) = 2x +3$$

Now the function has a name `f()` (not a particularly good one, however).

You probably recall that $x$ is called the `argument` of the function. So how do we translate this into R?

The crucial thing here is the R `function()` operator:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>f</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span> <span class='o'>&#123;</span>
  <span class='o'>(</span><span class='m'>2</span> <span class='o'>*</span> <span class='nv'>x</span><span class='o'>)</span>  <span class='o'>+</span> <span class='m'>3</span>
<span class='o'>&#125;</span></code></pre>

</div>

We **define** the function using this `function()` operator, and also **assign** the function to a name (here `f`) using \<-, just like assigning any other value to an object. This means that now `f` is a function object: just like you create vector objects, or lists, or data frame objects, when you assign them to names. Notice too that in RStudio they appear in the Global Environment in a special 'Functions' section, and clicking on them shows the code of the function. This means that if you have a large file with many functions defined, you don't have to go back searching for the function definition in the code itself.

**Terminology** (gotta have it!)

`x` here is also called the **argument** to the function. In this case there is just one, there could be more.

The expression inside the curly braces: $(2 * x) + 3$, is called the **body** of the function.

Here is the basic template of any function in R:

``` r
name <- function(arg1, arg2...) {
  <body>
}
```

The arguments go inside (...). The body is the block of code you want to reuse, and it's contained in curly brackets {...}.

Giving good names to functions can be tricky. You to don't want to be too explicit, and you don't want to be too terse (`f()` is too terse, btw). We'll return to this below when we write fancier functions.

But now we want to actually use the function to compute an output: this is termed **calling** the function, by **passing in** a specific value. That specific value gets **assigned** to the argument inside the function.

Here is a trivial example, assigning the value $1$ to the argument:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>f</span><span class='o'>(</span><span class='m'>1</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 5</span></code></pre>

</div>

So *after* calling the function in this way `x` is instantiated to `1`, and what is really happening is:

``` r
f <- function(1) {
  (2 * 1)  + 3
}
```

Easy-peasy.

But wait! if you simply call a function, its **output** (which you are probably interested in) just goes away. If you want to save the output of the function, to be used later, you need to *assign the output to a variable*:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>my_output</span> <span class='o'>&lt;-</span> <span class='nf'>f</span><span class='o'>(</span><span class='m'>1</span><span class='o'>)</span>
<span class='nv'>my_output</span>
<span class='c'>#&gt; [1] 5</span></code></pre>

</div>

This variable will now appear in the Values section of your Environment pane in RStudio, and can be reused in your subsequent code.

But wait! remember R data-structures? What if we pass in a vector as the argument?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>f</span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1</span>, <span class='m'>2</span>, <span class='m'>3</span>, <span class='m'>4</span>, <span class='m'>5</span><span class='o'>)</span><span class='o'>)</span>
<span class='c'>#&gt; [1]  5  7  9 11 13</span></code></pre>

</div>

Woohoo! In R, the functions you write yourself are also automagically 'vectorized': vector in, vector out.

But wait! how about a list???

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>f</span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='m'>1</span>, <span class='m'>2</span>, <span class='m'>3</span>, <span class='m'>4</span>, <span class='m'>5</span><span class='o'>)</span><span class='o'>)</span>
<span class='c'>#&gt; Error in 2 * x: non-numeric argument to binary operator</span></code></pre>

</div>

Whoops! Looks like R is vectorized over vectors :). If we want to process our new function over a list we'll have to do something more fancy, like a for-loop. We'll see how to incorporate our own functions into for-loops, building on previous sessions, next week.

## Breakout rooms, write your own functions

### Exercise 1

<div class="puzzle">

Write a function from scratch that computes the square of a single input. Give it a sensible name, and run it on some test input numbers to make sure it works.

Make sure to look in the Functions pane of the RStudio Environment tab to check it is assigned correctly.

Is your function vectorized? Run it on a simple vector argument to check.

<details>
<summary>
Hints (click here)
</summary>
<br>The relevant R exponentiation operator is `**`. <br>
</details>

<br>

<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>square</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span><span class='o'>&#123;</span>
  <span class='nv'>x</span> <span class='o'>**</span> <span class='m'>2</span>
<span class='o'>&#125;</span>

<span class='nf'>square</span><span class='o'>(</span><span class='m'>2</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 4</span>
<span class='nf'>square</span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1</span>, <span class='m'>2</span>, <span class='m'>3</span>, <span class='m'>4</span><span class='o'>)</span><span class='o'>)</span>
<span class='c'>#&gt; [1]  1  4  9 16</span></code></pre>

</div>

<br>

</details>

</div>

### Exercise 2

<div class="puzzle">

The function in Exercise 1 has a single argument, the base, and raises it to the exponent 2.

Write a function with two arguments, which includes both a base and exponent and try it out.

Is your function vectorized? Run it on a simple base vector to check.

Bonus: is it vectorized on both the base and the exponent?

<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>exponential</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>b</span>, <span class='nv'>e</span><span class='o'>)</span><span class='o'>&#123;</span>
  <span class='nv'>b</span> <span class='o'>**</span> <span class='nv'>e</span>
<span class='o'>&#125;</span>

<span class='nf'>exponential</span><span class='o'>(</span><span class='m'>2</span>, <span class='m'>10</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 1024</span>
<span class='nf'>exponential</span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1</span>, <span class='m'>2</span>, <span class='m'>3</span>, <span class='m'>4</span><span class='o'>)</span>, <span class='m'>10</span><span class='o'>)</span>
<span class='c'>#&gt; [1]       1    1024   59049 1048576</span>
<span class='nf'>exponential</span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1</span>, <span class='m'>2</span>, <span class='m'>3</span>, <span class='m'>4</span><span class='o'>)</span>, <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1</span>, <span class='m'>2</span>, <span class='m'>3</span>, <span class='m'>4</span><span class='o'>)</span><span class='o'>)</span>
<span class='c'>#&gt; [1]   1   4  27 256</span>
<span class='nf'>exponential</span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1</span>, <span class='m'>2</span>, <span class='m'>3</span>, <span class='m'>4</span><span class='o'>)</span>, <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1</span>, <span class='m'>2</span><span class='o'>)</span><span class='o'>)</span>
<span class='c'>#&gt; [1]  1  4  3 16</span></code></pre>

</div>

<br>

</details>

</div>

### Exercise 3

<div class="puzzle">

R does not have a built-in function for calculating the [coefficient of variation](https://en.m.wikipedia.org/wiki/Coefficient_of_variation), aka the **RSD** (relative standard deviation). This is defined as *the ratio of the standard deviation to the mean*.

Create a function that computes this, and test it on a couple of vectors.

<details>
<summary>
Hints (click here)
</summary>
<br>The relevant R built-in functions are <code>sd()</code> and <code>mean()</code>. The function should have one argument, which is assumed to be a vector. <br>
</details>

<br>

<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>coefficient_of_variation</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>v</span><span class='o'>)</span><span class='o'>&#123;</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/sd.html'>sd</a></span><span class='o'>(</span><span class='nv'>v</span><span class='o'>)</span><span class='o'>/</span><span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>v</span><span class='o'>)</span>
<span class='o'>&#125;</span>

<span class='nf'>coefficient_of_variation</span><span class='o'>(</span><span class='m'>1</span><span class='o'>:</span><span class='m'>10</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 0.5504819</span>
<span class='nf'>coefficient_of_variation</span><span class='o'>(</span><span class='m'>15</span><span class='o'>:</span><span class='m'>175</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 0.4907454</span></code></pre>

</div>

<br>

</details>

</div>

------------------------------------------------------------------------

## Why write functions? (Spoiler alert, DRY...)

### Copying your code is *not good*

The first motivation for writing a function is when you find yourself cut-and-pasting code blocks with slight alterations each time.

Say we have the following toy tidyverse data frame, where each column is a vector of 10 random numbers from a normal distribution, with `mean = 0` and `sd = 1` (the defaults for `rnorm`):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://tibble.tidyverse.org/reference/tibble.html'>tibble</a></span><span class='o'>(</span>
  a <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/stats/Normal.html'>rnorm</a></span><span class='o'>(</span><span class='m'>10</span><span class='o'>)</span>,
  b <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/stats/Normal.html'>rnorm</a></span><span class='o'>(</span><span class='m'>10</span><span class='o'>)</span>,
  c <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/stats/Normal.html'>rnorm</a></span><span class='o'>(</span><span class='m'>10</span><span class='o'>)</span>,
  d <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/stats/Normal.html'>rnorm</a></span><span class='o'>(</span><span class='m'>10</span><span class='o'>)</span>
<span class='o'>)</span>

<span class='nv'>df</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 4</span></span>
<span class='c'>#&gt;          a       b       c      d</span>
<span class='c'>#&gt;      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span> -<span style='color: #BB0000;'>1.88</span>    0.727  -<span style='color: #BB0000;'>0.468</span>   1.27 </span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span>  0.039<span style='text-decoration: underline;'>9</span> -<span style='color: #BB0000;'>0.789</span>  -<span style='color: #BB0000;'>2.41</span>    0.376</span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span> -<span style='color: #BB0000;'>0.410</span>   1.86    1.05   -<span style='color: #BB0000;'>0.618</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span> -<span style='color: #BB0000;'>0.266</span>  -<span style='color: #BB0000;'>0.204</span>  -<span style='color: #BB0000;'>0.715</span>   0.279</span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span>  0.244  -<span style='color: #BB0000;'>0.067</span><span style='color: #BB0000; text-decoration: underline;'>3</span>  0.884  -<span style='color: #BB0000;'>0.340</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span>  0.064<span style='text-decoration: underline;'>5</span> -<span style='color: #BB0000;'>1.09</span>    0.152  -<span style='color: #BB0000;'>0.840</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span>  0.749  -<span style='color: #BB0000;'>0.494</span>   0.681   0.341</span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span> -<span style='color: #BB0000;'>1.35</span>    0.208   0.077<span style='text-decoration: underline;'>6</span>  2.15 </span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span> -<span style='color: #BB0000;'>1.17</span>    0.088<span style='text-decoration: underline;'>3</span> -<span style='color: #BB0000;'>0.829</span>  -<span style='color: #BB0000;'>0.174</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span>  0.733   1.05    0.808   0.190</span></code></pre>

</div>

In previous Code Clubs we've seen how you can apply a built-in function like `mean` to each column using a `for` loop or `lapply`. But say we wanted to do something a bit fancier that is not part of core R. For example, we can *normalize* the values in a column so they range from 0 to 1 using the following code block:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>/</span> <span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span><span class='o'>)</span>
<span class='c'>#&gt;  [1] 0.0000000 0.7297073 0.5582684 0.6132731 0.8073051 0.7390605 1.0000000</span>
<span class='c'>#&gt;  [8] 0.1988908 0.2699569 0.9939179</span></code></pre>

</div>

This code is a literal translation of the mathematical formula for normalization:

$$z_{i} = \frac{x_{i} - min(x)}{max(x)-min(x)}$$

OK, so how can we do this for each column? Here is a first attempt:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span> <span class='o'>&lt;-</span> <span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>/</span> <span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span><span class='o'>)</span>
<span class='nv'>df</span><span class='o'>$</span><span class='nv'>b</span> <span class='o'>&lt;-</span> <span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>b</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>/</span> <span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>b</span><span class='o'>)</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>b</span><span class='o'>)</span><span class='o'>)</span>
<span class='nv'>df</span><span class='o'>$</span><span class='nv'>c</span> <span class='o'>&lt;-</span> <span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>c</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>c</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>/</span> <span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>c</span><span class='o'>)</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>c</span><span class='o'>)</span><span class='o'>)</span>
<span class='nv'>df</span><span class='o'>$</span><span class='nv'>d</span> <span class='o'>&lt;-</span> <span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>d</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>d</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>/</span> <span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>d</span><span class='o'>)</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>d</span><span class='o'>)</span><span class='o'>)</span>

<span class='nv'>df</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 4</span></span>
<span class='c'>#&gt;        a       b     c      d</span>
<span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span> 0      0.246  0.562 0.706 </span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span> 0.730 -<span style='color: #BB0000;'>0.267</span>  0     0.407 </span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span> 0.558  0.630  1     0.074<span style='text-decoration: underline;'>6</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span> 0.613 -<span style='color: #BB0000;'>0.069</span><span style='color: #BB0000; text-decoration: underline;'>1</span> 0.490 0.375 </span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span> 0.807 -<span style='color: #BB0000;'>0.022</span><span style='color: #BB0000; text-decoration: underline;'>8</span> 0.952 0.168 </span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span> 0.739 -<span style='color: #BB0000;'>0.370</span>  0.741 0     </span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span> 1     -<span style='color: #BB0000;'>0.167</span>  0.894 0.396 </span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span> 0.199  0.070<span style='text-decoration: underline;'>5</span> 0.719 1     </span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span> 0.270  0.029<span style='text-decoration: underline;'>9</span> 0.458 0.223 </span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span> 0.994  0.356  0.930 0.345</span></code></pre>

</div>

This works, but it caused me mental anguish to type it out. Even with cut and paste! All those manual textual substitutions!! And manual data entry is prone to mistakes, especially repetitive tasks like this. And say you had 1,000 columns...

**And it didn't work!!** Honestly, I swear that mistake was totally real: I didn't notice it until I looked at the output. Can you spot the mistake?

It turns out R has a `range` function that returns the minimum and maximum of a vector, which somewhat simplifies the coding:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/range.html'>range</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span></code></pre>

</div>

The result is a vector like `c(-1.2129504, 2.1011248)` (it varies run to run, since the columns values are random) which we can then index, and so we only do the min/max computation once for each column, instead of three times, so we get the following block of code for each column:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>rng</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/range.html'>range</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span>
<span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span> <span class='o'>-</span> <span class='nv'>rng</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>)</span> <span class='o'>/</span> <span class='o'>(</span><span class='nv'>rng</span><span class='o'>[</span><span class='m'>2</span><span class='o'>]</span> <span class='o'>-</span> <span class='nv'>rng</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>)</span></code></pre>

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
<span class='nv'>df</span><span class='o'>$</span><span class='nv'>d</span> <span class='o'>&lt;-</span> <span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>d</span> <span class='o'>-</span> <span class='nv'>rng</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>)</span> <span class='o'>/</span> <span class='o'>(</span><span class='nv'>rng</span><span class='o'>[</span><span class='m'>2</span><span class='o'>]</span> <span class='o'>-</span> <span class='nv'>rng</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>)</span></code></pre>

</div>

Still pretty horrible, and arguably worse since we add a line for each column.

How can we distill this into a function to avoid all that repetition?

### Encapsulation of code in a function

The secret to function writing is abstracting the *constant* from the *variable*. (Using the `range` function does throw into sharper relief what is constant and what is varying at least.) The constant part is the **body** of the function: the template or boiler-plate you use over and over again. The variable parts are the **arguments** of the function.

Here's what it looks like in this case:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>normalize</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span> <span class='o'>&#123;</span>
  <span class='nv'>rng</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/range.html'>range</a></span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span>
  <span class='o'>(</span><span class='nv'>x</span> <span class='o'>-</span> <span class='nv'>rng</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>)</span> <span class='o'>/</span> <span class='o'>(</span><span class='nv'>rng</span><span class='o'>[</span><span class='m'>2</span><span class='o'>]</span> <span class='o'>-</span> <span class='nv'>rng</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>)</span>
<span class='o'>&#125;</span></code></pre>

</div>

Pretty cool, right? Here `normalize` is the descriptive name we give the function.

In the current case the argument of our function is a column vector pulled from the data frame. But we can potentially use this function on *any* vector, so let's not be too specific. The more generally you can write your function, the more useful it will be.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>test_vec</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>3</span>, <span class='m'>7</span>, <span class='nv'>pi</span>, <span class='m'>8.657</span>, <span class='m'>80</span><span class='o'>)</span>
<span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>test_vec</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 0.000000000 0.051948052 0.001838866 0.073467532 1.000000000</span></code></pre>

</div>

A couple of things to note:

-   Including that extra line `rng <- range(x)` is no longer a problem, since we just type it once. If you are typing things out over and over you might prefer brevity. *When you write a function, you should prefer clarity.* It's good practice to break the the function down into logical steps, and name them properly. It's much easier for others to 'read' your function, and much easier for you when you come back to it in a couple of years. This is the principle of making your code 'self-annotated'.

-   Functions should be simple, clear, and do *one thing well*. You create programs by combining simple functions in a modular manner.

Our original horrible code can now be rewritten as:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span> <span class='o'>&lt;-</span> <span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span>
<span class='nv'>df</span><span class='o'>$</span><span class='nv'>b</span> <span class='o'>&lt;-</span> <span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>b</span><span class='o'>)</span>
<span class='nv'>df</span><span class='o'>$</span><span class='nv'>c</span> <span class='o'>&lt;-</span> <span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>c</span><span class='o'>)</span>
<span class='nv'>df</span><span class='o'>$</span><span class='nv'>d</span> <span class='o'>&lt;-</span> <span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>d</span><span class='o'>)</span></code></pre>

</div>

Which is an improvement, but the real power comes from the fact that we can use our new function in `for` loops and `apply` statements. We'll see how to do that next week.

By writing our own functions, we've effectively extended what R can do. And this is all that packages are: libraries of new functions that extend the capabilities of base R. In fact, if there are functions you design for your particular subject area and find yourself using all the time, you can make your own package and load it, and all your favorite functions will be right there (but that's for another day...)

### Exercise 4: Functions are not just for arithmetic!

<div class="puzzle">

The [fastq](https://en.m.wikipedia.org/wiki/FASTQ_format) file format for DNA sequencing uses a letter/punctuation code for the *quality of the base* called at each position (the fourth line below) which is in one-to-one relationship to the bases in the second line:

    @SIM:1:FCX:1:15:6329:1045 1:N:0:2
    TCGCACTCAACGCCCTGCATATGACAAGACAGAATC
    +
    <>;##=><9=AAAAAAAAAA9#:<#<;<<<????#=

To translate a letter code into a numerical [phred quality score](https://en.m.wikipedia.org/wiki/Phred_quality_score) we have to do two things: (i) translate the **character** to an **integer** using the [ASCII code](http://www.asciitable.com) look up table (ii) subtract 33 from that value (!). (High scores are good).

For the first step, R has a built-in function that converts a character into an integer according to that table, for example:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/utf8Conversion.html'>utf8ToInt</a></span><span class='o'>(</span><span class='s'>"!"</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 33</span></code></pre>

</div>

Write a function `phred_score()` that computes the phred score for any character. Check that it returns 0 for "!".

Is this function vectorized? Apply your function to our example string:

`<>;##=><9=AAAAAAAAAA9#:<#<;<<<????#=`

to convert it to a vector of phred quality scores.

<details>
<summary>
Hints (click here)
</summary>

<br>Remember when you pass the value to this function it has to be an *R character string*, which needs to be surrounded by quotes.

<br>
</details>

<br>

<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>phred_score</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>character</span><span class='o'>)</span><span class='o'>&#123;</span>
  <span class='nf'><a href='https://rdrr.io/r/base/utf8Conversion.html'>utf8ToInt</a></span><span class='o'>(</span><span class='nv'>character</span><span class='o'>)</span> <span class='o'>-</span> <span class='m'>33</span>
<span class='o'>&#125;</span>

<span class='nf'>phred_score</span><span class='o'>(</span><span class='s'>"!"</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 0</span>
<span class='nf'>phred_score</span><span class='o'>(</span><span class='s'>"&lt;&gt;;##=&gt;&lt;9=AAAAAAAAAA9#:&lt;#&lt;;&lt;&lt;&lt;????#="</span><span class='o'>)</span>
<span class='c'>#&gt;  [1] 27 29 26  2  2 28 29 27 24 28 32 32 32 32 32 32 32 32 32 32 24  2 25 27  2</span>
<span class='c'>#&gt; [26] 27 26 27 27 27 30 30 30 30  2 28</span></code></pre>

</div>

Note: "!" is the first **printing character** in the ASCII table. The characters 0 through 32 were used historically to control the behavior of teleprinters: "the original ASCII specification included 33 non-printing control codes which originated with Teletype machines; most of these are now obsolete". If the ASCII table started with "!" instead of `NUL` we wouldn't need the correction of subtracting 33, and "!" would translate to 0. <br>

</details>

</div>

------------------------------------------------------------------------

