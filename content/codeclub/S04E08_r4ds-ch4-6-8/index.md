---
output: hugodown::md_document
title: "S04E08: R for Data Science - Chapters 4, 6, and 8"
subtitle: "Covering some R Basics, how to work with R scripts, and introducing RStudio Projects"
summary: "In this first session of Code Club for Fall '22, we will continue working our way through the book R for Data Science. Today, we'll look at three very short chapters on some R and RStudio basics."
authors: [jessica-cooperstone]
tags: [codeclub, r4ds]
date: "2022-09-15"
lastmod: "2022-09-15"
toc: true
rmd_hash: 6b5ba0dd28c09833

---

<p align="center">
<img src=img/r4ds_cover.png width="45%">
</p>

------------------------------------------------------------------------

## I -- Brief Code Club Introduction

### Organizers

-   *Michael Broe* -- Evolution, Ecology and Organismal Biology (EEOB)
-   *Jessica Cooperstone* -- Horticulture & Crop Science (HCS) / Food Science & Technology (FST)
-   *Stephen Opiyo* -- Molecular & Cellular Imaging Center (MCIC) - Columbus
-   *Jelmer Poelstra* -- Molecular & Cellular Imaging Center (MCIC) - Wooster
-   *Mike Sovic* -- Infectious Diseases Institute AMSL - Genomics Lab

### Code Club practicalities

-   In-person (Columbus & Wooster) and Zoom hybrid

-   Mix of instruction/discussion with the entire group, and doing exercises in breakout groups of up to 4-5 people.

-   When doing **exercises in breakout groups**, we encourage you:

    -   To briefly introduce yourselves and to do the exercises as a group
    -   On Zoom, to turn your cameras on and to have someone share their screen (use the `Ask for help` button in Zoom to get help from an organizer)
    -   To let a *less* experienced person do the screen sharing and coding

-   You can **ask a question** at any time, by speaking or typing in the Zoom chat.

-   You can generally come early or stay late for **troubleshooting** but also for questions related to your research.

Some more notes:

-   We recommend that you **read** the relevant (part of the) chapter before each session, especially if the material in the chapter is new to you.

-   We try to make each session **as stand-alone as possible**. Still, if you missed one or more sessions, you would ideally catch up on reading those parts of the book, especially when we split a chapter across multiple sessions.

-   We **record** the whole-group parts of the Zoom call, and share the recordings only with Code Club participants.

### New to Code Club or R?

Take a look at these pages on our website:

-   [Computer setup for Code Club](/codeclub-setup/)
-   [Resources and tips to get started with R](/tutorials/r-resources-tips/)
-   [List of all previous Code Club session topics](/codeclub-schedule/#previous-semesters)

<br>

------------------------------------------------------------------------

## II -- The R for Data Science book (R4DS)

This excellent book by Hadley Wickham (also author of many of the R packages used in the book!) and Garret Grolemund, has a freely available **[online version](https://r4ds.had.co.nz/) that is regularly updated** and contains exercises. It was originally published in 2016.

The book focuses on the so-called **"*tidyverse*" ecosystem** in R. The *tidyverse* can be seen as a **modern dialect of R**. In previous Code Clubs, we have often --but not always!-- been doing things "the *tidyverse* way" as well.

For today's chapters, The R4DS exercises I think are not so good, so I've replaced some and added some of my own.

<br>

------------------------------------------------------------------------

## III -- R4DS Chapter 4

In the first two R4DS exercises for this chapter, the message is that R does not handle typos so make sure you spell things correctly.

Exercise 3: take a look at the RStudio keyboard shortcuts by clicking `Tools` \> `Keyboard Shortcut Help`, or you can press <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>K</kbd> on a PC.

<br>

------------------------------------------------------------------------

## IV -- R4DS Chapter 6

<div class="puzzle">

<div>

Run the following code:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>cars</span><span class='o'>)</span></span></code></pre>

</div>

What went wrong?

<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

[`glimpse()`](https://pillar.r-lib.org/reference/glimpse.html) is a function from the *dplyr* package, one of the core *tidyverse* packages that are loaded as part of the tidyverse.

However, in every R session in which you want to use tidyverse function, you always need call [`library(tidyverse)`](https://tidyverse.tidyverse.org).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span></span></code></pre>

</div>

Now you can use [`glimpse()`](https://pillar.r-lib.org/reference/glimpse.html):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://pillar.r-lib.org/reference/glimpse.html'>glimpse</a></span><span class='o'>(</span><span class='nv'>cars</span><span class='o'>)</span></span><span><span class='c'>#&gt; Rows: 50</span></span>
<span><span class='c'>#&gt; Columns: 2</span></span>
<span><span class='c'>#&gt; $ speed <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> 4, 4, 7, 7, 8, 9, 10, 10, 10, 11, 11, 12, 12, 12, 12, 13, 13, 13…</span></span>
<span><span class='c'>#&gt; $ dist  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> 2, 10, 4, 22, 16, 10, 18, 26, 34, 17, 28, 14, 20, 24, 28, 26, 34…</span></span></code></pre>

</div>

<br>

Note, if you got an error like this when running [`library(tidyverse)`](https://tidyverse.tidyverse.org):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'>#&gt; Error in library(tidyverse) : there is no package called ‘tidyverse’</span></span></code></pre>

</div>

...that means you still need to *install* it:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"tidyverse"</span><span class='o'>)</span></span>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span></span></code></pre>

</div>

</details>

</div>

</div>

<br>

------------------------------------------------------------------------

## IV -- R4DS Chapter 8

<div class="puzzle">

<div>

Create an RStudio Project for Code Club.

</div>

</div>

<div class="puzzle">

<div>

Run the code below in your new Project:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nv'>diamonds</span>, <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span><span class='nv'>carat</span>, <span class='nv'>price</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_hex.html'>geom_hex</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggsave.html'>ggsave</a></span><span class='o'>(</span><span class='s'>"diamonds.pdf"</span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://readr.tidyverse.org/reference/write_delim.html'>write_csv</a></span><span class='o'>(</span><span class='nv'>diamonds</span>, <span class='s'>"diamonds.csv"</span><span class='o'>)</span></span></code></pre>

</div>

-   What does the code above do?

-   Find the files `diamonds.pdf` and `diamonds.csv` on your computer, without using a search function. How did you know where to look for them?

-   Where is the R working directory on your computer?

<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

-   The code does the following:

    -   Load the *tidyverse* package
    -   Create a simple plot using the tidyverse `diamonds` dataset
    -   Save the plot to disk as a PDF file
    -   Save the `diamonds` dataframe to disk as a CSV file

-   The files were saved in the same folder as your newly created RStudio project. (See also the next point.)

-   Whenever you have an active RStudio Project, R's working directory will be in the same folder as your RStudio project.

</details>

</div>

</div>

<br> <br>

