---
toc: true
title: "Computer Setup for Code Club"
---

----

<br>

Here, you will find general information about computer setup for Code Club.
Additional setup instructions for individual sessions will appear in the posts for each session.

## Summary

- Install R and RStudio
  (if you have an older version of R, then consider [updating R](/tutorials/r-resources-tips/#updating-r)).
  
- Install the *tidyverse* package and test if you can load it.
  
- Prefer not to install anything locally?
  [Contact Jelmer](mailto:poelstra.1@osu.edu) to be added to the Ohio Supercomputer project for Code Club.

- **Run into issues or have questions?**
  Don't hesitate to [contact Jelmer](mailto:poelstra.1@osu.edu) or
  one of the other organizers.
  You can also come to Code Club Zoom 15 minutes early,
  and one or more of the organizers should be there already.

<br>

----

## Local installation {#local}

<div class="alert alert-note">
<div>

### Already have R installed?

- Please check your version of R -- this information is printed to the console
  when you start R, and you can also get it by typing `sessionInfo()` and checking
  the first line of the output.
  
- Currently (January 2023), we would recommend R version `4.2.0` or higher.
  And since we'll work with the "base R pipe",
  you'll definitely need version `4.1.0` or higher.
  
- To update R, [see this page for instructions](/tutorials/r-resources-tips/#updating-r).

- Make sure you have installed the *tidyverse* package (try `library(tidyverse)`).
  
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

When you issue the command `library(tidyverse)` in your R console inside RStudio,
you should get output similar to what is shown below:

```r
library(tidyverse)

── Attaching packages ──────────────────────────────────────────────────────────
───────────────────────────────────────────── tidyverse 1.3.1 ──
✔ ggplot2 3.3.6     ✔ purrr   0.3.4
✔ tibble  3.1.7     ✔ dplyr   1.0.9
✔ tidyr   1.2.0     ✔ stringr 1.4.0
✔ readr   2.1.2     ✔ forcats 0.5.1
── Conflicts ───────────────────────────────────────────────────────────────────
─────────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()
```

If you get an error instead, please try to troubleshoot it by following any instructions
given, or by Googling the error message.
It may be necessary to update R itself, see [here](/codeclub-novice/#updating-r) for instructions.
You can also send the [organizers of Code Club](https://biodash.github.io/codeclub-about/#organizers) an email.

<br>

----

## Alternative: Use RStudio Server at OSC {#osc}

Upon request ([contact Jelmer](mailto:poelstra.1@osu.edu)),
you can get access to the [Ohio Supercomputer Center (OSC)](http://osc.edu)
Classroom Project for Code Club (`PAS1838`).
This way, you can code in RStudio from your browser rather than with a local installation.
This is a good option if you prefer not to install anything or if you run
into problems during installations.

**After you asked for access to the OSC project,
you should receive an email from OSC that you have been added to the Code Club OSC project.**

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

### Run RStudio Server from the OSC website {#osc-run-rstudio}

[OSC OnDemand](https://ondemand.osc.edu/) lets you access OSC resources through your
browser and run applications like RStudio.
It has a separate access point, <https://class.osc.edu/>,
for "classroom projects" such as this one. 

1. To get started, go to <https://class.osc.edu/> and log in with your OSC username and password.

2. Click on `Apps` in the blue top bar, and select `RStudio Server: Form`, as shown below:
  
  {{< figure src="osc_rstudio-app.png" width="600px" caption="" >}}

3. Now, you're on a page from which you can launch an RStudio server that will run on an OSC cluster.
   As shown below, make sure that "Code Club" is selected under `Class Materials`,
   and change the select `Number of hours` to 2. Then click `Launch`.

   {{< figure src="osc_rstudio-form.png" width="500px" caption="" >}}
  
4. You should see a box like this:

   {{< figure src="osc_queued.png" width="600px" caption="" >}}

5. Your job usually starts running within seconds, and the color of the top
   bar will then switch from blue ("Queued" and then "Starting") to green ("Running"):
   
   {{< figure src="osc_running.png" width="600px" caption="" >}}

6. Click `Connect to RStudio Server` at the bottom of the box,
   and an RStudio Server instance will open.

### Test whether you can load the *tidyverse*

Several commonly used packages will be automatically available to you at OSC,
and that should include the *tidyverse*.
Test whether you can load the *tidyverse* by running `library(tidyverse)`,
and check whether you get output similar to what is shown below
(exact versions of packages may differ):

```r
library(tidyverse)

── Attaching packages ──────────────────────────────────────────────────────────
───────────────────────────────────────────── tidyverse 1.3.1 ──
✔ ggplot2 3.3.6     ✔ purrr   0.3.4
✔ tibble  3.1.7     ✔ dplyr   1.0.9
✔ tidyr   1.2.0     ✔ stringr 1.4.0
✔ readr   2.1.2     ✔ forcats 0.5.1
── Conflicts ───────────────────────────────────────────────────────────────────
─────────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()
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

## More info {#more}

Please see our **[R Resources and Tips](/tutorials/r-resources-tips/)** page for:

- [Resources to get started with R](/tutorials/r-resources-tips/#r-resources)
- [Useful R and RStudio settings](/tutorials/r-resources-tips/#useful-settings)
- [The basics of installing packages in R](/tutorials/r-resources-tips/#installing-r-packages)
- [Instructions for updating R](/tutorials/r-resources-tips/#updating-r)

<br/> <br/> <br/>

----
