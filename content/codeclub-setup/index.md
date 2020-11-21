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
where Code Club has a Classroom Project. We recommend that you make sure you have
an active OSC account with access to the Code Club project either way,
which can be a helpful backup option when something fails with locall installs.

If you missed the first session, have a look at the [introductory slides](/slides/CC01/) as well.

<br>

----

## Option 1 -- OSC {#osc}

All Code Club participants will get access to the OSC Classroom Project for Code Club (`PAS1838`).
This way, you can code in (e.g.) RStudio from your browser rather than with a local installation.
This is a good option if you prefer not to install anything locally or run into problems when doing so.

*If you already had an OSC account*, you should have been added to the Code Club OSC project
and can continue to the [second step](/codeclub-setup/#osc-run-rstudio).
Otherwise, please follow the instructions below to sign up and get access to the project.

### Sign up at OSC {#osc-signup}

To sign up:

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
- R: At least version `3.6` -- [See here for instructions to update R](/codeclub-novice/#updating-r)
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

RStudio is a so-called Integrated Development Environment (IDE) for R,
with side-by-side panes for an R script, an R concole, plots, help documents, and much more.
While it is perfectly possible to use R without RStudio, RStudio has become
the de facto standard for working with R and is very useful.

To install RStudio, go to the [RStudio download page](https://rstudio.com/products/rstudio/download/#download)
and download and run the installer file for your operating system. 

### Install the *tidyverse* {#install-tidy}

Install the *tidyverse*, which is a collection of useful R packages,
by typing the following command inside an R console:

```r
install.packages("tidyverse")
```

### Test whether you can load the *tidyverse*

When you issue the command `library("tidyverse")`,
you should get the output shown below:

```r
library("tidyverse")

#> ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──

#> ✔ ggplot2 3.3.2     ✔ purrr   0.3.4
#> ✔ tibble  3.0.4     ✔ dplyr   1.0.2
#> ✔ tidyr   1.1.2     ✔ stringr 1.4.0
#> ✔ readr   1.3.1     ✔ forcats 0.5.0

#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
```

If you get an error instead, please try to troubleshoot it.
Updating R itself may be necessary, see [here](/codeclub-novice/#updating-r) for instructions.
You can also send the [organizers of Code Club](https://biodash.github.io/codeclub-about/#organizers) an email.
And if you can't get it to work yet,
you can always use OSC for the time being, see the [setup instructions further up on this page](/codeclub-setup/#osc).

<br>

----

## More info {#more}

Please see the **[Getting started with R](/codeclub-novice/)** page for:

- [Resources to get started with R](/codeclub-novice/#new-to-r)
- [Useful R and RStudio settings](/codeclub-novice/#useful-settings)
- [The basics of installing packages in R](/codeclub-novice/#installing-r-packages)
- [Instructions for updating R](/codeclub-novice/#updating-r)



<br/> <br/> <br/>

----
