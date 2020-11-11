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
rmd_hash: 545aa7bd568f706e

---

------------------------------------------------------------------------

<br>

Prep for this week
------------------

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

-   RStudio Projects

-   The Backyard Bird Count

-   If we have time: Reading in & exploring the bird data

<br>

------------------------------------------------------------------------

------------------------------------------------------------------------

Create an RStudio Project
-------------------------

Projects are an RStudio-specific concept that create a special file (`.Rproj`), primarily to designate a directory as the working directory for everything within it. We recommend creating exactly one separate Project for each research project with an R component -- and for things like Code Club.

<br>

<div class="alert alert-note">

<div>

**Why use Projects?**

In brief, Projects help you to organize your work and to make it more portable. More specifically:

-   They record which files (scripts, R Markdown) are open in RStudio, and will reopen all of those when you reopen the project. This becomes quite handy, say, when you work on three different projects, each of which uses a number of scripts.

-   An even more significant advantage is that Projects allow you to avoid manually setting your working directory, and to use *relative file paths* to refer to files within the project. This way, even if you move the project directory, or copy it to a different computer, the same paths will still work. This would not be the case if you used [`setwd()`](https://rdrr.io/r/base/getwd.html) which will generally require you to use an absolute path, e.g. [`setwd('C:/Users/Jane/Documents/')`](https://rdrr.io/r/base/getwd.html).

-   Finally, Projects encourage organizing research projects inside self-contained directories, rather than have files spread around your computer, which can save you a lot of headaches and increases reproducibility.

</div>

</div>

<br>

**Let's create an RStudio Project for Code Club:**

-   Open RStudio locally or [start an OSC RStudio Server session](/codeclub-setup/#osc-run-rstudio).

-   *If you're working locally*, create a directory wherever you like on your computer for all things Code Club. You can do this in R using [`dir.create()`](https://rdrr.io/r/base/files2.html), or outside of R.  
    (*If you're at OSC*, skip this step because you're automatically inside a Code Club-specific, personal directory.)

-   Click `File` (top menu bar) \> `New Project`, and then select `Existing Directory`.

    -   *If you're working locally*, select the Code Club directory that you created in the previous step.

    -   *If you're working at OSC*, keep the default choice "[`~`](https://rdrr.io/r/base/tilde.html)" (i.e., *home*), which is the directory you started in when entering the RStudio Server session.

-   You should now see the file ending in `.Rproj` in the RStudio `Files` tab in the lower right pane.

(To open an existing Project, use `File` \> `Open Project` inside RStudio, or click the `.Rproj` file in your file browser.)

<br>

------------------------------------------------------------------------

Orienting ourselves
-------------------

-   **Where are we?** Type in the console (bottom left):
    <div class="highlight">

    <pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/getwd.html'>getwd</a></span><span class='o'>(</span><span class='o'>)</span>    <span class='c'># short for "get working directory"</span>
    </code></pre>

    </div>

When a Project is open, the R working directory will always be the directory that contains the `.Rproj` file. This way, we can refer to all of our files in Code Club using relative paths starting from that directory, and have no need for [`setwd()`](https://rdrr.io/r/base/getwd.html).

-   **Create two new directories** -- one for this session, and one for a dataset that we will download shortly (and will be reusing across sessions):
    <div class="highlight">

    <pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># Dir for Code Club Session 1:</span>
    <span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>'S01'</span><span class='o'>)</span>

    <span class='c'># Dir for our bird data:</span>
    <span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>'data/birds/'</span>, recursive <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span> <span class='c'># The "recursive" argument lets us</span>
                                                <span class='c'># create two levels at once</span>
    </code></pre>

    </div>

To keep a record of what we are doing, and to easily modify and rerun earlier commands, we'll want to save our commands in a script and execute them from there, rather than typing our commands directly in the console.

-   **Open a new R** script using `File` (top menu bar) \> `New File` \> `R script`.  
    Save the script (`File` \> `Save`) as `S01.R` inside your `S01` directory.

-   Type a command to **load the *tidyverse*** on the first line of the script:

    <div class="highlight">

    <pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
    </code></pre>

    </div>

-   **Execute the line**, i.e. to send it to the console, by pressing `Ctrl Enter`.

<br>

------------------------------------------------------------------------

<div class="alert alert-note">

<div>

The Great Backyard Bird Count
-----------------------------

<br>

<div class="highlight">

<img src="GBBC_screenshot.png" width="90%" style="display: block; margin: auto;" />

</div>

<br>

The [Great Backyard Bird Count (GBBC)](https://gbbc.birdcount.org/) is an annual citizen science event where everyone is encouraged to to identify and count birds in their backyard -- or anywhere else -- for at least 15 minutes, and report their sightings online. Since 2013, it is a global event, but it has been done since 1998 in the US and Canada.

</div>

</div>

<br>

------------------------------------------------------------------------

Getting the bird data
---------------------

We downloaded a [GBBC dataset](https://www.gbif.org/dataset/82cb293c-f762-11e1-a439-00145eb45e9a) from the [Global Biodiversity Information Facility (GBIF)](https://www.gbif.org/). Because the file was 3.1 GB large, we selected only the records from Ohio and removed some uninformative columns. We put the resulting 36 MB file in our Github repo from which we'll download it now.

#### Download the data

We can download the dataset using the [`download.file()`](https://rdrr.io/r/utils/download.file.html) function:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>birds_file_url</span> <span class='o'>&lt;-</span> <span class='s'>'https://raw.githubusercontent.com/biodash/biodash.github.io/master/data/birds/backyard-birds_Ohio.tsv'</span>
<span class='nv'>birds_file</span> <span class='o'>&lt;-</span> <span class='s'>'data/birds/backyard-birds_Ohio.tsv'</span>
<span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>birds_file_url</span>, destfile <span class='o'>=</span> <span class='nv'>birds_file</span><span class='o'>)</span>
</code></pre>

</div>

#### Read the data

Now, let's read the file into R. The `.tsv` extension ("tab-separated values") tells us this is a plain text file in which columns are separated by tabs, so we will use a convenience function for exactly this type of file:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>birds</span> <span class='o'>&lt;-</span> <span class='nf'>read_tsv</span><span class='o'>(</span><span class='nv'>birds_file</span><span class='o'>)</span>
</code></pre>

</div>

<br>

<div class="alert alert-note">

<div>

**Reading tabular data into R**

Here, we used the `read_tsv()` function from the *readr* package, which is part of the core set of 8 *tidyverse* packages. The more general counterpart of this function is `read_delim()`, which allows you to specify the delimiter using an argument.

There are also functions in "base R" (i.e., they are loaded into R by default, and not part of the *tidyverse*) that read tabular data, such as [`read.table()`](https://rdrr.io/r/utils/read.table.html) and [`read.delim()`](https://rdrr.io/r/utils/read.table.html). These are generally a bit slower than the *readr* functions, and have perhaps less sensible default options to their arguments. Particularly relevant is how columns with characters (strings) are parsed -- until R 4.0, which was released earlier this year, base R's default behavior was to parse them as **factors**, which is generally not desirable. *readr* functions will never convert character columns to factors.

(You can check which version of R you are running by typing [`sessionInfo()`](https://rdrr.io/r/utils/sessionInfo.html). You can also check directly how characters are read by default with [`default.stringsAsFactors()`](https://rdrr.io/r/base/data.frame.html). To avoid conversion to factors, specify `stringsAsFactors = FALSE` in your [`read.table()`](https://rdrr.io/r/utils/read.table.html) / [`read.delim()`](https://rdrr.io/r/utils/read.table.html) function call.)

If speed is important, which it becomes when reading in very large files (\~ 100s of MBs or larger), you should consider using the `fread()` function from the *data.table* package.

</div>

</div>

<br>

------------------------------------------------------------------------

Exploring backyard birds
------------------------

**To get a feel for our data**, we can run the following functions:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>birds</span>          <span class='c'># Simply typing the name of an object will print it to screen</span>
<span class='nf'><a href='https://rdrr.io/r/base/print.html'>print</a></span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>)</span>   <span class='c'># Same as above, but explicitly calling print()    </span>
<span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>)</span>     <span class='c'># Short for "structure", for column-wise information </span>
<span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>)</span> <span class='c'># tidyverse version of str()</span>
<span class='nf'><a href='https://rdrr.io/r/utils/View.html'>View</a></span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>)</span>    <span class='c'># In RStudio, will open object in a table in an Rstudio tab.</span>
               <span class='c'># Clicking on the object in the `Environment` pane will do the same!</span>
</code></pre>

</div>

<div class="puzzle">

### Your turn: what's in the dataset?

-   Explore the output of the commands above, and try to understand what you see. What does a single row represent, and what is in each column?

-   In particular, pay attention to the classes and types of the different columns, which several of these functions print.

-   How many rows and how many columns does the dataset have?

-   Write down some simple questions you would like to answer using this dataset.

<details>

<summary> Hints (click here) </summary> <br>

-   Note that in R, `dbl` (for "double") and `num` (for "numeric") are both used, and almost interchangeably so, for floating point numbers. (Integers are a separate class that are simply called "integers" and abbreviated as `int`, but we have no integer columns in this dataset.)

-   `read_tsv()` parsed our date as a "date-time" (`dttm` or `POSIXct` for short), which contains both a date and a time (this is not a common format for most R users). In our case, it looks like the time is always "00:00:00" and thus doesn't provide any information.

</details>

<br>

<details>

<summary> Solutions (click here) </summary> <br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># Just printing the glimpse() output to show the number of rows and columns:</span>
<span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>)</span>

<span class='c'>## Rows: 311,441</span>
<span class='c'>## Columns: 10</span>
<span class='c'>## $ class            &lt;chr&gt; "Aves", "Aves", "Aves", "Aves", "Aves", "Aves", "Aves", "Aves", "Aves", "Aves", "Aves", "Aves", "Aves…</span>
<span class='c'>## $ order            &lt;chr&gt; "Passeriformes", "Passeriformes", "Passeriformes", "Passeriformes", "Passeriformes", "Passeriformes",…</span>
<span class='c'>## $ family           &lt;chr&gt; "Corvidae", "Corvidae", "Corvidae", "Corvidae", "Corvidae", "Corvidae", "Corvidae", "Corvidae", "Corv…</span>
<span class='c'>## $ genus            &lt;chr&gt; "Cyanocitta", "Cyanocitta", "Cyanocitta", "Cyanocitta", "Cyanocitta", "Cyanocitta", "Cyanocitta", "Cy…</span>
<span class='c'>## $ species          &lt;chr&gt; "Cyanocitta cristata", "Cyanocitta cristata", "Cyanocitta cristata", "Cyanocitta cristata", "Cyanocit…</span>
<span class='c'>## $ locality         &lt;chr&gt; "44805 Ashland", "45244 Cincinnati", "44132 Euclid", "45242 Cincinnati", "45246 Cincinnati", "44484 W…</span>
<span class='c'>## $ stateProvince    &lt;chr&gt; "Ohio", "Ohio", "Ohio", "Ohio", "Ohio", "Ohio", "Ohio", "Ohio", "Ohio", "Ohio", "Ohio", "Ohio", "Ohio…</span>
<span class='c'>## $ decimalLatitude  &lt;dbl&gt; 40.86166, 39.10666, 41.60768, 39.24236, 39.28207, 41.23180, 41.38730, 41.31395, 41.70916, 39.96116, 3…</span>
<span class='c'>## $ decimalLongitude &lt;dbl&gt; -82.31558, -84.32972, -81.50085, -84.35545, -84.46880, -80.75410, -81.31230, -81.68515, -83.70952, -8…</span>
<span class='c'>## $ eventDate        &lt;dttm&gt; 2007-02-16, 2007-02-17, 2007-02-17, 2007-02-19, 2007-02-18, 2007-02-17, 2008-02-16, 2008-02-17, 2008…</span>
</code></pre>

</div>

-   The dataset has 311,441 rows, and 10 columns.

</details>

</div>

<br>

<div class="alert alert-note">

<div>

**Types of data frames**

`data.frame` is R's basic object type that deals with tabular data wherein each column can contain a different type of data. When you use base R functions to read in data, you will get a `data.frame` object. However, when you use *readr*, you will get the *tidyverse*'s **subclass** of `data.frame`: colloquially called a `tibble` and formally a `tbl_df`.

`tibbles` and "regular" `data.frames` can generally be used interchangeably, but some default behavior does differ. Most strikingly, they are printed to screen differently.

To tell what kind of data frame your are dealing with, and to tell the class of any R object, use the [`class()`](https://rdrr.io/r/base/class.html) function, e.g. [`class(birds)`](https://rdrr.io/r/base/class.html).

<div class="puzzle">

***Optional: comparing data frame types***

Read in the bird data as a `data.frame` and compare overviews of the `tibble` and the `data.frame`.

-   What are some differences in how they are displayed and behave? In particular, compare what happens when you use [`print()`](https://rdrr.io/r/base/print.html) (or simply type the object name).

-   Were all the columns parsed in the same way -- i.e., did the `tibble` and the `data.frame` assign the same class to each column?

-   How could you switch (convert) directly between `tibble` and `data.frame` objects?

</div>

<details>
<summary> Hints (click here) </summary> <br>
<ul>
<li>
Use the <code>read.table()</code> function, and note that you will need to specify non-default options for the arguments <code>sep</code> and <code>header</code>. Type <code>?read.table</code> for details.
</li>
<li>
Have a close look at the class for the "eventDate" column. Note that <code>POSIXct</code> is the formal date-time class, while tibbles/tidyverse will refer to these as <code>ddtm</code>.
</li>
<li>
Use the <code>as.data.frame()</code> and <code>as\_tibble()</code> functions to change the object type.
</li>
</ul>
</details>

<br>

<details>

<summary> Solutions (click here) </summary> <br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># Read the dataset as data.frame using read.table():</span>
<span class='nv'>birds_df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/utils/read.table.html'>read.table</a></span><span class='o'>(</span><span class='nv'>infile</span>, sep <span class='o'>=</span> <span class='s'>'\t'</span>, header <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>

<span class='c'># Class of the eventDate column -- read.table() did not parse the date as a date!</span>
<span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>$</span><span class='nv'>eventDate</span><span class='o'>)</span>
<span class='c'># [1] "POSIXct" "POSIXt" </span>
<span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span><span class='o'>(</span><span class='nv'>birds_df</span><span class='o'>$</span><span class='nv'>eventDate</span><span class='o'>)</span>
<span class='c'># [1] "character"</span>

<span class='c'># Convert between a data.frame and a tibble:</span>
<span class='nv'>birds_df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/as.data.frame.html'>as.data.frame</a></span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>)</span>
<span class='nv'>birds_tibble</span> <span class='o'>&lt;-</span> <span class='nf'>as_tibble</span><span class='o'>(</span><span class='nv'>birds_df</span><span class='o'>)</span>
</code></pre>

</div>

</details>

</div>

</div>

<br>

<div class="alert alert-note">

<div>

**Pro-tip for data frame summaries**

Use the `skim` function from the *skimr* package:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='nv'>skimr</span><span class='o'>)</span>
<span class='nf'>skim</span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>)</span>
</code></pre>

</div>

</div>

</div>

<br> <br> <br>

