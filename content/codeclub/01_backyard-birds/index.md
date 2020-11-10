---
output: hugodown::md_document
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Session 1: Backyard Birds"
subtitle: "Starting with RStudio Projects and reading in our data"
summary: ""
authors: [admin]
tags: [codeclub, backyard-birds]
categories: []
date: 2020-11-04
lastmod: 2020-11-04
featured: false
draft: false

toc: true

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: "Red-breasted Nuthatch, *Sitta canadensis*"
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
rmd_hash: 4e40f5cce51b3828

---

------------------------------------------------------------------------

<br>

**Contents:**

-   [Prep for this week](/post/01_backyard-birds/#prep-for-this-week)
-   [Summary of what we will cover](01_backyard-birds/#what-we-will-cover)
-   [Session content](/post/01_backyard-birds/#session-content)

<br>

------------------------------------------------------------------------

Prep for this week
------------------

### Basic computer setup

If you didn't already do this, please follow the [Code Club Computer Setup](/codeclub-setup/) instructions.

### Test if it works

Please open RStudio locally or [start an OSC RStudio Server session](codeclub-setup/#osc-run-rstudio).

If you have not used RStudio before, take a moment to explore what's in the panels and tabs. (It may help to check out [Mike Sovic's 1-minute intro to the RStudio interface](https://www.youtube.com/watch?v=ByxF3xjN2JQ&list=PLxhIMi78eQegFm3XqsylVa-Lm7nfiUshe&t=2m15s) or [RStudio's 3-minute intro](https://fast.wistia.net/embed/iframe/520zbd3tij?videoFoam=true).)

If you're able to do so, please open RStudio again a bit before Code Club starts -- and in case you run into issues, please join the Zoom call early and we'll troubleshoot.

### New to R?

Please have a look at our [New to R?](/codeclub-novice/) page.

<br>

------------------------------------------------------------------------

What we will cover
------------------

-   Introducing Code Club

-   Making sure everyone has a working RStudio session

-   RStudio Projects

-   The Backyard Bird Count (BBC) data

-   If we have time: Reading in & exploring the BBC data

<br>

------------------------------------------------------------------------

Session content
---------------

### Intro to RStudio Projects

Rstudio Projects help you to organize your work and to make it more portable. We recommend creating a separate Project for each research project with an R component -- and for things like Code Club. Using Projects has several advantages:

-   They record which files are open in RStudio, and will reopen all of those when you reopen the project. This becomes quite handy, say, when you work on three projects, each of which use a number of scripts.

-   An even more significant advantage is that Projects allow you to use *relative file paths*, and avoids having to manually set your working directory. This way, even if you move the directory on your computer or copy it to a different computer, the same commands would still work. This would not be the case if you had a command like [`setwd('C:/Users/Jane/Documents/')`](https://rdrr.io/r/base/getwd.html) in your code.

-   Finally, Projects encourage you to organizing your research projects inside self-contained directories, rather than have files spread around your computer, which increases reproducibility.

### Create an RStudio Project

Let's create an RStudio Project for Code Club:

-   Open RStudio locally or [start an OSC RStudio Server session](codeclub-setup/#osc-run-rstudio).

-   *If you're working locally*, create a directory wherever you like on your computer for all things Code Club. You can do this in R using [`dir.create()`](https://rdrr.io/r/base/files2.html), or outside of R. (If you're at OSC, you'll already be in a Code Club-specific, personal directory.)

-   Click `File` (top menu bar) \> `New Project` \> `Existing Directory`.

    -   *If you're working locally*, select the Code Club directory that you created in the previous step.

    -   *If you're working at OSC*, keep the default choice "[`~`](https://rdrr.io/r/base/tilde.html)" (i.e., *home*), which is the directory you started in when entering the RStudio Server session.

-   You should now see the file ending in `.Rproj` in the RStudio `Files` tab in the lower right pane. (You can open a project from inside RStudio, or by clicking on the `.Rproj` file in your file browser.)

### Orienting ourselves

Type in the console (bottom left):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/getwd.html'>getwd</a></span><span class='o'>(</span><span class='o'>)</span>
</code></pre>

</div>

The working directory will *always* be the directory that contains the `.Rproj` file when we have that project open. This way, we can refer to all of our files in Code Club using relative paths starting from that directory, and we don't need to set the working directory using an absolute path with [`setwd()`](https://rdrr.io/r/base/getwd.html), which is not portable.

Let's create two new directories, one for this session, and one of the data (which we will be reusing across sessions):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>'S01'</span><span class='o'>)</span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>'data/birds/'</span>, recursive <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span> <span class='c'># The "recursive" argument lets us create two levels at once</span>
</code></pre>

</div>

We don't want to be typing our commands in the console, but will want to save them and execute them from a script.

Open a new R script using `File` (top menu bar) \> `New File` \> `R script`.  
Save the script (`File` \> `Save`) as `S01.R` inside your `S01` directory.

As the first line our script, we load the `tidyverse`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
</code></pre>

</div>

*Press `Ctrl` + `Enter` to execute the line, i.e. to send it to the console.*

### Backyard Bird Count data

**TBA**

### Downloading and reading in our dataset

Download:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>file_url</span> <span class='o'>&lt;-</span> <span class='s'>'https://raw.githubusercontent.com/biodash/biodash.github.io/master/data/birds/backyard-birds_Ohio.tsv'</span>
<span class='nv'>birds_file</span> <span class='o'>&lt;-</span> <span class='s'>'data/birds/backyard-birds_Ohio.tsv'</span>
<span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>file_url</span>, destfile <span class='o'>=</span> <span class='nv'>birds_file</span><span class='o'>)</span>
</code></pre>

</div>

Read it into R:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>birds</span> <span class='o'>&lt;-</span> <span class='nf'>read_csv</span><span class='o'>(</span><span class='nv'>birds_file</span><span class='o'>)</span>
</code></pre>

</div>

<div class="alert alert-note">

<div>

This is an **alert** note.

</div>

<div class="alert puzzle">

<div>

This is a puzzle div, for do-it-yourself challenges.

</div>

<div class="puzzle">

This is a **puzzle** div, for do-it-yourself challenges.

</div>

### Exploring backyard birds

**TBA**

<br> <br> <br>

