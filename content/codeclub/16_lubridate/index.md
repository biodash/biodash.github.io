---
title: "Session 16: lubridate"
subtitle: "Working with dates and times in R."
summary: "Today, we will learn how to work effectively with dates and times in R using the lubridate package."  
authors: [stephen-opiyo]
date: "2021-03-31"
output: hugodown::md_document
toc: true
image:
  caption: "Artwork by @allison_horst"
  focal_point: ""
  preview_only: false
rmd_hash: 9b797fa51275aca4

---

<br> <br> <br>

------------------------------------------------------------------------

## New to Code Club?

-   If you didn't already do this, please follow the [Code Club Computer Setup](/codeclub-setup/04_ggplot2/) instructions, which also has pointers for if you're new to R or RStudio.

-   If you're able to do so, please open RStudio a bit before Code Club starts -- and in case you run into issues, please join the Zoom call early and we'll help you troubleshoot.

<br>

------------------------------------------------------------------------

## 1. Getting set up

R has a range of functions that allow you to work with dates and times. However, today we will discuss how to work with dates and times in R using the package "*lubridate*".

While *lubridate* is *tidyverse*-style, it is not part of the core *tidyverse*, so we need to install it.

We are also going to use the bird data that was first discussed in Code Club session 1, and we will need to download that.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># If needed, install the lubridate package:</span>
<span class='c'># install.packages("lubridate")</span>

<span class='c'># Load the tidyverse and lubridate:</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://lubridate.tidyverse.org'>lubridate</a></span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># Create a dir for our bird data ("recursive" to create two levels at once):</span>
<span class='nf'><a href='https://rdrr.io/r/base/files2.html'>dir.create</a></span><span class='o'>(</span><span class='s'>"data/birds/"</span>, recursive <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>

<span class='c'># The URL to our file:</span>
<span class='nv'>birds_file_url</span> <span class='o'>&lt;-</span> <span class='s'>"https://raw.githubusercontent.com/biodash/biodash.github.io/master/assets/data/birds/backyard-birds_Ohio.tsv"</span>

<span class='c'># The path to the file that we want to download the data to:</span>
<span class='nv'>birds_file</span> <span class='o'>&lt;-</span> <span class='s'>"data/birds/backyard-birds_Ohio.tsv"</span>

<span class='c'># Download:</span>
<span class='nf'><a href='https://rdrr.io/r/utils/download.file.html'>download.file</a></span><span class='o'>(</span>url <span class='o'>=</span> <span class='nv'>birds_file_url</span>, destfile <span class='o'>=</span> <span class='nv'>birds_file</span><span class='o'>)</span>

<span class='c'># Read the data:</span>
<span class='nv'>birds</span> <span class='o'>&lt;-</span> <span class='nf'>read_tsv</span><span class='o'>(</span>file <span class='o'>=</span> <span class='nv'>birds_file</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

</div>

<br>

------------------------------------------------------------------------

## 2. What is *lubridate*?

*lubridate* provides tools that make it easier to parse and manipulate dates.

We will discuss the common use of lubridate under the following themes:

1.  Parsing dates

2.  Manipulating dates  
    a) *Instants*: Rounding dates, time zones  
    b) *Time spans*: Durations, periods, intervals

<br>

------------------------------------------------------------------------

## 3. Parsing dates

*lubridate*'s parsing functions read strings into R as "date-time" objects. Year is represented by `y`, month by `m`, and day by `d`.

Strings can be parsed using the following functions: [`dmy()`](http://lubridate.tidyverse.org/reference/ymd.html), [`myd()`](http://lubridate.tidyverse.org/reference/ymd.html), [`ymd()`](http://lubridate.tidyverse.org/reference/ymd.html), [`ydm()`](http://lubridate.tidyverse.org/reference/ymd.html), [`dym()`](http://lubridate.tidyverse.org/reference/ymd.html), [`mdy()`](http://lubridate.tidyverse.org/reference/ymd.html), [`ymd_hms()`](http://lubridate.tidyverse.org/reference/ymd_hms.html).

*Let us look at some examples*

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># parsing by year, month, day</span>
<span class='nf'><a href='http://lubridate.tidyverse.org/reference/ymd.html'>ymd</a></span><span class='o'>(</span><span class='m'>20170131</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "2017-01-31"</span>


<span class='c'># parsing by month, day, year</span>
<span class='nf'><a href='http://lubridate.tidyverse.org/reference/ymd.html'>mdy</a></span><span class='o'>(</span><span class='s'>"December 1st, 2020"</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "2020-12-01"</span>


<span class='c'># parsing by day, month, year</span>
<span class='nf'><a href='http://lubridate.tidyverse.org/reference/ymd.html'>dmy</a></span><span class='o'>(</span><span class='s'>"01-Dec-2020"</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "2020-12-01"</span>


<span class='nf'><a href='http://lubridate.tidyverse.org/reference/ymd.html'>dmy</a></span><span class='o'>(</span><span class='s'>"01/Dec/2020"</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "2020-12-01"</span>


<span class='nf'><a href='http://lubridate.tidyverse.org/reference/ymd.html'>dmy</a></span><span class='o'>(</span><span class='s'>"01Dec2020"</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "2020-12-01"</span>


<span class='c'># parsing by year, month, day, hour, minutes, and seconds</span>
<span class='nf'><a href='http://lubridate.tidyverse.org/reference/ymd_hms.html'>ymd_hms</a></span><span class='o'>(</span><span class='s'>"2020-01-31 20:11:59"</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "2020-01-31 20:11:59 UTC"</span>
</code></pre>

</div>

<br>

------------------------------------------------------------------------

## 4. Manipulating dates: Instants

*lubridate* distinguishes between *moments* in time (instants) and *spans* of time (time spans).

Instants are specific moments of time. They are a combination of measurements on different units (i.e, years, months, days, etc.).

-   [`now()`](http://lubridate.tidyverse.org/reference/now.html) returns the current system time.  
-   [`today()`](http://lubridate.tidyverse.org/reference/now.html) returns the current system date.

The individual values for [`now()`](http://lubridate.tidyverse.org/reference/now.html) and [`today()`](http://lubridate.tidyverse.org/reference/now.html) units can be extracted from an instant and set with the accessor functions [`second()`](http://lubridate.tidyverse.org/reference/second.html), [`minute()`](http://lubridate.tidyverse.org/reference/minute.html), [`hour()`](http://lubridate.tidyverse.org/reference/hour.html), [`day()`](http://lubridate.tidyverse.org/reference/day.html), [`yday()`](http://lubridate.tidyverse.org/reference/day.html), [`mday()`](http://lubridate.tidyverse.org/reference/day.html), [`wday()`](http://lubridate.tidyverse.org/reference/day.html), [`week()`](http://lubridate.tidyverse.org/reference/week.html), [`month()`](http://lubridate.tidyverse.org/reference/month.html), and [`year()`](http://lubridate.tidyverse.org/reference/year.html).

*Let us look at some examples*

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># Find the current system date using function today ()</span>
<span class='nf'><a href='http://lubridate.tidyverse.org/reference/now.html'>today</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "2021-03-31"</span>


<span class='c'># Find the current system time using function now ()</span>
<span class='nv'>Now</span> <span class='o'>&lt;-</span> <span class='nf'><a href='http://lubridate.tidyverse.org/reference/now.html'>now</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='nv'>Now</span>

<span class='c'>#&gt; [1] "2021-03-31 17:26:48 EDT"</span>


<span class='c'># Extract the day of the month from an object Now using function mday ()</span>
<span class='nf'><a href='http://lubridate.tidyverse.org/reference/day.html'>mday</a></span><span class='o'>(</span><span class='nv'>Now</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 31</span>


<span class='c'># Extract the day of the week from an object Now using function wday()</span>
<span class='nf'><a href='http://lubridate.tidyverse.org/reference/day.html'>wday</a></span><span class='o'>(</span><span class='nv'>Now</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 4</span>


<span class='c'># Extract the week of the year from an object Now using function week ()</span>
<span class='nf'><a href='http://lubridate.tidyverse.org/reference/week.html'>week</a></span><span class='o'>(</span><span class='nv'>Now</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 13</span>


<span class='c'># Extract the month from an object Now using function month ()</span>
<span class='nf'><a href='http://lubridate.tidyverse.org/reference/month.html'>month</a></span><span class='o'>(</span><span class='nv'>Now</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 3</span>


<span class='c'># Extract the year from an object Now using function year ()</span>
<span class='nf'><a href='http://lubridate.tidyverse.org/reference/year.html'>year</a></span><span class='o'>(</span><span class='nv'>Now</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 2021</span>
</code></pre>

</div>

### Rounding instants

Instants can be *rounded* to a convenient unit using the functions [`ceiling_date()`](http://lubridate.tidyverse.org/reference/round_date.html), [`floor_date()`](http://lubridate.tidyverse.org/reference/round_date.html), and [`round_date()`](http://lubridate.tidyverse.org/reference/round_date.html).

-   [`ceiling_date()`](http://lubridate.tidyverse.org/reference/round_date.html) takes a date-time object and rounds it up to the nearest boundary of the specified time unit.

-   [`round_date()`](http://lubridate.tidyverse.org/reference/round_date.html) takes a date-time object and time unit, and rounds it to the nearest value of the specified time unit.

-   [`floor_date()`](http://lubridate.tidyverse.org/reference/round_date.html) takes a date-time object and rounds it down to the nearest boundary of the specified time unit.

*Let us look at some examples*

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='http://lubridate.tidyverse.org/reference/round_date.html'>ceiling_date</a></span><span class='o'>(</span><span class='nv'>Now</span>, unit <span class='o'>=</span> <span class='s'>"minute"</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "2021-03-31 17:27:00 EDT"</span>


<span class='nf'><a href='http://lubridate.tidyverse.org/reference/round_date.html'>round_date</a></span><span class='o'>(</span><span class='nv'>Now</span>, unit <span class='o'>=</span> <span class='s'>"minute"</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "2021-03-31 17:27:00 EDT"</span>


<span class='nf'><a href='http://lubridate.tidyverse.org/reference/round_date.html'>floor_date</a></span><span class='o'>(</span><span class='nv'>Now</span>, unit <span class='o'>=</span> <span class='s'>"minute"</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "2021-03-31 17:26:00 EDT"</span>
</code></pre>

</div>

### Time zones

Naming time zones is challenging because everyday names of time zones tend to be ambiguous. For example, USA has EST, or Eastern Standard Time. However, both Australia and Canada also have EST!

To avoid confusion, R uses the international standard IANA time zones. These use a consistent naming scheme "/", typically in the form `<continent>/<city>` (there are a few exceptions because not every country lies on a continent). Examples include `America/New_York`, `Europe/Paris`, and `Pacific/Auckland`.

Unless otherwise specified, *lubridate* always uses UTC. UTC (Coordinated Universal Time) is the standard time zone used by the scientific community and roughly equivalent to its predecessor GMT (Greenwich Mean Time).

Example: [`ymd_hms("2021-03-27 11:54:54 EDT", tz="America/New_York")`](http://lubridate.tidyverse.org/reference/ymd_hms.html)

<br>

------------------------------------------------------------------------

## 4. Manipulating dates: Time spans

A timespan is a length of time that may or may not be connected to a particular instant. For example, two months is a timespan. *lubridate* has three timespan classes: Durations, Periods and Intervals.

### Durations

Durations measure the exact amount of time that occurs between two instants.

Functions for working with durations include [`is.duration()`](http://lubridate.tidyverse.org/reference/duration.html), [`as.duration()`](http://lubridate.tidyverse.org/reference/as.duration.html) and [`duration()`](http://lubridate.tidyverse.org/reference/duration.html). For specific lengths, [`dseconds()`](http://lubridate.tidyverse.org/reference/duration.html), [`dminutes()`](http://lubridate.tidyverse.org/reference/duration.html), [`dhours()`](http://lubridate.tidyverse.org/reference/duration.html), [`ddays()`](http://lubridate.tidyverse.org/reference/duration.html), [`dweeks()`](http://lubridate.tidyverse.org/reference/duration.html) and [`dyears()`](http://lubridate.tidyverse.org/reference/duration.html) convenient lengths.

### Periods

Periods measure the change in clock time that occurs between two instants.

Functions for working with periods include [`is.period()`](http://lubridate.tidyverse.org/reference/period.html), [`as.period()`](http://lubridate.tidyverse.org/reference/as.period.html) and [`period()`](http://lubridate.tidyverse.org/reference/period.html). [`seconds()`](http://lubridate.tidyverse.org/reference/period.html), [`minutes()`](http://lubridate.tidyverse.org/reference/period.html), [`hours()`](http://lubridate.tidyverse.org/reference/period.html), [`days()`](http://lubridate.tidyverse.org/reference/period.html), [`weeks()`](http://lubridate.tidyverse.org/reference/period.html), [`months()`](https://rdrr.io/r/base/weekday.POSIXt.html) and [`years()`](http://lubridate.tidyverse.org/reference/period.html) quickly create periods of convenient lengths.

### Intervals

Intervals are timespans that begin at a specific instant and end at a specific instant. Intervals retain complete information about a timespan. They provide the only reliable way to convert between periods and durations.

Functions for working with intervals include [`is.interval()`](http://lubridate.tidyverse.org/reference/interval.html), [`as.interval()`](http://lubridate.tidyverse.org/reference/as.interval.html), [`interval()`](http://lubridate.tidyverse.org/reference/interval.html), [`int_shift()`](http://lubridate.tidyverse.org/reference/interval.html), [`int_flip()`](http://lubridate.tidyverse.org/reference/interval.html), [`int_aligns()`](http://lubridate.tidyverse.org/reference/interval.html), [`int_overlaps()`](http://lubridate.tidyverse.org/reference/interval.html).

*Let us look at an example*

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># John was born on 19841014. How old is John</span>
<span class='nv'>h_age</span> <span class='o'>&lt;-</span> <span class='nf'><a href='http://lubridate.tidyverse.org/reference/now.html'>today</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>-</span> <span class='nf'><a href='http://lubridate.tidyverse.org/reference/ymd.html'>ymd</a></span><span class='o'>(</span><span class='m'>19841014</span><span class='o'>)</span>
<span class='nv'>h_age</span>

<span class='c'>#&gt; Time difference of 13317 days</span>


<span class='c'># Time difference in days</span>
<span class='nf'><a href='http://lubridate.tidyverse.org/reference/as.duration.html'>as.duration</a></span><span class='o'>(</span><span class='nv'>h_age</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "1150588800s (~36.46 years)"</span>
</code></pre>

</div>

<br>

------------------------------------------------------------------------

## 5. Plotting the bird data

We will plot the bird data using *ggplot2*.

First, we plot a bar graph of days of the week:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>birds</span> <span class='o'>%&gt;%</span>
  <span class='nf'>mutate</span><span class='o'>(</span>Wday <span class='o'>=</span> <span class='nf'><a href='http://lubridate.tidyverse.org/reference/day.html'>wday</a></span><span class='o'>(</span><span class='nv'>eventDate</span>, label <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>Wday</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_bar</span><span class='o'>(</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-8-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Second, we'll plot the relative relative abundance of different bird orders by day of the week:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>birds</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>mutate</span><span class='o'>(</span>Wday <span class='o'>=</span> <span class='nf'><a href='http://lubridate.tidyverse.org/reference/day.html'>wday</a></span><span class='o'>(</span><span class='nv'>eventDate</span>, label <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>Wday</span>, fill <span class='o'>=</span> <span class='nv'>order</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_bar</span><span class='o'>(</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-9-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<br>

------------------------------------------------------------------------

## 6. Breakout rooms!

<div class="puzzle">

<div>

### Exercise 1

Jane was born on January 31st, 1992. How old is Jane today?

<details>
<summary>
Hints (click here)
</summary>

<br> Use the functions [`today()`](http://lubridate.tidyverse.org/reference/now.html), [`mdy()`](http://lubridate.tidyverse.org/reference/ymd.html), and [`as.duration()`](http://lubridate.tidyverse.org/reference/as.duration.html).

</details>

<br>

<details>
<summary>
Solution (click here)
</summary>
<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>Jane_age</span> <span class='o'>&lt;-</span> <span class='nf'><a href='http://lubridate.tidyverse.org/reference/now.html'>today</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>-</span> <span class='nf'><a href='http://lubridate.tidyverse.org/reference/ymd.html'>mdy</a></span><span class='o'>(</span><span class='s'>"January 31st, 1992"</span><span class='o'>)</span>
<span class='nf'><a href='http://lubridate.tidyverse.org/reference/as.duration.html'>as.duration</a></span><span class='o'>(</span><span class='nv'>Jane_age</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "920332800s (~29.16 years)"</span>
</code></pre>

</div>

</details>

</div>

</div>

<div class="puzzle">

<div>

### Exercise 2

Plot a horizontal bar chart of bird orders.

<details>
<summary>
Hints (click here)
</summary>

<br> Use the `coord_flip()` function.

</details>

<br>

<details>
<summary>
Solution (click here)
</summary>
<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>birds</span> <span class='o'>%&gt;%</span>
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>order</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_bar</span><span class='o'>(</span>fill <span class='o'>=</span> <span class='s'>"#f68034"</span>, alpha <span class='o'>=</span> <span class='m'>0.6</span>, width <span class='o'>=</span> <span class='m'>0.4</span><span class='o'>)</span> <span class='o'>+</span>
<span class='nf'>coord_flip</span><span class='o'>(</span><span class='o'>)</span> 

</code></pre>
<img src="figs/unnamed-chunk-11-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

</div>

<div class="puzzle">

<div>

### Bonus exercise

Remove the order "Passeriformes" from the bird data, and plot relative abundance of order based on days of the week.

<details>
<summary>
Hints (click here)
</summary>

<br> Use the functions [`filter()`](https://rdrr.io/r/stats/filter.html) and `mutate()`.

</details>

<br>

<details>
<summary>
Solution (click here)
</summary>
<br>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># Remove Passeriformes:</span>
<span class='nv'>birds_a</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>birds</span>, <span class='nv'>order</span> <span class='o'>!=</span> <span class='s'>"Passeriformes"</span><span class='o'>)</span>

<span class='c'># Create the plot:</span>
<span class='nv'>birds_a</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>mutate</span><span class='o'>(</span>Wday <span class='o'>=</span> <span class='nf'><a href='http://lubridate.tidyverse.org/reference/day.html'>wday</a></span><span class='o'>(</span><span class='nv'>eventDate</span>, label <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>Wday</span>, fill <span class='o'>=</span> <span class='nv'>order</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_bar</span><span class='o'>(</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-12-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

</div>

