---
toc: true
title: "Computer Setup for Code Club"
---

----

<br>

Here, you will find general information on computer setup for Code Club.
Additional setup instructions for individual sessions will appear in the posts for each session.

<br>

## Summary

- You can work in your browser at the [Ohio Supercomputer Center (OSC)](/codeclub-setup/#osc)
  or or you can work [with local software installations](/codeclub-setup/#local).

- **If you plan to work at OSC**:
  
  - Sign up at OSC if you don't have an account yet.
  
  - You should have received 
  
  - Test if you can start an RStudio Server session at OSC OnDemand.

- **If you plan to work with local software installations**:
  
  - [Install R](/codeclub-setup/#install-r) and [install RStudio](/codeclub-setup/#install-rstudio). <br>
    (If you already have R but you version is below `R 3.6`, then [update R](/codeclub-novice/#updating-r).)
  
  - [Install the *tidyverse* and test if you can load it](/codeclub-setup/#install-tidy).
  
- **Questions?** Don't hesitate to contact [Jelmer](mailto:poelstra.1@osu.edu) or
  one of the other organizers. You can also join the Code Club Zoom call
  15 minutes early, and one or more of the organizers will be on there already.

<br>

----

## Option 1 -- OSC {#osc}

All Code Club participants will get access to the [Ohio Supercomputer Center (OSC)](http://osc.edu)
Classroom Project for Code Club (`PAS1838`).
This way, you can code in, for example, RStudio from your browser rather than with a local installation.
This is a good option if you prefer not to install anything locally or if you run
into problems during installations.

**After signing up for Code Club, you should have received an email from OSC
that you were added to the OSC project.**

- *If you already have an OSC account*,
  you shouldn't need to do anything to gain access,
  although the email may ask you to confirm/accept your being added to project.

- *If you do not yet have an OSC account*,
  the email you received from OSC should have a link to do so.
  Alternatively, follow the instructions below to sign up and get access to the project.
  
  <details>
  <summary>
  Instructions to sign up at OSC (click here)
  </summary>

  To sign up:
  
  - Go to <https://my.osc.edu/> and click the blue "*Sign Up*" bar.
  
  - In the bottom right portion of the form where you provide your info (see screenshot below),
    you should enter Code Club's Project Code, which is `PAS1838`.
    **If you want to use OSC, please do this on a day prior to your first Code Club participation.**
    This way, there is time to troubleshoot if needed. Moreover, the `Code Club` option on the
    Interactive Apps page below can take a few hours to appear after you become a member of the project.
  
  {{< figure src="osc_signup2.png" width="600px" caption="Enter Project Code PAS1838 in the red box (click to enlarge)" >}}
  
  </details>

### Run RStudio Server {#osc-run-rstudio}

[OSC OnDemand](https://ondemand.osc.edu/) lets you access OSC resources through your
browser and run applications like RStudio.
It has a separate access point, <https://class.osc.edu/>,
for "classroom projects" such as this one. 

- To get started, go to <https://class.osc.edu/> and log in with your OSC username and password.

- Then, click on `Apps` in the blue top bar, and select `RStudio Server: Form`:
  
  {{< figure src="osc_rstudio-app.png" width="600px" caption="" >}}

- Now, you're on a page from which you can launch an RStudio server that will run on an OSC cluster.
  As shown below, make sure that "Code Club" is selected under `Class Materials`,
  and change the select `Number of hours` to 2. Then click `Launch`.

  {{< figure src="osc_rstudio-form.png" width="500px" caption="" >}}
  
- Now, you should see a box like this:

  {{< figure src="osc_queued.png" width="600px" caption="" >}}

- Your job usually starts running within seconds, causing the color of the top
  bar to switch from blue ("Queued") to green ("Running"):
  {{< figure src="osc_running.png" width="600px" caption="" >}}

- Click `Connect to RStudio Server` at the bottom of the box,
  and an RStudio Server instance will open.

### Test whether you can load the *tidyverse*

Several commonly used packages will be automatically available to you,
and that should include the *tidyverse*.
Test whether you can load the *tidyverse* by running `library(tidyverse)`,
and checking whether you get output similar to what is shown below:

```r
library(tidyverse)

#> ── Attaching packages ────────────────────────────────────────────────────────────────────────────────────── tidyverse 1.3.1 ──
#> ✓ ggplot2 3.3.5     ✓ purrr   0.3.4
#> ✓ tibble  3.1.3     ✓ dplyr   1.0.7
#> ✓ tidyr   1.1.3     ✓ stringr 1.4.0
#> ✓ readr   2.0.1     ✓ forcats 0.5.1
#> ── Conflicts ───────────────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
```

If you get an error, install the *tidyverse* as follows:

```r
install.packages("tidyverse")
```
  
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

## Option 2 -- Local installation {#local}

<div class="alert alert-note">
<div>

### Already have R installed?

- Please check your version of R, and update if it is below version `3.6`.  
  [See this page for instructions.](/codeclub-novice/#updating-r)

- Make sure you have [installed the *tidyverse*](/codeclub-setup/#install-r).
  
</div>
</div>

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

To install or update the *tidyverse*, which is a collection of useful R packages,
copy the following command into an R console, and press Enter:

```r
install.packages("tidyverse")
```

### Test whether you can load the *tidyverse* {#test-tidy}

When you issue the command `library(tidyverse)`,
you should get output similar to what is shown below:

```r
library(tidyverse)

#> ── Attaching packages ────────────────────────────────────────────────────────────────────────────────────── tidyverse 1.3.1 ──
#> ✓ ggplot2 3.3.5     ✓ purrr   0.3.4
#> ✓ tibble  3.1.3     ✓ dplyr   1.0.7
#> ✓ tidyr   1.1.3     ✓ stringr 1.4.0
#> ✓ readr   2.0.1     ✓ forcats 0.5.1
#> ── Conflicts ───────────────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
```

If you get an error instead, please try to troubleshoot it by following any instructions
given, or by Googling the error message.
It may be necessary to update R itself, see [here](/codeclub-novice/#updating-r) for instructions.
You can also send the [organizers of Code Club](https://biodash.github.io/codeclub-about/#organizers) an email.

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
