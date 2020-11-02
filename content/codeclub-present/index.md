---
toc: true
---

# Information for Presenters

----

<br>

## Introduction

- Each Code Club session represents a blogpost on the website at <https://biodash.github.io/post/>.

- Regular presenters will be given direct access to the [Github repository](https://github.com/biodash/biodash.github.io)
  and will be able to push a new post to the website directly.

- Occasional presenters can either send their material directly to [Jelmer](mailto:poelstra.1@osu.edu)
  or create a "pull request" with their new post.

<br>

----

## Checklist

An overview of what to do; see the sections further down on how to do it.

- Get the session info onto the website **about 1 week before the session**. 
  
  - At this point, your post should contain information on the topic and
    recommended prep for participants.
  
  - Additional content such as intro slides and example code can be included
    right away, or added just before the session.

- Include a link to an R script/markdown that participants can download.

- If your session includes a dataset, upload it and include code
  in the abovementioned script/markdown file that will download the dataset file(s).

<br>

----

## Getting your files onto the site

### 1: Get the repo

You only need to do this if you want to create a pull request or push your content to the website
directly. If you want to send your R Markdown file by email, skip this and continue to Step 2.

The following assumes you have git installed (if not, see [these instructions](https://github.com/git-guides/install-git)),
and a Github account (if not, sign up [here](https://github.com/join)).

- Go to a dir that you would like to be the parent dir of the Biodash/Codeclub repo:
  ```sh
  cd my-dir
  ```

- Clone the repo:
  ```sh
  git clone git@github.com:biodash/biodash.github.io.git
  ```

- Move into the newly downloaded repo dir:
  ```sh
  cd biodash
  ```

- Create a new branch (by way of example called "my-branch") and switch to it:
  ```sh
  git checkout -b my-branch
  ```

<br>

----

### 2: Create a post

- Start an R session. If you don't have the `hugodown` package installed, install it:
  ```r
  remotes::install_github("r-lib/hugodown")
  ```
- A *post bundle* is a separate folder for a post which will hold the R Markdown file
  that contains the post, as well as associated images and so on.
  To create a post bundle along with a R Markdown file that already has many useful YAML header tags:
  ```r
  hugodown::use_post('post/<session-number>_<short-title>')
  # An example would be: hugodown::use_post('post/01_intro-to-R')
  ```
  The `<session-number>` is the actual Code Club session number,
  and `<short-title>` is a short title that you would like to give the post,
  which will be used for links and the folder name.

- Write the contents of your Code Club session that you would like to share with participants, in R Markdown format.
  For formatting tips, see [below](/codeclub-present/#format).

- **If you want participants to load an R Markdown file or script:**   
  An easy solution is to place the file in the same directory as your post, and include it in your git commit,
  so it will be uploaded to Github. In that case, the URL to the file for direct downloads for participants will be:
  `https://raw.githubusercontent.com/biodash/biodash.github.io/master/docs/post/<session-number>_<short-title>/<filename>`.   
  
  In your post, include a function call like `file.download(<script-URL>)` for participants to get the file --
  this will work both for participants working locally and those working in an OSC RStudio Server instance.

- **If your session contains a dataset:**   
  Like for the markdown/script, place the file(s) in the same directory as your post.
  If you have a markdown/script for participants, include `file.download(<dataset-URL>)` in this file,
  otherwise include it directly in your post.

- Convert your `.Rmd` (R Markdown) file to a `.md` (Markdown) file.
  Since your output was specified as `hugodown::md_document` when you called `hugodown::use_post()`
  (and not as a HTML file -- recall that Hugo will perform the markdown to HTML conversion),
  this is done most easily by "knitting" your post in RStudio by clicking `Knit` in the top bar,
  or by pressing `Ctrl + Shift + K`.
  
<br>

----

### 3: Preview your post (optional)

You can do this in two ways, from RStudio or from the command line.

#### Option A: In RStudio

- Install Hugo:
  ```r
  hugodown::hugo_install("0.66.0")
  ```

- Preview the site:
  ```r
  hugodown::hugo_start()
  ```

#### Option B: From the command line

- Install Hugo using [these instructions](https://gohugo.io/getting-started/installing/).

- Serve the website locally:
  ```sh
  hugo serve
  ```
  You will see a message that includes "*Web Server is available at [...]*".
  Click the link or copy and paste the address into a browser, and you will see the rendered website.
  Until you press `Ctrl + C` on the command line, the server will keep running and will update
  whenever you save changes in a file within the website directory.

<br>

----

### 4: Commit

- Add the files from your post:
  ```sh
  git add post/<your-post-name>/*
  ```

- Commit:
  ```sh
  git commit -m "Add CodeClub session <session-nr> by <your-name>"
  ```

<br>

----

### 5: Push or submit pull request

Your Markdown (`.md`) file will be built along with the rest of the website by a program called Hugo 
(Hugo does not recognize R Markdown (`Rmd`) files, that's why you needed to Knit your R Markdown yourself).

This will eventually be done automatically via Github actions; but as long as that has not yet been set up,
Jelmer will manually call Hugo to build the website. 

<br>

#### Option A: Create a pull request

When you create a *pull request*, you are asking the maintainers of a repository
to *pull* your changes into their repository. 

- Push to your branch:
  ```sh
  git push origin my-branch
  ```

- Create the pull request:
  - Go to the Pull requests page of our repo at <https://github.com/biodash/biodash.github.io/pulls>.
  - Click the green button on the right that says `New pull request`.
  - In the grey bar on top, in the button that says `Compare: <branch>`, make sure the branch specifiied is your branch,
    which we've named `my-branch` in these instructions.
  - Enter a **title** (e.g. "*New Post: Session 6*") and **description** (say a little more about the post) for the pull request.
  - Click the green button `Send pull request`.

<br>

#### Option B: Push to the site repo (direct access required)

- Merge your branch with the main (master) branch:
  ```sh
  git checkout master       # Move to the master branch prior to merging
  git merge my-branch       # Merge into master (assuming your branch was named "my-branch")
  ```

- Push to the master branch:
  ```sh
  git push origin master
  ```

<br>

----

### 6: Install packages at OSC (optional)

Many R packages are already installed at OSC (nearly 200 for R 4.0.2), including the `tidyverse`.
You can check which packages have been installed by typing, in an R session at OSC:
```r
library()
```

This will list packages by library, which should include two locations available to all
OSC users (starting with `/usr/local/R`), your personal library, and the Code Club library
(`/fs/ess/PAS1838/CODECLUB/Rpkgs`).

If you want to make another package available to Code Club participants, you can do so
as follows in an RStudio Server session at OSC:

```r
install.packages("<pkg-name>", lib = "/fs/ess/PAS1838/CODECLUB/Rpkgs")
```

This library is available to all members of the Code Club OSC classroom project.
To check specifically which packages are available in this library -- and whether your newly
installed package has indeed been installed here, type:

```r
library(lib.loc = "/fs/ess/PAS1838/CODECLUB/Rpkgs")
```

Alternatively, you can let participants working at OSC install the packages themselves,
like participants that work locally will have to do.

<br>

----

## Formatting tips {#format}

### Miscellaneous

- If you want a **Table of Contents** (TOC) for your file, add a line `toc: true` to the `YAML`
  (*not* indented, as it is not an option of the output format).

- Add a line saying `source_extension: '.Rmd'` (not indented) to your R Markdown,
  which will ensure that there is a link to the source document at the top of your post.

- To add an image, put it in the same directory as the markdown file,
  and refer to it without prepending a path.

<br>

### Hidden sections

It can be useful to provide solutions to small challenges in the file,
but to hide them by default. This can be done with a little HTML:

````{html}
<details>
  <summary>
  Solution (click here)
  </summary>

<br>
... Your solution - this can be a long section including a code block...
```{r}
install.packages("tidyverse")
```
</details>
````
This is rendered as:
<details>
  <summary>
Solution (click here)
  </summary>

<br>

... Your solution - this can be a long section including a code block...
  ```{r}
install.packages("tidyverse")
```
</details>

<br>

### Info/alert notes

To produce boxes to draw attention to specific content,
you can use two classes that are specific to the [Hugo Academic Theme](https://themes.gohugo.io/academic/)
(now branded as ["Wowchemy"](https://wowchemy.com/)).

- `alert-note` for a blue box with an info symbol:

  ```{HTML}
  <div class="alert alert-note">
  <div>
    This is an alert note.
  </div>
  ```
  
  Which is rendered as:
  
  <div class="alert alert-note">
  <div>
    This is an alert note.
  </div>

- `alert-warning` for a red box with a warning symbol:
  
   ```{HTML}
  <div class="alert alert-warning">
  <div>
    This is an alert warning.
  </div>
  ```

  Which is rendered as:

  <div class="alert alert-warning">
  <div>
    This is an alert warning.
  </div>

<br>

### Shortcodes

Hugo shortcodes are little code snippets for specific content.
Some of these are specific to Wowchemy,
and others are available for any Hugo site.

<br>

#### Highlight text

You can highlight text as follows:

```bash
Here is some {{</* hl */>}}highlighted text{{</* /hl */>}}.
```

This will render as:

Here is some {{< hl >}}highlighted text{{< /hl >}}.

<br>

#### Icons

Wowchemy supports shortcodes for icons, for instance: 

{{< icon name="r-project" pack="fab" >}}
```bash
{{</* icon name="r-project" pack="fab" */>}}
```

{{< icon name="python" pack="fab" >}}  
```bash
{{</* icon name="python" pack="fab" */>}}
```

{{< icon name="terminal" pack="fas" >}}
```bash
{{</* icon name="terminal" pack="fas" */>}}
```

<br>

#### General Hugo shortcodes

- To embed a Youtube video, use the following, replacing "videoID" by the actual ID
  (https://www.youtube.com/watch?v=ID) in 
  ```{bash}
  {{</* youtube ID */>}}
  ```

- To embed a Tweet, use the following, replacing "tweetID" by the actual ID
  (https://twitter.com/user/status/ID): 
    ```{bash}
  {{</* tweet ID */>}}
  ```

For more info and more shortcodes,
see the [Hugo documentation on shortcodes](https://gohugo.io/content-management/shortcodes/).

<br/> <br/> <br/> <br/>
