---
output: hugodown::md_document
title: "S03E07: Avoid Copy-pasting Code - Intro and Vectorization"
subtitle: "How to repeat operations without repeating your code"
summary: "In this first session on strategies for repeating operations without copy-pasting your code, we will focus on vectorization."
authors: [admin]
tags: [codeclub, iteration]
date: "2022-02-22"
lastmod: "2022-02-22"
toc: true

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: "Artwork by @allison_horst"
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
rmd_hash: f73d9afdeb21fb89

---

<br> <br> <br>

------------------------------------------------------------------------

## Housekeeping

#### New to Code Club?

Check out the [Code Club Computer Setup](/codeclub-setup/) instructions, which also has pointers for if you're new to R or RStudio.

#### Session goals

Today, you will learn:

-   That you should avoid copy-pasting your code
-   Which alternatives to repeating yourself exist in R
-   What *vectorization* is and how to make use of it

#### R packages we will use

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>## If necessary, install the packages we will use</span>
<span class='kr'>if</span> <span class='o'>(</span><span class='o'>!</span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>require</a></span><span class='o'>(</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/'>palmerpenguins</a></span><span class='o'>)</span><span class='o'>)</span> <span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"palmerpenguins"</span><span class='o'>)</span>
<span class='kr'>if</span> <span class='o'>(</span><span class='o'>!</span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>require</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span><span class='o'>)</span> <span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"tidyverse"</span><span class='o'>)</span>
<span class='kr'>if</span> <span class='o'>(</span><span class='o'>!</span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>require</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/tidyverse/glue'>glue</a></span><span class='o'>)</span><span class='o'>)</span> <span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"glue"</span><span class='o'>)</span>

<span class='c'>## Load the packages we will use</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/'>palmerpenguins</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/tidyverse/glue'>glue</a></span><span class='o'>)</span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## I -- Avoid copy-pasting code

#### Don't Repeat Yourself (DRY)

Sometimes, you have a bit of code, and you need to repeat the operations in that code *almost* exactly.

This can apply to anywhere from a single line to dozens of lines of code. For instance, you may want to rerun a statistical model with different parameter values, or repeat an analysis for different batches or subsets of samples. In the context of our trusty penguins dataset, we may want to repeat an analysis for each of the 4 morphological measurements.

Your first instinct is perhaps to copy-paste your code several times, and make the necessary slight adjustments in each instance. There are problems with this approach, including:

-   You will end up with a lot of code, reducing clarity and making it more error-prone

-   Making changes to the parts of the code shared by all blocks becomes challenging.

Avoiding such code repetition is where the programming mantra "Don't Repeat Yourself" ("DRY") comes from.

<br>

#### Alternatives to repeating yourself

So what are the alternatives?

In R, two key approaches to avoiding copy-pasting your code are to use *iteration* to repeat a procedure, and you can do so either:

-   Using a ***loop***

-   Using ***"functional programming"***: apply a function multiple times with special functions ("functionals") from the base R `apply`-family or *purrr*'s `map`-family.

Loops are especially useful if you have a whole block of code that needs to be rerun, while functionals are easier to apply when you need to rerun a single function call.

Furthermore, you can avoid code repetition by:

-   ***Writing your own functions*** (using *arguments* to make them flexible)

-   In simple cases, making use of R's ***vectorization*** capabilities.

These approaches are clearer, less error-prone, and more flexible than copy-pasting code. They can also be combined.

**We will tackle all of these approaches in Code Club in the upcoming weeks, starting with vectorization this week.**

<br>

#### But first, an iteration example

Below, I will give a quick example of each of the two iteration approaches: a loop and a functional. Hopefully, this will be illustrative even if you don't understand all the details: come back in the next few weeks to learn more about this!

Say that we wanted to compute the mean for each of the 4 measurements for each penguin: bill length, bill depth, flipper length, and body mass.

To do this, we could write:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>$</span><span class='nv'>bill_length_mm</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 43.92193</span>
<span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>$</span><span class='nv'>bill_depth_mm</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 17.15117</span>
<span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>$</span><span class='nv'>flipper_length_mm</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 200.9152</span>
<span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>$</span><span class='nv'>body_mass_g</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 4201.754</span></code></pre>

</div>

But that is a bit repetitive. And it would get especially so if we had 20 different measurements. Or if, instead of just computing the mean, we wanted to perform an analysis consisting of multiple steps.

What would it look like to use iteration in a case like this?

-   With a `for` loop:
    <div class="highlight">

    <pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>## The columns we are interested in are columns 3 through 6 (3:6)</span>
    <span class='c'>## We can extract each column with the `[[...]]` notation we saw last week</span>
    <span class='kr'>for</span> <span class='o'>(</span><span class='nv'>column_index</span> <span class='kr'>in</span> <span class='m'>3</span><span class='o'>:</span><span class='m'>6</span><span class='o'>)</span> <span class='o'>&#123;</span>
      <span class='nv'>column_mean</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>[[</span><span class='nv'>column_index</span><span class='o'>]</span><span class='o'>]</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
      <span class='nf'><a href='https://rdrr.io/r/base/print.html'>print</a></span><span class='o'>(</span><span class='nv'>column_mean</span><span class='o'>)</span>
    <span class='o'>&#125;</span>
    <span class='c'>#&gt; [1] 43.92193</span>
    <span class='c'>#&gt; [1] 17.15117</span>
    <span class='c'>#&gt; [1] 200.9152</span>
    <span class='c'>#&gt; [1] 4201.754</span></code></pre>

    </div>
-   With *purrr*'s `map()` function:
    <div class="highlight">

    <pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
      <span class='nf'>select</span><span class='o'>(</span><span class='m'>3</span><span class='o'>:</span><span class='m'>6</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
      <span class='nf'>map</span><span class='o'>(</span><span class='nv'>mean</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
    <span class='c'>#&gt; $bill_length_mm</span>
    <span class='c'>#&gt; [1] 43.92193</span>
    <span class='c'>#&gt; </span>
    <span class='c'>#&gt; $bill_depth_mm</span>
    <span class='c'>#&gt; [1] 17.15117</span>
    <span class='c'>#&gt; </span>
    <span class='c'>#&gt; $flipper_length_mm</span>
    <span class='c'>#&gt; [1] 200.9152</span>
    <span class='c'>#&gt; </span>
    <span class='c'>#&gt; $body_mass_g</span>
    <span class='c'>#&gt; [1] 4201.754</span></code></pre>

    </div>

<div class="alert alert-note">

<div>

In this simple example where we are working with a dataframe, a specialized *dplyr* approach with `across()` also works:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins</span> <span class='o'>%&gt;%</span> <span class='nf'>summarise</span><span class='o'>(</span><span class='nf'>across</span><span class='o'>(</span><span class='m'>3</span><span class='o'>:</span><span class='m'>6</span>, <span class='nv'>mean</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1 × 4</span></span>
<span class='c'>#&gt;   bill_length_mm bill_depth_mm flipper_length_mm body_mass_g</span>
<span class='c'>#&gt;            <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>             <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span>           43.9          17.2              201.       <span style='text-decoration: underline;'>4</span>202.</span></code></pre>

</div>

</div>

</div>

<br>

#### What about vectorization?

While iteration using loops or functionals is very useful, in R, we don't need to use these strategies as much as in other languages. The main reason for this is that R often makes use of *vectorization*.

To illustrate vectorization, we'll work with a vector of bill lengths that we extract from the penguins dataframe (though as we'll see later, all of this works in dataframes, too):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>## Remove rows with NAs:</span>
<span class='nv'>penguins_noNA</span> <span class='o'>&lt;-</span> <span class='nf'>drop_na</span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>)</span>              

<span class='c'>## Extract a column with `$`, then take the first 10 values: </span>
<span class='nv'>bill_len</span> <span class='o'>&lt;-</span> <span class='nv'>penguins_noNA</span><span class='o'>$</span><span class='nv'>bill_length_mm</span><span class='o'>[</span><span class='m'>1</span><span class='o'>:</span><span class='m'>10</span><span class='o'>]</span>

<span class='nv'>bill_len</span>
<span class='c'>#&gt;  [1] 39.1 39.5 40.3 36.7 39.3 38.9 39.2 41.1 38.6 34.6</span></code></pre>

</div>

Say that we wanted to convert each value in the `bill_len` vector from millimeters to inches. Would we need to multiply each individual value by 0.0393701?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_len</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span> <span class='o'>*</span> <span class='m'>0.0393701</span>
<span class='c'>#&gt; [1] 1.539371</span>
<span class='nv'>bill_len</span><span class='o'>[</span><span class='m'>2</span><span class='o'>]</span> <span class='o'>*</span> <span class='m'>0.0393701</span>
<span class='c'>#&gt; [1] 1.555119</span>
<span class='nv'>bill_len</span><span class='o'>[</span><span class='m'>3</span><span class='o'>]</span> <span class='o'>*</span> <span class='m'>0.0393701</span>
<span class='c'>#&gt; [1] 1.586615</span>

<span class='c'># And so on...</span></code></pre>

</div>

Or should we resort to a loop or a `map()`-type function here? Fortunately, none of this is necessary! You may already know that in R, you can simply do:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_len</span> <span class='o'>*</span> <span class='m'>0.0393701</span>
<span class='c'>#&gt;  [1] 1.539371 1.555119 1.586615 1.444883 1.547245 1.531497 1.543308 1.618111</span>
<span class='c'>#&gt;  [9] 1.519686 1.362205</span></code></pre>

</div>

Similarly, say that we wanted to log-transform every value in the vector, then we can just use the [`log()`](https://rdrr.io/r/base/Log.html) function once for the entire vector:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/Log.html'>log</a></span><span class='o'>(</span><span class='nv'>bill_len</span><span class='o'>)</span>
<span class='c'>#&gt;  [1] 3.666122 3.676301 3.696351 3.602777 3.671225 3.660994 3.668677 3.716008</span>
<span class='c'>#&gt;  [9] 3.653252 3.543854</span></code></pre>

</div>

If you knew about this, perhaps you didn't even think of much of it? Actually, it is worth dwelling on this capability, which is called *vectorization* and is a pretty unique feature of the R language. In many other languages, you would in fact write a loop to transform each individual value.

So let's learn a bit more about vectorization.

<br>

------------------------------------------------------------------------

## II -- Vectorization patterns

### A vector and a "scalar"

When we multiplied the value `0.0393701` with the vector `bill_len`, `0.0393701` was automatically recycled as many times as needed to be multiplied with *each individual value* in the `bill_len` vector.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_len</span>
<span class='c'>#&gt;  [1] 39.1 39.5 40.3 36.7 39.3 38.9 39.2 41.1 38.6 34.6</span>

<span class='nv'>bill_len</span> <span class='o'>*</span> <span class='m'>0.0393701</span>
<span class='c'>#&gt;  [1] 1.539371 1.555119 1.586615 1.444883 1.547245 1.531497 1.543308 1.618111</span>
<span class='c'>#&gt;  [9] 1.519686 1.362205</span></code></pre>

</div>

(A single value like `0.0393701` is often called a "scalar" or a variable, but in R it is really a vector of length 1.)

As mentioned, you would write a loop to do this in many other languages, and in fact, under the hood, R *also* uses a loop to do this!

Vectorization is very useful for two reasons:

-   *You* don't have to write the loop (or another iteration construct), which saves you a fair bit of typing and makes the code clearer.

-   The under-the-hood-loop is being executed *much* faster than a loop that you would write with R code, because it is written in `C`/`C++`.

### Vectors of equal length

We can also use vectorized operations when both vectors contain multiple items. For instance, say we want to get the ratio of bill length to bill depth for each penguin:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>## Like above with bill length, we create a vector with 10 bill depths:</span>
<span class='nv'>bill_dp</span> <span class='o'>&lt;-</span> <span class='nv'>penguins_noNA</span><span class='o'>$</span><span class='nv'>bill_depth_mm</span><span class='o'>[</span><span class='m'>1</span><span class='o'>:</span><span class='m'>10</span><span class='o'>]</span>

<span class='c'>## We compute the ratio:</span>
<span class='nv'>bill_len</span> <span class='o'>/</span> <span class='nv'>bill_dp</span>
<span class='c'>#&gt;  [1] 2.090909 2.270115 2.238889 1.901554 1.907767 2.185393 2.000000 2.335227</span>
<span class='c'>#&gt;  [9] 1.820755 1.639810</span>

<span class='nv'>bill_len</span>
<span class='c'>#&gt;  [1] 39.1 39.5 40.3 36.7 39.3 38.9 39.2 41.1 38.6 34.6</span>
<span class='nv'>bill_dp</span>
<span class='c'>#&gt;  [1] 18.7 17.4 18.0 19.3 20.6 17.8 19.6 17.6 21.2 21.1</span></code></pre>

</div>

What happened here is that the first value is `bill_len` was divided by the first value in `bill_dp`, the second value in `bill_len` by the second value in `bill_dp`, and so forth.

This also works directly for the columns of a data frame:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_ratio</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span><span class='o'>$</span><span class='nv'>bill_length_mm</span> <span class='o'>/</span> <span class='nv'>penguins</span><span class='o'>$</span><span class='nv'>bill_depth_mm</span>

<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>bill_ratio</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 2.090909 2.270115 2.238889       NA 1.901554 1.907767</span></code></pre>

</div>

In the above examples, both vectors had the same length. In Exercise 1, you'll see that vectorization also works with two vectors with multiple values that *differ in length*.

### Vectorized functions

Above, we already briefly saw that we can simply pass a vector to the [`log()`](https://rdrr.io/r/base/Log.html) function and it will compute the log for each of them and return a vector of the same length.

So, the [`log()`](https://rdrr.io/r/base/Log.html) function works the same regardless of whether you pass a single value or a vector with multiple values:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/Log.html'>log</a></span><span class='o'>(</span><span class='m'>21</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 3.044522</span>

<span class='nf'><a href='https://rdrr.io/r/base/Log.html'>log</a></span><span class='o'>(</span><span class='nv'>bill_len</span><span class='o'>)</span>
<span class='c'>#&gt;  [1] 3.666122 3.676301 3.696351 3.602777 3.671225 3.660994 3.668677 3.716008</span>
<span class='c'>#&gt;  [9] 3.653252 3.543854</span></code></pre>

</div>

Because in R, a single value like `21` is really a vector of length 1, this behavior makes sense.

Just remember that for most functions, you do really need to pass a vector and not just a sequence of numbers:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>## This way, log() thinks you are passing 3 separate arguments:</span>
<span class='nf'><a href='https://rdrr.io/r/base/Log.html'>log</a></span><span class='o'>(</span><span class='m'>10</span>, <span class='m'>15</span>, <span class='m'>20</span><span class='o'>)</span>
<span class='c'>#&gt; Error in log(10, 15, 20): unused argument (20)</span>

<span class='c'>## Now, you pass 1 argument which is a vector created with `c()`</span>
<span class='nf'><a href='https://rdrr.io/r/base/Log.html'>log</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>10</span>, <span class='m'>15</span>, <span class='m'>20</span><span class='o'>)</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 2.302585 2.708050 2.995732</span></code></pre>

</div>

There are many other vectorized functions that will transform each value in a vector, such as [`round()`](https://rdrr.io/r/base/Round.html) (rounding numbers) and [`abs()`](https://rdrr.io/r/base/MathFun.html) (taking absolute numbers).

Other vectorized functions summarize a vector into a single value, such as [`sum()`](https://rdrr.io/r/base/sum.html) and [`mean()`](https://rdrr.io/r/base/mean.html).

<br>

------------------------------------------------------------------------

## Breakout Rooms I

<details>
<summary>
<b>Code to get set up</b> (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>## If necessary, install the packages we will use</span>
<span class='kr'>if</span> <span class='o'>(</span><span class='o'>!</span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>require</a></span><span class='o'>(</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/'>palmerpenguins</a></span><span class='o'>)</span><span class='o'>)</span> <span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"palmerpenguins"</span><span class='o'>)</span>
<span class='kr'>if</span> <span class='o'>(</span><span class='o'>!</span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>require</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span><span class='o'>)</span> <span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"tidyverse"</span><span class='o'>)</span>
<span class='kr'>if</span> <span class='o'>(</span><span class='o'>!</span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>require</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/tidyverse/glue'>glue</a></span><span class='o'>)</span><span class='o'>)</span> <span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"glue"</span><span class='o'>)</span>

<span class='c'>## Load the packages we will use</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/'>palmerpenguins</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/tidyverse/glue'>glue</a></span><span class='o'>)</span>

<span class='c'>## Create a vector of bill lengths</span>
<span class='nv'>penguins_noNA</span> <span class='o'>&lt;-</span> <span class='nf'>drop_na</span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>)</span>
<span class='nv'>bill_len</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>penguins_noNA</span><span class='o'>$</span><span class='nv'>bill_length_mm</span>, <span class='m'>10</span><span class='o'>)</span></code></pre>

</div>

</details>

<div class="puzzle">

<div>

### Exercise 1: Unequal length

Vectorization also works when two vectors with multiple elements do not have the same length. For instance, in the example below, we divide the first value by 10, the second by 100, the third again by 10, and so on:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_len</span> <span class='o'>/</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>10</span>, <span class='m'>100</span><span class='o'>)</span>
<span class='c'>#&gt;  [1] 3.910 0.395 4.030 0.367 3.930 0.389 3.920 0.411 3.860 0.346</span></code></pre>

</div>

-   **Given the length of `bill_len` (10), do you see any issues if you would** **divide by a vector of length 3? Try it out and see what happens.**

<details>
<summary>
<b>Hints</b> (click here)
</summary>

<br>

While 10 is a multiple of 2, it is not a multiple of 3. This means that the shorter vector will not be recycled in its entirety the last time around.

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

R will perform the operation but issue a warning about it:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_len</span> <span class='o'>/</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>10</span>, <span class='m'>100</span>, <span class='m'>1000</span><span class='o'>)</span>
<span class='c'>#&gt; Warning in bill_len/c(10, 100, 1000): longer object length is not a multiple of shorter object length</span>
<span class='c'>#&gt;  [1] 3.9100 0.3950 0.0403 3.6700 0.3930 0.0389 3.9200 0.4110 0.0386 3.4600</span></code></pre>

</div>

</details>

-   **Negate *every other* value in the `bill_len` vector.**

<details>
<summary>
<b>Hints</b> (click here)
</summary>

<br>

-   Negation means turning a positive value into a negative value and vice versa (e.g. `3` => `-3` and `-15` => `15`).

-   You can leave the other values as-is by multiplying them by 1.

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_len</span> <span class='o'>*</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1</span>, <span class='o'>-</span><span class='m'>1</span><span class='o'>)</span>
<span class='c'>#&gt;  [1]  39.1 -39.5  40.3 -36.7  39.3 -38.9  39.2 -41.1  38.6 -34.6</span></code></pre>

</div>

</details>

</div>

</div>

<br>

<div class="puzzle">

<div>

### Exercise 2: Strings

The `glue` function from the package of the same name allows you to combine literal strings with the values or strings contained in R objects. For instance:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>island</span> <span class='o'>&lt;-</span> <span class='s'>"Biscoe"</span>
<span class='nf'><a href='https://glue.tidyverse.org/reference/glue.html'>glue</a></span><span class='o'>(</span><span class='s'>"The island of &#123;island&#125;"</span><span class='o'>)</span>
<span class='c'>#&gt; The island of Biscoe</span></code></pre>

</div>

So, you combine both literal strings and R objects in a single quoted string, and access the values of R objects using braces `{}`.

-   **Extract the names of the three islands contained in the `penguins` dataframe,** **and save them in an vector called `islands`.**

<details>
<summary>
<b>Hints</b> (click here)
</summary>

<br>

Use the [`unique()`](https://rdrr.io/r/base/unique.html) function to get a "deduplicated" vector of islands, i.e. with one entry per island.

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>islands</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/unique.html'>unique</a></span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>$</span><span class='nv'>island</span><span class='o'>)</span>
<span class='nv'>islands</span>
<span class='c'>#&gt; [1] Torgersen Biscoe    Dream    </span>
<span class='c'>#&gt; Levels: Biscoe Dream Torgersen</span>

<span class='c'>## Or:</span>
<span class='nv'>islands</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span> <span class='nf'>pull</span><span class='o'>(</span><span class='nv'>island</span><span class='o'>)</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/base/unique.html'>unique</a></span><span class='o'>(</span><span class='o'>)</span></code></pre>

</div>

Note: it is fine that `islands` is still a *factor*, like the `island` column in `penguins` was.

</details>

-   **Make use of vectorization to print each island's name like so:**
    <div class='highlight'>
    <pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#&gt; The island of Torgersen</span>
    <span class='c'>#&gt; The island of Biscoe</span>
    <span class='c'>#&gt; The island of Dream</span></code></pre>

</div>

<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://glue.tidyverse.org/reference/glue.html'>glue</a></span><span class='o'>(</span><span class='s'>"Island of &#123;islands&#125;"</span><span class='o'>)</span>
<span class='c'>#&gt; Island of Torgersen</span>
<span class='c'>#&gt; Island of Biscoe</span>
<span class='c'>#&gt; Island of Dream</span></code></pre>

</div>

</details>

</div>

</div>

<br>

------------------------------------------------------------------------

## III -- Vectorization with logical indices

We can also use vectorized solutions when we want to operate only on elements that satisfy a certain condition. To do so, we make use of R's ability to index a vector with a *logical vector*.

Let's say we don't trust any bill length measurement of over 40 mm, and we want to remove those from our vector.

First, note that the code below will return a logical vector of the same length as `bill_len`, with `TRUE` if the value is \>40, and `FALSE` if it is not:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_len</span> <span class='o'>&gt;</span> <span class='m'>40</span>
<span class='c'>#&gt;  [1] FALSE FALSE  TRUE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE</span>
<span class='nv'>bill_len</span>
<span class='c'>#&gt;  [1] 39.1 39.5 40.3 36.7 39.3 38.9 39.2 41.1 38.6 34.6</span></code></pre>

</div>

When we index the original vector with such a logical vector (sometimes referred to as a *mask*), we only get the values \>40:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_len</span><span class='o'>[</span><span class='nv'>bill_len</span> <span class='o'>&gt;</span> <span class='m'>40</span><span class='o'>]</span>
<span class='c'>#&gt; [1] 40.3 41.1</span></code></pre>

</div>

This is very succinct and powerful!

With a similar strategy, you can also retain all elements of the vector but manipulate some of them:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>## We create a separate vector so we don't change the original one:</span>
<span class='nv'>bill_len_ed</span> <span class='o'>&lt;-</span> <span class='nv'>bill_len</span>

<span class='c'>## Only change values &gt; 40:</span>
<span class='nv'>bill_len_ed</span><span class='o'>[</span><span class='nv'>bill_len</span> <span class='o'>&gt;</span> <span class='m'>40</span><span class='o'>]</span> <span class='o'>&lt;-</span> <span class='nv'>bill_len_ed</span><span class='o'>[</span><span class='nv'>bill_len</span> <span class='o'>&gt;</span> <span class='m'>40</span><span class='o'>]</span> <span class='o'>-</span> <span class='m'>100</span>
<span class='nv'>bill_len_ed</span>
<span class='c'>#&gt;  [1]  39.1  39.5 -59.7  36.7  39.3  38.9  39.2 -58.9  38.6  34.6</span></code></pre>

</div>

But for those kinds of operations, the vectorized [`ifelse()`](https://rdrr.io/r/base/ifelse.html) function is easier and clearer:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_len_ed</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='o'>(</span><span class='nv'>bill_len</span> <span class='o'>&gt;</span> <span class='m'>40</span>, <span class='nv'>bill_len</span> <span class='o'>-</span> <span class='m'>100</span>, <span class='nv'>bill_len</span><span class='o'>)</span>
<span class='nv'>bill_len_ed</span>
<span class='c'>#&gt;  [1]  39.1  39.5 -59.7  36.7  39.3  38.9  39.2 -58.9  38.6  34.6</span></code></pre>

</div>

<br>

<div class="alert alert-note">

<div>

When creating logical vectors, the [`any()`](https://rdrr.io/r/base/any.html) and [`all()`](https://rdrr.io/r/base/all.html) functions are very handy.

For instance, say we had a vector of p-values:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>pvals</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>0.06</span>, <span class='m'>0.048</span>, <span class='m'>0.01</span>, <span class='m'>0.73</span><span class='o'>)</span></code></pre>

</div>

To check whether any of the p-values are significant:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/any.html'>any</a></span><span class='o'>(</span><span class='nv'>pvals</span> <span class='o'>&lt;</span> <span class='m'>0.05</span><span class='o'>)</span>
<span class='c'>#&gt; [1] TRUE</span></code></pre>

</div>

To check whether all of the p-values are significant:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/all.html'>all</a></span><span class='o'>(</span><span class='nv'>pvals</span> <span class='o'>&lt;</span> <span class='m'>0.05</span><span class='o'>)</span>
<span class='c'>#&gt; [1] FALSE</span></code></pre>

</div>

Moreover, because `TRUE` corresponds to 1 and `FALSE` to 0, you can also directly count the number of elements that satisfy a condition:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/sum.html'>sum</a></span><span class='o'>(</span><span class='nv'>pvals</span> <span class='o'>&lt;</span> <span class='m'>0.05</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 2</span></code></pre>

</div>

</div>

</div>

<br>

<br>

------------------------------------------------------------------------

## Breakout Rooms II

<div class="puzzle">

<div>

### Exercise 3: Logical vectors

-   Create a vector `bill_len_NA` where all values > 40 have been turned into `NA`s.

<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>## Using logical vector subsetting:</span>
<span class='nv'>bill_len_NA</span> <span class='o'>&lt;-</span> <span class='nv'>bill_len</span>
<span class='nv'>bill_len_NA</span><span class='o'>[</span><span class='nv'>bill_len_NA</span> <span class='o'>&gt;</span> <span class='m'>40</span><span class='o'>]</span> <span class='o'>&lt;-</span> <span class='kc'>NA</span>
<span class='nv'>bill_len_NA</span>
<span class='c'>#&gt;  [1] 39.1 39.5   NA 36.7 39.3 38.9 39.2   NA 38.6 34.6</span>

<span class='c'>## Or, using `ifelse()`:</span>
<span class='nv'>bill_len_NA</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='o'>(</span><span class='nv'>bill_len</span> <span class='o'>&gt;</span> <span class='m'>40</span>, <span class='kc'>NA</span>, <span class='nv'>bill_len</span><span class='o'>)</span>
<span class='nv'>bill_len_NA</span>
<span class='c'>#&gt;  [1] 39.1 39.5   NA 36.7 39.3 38.9 39.2   NA 38.6 34.6</span></code></pre>

</div>

</details>

-   Remove all `NA`s from `bill_len_NA`. (If you don't know the function to identify `NA`s in a vector, take a look at the Hints.)

<details>
<summary>
<b>Hints</b> (click here)
</summary>

<br>

-   The function [`is.na()`](https://rdrr.io/r/base/NA.html) will check which values in a vector are `NA`s: it returns a logical vector with `TRUE`s for `NA` values and `FALSE`s for non-`NA` values.

-   Since you want to *remove* `NA` values, you need to negate the output of the [`is.na()`](https://rdrr.io/r/base/NA.html) function when subsetting. You can negate logical tests in R with a [`!`](https://rdrr.io/r/base/Logic.html). So, `!is.na()` would have `TRUE` for non-`NA` values, which would allow you to keep them.

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_len_NA</span><span class='o'>[</span><span class='o'>!</span><span class='nf'><a href='https://rdrr.io/r/base/NA.html'>is.na</a></span><span class='o'>(</span><span class='nv'>bill_len_NA</span><span class='o'>)</span><span class='o'>]</span>
<span class='c'>#&gt; [1] 39.1 39.5 36.7 39.3 38.9 39.2 38.6 34.6</span></code></pre>

</div>

</details>

</div>

</div>

<br>

<div class="puzzle">

<div>

### Exercise 4: `ifelse()` in a plot

With *ggplot*, make a `geom_point()` plot of `bill_length_mm` versus `bill_depth_mm` in Gentoo Penguins. In this plot, highlight penguins with a bill length to bill depth ratio larger than 3.5 by giving those points a different color.

Don't hesitate to look at the Hints if you're not sure how to approach this.

<details>
<summary>
<b>Hints 1 </b> (click here)
</summary>

<br>

-   Create a new dataframe with:
    -   Just Gentoo penguins (use the function [`filter()`](https://rdrr.io/r/stats/filter.html))
    -   No `NA`s (use the function `drop_na()`)
    -   A new column with a logical vector indicating whether the bill length to bill depth ratio is >3.5 (e.g., use the `mutate()` function with an [`ifelse()`](https://rdrr.io/r/base/ifelse.html) statement).
-   When creating the plot, assign the new column to the `color` aesthetic.

*An alternative:* you don't even need to create the logical-vector-column, you could also directly map the `color` aesthetic to a logical expression!

</details>
<details>
<summary>
<b>Hints 2 </b> (click here)
</summary>

<br>

-   Here is some example skeleton code for the data processing:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>...</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='c'>## Only retain rows for 1 penguin species:</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>species</span> <span class='o'>==</span> <span class='nv'>...</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='c'>## Remove rows with NAs:</span>
  <span class='nv'>...</span> <span class='o'>%&gt;%</span> 
  <span class='c'>## Create a new column `ratio` with a logical vector:</span>
  <span class='nf'>mutate</span><span class='o'>(</span>ratio <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='o'>(</span><span class='nv'>...</span>, <span class='s'>"&gt; 3.5"</span>, <span class='s'>"&lt; 3.5"</span><span class='o'>)</span><span class='o'>)</span></code></pre>

</div>

-   Here is some example skeleton code for the plot:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span><span class='nv'>...</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='c'>## Use the new column with the logical vector for the `color` aesthetic</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>...</span>, y <span class='o'>=</span> <span class='nv'>...</span>, color <span class='o'>=</span> <span class='nv'>...</span><span class='o'>)</span><span class='o'>)</span></code></pre>

</div>

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>## Create the new dataframe</span>
<span class='nv'>gent</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>species</span> <span class='o'>==</span> <span class='s'>"Gentoo"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>mutate</span><span class='o'>(</span>
    ratio <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span><span class='o'>(</span><span class='nv'>bill_length_mm</span> <span class='o'>/</span> <span class='nv'>bill_depth_mm</span> <span class='o'>&gt;</span> <span class='m'>3.5</span>, <span class='s'>"&gt; 3.5"</span>, <span class='s'>"&lt; 3.5"</span><span class='o'>)</span>
    <span class='o'>)</span>

<span class='c'>## Make the plot:</span>
<span class='nf'>ggplot</span><span class='o'>(</span><span class='nv'>gent</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span>, color <span class='o'>=</span> <span class='nv'>ratio</span><span class='o'>)</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-35-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Or:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>## Create the new dataframe without making a new variable</span>
<span class='nv'>gent</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>species</span> <span class='o'>==</span> <span class='s'>"Gentoo"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>## Make the plot and include the logical expression in the `aes()` call:</span>
<span class='nf'>ggplot</span><span class='o'>(</span><span class='nv'>gent</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span>,
                 color <span class='o'>=</span> <span class='nv'>bill_length_mm</span> <span class='o'>/</span> <span class='nv'>bill_depth_mm</span> <span class='o'>&gt;</span> <span class='m'>3.5</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"Bill length ratio &gt; 3.5"</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-36-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

</div>

<br>

------------------------------------------------------------------------

## Bonus -- Vectorization with matrices

We can also perform vectorized operations on *entire matrices*. With the following matrix:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>## We use the "sample" function to get 25 random values between 1 and a 100,</span>
<span class='c'>## and put those in a 5*5 matrix:</span>
<span class='nv'>mat</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/matrix.html'>matrix</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/sample.html'>sample</a></span><span class='o'>(</span><span class='m'>1</span><span class='o'>:</span><span class='m'>100</span>, <span class='m'>25</span><span class='o'>)</span>, nrow <span class='o'>=</span> <span class='m'>5</span>, ncol <span class='o'>=</span> <span class='m'>5</span><span class='o'>)</span>
<span class='nv'>mat</span>
<span class='c'>#&gt;      [,1] [,2] [,3] [,4] [,5]</span>
<span class='c'>#&gt; [1,]   38   48   43   67  100</span>
<span class='c'>#&gt; [2,]   63   10   70   81   93</span>
<span class='c'>#&gt; [3,]   21   65   72   98   53</span>
<span class='c'>#&gt; [4,]   69   22   17   25   29</span>
<span class='c'>#&gt; [5,]   90   80   45   37   33</span></code></pre>

</div>

...we could multiple all values by 10 or get the square of each value simply as follows:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>mat</span> <span class='o'>*</span> <span class='m'>10</span>
<span class='c'>#&gt;      [,1] [,2] [,3] [,4] [,5]</span>
<span class='c'>#&gt; [1,]  380  480  430  670 1000</span>
<span class='c'>#&gt; [2,]  630  100  700  810  930</span>
<span class='c'>#&gt; [3,]  210  650  720  980  530</span>
<span class='c'>#&gt; [4,]  690  220  170  250  290</span>
<span class='c'>#&gt; [5,]  900  800  450  370  330</span>

<span class='nv'>mat</span> <span class='o'>*</span> <span class='nv'>mat</span>
<span class='c'>#&gt;      [,1] [,2] [,3] [,4]  [,5]</span>
<span class='c'>#&gt; [1,] 1444 2304 1849 4489 10000</span>
<span class='c'>#&gt; [2,] 3969  100 4900 6561  8649</span>
<span class='c'>#&gt; [3,]  441 4225 5184 9604  2809</span>
<span class='c'>#&gt; [4,] 4761  484  289  625   841</span>
<span class='c'>#&gt; [5,] 8100 6400 2025 1369  1089</span></code></pre>

</div>

