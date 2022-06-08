### Useful settings

By default, R will try to save your "environment" (e.g., your loaded data, variables, etc)
when you exit, and then reload everything the way it was upon restarting R.
However, doing so is not good practice!
  You should always be able to reproduce your environment given a set of commands
*saved in an R script or R Markdown document*,
whereas saving and reloading your entire environment encourages you to be sloppy about this.

To disable this behavior in RStudio,
click `Tools` > `Global Options` > `General` and set the options as follows:

  {{< figure src="r_environment.png" width="400px" caption="Recommended R/RStudio settings" >}}
