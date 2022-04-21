---
title: "Session S03E12: Incorporating your own functions into loops"
summary: "In this session of Code Club, we'll see how putting your own functions into loops prevents repeating yourself even more."
authors: [michael-broe]
date: "2022-04-19"
output: hugodown::md_document
toc: true
image: 
  caption: ""
  focal_point: ""
  preview_only: false
editor_options: 
  markdown: 
    wrap: 72
rmd_hash: 7016764a90761db5

---

<br> <br> <br>

------------------------------------------------------------------------

## New To Code Club?

-   First, check out the [Code Club Computer Setup](/codeclub-setup/) instructions, which also has some pointers that might be helpful if you're new to R or RStudio.

-   Please open RStudio before Code Club to test things out -- if you run into issues, join the Zoom call early and we'll troubleshoot.

------------------------------------------------------------------------

## Session Goals

-   Learn how to incorporate your own functions into loops.
-   Learn how to efficiently *save* the outputs of your loop into a data structure.
-   Learn how using a functional (like `purr::map`) saves you a lot of housekeeping.

------------------------------------------------------------------------

Again we'll be using [`tibble()`](https://tibble.tidyverse.org/reference/tibble.html) from the tidyverse package, so we need to load that first.

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

We'll also reuse the toy data frame from last Code Club:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://tibble.tidyverse.org/reference/tibble.html'>tibble</a></span><span class='o'>(</span>
  a <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/stats/Normal.html'>rnorm</a></span><span class='o'>(</span><span class='m'>10</span><span class='o'>)</span>,
  b <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/stats/Normal.html'>rnorm</a></span><span class='o'>(</span><span class='m'>10</span><span class='o'>)</span>,
  c <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/stats/Normal.html'>rnorm</a></span><span class='o'>(</span><span class='m'>10</span><span class='o'>)</span>,
  d <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/stats/Normal.html'>rnorm</a></span><span class='o'>(</span><span class='m'>10</span><span class='o'>)</span>
<span class='o'>)</span>

<span class='nv'>df</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 4</span></span>
<span class='c'>#&gt;          a        b      c      d</span>
<span class='c'>#&gt;      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span> -<span style='color: #BB0000;'>1.57</span>    0.647    1.39   0.851</span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span>  0.239   0.667   -<span style='color: #BB0000;'>0.108</span> -<span style='color: #BB0000;'>1.74</span> </span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span> -<span style='color: #BB0000;'>0.520</span>  -<span style='color: #BB0000;'>0.663</span>   -<span style='color: #BB0000;'>0.343</span>  0.652</span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span> -<span style='color: #BB0000;'>0.035</span><span style='color: #BB0000; text-decoration: underline;'>9</span> -<span style='color: #BB0000;'>1.69</span>    -<span style='color: #BB0000;'>1.30</span>  -<span style='color: #BB0000;'>1.58</span> </span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span>  1.27    0.357    0.158 -<span style='color: #BB0000;'>1.92</span> </span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span> -<span style='color: #BB0000;'>1.04</span>    0.490    0.897  1.33 </span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span> -<span style='color: #BB0000;'>0.212</span>  -<span style='color: #BB0000;'>0.753</span>   -<span style='color: #BB0000;'>1.68</span>  -<span style='color: #BB0000;'>0.503</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span>  1.91    0.275    0.646  0.139</span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span> -<span style='color: #BB0000;'>0.535</span>  -<span style='color: #BB0000;'>0.006</span><span style='color: #BB0000; text-decoration: underline;'>32</span> -<span style='color: #BB0000;'>1.02</span>  -<span style='color: #BB0000;'>0.467</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span>  0.223  -<span style='color: #BB0000;'>0.422</span>    0.616 -<span style='color: #BB0000;'>0.553</span></span></code></pre>

</div>

And we'll also be re-using our own `normalize` function:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>normalize</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span> <span class='o'>&#123;</span>
  <span class='nv'>rng</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/range.html'>range</a></span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span>
  <span class='o'>(</span><span class='nv'>x</span> <span class='o'>-</span> <span class='nv'>rng</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>)</span> <span class='o'>/</span> <span class='o'>(</span><span class='nv'>rng</span><span class='o'>[</span><span class='m'>2</span><span class='o'>]</span> <span class='o'>-</span> <span class='nv'>rng</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>)</span>
<span class='o'>&#125;</span></code></pre>

</div>

Last time we saw how to use this function to simplify our code:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span> <span class='o'>&lt;-</span> <span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>a</span><span class='o'>)</span>
<span class='nv'>df</span><span class='o'>$</span><span class='nv'>b</span> <span class='o'>&lt;-</span> <span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>b</span><span class='o'>)</span>
<span class='nv'>df</span><span class='o'>$</span><span class='nv'>c</span> <span class='o'>&lt;-</span> <span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>c</span><span class='o'>)</span>
<span class='nv'>df</span><span class='o'>$</span><span class='nv'>d</span> <span class='o'>&lt;-</span> <span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>d</span><span class='o'>)</span></code></pre>

</div>

In previous Code Clubs we've seen how you can apply a built-in function like `mean` to each column of a data frame using a `for` loop, `lapply`, or `map`.

We can use exactly the same techniques with our own functions.

But I think it's worth taking advantage of this time to revisit a couple of details (some of which were in the Bonus Material in [S03E08](https://biodash.github.io/codeclub/s03e08_loops/)).

## Accessing by value vs. index

In our first session on loops, we saw an example like this:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'>for</span> <span class='o'>(</span><span class='nv'>a_number</span> <span class='kr'>in</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>10</span>, <span class='m'>11</span>, <span class='m'>12</span>, <span class='m'>13</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>&#123;</span> <span class='c'># We iterate over 10, 11, 12, 13</span>
  <span class='nf'><a href='https://rdrr.io/r/base/print.html'>print</a></span><span class='o'>(</span><span class='nv'>a_number</span> <span class='o'>*</span> <span class='o'>-</span><span class='m'>1</span><span class='o'>)</span>
<span class='o'>&#125;</span>
<span class='c'>#&gt; [1] -10</span>
<span class='c'>#&gt; [1] -11</span>
<span class='c'>#&gt; [1] -12</span>
<span class='c'>#&gt; [1] -13</span></code></pre>

</div>

Here we are looping over the actual values in the vector. But we can also access the values *by their index*. Here we loop over an index, and include that index in the body of the loop. It is very common in this usage to use the name `i` for the variable. This is most common when the vector/list/data frame already exists as an object:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>numbers</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>10</span>, <span class='m'>11</span>, <span class='m'>12</span>, <span class='m'>13</span><span class='o'>)</span> <span class='c'># We create a vector</span>

<span class='kr'>for</span> <span class='o'>(</span><span class='nv'>i</span> <span class='kr'>in</span> <span class='m'>1</span><span class='o'>:</span><span class='m'>4</span><span class='o'>)</span> <span class='o'>&#123;</span>             <span class='c'># We iterate over the indexes 1, 2, 3, 4</span>
  <span class='nf'><a href='https://rdrr.io/r/base/print.html'>print</a></span><span class='o'>(</span><span class='nv'>numbers</span><span class='o'>[</span><span class='nv'>i</span><span class='o'>]</span> <span class='o'>*</span> <span class='o'>-</span><span class='m'>1</span><span class='o'>)</span>     <span class='c'># We access the value using the index notation `[ ]`</span>
<span class='o'>&#125;</span>
<span class='c'>#&gt; [1] -10</span>
<span class='c'>#&gt; [1] -11</span>
<span class='c'>#&gt; [1] -12</span>
<span class='c'>#&gt; [1] -13</span></code></pre>

</div>

Note that here we 'hard-coded' the length of the vector inside the loop. We can generalize this so it will work on vectors of *any length* by using this syntax:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>numbers</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>10</span>, <span class='m'>11</span>, <span class='m'>12</span>, <span class='m'>13</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/base/length.html'>length</a></span><span class='o'>(</span><span class='nv'>numbers</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 4</span>

<span class='kr'>for</span> <span class='o'>(</span><span class='nv'>i</span> <span class='kr'>in</span> <span class='m'>1</span><span class='o'>:</span><span class='nf'><a href='https://rdrr.io/r/base/length.html'>length</a></span><span class='o'>(</span><span class='nv'>numbers</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>&#123;</span> <span class='c'># We iterate over 1, 2, 3,...</span>
  <span class='nf'><a href='https://rdrr.io/r/base/print.html'>print</a></span><span class='o'>(</span><span class='nv'>numbers</span><span class='o'>[</span><span class='nv'>i</span><span class='o'>]</span> <span class='o'>*</span> <span class='o'>-</span><span class='m'>1</span><span class='o'>)</span>
<span class='o'>&#125;</span>
<span class='c'>#&gt; [1] -10</span>
<span class='c'>#&gt; [1] -11</span>
<span class='c'>#&gt; [1] -12</span>
<span class='c'>#&gt; [1] -13</span></code></pre>

</div>

## Storing loop outputs

We have also seen that unless you issue a [`print()`](https://rdrr.io/r/base/print.html) statement which runs on *every separate iteration of the loop*, the output values simply 'go away'.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'>for</span> <span class='o'>(</span><span class='nv'>a_number</span> <span class='kr'>in</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>10</span>, <span class='m'>11</span>, <span class='m'>12</span>, <span class='m'>13</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>&#123;</span>
  <span class='nv'>a_number</span> <span class='o'>*</span> <span class='o'>-</span><span class='m'>1</span>
<span class='o'>&#125;</span></code></pre>

</div>

Similarly if we want to actually *save* the output of the loop in a vector, we need to save an output value on *every separate iteration of the loop*. And this means we have to build the output vector iteration-by-iteration. Here is a first guess how to do this:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>outputs</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/vector.html'>vector</a></span><span class='o'>(</span><span class='o'>)</span>                    <span class='c'># We 'initialize' an *empty vector* to hold the outputs</span>

<span class='nv'>outputs</span>
<span class='c'>#&gt; logical(0)</span>

<span class='kr'>for</span> <span class='o'>(</span><span class='nv'>a_number</span> <span class='kr'>in</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>10</span>, <span class='m'>11</span>, <span class='m'>12</span>, <span class='m'>13</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>&#123;</span>
  <span class='nv'>outputs</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='nv'>outputs</span>, <span class='nv'>a_number</span> <span class='o'>*</span> <span class='o'>-</span><span class='m'>1</span><span class='o'>)</span> <span class='c'># Each time round the loop we *append* a new value to the existing vector</span>
<span class='o'>&#125;</span>

<span class='nv'>outputs</span>
<span class='c'>#&gt; [1] -10 -11 -12 -13</span></code></pre>

</div>

This looks fine, **however**, there is a problem. The vector 'grows' at each iteration, and this means that, as Jelmer pointed out in the bonus material on loops, '**R has to create an entirely new object in each iteration of the loop**, because the object's memory requirements keep increasing.'

This is not an issue for the toy vector we are using here, but say you were using a loop to create a data frame, column by column, with thousands of rows, and hundreds of columns. On every iteration the entire data frame would have to be copied and extended, and copied and extended, and...

So how do we avoid that?

The technique is to initialize a vector (or list, or data frame) of the appropriate size for the outputs, which **preallocates** the memory required to store it. Then instead of *appending* to it on each iteration, we *write into it* on each iteration. The size of the output vector is already fixed, and modifying values like this is way more efficient. Again, the magic is is to use indexes.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>output_vector</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/vector.html'>vector</a></span><span class='o'>(</span>length <span class='o'>=</span> <span class='m'>4</span><span class='o'>)</span>

<span class='nv'>output_vector</span>
<span class='c'>#&gt; [1] FALSE FALSE FALSE FALSE</span>

<span class='nv'>numbers</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>10</span>, <span class='m'>11</span>, <span class='m'>12</span>, <span class='m'>13</span><span class='o'>)</span>

<span class='kr'>for</span> <span class='o'>(</span><span class='nv'>i</span> <span class='kr'>in</span> <span class='m'>1</span><span class='o'>:</span><span class='m'>4</span><span class='o'>)</span> <span class='o'>&#123;</span> 
  <span class='nv'>output_vector</span><span class='o'>[</span><span class='nv'>i</span><span class='o'>]</span> <span class='o'>&lt;-</span> <span class='nv'>numbers</span><span class='o'>[</span><span class='nv'>i</span><span class='o'>]</span> <span class='o'>*</span> <span class='o'>-</span><span class='m'>1</span>
<span class='o'>&#125;</span>

<span class='nv'>output_vector</span>
<span class='c'>#&gt; [1] -10 -11 -12 -13</span></code></pre>

</div>

## Breakout rooms, storing loop outputs

### Exercise 1

<div class="puzzle">

R has a function `letters` which returns a character vector:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>letters</span>
<span class='c'>#&gt;  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s"</span>
<span class='c'>#&gt; [20] "t" "u" "v" "w" "x" "y" "z"</span></code></pre>

</div>

(`letters` is a bit like `iris`: it's a character vector which is 'just there', like `iris` is a data frame which is 'just there').

The tidyverse also has a function [`str_to_upper()`](https://stringr.tidyverse.org/reference/case.html) which converts the case of a character:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://stringr.tidyverse.org/reference/case.html'>str_to_upper</a></span><span class='o'>(</span><span class='s'>"a"</span><span class='o'>)</span>
<span class='c'>#&gt; [1] "A"</span></code></pre>

</div>

Write a for loop that converts each element of a character vector to upper case, saving the output by writing the output of each iteration into an empty vector.

<details>
<summary>
Hints (click here)
</summary>
<br>What is `letters[1]`? <br>
</details>

<br>

<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>upper_case</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/vector.html'>vector</a></span><span class='o'>(</span>length <span class='o'>=</span> <span class='m'>26</span><span class='o'>)</span>

<span class='kr'>for</span> <span class='o'>(</span><span class='nv'>i</span> <span class='kr'>in</span> <span class='m'>1</span><span class='o'>:</span><span class='m'>26</span><span class='o'>)</span> <span class='o'>&#123;</span>
  <span class='nv'>upper_case</span><span class='o'>[</span><span class='nv'>i</span><span class='o'>]</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://stringr.tidyverse.org/reference/case.html'>str_to_upper</a></span><span class='o'>(</span><span class='nv'>letters</span><span class='o'>[</span><span class='nv'>i</span><span class='o'>]</span><span class='o'>)</span>
<span class='o'>&#125;</span></code></pre>

</div>

<br>

</details>

</div>

## Back to `normalize`

This gives us the machinery to use our own function in a for loop.

First, recall how we can access a column vector using the `[[ ]]` syntax:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>df</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span>
<span class='c'>#&gt;  [1] -1.56695706  0.23880352 -0.52028396 -0.03587572  1.26976225 -1.03948139</span>
<span class='c'>#&gt;  [7] -0.21172370  1.90549573 -0.53548764  0.22250909</span></code></pre>

</div>

So we can iteratively access each column in a for loop:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'>for</span> <span class='o'>(</span><span class='nv'>i</span> <span class='kr'>in</span> <span class='m'>1</span><span class='o'>:</span><span class='m'>4</span><span class='o'>)</span> <span class='o'>&#123;</span>
  <span class='nf'><a href='https://rdrr.io/r/base/print.html'>print</a></span><span class='o'>(</span><span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>[[</span><span class='nv'>i</span><span class='o'>]</span><span class='o'>]</span><span class='o'>)</span><span class='o'>)</span>
<span class='o'>&#125;</span>
<span class='c'>#&gt;  [1] 0.0000000 0.5200245 0.3014218 0.4409221 0.8169209 0.1519029 0.3902813</span>
<span class='c'>#&gt;  [8] 1.0000000 0.2970435 0.5153320</span>
<span class='c'>#&gt;  [1] 0.9915841 1.0000000 0.4352500 0.0000000 0.8684414 0.9250426 0.3970564</span>
<span class='c'>#&gt;  [8] 0.8335988 0.7141351 0.5377301</span>
<span class='c'>#&gt;  [1] 1.0000000 0.5131949 0.4367290 0.1242323 0.5998479 0.8402709 0.0000000</span>
<span class='c'>#&gt;  [8] 0.7587425 0.2170914 0.7489915</span>
<span class='c'>#&gt;  [1] 0.85264136 0.05580354 0.79127366 0.10586772 0.00000000 1.00000000</span>
<span class='c'>#&gt;  [7] 0.43627787 0.63372198 0.44736338 0.42096304</span></code></pre>

</div>

And again, we can generalize this to a data frame of of any length.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'>for</span> <span class='o'>(</span><span class='nv'>i</span> <span class='kr'>in</span> <span class='m'>1</span><span class='o'>:</span><span class='nf'><a href='https://rdrr.io/r/base/length.html'>length</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>&#123;</span>
  <span class='nf'><a href='https://rdrr.io/r/base/print.html'>print</a></span><span class='o'>(</span><span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>[[</span><span class='nv'>i</span><span class='o'>]</span><span class='o'>]</span><span class='o'>)</span><span class='o'>)</span>
<span class='o'>&#125;</span>
<span class='c'>#&gt;  [1] 0.0000000 0.5200245 0.3014218 0.4409221 0.8169209 0.1519029 0.3902813</span>
<span class='c'>#&gt;  [8] 1.0000000 0.2970435 0.5153320</span>
<span class='c'>#&gt;  [1] 0.9915841 1.0000000 0.4352500 0.0000000 0.8684414 0.9250426 0.3970564</span>
<span class='c'>#&gt;  [8] 0.8335988 0.7141351 0.5377301</span>
<span class='c'>#&gt;  [1] 1.0000000 0.5131949 0.4367290 0.1242323 0.5998479 0.8402709 0.0000000</span>
<span class='c'>#&gt;  [8] 0.7587425 0.2170914 0.7489915</span>
<span class='c'>#&gt;  [1] 0.85264136 0.05580354 0.79127366 0.10586772 0.00000000 1.00000000</span>
<span class='c'>#&gt;  [7] 0.43627787 0.63372198 0.44736338 0.42096304</span></code></pre>

</div>

Here again, we are just printing the output, not saving it to a new data frame.

So, according to our strategy, we want to create an empty data frame to hold our results. We can use information from our original data frame to do this.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>empty_vec</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/vector.html'>vector</a></span><span class='o'>(</span>length <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>)</span><span class='o'>)</span> <span class='c'># Empty vector with correct number of rows</span>

<span class='nv'>df_norm</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://tibble.tidyverse.org/reference/tibble.html'>tibble</a></span><span class='o'>(</span>a <span class='o'>=</span> <span class='nv'>empty_vec</span>, b <span class='o'>=</span> <span class='nv'>empty_vec</span>, c <span class='o'>=</span> <span class='nv'>empty_vec</span>, d <span class='o'>=</span> <span class='nv'>empty_vec</span><span class='o'>)</span>

<span class='kr'>for</span> <span class='o'>(</span><span class='nv'>i</span> <span class='kr'>in</span> <span class='m'>1</span><span class='o'>:</span><span class='nf'><a href='https://rdrr.io/r/base/length.html'>length</a></span><span class='o'>(</span><span class='nv'>df</span><span class='o'>)</span><span class='o'>)</span><span class='o'>&#123;</span>
  <span class='nv'>df_norm</span><span class='o'>[[</span><span class='nv'>i</span><span class='o'>]</span><span class='o'>]</span> <span class='o'>&lt;-</span> <span class='nf'>normalize</span><span class='o'>(</span><span class='nv'>df</span><span class='o'>[[</span><span class='nv'>i</span><span class='o'>]</span><span class='o'>]</span><span class='o'>)</span>
<span class='o'>&#125;</span>

<span class='nv'>df_norm</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 4</span></span>
<span class='c'>#&gt;        a     b     c      d</span>
<span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span> 0     0.992 1     0.853 </span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span> 0.520 1     0.513 0.055<span style='text-decoration: underline;'>8</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span> 0.301 0.435 0.437 0.791 </span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span> 0.441 0     0.124 0.106 </span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span> 0.817 0.868 0.600 0     </span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span> 0.152 0.925 0.840 1     </span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span> 0.390 0.397 0     0.436 </span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span> 1     0.834 0.759 0.634 </span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span> 0.297 0.714 0.217 0.447 </span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span> 0.515 0.538 0.749 0.421</span></code></pre>

</div>

## Using a `map` command.

It's a pain to have to *manually* set up the 'container' that will house your results. Couldn't the computer do that for us? Yes! All of this housekeeping, the for loop, the preallocation of data frame size, is done behind the scenes as part of the implementation of [`lapply()`](https://rdrr.io/r/base/lapply.html) and `map`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>map_norm</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://purrr.tidyverse.org/reference/map.html'>map</a></span><span class='o'>(</span><span class='nv'>df</span>, <span class='nv'>normalize</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>map_norm</span><span class='o'>)</span>
<span class='c'>#&gt; List of 4</span>
<span class='c'>#&gt;  $ a: num [1:10] 0 0.52 0.301 0.441 0.817 ...</span>
<span class='c'>#&gt;  $ b: num [1:10] 0.992 1 0.435 0 0.868 ...</span>
<span class='c'>#&gt;  $ c: num [1:10] 1 0.513 0.437 0.124 0.6 ...</span>
<span class='c'>#&gt;  $ d: num [1:10] 0.8526 0.0558 0.7913 0.1059 0 ...</span></code></pre>

</div>

Notice that the output of `map` (like `lapply`) is a list. But we can easily convert it into a data frame:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>map_norm_df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://purrr.tidyverse.org/reference/map.html'>map</a></span><span class='o'>(</span><span class='nv'>df</span>, <span class='nv'>normalize</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> 
  <span class='nv'>as_tibble</span>

<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>map_norm_df</span><span class='o'>)</span>
<span class='c'>#&gt; tibble [10 × 4] (S3: tbl_df/tbl/data.frame)</span>
<span class='c'>#&gt;  $ a: num [1:10] 0 0.52 0.301 0.441 0.817 ...</span>
<span class='c'>#&gt;  $ b: num [1:10] 0.992 1 0.435 0 0.868 ...</span>
<span class='c'>#&gt;  $ c: num [1:10] 1 0.513 0.437 0.124 0.6 ...</span>
<span class='c'>#&gt;  $ d: num [1:10] 0.8526 0.0558 0.7913 0.1059 0 ...</span></code></pre>

</div>

