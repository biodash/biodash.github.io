---
title: "Session 4: Visualizing Data"
subtitle: "Introduction to Data Visualization with `ggplot2`"
summary: "In this session of Code Club, we'll look at how to visualize data in R using `ggplot2`."  
authors: [michael-broe]
date: "2020-12-10"
output: hugodown::md_document
toc: true

image: 
  caption: "Image from http://r-statistics.co/ggplot2-Tutorial-With-R.html"
  focal_point: ""
  preview_only: false

rmd_hash: f0509ecb33c287e7

---

<br> <br> <br>

------------------------------------------------------------------------

## New To Code Club?

-   First, check out the [Code Club Computer Setup](/codeclub-setup/) instructions, which also has some pointers that might be helpful if you're new to R or RStudio.

-   Please open RStudio before Code Club to test things out -- if you run into issues, join the Zoom call early and we'll troubleshoot.

------------------------------------------------------------------------

## Session Goals

-   Learn the philosophy of **coding** a graphic.
-   Learn the basic **template** of a **ggplot2** graphic, so you can reuse it for multiple chart types.
-   Learn how you can quickly add visual information to a graphic using **aesthetics** and **layers**.

------------------------------------------------------------------------

## Intro: The ggplot2 philosophy

We have already seen that in R, instead of manually manipulating data frames as you might do when editing Excel sheets, we **code** the operations we want to perform using **dplyr** verbs like `select()`, `mutate()`, `inner_join()`, and so on.

In a similar way when performing visualization, instead of clicking on a chart type in Excel, we **code the chart** in R.

And just as **dplyr** gives us efficient ways to manipulate data frames, **ggplot2** (which is also part of the **tidyverse**) gives us efficient ways to manipulate charts/plots/graphics (we use these terms interchangeably).

The **gg** in **ggplot2** stands for *grammar of graphics*, an systematic approach for designing statistical plots developed by Leland Wilkinson. The idea behind this was to think about 'pulling apart' various plots into their shared component pieces, then provide code that could put them together again. We can then create new plots like we create new sentences (once we understand this grammar).

There are two parts to this. First, the 'nouns and verbs' we need to work with plots are very different than those we need to work with data frames. **ggplot2** is like a mini-language of its own, with its own verbs and syntax.

Second, this notion of pulling apart a graphic leads to the idea of *layers*. You can build up a plot of any complexity by *overlaying* different views of the same data.

There's a learning curve here for sure, but there are a couple of things that help us.

First, every graphic shares a *common template*. This is like thinking about the sentence "The cat sat on the mat" grammatically as the template `NP V PP` (`N`oun `P`hrase "The cat", `V`erb "sat", `P`repositional `P`hrase "on the mat"). Once you understand this structure you can "say" a *lot* of different things.

(And I mean a *lot*. The [ggplot cheat sheet](https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf) gives an overview of the things you can do, but because this is a language, users can create their own [extensions](https://exts.ggplot2.tidyverse.org/gallery/) that you can also utilize.)

Second, they way we put layers together is identical to the way we use pipes. You can read `%>%` as "and then": `select()` and then `mutate()` and then `summarize()`. In graphics, we can say "show this layer, and then *overlay* this layer, and then *overlay* this layer", etc., using a very similar syntax.

<br>

------------------------------------------------------------------------

## Examples

So how does this work in practice? We'll work through visualizing the **iris** dataset that you've seen before. This is an extremely famous [dataset](https://en.m.wikipedia.org/wiki/Iris_flower_data_set) that was first analyzed by R. A. Fisher in 1936 *The use of multiple measurements in taxonomic problems*.

\*ggplot2\*\* is part of the tidyverse package so we need to load that first:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># this assumes you've already installed tidyverse</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>

<span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching packages</span><span> ─────────────────────────────────────── tidyverse 1.3.0 ──</span></span>

<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>ggplot2</span><span> 3.3.2     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>purrr  </span><span> 0.3.4</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>tibble </span><span> 3.0.4     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>dplyr  </span><span> 0.8.5</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>tidyr  </span><span> 1.0.3     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>stringr</span><span> 1.4.0</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>readr  </span><span> 1.3.1     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>forcats</span><span> 0.5.0</span></span>

<span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span><span> ────────────────────────────────────────── tidyverse_conflicts() ──</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>filter()</span><span> masks </span><span style='color: #0000BB;'>stats</span><span>::filter()</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>lag()</span><span>    masks </span><span style='color: #0000BB;'>stats</span><span>::lag()</span></span>
</code></pre>

</div>

And recall that the **iris** dataset (3 species, 50 observations per species) is automatically available to us:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>iris</span><span class='o'>)</span>

<span class='c'>#&gt;   Sepal.Length Sepal.Width Petal.Length Petal.Width Species</span>
<span class='c'>#&gt; 1          5.1         3.5          1.4         0.2  setosa</span>
<span class='c'>#&gt; 2          4.9         3.0          1.4         0.2  setosa</span>
<span class='c'>#&gt; 3          4.7         3.2          1.3         0.2  setosa</span>
<span class='c'>#&gt; 4          4.6         3.1          1.5         0.2  setosa</span>
<span class='c'>#&gt; 5          5.0         3.6          1.4         0.2  setosa</span>
<span class='c'>#&gt; 6          5.4         3.9          1.7         0.4  setosa</span>
</code></pre>

</div>

What is the correlation between petal length and width in these species? Are longer petals also wider? We can visualize this with a scatterplot. But first let's look a the ggplot template:

    ggplot(data = <DATA>) + 
      <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

These are the obligatory parts of any plot. The first argument to ggplot is the data frame:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>iris</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-3-1.png" width="700px" style="display: block; margin: auto;" />

</div>

This is not very interesting! but it's notable that it is *something*. `ggplot()` has created a base coordinate system that we can add visual layers to. The *add a layer* operator is "**+**", which is the ggplot equivalent of the pipe symbol, and **it must occur at the end of the line**.

The next argument specifies the **kind** plot we want: scatterplot, bar chart, fitted line, boxplot, etc. ggplot refers to these as **geoms**: the geometrical object that a plot uses to represent data. You can see an overview of all these in the [cheat sheet](https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf). The geom for a scatterplot is the point geom `geom_point()`.

But we also require a `mapping` argument, which relates the *variables* in the dataset we want to focus on to their *visual representation* in the plot. Finally we need to specify an "aesthetic" for the geometric objects in the plot, which will control things like shape, color, transparency, etc. Perhaps surprisingly, for a ggplot scatterplot, the x and y coordinates are aesthetics, since this controls not the shape or color, but the position of the points in the grid. Here is our complete plot:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>iris</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>Petal.Length</span>, y <span class='o'>=</span> <span class='nv'>Petal.Width</span><span class='o'>)</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-4-1.png" width="700px" style="display: block; margin: auto;" />

</div>

The National Health and Nutrition Examination Survey [(NHANES) dataset](https://www.rdocumentation.org/packages/NHANES/versions/2.1.0/topics/NHANES) contains survey data obtained annually from \~5,000 individuals on a variety of health and lifestyle-related metrics. A subset of the data are available as an R package - install and load it...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"NHANES"</span>, repos <span class='o'>=</span> <span class='s'>"http://cran.us.r-project.org"</span><span class='o'>)</span>

<span class='c'>#&gt; </span>
<span class='c'>#&gt; The downloaded binary packages are in</span>
<span class='c'>#&gt;   /var/folders/d4/h4yjqs1560zbsgvrrwbmbp5r0000gn/T//RtmpnW4Ybx/downloaded_packages</span>

<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'>NHANES</span><span class='o'>)</span>
</code></pre>

</div>

Now preview the dataset...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>NHANES</span><span class='o'>)</span>

<span class='c'>#&gt; Rows: 10,000</span>
<span class='c'>#&gt; Columns: 76</span>
<span class='c'>#&gt; $ ID               <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 51624, 51624, 51624, 51625, 51630, 51638, 51646, 516…</span></span>
<span class='c'>#&gt; $ SurveyYr         <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> 2009_10, 2009_10, 2009_10, 2009_10, 2009_10, 2009_10…</span></span>
<span class='c'>#&gt; $ Gender           <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> male, male, male, male, female, male, male, female, …</span></span>
<span class='c'>#&gt; $ Age              <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 34, 34, 34, 4, 49, 9, 8, 45, 45, 45, 66, 58, 54, 10,…</span></span>
<span class='c'>#&gt; $ AgeDecade        <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>  30-39,  30-39,  30-39,  0-9,  40-49,  0-9,  0-9,  4…</span></span>
<span class='c'>#&gt; $ AgeMonths        <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 409, 409, 409, 49, 596, 115, 101, 541, 541, 541, 795…</span></span>
<span class='c'>#&gt; $ Race1            <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> White, White, White, Other, White, White, White, Whi…</span></span>
<span class='c'>#&gt; $ Race3            <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ Education        <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> High School, High School, High School, NA, Some Coll…</span></span>
<span class='c'>#&gt; $ MaritalStatus    <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Married, Married, Married, NA, LivePartner, NA, NA, …</span></span>
<span class='c'>#&gt; $ HHIncome         <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> 25000-34999, 25000-34999, 25000-34999, 20000-24999, …</span></span>
<span class='c'>#&gt; $ HHIncomeMid      <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 30000, 30000, 30000, 22500, 40000, 87500, 60000, 875…</span></span>
<span class='c'>#&gt; $ Poverty          <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 1.36, 1.36, 1.36, 1.07, 1.91, 1.84, 2.33, 5.00, 5.00…</span></span>
<span class='c'>#&gt; $ HomeRooms        <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 6, 6, 6, 9, 5, 6, 7, 6, 6, 6, 5, 10, 6, 10, 10, 4, 3…</span></span>
<span class='c'>#&gt; $ HomeOwn          <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Own, Own, Own, Own, Rent, Rent, Own, Own, Own, Own, …</span></span>
<span class='c'>#&gt; $ Work             <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> NotWorking, NotWorking, NotWorking, NA, NotWorking, …</span></span>
<span class='c'>#&gt; $ Weight           <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 87.4, 87.4, 87.4, 17.0, 86.7, 29.8, 35.2, 75.7, 75.7…</span></span>
<span class='c'>#&gt; $ Length           <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ HeadCirc         <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ Height           <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 164.7, 164.7, 164.7, 105.4, 168.4, 133.1, 130.6, 166…</span></span>
<span class='c'>#&gt; $ BMI              <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 32.22, 32.22, 32.22, 15.30, 30.57, 16.82, 20.64, 27.…</span></span>
<span class='c'>#&gt; $ BMICatUnder20yrs <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ BMI_WHO          <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> 30.0_plus, 30.0_plus, 30.0_plus, 12.0_18.5, 30.0_plu…</span></span>
<span class='c'>#&gt; $ Pulse            <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 70, 70, 70, NA, 86, 82, 72, 62, 62, 62, 60, 62, 76, …</span></span>
<span class='c'>#&gt; $ BPSysAve         <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 113, 113, 113, NA, 112, 86, 107, 118, 118, 118, 111,…</span></span>
<span class='c'>#&gt; $ BPDiaAve         <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 85, 85, 85, NA, 75, 47, 37, 64, 64, 64, 63, 74, 85, …</span></span>
<span class='c'>#&gt; $ BPSys1           <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 114, 114, 114, NA, 118, 84, 114, 106, 106, 106, 124,…</span></span>
<span class='c'>#&gt; $ BPDia1           <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 88, 88, 88, NA, 82, 50, 46, 62, 62, 62, 64, 76, 86, …</span></span>
<span class='c'>#&gt; $ BPSys2           <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 114, 114, 114, NA, 108, 84, 108, 118, 118, 118, 108,…</span></span>
<span class='c'>#&gt; $ BPDia2           <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 88, 88, 88, NA, 74, 50, 36, 68, 68, 68, 62, 72, 88, …</span></span>
<span class='c'>#&gt; $ BPSys3           <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 112, 112, 112, NA, 116, 88, 106, 118, 118, 118, 114,…</span></span>
<span class='c'>#&gt; $ BPDia3           <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 82, 82, 82, NA, 76, 44, 38, 60, 60, 60, 64, 76, 82, …</span></span>
<span class='c'>#&gt; $ Testosterone     <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ DirectChol       <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 1.29, 1.29, 1.29, NA, 1.16, 1.34, 1.55, 2.12, 2.12, …</span></span>
<span class='c'>#&gt; $ TotChol          <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 3.49, 3.49, 3.49, NA, 6.70, 4.86, 4.09, 5.82, 5.82, …</span></span>
<span class='c'>#&gt; $ UrineVol1        <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 352, 352, 352, NA, 77, 123, 238, 106, 106, 106, 113,…</span></span>
<span class='c'>#&gt; $ UrineFlow1       <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, NA, NA, NA, 0.094, 1.538, 1.322, 1.116, 1.116, 1…</span></span>
<span class='c'>#&gt; $ UrineVol2        <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ UrineFlow2       <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ Diabetes         <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> No, No, No, No, No, No, No, No, No, No, No, No, No, …</span></span>
<span class='c'>#&gt; $ DiabetesAge      <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ HealthGen        <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Good, Good, Good, NA, Good, NA, NA, Vgood, Vgood, Vg…</span></span>
<span class='c'>#&gt; $ DaysPhysHlthBad  <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 0, 0, 0, NA, 0, NA, NA, 0, 0, 0, 10, 0, 4, NA, NA, 0…</span></span>
<span class='c'>#&gt; $ DaysMentHlthBad  <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 15, 15, 15, NA, 10, NA, NA, 3, 3, 3, 0, 0, 0, NA, NA…</span></span>
<span class='c'>#&gt; $ LittleInterest   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Most, Most, Most, NA, Several, NA, NA, None, None, N…</span></span>
<span class='c'>#&gt; $ Depressed        <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Several, Several, Several, NA, Several, NA, NA, None…</span></span>
<span class='c'>#&gt; $ nPregnancies     <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> NA, NA, NA, NA, 2, NA, NA, 1, 1, 1, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ nBabies          <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> NA, NA, NA, NA, 2, NA, NA, NA, NA, NA, NA, NA, NA, N…</span></span>
<span class='c'>#&gt; $ Age1stBaby       <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> NA, NA, NA, NA, 27, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ SleepHrsNight    <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 4, 4, 4, NA, 8, NA, NA, 8, 8, 8, 7, 5, 4, NA, 5, 7, …</span></span>
<span class='c'>#&gt; $ SleepTrouble     <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Yes, Yes, Yes, NA, Yes, NA, NA, No, No, No, No, No, …</span></span>
<span class='c'>#&gt; $ PhysActive       <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> No, No, No, NA, No, NA, NA, Yes, Yes, Yes, Yes, Yes,…</span></span>
<span class='c'>#&gt; $ PhysActiveDays   <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, 5, 5, 5, 7, 5, 1, NA, 2,…</span></span>
<span class='c'>#&gt; $ TVHrsDay         <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ CompHrsDay       <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
<span class='c'>#&gt; $ TVHrsDayChild    <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> NA, NA, NA, 4, NA, 5, 1, NA, NA, NA, NA, NA, NA, 4, …</span></span>
<span class='c'>#&gt; $ CompHrsDayChild  <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> NA, NA, NA, 1, NA, 0, 6, NA, NA, NA, NA, NA, NA, 3, …</span></span>
<span class='c'>#&gt; $ Alcohol12PlusYr  <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Yes, Yes, Yes, NA, Yes, NA, NA, Yes, Yes, Yes, Yes, …</span></span>
<span class='c'>#&gt; $ AlcoholDay       <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> NA, NA, NA, NA, 2, NA, NA, 3, 3, 3, 1, 2, 6, NA, NA,…</span></span>
<span class='c'>#&gt; $ AlcoholYear      <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 0, 0, 0, NA, 20, NA, NA, 52, 52, 52, 100, 104, 364, …</span></span>
<span class='c'>#&gt; $ SmokeNow         <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> No, No, No, NA, Yes, NA, NA, NA, NA, NA, No, NA, NA,…</span></span>
<span class='c'>#&gt; $ Smoke100         <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Yes, Yes, Yes, NA, Yes, NA, NA, No, No, No, Yes, No,…</span></span>
<span class='c'>#&gt; $ Smoke100n        <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Smoker, Smoker, Smoker, NA, Smoker, NA, NA, Non-Smok…</span></span>
<span class='c'>#&gt; $ SmokeAge         <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 18, 18, 18, NA, 38, NA, NA, NA, NA, NA, 13, NA, NA, …</span></span>
<span class='c'>#&gt; $ Marijuana        <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Yes, Yes, Yes, NA, Yes, NA, NA, Yes, Yes, Yes, NA, Y…</span></span>
<span class='c'>#&gt; $ AgeFirstMarij    <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 17, 17, 17, NA, 18, NA, NA, 13, 13, 13, NA, 19, 15, …</span></span>
<span class='c'>#&gt; $ RegularMarij     <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> No, No, No, NA, No, NA, NA, No, No, No, NA, Yes, Yes…</span></span>
<span class='c'>#&gt; $ AgeRegMarij      <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 20, 15, …</span></span>
<span class='c'>#&gt; $ HardDrugs        <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Yes, Yes, Yes, NA, Yes, NA, NA, No, No, No, No, Yes,…</span></span>
<span class='c'>#&gt; $ SexEver          <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Yes, Yes, Yes, NA, Yes, NA, NA, Yes, Yes, Yes, Yes, …</span></span>
<span class='c'>#&gt; $ SexAge           <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 16, 16, 16, NA, 12, NA, NA, 13, 13, 13, 17, 22, 12, …</span></span>
<span class='c'>#&gt; $ SexNumPartnLife  <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 8, 8, 8, NA, 10, NA, NA, 20, 20, 20, 15, 7, 100, NA,…</span></span>
<span class='c'>#&gt; $ SexNumPartYear   <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 1, 1, 1, NA, 1, NA, NA, 0, 0, 0, NA, 1, 1, NA, NA, 1…</span></span>
<span class='c'>#&gt; $ SameSex          <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> No, No, No, NA, Yes, NA, NA, Yes, Yes, Yes, No, No, …</span></span>
<span class='c'>#&gt; $ SexOrientation   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> Heterosexual, Heterosexual, Heterosexual, NA, Hetero…</span></span>
<span class='c'>#&gt; $ PregnantNow      <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …</span></span>
</code></pre>

</div>

To try out merging/joining, we'll create two separate data frames by pulling out some variables from this NHANES dataset. One will contain demographic variables, and the other with have some physical measurements. Then we'll join them back together. Let's create the two sub-datasets first...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#Filter out rows with data from 2009-2010 and Age &gt; 5, </span>
<span class='c'>#select a subset (4) of the variables, then get rid of </span>
<span class='c'>#all duplicate rows. Assign the output to object 'dem_data'.</span>
<span class='nv'>dem_data</span> <span class='o'>&lt;-</span> <span class='nv'>NHANES</span> <span class='o'>%&gt;%</span> 
            <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>SurveyYr</span> <span class='o'>==</span> <span class='s'>"2009_10"</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
            <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>Age</span> <span class='o'>&gt;</span> <span class='m'>5</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
            <span class='nf'>select</span><span class='o'>(</span><span class='nv'>ID</span>, <span class='nv'>Gender</span>, <span class='nv'>Age</span>, <span class='nv'>Education</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
            <span class='nf'>distinct</span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#similar as above, but with a different filter and </span>
<span class='c'>#selecting different variables. Save as 'phys_data'</span>
<span class='nv'>phys_data</span> <span class='o'>&lt;-</span> <span class='nv'>NHANES</span> <span class='o'>%&gt;%</span> 
             <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>SurveyYr</span> <span class='o'>==</span> <span class='s'>"2009_10"</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
             <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>Height</span> <span class='o'>&lt;</span> <span class='m'>180</span><span class='o'>)</span>  <span class='o'>%&gt;%</span>
             <span class='nf'>select</span><span class='o'>(</span><span class='nv'>ID</span>, <span class='nv'>Height</span>, <span class='nv'>BMI</span>, <span class='nv'>Pulse</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
             <span class='nf'>distinct</span><span class='o'>(</span><span class='o'>)</span>
</code></pre>

</div>

Now explore them a bit...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#view the first 6 rows of each - note the shared ID column</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>dem_data</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 4</span></span>
<span class='c'>#&gt;      ID Gender   Age Education   </span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>       </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> </span><span style='text-decoration: underline;'>51</span><span>624 male      34 High School </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> </span><span style='text-decoration: underline;'>51</span><span>630 female    49 Some College</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> </span><span style='text-decoration: underline;'>51</span><span>638 male       9 </span><span style='color: #BB0000;'>NA</span><span>          </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> </span><span style='text-decoration: underline;'>51</span><span>646 male       8 </span><span style='color: #BB0000;'>NA</span><span>          </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> </span><span style='text-decoration: underline;'>51</span><span>647 female    45 College Grad</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> </span><span style='text-decoration: underline;'>51</span><span>654 male      66 Some College</span></span>

<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>phys_data</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 4</span></span>
<span class='c'>#&gt;      ID Height   BMI Pulse</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> </span><span style='text-decoration: underline;'>51</span><span>624   165.  32.2    70</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> </span><span style='text-decoration: underline;'>51</span><span>625   105.  15.3    </span><span style='color: #BB0000;'>NA</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> </span><span style='text-decoration: underline;'>51</span><span>630   168.  30.6    86</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> </span><span style='text-decoration: underline;'>51</span><span>638   133.  16.8    82</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> </span><span style='text-decoration: underline;'>51</span><span>646   131.  20.6    72</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> </span><span style='text-decoration: underline;'>51</span><span>647   167.  27.2    62</span></span>


<span class='c'>#preview in another way - note the different numbers of observations (rows)</span>
<span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>dem_data</span><span class='o'>)</span>

<span class='c'>#&gt; Rows: 3,217</span>
<span class='c'>#&gt; Columns: 4</span>
<span class='c'>#&gt; $ ID        <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 51624, 51630, 51638, 51646, 51647, 51654, 51656, 51657, 516…</span></span>
<span class='c'>#&gt; $ Gender    <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> male, female, male, male, female, male, male, male, female,…</span></span>
<span class='c'>#&gt; $ Age       <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 34, 49, 9, 8, 45, 66, 58, 54, 10, 58, 50, 9, 33, 60, 16, 56…</span></span>
<span class='c'>#&gt; $ Education <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> High School, Some College, NA, NA, College Grad, Some Colle…</span></span>

<span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>phys_data</span><span class='o'>)</span>

<span class='c'>#&gt; Rows: 3,021</span>
<span class='c'>#&gt; Columns: 4</span>
<span class='c'>#&gt; $ ID     <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 51624, 51625, 51630, 51638, 51646, 51647, 51654, 51657, 51659,…</span></span>
<span class='c'>#&gt; $ Height <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 164.7, 105.4, 168.4, 133.1, 130.6, 166.7, 169.5, 169.4, 141.8,…</span></span>
<span class='c'>#&gt; $ BMI    <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 32.22, 15.30, 30.57, 16.82, 20.64, 27.24, 23.67, 26.03, 19.20,…</span></span>
<span class='c'>#&gt; $ Pulse  <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 70, NA, 86, 82, 72, 62, 60, 76, 80, 94, 74, 92, 84, 76, 64, 70…</span></span>
</code></pre>

</div>

Let's use the shared ID column to join the two datasets together. We'll do this in 4 different ways to compare different types of joins: `inner_join()`, `left_join()`, `right_join()`, and `full_join()`. Pay attention to the number of rows in the joined dataset each time and how it relates to the number of rows in each of the two individual datasets.

The basic structure of the dplyr `*_join()` functions is...

`*_join(dataframe 'x', dataframe 'y', by = shared column name)`

<br>

------------------------------------------------------------------------

## 1 - `inner_join()`

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#perform an inner join</span>
<span class='nv'>join_inner</span> <span class='o'>&lt;-</span> <span class='nf'>inner_join</span><span class='o'>(</span><span class='nv'>dem_data</span>, <span class='nv'>phys_data</span>, by <span class='o'>=</span> <span class='s'>"ID"</span><span class='o'>)</span>

<span class='c'>#preview the new object</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>join_inner</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 7</span></span>
<span class='c'>#&gt;      ID Gender   Age Education    Height   BMI Pulse</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>         </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> </span><span style='text-decoration: underline;'>51</span><span>624 male      34 High School    165.  32.2    70</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> </span><span style='text-decoration: underline;'>51</span><span>630 female    49 Some College   168.  30.6    86</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> </span><span style='text-decoration: underline;'>51</span><span>638 male       9 </span><span style='color: #BB0000;'>NA</span><span>             133.  16.8    82</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> </span><span style='text-decoration: underline;'>51</span><span>646 male       8 </span><span style='color: #BB0000;'>NA</span><span>             131.  20.6    72</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> </span><span style='text-decoration: underline;'>51</span><span>647 female    45 College Grad   167.  27.2    62</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> </span><span style='text-decoration: underline;'>51</span><span>654 male      66 Some College   170.  23.7    60</span></span>


<span class='c'>#get dimensions</span>
<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>join_inner</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 2806    7</span>
</code></pre>

</div>

## 2 - `left_join()`

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#perform an left join</span>
<span class='nv'>join_left</span> <span class='o'>&lt;-</span> <span class='nf'>left_join</span><span class='o'>(</span><span class='nv'>dem_data</span>, <span class='nv'>phys_data</span>, by <span class='o'>=</span> <span class='s'>"ID"</span><span class='o'>)</span>

<span class='c'>#preview the new object</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>join_left</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 7</span></span>
<span class='c'>#&gt;      ID Gender   Age Education    Height   BMI Pulse</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>         </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> </span><span style='text-decoration: underline;'>51</span><span>624 male      34 High School    165.  32.2    70</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> </span><span style='text-decoration: underline;'>51</span><span>630 female    49 Some College   168.  30.6    86</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> </span><span style='text-decoration: underline;'>51</span><span>638 male       9 </span><span style='color: #BB0000;'>NA</span><span>             133.  16.8    82</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> </span><span style='text-decoration: underline;'>51</span><span>646 male       8 </span><span style='color: #BB0000;'>NA</span><span>             131.  20.6    72</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> </span><span style='text-decoration: underline;'>51</span><span>647 female    45 College Grad   167.  27.2    62</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> </span><span style='text-decoration: underline;'>51</span><span>654 male      66 Some College   170.  23.7    60</span></span>


<span class='c'>#get dimensions</span>
<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>join_left</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 3217    7</span>
</code></pre>

</div>

## 3 - `right_join()`

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#perform an right join</span>
<span class='nv'>join_right</span> <span class='o'>&lt;-</span> <span class='nf'>right_join</span><span class='o'>(</span><span class='nv'>dem_data</span>, <span class='nv'>phys_data</span>, by <span class='o'>=</span> <span class='s'>"ID"</span><span class='o'>)</span>

<span class='c'>#preview the new object</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>join_right</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 7</span></span>
<span class='c'>#&gt;      ID Gender   Age Education    Height   BMI Pulse</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>         </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> </span><span style='text-decoration: underline;'>51</span><span>624 male      34 High School    165.  32.2    70</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> </span><span style='text-decoration: underline;'>51</span><span>625 </span><span style='color: #BB0000;'>NA</span><span>        </span><span style='color: #BB0000;'>NA</span><span> </span><span style='color: #BB0000;'>NA</span><span>             105.  15.3    </span><span style='color: #BB0000;'>NA</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> </span><span style='text-decoration: underline;'>51</span><span>630 female    49 Some College   168.  30.6    86</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> </span><span style='text-decoration: underline;'>51</span><span>638 male       9 </span><span style='color: #BB0000;'>NA</span><span>             133.  16.8    82</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> </span><span style='text-decoration: underline;'>51</span><span>646 male       8 </span><span style='color: #BB0000;'>NA</span><span>             131.  20.6    72</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> </span><span style='text-decoration: underline;'>51</span><span>647 female    45 College Grad   167.  27.2    62</span></span>


<span class='c'>#get dimensions</span>
<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>join_right</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 3021    7</span>
</code></pre>

</div>

## 4 - `full_join()`

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#perform an full join</span>
<span class='nv'>join_full</span> <span class='o'>&lt;-</span> <span class='nf'>full_join</span><span class='o'>(</span><span class='nv'>dem_data</span>, <span class='nv'>phys_data</span>, by <span class='o'>=</span> <span class='s'>"ID"</span><span class='o'>)</span>

<span class='c'>#preview the new object</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>join_full</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 7</span></span>
<span class='c'>#&gt;      ID Gender   Age Education    Height   BMI Pulse</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>         </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> </span><span style='text-decoration: underline;'>51</span><span>624 male      34 High School    165.  32.2    70</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> </span><span style='text-decoration: underline;'>51</span><span>630 female    49 Some College   168.  30.6    86</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> </span><span style='text-decoration: underline;'>51</span><span>638 male       9 </span><span style='color: #BB0000;'>NA</span><span>             133.  16.8    82</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> </span><span style='text-decoration: underline;'>51</span><span>646 male       8 </span><span style='color: #BB0000;'>NA</span><span>             131.  20.6    72</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> </span><span style='text-decoration: underline;'>51</span><span>647 female    45 College Grad   167.  27.2    62</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> </span><span style='text-decoration: underline;'>51</span><span>654 male      66 Some College   170.  23.7    60</span></span>


<span class='c'>#get dimensions</span>
<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>join_full</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 3432    7</span>
</code></pre>

</div>

<br>

------------------------------------------------------------------------

# Breakout rooms

We're going to add to our backyard birds dataset. I found a dataset that has life history data for a large number of species (birds and others). We'll use species names to merge some of these life history variables in to the occurrence data we already have.

If you're new and haven't yet gotten the backyard bird dataset, get it first by running the code below. Otherwise, you can skip this step...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># create a directory called data that contains a subdirectory called birds</span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>'data/birds/'</span>, recursive <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>

<span class='c'>#&gt; Warning in dir.create("data/birds/", recursive = TRUE): 'data/birds' already exists</span>


<span class='c'># set the location of the file</span>
<span class='nv'>birds_file_url</span> <span class='o'>&lt;-</span>
<span class='s'>'https://raw.githubusercontent.com/biodash/biodash.github.io/master/assets/data/birds/backyard-birds_Ohio.tsv'</span>

<span class='c'># set the path for the downloaded file</span>
<span class='nv'>birds_file</span> <span class='o'>&lt;-</span> <span class='s'>'data/birds/backyard-birds_Ohio.tsv'</span>
<span class='c'>#download</span>
<span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>birds_file_url</span>, destfile <span class='o'>=</span> <span class='nv'>birds_file</span><span class='o'>)</span>
</code></pre>

</div>

Now **(everybody)**, read in the bird data for this session...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>birds_file</span> <span class='o'>&lt;-</span> <span class='s'>'data/birds/backyard-birds_Ohio.tsv'</span>
<span class='nv'>birds</span> <span class='o'>&lt;-</span> <span class='nf'>read_tsv</span><span class='o'>(</span><span class='nv'>birds_file</span><span class='o'>)</span>

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

## Exercise 1

<div class="alert puzzle">

<div>

Reduce the backyard bird dataset and keep just the following columns: **species, locality, stateProvince, eventDate, species_en**

<details>
<summary>
Hints (click here)
</summary>

<br> Use `select()` to pull out the columns you want. <br>

</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

    birds <- birds %>% select(species, locality, stateProvince, eventDate, species_en)

</details>

</div>

</div>

------------------------------------------------------------------------

## Exercise 2

<div class="alert puzzle">

<div>

Check to make sure things look right - how many columns does the birds dataset now have?

<details>
<summary>
Hints (click here)
</summary>
<br> Use the [`dim()`](https://rdrr.io/r/base/dim.html) function. Or the [`ncol()`](https://rdrr.io/r/base/nrow.html) function. Or `glimpse()`. Or [`head()`](https://rdrr.io/r/utils/head.html). Or [`str()`](https://rdrr.io/r/utils/str.html). Or even [`summary()`](https://rdrr.io/r/base/summary.html). There's lots of ways to do this. <br>
</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 311441     12</span>
</code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

## Exercise 3

<div class="alert puzzle">

<div>

Now download and read in the new life history dataset (tab separated) available at <https://github.com/biodash/biodash.github.io/raw/master/assets/data/birds/esa_life_history_data_cc.tsv>. Then explore it a bit - how many rows and columns are there?

<details>
<summary>
Hints (click here)
</summary>
<br> Use the [`download.file()`](https://rdrr.io/r/utils/download.file.html) function like we did previously for the bird dataset. You'll need to define the arguments 'url' and 'destfile' inside the parentheses. You can put the file anywhere you want, but I'd suggest in the same directory as the bird file we got, so, for example, the destination file could be "data/birds/life_history_data.tsv". <br>
</details>
<details>
<summary>
Solution (click here)
</summary>

<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#download the file from online and save it as a '.tsv' file (since it's tab delimited)</span>
<span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='s'>"https://github.com/biodash/biodash.github.io/raw/master/assets/data/birds/esa_life_history_data_cc.tsv"</span>,
destfile <span class='o'>=</span> <span class='s'>"data/birds/life_history_data.tsv"</span><span class='o'>)</span>

<span class='c'>#read the data in to R as an object named 'life_hist'</span>
<span class='nv'>life_hist</span> <span class='o'>&lt;-</span> <span class='nf'>read_tsv</span><span class='o'>(</span>file <span class='o'>=</span> <span class='s'>"data/birds/life_history_data.tsv"</span><span class='o'>)</span>

<span class='c'>#&gt; Parsed with column specification:</span>
<span class='c'>#&gt; cols(</span>
<span class='c'>#&gt;   class = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   order = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   family = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   genus = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   species = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   common_name = <span style='color: #BB0000;'>col_character()</span><span>,</span></span>
<span class='c'>#&gt;   female_maturity_d = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   litter_or_clutch_size_n = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   litters_or_clutches_per_y = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   adult_body_mass_g = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   maximum_longevity_y = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   egg_mass_g = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   incubation_d = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   fledging_age_d = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   longevity_y = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   adult_svl_cm = <span style='color: #00BB00;'>col_double()</span></span>
<span class='c'>#&gt; )</span>


<span class='c'>#preview the data</span>
<span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>life_hist</span><span class='o'>)</span>

<span class='c'>#&gt; Rows: 21,322</span>
<span class='c'>#&gt; Columns: 16</span>
<span class='c'>#&gt; $ class                     <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Aves", "Aves", "Aves", "Aves", "Aves", "Av…</span></span>
<span class='c'>#&gt; $ order                     <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Accipitriformes", "Accipitriformes", "Acci…</span></span>
<span class='c'>#&gt; $ family                    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Accipitridae", "Accipitridae", "Accipitrid…</span></span>
<span class='c'>#&gt; $ genus                     <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Accipiter", "Accipiter", "Accipiter", "Acc…</span></span>
<span class='c'>#&gt; $ species                   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Accipiter albogularis", "Accipiter badius"…</span></span>
<span class='c'>#&gt; $ common_name               <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Pied Goshawk", "Shikra", "Bicolored Hawk",…</span></span>
<span class='c'>#&gt; $ female_maturity_d         <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, 363.468, NA, NA, 363.468, NA, NA, 547.8…</span></span>
<span class='c'>#&gt; $ litter_or_clutch_size_n   <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, 3.250, 2.700, NA, 4.000, NA, 2.700, 4.2…</span></span>
<span class='c'>#&gt; $ litters_or_clutches_per_y <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, 1, NA, NA, 1, NA, NA, 1, NA, 1, NA, 1, …</span></span>
<span class='c'>#&gt; $ adult_body_mass_g         <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 251.500, 140.000, 345.000, 142.000, 203.500…</span></span>
<span class='c'>#&gt; $ maximum_longevity_y       <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, 19.90000, NA, 2…</span></span>
<span class='c'>#&gt; $ egg_mass_g                <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, 21.00, 32.00, NA, 21.85, NA, 32.00, 19.…</span></span>
<span class='c'>#&gt; $ incubation_d              <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, 30.00, NA, NA, 32.50, NA, NA, 33.00, NA…</span></span>
<span class='c'>#&gt; $ fledging_age_d            <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, 32.00, NA, NA, 42.50, NA, NA, 24.25, NA…</span></span>
<span class='c'>#&gt; $ longevity_y               <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, 12.58333, NA, 1…</span></span>
<span class='c'>#&gt; $ adult_svl_cm              <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, 30.00, 39.50, NA, 33.50, NA, 39.50, 29.…</span></span>
</code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

## Exercise 4

<div class="alert puzzle">

<div>

This new dataset contains life history data for more than just birds. What Classes of organisms are represented in the 'Class' variable?

<details>
<summary>
Hints (click here)
</summary>
<br> Try using a combination of the `select()` and `distinct()` functions to pull out the column you're interested in, and then to get the distinct values, respectively. <br>
</details>
<details>
<summary>
Solutions (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>life_hist</span> <span class='o'>%&gt;%</span> <span class='nf'>select</span><span class='o'>(</span><span class='nv'>class</span><span class='o'>)</span> <span class='o'>%&gt;%</span> <span class='nf'>distinct</span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 3 x 1</span></span>
<span class='c'>#&gt;   class   </span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Aves    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Mammalia</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Reptilia</span></span>
</code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

## Exercise 5

<div class="alert puzzle">

<div>

Reduce the life history dataset down to keep just the rows for Class **Aves** and the columns **species, adult_body_mass_g, adult_svl_cm, longevity_y, litter_or_clutch_size_n**. What are the dimensions now?

<details>
<summary>
Hints (click here)
</summary>
Use [`filter()`](https://rdrr.io/r/stats/filter.html) along with an appropriate logical expression to keep the rows we want. Use `select()` to get the desired columns. <br>
</details>
<details>
<summary>
Solutions (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># pull out target rows and columns</span>
<span class='nv'>life_hist_aves</span> <span class='o'>&lt;-</span> <span class='nv'>life_hist</span> <span class='o'>%&gt;%</span> 
                  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>class</span> <span class='o'>==</span> <span class='s'>"Aves"</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
                  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>species</span>, <span class='nv'>adult_body_mass_g</span>, <span class='nv'>adult_svl_cm</span>, <span class='nv'>longevity_y</span>, <span class='nv'>litter_or_clutch_size_n</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span><span class='o'>(</span><span class='nv'>life_hist_aves</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 9802    5</span>
</code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

## Exercise 6

<div class="alert puzzle">

<div>

Preview each dataset again, just to make sure you're clear about what's in each one. Are there any columns that are shared between the two?

<details>
<summary>
Hints (click here)
</summary>

Consider `glimpse()` or [`head()`](https://rdrr.io/r/utils/head.html) to preview the datasets (tibbles/data frames). If you want to use a function to find shared columns, try a combination of [`intersect()`](https://rdrr.io/r/base/sets.html) and [`names()`](https://rdrr.io/r/base/names.html)

</details>
<details>
<summary>
Solutions (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>)</span>

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


<span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>life_hist_aves</span><span class='o'>)</span>

<span class='c'>#&gt; Rows: 9,802</span>
<span class='c'>#&gt; Columns: 5</span>
<span class='c'>#&gt; $ species                 <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Accipiter albogularis", "Accipiter badius", …</span></span>
<span class='c'>#&gt; $ adult_body_mass_g       <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 251.500, 140.000, 345.000, 142.000, 203.500, …</span></span>
<span class='c'>#&gt; $ adult_svl_cm            <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, 30.00, 39.50, NA, 33.50, NA, 39.50, 29.00…</span></span>
<span class='c'>#&gt; $ longevity_y             <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, 12.58333, NA, 12.…</span></span>
<span class='c'>#&gt; $ litter_or_clutch_size_n <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, 3.250, 2.700, NA, 4.000, NA, 2.700, 4.250…</span></span>


<span class='nf'><a href='https://rdrr.io/r/base/sets.html'>intersect</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/names.html'>names</a></span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>)</span>, <span class='nf'><a href='https://rdrr.io/r/base/names.html'>names</a></span><span class='o'>(</span><span class='nv'>life_hist_aves</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "species"</span>
</code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

## Exercise 7

<div class="alert puzzle">

<div>

Now lets join them together based on their shared variable. Not all species in the backyard bird (Ohio) dataset are included in the life history dataset. Likewise, there are life history data for many species that aren't in the Ohio dataset. We want to keep all the Ohio observations, and merge in life history data for species where it's availble, but we also don't want to add in life history data for species that aren't in the Ohio dataset. Choose an appropriate join function with those things in mind.

<details>
<summary>
Hints (click here)
</summary>

Try a `left_join()`, defining the Ohio backyard bird dataset as the 'x' dataset in the join and the life history data as the 'y' dataset. Get details on that function with `?left_join`. <br>

</details>
<details>
<summary>
Solutions (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>joined_data</span> <span class='o'>&lt;-</span> <span class='nf'>left_join</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>birds</span>, y <span class='o'>=</span> <span class='nv'>life_hist_aves</span>, by <span class='o'>=</span> <span class='s'>"species"</span><span class='o'>)</span>
</code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

## Exercise 8

<div class="alert puzzle">

<div>

What are the longest- and shortest-living bird species in Ohio based on the data in the longevity_y column?

<details>
<summary>
Hints (click here)
</summary>

Try using `select()` to pull out just the columns species and longevity_y, then use `distinct()` to get the unique rows, then `arrange()` based on the longevity_y column. You might also find the dplyr function `desc()` helpful.

Alternatively, you could try grouping by species, then use summarise() to get either the max, min, or mean value for longevity_y for each species (there's just one value for each species, so all of those statistics give the same value in this case). Then sort (arrange) the resulting summarized data frame on the longevity value.

<br>
</details>
<details>
<summary>
Solutions (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#option 1 - shortest-lived birds</span>
<span class='nv'>joined_data</span> <span class='o'>%&gt;%</span> <span class='nf'>select</span><span class='o'>(</span><span class='nv'>species</span>, <span class='nv'>longevity_y</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
                <span class='nf'>distinct</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
                <span class='nf'>arrange</span><span class='o'>(</span><span class='nv'>longevity_y</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 171 x 2</span></span>
<span class='c'>#&gt;    species              longevity_y</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                      </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> Loxia leucoptera            4   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> Spiza americana             4   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> Certhia americana           4.6 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> Acanthis hornemanni         4.6 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> Tringa flavipes             4.75</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> Podiceps grisegena          4.8 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> Calcarius lapponicus        5   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> Anthus rubescens            5.1 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> Perdix perdix               5.17</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> Regulus satrapa             5.32</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 161 more rows</span></span>


<span class='c'>#option 1 - longest-lived birds</span>
<span class='nv'>joined_data</span> <span class='o'>%&gt;%</span> <span class='nf'>select</span><span class='o'>(</span><span class='nv'>species</span>, <span class='nv'>longevity_y</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
                <span class='nf'>distinct</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
                <span class='nf'>arrange</span><span class='o'>(</span><span class='nf'>desc</span><span class='o'>(</span><span class='nv'>longevity_y</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 171 x 2</span></span>
<span class='c'>#&gt;    species                  longevity_y</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                          </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> Larus argentatus                33.4</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> Larus glaucoides                33  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> Larus thayeri                   33  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> Haliaeetus leucocephalus        33.0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> Larus fuscus                    32.8</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> Aquila chrysaetos               32  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> Anas platyrhynchos              29  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> Larus delawarensis              28.6</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> Asio otus                       27.8</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> Cygnus olor                     27.7</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 161 more rows</span></span>


<span class='c'>#option 2 - shortest-lived birds</span>
<span class='nv'>joined_data</span> <span class='o'>%&gt;%</span> <span class='nf'>group_by</span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
                <span class='nf'>summarise</span><span class='o'>(</span>longevity <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='o'>(</span><span class='nv'>longevity_y</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
                <span class='nf'>arrange</span><span class='o'>(</span><span class='nv'>longevity</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 171 x 2</span></span>
<span class='c'>#&gt;    species              longevity</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                    </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> Loxia leucoptera          4   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> Spiza americana           4   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> Acanthis hornemanni       4.6 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> Certhia americana         4.6 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> Tringa flavipes           4.75</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> Podiceps grisegena        4.8 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> Calcarius lapponicus      5   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> Anthus rubescens          5.1 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> Perdix perdix             5.17</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> Regulus satrapa           5.32</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 161 more rows</span></span>

    
<span class='c'>#option 2 - longest-lived birds</span>
<span class='nv'>joined_data</span> <span class='o'>%&gt;%</span> <span class='nf'>group_by</span><span class='o'>(</span><span class='nv'>species</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
                <span class='nf'>summarise</span><span class='o'>(</span>longevity <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='o'>(</span><span class='nv'>longevity_y</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
                <span class='nf'>arrange</span><span class='o'>(</span><span class='nf'>desc</span><span class='o'>(</span><span class='nv'>longevity</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 171 x 2</span></span>
<span class='c'>#&gt;    species                  longevity</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                        </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> Larus argentatus              33.4</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> Larus glaucoides              33  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> Larus thayeri                 33  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> Haliaeetus leucocephalus      33.0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> Larus fuscus                  32.8</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> Aquila chrysaetos             32  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> Anas platyrhynchos            29  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> Larus delawarensis            28.6</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> Asio otus                     27.8</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> Cygnus olor                   27.7</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 161 more rows</span></span>
</code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

## Bonus time!

## Bonus 1

<div class="alert puzzle">

<div>

What species in Ohio has the largest ratio of adult body mass to length (measured as snout vent length, or 'adult_svl_cm')?

<details>
<summary>
Hints (click here)
</summary>

Use mutate() to create a new variable containing the body mass divided by svl, then arrange the dataset using that new variable to get the species with the highest value.

</details>
<details>
<summary>
Solutions (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>joined_data</span> <span class='o'>%&gt;%</span> <span class='nf'>mutate</span><span class='o'>(</span>ratio <span class='o'>=</span> <span class='nv'>adult_body_mass_g</span><span class='o'>/</span><span class='nv'>adult_svl_cm</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
                <span class='nf'>select</span><span class='o'>(</span><span class='nv'>species_en</span>, <span class='nv'>ratio</span><span class='o'>)</span> <span class='o'>%&gt;%</span> <span class='nf'>distinct</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
                <span class='nf'>arrange</span><span class='o'>(</span><span class='nf'>desc</span><span class='o'>(</span><span class='nv'>ratio</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 170 x 2</span></span>
<span class='c'>#&gt;    species_en     ratio</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>          </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> Mute Swan       71.8</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> Wild Turkey     68.0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> Trumpeter Swan  64.9</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> Bald Eagle      59.2</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> Golden Eagle    56.2</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> Canada Goose    48.3</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> Tundra Swan     47.0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> Cackling Goose  44.4</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> Snow Goose      35.1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> Snowy Owl       32.8</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 160 more rows</span></span>
</code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

### Bonus 2

<div class="alert puzzle">

<div>

There are 2 additional joins we haven't talked about - semi_join() and anti_join(). Take a look at the documentation to see what these do. Use one of them to find what species in the backyard birds dataset are not in the life history dataset.

<details>
<summary>
Hints (click here)
</summary>

Use anti_join() and distinct().

</details>
<details>
<summary>
Solutions (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>anti_join</span><span class='o'>(</span><span class='nv'>birds</span>, <span class='nv'>life_hist_aves</span>, by <span class='o'>=</span> <span class='s'>"species"</span><span class='o'>)</span> <span class='o'>%&gt;%</span> <span class='nf'>select</span><span class='o'>(</span><span class='nv'>species</span>, <span class='nv'>species_en</span><span class='o'>)</span> <span class='o'>%&gt;%</span>
                                                     <span class='nf'>distinct</span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 2</span></span>
<span class='c'>#&gt;   species                       species_en           </span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                         </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Dendrocopos pubescens         Downy Woodpecker     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Spizelloides arborea          American Tree Sparrow</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Otus asio                     Eastern Screech Owl  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Larus minutus                 Little Gull          </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> Anas rubripes x platyrhynchos </span><span style='color: #BB0000;'>NA</span><span>                   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> </span><span style='color: #BB0000;'>NA</span><span>                            </span><span style='color: #BB0000;'>NA</span></span>
</code></pre>

</div>

</details>

</div>

</div>

------------------------------------------------------------------------

## Bonus 3

<div class="alert puzzle">

<div>

The life history dataset we downloaded above is actually a modified version of the original file, which is located at '<http://www.esapubs.org/archive/ecol/E096/269/Data_Files/Amniote_Database_Aug_2015.csv>'

Try starting with the original file and repeating what we did above - merging the variables **species, adult_body_mass_g, adult_svl_cm, longevity_y, litter_or_clutch_size_n** in to the original birds dataset. First, make sure to get it read in correctly. Then pay attention to the species column in the life history dataset - what needs to be done before a join/merge can be performed?

<details>
<summary>
Hints (click here)
</summary>

Pay attention to how missing data are coded in this dataset (it's -999). Also, data are very sparse for some of the variables - in other words, they have lots of missing data. This seems to cause a problem with the read_csv function, as it only considers the first 1000 rows for the purpose of defining the class of each column. This can be a problem if all of the first 1000 rows are missing. Finally, it appears that even though this is a comma separated file (commas define the column breaks), there are a few instances where commas are used within a field. This happens in the 'common name' column in a few cases where multiple common names are listed for a specific observation. This is one example of something that can become quite frustrating when trying to get data loaded in, and is worth keeping an eye out for. Fortunately, in our case, it only seems to happen for non-bird species in this dataset, which we filter out anyway, so it can be dealt with. However, if it had impacted any of the bird observations, I think fixing this might require a solution outside of R - possibly a command line approach.

<br>

</details>
<details>
<summary>
Solutions (click here)
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#download</span>
<span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='s'>"http://www.esapubs.org/archive/ecol/E096/269/Data_Files/Amniote_Database_Aug_2015.csv"</span>, 
destfile <span class='o'>=</span> <span class='s'>"data/birds/orig_life_history.csv"</span><span class='o'>)</span>

<span class='c'>#read the data in to R as an object named 'full_life_hist'</span>

<span class='nv'>full_life_hist</span> <span class='o'>&lt;-</span> <span class='nf'>read_csv</span><span class='o'>(</span><span class='s'>"data/birds/orig_life_history.csv"</span>, 
                  na <span class='o'>=</span> <span class='s'>"-999"</span>, 
                  col_types <span class='o'>=</span> <span class='nf'>cols</span><span class='o'>(</span>birth_or_hatching_svl_cm <span class='o'>=</span> <span class='nf'>col_double</span><span class='o'>(</span><span class='o'>)</span>,
                  weaning_d <span class='o'>=</span> <span class='nf'>col_double</span><span class='o'>(</span><span class='o'>)</span>,gestation_d <span class='o'>=</span> <span class='nf'>col_double</span><span class='o'>(</span><span class='o'>)</span>, 
                  weaning_weight_g <span class='o'>=</span> <span class='nf'>col_double</span><span class='o'>(</span><span class='o'>)</span>, 
                  male_svl_cm <span class='o'>=</span> <span class='nf'>col_double</span><span class='o'>(</span><span class='o'>)</span>, 
                  female_svl_cm <span class='o'>=</span> <span class='nf'>col_double</span><span class='o'>(</span><span class='o'>)</span>,
                  no_sex_svl_cm <span class='o'>=</span> <span class='nf'>col_double</span><span class='o'>(</span><span class='o'>)</span>, 
                  female_body_mass_at_maturity_g <span class='o'>=</span> <span class='nf'>col_double</span><span class='o'>(</span><span class='o'>)</span>,
                  female_svl_at_maturity_cm <span class='o'>=</span> <span class='nf'>col_double</span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span>

<span class='c'>#get the original version of the birds dataset</span>
<span class='nv'>birds</span> <span class='o'>&lt;-</span> <span class='nf'>read_tsv</span><span class='o'>(</span><span class='s'>'data/birds/backyard-birds_Ohio.tsv'</span><span class='o'>)</span>

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


<span class='c'>#subset each for the columns and rows we want</span>
<span class='nv'>life_hist_aves</span> <span class='o'>&lt;-</span> <span class='nv'>full_life_hist</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>class</span> <span class='o'>==</span> <span class='s'>"Aves"</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
                  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>species</span>, <span class='nv'>adult_body_mass_g</span>, <span class='nv'>adult_svl_cm</span>, <span class='nv'>longevity_y</span>, <span class='nv'>litter_or_clutch_size_n</span><span class='o'>)</span>

<span class='nv'>birds</span> <span class='o'>&lt;-</span> <span class='nv'>birds</span> <span class='o'>%&gt;%</span> <span class='nf'>select</span><span class='o'>(</span><span class='nv'>species</span>, <span class='nv'>locality</span>, <span class='nv'>stateProvince</span>, <span class='nv'>eventDate</span>, <span class='nv'>species_en</span><span class='o'>)</span>

<span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>)</span>

<span class='c'>#&gt; Rows: 311,441</span>
<span class='c'>#&gt; Columns: 5</span>
<span class='c'>#&gt; $ species       <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Cyanocitta cristata", "Cyanocitta cristata", "Cyanocit…</span></span>
<span class='c'>#&gt; $ locality      <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "44805 Ashland", "45244 Cincinnati", "44132 Euclid", "4…</span></span>
<span class='c'>#&gt; $ stateProvince <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Ohio", "Ohio", "Ohio", "Ohio", "Ohio", "Ohio", "Ohio",…</span></span>
<span class='c'>#&gt; $ eventDate     <span style='color: #555555;font-style: italic;'>&lt;dttm&gt;</span><span> 2007-02-16, 2007-02-17, 2007-02-17, 2007-02-19, 2007-0…</span></span>
<span class='c'>#&gt; $ species_en    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Blue Jay", "Blue Jay", "Blue Jay", "Blue Jay", "Blue J…</span></span>


<span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>life_hist_aves</span><span class='o'>)</span>

<span class='c'>#&gt; Rows: 9,802</span>
<span class='c'>#&gt; Columns: 5</span>
<span class='c'>#&gt; $ species                 <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "albogularis", "badius", "bicolor", "brachyur…</span></span>
<span class='c'>#&gt; $ adult_body_mass_g       <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 251.500, 140.000, 345.000, 142.000, 203.500, …</span></span>
<span class='c'>#&gt; $ adult_svl_cm            <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, 30.00, 39.50, NA, 33.50, NA, 39.50, 29.00…</span></span>
<span class='c'>#&gt; $ longevity_y             <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, 12.58333, NA, 12.…</span></span>
<span class='c'>#&gt; $ litter_or_clutch_size_n <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, 3.250, 2.700, NA, 4.000, NA, 2.700, 4.250…</span></span>


<span class='c'>#notice the species column in the life history data doesn't include the genus name. Since the names don't match in the species column from each dataset, a join won't work. Add the genus variable in from the original life history data...</span>

<span class='nv'>life_hist_aves</span> <span class='o'>&lt;-</span> <span class='nv'>full_life_hist</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>class</span> <span class='o'>==</span> <span class='s'>"Aves"</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
                  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>genus</span>, <span class='nv'>species</span>, <span class='nv'>adult_body_mass_g</span>, <span class='nv'>adult_svl_cm</span>, <span class='nv'>longevity_y</span>, <span class='nv'>litter_or_clutch_size_n</span><span class='o'>)</span>

<span class='c'>#now use mutate to replace the species column so it includes both the genus and species...</span>

<span class='nv'>life_hist_aves</span> <span class='o'>&lt;-</span> <span class='nv'>life_hist_aves</span> <span class='o'>%&gt;%</span> <span class='nf'>mutate</span><span class='o'>(</span>species <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/paste.html'>paste0</a></span><span class='o'>(</span><span class='nv'>genus</span>, <span class='s'>" "</span>, <span class='nv'>species</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span> <span class='nf'>select</span><span class='o'>(</span><span class='o'>-</span><span class='nv'>genus</span><span class='o'>)</span>

<span class='c'>#preview again</span>
<span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>birds</span><span class='o'>)</span>

<span class='c'>#&gt; Rows: 311,441</span>
<span class='c'>#&gt; Columns: 5</span>
<span class='c'>#&gt; $ species       <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Cyanocitta cristata", "Cyanocitta cristata", "Cyanocit…</span></span>
<span class='c'>#&gt; $ locality      <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "44805 Ashland", "45244 Cincinnati", "44132 Euclid", "4…</span></span>
<span class='c'>#&gt; $ stateProvince <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Ohio", "Ohio", "Ohio", "Ohio", "Ohio", "Ohio", "Ohio",…</span></span>
<span class='c'>#&gt; $ eventDate     <span style='color: #555555;font-style: italic;'>&lt;dttm&gt;</span><span> 2007-02-16, 2007-02-17, 2007-02-17, 2007-02-19, 2007-0…</span></span>
<span class='c'>#&gt; $ species_en    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Blue Jay", "Blue Jay", "Blue Jay", "Blue Jay", "Blue J…</span></span>

<span class='nf'>glimpse</span><span class='o'>(</span><span class='nv'>life_hist_aves</span><span class='o'>)</span>

<span class='c'>#&gt; Rows: 9,802</span>
<span class='c'>#&gt; Columns: 5</span>
<span class='c'>#&gt; $ species                 <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Accipiter albogularis", "Accipiter badius", …</span></span>
<span class='c'>#&gt; $ adult_body_mass_g       <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 251.500, 140.000, 345.000, 142.000, 203.500, …</span></span>
<span class='c'>#&gt; $ adult_svl_cm            <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, 30.00, 39.50, NA, 33.50, NA, 39.50, 29.00…</span></span>
<span class='c'>#&gt; $ longevity_y             <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, NA, NA, NA, NA, NA, NA, 12.58333, NA, 12.…</span></span>
<span class='c'>#&gt; $ litter_or_clutch_size_n <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> NA, 3.250, 2.700, NA, 4.000, NA, 2.700, 4.250…</span></span>


<span class='c'>#now we can join</span>
<span class='nv'>joined_data</span> <span class='o'>&lt;-</span> <span class='nf'>left_join</span><span class='o'>(</span><span class='nv'>birds</span>, <span class='nv'>life_hist_aves</span>, by <span class='o'>=</span> <span class='s'>"species"</span><span class='o'>)</span>
</code></pre>

</div>

</details>

<br>

</div>

</div>

------------------------------------------------------------------------

<br> <br> <br> <br>

