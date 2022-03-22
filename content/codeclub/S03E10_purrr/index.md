---
title: "Session S03E10: Functional Programming With purrr functions"
subtitle: "Using functions from tidy's purrr package as an alternative to loops."
summary: "In this session of Code Club, we'll consider some functions from the purrr package, which can be used as efficient alternatives to for loops and the `apply()` functions we explored in the previous session."  
authors: [mike-sovic]
date: "2022-03-21"
output: hugodown::md_document
toc: true

rmd_hash: 6577bac7f740462c

---

------------------------------------------------------------------------

## Session Goals

-   List and differentiate between some useful purrr functions.
-   Compare purrr functions to the [`apply()`](https://rdrr.io/r/base/apply.html) functions from last session.
-   Use purrr functions as alternatives to loops.

------------------------------------------------------------------------

## Highlights From Last Session

In the previous session, we explored some functions from the [`apply()`](https://rdrr.io/r/base/apply.html) family of functions, which provided alternatives to writing loops to iteratively apply some function to the elements of a data structure such as a vector, list, or data frame. Let's start with a simple list with three entries...

### Generate An Example List

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>our_list</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span>A <span class='o'>=</span> <span class='m'>1</span><span class='o'>:</span><span class='m'>10</span>, B <span class='o'>=</span> <span class='m'>11</span><span class='o'>:</span><span class='m'>20</span>, C <span class='o'>=</span> <span class='m'>21</span><span class='o'>:</span><span class='m'>30</span><span class='o'>)</span>
<span class='nv'>our_list</span>

<span class='c'>#&gt; $A</span>
<span class='c'>#&gt;  [1]  1  2  3  4  5  6  7  8  9 10</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; $B</span>
<span class='c'>#&gt;  [1] 11 12 13 14 15 16 17 18 19 20</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; $C</span>
<span class='c'>#&gt;  [1] 21 22 23 24 25 26 27 28 29 30</span>
</code></pre>

</div>

We could use a loop to calculate the mean for each of the entries.

### Calculate Mean For Each List Entry With A Loop

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>results_loop</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='kr'>for</span> <span class='o'>(</span><span class='nv'>i</span> <span class='kr'>in</span> <span class='m'>1</span><span class='o'>:</span><span class='nf'><a href='https://rdrr.io/r/base/length.html'>length</a></span><span class='o'>(</span><span class='nv'>our_list</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>&#123;</span>
  <span class='nv'>results_loop</span><span class='o'>[</span><span class='nv'>i</span><span class='o'>]</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>our_list</span><span class='o'>[[</span><span class='nv'>i</span><span class='o'>]</span><span class='o'>]</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
<span class='o'>&#125;</span>

<span class='nv'>results_loop</span>

<span class='c'>#&gt; [[1]]</span>
<span class='c'>#&gt; [1] 5.5</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[2]]</span>
<span class='c'>#&gt; [1] 15.5</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[3]]</span>
<span class='c'>#&gt; [1] 25.5</span>
</code></pre>

</div>

Like we saw last week, [`lapply()`](https://rdrr.io/r/base/lapply.html) gave us an alternative way to do the same thing, and with simpler and clearer code...

### Calculate Mean For Each Variable With `lapply()`

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>res_lapply</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/lapply.html'>lapply</a></span><span class='o'>(</span><span class='nv'>our_list</span>, <span class='nv'>mean</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
<span class='nv'>res_lapply</span>

<span class='c'>#&gt; $A</span>
<span class='c'>#&gt; [1] 5.5</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; $B</span>
<span class='c'>#&gt; [1] 15.5</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; $C</span>
<span class='c'>#&gt; [1] 25.5</span>
</code></pre>

</div>

I mentioned in the previous session that when working with the [`apply()`](https://rdrr.io/r/base/apply.html) functions, it's important to think about the structure/type of data going in to the function, and also that getting returned by the function. We saw that the [`lapply()`](https://rdrr.io/r/base/lapply.html) example above returned a list, and can confirm that with...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>res_lapply</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "list"</span>
</code></pre>

</div>

We also saw that [`sapply()`](https://rdrr.io/r/base/lapply.html) was very similar to [`lapply()`](https://rdrr.io/r/base/lapply.html), but instead of a list being returned, the results were condensed down to a vector - specifically in this case, a numeric vector...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>res_sapply</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/lapply.html'>sapply</a></span><span class='o'>(</span><span class='nv'>our_list</span>, <span class='nv'>mean</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
<span class='nv'>res_sapply</span>

<span class='c'>#&gt;    A    B    C </span>
<span class='c'>#&gt;  5.5 15.5 25.5</span>

<span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>res_sapply</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "numeric"</span>
</code></pre>

</div>

## `map()` Functions From *purrr*

In this session, we're going to look at some of the `map()` functions from the *purrr* package, which is part of the *tidyverse*. In some cases, these functions return the same results as their [`apply()`](https://rdrr.io/r/base/apply.html) analogues. As an example, compare the `map()` function to [`lapply()`](https://rdrr.io/r/base/lapply.html)...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
<span class='nv'>res_map</span> <span class='o'>&lt;-</span> <span class='nf'>map</span><span class='o'>(</span><span class='nv'>our_list</span>, <span class='nv'>mean</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
<span class='nv'>res_map</span>

<span class='c'>#&gt; $A</span>
<span class='c'>#&gt; [1] 5.5</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; $B</span>
<span class='c'>#&gt; [1] 15.5</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; $C</span>
<span class='c'>#&gt; [1] 25.5</span>
</code></pre>

</div>

So why might you want to use the `map()` functions? There are two primary reasons...

1.  The syntax/names of the `map()` functions might be easier to understand and make for clearer code.
2.  The `map()` family provides additional functionality that might at best be cumbersome to achieve with the base R approaches. We won't get to this in this session, but see the `imap()` function for one example.

Ultimately, much of the value in using these `map()` functions gets realized when you start writing your own custom functions, which is something we haven't done yet, but will be doing soon. For now, we'll work with some fairly basic examples just to get introduced to some of the syntax and usage of these functions. There's a *purrr* cheatsheet that you might find helpful available at <https://raw.githubusercontent.com/rstudio/cheatsheets/main/purrr.pdf>

We'll start working with `map()` in the first breakout session...

### Breakout Exercises 1

Like with the first breakout exercise from last week, below I'm pulling out a subset of the numeric variables available in the *penguins* data frame and reformating them into a list named *pens_list* that we'll use to practice with `map()` functions.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/'>palmerpenguins</a></span><span class='o'>)</span>
<span class='nv'>pens_list</span> <span class='o'>&lt;-</span> <span class='nf'>select_if</span><span class='o'>(</span><span class='nv'>penguins</span>, <span class='nv'>is.numeric</span><span class='o'>)</span> <span class='o'>%&gt;%</span> <span class='nf'>select</span><span class='o'>(</span><span class='o'>-</span><span class='nv'>year</span><span class='o'>)</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>as.list</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>pens_list</span><span class='o'>)</span>

<span class='c'>#&gt; List of 4</span>
<span class='c'>#&gt;  $ bill_length_mm   : num [1:344] 39.1 39.5 40.3 NA 36.7 39.3 38.9 39.2 34.1 42 ...</span>
<span class='c'>#&gt;  $ bill_depth_mm    : num [1:344] 18.7 17.4 18 NA 19.3 20.6 17.8 19.6 18.1 20.2 ...</span>
<span class='c'>#&gt;  $ flipper_length_mm: int [1:344] 181 186 195 NA 193 190 181 195 193 190 ...</span>
<span class='c'>#&gt;  $ body_mass_g      : int [1:344] 3750 3800 3250 NA 3450 3650 3625 4675 3475 4250 ...</span>
</code></pre>

</div>

<div class="alert puzzle">

<div>

Use `map()` to calculate the mean value for each of the variables/entries in *pens_list*. What type of results are returned (i.e. is it a list, vector, data frame, etc)?

<details>
<summary>
Hints (click here)
</summary>

<br> Apply the [`mean()`](https://rdrr.io/r/base/mean.html) function with `map()`. Remember there are NA's in the data - see the help for [`mean()`](https://rdrr.io/r/base/mean.html) for dealing with those. You can view the result, or try [`class()`](https://rdrr.io/r/base/class.html) to get the type of object returned.

<br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>res_map</span> <span class='o'>&lt;-</span> <span class='nf'>map</span><span class='o'>(</span><span class='nv'>pens_list</span>, <span class='nv'>mean</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
<span class='nv'>res_map</span>

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
<span class='c'>#&gt; [1] 4201.754</span>

<span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>res_map</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "list"</span>
</code></pre>

</div>

</details>

</div>

</div>

<div class="alert puzzle">

<div>

As we saw last week, and in the example above, [`sapply()`](https://rdrr.io/r/base/lapply.html) is similar to [`lapply()`](https://rdrr.io/r/base/lapply.html), but returns results as a vector instead of as a list. Take a look at the help for `map()` and find a function that will return a vector of doubles (numerics) and apply it to the *pens_list* object like you just did with `map()`. Then find another function that will return the results as a data frame.

<details>
<summary>
Hints (click here)
</summary>

<br> Try the `map_dbl()` and `map_dfr()` functions.

<br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>map_vec</span> <span class='o'>&lt;-</span> <span class='nf'>map_dbl</span><span class='o'>(</span><span class='nv'>pens_list</span>, <span class='nv'>mean</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
<span class='nv'>map_vec</span>

<span class='c'>#&gt;    bill_length_mm     bill_depth_mm flipper_length_mm       body_mass_g </span>
<span class='c'>#&gt;          43.92193          17.15117         200.91520        4201.75439</span>


<span class='nv'>map_df</span> <span class='o'>&lt;-</span> <span class='nf'>map_dfr</span><span class='o'>(</span><span class='nv'>pens_list</span>, <span class='nv'>mean</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
<span class='nv'>map_df</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 1 x 4</span></span>
<span class='c'>#&gt;   bill_length_mm bill_depth_mm flipper_length_mm body_mass_g</span>
<span class='c'>#&gt;            <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>         </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>             </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span>           43.9          17.2              201.       </span><span style='text-decoration: underline;'>4</span><span>202.</span></span>
</code></pre>

</div>

<br>

</details>

</div>

</div>

Remember that with `map()`, the input is a single list or vector, and the function is applied to each element of the list of vector. A number of variants of the `map()` function are available that define the type of output that gets returned.

## `map2()`

While `map()` allowed us to apply some function to the elements of a single list or vector, `map2()` lets us apply some operation to paired elements from two lists (or vectors).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>our_list1</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='m'>1</span><span class='o'>:</span><span class='m'>10</span><span class='o'>)</span>
<span class='nv'>our_list1</span>

<span class='c'>#&gt; [[1]]</span>
<span class='c'>#&gt;  [1]  1  2  3  4  5  6  7  8  9 10</span>

<span class='nv'>our_list2</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='m'>11</span><span class='o'>:</span><span class='m'>20</span><span class='o'>)</span>
<span class='nv'>our_list2</span>

<span class='c'>#&gt; [[1]]</span>
<span class='c'>#&gt;  [1] 11 12 13 14 15 16 17 18 19 20</span>
</code></pre>

</div>

Here's we'll use `map2()` to get the sums of corresponding pairs of elements from the two lists...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>map2</span><span class='o'>(</span><span class='nv'>our_list1</span>, <span class='nv'>our_list2</span>, <span class='o'>~</span> <span class='nv'>.x</span> <span class='o'>+</span> <span class='nv'>.y</span><span class='o'>)</span>

<span class='c'>#&gt; [[1]]</span>
<span class='c'>#&gt;  [1] 12 14 16 18 20 22 24 26 28 30</span>
</code></pre>

</div>

The tilde (\~) in the third argument indicates a formula that will be converted to a function and applied. It's actually kind of a short-hand way to write and apply a custom function, but since we haven't gotten in to writing our own functions yet (though that's coming soon!), for now, just remember that the function passed to `map2()` has to take two arguments, which are defined as '.x' and '.y' (elements in corresponding positions of the first and second lists or vectors, respectively) in each iteration of the function.

### Breakout Exercises 2

Below are two vectors containing bill-measurement data from the penguins data frame (bill length and bill depth).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_length_mm</span> <span class='o'>&lt;-</span> <span class='nv'>pens_list</span><span class='o'>$</span><span class='nv'>bill_length_mm</span>
<span class='nv'>bill_depth_mm</span> <span class='o'>&lt;-</span> <span class='nv'>pens_list</span><span class='o'>$</span><span class='nv'>bill_depth_mm</span>
</code></pre>

</div>

<div class="alert puzzle">

<div>

Use `map2()` to calculate the bill ratio for each penguin (length/depth). Output the result as a vector containing doubles (numerics), and save it as the object *bill_ratios*.

<details>
<summary>
Hints (click here)
</summary>

<br> Apply the `map2_dbl()` function and use the third argument to define a formula that divides the length value by the width value.

<br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_ratios</span> <span class='o'>&lt;-</span> <span class='nf'>map2_dbl</span><span class='o'>(</span><span class='nv'>bill_length_mm</span>, <span class='nv'>bill_depth_mm</span>, <span class='o'>~</span> <span class='nv'>.x</span> <span class='o'>/</span> <span class='nv'>.y</span><span class='o'>)</span>
</code></pre>

</div>

</details>

</div>

</div>

<div class="alert puzzle">

<div>

How many of the penguins in the dataset have bill ratios greater than 3?

<details>
<summary>
Hints (click here)
</summary>

<br> Logicals in R can be interpreted as 1/0 (TRUE/FALSE). Try using [`sum()`](https://rdrr.io/r/base/sum.html) to sum over the results of a logical expression to get the number of ratios \> 3. Alternatively, you could index *bill_ratios* to retain just the values \> 3, and then get the length of that vector. Remember that there are NA's mixed in - how does this affect each of these two approaches?

<br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/sum.html'>sum</a></span><span class='o'>(</span><span class='nv'>bill_ratios</span> <span class='o'>&gt;</span> <span class='m'>3</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 109</span>


<span class='c'># OR</span>

<span class='nv'>bill_ratios</span><span class='o'>[</span><span class='nv'>bill_ratios</span> <span class='o'>&gt;</span> <span class='m'>3</span><span class='o'>]</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/stats/na.fail.html'>na.omit</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/base/length.html'>length</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 109</span>
</code></pre>

</div>

</details>

</div>

</div>

### Bonus

<div class="alert puzzle">

<div>

Here's one more dataset that's based on the *penguins* data (though much of it is made up). It represents measurements taken for each of three penguins over three years. *List1* has data for year 1, *List2* has data for year 2, and *List3* has data for year 3.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>yr1_list</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='s'>"Pen_1"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"bill_length_mm"</span> <span class='o'>=</span> <span class='m'>39.1</span>, <span class='s'>"bill_depth_mm"</span> <span class='o'>=</span> <span class='m'>18.7</span>, <span class='s'>"flipper_length_mm"</span> <span class='o'>=</span> <span class='m'>181</span>, <span class='s'>"body_mass_g"</span> <span class='o'>=</span> <span class='m'>3750</span><span class='o'>)</span>,
             <span class='s'>"Pen_2"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"bill_length_mm"</span> <span class='o'>=</span> <span class='m'>39.5</span>, <span class='s'>"bill_depth_mm"</span> <span class='o'>=</span> <span class='m'>17.4</span>, <span class='s'>"flipper_length_mm"</span> <span class='o'>=</span> <span class='m'>186</span>, <span class='s'>"body_mass_g"</span> <span class='o'>=</span> <span class='m'>3800</span><span class='o'>)</span>,
             <span class='s'>"Pen_3"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"bill_length_mm"</span> <span class='o'>=</span> <span class='m'>40.3</span>, <span class='s'>"bill_depth_mm"</span> <span class='o'>=</span> <span class='m'>18</span>, <span class='s'>"flipper_length_mm"</span> <span class='o'>=</span> <span class='m'>195</span>, <span class='s'>"body_mass_g"</span> <span class='o'>=</span> <span class='m'>3250</span><span class='o'>)</span><span class='o'>)</span>

<span class='nv'>yr2_list</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='s'>"Pen_1"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"bill_length_mm"</span> <span class='o'>=</span> <span class='m'>39.8</span>, <span class='s'>"bill_depth_mm"</span> <span class='o'>=</span> <span class='m'>18.9</span>, <span class='s'>"flipper_length_mm"</span> <span class='o'>=</span> <span class='m'>184</span>, <span class='s'>"body_mass_g"</span> <span class='o'>=</span> <span class='m'>3767</span><span class='o'>)</span>,
             <span class='s'>"Pen_2"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"bill_length_mm"</span> <span class='o'>=</span> <span class='m'>38.7</span>, <span class='s'>"bill_depth_mm"</span> <span class='o'>=</span> <span class='m'>17.2</span>, <span class='s'>"flipper_length_mm"</span> <span class='o'>=</span> <span class='m'>186</span>, <span class='s'>"body_mass_g"</span> <span class='o'>=</span> <span class='m'>3745</span><span class='o'>)</span>,
             <span class='s'>"Pen_3"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"bill_length_mm"</span> <span class='o'>=</span> <span class='m'>40.7</span>, <span class='s'>"bill_depth_mm"</span> <span class='o'>=</span> <span class='m'>18.6</span>, <span class='s'>"flipper_length_mm"</span> <span class='o'>=</span> <span class='m'>217</span>, <span class='s'>"body_mass_g"</span> <span class='o'>=</span> <span class='m'>3470</span><span class='o'>)</span><span class='o'>)</span>

<span class='nv'>yr3_list</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='s'>"Pen_1"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"bill_length_mm"</span> <span class='o'>=</span> <span class='m'>40.2</span>, <span class='s'>"bill_depth_mm"</span> <span class='o'>=</span> <span class='m'>19.3</span>, <span class='s'>"flipper_length_mm"</span> <span class='o'>=</span> <span class='m'>188</span>, <span class='s'>"body_mass_g"</span> <span class='o'>=</span> <span class='m'>3790</span><span class='o'>)</span>,
             <span class='s'>"Pen_2"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"bill_length_mm"</span> <span class='o'>=</span> <span class='m'>38.4</span>, <span class='s'>"bill_depth_mm"</span> <span class='o'>=</span> <span class='m'>17.0</span>, <span class='s'>"flipper_length_mm"</span> <span class='o'>=</span> <span class='m'>187</span>, <span class='s'>"body_mass_g"</span> <span class='o'>=</span> <span class='m'>3710</span><span class='o'>)</span>,
             <span class='s'>"Pen_3"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"bill_length_mm"</span> <span class='o'>=</span> <span class='m'>40.9</span>, <span class='s'>"bill_depth_mm"</span> <span class='o'>=</span> <span class='m'>18.9</span>, <span class='s'>"flipper_length_mm"</span> <span class='o'>=</span> <span class='m'>228</span>, <span class='s'>"body_mass_g"</span> <span class='o'>=</span> <span class='m'>3493</span><span class='o'>)</span><span class='o'>)</span>
</code></pre>

</div>

Try calculating the average value for each of the variables for each penguin over the three years. Output the results as a data frame.

<details>
<summary>
Hints (click here)
</summary>

<br>

Take a look at the help for `pmap()`. It has some similarities to `map2()`, but instead of applying to 2 lists, `pmap()` works with 3 or more. Notice the names of the lists the function will be applied to are given as a single argument (a list). Provide a formula to calculate the mean. Unlike the `map2()` function, which only works on functions that take 2 arguments (denoted '.x' and '.y'), the number of arguments passed to the function used in `pmap()` can be three or more, and they are denoted '..1', '..2', '..3', etc.

<br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>pmap_dfr</span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='nv'>yr1_list</span>, <span class='nv'>yr2_list</span>, <span class='nv'>yr3_list</span><span class='o'>)</span>, <span class='o'>~</span> <span class='o'>(</span><span class='nv'>..1</span> <span class='o'>+</span> <span class='nv'>..2</span> <span class='o'>+</span> <span class='nv'>..3</span><span class='o'>)</span><span class='o'>/</span><span class='m'>3</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 x 4</span></span>
<span class='c'>#&gt;   bill_length_mm bill_depth_mm flipper_length_mm body_mass_g</span>
<span class='c'>#&gt;            <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>         </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>             </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span>           39.7          19.0              184.       </span><span style='text-decoration: underline;'>3</span><span>769 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span>           38.9          17.2              186.       </span><span style='text-decoration: underline;'>3</span><span>752.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span>           40.6          18.5              213.       </span><span style='text-decoration: underline;'>3</span><span>404.</span></span>
</code></pre>

</div>

</details>

</div>

</div>

