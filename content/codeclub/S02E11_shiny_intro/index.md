---
title: 'Code Club S02E11: Shiny Bright Like a Diamond'
subtitle: 'An Introduction to ShinyR'
author: "Matt Teegarden"
date: "2021-11-30"
output: hugodown::md_document
toc: true
rmd_hash: cdd01cc360a195a0

---

<br>

<div class="alert alert-note">

<div>

**What will we go over today**

-   What is Shiny, and why would I want to use it?
-   Understanding the principles of user interfaces and servers
-   The structure of a basic Shiny app

</div>

</div>

<br>

------------------------------------------------------------------------

## Interactive Applications with R

Shiny is a package that builds interactive html-based applications using the R coding language and capabilities.

The goal of this session is to provide a basic introduction to the structure of simple Shiny apps. For more detailed information as you work to build more complicated apps, I recommend you reference the [Shiny tutorial page](https://shiny.rstudio.com/tutorial/).

The code for a Shiny app contains three main parts.

1.  A section defining the user interface (UI)
2.  A section defining the server
3.  A piece of code that combines the UI and server sections

Let's talk through some examples to illustrate what a UI and server are.

### A Conceptual Example

Imagine you are in need for directions from Columbus, OH to Wooster, OH.

You decide to use a website such as Google maps to give you precise directions for the quickest route.

You, the user, type in your location (Columbus) and your destination (Wooster), and as if by magic, turn-by-turn directions pop up on your screen.

Everything you have just interacted with and experienced is the **User Interface** of the maps application. Think of this as the front-end of the application.

The **Server** is everything going on behind the scenes- the lines of code and calculations- invisible to the user- that take the user input and produce the results that are then presented back to the user.

### A more grounded example

The OSU Infectious Disease Institute maintains a webapp that tracked COVID-19 statistics in Ohio from March 2020 to March 2021. Click or navigate to: <https://covidmap.osu.edu/>

This is a nice demonstration of a "data dashboard", which is a very common use of the Shiny package.

It provides a way for a user of virtually any skill level to interact with their COVID-19 data set. It may look very fancy, but it was all put together using Shiny and many R commands you already know.

What function would the app use to pair down the data to the selected date range? What R package are they using the plot the daily counts of new cases?

You can apply what you have already learned in code club to make a fancy, interactive web app for your own data sets!

We just need to learn how to code R within the Shiny environment.

### Let's start with a simple Shiny app

First, take a second to install Shiny, and for the purpose of our demonstration today, I recommend you also pre-load the tidyverse (I am assuming you already have that installed)

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"shiny"</span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://shiny.rstudio.com/'>shiny</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span></code></pre>

</div>

You can use a common structure to set up the basic parts of almost any shiny app. Below you will see that we are creating an object for the UI, another for the server, and then we combine them with the `shinyApp` call. Before we start building the app, we need to tell it where to live on our computer.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>ui</span> <span class='o'>&lt;-</span> <span class='nv'>...</span>

<span class='nv'>server</span> <span class='o'>&lt;-</span> <span class='nv'>...</span>

<span class='nf'><a href='https://rdrr.io/pkg/shiny/man/shinyApp.html'>shinyApp</a></span><span class='o'>(</span>ui <span class='o'>=</span> <span class='nv'>ui</span>, server <span class='o'>=</span> <span class='nv'>server</span><span class='o'>)</span></code></pre>

</div>

Inside your directory for code club, create a folder for this week. In this folder, save a new R script with the name app.R

Shiny uses the directory as a sort of bundle to run your app from. The name of your directory is the name of the app, the app.R file is the code, and there are other file types (with specific names) that you can add to the directory later as your app gets more complicated.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>"S02E12"</span><span class='o'>)</span></code></pre>

</div>

## Let's make an app!

We are going to start simple, using a data set about large pumpkins, squashes, and tomatoes.

First, let's download the data and do a little cleanup.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#download the dataframe from github. This data can also be found in the `tidytuesdayR` package. </span>
<span class='nv'>pumpkins</span> <span class='o'>&lt;-</span> <span class='nf'>readr</span><span class='nf'>::</span><span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_csv</a></span><span class='o'>(</span><span class='s'>'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-10-19/pumpkins.csv'</span><span class='o'>)</span>

<span class='c'>#the year and type of crop are combined into a single column, separated by a "-". Need to split.</span>
<span class='c'>#also, there are some rows in the data frame that contain information about the number of entries</span>
<span class='c'>#need to remove these interceding rows</span>

<span class='nv'>pumpkins</span> <span class='o'>&lt;-</span> <span class='nv'>pumpkins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='c'>#separate the year column</span>
  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/separate.html'>separate</a></span><span class='o'>(</span>col <span class='o'>=</span> <span class='nv'>id</span>, into <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"year"</span>, <span class='s'>"vegetable"</span><span class='o'>)</span>, sep <span class='o'>=</span> <span class='s'>"-"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='c'>#find and tag the rows that do not have data</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>delete <span class='o'>=</span> <span class='nf'><a href='https://stringr.tidyverse.org/reference/str_detect.html'>str_detect</a></span><span class='o'>(</span><span class='nv'>place</span>, <span class='s'>"\\d*\\s*Entries"</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='c'>#filter out the rows that do not have data</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>delete</span><span class='o'>==</span><span class='kc'>FALSE</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='c'>#remove the tagging column</span>
  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='o'>-</span><span class='nv'>delete</span><span class='o'>)</span>

<span class='c'>#Rename the vegetables to their actual names</span>
<span class='nv'>pumpkins</span><span class='o'>$</span><span class='nv'>vegetable</span> <span class='o'>&lt;-</span> <span class='nv'>pumpkins</span><span class='o'>$</span><span class='nv'>vegetable</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://stringr.tidyverse.org/reference/str_replace.html'>str_replace</a></span><span class='o'>(</span><span class='s'>"^F$"</span>, <span class='s'>"Field Pumpkin"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://stringr.tidyverse.org/reference/str_replace.html'>str_replace</a></span><span class='o'>(</span><span class='s'>"^P$"</span>, <span class='s'>"Giant Pumpkin"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://stringr.tidyverse.org/reference/str_replace.html'>str_replace</a></span><span class='o'>(</span><span class='s'>"^S$"</span>, <span class='s'>"Giant Squash"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://stringr.tidyverse.org/reference/str_replace.html'>str_replace</a></span><span class='o'>(</span><span class='s'>"^W$"</span>, <span class='s'>"Giant Watermelon"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://stringr.tidyverse.org/reference/str_replace.html'>str_replace</a></span><span class='o'>(</span><span class='s'>"^L$"</span>, <span class='s'>"Long Gourd"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
  <span class='nf'><a href='https://stringr.tidyverse.org/reference/str_replace.html'>str_replace</a></span><span class='o'>(</span><span class='s'>"^T$"</span>, <span class='s'>"Tomato"</span><span class='o'>)</span>

<span class='c'>#get rid of commas in the weight_lbs column</span>
<span class='nv'>pumpkins</span><span class='o'>$</span><span class='nv'>weight_lbs</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/numeric.html'>as.numeric</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/grep.html'>gsub</a></span><span class='o'>(</span><span class='s'>","</span>,<span class='s'>""</span>,<span class='nv'>pumpkins</span><span class='o'>$</span><span class='nv'>weight_lbs</span><span class='o'>)</span><span class='o'>)</span>
  
<span class='c'>#look at the data structure</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>pumpkins</span><span class='o'>)</span>
  </code></pre>

</div>

### User Interface

Now that we have our data sorted out, let's start building out our user interface

The UI portion of your code is where you will define the appearance and physical layout of your app, and in Shiny, layouts are commonly defined using [`fluidPage()`](https://rdrr.io/pkg/shiny/man/fluidPage.html). Fluid pages scale to fill the available window size of your browser, and are formatted to a grid with 12 equally spaced columns and as many rows of equal height that you need for your app. Within the \`fluidPage()' command, you define how different components of your app physically fit within the browser window.

There are some handy pre-sets that we can use to build an app more quickly, but just know that the interface you build is *very* customizable with enough effort. For the purpose of this demonstration, we will use the preset commands that define a `sidebarPanel()` for user inputs and a \`mainPanel()' for data output.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>ui</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/fluidPage.html'>fluidPage</a></span><span class='o'>(</span>
  <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/sidebarLayout.html'>sidebarPanel</a></span><span class='o'>(</span>
    
  <span class='o'>)</span>,
  <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/sidebarLayout.html'>mainPanel</a></span><span class='o'>(</span>
    
  <span class='o'>)</span>
<span class='o'>)</span>

<span class='nv'>server</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>input</span>,<span class='nv'>output</span><span class='o'>)</span><span class='o'>&#123;</span>
<span class='o'>&#125;</span>

<span class='nf'><a href='https://rdrr.io/pkg/shiny/man/shinyApp.html'>shinyApp</a></span><span class='o'>(</span>ui<span class='o'>=</span><span class='nv'>ui</span>,server<span class='o'>=</span><span class='nv'>server</span><span class='o'>)</span></code></pre>

</div>

This is the basic layout of our app. It may read a little funny because I am leaving space to put in different components.

Now, back to our example dataset. The World Pumpkin Committee is very interested in being able to view the weight distribution of each vegetable by year. Let's make them an app for that!

We will add a place for them to select the year in [`sidebarPanel()`](https://rdrr.io/pkg/shiny/man/sidebarLayout.html) Shiny has a number of data input options. The one you pick, will depend on what information you want to get from the user. No matter the input, you will need to specify the `InputID`. This piece of information is very important, as it is how the server references the inputs in the UI.

For this example, we have a defined set of inputs (this competition has only been going on for a set number of years), so we will use [`selectInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html). We will also define the choices as the years avilable in our dataset.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>ui</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/fluidPage.html'>fluidPage</a></span><span class='o'>(</span>
  <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/sidebarLayout.html'>sidebarPanel</a></span><span class='o'>(</span>
    <span class='c'>#here we are naming the input as 'year', the box will display 'Select Year', and </span>
    <span class='c'>#the user will choose from the competition years as referenced from the </span>
    <span class='c'>#pumpkins dataframe</span>
    <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/selectInput.html'>selectInput</a></span><span class='o'>(</span>inputId <span class='o'>=</span> <span class='s'>"year"</span>, label <span class='o'>=</span> <span class='s'>"Select Year"</span>, choices <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/unique.html'>unique</a></span><span class='o'>(</span><span class='nv'>pumpkins</span><span class='o'>$</span><span class='nv'>year</span><span class='o'>)</span><span class='o'>)</span>
    
  <span class='o'>)</span>,
  <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/sidebarLayout.html'>mainPanel</a></span><span class='o'>(</span>
    
  <span class='o'>)</span>
<span class='o'>)</span>

<span class='nv'>server</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>input</span>,<span class='nv'>output</span><span class='o'>)</span><span class='o'>&#123;</span>
<span class='o'>&#125;</span>

<span class='nf'><a href='https://rdrr.io/pkg/shiny/man/shinyApp.html'>shinyApp</a></span><span class='o'>(</span>ui<span class='o'>=</span><span class='nv'>ui</span>,server<span class='o'>=</span><span class='nv'>server</span><span class='o'>)</span></code></pre>

</div>

We now have the input side of our UI, but we also need to define what and where our output will be by essentially adding a placeholder for our output. There are many options in Shiny, but we will be using a [`plotOutput()`](https://rdrr.io/pkg/shiny/man/plotOutput.html) for this example. The main thing that needs to be set is the `OutputID`. Similar to the `InputID`, this tells the server where to place our results.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>ui</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/fluidPage.html'>fluidPage</a></span><span class='o'>(</span>
  <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/sidebarLayout.html'>sidebarPanel</a></span><span class='o'>(</span>
    <span class='c'>#here we are naming the input as 'year', the box will display 'Select Year', and </span>
    <span class='c'>#the user will choose from the competition years as referenced from the </span>
    <span class='c'>#pumpkins dataframe</span>
    <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/selectInput.html'>selectInput</a></span><span class='o'>(</span>inputId <span class='o'>=</span> <span class='s'>"year"</span>, label <span class='o'>=</span> <span class='s'>"Select Year"</span>, choices <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/unique.html'>unique</a></span><span class='o'>(</span><span class='nv'>pumpkins</span><span class='o'>$</span><span class='nv'>year</span><span class='o'>)</span><span class='o'>)</span>
    
  <span class='o'>)</span>,
  <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/sidebarLayout.html'>mainPanel</a></span><span class='o'>(</span>
    <span class='c'>#placeholder for a plot to generate</span>
    <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/plotOutput.html'>plotOutput</a></span><span class='o'>(</span>outputId <span class='o'>=</span> <span class='s'>"weight_distribution"</span><span class='o'>)</span>
    
  <span class='o'>)</span>
<span class='o'>)</span>
<span class='nv'>server</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>input</span>,<span class='nv'>output</span><span class='o'>)</span><span class='o'>&#123;</span>
<span class='o'>&#125;</span>

<span class='nf'><a href='https://rdrr.io/pkg/shiny/man/shinyApp.html'>shinyApp</a></span><span class='o'>(</span>ui<span class='o'>=</span><span class='nv'>ui</span>,server<span class='o'>=</span><span class='nv'>server</span><span class='o'>)</span></code></pre>

</div>

Run this whole chunk of code. Notice you will create a `ui` object and a `server` function that are combined with `shinyApp`. Once you run that last piece, a built in web browser will appear and run your app.

When you are not using the app, be sure to fully exit the browser window, otherwise it will keep running in the background.

### Server

Now that we have our UI built, let's move on to the server. This is where you will code what R should do with inputs from the UI side and how results should be presented to the user.

Notice the server is built as a `function()` with `input` and `output` objects.

For our example. we basically want to use the `inputID` "year" to filter our list, then we want to plot the weight distribution of each vegetable.This is done using code you are likely already familiar with.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>ui</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/fluidPage.html'>fluidPage</a></span><span class='o'>(</span>
  <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/sidebarLayout.html'>sidebarPanel</a></span><span class='o'>(</span>
    <span class='c'>#here we are naming the input as 'year', the box will display 'Select year', and </span>
    <span class='c'>#the user will choose from the competition years as referenced from the </span>
    <span class='c'>#pumpkins dataframe</span>
    <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/selectInput.html'>selectInput</a></span><span class='o'>(</span>inputId <span class='o'>=</span> <span class='s'>"year"</span>, label <span class='o'>=</span> <span class='s'>"Select Year"</span>, choices <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/unique.html'>unique</a></span><span class='o'>(</span><span class='nv'>pumpkins</span><span class='o'>$</span><span class='nv'>year</span><span class='o'>)</span><span class='o'>)</span>
    
  <span class='o'>)</span>,
  <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/sidebarLayout.html'>mainPanel</a></span><span class='o'>(</span>
     <span class='c'>#placeholder for a plot to generate</span>
    <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/plotOutput.html'>plotOutput</a></span><span class='o'>(</span>outputId <span class='o'>=</span> <span class='s'>"weight_distribution"</span><span class='o'>)</span>
  <span class='o'>)</span>
<span class='o'>)</span>

<span class='nv'>server</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>input</span>,<span class='nv'>output</span><span class='o'>)</span><span class='o'>&#123;</span>
  <span class='c'>#notice the callback to our outputID</span>
  <span class='nv'>output</span><span class='o'>$</span><span class='nv'>weight_distribution</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/renderPlot.html'>renderPlot</a></span><span class='o'>(</span>
    <span class='nv'>pumpkins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
      <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>year</span><span class='o'>==</span><span class='nv'>input</span><span class='o'>$</span><span class='nv'>year</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
      <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span><span class='nv'>vegetable</span>, <span class='nv'>weight_lbs</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
      <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_boxplot.html'>geom_boxplot</a></span><span class='o'>(</span><span class='o'>)</span>
  <span class='o'>)</span>
<span class='o'>&#125;</span>

<span class='nf'><a href='https://rdrr.io/pkg/shiny/man/shinyApp.html'>shinyApp</a></span><span class='o'>(</span>ui<span class='o'>=</span><span class='nv'>ui</span>,server<span class='o'>=</span><span class='nv'>server</span><span class='o'>)</span></code></pre>

</div>

Notice how the `outputID` from the `ui` section is referenced as `output$weight_distribution` on the server side. Do you see where our `inputID` is referenced on the server side?

Also notice how the code is wrapped within a `renderPlot` command. This is a special Shiny command specific to plot outputs. There are other commands for other types of outputs, such as `renderTable` for table outputs.

These commands are also special because they are "reactive", meaning they react to changes in user inputs and re-execute the code when those changes occur. This is a simple explanation of a somewhat complex topic. For a more in-depth explanation, see [this explanation](https://shiny.rstudio.com/articles/understanding-reactivity.html).

Re-run the code, and you should now see a plot that will respond to changes in the year input box.

## Exercise 1

<div class="alert puzzle">

<div>

Now it is your turn to add on to the app. The World Pumpkin Committee would like to also have the app generate a table that contains the weight, grower name, city, and state/province of each first place vegetable for the year selected in the input.

**Bonus** Explore `renderTable` to see how you can change the number of significant figures displayed.

<details>
<summary>
Hints (click here)
</summary>

<br> Focus on the server side of the app, you already have the input from the UI that you need. Use [`renderTable()`](https://rdrr.io/pkg/shiny/man/renderTable.html).

<br>
</details>
<details>
<summary>
Solution (click here)
</summary>
<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>ui</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/fluidPage.html'>fluidPage</a></span><span class='o'>(</span>
  <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/sidebarLayout.html'>sidebarPanel</a></span><span class='o'>(</span>
    <span class='c'>#here we are naming the input as 'year', the box will display 'Select year', and </span>
    <span class='c'>#the user will choose from the competition years as referenced from the </span>
    <span class='c'>#pumpkins dataframe</span>
    <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/selectInput.html'>selectInput</a></span><span class='o'>(</span>inputId <span class='o'>=</span> <span class='s'>"year"</span>, label <span class='o'>=</span> <span class='s'>"Select Year"</span>, choices <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/unique.html'>unique</a></span><span class='o'>(</span><span class='nv'>pumpkins</span><span class='o'>$</span><span class='nv'>year</span><span class='o'>)</span><span class='o'>)</span>
    
  <span class='o'>)</span>,
  <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/sidebarLayout.html'>mainPanel</a></span><span class='o'>(</span>
     <span class='c'>#placeholder for a plot to generate</span>
    <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/plotOutput.html'>plotOutput</a></span><span class='o'>(</span>outputId <span class='o'>=</span> <span class='s'>"weight_distribution"</span><span class='o'>)</span>,
    <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/tableOutput.html'>tableOutput</a></span><span class='o'>(</span>outputId <span class='o'>=</span> <span class='s'>"winner_table"</span><span class='o'>)</span>
  <span class='o'>)</span>
<span class='o'>)</span>

<span class='nv'>server</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>input</span>,<span class='nv'>output</span><span class='o'>)</span><span class='o'>&#123;</span>
  <span class='c'>#notice the callback to our outputID</span>
  <span class='nv'>output</span><span class='o'>$</span><span class='nv'>weight_distribution</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/renderPlot.html'>renderPlot</a></span><span class='o'>(</span>
    <span class='nv'>pumpkins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
      <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>year</span><span class='o'>==</span><span class='nv'>input</span><span class='o'>$</span><span class='nv'>year</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
      <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span><span class='nv'>vegetable</span>, <span class='nv'>weight_lbs</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
      <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_boxplot.html'>geom_boxplot</a></span><span class='o'>(</span><span class='o'>)</span>
  <span class='o'>)</span>
  <span class='c'>#create the output for the table using renderTable</span>
  <span class='nv'>output</span><span class='o'>$</span><span class='nv'>winner_table</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/renderTable.html'>renderTable</a></span><span class='o'>(</span>
    <span class='nv'>pumpkins</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
      <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>year</span><span class='o'>==</span><span class='nv'>input</span><span class='o'>$</span><span class='nv'>year</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
      <span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>place</span> <span class='o'>==</span> <span class='s'>"1"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
      <span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span><span class='nv'>vegetable</span>, <span class='nv'>weight_lbs</span>, <span class='nv'>grower_name</span>, <span class='nv'>city</span>, <span class='nv'>state_prov</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>
      <span class='c'>#I just wanted to rename the columns to look nicer</span>
      <span class='nf'><a href='https://dplyr.tidyverse.org/reference/rename.html'>rename</a></span><span class='o'>(</span><span class='s'>"weight (lbs)"</span><span class='o'>=</span><span class='nv'>weight_lbs</span>, <span class='s'>"grower name"</span><span class='o'>=</span><span class='nv'>grower_name</span>, <span class='s'>"state/provice"</span><span class='o'>=</span><span class='nv'>state_prov</span><span class='o'>)</span>,
    <span class='c'>#setting significant figures as an option under renderTable</span>
    digits <span class='o'>=</span> <span class='m'>1</span>,
    <span class='c'>#adding a caption to be fancy</span>
    caption <span class='o'>=</span> <span class='s'>"Table of Winners"</span>,
    caption.placement <span class='o'>=</span> <span class='s'>"top"</span>
  <span class='o'>)</span>
<span class='o'>&#125;</span>

<span class='nf'><a href='https://rdrr.io/pkg/shiny/man/shinyApp.html'>shinyApp</a></span><span class='o'>(</span>ui<span class='o'>=</span><span class='nv'>ui</span>,server<span class='o'>=</span><span class='nv'>server</span><span class='o'>)</span></code></pre>

</div>

</details>

</div>

</div>

## Exercise 2

<div class="alert puzzle">

<div>

Create a new app that allows a user to visualize how changing the value of "m" in y=mx+b affects the slope of a line.

<details>
<summary>
Hints (click here)
</summary>

<br> You will need to define the values of x. You can do this within the server function (i.e. `a <- tibble(a=-100:100)`).

Also note that changing the slope of a line may not be so noticable because plots will automatically adjust to the scale of the data. Consider locking your coordinates so you notice changing slopes more easily.

<br>
</details>
<details>
<summary>
Solution (click here)
</summary>
<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>ui</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/fluidPage.html'>fluidPage</a></span><span class='o'>(</span>
  <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/sidebarLayout.html'>sidebarPanel</a></span><span class='o'>(</span>
    <span class='c'>#I chose sliderInput here, you can choose another input type</span>
    <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/sliderInput.html'>sliderInput</a></span><span class='o'>(</span>inputId <span class='o'>=</span> <span class='s'>"slope"</span>, min <span class='o'>=</span> <span class='o'>-</span><span class='m'>10</span>, max <span class='o'>=</span> <span class='m'>10</span>, value <span class='o'>=</span> <span class='m'>2</span>, label <span class='o'>=</span> <span class='s'>"Slope"</span><span class='o'>)</span>
  <span class='o'>)</span>,
  <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/sidebarLayout.html'>mainPanel</a></span><span class='o'>(</span>
    <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/plotOutput.html'>plotOutput</a></span><span class='o'>(</span>outputId <span class='o'>=</span> <span class='s'>"graph"</span><span class='o'>)</span>
  <span class='o'>)</span>
<span class='o'>)</span>

<span class='nv'>server</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>input</span>,<span class='nv'>output</span><span class='o'>)</span><span class='o'>&#123;</span>
  <span class='nv'>a</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://tibble.tidyverse.org/reference/tibble.html'>tibble</a></span><span class='o'>(</span>a<span class='o'>=</span><span class='o'>-</span><span class='m'>100</span><span class='o'>:</span><span class='m'>100</span><span class='o'>)</span>
  
  <span class='nv'>output</span><span class='o'>$</span><span class='nv'>graph</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/renderPlot.html'>renderPlot</a></span><span class='o'>(</span>
    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nv'>a</span>, <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span><span class='nv'>a</span>, <span class='nv'>input</span><span class='o'>$</span><span class='nv'>slope</span><span class='o'>*</span><span class='nv'>a</span><span class='o'>)</span><span class='o'>)</span><span class='o'>+</span>
      <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_path.html'>geom_line</a></span><span class='o'>(</span><span class='o'>)</span><span class='o'>+</span>
      <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/coord_cartesian.html'>coord_cartesian</a></span><span class='o'>(</span>xlim <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='o'>-</span><span class='m'>25</span>,<span class='m'>25</span><span class='o'>)</span>, ylim <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='o'>-</span><span class='m'>100</span>,<span class='m'>100</span><span class='o'>)</span><span class='o'>)</span>
  <span class='o'>)</span>
  
<span class='o'>&#125;</span>

<span class='nf'><a href='https://rdrr.io/pkg/shiny/man/shinyApp.html'>shinyApp</a></span><span class='o'>(</span>ui<span class='o'>=</span><span class='nv'>ui</span>,server<span class='o'>=</span><span class='nv'>server</span><span class='o'>)</span></code></pre>

</div>

</details>

</div>

</div>

## Exercise 3

<div class="alert puzzle">

<div>

Add on to your app from Exercise 2 by providing another input for user to adjust the y-intercept.

<details>
<summary>
Solution (click here)
</summary>
<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>ui</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/fluidPage.html'>fluidPage</a></span><span class='o'>(</span>
  <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/sidebarLayout.html'>sidebarPanel</a></span><span class='o'>(</span>
    <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/sliderInput.html'>sliderInput</a></span><span class='o'>(</span>inputId <span class='o'>=</span> <span class='s'>"slope"</span>, min <span class='o'>=</span> <span class='o'>-</span><span class='m'>10</span>, max <span class='o'>=</span> <span class='m'>10</span>, value <span class='o'>=</span> <span class='m'>2</span>, label <span class='o'>=</span> <span class='s'>"Slope"</span><span class='o'>)</span>,
    <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/sliderInput.html'>sliderInput</a></span><span class='o'>(</span>inputId <span class='o'>=</span> <span class='s'>"intercept"</span>, min <span class='o'>=</span> <span class='o'>-</span><span class='m'>10</span>, max <span class='o'>=</span> <span class='m'>10</span>, value <span class='o'>=</span> <span class='m'>2</span>, label <span class='o'>=</span> <span class='s'>"Y-Intercept"</span><span class='o'>)</span>
  <span class='o'>)</span>,
  <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/sidebarLayout.html'>mainPanel</a></span><span class='o'>(</span>
    <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/plotOutput.html'>plotOutput</a></span><span class='o'>(</span>outputId <span class='o'>=</span> <span class='s'>"graph"</span><span class='o'>)</span>
  <span class='o'>)</span>
<span class='o'>)</span>

<span class='nv'>server</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>input</span>,<span class='nv'>output</span><span class='o'>)</span><span class='o'>&#123;</span>
  <span class='nv'>a</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://tibble.tidyverse.org/reference/tibble.html'>tibble</a></span><span class='o'>(</span>a<span class='o'>=</span><span class='o'>-</span><span class='m'>100</span><span class='o'>:</span><span class='m'>100</span><span class='o'>)</span>
  
  <span class='nv'>output</span><span class='o'>$</span><span class='nv'>graph</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/shiny/man/renderPlot.html'>renderPlot</a></span><span class='o'>(</span>
    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nv'>a</span>, <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span><span class='nv'>a</span>, <span class='nv'>input</span><span class='o'>$</span><span class='nv'>slope</span><span class='o'>*</span><span class='nv'>a</span><span class='o'>+</span><span class='nv'>input</span><span class='o'>$</span><span class='nv'>intercept</span><span class='o'>)</span><span class='o'>)</span><span class='o'>+</span>
      <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_path.html'>geom_line</a></span><span class='o'>(</span><span class='o'>)</span><span class='o'>+</span>
      <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/coord_cartesian.html'>coord_cartesian</a></span><span class='o'>(</span>xlim <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='o'>-</span><span class='m'>25</span>,<span class='m'>25</span><span class='o'>)</span>, ylim <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='o'>-</span><span class='m'>100</span>,<span class='m'>100</span><span class='o'>)</span><span class='o'>)</span>
  <span class='o'>)</span>
  
<span class='o'>&#125;</span>

<span class='nf'><a href='https://rdrr.io/pkg/shiny/man/shinyApp.html'>shinyApp</a></span><span class='o'>(</span>ui<span class='o'>=</span><span class='nv'>ui</span>,server<span class='o'>=</span><span class='nv'>server</span><span class='o'>)</span></code></pre>

</div>

</details>

</div>

</div>

