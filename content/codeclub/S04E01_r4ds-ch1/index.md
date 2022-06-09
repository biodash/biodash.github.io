---
output: hugodown::md_document
title: "S04E01: R for Data Science - Chapter 1: Introduction"
subtitle: "Introducing a new season of Code Club, in which we will read the book R for Data Science (R4DS)"
summary: "We will introduce a new season of Code Club, in which we'll do things a little differently than before: we are going to work our way through a book: R for Data Science. Today, we'll look at the first, introductory chapter of the book."
authors: [admin]
tags: [codeclub, r4ds]
date: "2022-06-09"
lastmod: "2022-06-09"
toc: true
rmd_hash: 0f3514e17c8439e2

---

<br> <br>

------------------------------------------------------------------------

## I -- Intro to this season of Code Club

### Organizers

-   *Michael Broe* -- Evolution, Ecology and Organismal Biology (EEOB)
-   *Jessica Cooperstone* -- Horticulture & Crop Science (HCS) / Food Science & Technology (FST)
-   *Stephen Opiyo* -- Molecular & Cellular Imaging Center (MCIC) - Columbus
-   *Jelmer Poelstra* -- Molecular & Cellular Imaging Center (MCIC) - Wooster
-   *Mike Sovic* -- Center for Applied Plant Sciences (CAPS)

### Session logistics

-   In-person (Columbus & Wooster) and Zoom hybrid

-   Mix of instruction/discussion with the entire group, and doing exercises in breakout groups of up to \~4 people.

-   When doing **exercises in breakout groups**, we encourage you:

    -   To briefly introduce yourselves and to do the exercises as a group
    -   On Zoom, to turn your cameras on and to have someone share their screen (use the `Ask for help` button in Zoom to get help from an organizer)
    -   To let a *less* experienced person do the coding

-   You can interrupt us to **ask a question** at any time, by speaking or typing in the Zoom chat.

-   You can generally come early or stay late for **troubleshooting or questions related to your research.**

Also:

-   We recommend that you **read** the relevant (part of the) chapter before each session, especially if the material in the chapter is new to you.

-   We try to make each session **as stand-alone as possible**. Still, if you missed one or more sessions, you would ideally catch up on reading those parts of the book, especially when we split a chapter across multiple sessions.

-   We **record** the whole-group parts of the Zoom call, and share the recordings only with Code Club participants.

-   We're always hoping for someone outside of the group of organizers to **lead a session** -- this might be more feasible now that we're going through a book?

### New to Code Club or R?

Take a look at these pages on our website:

-   [Computer setup for Code Club](/codeclub-setup/)
-   [Resources and tips to get started with R](/tutorials/r-resources-tips/)
-   [List of all previous Code Club session topics](/codeclub-schedule/#previous-semesters)

<br>

------------------------------------------------------------------------

## II -- The R for Data Science book (R4DS)

<p align="center">
<img src=img/r4ds_cover.png width="35%">
</p>

This excellent book by Hadley Wickham (also author of many of the R packages used in the book!) and Garret Grolemund, has a freely available **[online version](https://r4ds.had.co.nz/) that is regularly updated**. It was originally published in 2016.

The book doesn't technically assume any **previous experience with R**, but if you're completely new to R and to coding in any language, we would recommend you take a look at some introductory R material ([see this page with some resources](/tutorials/r-resources-tips/)) before we start with Chapter 2 next week.

The book focuses on the so-called **"tidyverse" ecosystem** in R. The *tidyverse* is a collection of R packages which focuses on improved and more consistent approaches than those of "base R" (i.e., shipped with R by default). As such, the *tidyverse* can be seen as a modern dialect of R. In previous Code Clubs, we have often --but not always!-- been doing things "the tidyverse way" as well.

We will *not* be able to finish the book by the end of the summer. But if folks are liking the book, we may carry on with it during the fall semester.

<br>

------------------------------------------------------------------------

## III -- R4DS Chapter 1 notes

### 1.1 - What you will learn

The data science process visualized:

<p align="center">
<img src=img/data-science.png width="80%">
</p>

<br>

### 1.3 - What you won't learn

Some perhaps unfamiliar terms and concepts that came by in [this section](https://r4ds.had.co.nz/introduction.html#what-you-wont-learn):

#### [1.3.1 - Processing big data](https://r4ds.had.co.nz/introduction.html#big-data)

> Fortunately each problem is independent of the others (a setup that is sometimes called embarrassingly parallel), so you just need a system (like Hadoop or Spark) that allows you to send different datasets to different computers for processing.

At OSU, and most other universities, we instead tend to make use of "**supercomputers**" when we want to simultaneously run an analysis many times, and more broadly, if we have "big data". Specifically, we have the ["Ohio Supercomputer Center" (OSC)](https://www.osc.edu/) here.

#### [1.3.3 - Rectangular data](https://r4ds.had.co.nz/introduction.html#non-rectangular-data)

Rectangular data is basically data that can be effectively entered in a spreadsheet (and in R, we tend to put this in a so-called "data frame", or tidyverse-style, in a "tibble").

The chapter mentions some examples of non-rectangular data, such as text and (phylogenetic) trees.

<br>

### 1.4.2 - RStudio interface

R itself simply provides a "*console*" (command-line interface) where you can type your commands. RStudio, on the other hand, allows you to see the R console side-by-side with your scripts, plots, and more.

Once you have a running instance of RStudio, **create a new R script** by clicking `File` \> `New File` \> `R Script`. Now, you should see all 4 "panes" that the RStudio window is divided into:

-   *Top-left*: The **Editor** for your scripts and other documents (*hidden when no file is open*).
-   *Bottom-left*: The **R Console** to interactively run your code (+ a tab with a **Terminal**).
-   *Top-right*: Your **Environment** with R objects you have created (+ several other tabs).
-   *Bottom-right*: Tabs for **Files**, **Plots**, **Help**, and others.

<p align="center">
<img src=img/rstudio-layout-ed.png width="95%">
</p>

<br>

<div class="puzzle">

<div>

### Check that you have R and RStudio working

Take a moment to ***explore the RStudio interface***. Were you able to open an R script? Can you run some simple R code in the console (e.g., [the example in the book](https://r4ds.had.co.nz/introduction.html#running-r-code))?

Take a look at your ***version of R***: this was printed in the console when you started RStudio (see the RStudio screenshot above).

The current version of R is `4.2.0`. If your version of R is below `4.0`, it will be a good idea to update R. To do so, you can follow [these instructions](/tutorials/r-resources-tips/#updating-r). But it is better to start this process at the very end of this session or after it, since it may take a while.

</div>

</div>

<br>

### 1.4.3 & 1.4.4 - R packages

> An R package is a collection of functions, data, and documentation that extends the capabilities of base R.

So, you can think of packages as "add-ons" / "extensions" to R.

#### Installation versus loading

Packages have to be separately **installed** (usually *from within R*, using R code) and once you have done this, you don't need to redo it unless:

-   You want a different version of the package
-   You have switched to a different version of R

Unlike installation, **loading** a package is necessary again and again, in every R session that you want to use it.

#### The tidyverse

The *tidyverse* is unusual in that it is a *collection* of packages that can be installed and loaded with a single command. The individual *tidyverse* packages are the focus of several chapters in the book, for instance:

| Package           | Functionality                 | Main chapter |
|-------------------|-------------------------------|--------------|
| *ggplot2*         | Creating plots                | Ch. 3        |
| *tidyr* & *dplyr* | Manipulating dataframes       | Ch. 5 and 7  |
| *readr*           | Reading in data               | Ch. 11       |
| *stringr*         | Working with "strings" (text) | Ch. 14       |
| *forcats*         | Working with "factors"        | Ch. 15       |
| *purrr*           | Iteration                     | Ch. 21       |

#### Data packages

Additionally, we'll use a couple of "data packages" (packages that only contain data, and no functions) throughout the book: *nycflights13*, *gapminder*, and *Lahman*.

<br>

------------------------------------------------------------------------

## Breakout rooms

<div class="puzzle">

<div>

### 1. Introduce yourselves!

Please take a moment to introduce yourself to your breakout roommates. You may also want to mention:

-   Your level of experience with R (and perhaps other coding languages)

-   What you want to use R for, or what you are already using R for

-   Perhaps why you think this book might be useful

</div>

</div>

<div class="puzzle">

<div>

### 2. Install/load the packages

*Usually, exercises can be done with your breakout group on one computer, but the following should be done individually, to check that everyone is up and running.*

Most of you should already have the ***tidyverse*** installed, so let's start by trying to *load* it. This is done with the [`library()`](https://rdrr.io/r/base/library.html) function. To check if you can load the *tidyverse*, run the following and see if you get similar output as printed below:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
<span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching packages</span> ─────────────────────────────────────── tidyverse 1.3.1 ──</span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>ggplot2</span> 3.3.6     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>purrr  </span> 0.3.4</span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tibble </span> 3.1.7     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>dplyr  </span> 1.0.9</span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tidyr  </span> 1.2.0     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>stringr</span> 1.4.0</span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>readr  </span> 2.1.2     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>forcats</span> 0.5.1</span>
<span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span> ────────────────────────────────────────── tidyverse_conflicts() ──</span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>filter()</span> masks <span style='color: #0000BB;'>stats</span>::filter()</span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>lag()</span>    masks <span style='color: #0000BB;'>stats</span>::lag()</span></code></pre>

</div>

If that didn't work, try to install (and then load) the *tidyverse*:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>## Note: the package name is "quoted" in the install.packages() function:</span>
<span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"tidyverse"</span><span class='o'>)</span>

<span class='c'>## ... but it is (normally) not in library():</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span></code></pre>

</div>

<br>

Now, let's also install the **data packages**:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"nycflights13"</span>, <span class='s'>"gapminder"</span>, <span class='s'>"Lahman"</span><span class='o'>)</span><span class='o'>)</span></code></pre>

</div>

The previous installation commands should return a whole bunch of output, but if all went well, you should not see any errors. Instead, look for phrases like `* DONE (nycflights13)`, which indicate successful installation of a package.

You can also load the data packages:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/hadley/nycflights13'>nycflights13</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/jennybc/gapminder'>gapminder</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://CRAN.R-project.org/package=Lahman'>Lahman</a></span><span class='o'>)</span></code></pre>

</div>

You won't see any output when loading most packages, like the three above (but unlike the *tidyverse*).

**Bonus question:** What are these "conflicts" in the *tidyverse* startup messages referring to?

</div>

</div>

<div class="puzzle">

<div>

### 3. Bonus: Questions or remarks about the chapter?

Discuss or ask about whatever you thought was interesting/confusing/etc about the chapter!

If nothing else comes up, you could think about and discuss the following:

-   [1.3.2](https://r4ds.had.co.nz/introduction.html#python-julia-and-friends): ***"Data science teams"*** -- Are grad students in a lab "Data science teams", or are they talking about something else? What does this, perhaps, say about the primary expected audience for the book?

-   [1.3.4](https://r4ds.had.co.nz/introduction.html#hypothesis-confirmation): "Hypothesis generation" vs. "hypothesis confirmation" -- are you familiar with this distinction and do you used it in practice?

-   [1.3.2](https://r4ds.had.co.nz/introduction.html#python-julia-and-friends): Other languages commonly used for data analysis: **Python** and **Julia**. Are you familiar at all with these languages and their pros and cons with respect to R?

</div>

</div>

<br> <br>

