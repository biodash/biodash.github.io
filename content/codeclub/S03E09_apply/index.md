---
title: "Session S03E09: Functional Programming With Apply() functions"
subtitle: "Using the `apply()` functions of base R as an alternative to loops."
summary: "In this session of Code Club, we'll consider the `apply()` family of functions, which can often be used as efficient alternatives to writing some of the loops we worked with in the previous session."  
authors: [mike-sovic]
date: "2022-03-08"
output: hugodown::md_document
toc: true

rmd_hash: caf6b66d656f90da

---

------------------------------------------------------------------------

## Session Goals

-   Continue practicing with loops in R.
-   Describe how the [`apply()`](https://rdrr.io/r/base/apply.html) functions relate to loops in R.
-   Use apply functions as alternatives to loops.
-   Identify the input and output formats associated with different [`apply()`](https://rdrr.io/r/base/apply.html) functions.

------------------------------------------------------------------------

## Highlights From Recent Sessions

In the past several sessions, we've talked about several things that have relevance to today's discussion of the [`apply()`](https://rdrr.io/r/base/apply.html) functions. Here's a quick review...

### Data Structures And Indexing

There are several widely-used data structures in R. They include vectors, lists, and data frames. As Michael Broe showed in [a recent session on data structures](https://biodash.github.io/codeclub/s03e06_datastructures/), each of these can be indexed, which means we can pull out one or more specific elements from those structures.

### Vectors

Vectors have one dimension (can be characterized by their length), and all the elements of any vector in R have to be of the same class. They are often created with the [`c()`](https://rdrr.io/r/base/c.html) (combine) function...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#Create some vectors</span>
<span class='nv'>num_vector1</span> <span class='o'>&lt;-</span> <span class='m'>1</span><span class='o'>:</span><span class='m'>10</span>
<span class='nv'>num_vector1</span>

<span class='c'>#&gt;  [1]  1  2  3  4  5  6  7  8  9 10</span>

<span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>num_vector1</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "integer"</span>

<span class='nv'>num_vector2</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1</span>,<span class='m'>2</span>,<span class='m'>6</span>,<span class='m'>10</span><span class='o'>)</span>
<span class='nv'>num_vector2</span>

<span class='c'>#&gt; [1]  1  2  6 10</span>

<span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>num_vector2</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "numeric"</span>

<span class='nv'>log_vector</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='kc'>TRUE</span>, <span class='kc'>FALSE</span>, <span class='kc'>TRUE</span>, <span class='kc'>FALSE</span><span class='o'>)</span>
<span class='nv'>log_vector</span>

<span class='c'>#&gt; [1]  TRUE FALSE  TRUE FALSE</span>

<span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>log_vector</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "logical"</span>

<span class='c'>#Index a vector</span>
<span class='nv'>num_vector2</span><span class='o'>[</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1</span>,<span class='m'>3</span><span class='o'>)</span><span class='o'>]</span>

<span class='c'>#&gt; [1] 1 6</span>

<span class='nv'>num_vector2</span><span class='o'>[</span><span class='nv'>log_vector</span><span class='o'>]</span>

<span class='c'>#&gt; [1] 1 6</span>
</code></pre>

</div>

### Lists

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#Create a list</span>
<span class='nv'>my_list</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='s'>"num_vec1"</span> <span class='o'>=</span> <span class='nv'>num_vector1</span>,
                <span class='s'>"num_vec2"</span> <span class='o'>=</span> <span class='nv'>num_vector2</span>,
                <span class='s'>"log_vec"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='kc'>TRUE</span>, <span class='kc'>FALSE</span>, <span class='kc'>TRUE</span>, <span class='kc'>FALSE</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#View the list</span>
<span class='nv'>my_list</span>

<span class='c'>#&gt; $num_vec1</span>
<span class='c'>#&gt;  [1]  1  2  3  4  5  6  7  8  9 10</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; $num_vec2</span>
<span class='c'>#&gt; [1]  1  2  6 10</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; $log_vec</span>
<span class='c'>#&gt; [1]  TRUE FALSE  TRUE FALSE</span>

<span class='c'>#Try some indexing</span>
<span class='nv'>my_list</span><span class='o'>[</span><span class='m'>2</span><span class='o'>]</span>

<span class='c'>#&gt; $num_vec2</span>
<span class='c'>#&gt; [1]  1  2  6 10</span>

<span class='nv'>my_list</span><span class='o'>[[</span><span class='m'>2</span><span class='o'>]</span><span class='o'>]</span>

<span class='c'>#&gt; [1]  1  2  6 10</span>

<span class='nv'>my_list</span><span class='o'>$</span><span class='nv'>num_vec2</span>

<span class='c'>#&gt; [1]  1  2  6 10</span>
</code></pre>

</div>

### Data Frames

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#Create a data frame</span>
<span class='nv'>my_df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/data.frame.html'>data.frame</a></span><span class='o'>(</span><span class='s'>"num_vec"</span> <span class='o'>=</span> <span class='nv'>num_vector2</span>,
                <span class='s'>"log_vec"</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='kc'>TRUE</span>, <span class='kc'>FALSE</span>, <span class='kc'>TRUE</span>, <span class='kc'>FALSE</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#View the data frame</span>
<span class='nv'>my_df</span>

<span class='c'>#&gt;   num_vec log_vec</span>
<span class='c'>#&gt; 1       1    TRUE</span>
<span class='c'>#&gt; 2       2   FALSE</span>
<span class='c'>#&gt; 3       6    TRUE</span>
<span class='c'>#&gt; 4      10   FALSE</span>


<span class='c'>#OR</span>

<span class='nv'>my_df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/as.data.frame.html'>as.data.frame</a></span><span class='o'>(</span><span class='nv'>my_list</span><span class='o'>[</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>2</span>,<span class='m'>3</span><span class='o'>)</span><span class='o'>]</span><span class='o'>)</span>

<span class='nv'>my_df</span>

<span class='c'>#&gt;   num_vec2 log_vec</span>
<span class='c'>#&gt; 1        1    TRUE</span>
<span class='c'>#&gt; 2        2   FALSE</span>
<span class='c'>#&gt; 3        6    TRUE</span>
<span class='c'>#&gt; 4       10   FALSE</span>


<span class='c'>#Index the data frame</span>
<span class='nv'>my_df</span><span class='o'>[</span><span class='m'>2</span><span class='o'>]</span>

<span class='c'>#&gt;   log_vec</span>
<span class='c'>#&gt; 1    TRUE</span>
<span class='c'>#&gt; 2   FALSE</span>
<span class='c'>#&gt; 3    TRUE</span>
<span class='c'>#&gt; 4   FALSE</span>


<span class='nv'>my_df</span><span class='o'>[[</span><span class='m'>2</span><span class='o'>]</span><span class='o'>]</span>

<span class='c'>#&gt; [1]  TRUE FALSE  TRUE FALSE</span>


<span class='nv'>my_df</span><span class='o'>$</span><span class='nv'>log_vec</span>

<span class='c'>#&gt; [1]  TRUE FALSE  TRUE FALSE</span>
</code></pre>

</div>

### Loops

As Jelmer demonstrated in [last week's session](https://biodash.github.io/codeclub/s03e08_loops/), loops allow you to iteratively apply some task(s) to a series of inputs. In the simple loop below, we take each of three three values (1,3,6), print a statement with the original value, then negate the value and print another statement with the updated value...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'>for</span> <span class='o'>(</span><span class='nv'>x</span> <span class='kr'>in</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1</span>,<span class='m'>3</span>,<span class='m'>6</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>&#123;</span>
  <span class='nf'><a href='https://rdrr.io/r/base/print.html'>print</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/paste.html'>paste0</a></span><span class='o'>(</span><span class='s'>"Input value is "</span>, <span class='nv'>x</span><span class='o'>)</span><span class='o'>)</span>
  <span class='nv'>x</span> <span class='o'>&lt;-</span> <span class='o'>-</span><span class='nv'>x</span>
  <span class='nf'><a href='https://rdrr.io/r/base/print.html'>print</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/paste.html'>paste0</a></span><span class='o'>(</span><span class='s'>"Negated value is "</span>, <span class='nv'>x</span><span class='o'>)</span><span class='o'>)</span>
<span class='o'>&#125;</span>

<span class='c'>#&gt; [1] "Input value is 1"</span>
<span class='c'>#&gt; [1] "Negated value is -1"</span>
<span class='c'>#&gt; [1] "Input value is 3"</span>
<span class='c'>#&gt; [1] "Negated value is -3"</span>
<span class='c'>#&gt; [1] "Input value is 6"</span>
<span class='c'>#&gt; [1] "Negated value is -6"</span>
</code></pre>

</div>

### Functions

We use functions abundantly in R. Even the simple examples above used multiple functions, including [`c()`](https://rdrr.io/r/base/c.html), which combined items into a vector, [`class()`](https://rdrr.io/r/base/class.html), which returned the type, or class of an object, and [`paste0()`](https://rdrr.io/r/base/paste.html), which allowed us to stitch together character vectors and objects into a single expression. Functions typically accept (and often require) arguments - pieces of information that are provided inside the parentheses that may provide input for the function or details that modify its behavior. As a simple example, setting the na.rm argument in the [`mean()`](https://rdrr.io/r/base/mean.html) function provides a mean for all values in a vector after removing any that are NA. Otherwise, the mean is returned as "NA"...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>values</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1</span><span class='o'>:</span><span class='m'>5</span>, <span class='kc'>NA</span>, <span class='m'>7</span><span class='o'>:</span><span class='m'>10</span><span class='o'>)</span>
<span class='nv'>values</span>

<span class='c'>#&gt;  [1]  1  2  3  4  5 NA  7  8  9 10</span>

<span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>values</span><span class='o'>)</span>

<span class='c'>#&gt; [1] NA</span>

<span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>values</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 5.444444</span>
</code></pre>

</div>

## Functionals

In contrast to traditional arguments like the *na.rm* above, some functions accept other functions as arguments - these are sometimes called *functionals*. In this session we'll look at some of the functionals in the [`apply()`](https://rdrr.io/r/base/apply.html) group. These provide alternatives to writing loops by allowing us to iteratively apply some function over structures like lists or data frames. They include...

-   [`apply()`](https://rdrr.io/r/base/apply.html) - apply some function to the margins (rows or columns) of a rectangular object (i.e. matrix or data frame)
-   [`lapply()`](https://rdrr.io/r/base/lapply.html) - apply some function to each element of a list
-   [`sapply()`](https://rdrr.io/r/base/lapply.html) - similar to [`lapply()`](https://rdrr.io/r/base/lapply.html), but provides output in a different format
-   [`mapply()`](https://rdrr.io/r/base/mapply.html) - apply a function to multiple lists

Key to understanding how and when to use each of these is thinking about the structure of the data going in and the structure of the results that get returned. We'll start with [`lapply()`](https://rdrr.io/r/base/lapply.html).

### `lapply()`

[`lapply()`](https://rdrr.io/r/base/lapply.html) allows you to iteratively apply a function to items in a list, and by default, returns a list of results with the same number of entries as the input had. The only required arguments are the list the function will be applied to and the function itself. Keep in mind that these [`apply()`](https://rdrr.io/r/base/apply.html) functions are alternatives to loops. We'll try calculating means with both the loop approach and the [`apply()`](https://rdrr.io/r/base/apply.html) approach on the *simple_list* example below...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>simple_list</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='m'>1</span><span class='o'>:</span><span class='m'>10</span>,
                    <span class='m'>11</span><span class='o'>:</span><span class='m'>15</span>,
                    <span class='m'>16</span><span class='o'>:</span><span class='m'>30</span><span class='o'>)</span>

<span class='nv'>simple_list</span>

<span class='c'>#&gt; [[1]]</span>
<span class='c'>#&gt;  [1]  1  2  3  4  5  6  7  8  9 10</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[2]]</span>
<span class='c'>#&gt; [1] 11 12 13 14 15</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[3]]</span>
<span class='c'>#&gt;  [1] 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30</span>
</code></pre>

</div>

#### Calculate Means With A Loop

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>num_entries</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/length.html'>length</a></span><span class='o'>(</span><span class='nv'>simple_list</span><span class='o'>)</span>
<span class='nv'>results_list_loop</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='kr'>for</span> <span class='o'>(</span><span class='nv'>i</span> <span class='kr'>in</span> <span class='m'>1</span><span class='o'>:</span><span class='nv'>num_entries</span><span class='o'>)</span> <span class='o'>&#123;</span>
  <span class='nv'>current_mean</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>simple_list</span><span class='o'>[[</span><span class='nv'>i</span><span class='o'>]</span><span class='o'>]</span><span class='o'>)</span>
  <span class='nv'>results_list_loop</span><span class='o'>[</span><span class='nv'>i</span><span class='o'>]</span> <span class='o'>&lt;-</span> <span class='nv'>current_mean</span>
  
<span class='o'>&#125;</span>

<span class='nv'>results_list_loop</span>

<span class='c'>#&gt; [[1]]</span>
<span class='c'>#&gt; [1] 5.5</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[2]]</span>
<span class='c'>#&gt; [1] 13</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[3]]</span>
<span class='c'>#&gt; [1] 23</span>
</code></pre>

</div>

#### Calculate Means With `lapply()`

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>results_list_apply</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/lapply.html'>lapply</a></span><span class='o'>(</span><span class='nv'>simple_list</span>, <span class='nv'>mean</span><span class='o'>)</span>

<span class='nv'>results_list_apply</span>

<span class='c'>#&gt; [[1]]</span>
<span class='c'>#&gt; [1] 5.5</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[2]]</span>
<span class='c'>#&gt; [1] 13</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[3]]</span>
<span class='c'>#&gt; [1] 23</span>
</code></pre>

</div>

Notice we can use a lot less code with [`lapply()`](https://rdrr.io/r/base/lapply.html) to get the same result as with the for loop.

Give [`lapply()`](https://rdrr.io/r/base/lapply.html) a try in a Breakout Room...

### Breakout Exercises 1

As we've talked about before, lists and data frames are closely related data structures in R - data frames are a special type of list in which all the entries are of the same size, and so they can be neatly organized into a rectangular row/column structure. When data fit that rectangular pattern, it's easy to switch them between lists and data frames.

The code below pulls out the columns of the penguins data frame that are numeric and reformats them into a list named *pens_list*, which we're previewing with the [`str()`](https://rdrr.io/r/utils/str.html) function.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/'>palmerpenguins</a></span><span class='o'>)</span>
<span class='nv'>pens_list</span> <span class='o'>&lt;-</span> <span class='nf'>select_if</span><span class='o'>(</span><span class='nv'>penguins</span>, <span class='nv'>is.numeric</span><span class='o'>)</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>as.list</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>pens_list</span><span class='o'>)</span>

<span class='c'>#&gt; List of 5</span>
<span class='c'>#&gt;  $ bill_length_mm   : num [1:344] 39.1 39.5 40.3 NA 36.7 39.3 38.9 39.2 34.1 42 ...</span>
<span class='c'>#&gt;  $ bill_depth_mm    : num [1:344] 18.7 17.4 18 NA 19.3 20.6 17.8 19.6 18.1 20.2 ...</span>
<span class='c'>#&gt;  $ flipper_length_mm: int [1:344] 181 186 195 NA 193 190 181 195 193 190 ...</span>
<span class='c'>#&gt;  $ body_mass_g      : int [1:344] 3750 3800 3250 NA 3450 3650 3625 4675 3475 4250 ...</span>
<span class='c'>#&gt;  $ year             : int [1:344] 2007 2007 2007 2007 2007 2007 2007 2007 2007 2007 ...</span>
</code></pre>

</div>

<div class="alert puzzle">

<div>

Calculate the median value for each of the variables/entries in *pens_list*.

<details>
<summary>
Hints (click here)
</summary>

<br> You can write a loop to do this, or, preferably, use [`lapply()`](https://rdrr.io/r/base/lapply.html). You'll need one additional argument (na.rm) for the [`median()`](https://rdrr.io/r/stats/median.html) function - see the [`mean()`](https://rdrr.io/r/base/mean.html) example above, or check the help for the [`median()`](https://rdrr.io/r/stats/median.html) and [`lapply()`](https://rdrr.io/r/base/lapply.html) functions for more details.

<br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># loop option</span>
<span class='nv'>results_loop</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='kr'>for</span> <span class='o'>(</span><span class='nv'>i</span> <span class='kr'>in</span> <span class='m'>1</span><span class='o'>:</span><span class='nf'><a href='https://rdrr.io/r/base/length.html'>length</a></span><span class='o'>(</span><span class='nv'>pens_list</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>&#123;</span>
  <span class='nv'>results_loop</span><span class='o'>[</span><span class='nv'>i</span><span class='o'>]</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/median.html'>median</a></span><span class='o'>(</span><span class='nv'>pens_list</span><span class='o'>[[</span><span class='nv'>i</span><span class='o'>]</span><span class='o'>]</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
<span class='o'>&#125;</span>

<span class='nv'>results_loop</span>

<span class='c'>#&gt; [[1]]</span>
<span class='c'>#&gt; [1] 44.45</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[2]]</span>
<span class='c'>#&gt; [1] 17.3</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[3]]</span>
<span class='c'>#&gt; [1] 197</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[4]]</span>
<span class='c'>#&gt; [1] 4050</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[5]]</span>
<span class='c'>#&gt; [1] 2008</span>


<span class='c'>#lapply option</span>
<span class='nf'><a href='https://rdrr.io/r/base/lapply.html'>lapply</a></span><span class='o'>(</span><span class='nv'>pens_list</span>, <span class='nv'>median</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>

<span class='c'>#&gt; $bill_length_mm</span>
<span class='c'>#&gt; [1] 44.45</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; $bill_depth_mm</span>
<span class='c'>#&gt; [1] 17.3</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; $flipper_length_mm</span>
<span class='c'>#&gt; [1] 197</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; $body_mass_g</span>
<span class='c'>#&gt; [1] 4050</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; $year</span>
<span class='c'>#&gt; [1] 2008</span>
</code></pre>

</div>

</details>

</div>

</div>

<div class="alert puzzle">

<div>

You might have noticed that one of the columns is *year*. We don't really need to get the median for that, so use [`lapply()`](https://rdrr.io/r/base/lapply.html) to calculate the medians again, but this time only do it for the first 4 columns. Also, have it return useful names for the list items with the USE.NAMES argument.

<details>
<summary>
Hints (click here)
</summary>

<br> Index the list in the [`lapply()`](https://rdrr.io/r/base/lapply.html) function with square brackets to apply the function to just the first 4 entries. Set USE.NAMES to TRUE.

<br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'>
<span class='c'>#lapply option</span>
<span class='nf'><a href='https://rdrr.io/r/base/lapply.html'>lapply</a></span><span class='o'>(</span><span class='nv'>pens_list</span><span class='o'>[</span><span class='m'>1</span><span class='o'>:</span><span class='m'>4</span><span class='o'>]</span>, <span class='nv'>median</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span>, USE.NAMES <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>

<span class='c'>#&gt; $bill_length_mm</span>
<span class='c'>#&gt; [1] 44.45</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; $bill_depth_mm</span>
<span class='c'>#&gt; [1] 17.3</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; $flipper_length_mm</span>
<span class='c'>#&gt; [1] 197</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; $body_mass_g</span>
<span class='c'>#&gt; [1] 4050</span>
</code></pre>

</div>

<br>

</details>

</div>

</div>

<div class="alert puzzle">

<div>

Try the same code again, but this time run it with [`sapply()`](https://rdrr.io/r/base/lapply.html) instead of [`lapply()`](https://rdrr.io/r/base/lapply.html). What's the difference in these two functions?

<details>
<summary>
Hints (click here)
</summary>

<br> Simply replace [`lapply()`](https://rdrr.io/r/base/lapply.html) from the previous exercise with [`sapply()`](https://rdrr.io/r/base/lapply.html).

<br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/lapply.html'>sapply</a></span><span class='o'>(</span><span class='nv'>pens_list</span><span class='o'>[</span><span class='m'>1</span><span class='o'>:</span><span class='m'>4</span><span class='o'>]</span>, <span class='nv'>median</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span>, USE.NAMES <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>

<span class='c'>#&gt;    bill_length_mm     bill_depth_mm flipper_length_mm       body_mass_g </span>
<span class='c'>#&gt;             44.45             17.30            197.00           4050.00</span>
</code></pre>

</div>

</details>

</div>

</div>

<br>

### `apply()`

[`lapply()`](https://rdrr.io/r/base/lapply.html) allowed us to apply a function to separate entries in a list. [`apply()`](https://rdrr.io/r/base/apply.html) does something similar, but applies the function to the margins (rows or columns) of objects with two dimensions like data frames or matrices.

Let's start with a simple matrix...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>simple_mat</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/matrix.html'>matrix</a></span><span class='o'>(</span><span class='m'>1</span><span class='o'>:</span><span class='m'>15</span>, nrow <span class='o'>=</span> <span class='m'>3</span><span class='o'>)</span>

<span class='nv'>simple_mat</span>

<span class='c'>#&gt;      [,1] [,2] [,3] [,4] [,5]</span>
<span class='c'>#&gt; [1,]    1    4    7   10   13</span>
<span class='c'>#&gt; [2,]    2    5    8   11   14</span>
<span class='c'>#&gt; [3,]    3    6    9   12   15</span>
</code></pre>

</div>

Now we'll use [`apply()`](https://rdrr.io/r/base/apply.html) to get means for entries in *simple_mat*. Like [`lapply()`](https://rdrr.io/r/base/lapply.html), [`apply()`](https://rdrr.io/r/base/apply.html) requires that we provide arguments to define the object the function will be applied to and the function itself. But since with [`apply()`](https://rdrr.io/r/base/apply.html) the function can either be applied to the rows or columns, we need a third argument to specify which we want. This is done with either a '1' for rows or a '2' for columns...

#### Get The Mean For Each Column

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/apply.html'>apply</a></span><span class='o'>(</span><span class='nv'>simple_mat</span>, <span class='m'>2</span>, <span class='nv'>mean</span><span class='o'>)</span>

<span class='c'>#&gt; [1]  2  5  8 11 14</span>
</code></pre>

</div>

#### Get The Mean For Each Row

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/apply.html'>apply</a></span><span class='o'>(</span><span class='nv'>simple_mat</span>, <span class='m'>1</span>, <span class='nv'>mean</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 7 8 9</span>
</code></pre>

</div>

### Breakout Exercises 2

The code below will download a dataframe that contains average monthly temperature data for 282 US locations from 1981-2010, reformat it a bit to make it easier to work with, and store it as the object *temp_data*.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>temp_data</span> <span class='o'>&lt;-</span> <span class='nf'>read_csv</span><span class='o'>(</span><span class='s'>'https://raw.githubusercontent.com/biodash/biodash.github.io/master/assets/data/temperature/city_temp_data_noaa.csv'</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>unite</span><span class='o'>(</span><span class='s'>"Location"</span>,
        <span class='nv'>City</span>, <span class='nv'>State</span>,
        sep <span class='o'>=</span> <span class='s'>" "</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>column_to_rownames</span><span class='o'>(</span><span class='s'>"Location"</span><span class='o'>)</span>
</code></pre>

</div>

<div class="alert puzzle">

<div>

Preview *temp_data*. How is it structured? What do the rows and columns represent?

<details>
<summary>
Hints (click here)
</summary>

<br> Use [`head()`](https://rdrr.io/r/utils/head.html) or `glimpse()` to preview the dataset.

<br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>temp_data</span><span class='o'>)</span>

<span class='c'>#&gt;                   JAN  FEB  MAR  APR  MAY  JUN  JUL  AUG  SEP  OCT  NOV  DEC</span>
<span class='c'>#&gt; BIRMINGHAM AP AL 53.8 58.4 66.7 74.4 81.5 87.7 90.8 90.6 85.1 75.3 65.4 55.9</span>
<span class='c'>#&gt; HUNTSVILLE AL    51.2 55.9 64.9 73.6 81.3 88.2 90.7 90.9 85.0 74.6 63.7 53.5</span>
<span class='c'>#&gt; MOBILE AL        60.0 63.2 69.8 76.1 83.0 88.2 90.4 90.5 87.3 79.4 70.3 61.9</span>
<span class='c'>#&gt; MONTGOMERY AL    57.4 61.8 69.7 76.6 84.0 89.8 92.1 91.9 87.3 78.3 69.0 59.6</span>
<span class='c'>#&gt; ANCHORAGE AK     23.1 26.6 33.9 44.5 56.0 62.8 65.4 63.5 55.1 40.5 27.8 24.8</span>
<span class='c'>#&gt; ANNETTE AK       41.6 42.7 44.9 50.2 56.3 61.1 64.3 64.7 59.3 51.6 44.6 41.5</span>
</code></pre>

</div>

</details>

</div>

</div>

<div class="alert puzzle">

<div>

Now calculate the mean temperature for each month. Based on the locations sampled, what month is the warmest overall? The coldest?

<details>
<summary>
Hints (click here)
</summary>

<br> Use [`apply()`](https://rdrr.io/r/base/apply.html) to calculate the means for each column (columns are designated with '2').

<br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/apply.html'>apply</a></span><span class='o'>(</span><span class='nv'>temp_data</span>, <span class='m'>2</span>, <span class='nv'>mean</span><span class='o'>)</span>

<span class='c'>#&gt;      JAN      FEB      MAR      APR      MAY      JUN      JUL      AUG </span>
<span class='c'>#&gt; 44.35709 48.03156 55.75035 64.83936 73.33227 80.73582 84.88865 83.81418 </span>
<span class='c'>#&gt;      SEP      OCT      NOV      DEC </span>
<span class='c'>#&gt; 77.35922 66.87234 55.59610 46.22589</span>
</code></pre>

</div>

</details>

</div>

</div>

<div class="alert puzzle">

<div>

Now calculate the mean temperature for each location. Which location has the warmest annual temperature? The coldest? Since there are a lot of results to sort through, consider using indexing to extract the warmest and coldest temperatures.

<details>
<summary>
Hints (click here)
</summary>

<br> Use [`apply()`](https://rdrr.io/r/base/apply.html) to calculate the means for each row (rows are designated with '1'). Save the results to an object, and then use logical indexing in combination with the [`max()`](https://rdrr.io/r/base/Extremes.html) function to pull out the entry with the maximum value or [`min()`](https://rdrr.io/r/base/Extremes.html) to pull out the minimum value.

<br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>row_means</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/apply.html'>apply</a></span><span class='o'>(</span><span class='nv'>temp_data</span>, <span class='m'>1</span>, <span class='nv'>mean</span><span class='o'>)</span>
<span class='nv'>row_means</span><span class='o'>[</span><span class='nv'>row_means</span> <span class='o'>==</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='o'>(</span><span class='nv'>row_means</span><span class='o'>)</span><span class='o'>]</span>

<span class='c'>#&gt; POHNPEI-CAROLINE IS. PC </span>
<span class='c'>#&gt;                  88.175</span>

<span class='nv'>row_means</span><span class='o'>[</span><span class='nv'>row_means</span> <span class='o'>==</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>min</a></span><span class='o'>(</span><span class='nv'>row_means</span><span class='o'>)</span><span class='o'>]</span>

<span class='c'>#&gt; BARROW AK </span>
<span class='c'>#&gt;  17.18333</span>
</code></pre>

</div>

</details>

</div>

</div>

<div class="alert puzzle">

<div>

How many locations have a mean temp \> 75F?

<details>
<summary>
Hints (click here)
</summary>

<br> Use indexing like in the previous exercise. You can print the results, or use the length function to get the number returned.

<br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>row_means</span><span class='o'>[</span><span class='nv'>row_means</span> <span class='o'>&gt;</span> <span class='m'>75</span><span class='o'>]</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/base/length.html'>length</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 68</span>
</code></pre>

</div>

</details>

</div>

</div>

### Bonus

<div class="alert puzzle">

<div>

How many states or territories have at least one city in the dataset with a mean temp \> 75F?

<details>
<summary>
Hints (click here)
</summary>

<br> The states or territories are given by the last 2 characters in the row names of the data frame (which become the names of the vector elements in the results of [`apply()`](https://rdrr.io/r/base/apply.html)). Extract the set of names, use a regular expression to pull out the last two characters from each (consider `stringr::str_rep`, or [`gsub()`](https://rdrr.io/r/base/grep.html)), then unique them to get each one that's represented and find the length of that vector.

<br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>loc_names</span> <span class='o'>&lt;-</span> <span class='nv'>row_means</span><span class='o'>[</span><span class='nv'>row_means</span> <span class='o'>&gt;</span> <span class='m'>75</span><span class='o'>]</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/base/names.html'>names</a></span><span class='o'>(</span><span class='o'>)</span> 
<span class='nv'>states</span> <span class='o'>&lt;-</span> <span class='nf'>stringr</span><span class='nf'>::</span><span class='nf'><a href='https://stringr.tidyverse.org/reference/str_replace.html'>str_replace</a></span><span class='o'>(</span><span class='nv'>loc_names</span>, <span class='s'>"(.+)(..)"</span>, <span class='s'>"\\2"</span> <span class='o'>)</span>
<span class='nv'>unique_states</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/unique.html'>unique</a></span><span class='o'>(</span><span class='nv'>states</span><span class='o'>)</span>
<span class='nv'>unique_states</span>

<span class='c'>#&gt;  [1] "AL" "AZ" "CA" "FL" "GA" "HI" "LA" "MS" "NV" "NM" "SC" "TX" "PC" "PR"</span>


<span class='nf'><a href='https://rdrr.io/r/base/length.html'>length</a></span><span class='o'>(</span><span class='nv'>unique_states</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 14</span>
</code></pre>

</div>

</details>

</div>

</div>

<br>

------------------------------------------------------------------------

## Purrr: An Alternative (Tidy) Approach To `apply()` Functions

There are *tidy* alternatives to the apply functions - they're part of the *purrr* package, which we'll explore in the next session. In the meantime, if you want a preview, you can find details on *purrr* [here](https://purrr.tidyverse.org/).

------------------------------------------------------------------------

