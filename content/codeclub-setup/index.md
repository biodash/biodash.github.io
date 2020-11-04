---
toc: true
---

# Code Club: <br/> Computer Setup

----
<br>

Here, you will find general information on computer setup for Code Club.
Additional setup instructions for individual sessions (e.g., installing a specific package)
will appear in the posts for each session.

You may prefer to install the software locally, so you can easily practice
outside of Code Club. Alternatively, you can access RStudio (among other things)
in your browser at the [Ohio Supercomputer Center (OSC)](http://osc.edu),
where Code Club has a Classroom Project.

<br>

----

## Option 1 -- OSC {#osc}

### Sign up at OSC {#osc-signup}

All Code Club participants will get access to the OSC Classroom Project for Code Club (`PAS1838`).
This way, you can code in (e.g.) RStudio from your browser rather than with a local installation.
This is a good option if you prefer not to install anything locally or run into problems when doing so.

If you don't already have an OSC account, you do need to sign up:
- Go to <https://my.osc.edu/> and click the blue "*Sign Up*" bar.
- In the bottom right portion of the form where you provide your info (see screenshot below),
  you should enter Code Club's Project Code, which is `PAS1838`.
**If you want to use OSC, please do this on a day prior to your first Code Club participation.**
This way, there is time to troubleshoot if needed. Moreover, the `Code Club` option on the
Interactive Apps page below can take a few hours to appear after you become a member of the project.

{{< figure src="osc_signup2.png" width="800px" caption="Enter Project Code PAS1838 in the red box (click to enlarge)" >}}

### Run RStudio Server during Code Club {#osc-run-rstudio}

[OSC OnDemand](https://ondemand.osc.edu/) lets you access OSC resources through your browser and run a couple of applications with GUIs,
like RStudio. It has a separate access point, <https://class.osc.edu/>, for classroom projects such as this one. 
- To get started, go to <https://class.osc.edu/> and log in with your OSC username and password.
- Then, click on `Interactive Apps` in the blue top bar, and select `RStudio Server (Owens and Pitzer): Form`.
- Now, you're on a page from which you can launch an RStudio server that will run on an OSC cluster.
  - Under `Class Materials`, select `Code Club`.
  - Under `Number of hours`, enter `2`.
  - Click `Launch`.
- Now, you should see a box like this:
{{< figure src="osc_queued.png" width="700px" caption="" >}}
- Your job should start running pretty soon, and when it's ready the box should look like this: 
{{< figure src="osc_running.png" width="700px" caption="" >}}
- Click `Connect to RStudio Server` at the bottom of the box, and an RStudio Server instance will open. You're ready to go!

### More about OSC {#osc-more}

The above instructions should be all you need to access RStudio using OSC,
but there is lot more to OSC than that!
For more information about using OSC, see the excellent [Getting Started materials](https://www.osc.edu/resources/getting_started)
on their website (make sure not to miss the [HOWTOs](https://www.osc.edu/resources/getting_started/howto)).
Also, Mike Sovic has a [YouTube playlist "Getting Started With High Performance
Computing (HPC)"](https://www.youtube.com/playlist?list=PLxhIMi78eQeiJ0p7REEU5i7kJK3Vk2ek3)
at his channel [The Data Point](https://www.youtube.com/channel/UC2dB6jDTbqzlTM6edzfBSGQ). 

<br>

----

## Option 2 -- Local install {#local}

### Summary {#local-summary}

You will need:
- R -- preferably version >= `4.0.0`, but at least `3.0.1`
- RStudio
- R packages that we will regularly use:
  - `tidyverse`

### Install R {#install-r}

- **Windows**: Download and run the `.exe` file for the latest version of R from <https://cran.r-project.org/bin/windows/base/>,
  by clicking the large `Download R [version-number] for Windows` link at the top of the gray box.
- **Mac**: Download and run the `.pkg` file for the latest version of R from <https://cran.r-project.org/bin/macosx/>,
  by clicking the link just below `Latest release`.
- On a **Linux** distribution, you can also install R using the website above, but you may prefer to use
  a package manager instead -- for instance, seee [these instructions](https://linuxize.com/post/how-to-install-r-on-ubuntu-20-04/)
  for installing the latest R version on Ubuntu 20.04 using the `apt` package manager.

### Install RStudio {#install-rstudio}

RStudio is a so-called Interactive Development Environment (IDE) for R,
with side-by-side panes for an R script, an R concole, plots, help documents, and much more.
While it is perfectly possible to use R without RStudio, RStudio has become
the de facto standard for working with R and is very useful.

To install RStudio, go to the [RStudio download page](https://rstudio.com/products/rstudio/download/#download)
and download and run the installer file for your operating system. 

### Install the tidyverse {#install-tidy}

Install the `tidyverse`, which is a *collection* of useful packages, by
typing the following command inside an R console:

```r
install.packages("tidyverse")
```

<br>

----

## More info {#more}

Please see the [New to R?](/codeclub-novice/) section
to get started with R and for more R setup tips.



<br/> <br/> <br/>

----
