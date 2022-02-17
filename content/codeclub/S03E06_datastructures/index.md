---
title: "S03E06: Data structures and subsetting"
subtitle: "Overview of data structures and how to access them"
summary: "In this session of Code Club, we'll move below and beyond the tidyverse to get an overview of accessing various kinds of data structure in R."  
authors: [michael-broe]
date: "2022-02-15"
output: hugodown::md_document
toc: true
image: 
  caption: "Image from https://r4ds.had.co.nz"
  focal_point: ""
  preview_only: false
editor_options: 
  markdown: 
    wrap: 72
rmd_hash: 5382f014e3d29e9e

---

------------------------------------------------------------------------

## New To Code Club?

-   First, check out the [Code Club Computer Setup](/codeclub-setup/) instructions, which also has some pointers that might be helpful if you're new to R or RStudio.

-   Please open RStudio before Code Club to test things out -- if you run into issues, join the Zoom call early and we'll troubleshoot.

------------------------------------------------------------------------

## Session Goals

-   Learn the uses of base-R's three subsetting operators: `[ ]`, `[[ ]]`, and `$`.
-   Learn how the behavior of these operators varies depending on the **data structure** you are subsetting (vector, list, or data frame).
-   Learn the value of the [`str()`](https://rdrr.io/r/utils/str.html) command.
-   Learn how these base-R operators relate to tidyverse commands.

------------------------------------------------------------------------

In our previous set of Code Clubs on stats packages, we've encountered data structures of various kinds. Here we put the data structure material all in one place, and put it in a wider R context. We'll move below and beyond the tidyverse to get an overview of accessing various kinds of data structure in R.

## Intro: What is 'subsetting' anyway?

Subsetting (also known as indexing) is simply a way of using base-R syntax to extract specific pieces of a data structure.

We've already seen two **dplyr** verbs that perform this kind of operation: `filter` (to extract specific rows) and `select` (to extract specific columns).

But these are tidyverse commands, and only work with data frames.

R has two more basic data structures, from which everything else is built, **vectors** and **lists**, and for these we need different subsetting operators (dplyr functions won't work). We'll also see that data frames are just a special kind of list, and that base-R subsetting operators also work for these, which can often be useful and efficient.

In your R experience you will almost certainly come across both code and output which does not adhere to tidyverse conventions. We have already come across outputs which are *not* data frames in [SO3E01: t-tests](https://biodash.github.io/codeclub/s03e01_ttests/) and [S03E02: ANOVA](https://biodash.github.io/codeclub/s03e02_anova/) which we will revisit below.

Since the behavior of these operators depends on the actual data structure you are working with, it's useful when experimenting to use them in conjunction with the [`str()`](https://rdrr.io/r/utils/str.html) function, which compactly displays the internal structure of an any R object. A knowledge of the make-up of these data structures is also important when you come to write your own loops, iterations, and functions.

The most important distinction between vectors and lists is within vectors *every value must be of the same type*: for example, all characters, or all integers, etc. Inside lists, you can *mix values of any type*.

In addition, a list is best thought of as a general purpose container, which can contain not just mixed values, but also *entire vectors* of any type.

Since we'll be comparing base-R with tidyverse functions, we need to load the tidyverse, and we'll also be using the `palmerpenguins` package to reproduce our previous ANOVA results:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/'>palmerpenguins</a></span><span class='o'>)</span></code></pre>

</div>

------------------------------------------------------------------------

## Vectors

A vector is absolutely the most basic data structure in R. Every value in a vector must be of the **same type**.

There are four basic **types** of vector: integer, double, character, and logical. Vectors are created by hand with the [`c()`](https://rdrr.io/r/base/c.html) (combine, concatenate) function. We can check the type with the [`typeof()`](https://rdrr.io/r/base/typeof.html) operator. This is totally redundant if you just created the vector yourself, but when you are debugging code, or creating a vector using an expression, you might want to check exactly what type of vector is being used:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>vec_dbl</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1</span>, <span class='m'>2</span>, <span class='m'>3</span>, <span class='m'>4</span>, <span class='m'>5</span><span class='o'>)</span>
<span class='nv'>vec_dbl</span>
<span class='c'>#&gt; [1] 1 2 3 4 5</span>
<span class='nf'><a href='https://rdrr.io/r/base/typeof.html'>typeof</a></span><span class='o'>(</span><span class='nv'>vec_dbl</span><span class='o'>)</span>
<span class='c'>#&gt; [1] "double"</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>vec_seq</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/seq.html'>seq</a></span><span class='o'>(</span><span class='m'>1</span>, <span class='m'>5</span><span class='o'>)</span>
<span class='nv'>vec_seq</span>
<span class='c'>#&gt; [1] 1 2 3 4 5</span>
<span class='nf'><a href='https://rdrr.io/r/base/typeof.html'>typeof</a></span><span class='o'>(</span><span class='nv'>vec_seq</span><span class='o'>)</span>
<span class='c'>#&gt; [1] "integer"</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>vec_which</span> <span class='o'>&lt;-</span> <span class='m'>1</span><span class='o'>:</span><span class='m'>5</span>
<span class='nv'>vec_which</span>
<span class='c'>#&gt; [1] 1 2 3 4 5</span>
<span class='nf'><a href='https://rdrr.io/r/base/typeof.html'>typeof</a></span><span class='o'>(</span><span class='nv'>vec_which</span><span class='o'>)</span>
<span class='c'>#&gt; [1] "integer"</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>vec_chr</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"a"</span>, <span class='s'>"b"</span>, <span class='s'>"c"</span>, <span class='s'>"d"</span>, <span class='s'>"e"</span><span class='o'>)</span>
<span class='nv'>vec_chr</span>
<span class='c'>#&gt; [1] "a" "b" "c" "d" "e"</span>
<span class='nf'><a href='https://rdrr.io/r/base/typeof.html'>typeof</a></span><span class='o'>(</span><span class='nv'>vec_chr</span><span class='o'>)</span>
<span class='c'>#&gt; [1] "character"</span></code></pre>

</div>

Vectors have an insanely simple **str**ucture:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>vec_dbl</span><span class='o'>)</span>
<span class='c'>#&gt;  num [1:5] 1 2 3 4 5</span></code></pre>

</div>

[`str()`](https://rdrr.io/r/utils/str.html) also displays the type, and RStudio displays the result of [`str()`](https://rdrr.io/r/utils/str.html) in the Values pane. (Note that 'double' and 'num(eric)' mean exactly the same thing in R.)

For such a simple structure, there are a surprisingly large number of ways to subset a vector. We'll just look a a small sample here, and use the following example:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>x</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>2.1</span>, <span class='m'>4.2</span>, <span class='m'>3.3</span>, <span class='m'>5.4</span><span class='o'>)</span>
<span class='nv'>x</span>
<span class='c'>#&gt; [1] 2.1 4.2 3.3 5.4</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span>
<span class='c'>#&gt;  num [1:4] 2.1 4.2 3.3 5.4</span></code></pre>

</div>

(Notice for this example we are using a pedagocial trick, where the *number after the decimal point* indicates the position (index) of the value before the decimal point).

**Positive integers** return elements at the specified positions. Any expression that evaluates to a vector of positions can be used as the index. The index operator is `[ ]`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>x</span><span class='o'>[</span><span class='m'>3</span><span class='o'>]</span>
<span class='c'>#&gt; [1] 3.3</span>
<span class='nv'>x</span><span class='o'>[</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>3</span>, <span class='m'>1</span><span class='o'>)</span><span class='o'>]</span>
<span class='c'>#&gt; [1] 3.3 2.1</span>
<span class='nv'>x</span><span class='o'>[</span><span class='m'>2</span><span class='o'>:</span><span class='m'>4</span><span class='o'>]</span>
<span class='c'>#&gt; [1] 4.2 3.3 5.4</span></code></pre>

</div>

**Negative integers** *exclude* elements at the specified positions:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>x</span><span class='o'>[</span><span class='o'>-</span><span class='m'>3</span><span class='o'>]</span>
<span class='c'>#&gt; [1] 2.1 4.2 5.4</span>
<span class='nv'>x</span><span class='o'>[</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='o'>-</span><span class='m'>3</span>, <span class='o'>-</span><span class='m'>1</span><span class='o'>)</span><span class='o'>]</span>
<span class='c'>#&gt; [1] 4.2 5.4</span></code></pre>

</div>

The bottom line here is that each value in a vector has an implicit index (position), and we can use that index to pull out values of interest. This can be extremely useful when writing for-loops that move through a vector accessing one value at a time.

**Attributes**. One of the unusual features of R as opposed to other programming languages is that you can assign metadata of various kinds to the elements of vectors (and lists). For example, we can assign a **name** to each element, and then use a **character vector** as the index expression:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>y</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"a"</span> <span class='o'>=</span> <span class='m'>2.1</span>, <span class='s'>"b"</span> <span class='o'>=</span> <span class='m'>4.2</span>, <span class='s'>"c"</span> <span class='o'>=</span> <span class='m'>3.3</span>, <span class='s'>"d"</span> <span class='o'>=</span> <span class='m'>5.4</span><span class='o'>)</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>y</span><span class='o'>)</span>
<span class='c'>#&gt;  Named num [1:4] 2.1 4.2 3.3 5.4</span>
<span class='c'>#&gt;  - attr(*, "names")= chr [1:4] "a" "b" "c" "d"</span>
<span class='nv'>y</span><span class='o'>[</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"d"</span>, <span class='s'>"c"</span>, <span class='s'>"a"</span><span class='o'>)</span><span class='o'>]</span>
<span class='c'>#&gt;   d   c   a </span>
<span class='c'>#&gt; 5.4 3.3 2.1</span></code></pre>

</div>

The [`str()`](https://rdrr.io/r/utils/str.html) command now shows us that we now have a 'Named' numeric vector, and that we have a "names" attribute, which is itself a character vector.

### Exercise 1a

<div class="puzzle">

Consider the words "yellow", "red", and "green".

Create a numeric vector called "lengths" which simply shows the *length of the words* (in that order).

Look at its structure using [`str()`](https://rdrr.io/r/utils/str.html).

Extract the first and last elements of this vector, indexing by position.

<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>lengths</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>6</span>, <span class='m'>3</span>, <span class='m'>5</span><span class='o'>)</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>lengths</span><span class='o'>)</span>
<span class='c'>#&gt;  num [1:3] 6 3 5</span>
<span class='nv'>lengths</span><span class='o'>[</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1</span>, <span class='m'>3</span><span class='o'>)</span><span class='o'>]</span>
<span class='c'>#&gt; [1] 6 5</span></code></pre>

</div>

<br>

</details>

</div>

### Exercise 1b

<div class="puzzle">

Now create a second vector called "named_lengths", with the same word-lengths, but now also using a corresponding names attribute: "yellow", "red" and "green".

Look at its structure using [`str()`](https://rdrr.io/r/utils/str.html).

Again, extract the first and last elements, but now using a character vector as the index.

<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>named_lengths</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"yellow"</span> <span class='o'>=</span> <span class='m'>6</span>, <span class='s'>"red"</span> <span class='o'>=</span> <span class='m'>3</span>, <span class='s'>"green"</span> <span class='o'>=</span> <span class='m'>5</span><span class='o'>)</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>named_lengths</span><span class='o'>)</span>
<span class='c'>#&gt;  Named num [1:3] 6 3 5</span>
<span class='c'>#&gt;  - attr(*, "names")= chr [1:3] "yellow" "red" "green"</span>
<span class='nv'>named_lengths</span><span class='o'>[</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"yellow"</span>, <span class='s'>"green"</span><span class='o'>)</span><span class='o'>]</span>
<span class='c'>#&gt; yellow  green </span>
<span class='c'>#&gt;      6      5</span></code></pre>

</div>

<br>

</details>

</div>

------------------------------------------------------------------------

## Lists

There are two main differences between vectors and lists: (i) lists can contain elements of **different types**; and (ii) lists can contain **entire vectors** as elements (and even other lists: which is why lists are sometimes referred to as **recursive**: it can be lists of lists of lists, 'all the way down'. This is a topic for another day!).

Let's directly compare the structure of a *list* of numbers to a *vector* of numbers. Just as we create vectors by hand with the [`c()`](https://rdrr.io/r/base/c.html) function, we create lists with the [`list()`](https://rdrr.io/r/base/list.html) function.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>l</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='m'>2.1</span>, <span class='m'>4.2</span>, <span class='m'>3.3</span>, <span class='m'>5.4</span><span class='o'>)</span>
<span class='nv'>l</span>
<span class='c'>#&gt; [[1]]</span>
<span class='c'>#&gt; [1] 2.1</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[2]]</span>
<span class='c'>#&gt; [1] 4.2</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[3]]</span>
<span class='c'>#&gt; [1] 3.3</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[4]]</span>
<span class='c'>#&gt; [1] 5.4</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>l</span><span class='o'>)</span>
<span class='c'>#&gt; List of 4</span>
<span class='c'>#&gt;  $ : num 2.1</span>
<span class='c'>#&gt;  $ : num 4.2</span>
<span class='c'>#&gt;  $ : num 3.3</span>
<span class='c'>#&gt;  $ : num 5.4</span></code></pre>

</div>

Notice the difference between *printing* a list (all those brackets!!) and using the [`str()`](https://rdrr.io/r/utils/str.html) command, which is much more compact and readable.

What if we mix values of different types?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>l_mixed</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='m'>2.1</span>, <span class='m'>2L</span>, <span class='kc'>T</span>, <span class='s'>"a"</span><span class='o'>)</span>
<span class='nv'>l_mixed</span>
<span class='c'>#&gt; [[1]]</span>
<span class='c'>#&gt; [1] 2.1</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[2]]</span>
<span class='c'>#&gt; [1] 2</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[3]]</span>
<span class='c'>#&gt; [1] TRUE</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[4]]</span>
<span class='c'>#&gt; [1] "a"</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>l_mixed</span><span class='o'>)</span>
<span class='c'>#&gt; List of 4</span>
<span class='c'>#&gt;  $ : num 2.1</span>
<span class='c'>#&gt;  $ : int 2</span>
<span class='c'>#&gt;  $ : logi TRUE</span>
<span class='c'>#&gt;  $ : chr "a"</span></code></pre>

</div>

Things get more interesting when we create a **list of vectors**:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>mixed_vectors</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"kim"</span>, <span class='s'>"sandy"</span>, <span class='s'>"lee"</span><span class='o'>)</span>, <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>23</span>, <span class='m'>21</span>, <span class='m'>26</span><span class='o'>)</span><span class='o'>)</span>
<span class='nv'>mixed_vectors</span>
<span class='c'>#&gt; [[1]]</span>
<span class='c'>#&gt; [1] "kim"   "sandy" "lee"  </span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[2]]</span>
<span class='c'>#&gt; [1] 23 21 26</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>mixed_vectors</span><span class='o'>)</span>
<span class='c'>#&gt; List of 2</span>
<span class='c'>#&gt;  $ : chr [1:3] "kim" "sandy" "lee"</span>
<span class='c'>#&gt;  $ : num [1:3] 23 21 26</span></code></pre>

</div>

In these examples we see the appearance of a new subsetting operator `[[ ]]`, in addition to `[ ]`. How do they differ? Let's experiment, focussing on the second element of the list `c(23, 21, 26)`. Let's try to pull out that vector using the `[2]` notation (it is the second element after all).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>mixed_vectors_subset_a</span> <span class='o'>&lt;-</span> <span class='nv'>mixed_vectors</span><span class='o'>[</span><span class='m'>2</span><span class='o'>]</span>
<span class='nv'>mixed_vectors_subset_a</span>
<span class='c'>#&gt; [[1]]</span>
<span class='c'>#&gt; [1] 23 21 26</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>mixed_vectors_subset_a</span><span class='o'>)</span>
<span class='c'>#&gt; List of 1</span>
<span class='c'>#&gt;  $ : num [1:3] 23 21 26</span></code></pre>

</div>

**This does not pull out the vector!!** Instead, it returns a **sublist** which *contains* that vector as the only element (we'll see why R does this below...).

So how to we get our hands on the actual vector? This is where the `[[ ]]` operator comes in:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>mixed_vectors_subset_b</span> <span class='o'>&lt;-</span> <span class='nv'>mixed_vectors</span><span class='o'>[[</span><span class='m'>2</span><span class='o'>]</span><span class='o'>]</span>
<span class='nv'>mixed_vectors_subset_b</span>
<span class='c'>#&gt; [1] 23 21 26</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>mixed_vectors_subset_b</span><span class='o'>)</span>
<span class='c'>#&gt;  num [1:3] 23 21 26</span></code></pre>

</div>

We see that the behavior of the `[ ]` operator is very different for lists: it selects the element(s) you request, but *always still wrapped inside a list*. It 'shrinks' the original list. The `[[ ]]` operator on the other hand 'drills-down' and just returns the 'un-listed' vector in that position.

## Data frames

The reason R does things this way is because data frames are so central to the language. Let's build a data frame from the ground up to see how it works.

Basically the "inside" of a data frame is just a list with name attributes:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>attr_list</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span>name <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"kim"</span>, <span class='s'>"sandy"</span>, <span class='s'>"lee"</span><span class='o'>)</span>, age <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>23</span>, <span class='m'>21</span>, <span class='m'>26</span><span class='o'>)</span><span class='o'>)</span>
<span class='nv'>attr_list</span>
<span class='c'>#&gt; $name</span>
<span class='c'>#&gt; [1] "kim"   "sandy" "lee"  </span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; $age</span>
<span class='c'>#&gt; [1] 23 21 26</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>attr_list</span><span class='o'>)</span>
<span class='c'>#&gt; List of 2</span>
<span class='c'>#&gt;  $ name: chr [1:3] "kim" "sandy" "lee"</span>
<span class='c'>#&gt;  $ age : num [1:3] 23 21 26</span></code></pre>

</div>

Notice that instead of [`str()`](https://rdrr.io/r/utils/str.html) displaying `$ : ...` for each entry, we now see attributes `$ name: ...` , `$ age: ...` for each entry. Also note that all those double `[[ ]]` notations have disappeared when we print. This should give you a clue that `$age`, for example, is a kind of alias for `[[2]]`.

Finally, we can 'wrap' this into an official data frame structure:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>my_df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/as.data.frame.html'>as.data.frame</a></span><span class='o'>(</span><span class='nv'>attr_list</span><span class='o'>)</span>
<span class='nv'>my_df</span>
<span class='c'>#&gt;    name age</span>
<span class='c'>#&gt; 1   kim  23</span>
<span class='c'>#&gt; 2 sandy  21</span>
<span class='c'>#&gt; 3   lee  26</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>my_df</span><span class='o'>)</span>
<span class='c'>#&gt; 'data.frame':  3 obs. of  2 variables:</span>
<span class='c'>#&gt;  $ name: chr  "kim" "sandy" "lee"</span>
<span class='c'>#&gt;  $ age : num  23 21 26</span></code></pre>

</div>

Or wrap it into a tidyverse tibble:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>my_tibble</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://tibble.tidyverse.org/reference/as_tibble.html'>as_tibble</a></span><span class='o'>(</span><span class='nv'>attr_list</span><span class='o'>)</span>
<span class='nv'>my_tibble</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 × 2</span></span>
<span class='c'>#&gt;   name    age</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> kim      23</span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> sandy    21</span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> lee      26</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>my_tibble</span><span class='o'>)</span>
<span class='c'>#&gt; tibble [3 × 2] (S3: tbl_df/tbl/data.frame)</span>
<span class='c'>#&gt;  $ name: chr [1:3] "kim" "sandy" "lee"</span>
<span class='c'>#&gt;  $ age : num [1:3] 23 21 26</span></code></pre>

</div>

So a data frame is basically a list (intepreted as columns), with a names attribute for the columns (interpreted as headers). And with the extra condition that all the columns are of the same length, so it's rectangular. So we should be able to use our standard list subsetting operators on it:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>col_2</span> <span class='o'>&lt;-</span> <span class='nv'>my_df</span><span class='o'>[</span><span class='m'>2</span><span class='o'>]</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>col_2</span><span class='o'>)</span>
<span class='c'>#&gt; 'data.frame':  3 obs. of  1 variable:</span>
<span class='c'>#&gt;  $ age: num  23 21 26</span></code></pre>

</div>

Since a data frame is a list, subsetting using `[ ]` returns the specified column *still inside a data frame*. What about `[[ ]]`?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>vec_2</span> <span class='o'>&lt;-</span> <span class='nv'>my_df</span><span class='o'>[[</span><span class='m'>2</span><span class='o'>]</span><span class='o'>]</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>vec_2</span><span class='o'>)</span>
<span class='c'>#&gt;  num [1:3] 23 21 26</span></code></pre>

</div>

Using `[[ ]]` pulls out the data vector from the column.

Just like vectors, we can also subset a data frame by the name attribute, instead of by position:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>col_2_by_name</span> <span class='o'>&lt;-</span> <span class='nv'>my_df</span><span class='o'>[</span><span class='s'>"age"</span><span class='o'>]</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>col_2_by_name</span><span class='o'>)</span>
<span class='c'>#&gt; 'data.frame':  3 obs. of  1 variable:</span>
<span class='c'>#&gt;  $ age: num  23 21 26</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>vec_2_by_name</span> <span class='o'>&lt;-</span> <span class='nv'>my_df</span><span class='o'>[[</span><span class='s'>"age"</span><span class='o'>]</span><span class='o'>]</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>vec_2_by_name</span><span class='o'>)</span>
<span class='c'>#&gt;  num [1:3] 23 21 26</span></code></pre>

</div>

Finally `my_df$age` is simply a shorthand for `my_df[["age"]]` without the `[[ ]]` and the `" "`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>vec_2_by_dollar_name</span> <span class='o'>&lt;-</span> <span class='nv'>my_df</span><span class='o'>$</span><span class='nv'>age</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>vec_2_by_dollar_name</span><span class='o'>)</span>
<span class='c'>#&gt;  num [1:3] 23 21 26</span></code></pre>

</div>

## Direct comparison with tidyverse functions

The dplyr command [`select()`](https://dplyr.tidyverse.org/reference/select.html) over a data frame is exactly analogous to the single bracket operator `my_df["age"]`. It returns a data frame with a single column:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>col_2_select</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nv'>my_df</span>, <span class='s'>"age"</span><span class='o'>)</span>
<span class='nv'>col_2_select</span>
<span class='c'>#&gt;   age</span>
<span class='c'>#&gt; 1  23</span>
<span class='c'>#&gt; 2  21</span>
<span class='c'>#&gt; 3  26</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>col_2_select</span><span class='o'>)</span>
<span class='c'>#&gt; 'data.frame':  3 obs. of  1 variable:</span>
<span class='c'>#&gt;  $ age: num  23 21 26</span></code></pre>

</div>

The dplyr command [`pull()`](https://dplyr.tidyverse.org/reference/pull.html) over a data frame is exactly analogous to the double bracket operator `my_df[["age"]]`. It returns the data vector inside that column:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>col_2_pull</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/pull.html'>pull</a></span><span class='o'>(</span><span class='nv'>my_df</span>, <span class='s'>"age"</span><span class='o'>)</span>
<span class='nv'>col_2_pull</span>
<span class='c'>#&gt; [1] 23 21 26</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>col_2_pull</span><span class='o'>)</span>
<span class='c'>#&gt;  num [1:3] 23 21 26</span></code></pre>

</div>

The 'problem' with these dplyr functions is that they *require* a data frame as input, and we recently saw in [S03E01: t-tests](https://biodash.github.io/codeclub/s03e01_ttests/) that the statistical t-test output was *not* a data frame:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>pop1</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/Normal.html'>rnorm</a></span><span class='o'>(</span>n <span class='o'>=</span> <span class='m'>20</span>, mean <span class='o'>=</span> <span class='m'>10</span>, sd <span class='o'>=</span> <span class='m'>3</span><span class='o'>)</span>
<span class='nv'>pop2</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/Normal.html'>rnorm</a></span><span class='o'>(</span>n <span class='o'>=</span> <span class='m'>20</span>, mean <span class='o'>=</span> <span class='m'>10</span>, sd <span class='o'>=</span> <span class='m'>3</span><span class='o'>)</span>

<span class='nv'>tresult</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/t.test.html'>t.test</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>pop1</span>, y <span class='o'>=</span> <span class='nv'>pop2</span><span class='o'>)</span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>tresult</span><span class='o'>)</span>
<span class='c'>#&gt; List of 10</span>
<span class='c'>#&gt;  $ statistic  : Named num 0.32</span>
<span class='c'>#&gt;   ..- attr(*, "names")= chr "t"</span>
<span class='c'>#&gt;  $ parameter  : Named num 37.9</span>
<span class='c'>#&gt;   ..- attr(*, "names")= chr "df"</span>
<span class='c'>#&gt;  $ p.value    : num 0.751</span>
<span class='c'>#&gt;  $ conf.int   : num [1:2] -1.77 2.44</span>
<span class='c'>#&gt;   ..- attr(*, "conf.level")= num 0.95</span>
<span class='c'>#&gt;  $ estimate   : Named num [1:2] 10.17 9.84</span>
<span class='c'>#&gt;   ..- attr(*, "names")= chr [1:2] "mean of x" "mean of y"</span>
<span class='c'>#&gt;  $ null.value : Named num 0</span>
<span class='c'>#&gt;   ..- attr(*, "names")= chr "difference in means"</span>
<span class='c'>#&gt;  $ stderr     : num 1.04</span>
<span class='c'>#&gt;  $ alternative: chr "two.sided"</span>
<span class='c'>#&gt;  $ method     : chr "Welch Two Sample t-test"</span>
<span class='c'>#&gt;  $ data.name  : chr "pop1 and pop2"</span>
<span class='c'>#&gt;  - attr(*, "class")= chr "htest"</span></code></pre>

</div>

This is not a data frame, but an 'htest' class object. Further, it cannot be converted to a data frame in the usual way:

``` r
as.data.frame(tresult)
Error in as.data.frame.default(tresult): cannot coerce class ‘"htest"’ to a data.frame
```

This is precisely why the tidyverse developed the [`broom::tidy()`](https://generics.r-lib.org/reference/tidy.html) function, which works with legacy base-R outputs, and converts them to data frames. But if you have lots of t-tests, the overhead of converting all the outputs using broom, then using dplyr functions to access data, can be inefficient and overkill.

The t-test output is not a data frame, but it **is** a named list, so we can subset it directly. For example, to pull out the `p.value` we can do either:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>tresult</span><span class='o'>[[</span><span class='m'>3</span><span class='o'>]</span><span class='o'>]</span>
<span class='c'>#&gt; [1] 0.7507211</span></code></pre>

</div>

or

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>tresult</span><span class='o'>$</span><span class='nv'>p.value</span>
<span class='c'>#&gt; [1] 0.7507211</span></code></pre>

</div>

which is really much simpler than going through broom. In addition, we can get extra granularity very quickly using this notation. Say we want the lower bound of the confidence interval. We can 'stack' indexes:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>tresult</span><span class='o'>[[</span><span class='m'>4</span><span class='o'>]</span><span class='o'>]</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span>
<span class='c'>#&gt; [1] -1.774624</span></code></pre>

</div>

or

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>tresult</span><span class='o'>$</span><span class='nv'>conf.int</span><span class='o'>[[</span><span class='m'>1</span><span class='o'>]</span><span class='o'>]</span>
<span class='c'>#&gt; [1] -1.774624</span></code></pre>

</div>

This is saying 'give me the 4th element (or the conf.int element), and then give me the 1st element of that'.

------------------------------------------------------------------------

### Exercise 2

<div class="puzzle">

Reuse the t.test() code above, run `str` on the output, and extract the `stderr` value using both the `$` and `[[ ]]` indexing approaches.

<br>

<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>tresult</span><span class='o'>$</span><span class='nv'>stderr</span>
<span class='c'>#&gt; [1] 1.041051</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>tresult</span><span class='o'>[[</span><span class='m'>7</span><span class='o'>]</span><span class='o'>]</span>
<span class='c'>#&gt; [1] 1.041051</span></code></pre>

</div>

<br>

</details>

</div>

------------------------------------------------------------------------

### Exercise 3

<div class="puzzle">

When we ran our first ANOVA, we never actually looked at the data structure that was produced.

Run the following code and inspect the output.

``` r
bill_length_anova <- 
  aov(data = penguins %>% drop_na(),
      bill_length_mm ~ species + sex + species*sex)

str(bill_length_anova)
```

Aieee!

What happens when you try to turn this into a data frame, using `as.data.frame(bill_length_anova)`?

Now you can see why `broom:tidy()` is so useful! To remind yourselves what the tidied version looks like, run the code:

``` r
tidy_anova <- broom::tidy(bill_length_anova)
tidy_anova
```

But we can still extract values from this data structure directly: you just have to work out where to look...

See if you can extract the total residual df from this data structure using the \$ notation.

<br>

<details>
<summary>
Solution (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_length_anova</span> <span class='o'>&lt;-</span> 
  <span class='nf'><a href='https://rdrr.io/r/stats/aov.html'>aov</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>penguins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'><a href='https://tidyr.tidyverse.org/reference/drop_na.html'>drop_na</a></span><span class='o'>(</span><span class='o'>)</span>,
      <span class='nv'>bill_length_mm</span> <span class='o'>~</span> <span class='nv'>species</span> <span class='o'>+</span> <span class='nv'>sex</span> <span class='o'>+</span> <span class='nv'>species</span><span class='o'>*</span><span class='nv'>sex</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>bill_length_anova</span><span class='o'>)</span>
<span class='c'>#&gt; List of 13</span>
<span class='c'>#&gt;  $ coefficients : Named num [1:6] 37.26 9.32 8.31 3.13 1.39 ...</span>
<span class='c'>#&gt;   ..- attr(*, "names")= chr [1:6] "(Intercept)" "speciesChinstrap" "speciesGentoo" "sexmale" ...</span>
<span class='c'>#&gt;  $ residuals    : Named num [1:333] -1.29 2.242 3.042 -0.558 -1.09 ...</span>
<span class='c'>#&gt;   ..- attr(*, "names")= chr [1:333] "1" "2" "3" "4" ...</span>
<span class='c'>#&gt;  $ effects      : Named num [1:333] -802.79 44.75 70.8 33.7 3.82 ...</span>
<span class='c'>#&gt;   ..- attr(*, "names")= chr [1:333] "(Intercept)" "speciesChinstrap" "speciesGentoo" "sexmale" ...</span>
<span class='c'>#&gt;  $ rank         : int 6</span>
<span class='c'>#&gt;  $ fitted.values: Named num [1:333] 40.4 37.3 37.3 37.3 40.4 ...</span>
<span class='c'>#&gt;   ..- attr(*, "names")= chr [1:333] "1" "2" "3" "4" ...</span>
<span class='c'>#&gt;  $ assign       : int [1:6] 0 1 1 2 3 3</span>
<span class='c'>#&gt;  $ qr           :List of 5</span>
<span class='c'>#&gt;   ..$ qr   : num [1:333, 1:6] -18.2483 0.0548 0.0548 0.0548 0.0548 ...</span>
<span class='c'>#&gt;   .. ..- attr(*, "dimnames")=List of 2</span>
<span class='c'>#&gt;   .. .. ..$ : chr [1:333] "1" "2" "3" "4" ...</span>
<span class='c'>#&gt;   .. .. ..$ : chr [1:6] "(Intercept)" "speciesChinstrap" "speciesGentoo" "sexmale" ...</span>
<span class='c'>#&gt;   .. ..- attr(*, "assign")= int [1:6] 0 1 1 2 3 3</span>
<span class='c'>#&gt;   .. ..- attr(*, "contrasts")=List of 2</span>
<span class='c'>#&gt;   .. .. ..$ species: chr "contr.treatment"</span>
<span class='c'>#&gt;   .. .. ..$ sex    : chr "contr.treatment"</span>
<span class='c'>#&gt;   ..$ qraux: num [1:6] 1.05 1.03 1.05 1.05 1.03 ...</span>
<span class='c'>#&gt;   ..$ pivot: int [1:6] 1 2 3 4 5 6</span>
<span class='c'>#&gt;   ..$ tol  : num 1e-07</span>
<span class='c'>#&gt;   ..$ rank : int 6</span>
<span class='c'>#&gt;   ..- attr(*, "class")= chr "qr"</span>
<span class='c'>#&gt;  $ df.residual  : int 327</span>
<span class='c'>#&gt;  $ contrasts    :List of 2</span>
<span class='c'>#&gt;   ..$ species: chr "contr.treatment"</span>
<span class='c'>#&gt;   ..$ sex    : chr "contr.treatment"</span>
<span class='c'>#&gt;  $ xlevels      :List of 2</span>
<span class='c'>#&gt;   ..$ species: chr [1:3] "Adelie" "Chinstrap" "Gentoo"</span>
<span class='c'>#&gt;   ..$ sex    : chr [1:2] "female" "male"</span>
<span class='c'>#&gt;  $ call         : language aov(formula = bill_length_mm ~ species + sex + species * sex, data = penguins %&gt;%      drop_na())</span>
<span class='c'>#&gt;  $ terms        :Classes 'terms', 'formula'  language bill_length_mm ~ species + sex + species * sex</span>
<span class='c'>#&gt;   .. ..- attr(*, "variables")= language list(bill_length_mm, species, sex)</span>
<span class='c'>#&gt;   .. ..- attr(*, "factors")= int [1:3, 1:3] 0 1 0 0 0 1 0 1 1</span>
<span class='c'>#&gt;   .. .. ..- attr(*, "dimnames")=List of 2</span>
<span class='c'>#&gt;   .. .. .. ..$ : chr [1:3] "bill_length_mm" "species" "sex"</span>
<span class='c'>#&gt;   .. .. .. ..$ : chr [1:3] "species" "sex" "species:sex"</span>
<span class='c'>#&gt;   .. ..- attr(*, "term.labels")= chr [1:3] "species" "sex" "species:sex"</span>
<span class='c'>#&gt;   .. ..- attr(*, "order")= int [1:3] 1 1 2</span>
<span class='c'>#&gt;   .. ..- attr(*, "intercept")= int 1</span>
<span class='c'>#&gt;   .. ..- attr(*, "response")= int 1</span>
<span class='c'>#&gt;   .. ..- attr(*, ".Environment")=&lt;environment: R_GlobalEnv&gt; </span>
<span class='c'>#&gt;   .. ..- attr(*, "predvars")= language list(bill_length_mm, species, sex)</span>
<span class='c'>#&gt;   .. ..- attr(*, "dataClasses")= Named chr [1:3] "numeric" "factor" "factor"</span>
<span class='c'>#&gt;   .. .. ..- attr(*, "names")= chr [1:3] "bill_length_mm" "species" "sex"</span>
<span class='c'>#&gt;  $ model        :'data.frame':  333 obs. of  3 variables:</span>
<span class='c'>#&gt;   ..$ bill_length_mm: num [1:333] 39.1 39.5 40.3 36.7 39.3 38.9 39.2 41.1 38.6 34.6 ...</span>
<span class='c'>#&gt;   ..$ species       : Factor w/ 3 levels "Adelie","Chinstrap",..: 1 1 1 1 1 1 1 1 1 1 ...</span>
<span class='c'>#&gt;   ..$ sex           : Factor w/ 2 levels "female","male": 2 1 1 1 2 1 2 1 2 2 ...</span>
<span class='c'>#&gt;   ..- attr(*, "terms")=Classes 'terms', 'formula'  language bill_length_mm ~ species + sex + species * sex</span>
<span class='c'>#&gt;   .. .. ..- attr(*, "variables")= language list(bill_length_mm, species, sex)</span>
<span class='c'>#&gt;   .. .. ..- attr(*, "factors")= int [1:3, 1:3] 0 1 0 0 0 1 0 1 1</span>
<span class='c'>#&gt;   .. .. .. ..- attr(*, "dimnames")=List of 2</span>
<span class='c'>#&gt;   .. .. .. .. ..$ : chr [1:3] "bill_length_mm" "species" "sex"</span>
<span class='c'>#&gt;   .. .. .. .. ..$ : chr [1:3] "species" "sex" "species:sex"</span>
<span class='c'>#&gt;   .. .. ..- attr(*, "term.labels")= chr [1:3] "species" "sex" "species:sex"</span>
<span class='c'>#&gt;   .. .. ..- attr(*, "order")= int [1:3] 1 1 2</span>
<span class='c'>#&gt;   .. .. ..- attr(*, "intercept")= int 1</span>
<span class='c'>#&gt;   .. .. ..- attr(*, "response")= int 1</span>
<span class='c'>#&gt;   .. .. ..- attr(*, ".Environment")=&lt;environment: R_GlobalEnv&gt; </span>
<span class='c'>#&gt;   .. .. ..- attr(*, "predvars")= language list(bill_length_mm, species, sex)</span>
<span class='c'>#&gt;   .. .. ..- attr(*, "dataClasses")= Named chr [1:3] "numeric" "factor" "factor"</span>
<span class='c'>#&gt;   .. .. .. ..- attr(*, "names")= chr [1:3] "bill_length_mm" "species" "sex"</span>
<span class='c'>#&gt;  - attr(*, "class")= chr [1:2] "aov" "lm"</span></code></pre>

</div>

``` r
as.data.frame(bill_length_anova)

Error in as.data.frame.default(bill_length_anova) : 
  cannot coerce class ‘c("aov", "lm")’ to a data.frame
```

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>tidy_anova</span> <span class='o'>&lt;-</span> <span class='nf'>broom</span><span class='nf'>::</span><span class='nf'><a href='https://generics.r-lib.org/reference/tidy.html'>tidy</a></span><span class='o'>(</span><span class='nv'>bill_length_anova</span><span class='o'>)</span>
<span class='nv'>tidy_anova</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 4 × 6</span></span>
<span class='c'>#&gt;   term           df  sumsq  meansq statistic    p.value</span>
<span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>       <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span> species         2 <span style='text-decoration: underline;'>7</span>015.  <span style='text-decoration: underline;'>3</span>508.      654.    5.03<span style='color: #555555;'>e</span><span style='color: #BB0000;'>-115</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span> sex             1 <span style='text-decoration: underline;'>1</span>136.  <span style='text-decoration: underline;'>1</span>136.      212.    2.42<span style='color: #555555;'>e</span><span style='color: #BB0000;'>- 37</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span> species:sex     2   24.5   12.2       2.28  1.03<span style='color: #555555;'>e</span><span style='color: #BB0000;'>-  1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span> Residuals     327 <span style='text-decoration: underline;'>1</span>753.     5.36     <span style='color: #BB0000;'>NA</span>    <span style='color: #BB0000;'>NA</span>   <span style='color: #555555;'> </span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_length_anova</span><span class='o'>$</span><span class='nv'>df.residual</span>
<span class='c'>#&gt; [1] 327</span></code></pre>

</div>

<br>

</details>

</div>

------------------------------------------------------------------------

<br> <br> <br> <br>

