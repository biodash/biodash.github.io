
# Computer setup

Here, you will find some general information on computer setup for Code Club.
Additional setup for individual sessions (e.g., installing a specific package),
will be stated clearly in the posts for each session.

You may prefer to install the software locally, so you can easily practice
outside of Code Club. Alternatively, you can access RStudio (as well as the terminal
and Jupyter Notebooks) through your browser at the [Ohio Supercomputer Center (OSC)](http://osc.edu),
where Code Club has a Classroom Project. 

<br>

## Local installation

### Summary of what you need

- R -- preferably version >= `4.0.0`, but at least `3.0.1`
- RStudio
- R packages that we will regularly use:
  - `tidyverse`

### Install R

- **Windows**: Download and run the `.exe` file for the latest version of R from <https://cran.r-project.org/bin/windows/base/>,
  by clicking the large `Download R [version-number] for Windows` link at the top of the gray box.
- **Mac**: Download and run the `.pkg` file for the latest version of R from <https://cran.r-project.org/bin/macosx/>,
  by clicking the link just below `Latest release`.
- On a **Linux** distribution, you can also install R using the website above, but you may prefer to use
  a package manager instead -- for instance, seee [these instructions](https://linuxize.com/post/how-to-install-r-on-ubuntu-20-04/)
  for installing the latest R version on Ubuntu 20.04 using the `apt` package manager.

### Install RStudio

RStudio is a so-called Interactive Development Environment (IDE) for R,
with side-by-side panes for an R script, an R concole, plots, help documents, and much more.
While it is perfectly possible to use R without RStudio, RStudio has become
the de facto standard for working with R and is very useful.

To install RStudio, go to the [RStudio download page](https://rstudio.com/products/rstudio/download/#download)
and download and run the installer file for your operating system. 

### Install the tidyverse

Install the `tidyverse`, which is a *collection* of useful packages, by
typing the following command inside an R console:

```r
install.packages("tidyverse")
```

<br>

## Additional info about setting up R

### Updating R

If you have an older version of R already installed, consider updating it
(certainly do this your R version is below `3.0.1`, and preferably do this if your R version is below `4.0`).

- **Windows**: Use the function `installr::updateR()` in an R console.
- **Mac**: Download and install the latest `.pkg` file as if you were installing it for the first time.
- **Linux**: In Ubuntu, if you installed R with `apt` or `apt-get`, you can use `apt-get upgrade` in a terminal.
  Otherwise, download and install the latest version after removing the old one.
  [Rtask](https://rtask.thinkr.fr/installation-of-r-4-0-on-ubuntu-20-04-lts-and-tips-for-spatial-packages/) has some instructions for upgrading to
  R 4.0 specifically, when using Ubuntu (along with upgrading to Ubuntu 20.04).

#### Re-installing your packages after updating (Mac and Linux)

While the `installr::updateR()` also takes care of reinstalling your packages,
Mac and Linux users will have to re-install their packages.
Some people prefer to re-install these packages on the fly, which can end up being one way
to get rid of packages you no longer use.

But if you want to try to reinstall all you packages, run this before you upgrade:

```r
my_packages <- installed.packages()
saveRDS(my_packages, "my_packages.rds")
```

Then, after you've installed the latest R version:
```r
my_packages <- readRDS("CurrentPackages.rds")
install.packages(my_packages[1, ])
```

This will only work for packages available on CRAN.


### Installing R packages

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

## OSC

### Sign up at OSC

All Code Club participants automatically get access to the OSC Classroom Project for Code Club (`PAS1838`).
This way, you can work e.g. in RStudio from your browser rather than with a local installation.
However, you only need to do this if you prefer not to install anything, or if you have problems
with locally installing the software or individual packages -- we will not be running heavy computational analyses that will require the use of the cluster.

If you don't already have an OSC account, you do need to sign up:
- Go to <https://my.osc.edu/> and click the blue "*Sign Up*" bar.
- In the bottom right portion of the form where you provide your info (see screenshot below),
  you should enter Code Club's Project Code, which is `PAS1838`.

{{< figure src="osc_signup2.png" width="800px" caption="Enter Project Code PAS1838 in the red box (click to enlarge)" >}}

### Use RStudio with OSC OnDemand

OSC OnDemand lets you access OSC resources through your browser and run a couple of applications with GUIs, like RStudio.
- To get started, go to <https://ondemand.osc.edu/> and log in with your OSC username and password.
- Then, click on `Interactive Apps` in the blue top bar, and select `RStudio Server (Owens and Pitzer)`.
- Now, you're on a page from which you can launch an RStudio server that will run on an OSC cluster.
  - Under `Cluster`, either `Owens` or `Pitzer` will work.
  - Under `R version`, keep the default of `4.02`.
  - Under `Project`, if `PAS1838` is not already entered, enter it.
  - Under `Number of hours`, enter `2`.
  - Under `Node type`, keep the default of `any`.
  - Under `Number of cores`, keep the default of `1`.
  - Keep the box `I would like to receive an email when the session starts` unchecked.
  - Click `Launch`.
- Now, you should see a box like this:
{{< figure src="osc_queued.png" width="700px" caption="" >}}
- Your job should start running pretty soon, and when it's ready the box should look like this: 
{{< figure src="osc_running.png" width="700px" caption="" >}}
- Click `Connect to RStudio Server` at the bottom of the box, and an RStudio Server instance will open. You're ready to go!

### General info about using OSC

The above instructions should be all you need to access RStudio using OSC,
but there is lot more to OSC than that! For more information about using OSC, their website has excellent resources --
if you work your way through the [Getting Started materials](https://www.osc.edu/resources/getting_started),
you should be pretty far along!
In particular, once you're up and running with the basics, it's worth looking through the topics in the
[HOWTOs](https://www.osc.edu/resources/getting_started/howto).

Our very own Mike Sovic also has a [YouTube playlist "Getting Started With High Performance
Computing (HPC)"](https://www.youtube.com/playlist?list=PLxhIMi78eQeiJ0p7REEU5i7kJK3Vk2ek3)
at his channel [The Data Point](https://www.youtube.com/channel/UC2dB6jDTbqzlTM6edzfBSGQ). 

<br/> <br/> <br/> <br/>
