---
output: hugodown::md_document
title: "Session 1: Backyard Birds"
subtitle: "Starting with RStudio Projects and reading in our data"
summary: "In the first session of Code Club, we'll make sure that everyone is properly set up, create an RStudio Project, and start working with some data from the Great Backyard Bird Count."
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
rmd_hash: b8b079ba560ad7f5

---

------------------------------------------------------------------------

<br>

Prep homework
-------------

#### Basic computer setup

If you didn't already do this, please follow the [Code Club Computer Setup](/codeclub-setup/) instructions.

#### Test if it works

Please open RStudio locally or [start an OSC RStudio Server session](/codeclub-setup/#osc-run-rstudio).

If you have not used RStudio before, take a moment to explore what's in the panels and tabs. (It may help to check out [Mike Sovic's 1-minute intro to the RStudio interface](https://www.youtube.com/watch?v=ByxF3xjN2JQ&list=PLxhIMi78eQegFm3XqsylVa-Lm7nfiUshe&t=2m15s) or [RStudio's 3-minute intro](https://fast.wistia.net/embed/iframe/520zbd3tij?videoFoam=true).)

If you're able to do so, please open RStudio again a bit before Code Club starts -- and in case you run into issues, please join the Zoom call early and we'll troubleshoot.

#### New to R?

If you're completely new to R, it will be useful to have a look at some of the resources listed on our [New to R?](/codeclub-novice/) page prior to Code Club.

<br>

------------------------------------------------------------------------

Session summary
---------------

-   Introducing Code Club

-   Making sure everyone has a working RStudio session

-   RStudio Projects & orienting ourselves

-   Getting started with data from the Great Backyard Bird Count

<br>

------------------------------------------------------------------------

------------------------------------------------------------------------

1 - Create an RStudio Project
-----------------------------

Projects are an RStudio-specific concept that create a special file (`.Rproj`), primarily to designate a directory as the working directory for everything within it. We recommend creating exactly one separate Project for each research project with an R component -- and for things like Code Club.

<br>

<div class="alert alert-note">

<div>

**Why use Projects?**

In brief, Projects help you to organize your work and to make it more portable.

-   They record which scripts (and R Markdown files) are open in RStudio, and will reopen all of those when you reopen the project. This becomes quite handy, say, when you work on three different projects, each of which uses a number of scripts.

-   When using Projects, you generally don't have to manually set your working directory, and can use *relative file paths* to refer to files within the project. This way, even if you move the project directory, or copy it to a different computer, the same paths will still work. (This would not be the case if you used [`setwd()`](https://rdrr.io/r/base/getwd.html) which will generally require you to use an absolute path, e.g. [`setwd('C:/Users/Jane/Documents/')`](https://rdrr.io/r/base/getwd.html).)

-   Projects encourage you to organize research projects inside self-contained directories, rather than with files spread around your computer. This can save you a lot of headaches and increases reproducibility.

</div>

</div>

<br>

**Let's create an RStudio Project for Code Club:**

-   Open RStudio locally or [start an OSC RStudio Server session](/codeclub-setup/#osc-run-rstudio).  
    (*If you're at OSC*, you should see a file `0_CODECLUB.md` that's open in your top-left panel. You can ignore/close this file.)

-   *If you're working locally*, create a directory wherever you like on your computer for all things Code Club. You can do this in R using [`dir.create("path/to/your/dir")`](https://rdrr.io/r/base/files2.html), or outside of R.  
    (*If you're at OSC*, skip this step because you're automatically inside a Code Club-specific, personal directory.)

-   Click `File` (top menu bar) \> `New Project`, and then select `Existing Directory`.

    -   *If you're working locally*, select the Code Club directory that you created in the previous step.

    -   *If you're working at OSC*, keep the default choice "[`~`](https://rdrr.io/r/base/tilde.html)" (i.e., *home*), which is the directory you started in when entering the RStudio Server session.

-   After RStudio automatically reloads, you should see the file ending in `.Rproj` in the RStudio `Files` tab in the lower right pane, and you will have the Project open. All done for now!

(For future Code Club sessions, OSC users will have the Project automatically opened upon opening RStudio Server. If you're working locally and also using RStudio outside of this Project, you can open it by `File` \> `Open Project` inside RStudio, or by clicking the `.Rproj` file in your file browser, which will open RStudio *and* the Project.)

<br>

------------------------------------------------------------------------

2 - Orienting ourselves
-----------------------

#### Where are we?

We don't need to set our working directory, because our newly created Project is open, and we will therefore automatically have as our working directory the directory that contains the `.Rproj` file.

To see where you are, type or copy into the console (bottom left):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/getwd.html'>getwd</a></span><span class='o'>(</span><span class='o'>)</span>    <span class='c'># Short for "get working directory"</span>

<span class='nf'><a href='https://rdrr.io/r/base/list.files.html'>dir</a></span><span class='o'>(</span><span class='o'>)</span>      <span class='c'># Listing files in your current directory.</span>
           <span class='c'># This should return at least the `.RProj` file.</span>
</code></pre>

</div>

#### Create directories

Create two new directories -- one for this session, and one for a dataset that we will download shortly (and will be reusing across sessions):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># Dir for Code Club Session 1:</span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>'S01'</span><span class='o'>)</span>

<span class='c'># Dir for our bird data:</span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>'data/birds/'</span>, recursive <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span> <span class='c'># The "recursive" argument lets us</span>
                                            <span class='c'># create two levels at once</span>
</code></pre>

</div>

#### Create a script

To keep a record of what we are doing, and to easily modify and rerun earlier commands, we'll want to save our commands in a script and execute them from there, rather than typing our commands directly in the console.

-   Click `File` (top menu bar) \> `New File` \> `R script`.

-   Save the script (`File` \> `Save`) as `S01.R` inside your `S01` directory.

#### First line of the script

We will now load the core set of 8 *tidyverse* packages all at once. To do so, type/copy the command below on the first line of the script, and then **execute it** by clicking `Run` (top right of script pane) or by pressing `Ctrl Enter` (Windows/Linux, this should also work in your browser) or `⌘ Enter` (Mac).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># install.packages("tidyverse") # If you're working locally and did not install it yet</span>

<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>    <span class='c'># library() is the standard function to load R packages</span>

<span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching packages</span><span> ─────────────────────────────────────── tidyverse 1.3.0 ──</span></span>

<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>ggplot2</span><span> 3.3.2     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>purrr  </span><span> 0.3.4</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>tibble </span><span> 3.0.4     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>dplyr  </span><span> 1.0.2</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>tidyr  </span><span> 1.1.2     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>stringr</span><span> 1.4.0</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>readr  </span><span> 1.3.1     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>forcats</span><span> 0.5.0</span></span>

<span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span><span> ────────────────────────────────────────── tidyverse_conflicts() ──</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>filter()</span><span> masks </span><span style='color: #0000BB;'>stats</span><span>::filter()</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>lag()</span><span>    masks </span><span style='color: #0000BB;'>stats</span><span>::lag()</span></span>
</code></pre>

</div>

If it worked, you should get the same output as shown in the code block above: it attached 8 packages, and it warns that some of its functions are now "masking" base R functions.

<div class="alert alert-note">

<div>

The *tidyverse* is a very popular and useful ecosystem of R packages for data analysis, which we will be using a lot in Code Club (despite some disadvantages[^1]).

When we refer to "*base R*" as opposed to the *tidyverse*, we mean functions that are loaded in R by default (without loading a package), and that can perform similar operations in a different way.

</div>

</div>

<br>

------------------------------------------------------------------------

3 - Getting our dataset
-----------------------

We downloaded a Great Backyard Bird Count (GBBC) [dataset](https://www.gbif.org/dataset/82cb293c-f762-11e1-a439-00145eb45e9a) from the [Global Biodiversity Information Facility (GBIF)](https://www.gbif.org/). Because the file was 3.1 GB large, we selected only the records from Ohio and removed some uninformative columns. We'll download the resulting much smaller file (41.5 MB) from our Github repo.

<div class="alert alert-note">

<div>

### The Great Backyard Bird Count

<div class="highlight">

<img src="GBBC_screenshot.png" width="90%" style="display: block; margin: auto;" />

</div>

<br>

The [GBBC](https://gbbc.birdcount.org/) is an annual citizen science event where everyone is encouraged to to identify and count birds in their backyard -- or anywhere else -- for at least 15 minutes, and report their sightings online. Since 2013, it is a global event, but it has been done since 1998 in the US and Canada.

</div>

</div>

#### Download the data

We can download the dataset using the [`download.file()`](https://rdrr.io/r/utils/download.file.html) function:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># The URL to our file:</span>
<span class='nv'>birds_file_url</span> <span class='o'>&lt;-</span> <span class='s'>'https://raw.githubusercontent.com/biodash/biodash.github.io/master/assets/data/birds/backyard-birds_Ohio.tsv'</span>

<span class='c'># The path to the file we want to download to:</span>
<span class='nv'>birds_file</span> <span class='o'>&lt;-</span> <span class='s'>'data/birds/backyard-birds_Ohio.tsv'</span>

<span class='c'># Download</span>
<span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>birds_file_url</span>, destfile <span class='o'>=</span> <span class='nv'>birds_file</span><span class='o'>)</span>
</code></pre>

</div>

#### Read the data

Now, let's read the file into R. The `.tsv` extension ("tab-separated values") tells us this is a plain text file in which columns are separated by tabs, so we will use a convenience function from the *readr* package (which is part of the core set of 8 *tidyverse* packages, so it is already loaded) for exactly this type of file:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>birds</span> <span class='o'>&lt;-</span> <span class='nf'>read_tsv</span><span class='o'>(</span><span class='nv'>birds_file</span><span class='o'>)</span>

<span class='c'>#&gt; Parsed with column specification:</span>
<span class='c'>#&gt; cols(</span>
<span class='c'>#&gt;   class = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   order = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   family = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   genus = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   species = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   locality = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   stateProvince = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   decimalLatitude = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   decimalLongitude = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   eventDate = <span style='color: #0000BB;'>col_datetime(format = "")</span><span>,</span></span>
<span class='c'>#&gt;   species_en = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   range = <span style='color: #BB0000;'>col_character()</span></span>
<span class='c'>#&gt; )</span>
</code></pre>

</div>

Done! We have now read our data into a *tibble*, which is a type of data frame (formally a *data.frame*): R's object type to deals with tabular data wherein each column can contain a different type of data (numeric, characters/strings, etc).

<br>

------------------------------------------------------------------------

4 - Exploring backyard birds
----------------------------

<div class="puzzle">

### Exercise 1

**What's in the dataset?**

-   Explore the output of the following commands, and try to understand what you see. What does a single row represent, and what is in each column?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>birds</span>          <span class='c'># Type the name of an object to print it to screen</span>
<span class='nf'><a href='https://rdrr.io/r/base/print.html'>print</a></span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>)</span>   <span class='c'># Same as above, but explicitly calling print()    </span>

<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>)</span>     <span class='c'># Short for "structure", for column-wise information </span>
<span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>)</span> <span class='c'># tidyverse version of str()</span>

<span class='nf'><a href='https://rdrr.io/r/utils/View.html'>View</a></span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>)</span>    <span class='c'># In RStudio, will open object in a table in an Rstudio tab.</span>
               <span class='c'># Or: clicking on the object in the `Environment` pane!</span>
</code></pre>

</div>

-   In particular, pay attention to the data types (e.g., "character" or `chr`) of the different columns, which several of these functions print. The output of our `read_csv()` command also printed this information -- this function parsed our column into the types we see now. Were all the columns parsed correctly?

-   How many rows and how many columns does the dataset have?

-   What are some simple questions you would like to answer using this dataset? We'll collect some of these and try to answer them in later sessions.

<details>

<summary> Hints (click here) </summary> <br>

-   Note that in R, `dbl` (for "double") and `num` (for "numeric") are both used, and almost interchangeably so, for floating point numbers. (Integers are a separate class that are simply called "integers" and abbreviated as `int`, but we have no integer columns in this dataset.)

-   `read_tsv()` parsed our date as a "date-time" (`dttm` or `POSIXct` for short), which contains both a date and a time (this is not a common format for most R users). In our case, it looks like the time is always "00:00:00" and thus doesn't provide any information.

</details>

<br>

<details>

<summary> Solutions (click here) </summary> <br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># Just printing the glimpse() output which will show the number of rows and columns:</span>
<span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>)</span>

<span class='c'>#&gt; Rows: 311,441</span>
<span class='c'>#&gt; Columns: 12</span>
<span class='c'>#&gt; $ class            <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Aves", "Aves", "Aves", "Aves", "Aves", "Aves", "Ave…</span></span>
<span class='c'>#&gt; $ order            <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Passeriformes", "Passeriformes", "Passeriformes", "…</span></span>
<span class='c'>#&gt; $ family           <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Corvidae", "Corvidae", "Corvidae", "Corvidae", "Cor…</span></span>
<span class='c'>#&gt; $ genus            <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Cyanocitta", "Cyanocitta", "Cyanocitta", "Cyanocitt…</span></span>
<span class='c'>#&gt; $ species          <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Cyanocitta cristata", "Cyanocitta cristata", "Cyano…</span></span>
<span class='c'>#&gt; $ locality         <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "44805 Ashland", "45244 Cincinnati", "44132 Euclid",…</span></span>
<span class='c'>#&gt; $ stateProvince    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Ohio", "Ohio", "Ohio", "Ohio", "Ohio", "Ohio", "Ohi…</span></span>
<span class='c'>#&gt; $ decimalLatitude  <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 40.86166, 39.10666, 41.60768, 39.24236, 39.28207, 41…</span></span>
<span class='c'>#&gt; $ decimalLongitude <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> -82.31558, -84.32972, -81.50085, -84.35545, -84.4688…</span></span>
<span class='c'>#&gt; $ eventDate        <span style='color: #555555;font-style: italic;'>&lt;dttm&gt;</span><span> 2007-02-16, 2007-02-17, 2007-02-17, 2007-02-19, 200…</span></span>
<span class='c'>#&gt; $ species_en       <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Blue Jay", "Blue Jay", "Blue Jay", "Blue Jay", "Blu…</span></span>
<span class='c'>#&gt; $ range            <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># You can also check the number of rows and columns directly using:</span>
<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>)</span>          <span class='c'># Will return the number of rows and columns</span>

<span class='c'>#&gt; [1] 311441     12</span>


<span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>)</span>         <span class='c'># Will return the number of rows</span>

<span class='c'>#&gt; [1] 311441</span>

<span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>ncol</a></span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>)</span>         <span class='c'># Will return the number of columns</span>

<span class='c'>#&gt; [1] 12</span>
</code></pre>

</div>

</details>

</div>

<br> <br>

------------------------------------------------------------------------

------------------------------------------------------------------------

Bonus material
--------------

<br>

<div class="alert alert-note">

<div>

### `readr` options for challenging files

Note that we read in our file specifying any additional arguments to the `readr()` function, i.e. with all the default options. It is not always this easy!

Some options for more complex cases:

-   The more general counterpart of this function is `read_delim()`, which allows you to specify the delimiter using an argument using the `sep` argument, e.g. `sep="\t"` for tabs.

-   There are also arguments to these functions for when you need to skip lines, when you don't have column headers, when you need to specify the column types of some or all the columns, and so forth -- see this example:  

    <div class="highlight">

    <pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>my_df</span> <span class='o'>&lt;-</span> <span class='nf'>read_delim</span><span class='o'>(</span>
      file <span class='o'>=</span> <span class='s'>'file.txt'</span>,
      sep <span class='o'>=</span> <span class='s'>'\t'</span>,               <span class='c'># Manually specify tab as delimiter</span>
      col_names <span class='o'>=</span> <span class='kc'>FALSE</span>,        <span class='c'># Don't consider the first line to be a header</span>
      skip <span class='o'>=</span> <span class='m'>3</span>,                 <span class='c'># Skip the first three lines of the file</span>
      comment <span class='o'>=</span> <span class='s'>"#"</span>,            <span class='c'># Skip any line beginning with a "#"</span>
      col_types <span class='o'>=</span> <span class='nf'>cols</span><span class='o'>(</span>         <span class='c'># Specify column types</span>
        col1 <span class='o'>=</span> <span class='nf'>col_character</span><span class='o'>(</span><span class='o'>)</span>, <span class='c'># ..Note that we only need to specify columns </span>
        col2 <span class='o'>=</span> <span class='nf'>col_double</span><span class='o'>(</span><span class='o'>)</span>     <span class='c'># ..for which we need non-automatic typing</span>
        <span class='o'>)</span>
      <span class='o'>)</span>
    </code></pre>

    </div>

</div>

</div>

<br>

<div class="puzzle">

### Exercise 2 (Optional)

**Read this file!**

Try to read the following file into R, which is a modified and much smaller version of the bird dataset.

Make the function parse the "order" column as a factor, and the "year", "month", and "day" columns as whatever you think is sensible.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># Download and read the file:</span>
<span class='nv'>birds2_file_url</span> <span class='o'>&lt;-</span> <span class='s'>'https://raw.githubusercontent.com/biodash/biodash.github.io/master/assets/data/birds/backyard-birds_read-challenge.txt'</span>
<span class='nv'>birds2_file</span> <span class='o'>&lt;-</span> <span class='s'>'data/birds/backyard-birds_read-challenge.txt'</span>
<span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>birds2_file_url</span>, destfile <span class='o'>=</span> <span class='nv'>birds2_file</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># Your turn!</span>
<span class='nv'>birds2</span> <span class='o'>&lt;-</span> <span class='nv'>read_</span>    <span class='c'># Complete the command</span>
</code></pre>

</div>

<details>

<summary> Hints (click here) </summary> <br>

-   The file is saved as `.txt`, so the delimiter is not obvious -- first have a look at it (open it in RStudio, a text editor, or the terminal) to determine the delimiter. Then, use `read_delim()` with manual specification of the delimiter using the `delim` argument, or use a specialized convenience function.

-   Besides a leading line with no data, there is another problematic line further down. You will need both the `skip` and `comment` arguments to circumvent these.

-   Note that *readr* erroneously parses `month` as a character column if you don't manually specify its type.

-   Note that you can also use a succinct column type specification like `col_types = 'fc'`, which would parse, for a two-column file, the first column as a factor and the second as a character -- type e.g. `?read_tsv` for details in the help file.

</details>

<br>

<details>

<summary> Bare solution (click here) </summary> <br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># With succint column type specification:</span>
<span class='nv'>birds2</span> <span class='o'>&lt;-</span> <span class='nf'>read_csv</span><span class='o'>(</span>
  file <span class='o'>=</span> <span class='nv'>birds2_file</span>,
  skip <span class='o'>=</span> <span class='m'>1</span>,
  comment <span class='o'>=</span> <span class='s'>'$'</span>,
  col_types <span class='o'>=</span> <span class='s'>'fcdiii'</span>
  <span class='o'>)</span>

<span class='c'># With long column type specification:</span>
<span class='nv'>birds2</span> <span class='o'>&lt;-</span> <span class='nf'>read_csv</span><span class='o'>(</span>
  file <span class='o'>=</span> <span class='nv'>birds2_file</span>,
  skip <span class='o'>=</span> <span class='m'>1</span>,
  comment <span class='o'>=</span> <span class='s'>'$'</span>,
  col_types <span class='o'>=</span> <span class='nf'>cols</span><span class='o'>(</span>
    order <span class='o'>=</span> <span class='nf'>col_factor</span><span class='o'>(</span><span class='o'>)</span>,
    year <span class='o'>=</span>  <span class='nf'>col_integer</span><span class='o'>(</span><span class='o'>)</span>,
    month <span class='o'>=</span> <span class='nf'>col_integer</span><span class='o'>(</span><span class='o'>)</span>,
    day <span class='o'>=</span> <span class='nf'>col_integer</span><span class='o'>(</span><span class='o'>)</span>
    <span class='o'>)</span>
  <span class='o'>)</span>
</code></pre>

</div>

</details>

<br>

<details>

<summary> Solution with explanations (click here) </summary> <br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># With succinct column type specification:</span>
<span class='nv'>birds2</span> <span class='o'>&lt;-</span> <span class='nf'>read_csv</span><span class='o'>(</span>     <span class='c'># `read_csv()` because the file is comma-delimited</span>
  file <span class='o'>=</span> <span class='nv'>birds2_file</span>,
  skip <span class='o'>=</span> <span class='m'>1</span>,             <span class='c'># The first line is not part of the data frame</span>
  comment <span class='o'>=</span> <span class='s'>'$'</span>,        <span class='c'># Line 228 is a comment that starts with a `$`.</span>
  col_types <span class='o'>=</span> <span class='s'>'fcdiii'</span>  <span class='c'># 'f' for factor, 'c' for character,</span>
  <span class='o'>)</span>                     <span class='c'># ... 'd' for double (=numeric), 'i' for integer.</span>

<span class='c'># With long column type specification:</span>
<span class='nv'>birds2</span> <span class='o'>&lt;-</span> <span class='nf'>read_csv</span><span class='o'>(</span>
  file <span class='o'>=</span> <span class='nv'>birds2_file</span>,
  skip <span class='o'>=</span> <span class='m'>1</span>,
  comment <span class='o'>=</span> <span class='s'>'$'</span>,
  col_types <span class='o'>=</span> <span class='nf'>cols</span><span class='o'>(</span>        <span class='c'># Note that we can omit columns for which we</span>
    order <span class='o'>=</span> <span class='nf'>col_factor</span><span class='o'>(</span><span class='o'>)</span>,  <span class='c'># ... accept the automatic parsing,</span>
    year <span class='o'>=</span>  <span class='nf'>col_integer</span><span class='o'>(</span><span class='o'>)</span>, <span class='c'># ... when using the long specification. </span>
    month <span class='o'>=</span> <span class='nf'>col_integer</span><span class='o'>(</span><span class='o'>)</span>,
    day <span class='o'>=</span> <span class='nf'>col_integer</span><span class='o'>(</span><span class='o'>)</span>
    <span class='o'>)</span>
  <span class='o'>)</span>
</code></pre>

</div>

</details>

<br>

</div>

<br>

<div class="alert alert-note">

<div>

### Other options for reading tabular data

There are also functions in *base R* that read tabular data, such as [`read.table()`](https://rdrr.io/r/utils/read.table.html) and [`read.delim()`](https://rdrr.io/r/utils/read.table.html).

These are generally slower than the *readr* functions, and have less sensible default options to their arguments. Particularly relevant is how columns with characters (strings) are parsed -- until R 4.0, which was released earlier this year, base R's default behavior was to parse them as **factors**, which is generally not desirable[^2]. *readr* functions will never convert columns with strings to factors.

If speed is important, such as when reading in very large files (\~ 100s of MBs or larger), you should consider using the `fread()` function from the *data.table* package.

Finally, some examples of reading other types of files:

-   Read excel files directly using the *readxl* package.
-   Read Google Sheets directly from the web using the *googlesheets4* package.
-   Read non-tabular data using the base R [`readLines()`](https://rdrr.io/r/base/readLines.html) function.

</div>

</div>

<br> <br> <br> <br>

[^1]: As it is in some ways a dialect of R, the *tidyverse* can cause confusion ("tidy evaluation" in particular) and can sometimes make it seem like there is just more to learn -- because base R can't be fully ignored. Its rapid development has also meant that in some cases, new functions and approaches are being retired/soft-deprecated just a few years later.

[^2]: You can check which version of R you are running by typing [`sessionInfo()`](https://rdrr.io/r/utils/sessionInfo.html). You can also check directly how strings are read by default with [`default.stringsAsFactors()`](https://rdrr.io/r/base/data.frame.html). To avoid conversion to factors, specify `stringsAsFactors = FALSE` in your [`read.table()`](https://rdrr.io/r/utils/read.table.html) / [`read.delim()`](https://rdrr.io/r/utils/read.table.html) function call.

