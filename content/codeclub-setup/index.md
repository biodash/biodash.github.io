
# Computer setup

Here, you will find some general information on computer setup for Code Club.
Additional setup for individual sessions (e.g., installing a specific package),
will be stated clearly in the posts for each session.

You may prefer to install the necessary software locally, so you can easily practice
outside of Code Club. Alternatively, you can access RStudio (as well as the terminal
and Jupyter Notebooks) through your browser at the [Ohio Supercomputer Center (OSC)](http://osc.edu),
where we have a Classroom Project. 

<br>

## Local installation

### Summary of what you need

- R -- preferably version >= `4.0.0`, but at least `3.0.1`
- RStudio
- R packages that we will regularly use:
  - `tidyverse`

### Install R

- To install R for **Windows** or **Mac**, follow the instructions on the [CRAN website](https://cran.r-project.org/).
  Please install the latest version like the website will direct you to do (currently `4.0.3`).
- On a **Linux** distribution, you can also install R using the website above, but you may prefer to use
  a package manager instead -- for instance, [here](https://linuxize.com/post/how-to-install-r-on-ubuntu-20-04/) are instructions
  for installing the latest R version on Ubuntu 20.04.

### Install RStudio

RStudio is a so-called Interactive Development Environment (IDE) for R,
with panes for R scripts, an R concole, plots, help documents, and much more.
While it is perfectly possible to use R without RStudio, RStudio has become
the de facto standard for working with R and is incredibly useful.

To install RStudio, go to the [RStudio download page](https://rstudio.com/products/rstudio/download/#download)
and download and run the installer file for your operating system. 


### Installing R packages

To install an R package within R (e.g. in the R console in R Studio),
use the `install.packages()` function.

Please install the *tidyverse* (which happens to be a *collection* of packages, but
we can still install it using the same function) like so:

`install.packages("tidyverse")`

While this function will handle dependencies
within R (i.e., other packages that need to be installed in order to be able to install the package you want),
occasionally, there are errors relating to missing system dependencies that you will need to install *outside of R*.

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

OSC OnDemand lets you access OSC resources through your browser and run some software with GUIs, like RStudio.
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
but there is lot more to OSC than that! For more information about using OSC, their website has excellent resources.
If you work your way through the [getting started materials](https://www.osc.edu/resources/getting_started),
you should be pretty far along!
In particular, it's worth looking through the topics in the
[HOWTOs](https://www.osc.edu/resources/getting_started/howto).

Our very own Mike Sovic also has a [YouTube playlist "Getting Started With High Performance
Computing (HPC)"](https://www.youtube.com/playlist?list=PLxhIMi78eQeiJ0p7REEU5i7kJK3Vk2ek3)
at his channel [The Data Point](https://www.youtube.com/channel/UC2dB6jDTbqzlTM6edzfBSGQ). 

<br/> <br/> <br/> <br/>
