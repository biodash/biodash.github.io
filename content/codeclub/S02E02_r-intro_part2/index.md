---
title: "Code Club S02E02: An introduction to R (Part 2)"
summary: "Part 2 of hitting some of the important basics for working in R. We'll take a look at functions, packages, and pick up from last week with a bit more on R objects."  
authors: [mike-sovic]
date: "2021-08-30"
lastmod: "2021-08-30"
output: hugodown::md_document
toc: true
rmd_hash: 4770c1dade6230cd

---

<br>

## Learning objectives

> -   Create objects in R
> -   Recognize and use R functions
> -   Differentiate between some common object classes and data structures in R
> -   Read in data from a file
> -   Install and load R packages

<br>

------------------------------------------------------------------------

## 1 -- Intro

Nearly everything you do in R will involve **objects**, **functions**, or (often) both. In this session, we'll take a quick look at each of these fundamental components for working in R. In addition, we'll get introduced to R packages (since they'll provide many of the functions you'll use), and also practice reading some data in to R.

## 2 -- Objects

Objects are things in R to which a name can be assigned. They're created using the assignment operator "\<-", which can be thought of as an arrow (it's actually two separate characters - the less than symbol and dash) that points whatever is on the right side to a name provided on the left side. For example, running the following three lines of code creates objects named "x", "y", and "z", respectively...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>x</span> <span class='o'>&lt;-</span> <span class='m'>3</span> <span class='o'>+</span> <span class='m'>3</span>
<span class='nv'>y</span> <span class='o'>&lt;-</span> <span class='kc'>TRUE</span>
<span class='nv'>z</span> <span class='o'>&lt;-</span> <span class='s'>"cat"</span>
</code></pre>

</div>

If you run these lines in RStudio, you'll see the resulting objects listed in the top right panel. This is really helpful for keeping track of object names, as you'll often create many objects during an R session. Calling the objects returns their values...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>x</span>

<span class='c'>#&gt; [1] 6</span>

<span class='nv'>y</span>

<span class='c'>#&gt; [1] TRUE</span>

<span class='nv'>z</span>

<span class='c'>#&gt; [1] "cat"</span>
</code></pre>

</div>

## 3 -- Functions

We'll return to objects shortly, but first, let's take a very basic look at functions, which make up a second really important part of R. You can think of objects as **being** things in R, while functions **do** things in R. Essentially every task in R will involve objects or functions, and often both, so these are two things worth learning early on.

I'll start by writing a very simple function...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#define the function</span>
<span class='nv'>cubed_plus10</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>number</span><span class='o'>)</span> <span class='o'>&#123;</span>
  <span class='nv'>number</span><span class='o'>^</span><span class='m'>3</span><span class='o'>+</span><span class='m'>10</span>
<span class='o'>&#125;</span>

<span class='c'>#apply the function</span>
<span class='nf'>cubed_plus10</span><span class='o'>(</span><span class='m'>4</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 74</span>
</code></pre>

</div>

No need to get caught up in details of writing the function right now. A couple important things to recognize at this point...

1.  We created a function that took some input - the '4' in the example above, did something to it, and returned some output.
2.  To run the function, we used its name, followed by a set of parentheses. All R functions have that general structure. The parentheses might contain 0, 1, or more items (often referred to as **options** or **arguments**).

It's useful to be able to create your own functions. But if that sounds a little advanced to you at this point, you can still do a lot with R even without knowing how to write your own, as there are lots that have already been written for you. A number of commonly-used functions are available as soon as you start an R session - these are often referred to as "base R" functions.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#some example base R functions</span>
<span class='nf'><a href='https://rdrr.io/r/base/date.html'>date</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "Tue Aug 31 09:58:36 2021"</span>

<span class='nf'><a href='https://rdrr.io/r/base/getwd.html'>getwd</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "/Users/sovic.1/Desktop/docs/Desktop_clear_4-28-21/S18_dev/biodash.github.io/content/codeclub/S02E02_r-intro_part2"</span>

<span class='nf'><a href='https://rdrr.io/r/base/MathFun.html'>sqrt</a></span><span class='o'>(</span><span class='m'>25</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 5</span>
</code></pre>

</div>

## 4 -- Object Classes and Data Structures

Now that we have at least a basic idea of R functions, we'll turn attention back to objects (and use functions along the way from here on out). The objects we've created so far have been pretty simple. Let's revisit the three from above...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>x</span>

<span class='c'>#&gt; [1] 6</span>

<span class='nv'>y</span>

<span class='c'>#&gt; [1] TRUE</span>

<span class='nv'>z</span>

<span class='c'>#&gt; [1] "cat"</span>
</code></pre>

</div>

There are lots of different kinds, or *classes* of objects in R, and behind the scenes, each object that's created is immediately assigned to a class (or possibly multiple classes). There's no real limit to the number of classes that exist, as new ones can be created for specialized cases at any time. But there are a fairly small number of object classes you'll encounter a lot in R, so we'll take a look at some of those now. Let's use the [`class()`](https://rdrr.io/r/base/class.html) function to figure out what class R assigned each of our objects to...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "numeric"</span>


<span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>y</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "logical"</span>


<span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>z</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "character"</span>
</code></pre>

</div>

Some very common object classes you'll encounter...

> -   integer
> -   double (numeric)
> -   logical
> -   character
> -   factor

I'm going to introduce a new term here that's closely tied to object classes, and that's *data structures*. Again, there are a small number of data structures you'll work with a lot in R. They include...

> -   Vectors
> -   Matrices
> -   Data Frames
> -   Lists
> -   Arrays

Today we'll focus in on two of these - **vectors** and **data frames**.

## 5 -- Vectors

Vectors in R share a couple important characteristics...

1.  They're one-dimensional. In other words, they can be defined by a length property, with length zero, one, or more.
2.  All elements of a vector must be of the same type, or class.
3.  Operations can be performed on vectors - *vector recycling* rules apply (we'll see this in the breakout exercises next).

The [`c()`](https://rdrr.io/r/base/c.html) function is useful for creating vectors in R. It stands for "combine", and allows you to combine multiple items into a single vector object...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>odds</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1</span>,<span class='m'>3</span>,<span class='m'>5</span>,<span class='m'>7</span>,<span class='m'>9</span><span class='o'>)</span>
<span class='nv'>animals</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"dog"</span>, <span class='s'>"cat"</span>, <span class='s'>"cow"</span><span class='o'>)</span>

<span class='c'>#view the objects</span>
<span class='nv'>odds</span>

<span class='c'>#&gt; [1] 1 3 5 7 9</span>

<span class='nv'>animals</span>

<span class='c'>#&gt; [1] "dog" "cat" "cow"</span>


<span class='c'>#check their class</span>
<span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>odds</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "numeric"</span>

<span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>animals</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "character"</span>
</code></pre>

</div>

------------------------------------------------------------------------

### Breakout Rooms I (\~10 min.)

#### Exercise 1: Create Vector Objects

<div class="puzzle">

<div>

Create two objects (vectors) named *short_vec* and *long_vec*. To *short_vec*, assign the integers 1 through 5, and to *long_vec*, assign the integers 1 through 10. View each of the objects and check their class.

<details>
<summary>
<b>Hint</b> (click here)
</summary>

<br> The colon can be used to define a sequence of integers in R, for example, 1:3 represents the vector 1,2,3. <br>

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>short_vec</span> <span class='o'>&lt;-</span> <span class='m'>1</span><span class='o'>:</span><span class='m'>5</span>
<span class='nv'>long_vec</span> <span class='o'>&lt;-</span> <span class='m'>1</span><span class='o'>:</span><span class='m'>10</span>

<span class='nv'>short_vec</span>

<span class='c'>#&gt; [1] 1 2 3 4 5</span>

<span class='nv'>long_vec</span>

<span class='c'>#&gt;  [1]  1  2  3  4  5  6  7  8  9 10</span>


<span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>short_vec</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "integer"</span>

<span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>long_vec</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "integer"</span>
</code></pre>

</div>

</details>

</div>

</div>

<br>

#### Exercise 2: Vector Operations/Recycling

<div class="puzzle">

<div>

Now try adding the two vectors, *short_vec* and *long_vec*, together. Assign the result to a new object named *vec_sum*. Think about and talk through what you expect the result might look like before you execute the code.

<details>
<summary>
<b>Hint</b> (click here)
</summary>

<br> Before R performs an operation on any vectors, the vectors involved must be the same length. If they aren't, the shorter vector is "recycled" until it matches the length of longer vector. Then the operation is performed. <br>

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'>
<span class='nv'>vec_sum</span> <span class='o'>&lt;-</span> <span class='nv'>short_vec</span> <span class='o'>+</span> <span class='nv'>long_vec</span>

<span class='nv'>vec_sum</span>

<span class='c'>#&gt;  [1]  2  4  6  8 10  7  9 11 13 15</span>
</code></pre>

</div>

</details>

</div>

</div>

<br>

#### Exercise 3: Vector Operations/Recycling II

<div class="puzzle">

<div>

Just to drive this point on vector recycling home a little more, let's do more operation - this time, subtract 3 (itself a vector of length 1) from *short_vec*. Again, try to predict what will happen before you run it.

<details>
<summary>
<b>Solution</b> (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>short_vec</span> <span class='o'>-</span> <span class='m'>3</span>

<span class='c'>#&gt; [1] -2 -1  0  1  2</span>
</code></pre>

</div>

</details>

</div>

</div>

<br>

Keep in mind that all elements of a vector in R have to be of the same class. This means you typically won't see a vector that looks like...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>mixed_vector</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1</span>, <span class='s'>"cat"</span>, <span class='m'>4</span>, <span class='s'>"dog"</span>, <span class='kc'>TRUE</span><span class='o'>)</span>
</code></pre>

</div>

You can create such a vector, but in this case, R will view it as a character vector, meaning, for example, the 1 and 4 won't be treated as numbers, but as characters. Such forcing of an element or object into a specific class is often referred to as **coercion**. Let's go back to our object 'x'...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>x</span>

<span class='c'>#&gt; [1] 6</span>

<span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "numeric"</span>
</code></pre>

</div>

Notice it's assigned as numeric. Let's say we wanted R to see it as an integer (just slightly different in R than numeric)...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>x</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/integer.html'>as.integer</a></span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "integer"</span>
</code></pre>

</div>

We have used the [`as.integer()`](https://rdrr.io/r/base/integer.html) function to coerce x into class **integer**.

------------------------------------------------------------------------

## 6 -- Data Frames

Data frames are another data structure in R you'll likely use a lot. Some characteristics of data frames...

1.  They have two dimensions (rows, columns)
2.  Each variable (column) needs to have the same number of entries.
3.  All elements of any one column have to be of the same type/class, but different columns can be of different classes.

A good way to think about a data frame is as being analogous to an Excel spreadsheet, with the caveat that all the columns have the same number of entries, which isn't a requirement in an Excel sheet.

You can create a data frame by hand with the [`data.frame()`](https://rdrr.io/r/base/data.frame.html) function, but in many cases, you'll create a data frame in R by reading data in from a file with one of a number of functions that are available for that purpose. Let's try it. Here's a small example dataset I generated in Excel...

![example data set](https://github.com/biodash/biodash.github.io/raw/master/assets/data/data_frame/df_example.png)

It's available at the following address... <https://raw.githubusercontent.com/biodash/biodash.github.io/master/assets/data/data_frame/example_df.tsv>

(In this case, the data set comes from online, but often it will be a file on your computer, and the path to the file works the same way as how you'll use the web address below.)

------------------------------------------------------------------------

### Breakout Rooms II (\~10 min.)

#### Exercise 4: Reading In A Data Frame

<div class="puzzle">

<div>

Create an object named "data_address" that stores the web address for the dataset.

<details>
<summary>
<b>Hint</b> (click here)
</summary>

<br> Use the assignment operator and make sure to put the address in quotes to define it as a character string. <br>

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>data_address</span> <span class='o'>&lt;-</span> <span class='s'>"https://raw.githubusercontent.com/biodash/biodash.github.io/master/assets/data/data_frame/example_df.tsv"</span>
</code></pre>

</div>

</details>

<br>

Now use the [`read.table()`](https://rdrr.io/r/utils/read.table.html) function to read the dataset in as a data frame. Assign it as an object named 'exp_data' and view it in R.

<details>
<summary>
<b>Hint</b> (click here)
</summary>

<br> Use the *data_address* object as the first argument in the [`read.table()`](https://rdrr.io/r/utils/read.table.html) function. <br>

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>exp_data</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/utils/read.table.html'>read.table</a></span><span class='o'>(</span><span class='nv'>data_address</span><span class='o'>)</span>

<span class='nv'>exp_data</span>

<span class='c'>#&gt;    V1        V2        V3        V4</span>
<span class='c'>#&gt; 1 Age Height_cm Eye_Color Graduated</span>
<span class='c'>#&gt; 2  22    175.26      Blue      TRUE</span>
<span class='c'>#&gt; 3  67    170.18     Green      TRUE</span>
<span class='c'>#&gt; 4  53     165.1      Blue     FALSE</span>
<span class='c'>#&gt; 5  13    134.62     Brown     FALSE</span>
<span class='c'>#&gt; 6  19    147.32     Green      TRUE</span>
<span class='c'>#&gt; 7  27    185.42      Gray      TRUE</span>
<span class='c'>#&gt; 8  30     190.5      Blue      TRUE</span>
<span class='c'>#&gt; 9  11    144.78     Brown     FALSE</span>
</code></pre>

</div>

</details>

</div>

</div>

<br>

#### Exercise 5: Getting Info About Functions

<div class="puzzle">

<div>

The column names (header) were read in as the first observation, and default column names (i.e. V1, V2, etc) were added. Take a look at the help page for [`read.table()`](https://rdrr.io/r/utils/read.table.html) by typing [`?read.table`](https://rdrr.io/r/utils/read.table.html) in your R console, or by searching for "read.table" in the search box in the Help tab of the lower right RStudio panel. Look through some of the options/arguments and make an adjustment to fix the column names/header, then view the data frame again.

<details>
<summary>
<b>Hint</b> (click here)
</summary>

<br> Rerun the command, setting "header" to TRUE, instead of the default FALSE. <br>

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>exp_data</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/utils/read.table.html'>read.table</a></span><span class='o'>(</span><span class='nv'>data_address</span>, header <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>

<span class='nv'>exp_data</span>

<span class='c'>#&gt;   Age Height_cm Eye_Color Graduated</span>
<span class='c'>#&gt; 1  22    175.26      Blue      TRUE</span>
<span class='c'>#&gt; 2  67    170.18     Green      TRUE</span>
<span class='c'>#&gt; 3  53    165.10      Blue     FALSE</span>
<span class='c'>#&gt; 4  13    134.62     Brown     FALSE</span>
<span class='c'>#&gt; 5  19    147.32     Green      TRUE</span>
<span class='c'>#&gt; 6  27    185.42      Gray      TRUE</span>
<span class='c'>#&gt; 7  30    190.50      Blue      TRUE</span>
<span class='c'>#&gt; 8  11    144.78     Brown     FALSE</span>
</code></pre>

</div>

</details>

</div>

</div>

<br>

#### Exercise 6: Practicing With Some Functions

<div class="puzzle">

<div>

Spend a few minutes playing around with some of the following functions and try to figure out what they do by applying them to the exp_data object. If it's not clear, use the help...

-   head()
-   dim()
-   nrow()
-   ncol()
-   names()
-   str()
-   summary()

<details>
<summary>
<b>Solution</b> (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>exp_data</span><span class='o'>)</span>

<span class='c'>#&gt;   Age Height_cm Eye_Color Graduated</span>
<span class='c'>#&gt; 1  22    175.26      Blue      TRUE</span>
<span class='c'>#&gt; 2  67    170.18     Green      TRUE</span>
<span class='c'>#&gt; 3  53    165.10      Blue     FALSE</span>
<span class='c'>#&gt; 4  13    134.62     Brown     FALSE</span>
<span class='c'>#&gt; 5  19    147.32     Green      TRUE</span>
<span class='c'>#&gt; 6  27    185.42      Gray      TRUE</span>

<span class='c'>#gives preview of object</span>

<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>exp_data</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 8 4</span>

<span class='c'>#returns dimensions (number of row, number of columns) of the object</span>

<span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='nv'>exp_data</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 8</span>

<span class='c'>#returns number of rows in data frame</span>

<span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>ncol</a></span><span class='o'>(</span><span class='nv'>exp_data</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 4</span>

<span class='c'>#returns number of columns in data frame</span>

<span class='nf'><a href='https://rdrr.io/r/base/names.html'>names</a></span><span class='o'>(</span><span class='nv'>exp_data</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "Age"       "Height_cm" "Eye_Color" "Graduated"</span>

<span class='c'>#returns vector of column names</span>

<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>exp_data</span><span class='o'>)</span>

<span class='c'>#&gt; 'data.frame':  8 obs. of  4 variables:</span>
<span class='c'>#&gt;  $ Age      : int  22 67 53 13 19 27 30 11</span>
<span class='c'>#&gt;  $ Height_cm: num  175 170 165 135 147 ...</span>
<span class='c'>#&gt;  $ Eye_Color: Factor w/ 4 levels "Blue","Brown",..: 1 4 1 2 4 3 1 2</span>
<span class='c'>#&gt;  $ Graduated: logi  TRUE TRUE FALSE FALSE TRUE TRUE ...</span>

<span class='c'>#summarizes the structure of an object</span>

<span class='nf'><a href='https://rdrr.io/r/base/summary.html'>summary</a></span><span class='o'>(</span><span class='nv'>exp_data</span><span class='o'>)</span>

<span class='c'>#&gt;       Age          Height_cm     Eye_Color Graduated      </span>
<span class='c'>#&gt;  Min.   :11.00   Min.   :134.6   Blue :3   Mode :logical  </span>
<span class='c'>#&gt;  1st Qu.:17.50   1st Qu.:146.7   Brown:2   FALSE:3        </span>
<span class='c'>#&gt;  Median :24.50   Median :167.6   Gray :1   TRUE :5        </span>
<span class='c'>#&gt;  Mean   :30.25   Mean   :164.1   Green:2                  </span>
<span class='c'>#&gt;  3rd Qu.:35.75   3rd Qu.:177.8                            </span>
<span class='c'>#&gt;  Max.   :67.00   Max.   :190.5</span>

<span class='c'>#provides a summary/summary statistics for individual variables/columns </span>
</code></pre>

</div>

</details>

</div>

</div>

<br>

## 7 -- R Packages

I mentioned above when talking about functions that many have already been written for you, and some are available as soon as you open up R - those that are considered part of "base R". All the functions we've used up to this point are included in that set. But there are lots of other functions available as part of additional packages you can install and load. The two most common places to get packages are the CRAN and Bioconductor repositories - I did a couple short videos on these as part of [this Intro To R Playlist](https://youtube.com/playlist?list=PLxhIMi78eQegFm3XqsylVa-Lm7nfiUshe).

As one example, we used the function [`read.table()`](https://rdrr.io/r/utils/read.table.html) above to read in the example dataset. A similar function, [`read_tsv()`](https://readr.tidyverse.org/reference/read_delim.html) is available as part of the *readr* package, which is available from CRAN, and so can be installed with the [`install.packages()`](https://rdrr.io/r/utils/install.packages.html) function...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"readr"</span><span class='o'>)</span>
</code></pre>

</div>

The installation should only have to be done once. Then we use the [`library()`](https://rdrr.io/r/base/library.html) function to load the library in each R session where we want to use it...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://readr.tidyverse.org'>readr</a></span><span class='o'>)</span>

<span class='c'>#&gt; Warning: package 'readr' was built under R version 3.6.2</span>
</code></pre>

</div>

Now we should have access to the readr package and all of the functions contained in it.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>exp_data2</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_tsv</a></span><span class='o'>(</span><span class='nv'>data_address</span><span class='o'>)</span>

<span class='c'>#&gt; </span>
<span class='c'>#&gt; <span style='color: #00BBBB;'>──</span><span> </span><span style='font-weight: bold;'>Column specification</span><span> </span><span style='color: #00BBBB;'>────────────────────────────────────────────────────────</span></span>
<span class='c'>#&gt; cols(</span>
<span class='c'>#&gt;   Age = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   Height_cm = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   Eye_Color = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   Graduated = <span style='color: #BBBB00;'>col_logical()</span></span>
<span class='c'>#&gt; )</span>


<span class='nv'>exp_data2</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 8 x 4</span></span>
<span class='c'>#&gt;     Age Height_cm Eye_Color Graduated</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;lgl&gt;</span><span>    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span>    22      175. Blue      TRUE     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span>    67      170. Green     TRUE     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span>    53      165. Blue      FALSE    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span>    13      135. Brown     FALSE    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span>    19      147. Green     TRUE     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span>    27      185. Gray      TRUE     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>7</span><span>    30      190. Blue      TRUE     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>8</span><span>    11      145. Brown     FALSE</span></span>
</code></pre>

</div>

You might notice that *exp_data2* is a tibble, while *exp_data* is a data frame (try the [`class()`](https://rdrr.io/r/base/class.html) function on each). This small difference in the types of objects that are returned is one of the differences in the functions [`read.table()`](https://rdrr.io/r/utils/read.table.html) and [`read_tsv()`](https://readr.tidyverse.org/reference/read_delim.html). While the class of the objects is different, the contents of the objects are the same.

In addition to functions like [`install.packages()`](https://rdrr.io/r/utils/install.packages.html) and [`library()`](https://rdrr.io/r/base/library.html) that help you manage packages in R, RStudio also provides some point-and-click ways to do these same things. Check out the *packages* tab in the bottom-right RStudio panel.

------------------------------------------------------------------------

### Bonus: Breakout Rooms III (\~10 min.)

##### Exercise 7: Reading In Compressed Data

<div class="puzzle">

<div>

Let's look at one more example for a bit more practice with packages and reading data in to R. This time, we'll try reading in a compressed (gzipped) version of the same example dataset. This one's available from...

<https://github.com/biodash/biodash.github.io/raw/master/assets/data/data_frame/example_df.tsv.gz>

Let's read this dataset in as an object named *zip_data*. First try using the [`read.table()`](https://rdrr.io/r/utils/read.table.html) function just like before.

<details>
<summary>
<b>Hint</b> (click here)
</summary>

Try replacing the previous address with the updated address for the compressed file. Remember to set the header argument to TRUE.

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#create an object storing the web address</span>
<span class='nv'>zip_address</span> <span class='o'>&lt;-</span> <span class='s'>"https://github.com/biodash/biodash.github.io/raw/master/assets/data/data_frame/example_df.tsv.gz"</span>
</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>zip_data</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/utils/read.table.html'>read.table</a></span><span class='o'>(</span><span class='nv'>zip_address</span>, header <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
</code></pre>

</div>

</details>

<br>

[`read.table()`](https://rdrr.io/r/utils/read.table.html) isn't able to uncompress a file directly from online, so you probably got an error message. However, it can automatically uncompress a file when reading it in locally (from your computer). So, see if you can use the [`download.file()`](https://rdrr.io/r/utils/download.file.html) function to get the compressed file and then read it in in a second step.

<details>
<summary>
<b>Hint</b> (click here)
</summary>

[`download.file()`](https://rdrr.io/r/utils/download.file.html) requires that two arguments are defined: *url* and *destfile*. Check [`?download.file`](https://rdrr.io/r/utils/download.file.html) for details.

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span><span class='nv'>zip_address</span>, destfile <span class='o'>=</span> <span class='s'>"example_zip_file.tsv.gz"</span><span class='o'>)</span>

<span class='nv'>zip_data</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/utils/read.table.html'>read.table</a></span><span class='o'>(</span><span class='s'>"example_zip_file.tsv.gz"</span>, header <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
</code></pre>

</div>

</details>

<br>

Alternatively, you could install the *data.table* package and try its [`fread()`](https://Rdatatable.gitlab.io/data.table/reference/fread.html) function, which is able to download and automatically uncompress a file from online all in one step (though doing so requires another package, *R.utils*, so you'll also have to get that one first if you don't already have it)...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"R.utils"</span><span class='o'>)</span>
<span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"data.table"</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/HenrikBengtsson/R.utils'>R.utils</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://r-datatable.com'>data.table</a></span><span class='o'>)</span>

<span class='nf'>data.table</span><span class='nf'>::</span><span class='nf'><a href='https://Rdatatable.gitlab.io/data.table/reference/fread.html'>fread</a></span><span class='o'>(</span><span class='nv'>zip_address</span><span class='o'>)</span>

<span class='c'>#&gt;    Age Height_cm Eye_Color Graduated</span>
<span class='c'>#&gt; 1:  22    175.26      Blue      TRUE</span>
<span class='c'>#&gt; 2:  67    170.18     Green      TRUE</span>
<span class='c'>#&gt; 3:  53    165.10      Blue     FALSE</span>
<span class='c'>#&gt; 4:  13    134.62     Brown     FALSE</span>
<span class='c'>#&gt; 5:  19    147.32     Green      TRUE</span>
<span class='c'>#&gt; 6:  27    185.42      Gray      TRUE</span>
<span class='c'>#&gt; 7:  30    190.50      Blue      TRUE</span>
<span class='c'>#&gt; 8:  11    144.78     Brown     FALSE</span>
</code></pre>

</div>

</div>

</div>

Not only does this offer a little more practice with objects, functions, and reading in data, but it also provides one small example of the value in having multiple functions available that do similar things. In this specific case, when reading in data directly from online, you might find [`read.table()`](https://rdrr.io/r/utils/read.table.html) to be a little easier to work with if the data are uncompressed, but [`fread()`](https://Rdatatable.gitlab.io/data.table/reference/fread.html) might make things a bit easier (one less step) if the file is compressed. And we actually saw a third function, [`read_tsv()`](https://readr.tidyverse.org/reference/read_delim.html) earlier (from the *readr* package), which offers yet another option for reading in data-frame-like data. This kind of thing is common in R - there are typically multiple ways of doing things, and as you work in R, you'll continue to pick up more and more efficient ways of doing what you want to do.

<br>

<br> <br>

