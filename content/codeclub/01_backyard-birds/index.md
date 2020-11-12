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
rmd_hash: 20a709f104b25f90

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

<br> <br>

------------------------------------------------------------------------

------------------------------------------------------------------------

1 - Create an RStudio Project
-----------------------------

<br>

------------------------------------------------------------------------

2 - Orienting ourselves
-----------------------

<br>

------------------------------------------------------------------------

3 - Getting our dataset
-----------------------

We downloaded a Great Backyard Bird Count (GBBC) [dataset](https://www.gbif.org/dataset/82cb293c-f762-11e1-a439-00145eb45e9a) from the [Global Biodiversity Information Facility (GBIF)](https://www.gbif.org/). Because the file was 3.1 GB large, we selected only the records from Ohio and removed some uninformative columns. We'll download the resulting 36 MB file from our Github repo.

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

<br>

------------------------------------------------------------------------

4 - Exploring backyard birds
----------------------------

<br> <br> <br>

