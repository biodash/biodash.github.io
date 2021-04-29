---
title: "Cleaning up variables names, and other wrangling"
subtitle: "On your marks, get set, bake!"
summary: "During this  session of Code Club, we will be learning to clean up variable names, combine and separate columns, and extract data with regular expressions."  
authors: [jessica-cooperstone]
date: "2021-04-29"
lastmod: "2021-04-29"
output: hugodown::md_document
toc: true

image: 
  caption: "Artwork by @allison_horst"
  focal_point: ""
  preview_only: false

rmd_hash: 2e5ee27079774e7c

---

<br> <br> <br>

------------------------------------------------------------------------

Prep homework
-------------

### Basic computer setup

-   If you didn't already do this, please follow the [Code Club Computer Setup](/codeclub-setup/04_ggplot2/) instructions, which also has pointers for if you're new to R or RStudio.

-   If you're able to do so, please open RStudio a bit before Code Club starts -- and in case you run into issues, please join the Zoom call early and we'll help you troubleshoot.

<br>

------------------------------------------------------------------------

Getting Started
---------------

### RMarkdown for today's session

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># directory for Code Club Session 20:</span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>"S20"</span><span class='o'>)</span>

<span class='c'># directory for our RMarkdown</span>
<span class='c'># ("recursive" to create two levels at once.)</span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>"S20/Rmd/"</span><span class='o'>)</span>

<span class='c'># save the url location for today's script</span>
<span class='nv'>todays_Rmd</span> <span class='o'>&lt;-</span> 
  <span class='s'>'https://raw.githubusercontent.com/biodash/biodash.github.io/master/content/codeclub/20_cleaning-up/CleaningUp.Rmd'</span>

<span class='c'># indicate the name of the new script file</span>
<span class='nv'>Session20_Rmd</span> <span class='o'>&lt;-</span> <span class='s'>"S20/Rmd/CleaningUp.Rmd"</span>

<span class='c'># go get that file! </span>
<span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>todays_Rmd</span>,
              destfile <span class='o'>=</span> <span class='nv'>Session20_Rmd</span><span class='o'>)</span></code></pre>

</div>

<br>

------------------------------------------------------------------------

1 - Using regexs for wrangling
------------------------------

<p align="center">
<img src=bakers_5.png width="95%" alt="cute little monsters making cupcakes and enjoying R">
</p>

Artwork by [Allison Horst](https://github.com/allisonhorst/stats-illustrations)

Now that we have gone through a mini-series on regular expressions, with the [basics](https://biodash.github.io/codeclub/17_regex/), some [next level helpers](https://biodash.github.io/codeclub/18_regex2/), and [using tidytext to make word clouds](https://biodash.github.io/codeclub/19_wordclouds/), I thought I'd talk today about some applications of this information to cleaning up your data.

To do this, we are going to practice with the [`palmerpenguins`](https://allisonhorst.github.io/palmerpenguins/) dataset, and get back to the [`bakeoff`](https://bakeoff.netlify.app/) for our practice exercises.

</div>
</div>

<br>

------------------------------------------------------------------------

2 - Accessing our data
----------------------

-   You can do this locally, or at OSC. You can find instructions if you are having trouble [here](/codeclub-setup/).

First load your libraries. We will be using `stringr` and `tidyr` but those are both part of core `tidyverse`. We are also using a new package today called `janitor` which helps you "clean up" your data.

If you don't have the package `janitor`, please install it.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"janitor"</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/sfirke/janitor'>janitor</a></span><span class='o'>)</span> <span class='c'># for cleaning up column names</span>

<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/'>palmerpenguins</a></span><span class='o'>)</span> <span class='c'># for penguins data</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://bakeoff.netlify.com'>bakeoff</a></span><span class='o'>)</span> <span class='c'># for bakeoff data</span></code></pre>

</div>

Then we will use the package `palmerpenguins` and the dataset `penguins_raw`, which has a bit more info than `penguins`, which we have used previously.

<p align="center">
<img src=palmerpenguins.png width="50%" alt="hex sticker for the palmer penguins package, including 3 really cute penguins">
</p>

Artwork by [Allison Horst](https://allisonhorst.github.io/palmerpenguins/articles/art.html)

<br>

------------------------------------------------------------------------

3 - Variable names
------------------

There are many instances where you may have variables names and/or sample names that are messy. For example, variable names that include characters like white spaces, special characters like symbols, or begin with a number are going to give you problems with some R coding. I'll say that you *can* have these non-standard variable names, but occasionally they will give you a big headache and so I'd recommend to just avoid them.

R variable "rules":

-   can contain letters, numbers, underscores (`_`) and periods (`.`)
-   cannot start with a number or underscore
-   shouldn't be a "reserved" word, like if, else, function, TRUE, FALSE etc. (if you want to see them all, execute [`?reserved`](https://rdrr.io/r/base/Reserved.html) in your console)

You can read about the [tidyverse style guide](https://style.tidyverse.org/syntax.html) if you want to learn more.

Lets look at the variable names in `penguins_raw`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>penguins_raw</span><span class='o'>)</span>
<span class='c'>#&gt; Rows: 344</span>
<span class='c'>#&gt; Columns: 17</span>
<span class='c'>#&gt; $ studyName             <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "PAL0708", "PAL0708", "PAL0708", "PAL0708", "PAL…</span></span>
<span class='c'>#&gt; $ `Sample Number`       <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 1…</span></span>
<span class='c'>#&gt; $ Species               <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Adelie Penguin (Pygoscelis adeliae)", "Adelie P…</span></span>
<span class='c'>#&gt; $ Region                <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Anvers", "Anvers", "Anvers", "Anvers", "Anvers"…</span></span>
<span class='c'>#&gt; $ Island                <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Torgersen", "Torgersen", "Torgersen", "Torgerse…</span></span>
<span class='c'>#&gt; $ Stage                 <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Adult, 1 Egg Stage", "Adult, 1 Egg Stage", "Adu…</span></span>
<span class='c'>#&gt; $ `Individual ID`       <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "N1A1", "N1A2", "N2A1", "N2A2", "N3A1", "N3A2", …</span></span>
<span class='c'>#&gt; $ `Clutch Completion`   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Yes", "Yes", "Yes", "Yes", "Yes", "Yes", "No", …</span></span>
<span class='c'>#&gt; $ `Date Egg`            <span style='color: #555555;font-style: italic;'>&lt;date&gt;</span><span> 2007-11-11, 2007-11-11, 2007-11-16, 2007-11-16,…</span></span>
<span class='c'>#&gt; $ `Culmen Length (mm)`  <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 39.1, 39.5, 40.3, NA, 36.7, 39.3, 38.9, 39.2, 34…</span></span>
<span class='c'>#&gt; $ `Culmen Depth (mm)`   <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 18.7, 17.4, 18.0, NA, 19.3, 20.6, 17.8, 19.6, 18…</span></span>
<span class='c'>#&gt; $ `Flipper Length (mm)` <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 181, 186, 195, NA, 193, 190, 181, 195, 193, 190,…</span></span>
<span class='c'>#&gt; $ `Body Mass (g)`       <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 3750, 3800, 3250, NA, 3450, 3650, 3625, 4675, 34…</span></span>
<span class='c'>#&gt; $ Sex                   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "MALE", "FEMALE", "FEMALE", NA, "FEMALE", "MALE"…</span></span>
<span class='c'>#&gt; $ `Delta 15 N (o/oo)`   <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, 8.94956, 8.36821, NA, 8.76651, 8.66496, 9.18…</span></span>
<span class='c'>#&gt; $ `Delta 13 C (o/oo)`   <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, -24.69454, -25.33302, NA, -25.32426, -25.298…</span></span>
<span class='c'>#&gt; $ Comments              <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Not enough blood for isotopes.", NA, NA, "Adult…</span></span></code></pre>

</div>

What you can see is that there are variable names here that don't comply with the "rules" I just indicated. How can that be?! You can see for the variable `Sample Number` that it is surrounded by backticks. This is how R know that this is a variable name.

Okay, so who cares? If you want to call that particular variable, you will have to put it in backticks. For example:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'># this doesn't work
penguins_raw %>%
  select(Sample Number)</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># this works but is clunky</span>
<span class='nv'>penguins_raw</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>`Sample Number`</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 344 x 1</span></span>
<span class='c'>#&gt;    `Sample Number`</span>
<span class='c'>#&gt;              <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span>               1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span>               2</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span>               3</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span>               4</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span>               5</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span>               6</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span>               7</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span>               8</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span>               9</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span>              10</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 334 more rows</span></span></code></pre>

</div>

And, this is using `tidyverse` functions - there will be other situations where you will get non-solvable errors because of your variable names.

<br>

**tl;dr just make your variable names R compliant, there are lots of other harder things you're going to be doing with coding, so just make this easier for yourself.**

<br>

### Using `clean_names()`

<p align="center">
<img src=janitor_clean_names.png width="95%" alt="cute illustration of the function clean_names, with a little beaker feeding messy data into something that looks like a planar, and better column names coming out the other side">
</p>

Artwork by [Allison Horst](https://github.com/allisonhorst/stats-illustrations)

You may be thinking now, okay but what happens if someone else gives me data that has unclean variable names?

Don't worry too much, you can easily fix it. My favorite, and the simplest way to do this is using the package `janitor`, and the function [`clean_names()`](https://www.rdocumentation.org/packages/janitor/versions/1.2.0/topics/clean_names). Certainly you could clean your variable names manually, but why? This is really easy.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_clean</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/janitor/man/clean_names.html'>clean_names</a></span><span class='o'>(</span><span class='nv'>penguins_raw</span><span class='o'>)</span>

<span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>penguins_clean</span><span class='o'>)</span>  
<span class='c'>#&gt; Rows: 344</span>
<span class='c'>#&gt; Columns: 17</span>
<span class='c'>#&gt; $ study_name        <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "PAL0708", "PAL0708", "PAL0708", "PAL0708", "PAL0708…</span></span>
<span class='c'>#&gt; $ sample_number     <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 1…</span></span>
<span class='c'>#&gt; $ species           <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Adelie Penguin (Pygoscelis adeliae)", "Adelie Pengu…</span></span>
<span class='c'>#&gt; $ region            <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Anvers", "Anvers", "Anvers", "Anvers", "Anvers", "A…</span></span>
<span class='c'>#&gt; $ island            <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Torgersen", "Torgersen", "Torgersen", "Torgersen", …</span></span>
<span class='c'>#&gt; $ stage             <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Adult, 1 Egg Stage", "Adult, 1 Egg Stage", "Adult, …</span></span>
<span class='c'>#&gt; $ individual_id     <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "N1A1", "N1A2", "N2A1", "N2A2", "N3A1", "N3A2", "N4A…</span></span>
<span class='c'>#&gt; $ clutch_completion <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Yes", "Yes", "Yes", "Yes", "Yes", "Yes", "No", "No"…</span></span>
<span class='c'>#&gt; $ date_egg          <span style='color: #555555;font-style: italic;'>&lt;date&gt;</span><span> 2007-11-11, 2007-11-11, 2007-11-16, 2007-11-16, 200…</span></span>
<span class='c'>#&gt; $ culmen_length_mm  <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 39.1, 39.5, 40.3, NA, 36.7, 39.3, 38.9, 39.2, 34.1, …</span></span>
<span class='c'>#&gt; $ culmen_depth_mm   <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 18.7, 17.4, 18.0, NA, 19.3, 20.6, 17.8, 19.6, 18.1, …</span></span>
<span class='c'>#&gt; $ flipper_length_mm <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 181, 186, 195, NA, 193, 190, 181, 195, 193, 190, 186…</span></span>
<span class='c'>#&gt; $ body_mass_g       <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 3750, 3800, 3250, NA, 3450, 3650, 3625, 4675, 3475, …</span></span>
<span class='c'>#&gt; $ sex               <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "MALE", "FEMALE", "FEMALE", NA, "FEMALE", "MALE", "F…</span></span>
<span class='c'>#&gt; $ delta_15_n_o_oo   <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, 8.94956, 8.36821, NA, 8.76651, 8.66496, 9.18718,…</span></span>
<span class='c'>#&gt; $ delta_13_c_o_oo   <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, -24.69454, -25.33302, NA, -25.32426, -25.29805, …</span></span>
<span class='c'>#&gt; $ comments          <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Not enough blood for isotopes.", NA, NA, "Adult not…</span></span></code></pre>

</div>

You can see that `Sample Number` became `sample_number`, `Culmen Length (mm)` became `culmen_length_mm`.

The default is to parse with "snake" case, which would look like snake\_case. You could also set the argument `case` to:

-   `"lower_camel"` or `"small_camel"` to get lowerCamel
-   `"upper_camel"` or `"big_camel"` to get UpperCamel
-   `"screaming_snake"` or `"all_caps"` to get SCREAMING\_SNAKE (stop yelling please)
-   `"lower_upper"` to get lowerUPPER (I don't know why you'd want this)
-   `"upper_lower"` to get UPPERlower (I also don't know why you'd want this)

<p align="center">
<img src=coding_cases.png width="95%" alt="an illustration showing a camel, and the differences between camel, kebab, snake, and other useful cases">
</p>

Artwork by [Allison Horst](https://github.com/allisonhorst/stats-illustrations)

<br>

------------------------------------------------------------------------

4 - Unite character columns
---------------------------

There will be times when you'd like to take a variable, and combine it with another variable. For example, you might want a column called `region_island` which contains a combination of the `region` and `island` that each penguin is from. We can do this with the function [`unite()`](https://tidyr.tidyverse.org/reference/unite.html). The function `unite()` allows you to paste together multiple columns to become one column.

The arguments to `unite` work like this:

`unite(data, col, ..., sep = "_", remove = TRUE, na.rm = FALSE)`

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_clean_unite</span> <span class='o'>&lt;-</span> <span class='nv'>penguins_clean</span> <span class='o'>%&gt;%</span>
  <span class='nf'>unite</span><span class='o'>(</span>col <span class='o'>=</span> <span class='s'>"region_island"</span>, 
        <span class='nv'>region</span><span class='o'>:</span><span class='nv'>island</span>, <span class='c'># indicate the columns to unite</span>
        remove <span class='o'>=</span> <span class='kc'>FALSE</span><span class='o'>)</span> <span class='c'># don't remove region and island</span></code></pre>

</div>

Did it work?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>penguins_clean_unite</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 18</span></span>
<span class='c'>#&gt;   study_name sample_number species         region_island  region island stage   </span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>              </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>           </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>          </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> PAL0708                1 Adelie Penguin… Anvers_Torger… Anvers Torge… Adult, …</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> PAL0708                2 Adelie Penguin… Anvers_Torger… Anvers Torge… Adult, …</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> PAL0708                3 Adelie Penguin… Anvers_Torger… Anvers Torge… Adult, …</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> PAL0708                4 Adelie Penguin… Anvers_Torger… Anvers Torge… Adult, …</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> PAL0708                5 Adelie Penguin… Anvers_Torger… Anvers Torge… Adult, …</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> PAL0708                6 Adelie Penguin… Anvers_Torger… Anvers Torge… Adult, …</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 11 more variables: individual_id &lt;chr&gt;, clutch_completion &lt;chr&gt;,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   date_egg &lt;date&gt;, culmen_length_mm &lt;dbl&gt;, culmen_depth_mm &lt;dbl&gt;,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   flipper_length_mm &lt;dbl&gt;, body_mass_g &lt;dbl&gt;, sex &lt;chr&gt;,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   delta_15_n_o_oo &lt;dbl&gt;, delta_13_c_o_oo &lt;dbl&gt;, comments &lt;chr&gt;</span></span></code></pre>

</div>

This is a silly example since there is only one region, but I think you can see how this function is used.

<br>

------------------------------------------------------------------------

5 - Separate character columns
------------------------------

There will be times that you have a column that has two variables embedded within it, and you will want to separate or parse the column to become two separate columns. You can do this with the function [`separate()`](https://tidyr.tidyverse.org/reference/separate.html).

The arguments to separate look like this:

`separate(data, col, into, sep = "yourregex", remove = TRUE, extra = "warn", fill = "warn")`

Let's look at the column `stage`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_clean</span><span class='o'>$</span><span class='nv'>stage</span><span class='o'>[</span><span class='m'>1</span><span class='o'>:</span><span class='m'>5</span><span class='o'>]</span>
<span class='c'>#&gt; [1] "Adult, 1 Egg Stage" "Adult, 1 Egg Stage" "Adult, 1 Egg Stage"</span>
<span class='c'>#&gt; [4] "Adult, 1 Egg Stage" "Adult, 1 Egg Stage"</span></code></pre>

</div>

We might want to separate the column `stage` into `age` and `egg_stage`. We can do this with `separate()`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_clean_stage</span> <span class='o'>&lt;-</span> <span class='nv'>penguins_clean</span> <span class='o'>%&gt;%</span>
  <span class='nf'>separate</span><span class='o'>(</span>col <span class='o'>=</span> <span class='nv'>stage</span>,
           into <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"age"</span>, <span class='s'>"egg_stage"</span><span class='o'>)</span>,
           sep <span class='o'>=</span> <span class='s'>","</span>, <span class='c'># the comma is the separator</span>
           remove <span class='o'>=</span> <span class='kc'>FALSE</span><span class='o'>)</span> </code></pre>

</div>

Did it work?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_clean_stage</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>stage</span>, <span class='nv'>age</span>, <span class='nv'>egg_stage</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 3</span></span>
<span class='c'>#&gt;   stage              age   egg_stage     </span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>              </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>         </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Adult, 1 Egg Stage Adult </span><span style='color: #555555;'>"</span><span> 1 Egg Stage</span><span style='color: #555555;'>"</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Adult, 1 Egg Stage Adult </span><span style='color: #555555;'>"</span><span> 1 Egg Stage</span><span style='color: #555555;'>"</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Adult, 1 Egg Stage Adult </span><span style='color: #555555;'>"</span><span> 1 Egg Stage</span><span style='color: #555555;'>"</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Adult, 1 Egg Stage Adult </span><span style='color: #555555;'>"</span><span> 1 Egg Stage</span><span style='color: #555555;'>"</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> Adult, 1 Egg Stage Adult </span><span style='color: #555555;'>"</span><span> 1 Egg Stage</span><span style='color: #555555;'>"</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> Adult, 1 Egg Stage Adult </span><span style='color: #555555;'>"</span><span> 1 Egg Stage</span><span style='color: #555555;'>"</span></span></code></pre>

</div>

A different type of example:

The column `individual_id` has two parts: the letter N and then a number, and the letter A and then a number. Let's split this column into two columns, one called `id_n` that contains the number after the N, and a second called `id_a` that contains the number after the A.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_clean_fixID</span> <span class='o'>&lt;-</span> <span class='nv'>penguins_clean</span> <span class='o'>%&gt;%</span>
  <span class='nf'>separate</span><span class='o'>(</span>col <span class='o'>=</span> <span class='nv'>individual_id</span>,
           into <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"id_n"</span>, <span class='s'>"id_a"</span><span class='o'>)</span>,
           sep <span class='o'>=</span> <span class='s'>"A"</span>, <span class='c'># can also use regex "[A]"</span>
           remove <span class='o'>=</span> <span class='kc'>FALSE</span><span class='o'>)</span> </code></pre>

</div>

Did it work?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_clean_fixID</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>individual_id</span>, <span class='nv'>id_n</span>, <span class='nv'>id_a</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 3</span></span>
<span class='c'>#&gt;   individual_id id_n  id_a </span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>         </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> N1A1          N1    1    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> N1A2          N1    2    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> N2A1          N2    1    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> N2A2          N2    2    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> N3A1          N3    1    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> N3A2          N3    2</span></span></code></pre>

</div>

This worked to separate out the A, but the N is still linked with `id_n`. We can use separate again to remove it. In this case, we don't want to keep the column that will include only Ns, so we will indicate that in the `into` argument, and we set `remote = TRUE` (which actually you can omit because it is the default).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_clean_fixID</span> <span class='o'>&lt;-</span> <span class='nv'>penguins_clean_fixID</span> <span class='o'>%&gt;%</span>
  <span class='nf'>separate</span><span class='o'>(</span>col <span class='o'>=</span> <span class='nv'>id_n</span>,
           into <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='kc'>NA</span>, <span class='s'>"id_n"</span><span class='o'>)</span>, <span class='c'># the NA omits the variable</span>
           sep <span class='o'>=</span> <span class='s'>"N"</span>, <span class='c'># can also use regex "[N]"</span>
           remove <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span> <span class='c'># optional, since this is the default </span></code></pre>

</div>

Did it work?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_clean_fixID</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>individual_id</span>, <span class='nv'>id_n</span>, <span class='nv'>id_a</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 3</span></span>
<span class='c'>#&gt;   individual_id id_n  id_a </span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>         </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> N1A1          1     1    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> N1A2          1     2    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> N2A1          2     1    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> N2A2          2     2    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> N3A1          3     1    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> N3A2          3     2</span></span></code></pre>

</div>

6 - Extract character columns
-----------------------------

We can use [`extract()`](https://tidyr.tidyverse.org/reference/extract.html) to set up regular expressions to allow the separation of our variable `species` into exactly what we want.

We will use str\_view to figure out a regex that will work for us.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># indicate our string</span>
<span class='nv'>string</span> <span class='o'>&lt;-</span> <span class='s'>"Adelie Penguin (Pygoscelis adeliae)"</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># to get Adelie Penguin</span>
<span class='nf'>str_view</span><span class='o'>(</span><span class='nv'>string</span>, <span class='s'>"[[:alnum:]]+\\s[[:alnum:]]+"</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

<img src="adelie_penguin_1.png" width="700px" style="display: block; margin: auto auto auto 0;" />

</div>

-   `[[:alnum:]]` gives you anything alphanumeric.  
-   the [`+`](https://rdrr.io/r/base/Arithmetic.html) indicates to match alphanumeric at least 1 time
-   `\\s` indicates a space

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># to get Pygoscelis adeliae</span>
<span class='nf'>str_view</span><span class='o'>(</span><span class='nv'>string</span>, <span class='s'>"(?&lt;=\\()[[:alnum:]]+\\s[[:alnum:]]+"</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

<img src="pygoscelis_adeliae_2.png" width="700px" style="display: block; margin: auto auto auto 0;" />

</div>

-   `(?<=)` is called the positive lookbehind, and has this general structure `(?<=B)A` which can be read like "find exprssion A which is preceeded by expression B." In our example, expression B is a parentheses `(`. But there is some additional complexity here because parentheses have their own meanings in R, so you need to use the `\\` to escape them. The whole expression for this part of our regex is `(?<=\\()`.
-   `[[:alnum:]]` gives you anything alphanumeric.  
-   the [`+`](https://rdrr.io/r/base/Arithmetic.html) indicates to match alphanumeric at least 1 time
-   `\\s` indicates a space

Ok our regexs work as desired! Now we can incorporate them into `extract()`. Here I am using `.*?` to indicate the separator, as our separator is `(`. If you had a simpler separator, this would look simpler.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_clean_extract</span> <span class='o'>&lt;-</span> <span class='nv'>penguins_clean</span> <span class='o'>%&gt;%</span>
  <span class='nf'>extract</span><span class='o'>(</span>col <span class='o'>=</span> <span class='nv'>species</span>,
          into <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"common_name"</span>, <span class='s'>"genus_species"</span><span class='o'>)</span>,
          regex <span class='o'>=</span> <span class='s'>"([[:alnum:]]+\\s[[:alnum:]]+).*?((?&lt;=\\()[[:alnum:]]+\\s[[:alnum:]]+)"</span>, 
          remove <span class='o'>=</span> <span class='kc'>FALSE</span><span class='o'>)</span> </code></pre>

</div>

Did it work?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>penguins_clean_extract</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>species</span>, <span class='nv'>common_name</span>, <span class='nv'>genus_species</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 3</span></span>
<span class='c'>#&gt;   species                             common_name    genus_species     </span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                               </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>          </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>             </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Adelie Penguin (Pygoscelis adeliae) Adelie Penguin Pygoscelis adeliae</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Adelie Penguin (Pygoscelis adeliae) Adelie Penguin Pygoscelis adeliae</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Adelie Penguin (Pygoscelis adeliae) Adelie Penguin Pygoscelis adeliae</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Adelie Penguin (Pygoscelis adeliae) Adelie Penguin Pygoscelis adeliae</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> Adelie Penguin (Pygoscelis adeliae) Adelie Penguin Pygoscelis adeliae</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> Adelie Penguin (Pygoscelis adeliae) Adelie Penguin Pygoscelis adeliae</span></span></code></pre>

</div>

Voila!

<br>

------------------------------------------------------------------------

Exercises
---------

We will be doing our exercises today with a couple of datasets from the `bakeoff` package.

<p align="center">
<img src=mel_and_sue.gif width="95%" alt="mel and sue from GBBO are super excited about jaffa cakes">
</p>

<br>

------------------------------------------------------------------------

### Exercise 1

<div class="puzzle">

<div>

Using the dataset `bakers`, combine `bakers_last` with `bakers_first` to create a new column `bakers_last_first` which is indicated like this: Lastname, Firstname.

<details>

<summary> Hints (click here) </summary>

Use [`head()`](https://rdrr.io/r/utils/head.html) or `glimpse()` to see the structure of this data. Use `unite()` to combine columns. Don't forget to indicate the correct `sep` <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>bakers</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 8</span></span>
<span class='c'>#&gt;   series baker_full   baker    age occupation   hometown  baker_last baker_first</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>        </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>        </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>      </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>      </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> 1      </span><span style='color: #555555;'>"</span><span>Annetha Mi… Annet…    30 Midwife      Essex     Mills      Annetha    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> 1      </span><span style='color: #555555;'>"</span><span>David Cham… David     31 Entrepreneur Milton K… Chambers   David      </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> 1      </span><span style='color: #555555;'>"</span><span>Edward \"E… Edd       24 Debt collec… Bradford  Kimber     Edward     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> 1      </span><span style='color: #555555;'>"</span><span>Jasminder … Jasmi…    45 Assistant C… Birmingh… Randhawa   Jasminder  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> 1      </span><span style='color: #555555;'>"</span><span>Jonathan S… Jonat…    25 Research An… St Albans Shepherd   Jonathan   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> 1      </span><span style='color: #555555;'>"</span><span>Lea Harris</span><span style='color: #555555;'>"</span><span> Lea       51 Retired      Midlothi… Harris     Lea</span></span>

<span class='nv'>bakers_2</span> <span class='o'>&lt;-</span> <span class='nv'>bakers</span> <span class='o'>%&gt;%</span>
  <span class='nf'>unite</span><span class='o'>(</span>col <span class='o'>=</span> <span class='s'>"bakers_last_first"</span>,
        <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='nv'>baker_last</span>, <span class='nv'>baker_first</span><span class='o'>)</span>,
        sep <span class='o'>=</span> <span class='s'>", "</span><span class='o'>)</span>

<span class='c'># did it work?</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>bakers_2</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 7</span></span>
<span class='c'>#&gt;   series baker_full    baker    age occupation       hometown   bakers_last_fir…</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>         </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>            </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>      </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>           </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> 1      </span><span style='color: #555555;'>"</span><span>Annetha Mil… Annet…    30 Midwife          Essex      Mills, Annetha  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> 1      </span><span style='color: #555555;'>"</span><span>David Chamb… David     31 Entrepreneur     Milton Ke… Chambers, David </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> 1      </span><span style='color: #555555;'>"</span><span>Edward \"Ed… Edd       24 Debt collector … Bradford   Kimber, Edward  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> 1      </span><span style='color: #555555;'>"</span><span>Jasminder R… Jasmi…    45 Assistant Credi… Birmingham Randhawa, Jasmi…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> 1      </span><span style='color: #555555;'>"</span><span>Jonathan Sh… Jonat…    25 Research Analyst St Albans  Shepherd, Jonat…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> 1      </span><span style='color: #555555;'>"</span><span>Lea Harris</span><span style='color: #555555;'>"</span><span>  Lea       51 Retired          Midlothia… Harris, Lea</span></span></code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### Exercise 2

<div class="puzzle">

<div>

Using the dataset `bakers`, convert the column `hometown` to two columns, where whatever comes before the comma is in a column called `city` and whatever comes after is in a column called `locale`.

<details>

<summary> Hints (click here) </summary>

Try using `separate()`. <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>bakers</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 8</span></span>
<span class='c'>#&gt;   series baker_full   baker    age occupation   hometown  baker_last baker_first</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>        </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>        </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>      </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>      </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> 1      </span><span style='color: #555555;'>"</span><span>Annetha Mi… Annet…    30 Midwife      Essex     Mills      Annetha    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> 1      </span><span style='color: #555555;'>"</span><span>David Cham… David     31 Entrepreneur Milton K… Chambers   David      </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> 1      </span><span style='color: #555555;'>"</span><span>Edward \"E… Edd       24 Debt collec… Bradford  Kimber     Edward     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> 1      </span><span style='color: #555555;'>"</span><span>Jasminder … Jasmi…    45 Assistant C… Birmingh… Randhawa   Jasminder  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> 1      </span><span style='color: #555555;'>"</span><span>Jonathan S… Jonat…    25 Research An… St Albans Shepherd   Jonathan   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> 1      </span><span style='color: #555555;'>"</span><span>Lea Harris</span><span style='color: #555555;'>"</span><span> Lea       51 Retired      Midlothi… Harris     Lea</span></span>

<span class='nv'>bakers_hometown</span> <span class='o'>&lt;-</span> <span class='nv'>bakers</span> <span class='o'>%&gt;%</span>
  <span class='nf'>separate</span><span class='o'>(</span>col <span class='o'>=</span> <span class='nv'>hometown</span>,
           into <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"city"</span>, <span class='s'>"locale"</span><span class='o'>)</span>,
           sep <span class='o'>=</span> <span class='s'>", "</span><span class='o'>)</span>
<span class='c'>#&gt; Warning: Expected 2 pieces. Additional pieces discarded in 1 rows [71].</span>
<span class='c'>#&gt; Warning: Expected 2 pieces. Missing pieces filled with `NA` in 65 rows [1, 2, 3, 4, 5, 7, 8, 11, 12, 15, 19, 20, 23, 25, 27, 28, 31, 34, 38, 41, ...].</span>

<span class='c'># did it work?</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>bakers_hometown</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 9</span></span>
<span class='c'>#&gt;   series baker_full  baker    age occupation city  locale baker_last baker_first</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>      </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>      </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>      </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> 1      </span><span style='color: #555555;'>"</span><span>Annetha M… Annet…    30 Midwife    Essex </span><span style='color: #BB0000;'>NA</span><span>     Mills      Annetha    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> 1      </span><span style='color: #555555;'>"</span><span>David Cha… David     31 Entrepren… Milt… </span><span style='color: #BB0000;'>NA</span><span>     Chambers   David      </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> 1      </span><span style='color: #555555;'>"</span><span>Edward \"… Edd       24 Debt coll… Brad… </span><span style='color: #BB0000;'>NA</span><span>     Kimber     Edward     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> 1      </span><span style='color: #555555;'>"</span><span>Jasminder… Jasmi…    45 Assistant… Birm… </span><span style='color: #BB0000;'>NA</span><span>     Randhawa   Jasminder  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> 1      </span><span style='color: #555555;'>"</span><span>Jonathan … Jonat…    25 Research … St A… </span><span style='color: #BB0000;'>NA</span><span>     Shepherd   Jonathan   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> 1      </span><span style='color: #555555;'>"</span><span>Lea Harri… Lea       51 Retired    Midl… Scotl… Harris     Lea</span></span></code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### Exercise 3

<div class="puzzle">

<div>

Using the dataset `bakers` add a column `nickname` which indicates the bakers nickname, if they have one.

<details>

<summary> Hints (click here) </summary>

Think about how to make a regex that would pull out the nickname. Try using `str_view_all()` to get your regex working before you apply it to `bakers`.  
<br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>baker_full</span> <span class='o'>&lt;-</span> <span class='nv'>bakers</span><span class='o'>$</span><span class='nv'>baker_full</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># note I used single quotes because there were double quotes in the regex</span>
<span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>baker_full</span>, <span class='s'>'(?&lt;=\\").*(?=\\")'</span><span class='o'>)</span> </code></pre>

</div>

<div class="highlight">

<img src="nicknames_3.png" width="40%" style="display: block; margin: auto auto auto 0;" />

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bakers_nickname</span> <span class='o'>&lt;-</span> <span class='nv'>bakers</span> <span class='o'>%&gt;%</span>
  <span class='nf'>extract</span><span class='o'>(</span>col <span class='o'>=</span> <span class='nv'>baker_full</span>,
          into <span class='o'>=</span> <span class='s'>"nickname"</span>,
          regex <span class='o'>=</span> <span class='s'>'((?&lt;=\\").*(?=\\"))'</span><span class='o'>)</span>

<span class='nv'>bakers_nickname</span> <span class='o'>%&gt;%</span>
  <span class='nf'>arrange</span><span class='o'>(</span><span class='nv'>nickname</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 8</span></span>
<span class='c'>#&gt;   series nickname baker    age occupation       hometown  baker_last baker_first</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>    </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>            </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>      </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>      </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> 1      Edd      Edd       24 Debt collector … Bradford  Kimber     Edward     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> 2      Jo       Joanne    41 Housewife        Ongar, E… Wheatley   Joanne     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> 7      Val      Val       66 Semi-retired, S… Yeovil    Stones     Valerie    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> 8      Yan      Yan       46 Laboratory rese… North Lo… Tsou       Chuen-Yan  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> 1      </span><span style='color: #BB0000;'>NA</span><span>       Annet…    30 Midwife          Essex     Mills      Annetha    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> 1      </span><span style='color: #BB0000;'>NA</span><span>       David     31 Entrepreneur     Milton K… Chambers   David</span></span></code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### Exercise 4

<div class="puzzle">

<div>

Using the dataset `challenge_results`, write a regex to find any `signature` that contains chocolate. Remove all observations that contain `NA` for the `signature`. How many of the signature bakes contain chocolate? What percentage of the total signature bakes (for which we have bake names) does this represent?

<details>

<summary> Hints (click here) </summary>

You can get rid of NAs with `drop_na()`. Try using `str_count()` to see how many occurances you have of chocolate in the signatures. <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># select only signatures, drop NAs</span>
<span class='nv'>signatures</span> <span class='o'>&lt;-</span> <span class='nv'>challenge_results</span> <span class='o'>%&gt;%</span>
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>signature</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'>drop_na</span><span class='o'>(</span><span class='o'>)</span> 

<span class='c'># check dimensions </span>
<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>signatures</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 703   1</span>

<span class='c'># regex for chocolate (or Chocolate, or Chocolatey)</span>
<span class='nf'>str_count</span><span class='o'>(</span><span class='nv'>signatures</span>, <span class='s'>"C?c?hocolat"</span><span class='o'>)</span> 
<span class='c'>#&gt; Warning in stri_count_regex(string, pattern, opts_regex = opts(pattern)): argument is not an atomic vector; coercing</span>
<span class='c'>#&gt; [1] 77</span>

<span class='c'># what percent of signatures contain chocolate</span>
<span class='o'>(</span><span class='nf'>str_count</span><span class='o'>(</span><span class='nv'>signatures</span>, <span class='s'>"C?c?hocolat"</span><span class='o'>)</span><span class='o'>/</span><span class='nf'>count</span><span class='o'>(</span><span class='nv'>signatures</span><span class='o'>)</span><span class='o'>)</span><span class='o'>*</span><span class='m'>100</span>
<span class='c'>#&gt; Warning in stri_count_regex(string, pattern, opts_regex = opts(pattern)): argument is not an atomic vector; coercing</span>
<span class='c'>#&gt;          n</span>
<span class='c'>#&gt; 1 10.95306</span></code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

