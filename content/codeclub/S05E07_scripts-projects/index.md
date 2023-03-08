---
output: hugodown::md_document
title: "S05E07: R4DS (2e) - Ch. 9 - Workflow: scripts and projects"
subtitle: "Today we will go over two tools for organizing code: scripts and projects."
summary: "Today we will go over two tools for organizing code: scripts and projects."
authors: [jessica-cooperstone]
tags: [codeclub, r4ds]
date: "2023-03-08"
lastmod: "2023-03-08"
toc: true

image: 
  caption: "Artwork by [@allison_horst](https://twitter.com/allison_horst)"
  focal_point: ""
  preview_only: false
rmd_hash: 65347eb28269a621

---

------------------------------------------------------------------------

## Introduction

Today we are going to talk about two tools that will help you organize and execute your code:

-   scripts: a `.R` file where you can write code, execute code, and save code for future use.
-   projects: a .`Rproj` file that allows you to keep all the files associated with an a analysis together.

<br>

------------------------------------------------------------------------

## R Scripts (`.R`)

If you have the conventional layout in RStudio, your scripts will be loaded in the top left quadrant of your screen.

<p align="center">
<img src=img/rstudio.png width="90%" alt="A screenshot of the RStudio IDE, with a script in the top left corner (and highlighted in a red box), the environment in the top right, the console in the bottom left, and the files panel in the bottom right.">
</p>

You could simply type any code you want to execute into the console to run it, but long term this is not a good or practical solution. It can get cramped, and most of the time you want to save your code you write so you can use it again in the future.

The R script file acts like a text file where you can write code, and then send it to the console. You can also save the file so you can use/edit it later.

### Running code

There are a few different ways in which you can execute code from your script by sending it to the console.

1.  By using Run in the top right corner of your Environment pane.
    <p align="center">
    <img src=img/run.png width="30%" alt="A screenshot of the RStudio IDE, showing the different Run options.">
    </p>
2.  Using a keyboard shortcut: place your cursor on the line you want to run and type `Cmd + Enter` on a Mac/Linux, or `Ctrl + Enter` on a PC.

### Code diagnostics

RStudio gets continually smarter in pointing out potential mistakes in your code to you, so you can fix them. Below are some examples of what this will look like.

If you put non-allowable characters in an object name:
<p align="left">
<img src=img/spaces_in_names.png width="30%" alt="A screenshot of the RStudio IDE, an error when you put a space in an object name for the code my data <- 1:10, you will see a red x on the left by your line numbers, and the diagnostic unexpected token data, and unexpected token <-.">
</p>
If you are missing a parentheses:
<p align="left">
<img src=img/missing_parentheses.png width="50%" alt="A screenshot of the RStudio IDE, an error when you put a space in an object name, you will see a red x on the left by your line numbers, and the diagnostic unexpected end of document.">
</p>

### Saving and naming

Talking about conventions for saving and naming might sound picky, but doing this in a systematic and predictable way will help you (and anyone who uses your code) in the future. In general you want your names to be:

1.  **Machine** readable: don't contain any spaces, symbols, or otherwise unallowable characters. *For example*, R will not prevent you from using spaces in column names, but it will from that point forward need to be encased in backticks which you will definitely find annoying.  
2.  **Human** readable: contain names that indicate to you and others what is contained within that object. *For example*, if you name all your dataframes Data, Data1, Data2, Data3, Data 4... you will have trouble in the future remembering the differences between them.
3.  **Some inherent organizational structure**, like numbering the names of scripts in the order they are run, making sub-folders, so it's easy to understand what comes from where, and to find what you're looking for. *For example*, I like to make sub-folders for data, output, figs, so that my parent directory stays organized. If you have a few scripts and they need to run sequentially, it would be a good idea to name them so that order is apparent, like `01_data-import-wrangling.R`, `02_stat-analysis.R`, `03_plot-figs.R`.

<br>

## R Projects (`.Rproj`)

<p align="center">
<img src=img/setwd_v_rproj.png width="60%" alt="A cartoon of a cracked glass cube looking frustrated with casts on its arm and leg, with bandaids on it, containing “setwd”, looks on at a metal riveted cube labeled “R Proj” holding a skateboard looking sympathetic, and a smaller cube with a helmet on labeled “here” doing a trick on a skateboard.">
<figcaption>
Artwork by [@allison_horst](https://twitter.com/allison_horst)
</figcaption>
</p>

### A reminder about directories

A couple of weeks ago, Jelmer shared with us some information about [getting and your working directory](https://biodash.github.io/codeclub/s05e05/#interlude-file-locations) using [`getwd()`](https://rdrr.io/r/base/getwd.html) and [`setwd()`](https://rdrr.io/r/base/getwd.html).

The reason why we have to do this is because we need to indicate in R where it should be looking for importing files, and where it should be writing out files from our analyses. R cannot read your mind, so you have to tell it where this location is.

### Why saving your environment is a bad idea

By default, R will save, or ask if you if you want to save your environment. Your environment contains all of the working objects, data, functions that you have been using for your analysis.

We recommend that you turn off this auto-saving of your environment to aid in your own reproducible analysis in the future. You can do that by going to Tools \> Global Options

<p align="center">
<img src=img/clean-slate.png width="90%" alt="A screenshot of global options, general, unchecking to restore workspace at startup, and setting save workspace to RData to never.">
</p>

### Making a reprex

It is likely that as you travel on your coding journey, you will come across a problem that despite whatever you try, you are struggling to solve. You might want to post about your problem on [Stack Overflow](https://stackoverflow.com/) so you can get some help.

To do this, you should create a reprex: a **repr**oducible **ex**ample.

<p align="center">
<img src=img/reprex.png width="80%" alt="A side-by-side comparison of a monster providing problematic code to tech support when it is on a bunch of crumpled, disorganized papers, with both monsters looking sad and very stressed (left), compared to victorious looking monsters celebrating when code is provided in a nice box with a bow labeled “reprex”. Title text reads “reprex: make reproducible examples. Help them help everyone!” Learn more about reprex.">
<figcaption>
Artwork by [@allison_horst](https://twitter.com/allison_horst)
</figcaption>
</p>

Within your reprex, you should:

-   include everything you need to make your code reproducible. That includes any [`library()`](https://rdrr.io/r/base/library.html) calls and any necessary objects.

-   think minimalistically - don't use more or more complicated data if you example can be simpler. If you can use built in datasets from R (think, `mtcars`, `iris`), do so.

-   make sure its easy for someone to reproduce what you did via copy and pasting your code (no screenshots!)

Often the process of creating the reprex will help you figure out the answer to your own problem.

This isn't just good for posting about coding problems, if you want to ask your lab mate, instructor, collaborator, friend about a problem and you'd like their help in solving it, make it easy for them to help you.

Here is some more information about creating a good reprex [from the package reprex](https://reprex.tidyverse.org/articles/reprex-dos-and-donts.html) and [on Stack overflow](https://stackoverflow.com/questions/5963269/how-to-make-a-great-r-reproducible-example/16532098).

------------------------------------------------------------------------

## Breakout Rooms

We are going to practice what we've gone over today with some breakout exercises.

### Exercise 1

Set yourself up an R project for your Code Club files. Store it in a permanent and logical space on your computer (i.e., not your downloads folder or desktop), and once you've done it, open it up and use it for the rest of Code Club.

### Exercise 2

Using your new project, take a file from a past Code Club or from your research, and load it into R using what you've learned in the past two sessions ([Data Import](https://biodash.github.io/codeclub/s05e05/) and [Data Import 2](https://biodash.github.io/codeclub/s05e06/)). Also try and export what you've just imported and save it in a subfolder called "output".

### Exercise 3

Go to the RStudio Tips Twitter account, <https://twitter.com/rstudiotips> and find one tip that looks interesting. Practice using it!

### Exercise 4

What other common mistakes will RStudio diagnostics report? Read <https://support.posit.co/hc/en-us/articles/205753617-Code-Diagnostics> to find out.

### Bonus 1

Try and create a reprex for a coding problem you've run into.

