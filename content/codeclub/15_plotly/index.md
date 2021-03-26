---
title: "Session 15: Plotly"
subtitle: "Making our plots interactive"
summary: "During this fifteenth session of Code Club, we will learn to make interactive plots using ggplotly."  
authors: [jessica-cooperstone]
date: "2021-03-24"
output: hugodown::md_document
toc: true
rmd_hash: 9f879dd6224fbb24

---

------------------------------------------------------------------------

Prep homework
-------------

### Basic computer setup

-   If you didn't already do this, please follow the [Code Club Computer Setup](/codeclub-setup/04_ggplot2/) instructions, which also has pointers for if you're new to R or RStudio.

-   If you're able to do so, please open RStudio a bit before Code Club starts -- and in case you run into issues, please join the Zoom call early and we'll help you troubleshoot.

### New to ggplot?

Check out the three Code Club pages for [Session 4](/codeclub/04_ggplot2/), [Session 5](/codeclub/05_ggplot-round-2/) and [Session 10](/codeclub/10_faceting-animating/) which are all about `ggplot2`.

If you've never used `ggplot2` before (or even if you have), you may find [this cheat sheet](https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf) useful.

<br>

Getting Started
---------------

### RMarkdown for today's session

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># directory for Code Club Session 15:</span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>"S15"</span><span class='o'>)</span>

<span class='c'># directory for our RMarkdown</span>
<span class='c'># ("recursive" to create two levels at once.)</span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>"S15/Rmd/"</span><span class='o'>)</span>

<span class='c'># save the url location for today's script</span>
<span class='nv'>todays_Rmd</span> <span class='o'>&lt;-</span> 
  <span class='s'>'https://raw.githubusercontent.com/biodash/biodash.github.io/master/content/codeclub/15_plotly/Plotly-withOUT-answers.Rmd'</span>

<span class='c'># indicate the name of the new Rmd</span>
<span class='nv'>Session15_Rmd</span> <span class='o'>&lt;-</span> <span class='s'>"S15/Rmd/Session15_plotly.Rmd"</span>

<span class='c'># go get that file! </span>
<span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>todays_Rmd</span>,
              destfile <span class='o'>=</span> <span class='nv'>Session15_Rmd</span><span class='o'>)</span></code></pre>

</div>

<br>

------------------------------------------------------------------------

1 - What is plotly?
-------------------

Today we are going to talk about making interactive plots using [Plotly](https://plotly.com/). Plotly exists in a variety of programming languages, but today we will be just talking about using it in [R](https://plotly.com/r/). All of the plotly documentation can be found [here](https://cran.r-project.org/web/packages/plotly/plotly.pdf).

If you have never used `plotly` before, install it with the code below.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"plotly"</span><span class='o'>)</span></code></pre>

</div>

Here are some useful links to find info about using `ggplotly`.

-   [Basic ggplot2 charts](https://plotly.com/ggplot2/#layout-options)
-   [Plotly R library fundamentals](https://plotly.com/r/plotly-fundamentals/)
-   [Intro to `ggplotly()`](https://plotly-r.com/overview.html#intro-ggplotly)
-   [Using `layout()`](https://plotly.com/r/reference/layout/#)
-   [`ggplotly()` tooltips](https://plotly-r.com/controlling-tooltips.html#tooltip-text-ggplotly)

Before we start, there are two basic ways to use plot in R using plotly:

-   Using [`ggplotly()`](https://www.rdocumentation.org/packages/plotly/versions/4.9.3/topics/ggplotly) - this is what we will go over today because it has the same syntax as `ggplot()` which we have already learned
-   Using [`plot_ly()`](https://www.rdocumentation.org/packages/plotly/versions/4.9.3/topics/plot_ly) - there is slightly more functionality in this function, but the syntax is all new, so I'd suggest if you can do what you want with [`ggplotly()`](https://docs.ropensci.org/plotly/reference/ggplotly.html), do that. The syntax is not particularly hard so don't be scared to use it if interactive plots are something you're very interested in.

When you are googling about using plotly, you will find a combination of [`ggplotly()`](https://docs.ropensci.org/plotly/reference/ggplotly.html) and [`plot_ly()`](https://docs.ropensci.org/plotly/reference/plot_ly.html) approaches, and some parts of the code are interchangable. The easiesy way to see which parts are, is to try.

Also note, Google gets a bit confused when googling "ggplotly" and often returns information about just ggplot, so read extra carefully when problem solving.

This is an example of work from my group where we have found plotly to be particularly useful.

`{{< chart data="apples" >}}` Data from [Bilbrey et al., bioRxiv 2021](https://www.biorxiv.org/content/10.1101/2021.02.18.431481v1)

------------------------------------------------------------------------

2 - Load libraries, get data
----------------------------

Lets load the libraries we are using for today.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://plotly-r.com'>plotly</a></span><span class='o'>)</span> <span class='c'># for making interactive plots</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/ramnathv/htmlwidgets'>htmlwidgets</a></span><span class='o'>)</span> <span class='c'># for saving html files</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://allisonhorst.github.io/palmerpenguins/'>palmerpenguins</a></span><span class='o'>)</span> <span class='c'># for our penguins data</span></code></pre>

</div>

Let's look at `penguins_raw` this time, a df that has a bit more data than the `penguins` df.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>penguins_raw</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 17</span></span>
<span class='c'>#&gt;   studyName `Sample Number` Species       Region Island  Stage   `Individual ID`</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>               </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>         </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>          </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> PAL0708                 1 Adelie Pengu… Anvers Torger… Adult,… N1A1           </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> PAL0708                 2 Adelie Pengu… Anvers Torger… Adult,… N1A2           </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> PAL0708                 3 Adelie Pengu… Anvers Torger… Adult,… N2A1           </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> PAL0708                 4 Adelie Pengu… Anvers Torger… Adult,… N2A2           </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> PAL0708                 5 Adelie Pengu… Anvers Torger… Adult,… N3A1           </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> PAL0708                 6 Adelie Pengu… Anvers Torger… Adult,… N3A2           </span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 10 more variables: Clutch Completion &lt;chr&gt;, Date Egg &lt;date&gt;,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   Culmen Length (mm) &lt;dbl&gt;, Culmen Depth (mm) &lt;dbl&gt;,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   Flipper Length (mm) &lt;dbl&gt;, Body Mass (g) &lt;dbl&gt;, Sex &lt;chr&gt;,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   Delta 15 N (o/oo) &lt;dbl&gt;, Delta 13 C (o/oo) &lt;dbl&gt;, Comments &lt;chr&gt;</span></span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>penguins</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 8</span></span>
<span class='c'>#&gt;   species island bill_length_mm bill_depth_mm flipper_length_… body_mass_g sex  </span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>           </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>         </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>            </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Adelie  Torge…           39.1          18.7              181        </span><span style='text-decoration: underline;'>3</span><span>750 male </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Adelie  Torge…           39.5          17.4              186        </span><span style='text-decoration: underline;'>3</span><span>800 fema…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Adelie  Torge…           40.3          18                195        </span><span style='text-decoration: underline;'>3</span><span>250 fema…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Adelie  Torge…           </span><span style='color: #BB0000;'>NA</span><span>            </span><span style='color: #BB0000;'>NA</span><span>                 </span><span style='color: #BB0000;'>NA</span><span>          </span><span style='color: #BB0000;'>NA</span><span> </span><span style='color: #BB0000;'>NA</span><span>   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> Adelie  Torge…           36.7          19.3              193        </span><span style='text-decoration: underline;'>3</span><span>450 fema…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> Adelie  Torge…           39.3          20.6              190        </span><span style='text-decoration: underline;'>3</span><span>650 male </span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 1 more variable: year &lt;int&gt;</span></span></code></pre>

</div>

3 - Create base ggplot object
-----------------------------

Using the `penguins_raw` dataset and make a scatter plot with Culmen Length on the y, and Culmen Depth on the x.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_depth_length</span> <span class='o'>&lt;-</span> <span class='nv'>penguins_raw</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>`Culmen Length (mm)`</span>, y <span class='o'>=</span> <span class='nv'>`Culmen Depth (mm)`</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span>

<span class='nv'>bill_depth_length</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing missing values (geom_point).</span>
</code></pre>
<img src="figs/unnamed-chunk-5-1.png" width="700px" style="display: block; margin: auto;" />

</div>

4 - Make it interactive with [`ggplotly()`](https://docs.ropensci.org/plotly/reference/ggplotly.html)
-----------------------------------------

You can learn more about the [`ggplotly()`](https://docs.ropensci.org/plotly/reference/ggplotly.html) function, including its arguments [here](https://www.rdocumentation.org/packages/plotly/versions/4.9.3/topics/ggplotly).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://docs.ropensci.org/plotly/reference/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>bill_depth_length</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

</div>

`{{< chart data="penguins1" >}}`

Wow that was easy!

Let's add a title and change the theme to make our plot a little prettier before we progress.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_depth_length</span> <span class='o'>&lt;-</span> <span class='nv'>penguins_raw</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>`Culmen Length (mm)`</span>, y <span class='o'>=</span> <span class='nv'>`Culmen Depth (mm)`</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_minimal</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Understanding Penguin Bill Dimensions"</span><span class='o'>)</span>

<span class='nf'><a href='https://docs.ropensci.org/plotly/reference/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>bill_depth_length</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

</div>

`{{< chart data="penguins2" >}}`

5 - Using tooltip
-----------------

Using tooltip helps you to indicate what appears when you hover over different parts of your plot. You can learn more about controlling `tooltip` [here](https://plotly-r.com/controlling-tooltips.html).

What if we want to hover over each point and be able to tell which `Island` the penguin was found on?

To do this, we indicate what we want to hover with using `text =` in our aesthetic mappings. Then, we indicate `tooltip = "text"` to tell [`ggplotly()`](https://docs.ropensci.org/plotly/reference/ggplotly.html) what we want to hover.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_depth_length</span> <span class='o'>&lt;-</span> <span class='nv'>penguins_raw</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>`Culmen Length (mm)`</span>, y <span class='o'>=</span> <span class='nv'>`Culmen Depth (mm)`</span>,
             text <span class='o'>=</span> <span class='nv'>Island</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_minimal</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Understanding Penguin Bill Dimensions"</span><span class='o'>)</span>

<span class='nf'><a href='https://docs.ropensci.org/plotly/reference/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>bill_depth_length</span>,
         tooltip <span class='o'>=</span> <span class='s'>"text"</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

</div>

`{{< chart data="penguins3" >}}`

You can play around a lot with tooltip to get it to be exactly how you want, and you can include multiple things in your hover text.

You can also indicate to hover with data that is not inherently in your plot by mapping it to a `group` aesthetic.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_depth_length</span> <span class='o'>&lt;-</span> <span class='nv'>penguins_raw</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>`Culmen Length (mm)`</span>, y <span class='o'>=</span> <span class='nv'>`Culmen Depth (mm)`</span>,
             text <span class='o'>=</span> <span class='nv'>Island</span>, group <span class='o'>=</span> <span class='nv'>`Individual ID`</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_minimal</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Understanding Penguin Bill Dimensions"</span><span class='o'>)</span>

<span class='nf'><a href='https://docs.ropensci.org/plotly/reference/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>bill_depth_length</span>,
         tooltip <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"text"</span>, <span class='s'>"Individual ID"</span><span class='o'>)</span><span class='o'>)</span> <span class='c'># hover test will be in this order</span></code></pre>

</div>

<div class="highlight">

</div>

`{{< chart data="penguins4" >}}`

You may also want to paste in some text to your hover info to provide additional clarity on what you are showing.

You can use `paste` to add some information you'd like to see in each of the hover texts, here, we are indicating Island: `Island`. You can also add multiple variables within text, and it will populate in the hover text in the way you indicate. There is an example of how to do this in Bonus 1.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_depth_length</span> <span class='o'>&lt;-</span> <span class='nv'>penguins_raw</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>`Culmen Length (mm)`</span>, y <span class='o'>=</span> <span class='nv'>`Culmen Depth (mm)`</span>,
             text <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/paste.html'>paste</a></span><span class='o'>(</span><span class='s'>"Island:"</span>, <span class='nv'>Island</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_minimal</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Understanding Penguin Bill Dimensions"</span><span class='o'>)</span>

<span class='nf'><a href='https://docs.ropensci.org/plotly/reference/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>bill_depth_length</span>,
         tooltip <span class='o'>=</span> <span class='s'>"text"</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

</div>

`{{< chart data="penguins5" >}}`

6 - Hover label aesthetics
--------------------------

You might not like the default hover text aesthetics, and can change them! You can do this using `style` and `layout` and adding these functions using the pipe [`%>%`](https://magrittr.tidyverse.org/reference/pipe.html).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># setting fonts for the plot</span>
<span class='nv'>font</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span>
  family <span class='o'>=</span> <span class='s'>"Roboto Condensed"</span>,
  size <span class='o'>=</span> <span class='m'>15</span>,
  color <span class='o'>=</span> <span class='s'>"white"</span><span class='o'>)</span>

<span class='c'># setting hover label specs</span>
<span class='nv'>label</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span>
  bgcolor <span class='o'>=</span> <span class='s'>"#FF0000"</span>,
  bordercolor <span class='o'>=</span> <span class='s'>"transparent"</span>,
  font <span class='o'>=</span> <span class='nv'>font</span><span class='o'>)</span> <span class='c'># we can do this bc we already set font</span>

<span class='c'># plotting like normal</span>
<span class='nv'>bill_depth_length</span> <span class='o'>&lt;-</span> <span class='nv'>penguins_raw</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>`Culmen Length (mm)`</span>, y <span class='o'>=</span> <span class='nv'>`Culmen Depth (mm)`</span>,
             text <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/paste.html'>paste</a></span><span class='o'>(</span><span class='s'>"Island:"</span>, <span class='nv'>Island</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_minimal</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"A Deep Dive (ha) Into \nUnderstanding Penguin Bill Dimensions"</span><span class='o'>)</span>
<span class='c'># use\n to bring your text to another line</span>

<span class='c'># amending our ggplotly call to include new fonts and hover label specs</span>
<span class='nf'><a href='https://docs.ropensci.org/plotly/reference/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>bill_depth_length</span>, tooltip <span class='o'>=</span> <span class='s'>"text"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://docs.ropensci.org/plotly/reference/style.html'>style</a></span><span class='o'>(</span>hoverlabel <span class='o'>=</span> <span class='nv'>label</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://docs.ropensci.org/plotly/reference/layout.html'>layout</a></span><span class='o'>(</span>font <span class='o'>=</span> <span class='nv'>font</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

</div>

`{{< chart data="penguins6" >}}`

7 - Dynamic ticks
-----------------

Keep your axis labels so when you zoom, you can see where you are on your plot. Remember, you can zoom and pan around your plot!

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://docs.ropensci.org/plotly/reference/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>bill_depth_length</span>,
         tooltip <span class='o'>=</span> <span class='s'>"text"</span>,
         dynamicTicks <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

</div>

`{{< chart data="penguins7" >}}`

8 - Animating
-------------

Add `frame` in your aesthetics mapping to tell plotly what column to animate over. You can then play your animation, or toggle from one view to another.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># add frame</span>
<span class='nv'>bill_depth_length</span> <span class='o'>&lt;-</span> <span class='nv'>penguins_raw</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>`Culmen Length (mm)`</span>, y <span class='o'>=</span> <span class='nv'>`Culmen Depth (mm)`</span>,
             frame <span class='o'>=</span> <span class='nv'>Island</span>, text <span class='o'>=</span> <span class='nv'>`Individual ID`</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_minimal</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Understanding Penguin Bill Dimensions"</span><span class='o'>)</span>

<span class='nf'><a href='https://docs.ropensci.org/plotly/reference/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>bill_depth_length</span>,
         tooltip <span class='o'>=</span> <span class='s'>"text"</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

</div>

`{{< chart data="penguins8" >}}`

**Note:** I know this plot isn't animating, this is just because of how this website is formatting and I couldn't figure out how to fix it. But, if you do this in R, you will find the code works.

9 - Everything you know about ggplot still applies!
---------------------------------------------------

Don't forget you can use things like faceting, that we have gone over previously in [Session 10](https://biodash.github.io/codeclub/10_faceting-animating/).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bill_depth_length</span> <span class='o'>&lt;-</span> <span class='nv'>penguins</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>bill_length_mm</span>, y <span class='o'>=</span> <span class='nv'>bill_depth_mm</span>, color <span class='o'>=</span> <span class='nv'>species</span>,
             text <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/paste.html'>paste</a></span><span class='o'>(</span><span class='s'>"Island:"</span>, <span class='nv'>island</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_minimal</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"none"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Understanding Penguin Bill Dimensions"</span>,
       x <span class='o'>=</span> <span class='s'>"Culmen Bill Length (mm)"</span>,
       y <span class='o'>=</span> <span class='s'>"Culmen Bill Depth (mm)"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>facet_wrap</span><span class='o'>(</span><span class='o'>~</span><span class='nv'>species</span><span class='o'>)</span>

<span class='nf'><a href='https://docs.ropensci.org/plotly/reference/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>bill_depth_length</span>,
         tooltip <span class='o'>=</span> <span class='s'>"text"</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

</div>

`{{< chart data="penguins9" >}}`

10 - Saving your plots
----------------------

Now that you've made a beautiful interactive plot, you probably want to save it.

Assign the plot you want to save to an object, and use the function [`saveWidget()`](https://rdrr.io/pkg/htmlwidgets/man/saveWidget.html) to save it. You can find the documentation [here](https://www.rdocumentation.org/packages/htmlwidgets/versions/1.5.3/topics/saveWidget).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># assign ggplotly plot to an object</span>
<span class='nv'>ggplotly_to_save</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://docs.ropensci.org/plotly/reference/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>bill_depth_length</span>,
                             tooltip <span class='o'>=</span> <span class='s'>"text"</span><span class='o'>)</span>

<span class='c'># save</span>
<span class='nf'><a href='https://rdrr.io/pkg/htmlwidgets/man/saveWidget.html'>saveWidget</a></span><span class='o'>(</span>widget <span class='o'>=</span> <span class='nv'>ggplotly_to_save</span>,
           file <span class='o'>=</span> <span class='s'>"ggplotlying.html"</span><span class='o'>)</span></code></pre>

</div>

Breakout rooms
--------------

We are going to use the birds dataset from previous weeks, and gapminder data for the bonus.

Let's grab the birds data.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># create directory for data to go</span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>'data/birds/'</span>, recursive <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>

<span class='c'># preparing to download</span>
<span class='c'># denote bird file url</span>
<span class='nv'>birds_url</span> <span class='o'>&lt;-</span>
<span class='s'>'https://raw.githubusercontent.com/biodash/biodash.github.io/master/assets/data/birds/backyard-birds_Ohio.tsv'</span>
<span class='c'># denote file name</span>
<span class='nv'>birds_file</span> <span class='o'>&lt;-</span> <span class='s'>'data/birds/backyard-birds_Ohio.tsv'</span>

<span class='c'># get file</span>
<span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>birds_url</span>, 
              destfile <span class='o'>=</span> <span class='nv'>birds_file</span><span class='o'>)</span></code></pre>

</div>

Read in data.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># read in birds data</span>
<span class='nv'>birds</span> <span class='o'>&lt;-</span> <span class='nf'>read_tsv</span><span class='o'>(</span>file <span class='o'>=</span> <span class='s'>'data/birds/backyard-birds_Ohio.tsv'</span><span class='o'>)</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; <span style='color: #00BBBB;'>──</span><span> </span><span style='font-weight: bold;'>Column specification</span><span> </span><span style='color: #00BBBB;'>────────────────────────────────────────────────────────</span></span>
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
<span class='c'>#&gt; )</span></code></pre>

</div>

Look at your new df.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 12</span></span>
<span class='c'>#&gt;   class order   family  genus  species   locality  stateProvince decimalLatitude</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                   </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Aves  Passer… Corvid… Cyano… Cyanocit… 44805 As… Ohio                     40.9</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Aves  Passer… Corvid… Cyano… Cyanocit… 45244 Ci… Ohio                     39.1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Aves  Passer… Corvid… Cyano… Cyanocit… 44132 Eu… Ohio                     41.6</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Aves  Passer… Corvid… Cyano… Cyanocit… 45242 Ci… Ohio                     39.2</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> Aves  Passer… Corvid… Cyano… Cyanocit… 45246 Ci… Ohio                     39.3</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> Aves  Passer… Corvid… Cyano… Cyanocit… 44484 Wa… Ohio                     41.2</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 4 more variables: decimalLongitude &lt;dbl&gt;, eventDate &lt;dttm&gt;,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   species_en &lt;chr&gt;, range &lt;chr&gt;</span></span></code></pre>

</div>

Exercises
---------

### Exercise 1

<div class="puzzle">

<div>

Filter your new `birds` df to only inclue Blue Jays. Check to see how many Blue Jay sightings there were in Ohio.

<details>

<summary> Hints (click here) </summary>

Try using a [`filter()`](https://dplyr.tidyverse.org/reference/filter.html), and consider filtering based on `species_en` <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bald_eagle</span> <span class='o'>&lt;-</span> <span class='nv'>birds</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>species_en</span> <span class='o'>==</span> <span class='s'>"Bald Eagle"</span><span class='o'>)</span>

<span class='c'># what do we have?</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>bald_eagle</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 12</span></span>
<span class='c'>#&gt;   class order   family  genus  species   locality  stateProvince decimalLatitude</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                   </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Aves  Accipi… Accipi… Halia… Haliaeet… Mentor    Ohio                     41.7</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Aves  Accipi… Accipi… Halia… Haliaeet… 45742 Li… Ohio                     39.3</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Aves  Accipi… Accipi… Halia… Haliaeet… Moreland… Ohio                     41.4</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Aves  Accipi… Accipi… Halia… Haliaeet… Eastlake  Ohio                     41.7</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> Aves  Accipi… Accipi… Halia… Haliaeet… 44060 Me… Ohio                     41.7</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> Aves  Accipi… Accipi… Halia… Haliaeet… 44839 Hu… Ohio                     41.4</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 4 more variables: decimalLongitude &lt;dbl&gt;, eventDate &lt;dttm&gt;,</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>#   species_en &lt;chr&gt;, range &lt;chr&gt;</span></span>

<span class='c'># check our df dimensions</span>
<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>bald_eagle</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 381  12</span></code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### Exercise 2

<div class="puzzle">

<div>

Create a map that plots all the Blue Jays found around Ohio. Color the points blue. Make sure the aspect ratio of Ohio looks reasonable to you.

<details>

<summary> Hints (click here) </summary>

Go back to Sessions [11](https://biodash.github.io/codeclub/11_ggplot-maps/) and [12](https://biodash.github.io/codeclub/12_loops/) to re-remember how maps work. Don't forget to call [`library(maps)`](https://rdrr.io/r/base/library.html). <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'>maps</span><span class='o'>)</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Attaching package: 'maps'</span>
<span class='c'>#&gt; The following object is masked from 'package:purrr':</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;     map</span>

<span class='c'># get map of the states</span>
<span class='nv'>states</span> <span class='o'>&lt;-</span> <span class='nf'>map_data</span><span class='o'>(</span><span class='s'>"state"</span><span class='o'>)</span>

<span class='c'># filter states to only include ohio</span>
<span class='nv'>ohio</span> <span class='o'>&lt;-</span> <span class='nv'>states</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>region</span> <span class='o'>==</span> <span class='s'>"ohio"</span><span class='o'>)</span>

<span class='c'># plot</span>
<span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>ohio</span>,
       <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_polygon</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"black"</span>, fill <span class='o'>=</span> <span class='s'>"white"</span><span class='o'>)</span> <span class='o'>+</span>   
  <span class='nf'>geom_point</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>bald_eagle</span>,                 
             <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>decimalLongitude</span>, y <span class='o'>=</span> <span class='nv'>decimalLatitude</span>, group <span class='o'>=</span> <span class='kc'>NULL</span><span class='o'>)</span>,
             color <span class='o'>=</span> <span class='s'>"blue"</span>, alpha <span class='o'>=</span> <span class='m'>0.2</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>coord_fixed</span><span class='o'>(</span><span class='m'>1.2</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>'Bald Eagles Around Ohio'</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-29-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### Exercise 3

<div class="puzzle">

<div>

Make your plot interactive so you can hover and and see the locality of each bald eagle observation.

<details>

<summary> Hints (click here) </summary>

You may want to call `text` within `geom_point()`. <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>bald_eagles_ohio</span> <span class='o'>&lt;-</span> 
  <span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>ohio</span>,
         <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_polygon</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"black"</span>, fill <span class='o'>=</span> <span class='s'>"white"</span><span class='o'>)</span> <span class='o'>+</span>   
  <span class='nf'>geom_point</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>bald_eagle</span>,                 
             <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>decimalLongitude</span>, y <span class='o'>=</span> <span class='nv'>decimalLatitude</span>, group <span class='o'>=</span> <span class='kc'>NULL</span>,
                 text <span class='o'>=</span> <span class='nv'>locality</span><span class='o'>)</span>,
             color <span class='o'>=</span> <span class='s'>"blue"</span>, alpha <span class='o'>=</span> <span class='m'>0.2</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>coord_fixed</span><span class='o'>(</span><span class='m'>1.2</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>'Bald Eagles Around Ohio'</span><span class='o'>)</span>

<span class='nf'><a href='https://docs.ropensci.org/plotly/reference/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>bald_eagles_ohio</span>,
         tooltip <span class='o'>=</span> <span class='s'>"text"</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

</div>

`{{< chart data="ohio1" >}}`

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### Exercise 4

<div class="puzzle">

<div>

Change the hover text so that the background color is red, clean up your axis labels, and make all the fonts for the plot Arial.

<details>

<summary> Hints (click here) </summary>

You can set fonts either within your `ggplot()` call, or setting `font` within [`layout()`](https://docs.ropensci.org/plotly/reference/layout.html). You can customize the hover label with [`style()`](https://docs.ropensci.org/plotly/reference/style.html). <br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># setting fonts for the plot</span>
<span class='nv'>eagle_font</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span>
  family <span class='o'>=</span> <span class='s'>"Arial"</span>,
  size <span class='o'>=</span> <span class='m'>15</span>,
  color <span class='o'>=</span> <span class='s'>"white"</span><span class='o'>)</span>

<span class='c'># setting hover label specs</span>
<span class='nv'>eagle_label</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span>
  bgcolor <span class='o'>=</span> <span class='s'>"red"</span>,
  bordercolor <span class='o'>=</span> <span class='s'>"transparent"</span>,
  font <span class='o'>=</span> <span class='nv'>eagle_font</span><span class='o'>)</span> <span class='c'># we can do this bc we already set font</span>

<span class='nv'>bald_eagles_ohio</span> <span class='o'>&lt;-</span> 
  <span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>ohio</span>,
         <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_polygon</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"black"</span>, fill <span class='o'>=</span> <span class='s'>"white"</span><span class='o'>)</span> <span class='o'>+</span>   
  <span class='nf'>geom_point</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>bald_eagle</span>,                 
             <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>decimalLongitude</span>, y <span class='o'>=</span> <span class='nv'>decimalLatitude</span>, group <span class='o'>=</span> <span class='kc'>NULL</span>,
                 text <span class='o'>=</span> <span class='nv'>locality</span><span class='o'>)</span>,
             color <span class='o'>=</span> <span class='s'>"blue"</span>, alpha <span class='o'>=</span> <span class='m'>0.2</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>coord_fixed</span><span class='o'>(</span><span class='m'>1.2</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>'Bald Eagles Around Ohio'</span>,
       x <span class='o'>=</span> <span class='s'>"Latitude"</span>,
       y <span class='o'>=</span> <span class='s'>"Longitude"</span><span class='o'>)</span>

<span class='c'># amending our ggplotly call to include new fonts and hover label specs</span>
<span class='nf'><a href='https://docs.ropensci.org/plotly/reference/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>bald_eagles_ohio</span>, tooltip <span class='o'>=</span> <span class='s'>"text"</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://docs.ropensci.org/plotly/reference/style.html'>style</a></span><span class='o'>(</span>hoverlabel <span class='o'>=</span> <span class='nv'>eagle_label</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://docs.ropensci.org/plotly/reference/layout.html'>layout</a></span><span class='o'>(</span>font <span class='o'>=</span> <span class='nv'>eagle_font</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

</div>

`{{< chart data="ohio2" >}}`

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

Bonus
-----

### Bonus 1

<div class="puzzle">

<div>

Let's go back to the Gapminder data we looked at in the instructional part of [Session 10](https://biodash.github.io/codeclub/10_faceting-animating/) on faceting, animating, and multi-plotting.

Make a bubble-style plot that shows the life expectancy vs. GDP per capita over 1952 to 2007 for all countries. Color by continent, and indicate population by size. Use your knowledge of making plots to alter it such that you think it is descriptive and aesthetic.

<details>

<summary> Hints (click here) </summary>

Set `text` to what you want to hover (try adding multiple variables in there!), play around with `theme` and scaling, change fonts and aesthetics until you are pleased. You can download the `gapminder` data like this:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># install.packages("gapminder") # if you weren't at Session 10</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/jennybc/gapminder'>gapminder</a></span><span class='o'>)</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>gapminder</span><span class='o'>)</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 6</span></span>
<span class='c'>#&gt;   country     continent  year lifeExp      pop gdpPercap</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>    </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Afghanistan Asia       </span><span style='text-decoration: underline;'>1</span><span>952    28.8  8</span><span style='text-decoration: underline;'>425</span><span>333      779.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Afghanistan Asia       </span><span style='text-decoration: underline;'>1</span><span>957    30.3  9</span><span style='text-decoration: underline;'>240</span><span>934      821.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Afghanistan Asia       </span><span style='text-decoration: underline;'>1</span><span>962    32.0 10</span><span style='text-decoration: underline;'>267</span><span>083      853.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Afghanistan Asia       </span><span style='text-decoration: underline;'>1</span><span>967    34.0 11</span><span style='text-decoration: underline;'>537</span><span>966      836.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> Afghanistan Asia       </span><span style='text-decoration: underline;'>1</span><span>972    36.1 13</span><span style='text-decoration: underline;'>079</span><span>460      740.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> Afghanistan Asia       </span><span style='text-decoration: underline;'>1</span><span>977    38.4 14</span><span style='text-decoration: underline;'>880</span><span>372      786.</span></span></code></pre>

</div>

<br>
</details>

<br>

<details>

<summary> Solutions (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>gapminder_font</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span>
  family <span class='o'>=</span> <span class='s'>"Roboto Condensed"</span><span class='o'>)</span>

<span class='nv'>gapminder_bubble</span> <span class='o'>&lt;-</span> <span class='nv'>gapminder</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>gdpPercap</span>, y <span class='o'>=</span> <span class='nv'>lifeExp</span>, 
             fill <span class='o'>=</span> <span class='nv'>continent</span>, size <span class='o'>=</span> <span class='nv'>pop</span>, 
             text <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/paste.html'>paste</a></span><span class='o'>(</span>
               <span class='s'>"Country:"</span>, <span class='nv'>country</span>,
               <span class='s'>"\nLife expectancy:"</span>, <span class='nf'><a href='https://rdrr.io/r/base/Round.html'>round</a></span><span class='o'>(</span><span class='nv'>lifeExp</span>,<span class='m'>1</span><span class='o'>)</span>,
               <span class='s'>"\nGDP per capita:"</span>, <span class='nf'><a href='https://rdrr.io/r/base/Round.html'>round</a></span><span class='o'>(</span><span class='nv'>gdpPercap</span>,<span class='m'>0</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>frame <span class='o'>=</span> <span class='nv'>year</span><span class='o'>)</span>, color <span class='o'>=</span> <span class='s'>"black"</span>, shape <span class='o'>=</span> <span class='m'>21</span>, stroke <span class='o'>=</span> <span class='m'>0.2</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>scale_x_log10</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme_minimal</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>theme</span><span class='o'>(</span>plot.title <span class='o'>=</span> <span class='nf'>element_text</span><span class='o'>(</span>size <span class='o'>=</span> <span class='m'>18</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Changing Life Expectancy and GDP Per Capita Worldwide \nFrom 1952 to 2007"</span>,
       x <span class='o'>=</span> <span class='s'>"GDP per capita (in International Dollars)"</span>,
       y <span class='o'>=</span> <span class='s'>"Life Expectancy (years)"</span>,
       fill <span class='o'>=</span> <span class='s'>""</span>,
       size <span class='o'>=</span> <span class='s'>""</span><span class='o'>)</span>

<span class='nf'><a href='https://docs.ropensci.org/plotly/reference/ggplotly.html'>ggplotly</a></span><span class='o'>(</span><span class='nv'>gapminder_bubble</span>, 
         tooltip <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"text"</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://docs.ropensci.org/plotly/reference/layout.html'>layout</a></span><span class='o'>(</span>font <span class='o'>=</span> <span class='nv'>gapminder_font</span><span class='o'>)</span></code></pre>

</div>

<div class="highlight">

</div>

`{{< chart data="gapminder" >}}`

**Note:** I know this plot isn't animating, this is just because of how this website is formatting and I couldn't figure out how to fix it. But, if you do this in R, you will find the code works.

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

