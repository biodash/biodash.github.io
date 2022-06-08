---
title: "R Resources and Tips"
toc: true
date: "2021-08-17"
---

-----

<br>

## Resources to get started with R

### The basics

- [Code Club S02E01: Intro to R -- part 1](/codeclub/s02e01_r-intro-part1/)

- [Code Club S02E02: Intro to R -- part 2](/codeclub/s02e02_r-intro_part2/)

- [Mike Sovic's Youtube playlist of short videos on R](https://www.youtube.com/playlist?list=PLxhIMi78eQegFm3XqsylVa-Lm7nfiUshe):

{{< youtube ByxF3xjN2JQ >}}

<br>

### Lengthier material

- [A Tutorial Introduction to R](https://kingaa.github.io/R_Tutorial/).

- The Carpentries have a number of great lessons on R, such as:

  - [Data Analysis and Visualization in R for Ecologists](https://datacarpentry.org/R-ecology-lesson),
    which includes data wrangling with *tidyverse* packages and plotting with *ggplot2*.
    
  - [R for Reproducible Scientific Analysis](https://swcarpentry.github.io/r-novice-gapminder/)

- If you prefer material structured as a course, excellent free ones include
  the [R Basics](https://www.edx.org/course/data-science-r-basics)
  and [Visualization](https://www.edx.org/course/data-science-visualization) courses
  by Rafael Irizarry (you do have to create an EdX account for access).
  
- If you prefer a book, we would recommend Wickham & Grolemund's
  "R for Data Science", which is freely available on the web in a really nice format
  [here](https://r4ds.had.co.nz/).

<br>

----

## Miscellaneous R tips

### Installing R packages

#### CRAN packages

To install an R package that is available at [CRAN](https://cran.r-project.org/),
the default R package repository,
from within R (e.g. in the R console in RStudio), use the `install.packages()` function.

The `install.packages()` function will handle dependencies within R -- i.e., it will install other R packages
that your package depends on. Occasionally, when the install function needs to compile
a package from source, errors arise that relate to missing system dependencies (i.e. software outside of R).

On **Mac** and **Linux**, these system dependencies are best installed outside of R,
such as with `homebrew` on Mac or `apt` on Ubuntu.
The errror message you got when trying to install an R package should tell you which system dependencies are needed.

On Windows, you can use the `installr` package to install such dependencies or other software from within R -- for example:

```r
install.packages("installr")    # Install the installr package first
installlr::install.RStudio()    # Install RStudio
installr::install.python()      # Install Python
```

<br>

#### System setup to installing packages "from source"

Sometimes you need to install a package from source, that is,
you need to compile the package rather than simply installing a pre-existing binary.
(On **Linux**, where installing from source is often needed, this should work without additional steps.) 
On **Windows** and **Mac**, installing from source is generally only needed when you
install a package from outside of CRAN (such as from Github, see below),
*but* you will need to make sure you have the following non-R software:

**On **Windows**, you will need *Rtools* ([Rtools installation instructions](http://cran.r-project.org/bin/windows/Rtools/)).**

**On a Mac, you will need *Xcode* (which can be installed from the Mac App store).**

You can test whether or not you are able to install packages from source using the *devtools* package:

```r
install.packages("devtools")    # Install the devtools package
devtools::has_devel()           # Check whether you can install packages from source
```

For a bit more info, see [this page](https://rstats.wtf/set-up-an-r-dev-environment.html).

<br>

#### Installing packages from Github

To install a package from Github, use either the *devtools* or the *remotes* package -- for example:

```r
install.packages("devtools")                # Install the devtools package
devtools::install_github("kbroman/broman")  # Install from a repository using "<username>/<repo-name>"
```

This will install the package *from source*, so you will need to make sure you are able to do so
by following the instructions in the section right above this one.

<br>

#### Installing packages from Bioconductor

If you're doing bioinformatic analyses in R, you will probably run into packages
that are not on CRAN but on [Bioconductor](https://bioconductor.org/).
To install a package from Bioconductor, use the *BiocManager* package -- for example:

```r
install.packages("BiocManager")  # Install the BiocManager package
BiocManager::install("edgeR")    # Install the edgeR package from Bioconductor
```

<br>

----

### Updating R

Consider updating R if you have an older version of R installed.
**Specifically, in the first session of Code Club, we've seen problems when installing
the *tidyverse* with R versions below `R 3.6`.**

You can check which version of R you have by looking at the first lines of
output when running the following command inside R:

```r
sessionInfo()
```

#### To update:

- **Windows**: You can update R from within R. The `updateR()` function will also take care
  of updating your packages:
  
  ```r
  install.packages("installr")
  installr::updateR()
  ```

- **Mac**: Download and install the latest `.pkg` file as if you were installing it for the first time.

- **Linux**: In Ubuntu, if you installed R with `apt` or `apt-get`, you can use `apt-get upgrade` in a terminal.
  Otherwise, download and install the latest version after removing the old one.
  [Rtask has some instructions](https://rtask.thinkr.fr/installation-of-r-4-0-on-ubuntu-20-04-lts-and-tips-for-spatial-packages/) for upgrading to
  R 4.0 in Ubuntu (along with upgrading to Ubuntu 20.04).

<br>

#### Re-installing your packages after updating (Mac and Linux)

While the `installr::updateR()` function for **Windows** users takes care of reinstalling
your packages along with updating R,
**Mac** and **Linux** users will have to manually re-install their packages.
Some people prefer to re-install these packages on the fly, which can end up being a way
to get rid of packages you no longer use.

But if you want immediately reinstall all your packages, run this before you upgrade:

```r
my_packages <- installed.packages()
saveRDS(my_packages, "my_packages.rds")
```

Then, after you've installed the latest R version:
```r
my_packages <- readRDS("CurrentPackages.rds")
install.packages(my_packages[1, ])
```

This will only work for packages available on CRAN. Of course, you can check your list
for Github-only and Bioconductor packages and then install those with their respective commands
(see below). Yes, this can be a bit of a hassle!


<br/> <br/> <br/>

----
