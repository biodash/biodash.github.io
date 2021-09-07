---
title: |
  Code Club S02E01:
  An introduction to R (Part 1)
summary: "This first installment of Code Club in the Fall '21 semester is the first of two sessions where we will go through the basics of R."  
authors: [admin]
date: "2021-08-17"
lastmod: "2021-08-17"
output: hugodown::md_document
toc: true
rmd_hash: 0b4af7d80e612a8c

---

<br> <br>

## Learning objectives

> -   Learn what Code Club is all about
> -   Get some basic familiarity with R and RStudio
> -   Understand a bit about R *objects* and how to use them

<br>

------------------------------------------------------------------------

## To do beforehand

Before the Code Club Zoom session, please follow the [Code Club Computer Setup](/codeclub-setup/) instructions.

In brief, you should have R and RStudio installed on your computer *or* you should be set up to run RStudio Server at the Ohio Supercomputer Center (OSC). (As a bonus, you can try to install and load the *tidyverse* package as the setup page suggests, but no sweat if you can't get that to work yet.)

In case you run into issues, contact [Jelmer](mailto:poelstra.1@osu.edu) or for last-minute troubleshooting, you can join the Zoom call 15-30 minutes early.

<br>

------------------------------------------------------------------------

## (Re)Introducing Code Club

OSU Code Club is a regularly occurring online gathering to improve coding skills, now in its second year.

This Code Club was inspired by a paper in PLoS Computational Biology (["Ten simple rules to increase computational skills among biologists with Code Clubs"](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1008119)), and here are some of the underlying ideas:

-   Coding is best learned by doing, so Code Club is interactive and hands-on.

-   *Ongoing* exposure and practice also helps when learning.

-   We aim to keep it informal and maybe even fun.

-   We have a core group of 5 organizers that do most of the presenting, but we also encourage participants to present, and will have a couple of participant-led sessions at the end of this semester (see the [schedule](/codeclub-schedule/)).

#### Organizers

-   Jelmer Poelstra (Molecular and Cellular Imaging Center (MCIC), Wooster Campus)
-   Jessica Cooperstone (Dept. of Horticulture and Crop Science & Dept. of Food Science and Technology)
-   Michael Broe (Dept. of Evolution, Ecology and Organismal Biology)
-   Mike Sovic (Center for Applied Plant Sciences)
-   Stephen Opiyo (MCIC, Columbus Campus)

#### Session structure

Each session consists of an instructional part where you can code along or listen, some exercises in breakout rooms with 3-4 people, and exercise recaps with the entire group.

#### Zoom guidelines

-   We very much welcome questions at any time, so please either unmute yourself and speak, or post in the chat whenever you have a question!

-   Having your camera on helps, *especially* in breakout rooms. We will record the whole-group part of each session, so we understand if some of you prefer to have their cameras off during that part. (But note that we will only share the recordings with other Code Clubbers.)

-   You can use the icons under the "Participants" menu in Zoom when we ask for a "show of hands" or if you are having problems.

-   In breakout rooms:

    -   Briefly introduce yourselves.
    -   Have someone share their screen, preferably one of the least experienced people.
    -   Be friendly and patient, keep everyone aboard.
    -   The Zoom `Ask for help` button will alert us, and one of the organizers will come into the breakout room. (`Raise hand` is not seen by us outside of the room.)

#### Otherwise

-   We need your feedback! Always feel free to email one of the organizers, and for suggestions for a topic to cover in a future Code Club, you can fill out [this form](/codeclub-suggest/)!

-   I will quickly show the Code Club menu and BioDASH website during the session.

-   Zoom polling question: are you working at OSC or locally?

<br>

------------------------------------------------------------------------

## 1 -- Why R?

R is a programming language that is most well-known for being excellent for *statistical analysis* and *data visualization*.

**While the learning curve is steeper than for most programs with graphical user interfaces (GUIs), it pays off to invest in learning R:**

-   R gives you greater **flexibility** to do anything you want.

-   Writing computer instructions as *code*, like you have to do in R, is more **reproducible** than clicking around in a GUI. It also makes it much *easier to redo analyses* with slight modifications!

-   R is highly **interdisciplinary** and can be used with many different kinds of data. To just name two examples, R has a very strong ecosystem for bioinformatics analysis ("Bioconductor" project), and can be used to create maps and perform GIS analyses.

-   R is more than a platform to perform analysis and create figures. **R Markdown** combines R with a simple text markup language to produce *analysis reports* that integrate code, results, and text, and to create *slide decks*, *data dashboards*, *websites*, and even *books*! In the third session of Code Club, Michael Broe will talk more about R Markdown.

-   While not as versatile outside of data-focused topics as a language like Python, R can be used as a general programming language, for instance to **automate tasks** such as large-scale file renaming.

Finally, R:

-   Is open-source and freely available for all platforms (Windows, Mac, Linux).

-   Has a large and welcoming user community.

<br>

------------------------------------------------------------------------

## 2 -- Exploring RStudio

R simply provides a "*console*" (command-line interface) where you can type your commands.

However, because you want to save your commands in scripts and see the graphics that you produce, it is more effective to work in an environment that provides all of this side-by-side. We will use RStudio, an excellent *graphical environment* ("Integrated Development Environment", IDE) for R.

*I will now demonstrate how to start an RStudio Server session from the Ohio Supercomputer Center's website following the steps from our [Code Club Computer Setup page](/codeclub-setup/#osc-run-rstudio).* *If you have RStudio installed on your own computer, start it now, and otherwise, follow along with me to run RStudio in your browser.*

Once you have a running instance of RStudio, **create a new R script** by clicking `File` \> `New File` \> `R Script`.

Now, you should see all 4 "panes" that the RStudio window is divided into:

-   *Top-left*: The **Editor** for your scripts and other documents (*hidden when no file is open*).
-   *Bottom-left*: The **R Console** to interactively run your code (+ a tab with a **Terminal**).
-   *Top-right*: Your **Environment** with R objects you have created (+ several other tabs).
-   *Bottom-left*: Tabs for **Files**, **Plots**, **Help**, and others.

<p align="center">
<img src=img/rstudio-layout-ed.png width="95%">
</p>

So, in RStudio, we have a single interface to write code in text files or directly in the console, visualize plots, navigate the files found on our computer, and inspect the data we are working with.

RStudio has a lot of useful features and during the next few sessions of Code Club, we will introduce some tips and tricks for working with it.

<br>

------------------------------------------------------------------------

## Breakout rooms I (\~5 min.)

<div class="puzzle">

<div>

#### Introduce yourselves!

We'll return to the same breakout room configuration later in this session to do a few exercises, so please take a moment to introduce yourself to your breakout roommates. Make sure to also mention:

-   Your level of experience with R and other coding languages.

-   What you are aiming to use or are already using R for.

<br>

#### Check that everyone has RStudio working

-   Take a moment to explore the RStudio interface.

-   If you run into issues, click the `Ask for help` button in Zoom and one of us will come by.

</div>

</div>

------------------------------------------------------------------------

<br>

## 3 -- Interacting with R

#### R as a calculator

The lower-left RStudio pane, i.e. **the R console**, is where you can interact with R directly.

The **[`>`](https://rdrr.io/r/base/Comparison.html)** sign is the R "prompt". It indicates that R is ready for you to type something.

Let's start by performing a division:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='m'>203</span> <span class='o'>/</span> <span class='m'>2.54</span>
<span class='c'>#&gt; [1] 79.92126</span></code></pre>

</div>

R does the calculation and prints the result in the console as well. Afterwards, you get your **[`>`](https://rdrr.io/r/base/Comparison.html)** prompt back. (The `[1]` may look a bit weird when there is only one output element; this is how you can keep count of output elements when there are many.)

With the expected set of symbols, you can use R as a general calculator:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='m'>203</span> <span class='o'>*</span> <span class='m'>2.54</span>   <span class='c'># Multiplication</span>
<span class='c'>#&gt; [1] 515.62</span>
<span class='m'>203</span> <span class='o'>+</span> <span class='m'>2.54</span>   <span class='c'># Addition</span>
<span class='c'>#&gt; [1] 205.54</span></code></pre>

</div>

Note that pressing the *up arrow* key will put your previous command back on the prompt, and you can press the *up arrow* again to go further back (as well as the *down arrow* to go in the other direction).

<br>

#### Experimenting a bit...

What if we add spaces around our values?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'>         <span class='m'>203</span>                     <span class='o'>-</span> <span class='m'>2.54</span>
<span class='c'>#&gt; [1] 200.46</span></code></pre>

</div>

This works: as it turns out, R simply ignores any extra spaces.

Similarly, we *could* omit the single spaces around the mathematical operators that we used earlier (though we will keep using them for clarity):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='m'>203</span><span class='o'>/</span><span class='m'>2.54</span>
<span class='c'>#&gt; [1] 79.92126</span></code></pre>

</div>

<br>

How about:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'>203 /</code></pre>

</div>

Now the *prompt* turned into a [`+`](https://rdrr.io/r/base/Arithmetic.html) instead of the usual [`>`](https://rdrr.io/r/base/Comparison.html).

<details>
<summary>
<b>What is going on here?</b> (Click for the answer)
</summary>

<br>

R is waiting for you to finish the command, since you typed an incomplete command: something has to follow the division sign [`/`](https://rdrr.io/r/base/Arithmetic.html).

While it was obvious here that our command was incomplete, you will often type incomplete commands without realizing you did so. Just remember that when you see the [`+`](https://rdrr.io/r/base/Arithmetic.html) prompt, *something* has to be missing in your command: most commonly, you'll have forgotten a closing parenthesis `)` or you accidentally opened up an unwanted opening parenthesis `(`.

If you want to *abort* completing the incomplete command, you can press <kbd>Esc</kbd>.
</details>

<br>

And if we just type a number:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='m'>203</span>
<span class='c'>#&gt; [1] 203</span></code></pre>

</div>

R will print the number back to us! It turns out that the default, implicit action that R will perform on anything you type is to print it back to us (under the hood, it is calling a *function* called [`print()`](https://rdrr.io/r/base/print.html)).

<br>

Instead of a number, what if we try to have R print some *text* (a character string) back to us?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>Fantastic</span>
<span class='c'>#&gt; Error in eval(expr, envir, enclos): object 'Fantastic' not found</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'>Code Club
<span class='c'>#&gt; Error: &lt;text&gt;:1:6: unexpected symbol</span>
<span class='c'>#&gt; 1: Code Club</span>
<span class='c'>#&gt;          ^</span></code></pre>

</div>

<details>
<summary>
<b>What seems to be going wrong here?</b> (Click for the answer)
</summary>

<br>

Whenever you type a character string, R expects to find an *object* with that name (we will get to what exactly objects are in a little bit!). When no object exists with that name, R will throw an error. We will learn some of the basics of objects in section 5 of today's session.

</details>

<br>

We *can* get R to print character strings back to us, and work with strings in other ways, as long as we quote them:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='s'>"Fantastic"</span>
<span class='c'>#&gt; [1] "Fantastic"</span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## 4 -- Working with a script

#### Need for scripts

We can go along like this, typing commands directly into the R console. But to keep better track of what we're doing, it's a good idea to write code in plain text files, i.e. to write "**scripts**".

-   You should have already created a script above (otherwise, click `File` \> `New File` \> `R Script`).

-   Click `File` \> `Save As` to save the script; give it a descriptive name like `intro-to-R.R`.  
    (You may want to put the script in a new subfolder for this Code Club session.)

<br>

#### Interacting with the R console from your script

We recommend that you generally *type your commands into a script* and execute the commands from there, instead of typing directly into the console.

We want to make sure to save our division command, so start by typing the following into the R script in the top-left pane:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='m'>203</span> <span class='o'>/</span> <span class='m'>2.54</span></code></pre>

</div>

With the cursor still on this line, press <kbd>Ctrl</kbd> + <kbd>Enter</kbd>. The command will be copied to the R console and executed, and then the cursor will move to the next line.

Note that it doesn't matter where on the line your cursor is: <kbd>Ctrl</kbd> + <kbd>Enter</kbd> will execute the entire line unless you have selected only part of it.

(And when you have selected multiple lines of code, <kbd>Ctrl</kbd> + <kbd>Enter</kbd> will execute them all.)

<br>

#### Commenting

You can use `#` signs to annotate (comment) your code. Anything to the right of a `#` is ignored by R, meaning it won't be executed. You can use `#` both at the start of a line or anywhere in a line following code.

Comments are a great way to describe what your code does within the code itself, so comment liberally in your R scripts! This is useful not only for others that you may share your code with, but perhaps especially for yourself when you look back at your code a day, a month, or a year later.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># Divide by 2.54 to get the wingspan in inches:</span>
<span class='m'>203</span> <span class='o'>/</span> <span class='m'>2.54</span>    <span class='c'># Original measurement was in cm</span></code></pre>

</div>

<br>

------------------------------------------------------------------------

## 5 -- R Objects

#### Assigning stuff to R objects

We can assign any value, character, or set of values or characters to an *object* with the assignment operator, [`<-`](https://rdrr.io/r/base/assignOps.html). (This is a smaller-than sign [`<`](https://rdrr.io/r/base/Comparison.html) followed by a dash [`-`](https://rdrr.io/r/base/Arithmetic.html).)[^1]

For example:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>wingspan_cm</span> <span class='o'>&lt;-</span> <span class='m'>203</span>
<span class='nv'>conversion</span> <span class='o'>&lt;-</span> <span class='m'>2.54</span></code></pre>

</div>

Type that into your script, and use <kbd>Ctrl</kbd> + <kbd>Enter</kbd> to send it to the console.

The objects you create get added to your "workspace" or "environment." RStudio shows this in the **Environment tab** in the topright panel -- check to see if `wingspan_cm` and `conversion` are indeed there.

After you've assigned a number to an object, you can use it in other calculations:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>wingspan_inch</span> <span class='o'>&lt;-</span> <span class='nv'>wingspan_cm</span> <span class='o'>/</span> <span class='nv'>conversion</span>
<span class='nv'>wingspan_inch</span>
<span class='c'>#&gt; [1] 79.92126</span></code></pre>

</div>

More generally speaking, the object name that you provide is substituted with its contents by R, so the object name is just a *reference* to the underlying value.

Our objects so far contained just a single number and we may have also called them *variables*. Object is the more general name that encompasses R items of any size or complexity. As we see will see next week, R distinguishes between different *types* of objects.

<br>

#### Object names

Objects can be given any name such as `x`, `current_temperature`, or `subject_id`.

Some pointers on object names:

-   Because R is case sensitive, `wingspan_inch` is different from `Wingspan_inch`.

-   An object name cannot contain a space, so for readability, separate words using:

    -   **`_`** -- e.g. `wingspan_inch` (this is called "snake case", which we will tend to use in Code Club instructional materials)
    -   **`.`** -- e.g. `wingspan.inch`
    -   *capitalization* -- e.g. `wingspanInch` or `WingspanInch` ("camel case")

-   Object names can contain but cannot start with a number (`2x` is not valid, but `x2` is)[^2].

-   Make object names descriptive yet not too long.

You will make things easier for yourself by naming objects in a consistent way, for instance by always sticking to your favorite case like "snake case."[^3]

<br>

<div class="alert alert-note">

<div>

#### Objects, your workspace, and closing R

When you close R, it will probably ask you whether you want to save your workspace (*"Save workspace image to \~/.RData"*). When you do so, then the next time you start R, you can reload everything the way it was, such as your previously created objects.

While this may seem convenient, we recommend that you don't do this.

<details>
<summary>
<b>Can you think of a reason why saving and reloading your workspace may not be a good idea?</b> (Click for the answer)
</summary>

<br>

The main reason why this is generally not considered good practice relates to the idea that you should be able to *reproduce your workspace (and more broadly speaking, your analysis) from the code in your script*.

Remember that you can modify your workspace either by entering commands in the console directly, or by running them from a script -- or even from multiple different scripts. Also, in practice, you often run lines in the script out of order, or write lines in the script that you don't execute.

Therefore, if you "carry around" the same workspace across multiple different sessions, you run a greater risk of not having a reproducible set of steps in your script.

To make RStudio stop asking you about saving your workspace, click `Tools` \> `Global Options` \> `General` and set the options as follows:

<p align="center">
<img src=img/r_environment.png width="50%">
</p>

Taking these ideas a step further, it can be a good idea to occasionally restart R so you can check whether the code in your script is correct and complete, that you are not relying on code that is not in the script, and so on. To do so, you don't need to close and reopen RStudio itself: under `Session` in the top menu bar, you can click `Restart R` (and you should also see the keyboard shortcut for it in the menu bar, which is <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>F10</kbd> for Windows/Linux, and <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>F10</kbd> for Mac).

</details>

</div>

</div>

<br>

------------------------------------------------------------------------

## Breakout rooms II (5-10 min.)

*Note that in both of these exercises, the answers are not contained in what we just discussed. I would like you to think about your intuition for R's behavior, and then see if R indeed works that way or not.*

<div class="puzzle">

<div>

### Exercise 1: Object "linkage"

What do you think the value of `y` will be after executing the following lines in R? 100 or 160, and why?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>x</span> <span class='o'>&lt;-</span> <span class='m'>50</span>       <span class='c'># x is now 50</span>
<span class='nv'>y</span> <span class='o'>&lt;-</span> <span class='nv'>x</span> <span class='o'>*</span> <span class='m'>2</span>    <span class='c'># y is now 100</span>
<span class='nv'>x</span> <span class='o'>&lt;-</span> <span class='m'>80</span>       <span class='c'># x is now 80, but what is y?</span></code></pre>

</div>

<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

Objects don't get linked to each other, so if you change one object, it won't affect the values of other objects that were defined earlier.

**Therefore, `y` will continue to be `100`.**

</details>

</div>

</div>

<div class="puzzle">

<div>

### Exercise 2: Errors... (Bonus)

In section 3, you might have noticed that we got a different error when typing one versus multiple unquoted words. Here are those examples again:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>Fantastic</span>
<span class='c'>#&gt; Error in eval(expr, envir, enclos): object 'Fantastic' not found</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'>Code Club
<span class='c'>#&gt; Error: &lt;text&gt;:1:6: unexpected symbol</span>
<span class='c'>#&gt; 1: Code Club</span>
<span class='c'>#&gt;          ^</span></code></pre>

</div>

Reproduce these errors for yourself: in Rstudio's editor pane, type these or equivalent error-generating examples in a script saved with a `.R` extension, and send them to the console.

Why is the error in the second case different, and what does it mean?

<details>
<summary>
<b>Hints</b> (click here)
</summary>

<br>

-   Can you see how RStudio can "notice" errors already in the editor -- but only for the second of these two examples? The editor checks for *syntax* ("R grammar") errors but not whether objects already exist.

    <figure>
    <p align="center">

    <img src=img/rstudio_syntax-error.png width="60%">

    <figcaption>

    If you hover over the red cross in the margin, you can see what RStudio is upset about.

    </figcaption>
    </p>
    </figure>

-   What if we put a [`+`](https://rdrr.io/r/base/Arithmetic.html) or another operator between the two words?

    <div class="highlight">

    <pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>Code</span> <span class='o'>+</span> <span class='nv'>Club</span>
    <span class='c'>#&gt; Error in eval(expr, envir, enclos): object 'Code' not found</span></code></pre>

    </div>

</details>
<details>
<summary>
<b>Solution</b> (click here)
</summary>

<br>

When typing a single unquoted word which is not an existing object, R will look for an object and then complain that it can't find that object.

When typing multiple unquoted words with a space between them, regardless of whether those are existing objects, R will notice a *syntax ("R grammar") error* before it even gets around to checking objects.

The problem is that you are referring to two objects sequentially and without any mathematical operator in between them, or some other syntax to "join" them. In R, that's not valid syntax. (You may think it would perhaps simply try to print both objects, but this is not the case.)

</details>

A general lesson here is that you should always pay attention to the details of the error messages that you get. While the language may seem terse and odd at first, it usually holds important clues as to what is going wrong exactly.

</div>

</div>

------------------------------------------------------------------------

## In closing

#### Where to go from here

For a list of recommended resources for learning R, see our [R Resources and Tips page](/tutorials/r-resources-tips/) page.

#### Attribution

This was modified after material from [The Carpentries](https://carpentries.org/), especially from [this Data Carpentry workshop](http://uw-madison-aci.github.io/2016-06-01-uwmadison/) and [this "R for Ecology" workshop](https://datacarpentry.org/R-ecology-lesson).

<br> <br>

[^1]: In RStudio, typing <kbd>Alt</kbd> + <kbd>-</kbd> will write [`<-`](https://rdrr.io/r/base/assignOps.html) in a single keystroke. You can also use [`=`](https://rdrr.io/r/base/assignOps.html) as assignment, but that symbol can have other meanings, so we recommend sticking with the [`<-`](https://rdrr.io/r/base/assignOps.html) combination.

[^2]: There are some names that cannot be used because they are the names of fundamental keywords in R (e.g., `if`, `else`, `for`, see [here](https://stat.ethz.ch/R-manual/R-devel/library/base/html/Reserved.html) for a complete list). In general, it's best not to use other function names even if it's "allowed" (e.g., `c`, `T`, `mean`, `data`, `df`, `weights`). If in doubt, check the Help to see if the name is already in use.

[^3]: It is also recommended to use *nouns* for variable names, and *verbs* for function names. For more, two popular R style guides are [Hadley Wickham's](http://adv-r.had.co.nz/Style.html) and [Google's](https://google.github.io/styleguide/Rguide.xml).

