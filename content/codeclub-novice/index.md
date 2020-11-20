---
toc: true
---

# Code Club: <br/> New to R? And other R tips.

----
<br>

## New to R?
If you are completely new to R, we recommend watching at least the first couple of
videos from [Mike Sovic's Youtube playlist of short videos on R](https://www.youtube.com/playlist?list=PLxhIMi78eQegFm3XqsylVa-Lm7nfiUshe),
and ideally all of them, prior to attending Code Club. Here is the first video:

{{< youtube ByxF3xjN2JQ >}}

<br>

In case you want to do more self-study (note that this is *not* required/needed),
here are some additional resources:
- A useful and fun written tutorial is [R for cats](https://rforcats.net/).
- For a more systematic and lengthy introduction to R, see 
  [A Tutorial Introduction to R](https://kingaa.github.io/R_Tutorial/)
  (this gets fairly advanced after section 9).
- Excellent comprehensive introductions are the [R Basics](https://www.edx.org/course/data-science-r-basics)
  and [Visualization](https://www.edx.org/course/data-science-visualization) classes by Rafael Irizarry
  that can be freely accessed; you do have to create an account. 

Also, don't hesitate to reach out to the [Code Club organizers](/codeclub-about/#organizers)
if you have any questions! 

<br>

----

## Miscellaneous R tips

### Useful settings

By default, R will try to save your "environment" (e.g., your loaded data, variables, etc)
when you exit, and then reload everything the way it was upon restarting R. However, this is bad!
You should always be able to reproduce your environment given a set of commands
saved in an R script or R Markdown document, whereas saving and reloading your environment
encourages you to be sloppy about this.

To disable this in RStudio, go to `Tools` > `Global Options` > `General` and set the options
as follows:

{{< figure src="r_environment.png" width="500px" caption="Recommended R/RStudio settings" >}}

To start R in the same way from the command line:

```r
R --no-save --no-restore-data
```

<br>

----

### Installing R packages

#### CRAN packages
To install an R package that is available at [CRAN](https://cran.r-project.org/), the default R package repository,
from within R (e.g. in the R console in RStudio), use the `install.packages()` function.

The `install.packages()` function will handle dependencies within R -- i.e., it will install other R packages
that your package depends on. Occasionally, when the install function needs to compile
a package from source, errors arise that relate to missing system dependencies (i.e. software outside of R).

On Mac and Linux, these system dependencies are best installed outside of R,
such as with `homebrew` on Mac or `apt` on Ubuntu.
The installation errror message should tell you which libraries are needed.

On Windows, you can use the `installr` package to install such dependencies or other software from within R -- for example:

```r
install.packages("installr")    # Install the installr package first
installlr::install.RStudio()    # Install RStudio
installr::install.python()      # Install Python
```

<br>

#### Packages from other sources

Some packages are not available on CRAN.
The two main alternative places that you may want to install packages from are Github and
(if you are working with bioinformatics data) [Bioconductor](https://bioconductor.org/).

To install a package from Github, use the `remotes` package -- for example:

```r
install.packages("remotes")                # Install the remotes package
remotes::install_github("kbroman/broman")  # Install from a repository using "<username>/<repo-name>"
```

To install a package from Bioconductor, use the `BiocManager` package -- for example:
```r
install.packages("BiocManager")  # Install the BiocManager package
BiocManager::install("edgeR")    # Install the edgeR package from Bioconductor
```

<br>

### Updating R

Consider updating R if you have an older version of R installed.
**Specifically, in the first session of Code Club, we've seen problems when installing
the *tidyverse* with R versions below `R 3.6`.**

- **Windows**: Use the function `installr::updateR()` in an R console
  (if needed, first install installr using `install.packages("installr")`).
- **Mac**: Download and install the latest `.pkg` file as if you were installing it for the first time.
- **Linux**: In Ubuntu, if you installed R with `apt` or `apt-get`, you can use `apt-get upgrade` in a terminal.
  Otherwise, download and install the latest version after removing the old one.
  [Rtask has some instructions](https://rtask.thinkr.fr/installation-of-r-4-0-on-ubuntu-20-04-lts-and-tips-for-spatial-packages/) for upgrading to
  R 4.0 in Ubuntu (along with upgrading to Ubuntu 20.04).

#### Re-installing your packages after updating (Mac and Linux)

While the `installr::updateR()` function for Windows users takes care of reinstalling
your packages along with updating R,
Mac and Linux users will have to manually re-install their packages.
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