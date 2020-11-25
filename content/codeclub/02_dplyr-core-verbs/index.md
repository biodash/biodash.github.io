---
title: "Session 2: dplyr core verbs"
subtitle: "Using select, filter, mutate, arrange, and summarize"
summary: "During this second session of Code Club, we will be learning how to use some of the most popular dplyr one-table functions, including filter, select, mutate, arrange, and summarize."  
authors: [jessica-cooperstone]
date: "2020-11-25"
output: hugodown::md_document
toc: true

image: 
  caption: "Artwork by @allison_horst"
  focal_point: ""
  preview_only: false

rmd_hash: a118430879cdfbda

---

<br> <br> <br>

------------------------------------------------------------------------

Prep homework
-------------

### Basic computer setup

-   If you didn't already do this, please follow the [Code Club Computer Setup](/codeclub-setup/) instructions, which also has pointers for if you're new to R or RStudio.

-   If you're able to do so, please open RStudio a bit before Code Club starts -- and in case you run into issues, please join the Zoom call early and we'll troubleshoot.

### New to dplyr?

If you've never used `dplyr` before (or even if you have), you may find [this cheat sheet](https://github.com/rstudio/cheatsheets/blob/master/data-transformation.pdf) useful.

<br>

----
----

Getting Started
---------------

### Download today's R script

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'>
<span class='nv'>todays_R_script</span> <span class='o'>&lt;-</span> <span class='s'>'https://raw.githubusercontent.com/biodash/biodash.github.io/master/content/codeclub/02_dplyr-core-verbs/2_Dplyr_one-table_verbs.R'</span>

<span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span><span class='nv'>todays_R_script</span><span class='o'>)</span>
</code></pre>

</div>

<br> <br> <br> <br>

