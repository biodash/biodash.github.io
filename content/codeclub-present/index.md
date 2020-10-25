
# For presenters

- Each Code Club session represents a blogpost on the website at <https://biodash.github.io/post/>.

- Regular presenters will be given direct access to the [Github repository](https://github.com/biodash/biodash.github.io)
  and will be able to push a new post to the website directly.

- Occasional presenters can either send their material directly to [Jelmer](mailto:poelstra.1@osu.edu)
  or create a "pull request" with their new post.

<br>

## Step 1: Get the repo

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

## Step 2: Create a new post in R

- Start an R session.

- If you don't have the `hugodown` package installed, install it:
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

- Write your actual post in R Markdown format.

- Convert your `.Rmd` (R Markdown) file to a `.md` (Markdown) file, which is done most easitly by "knitting" your post in RStudio by clicking `Knit` in the top bar or pressing `Ctrl + Shift + K`.

<br>

## Step 3: Check your post on a locally rendered website (optional)

You can do this in two ways, from RStudio or from the command line.

### Option A: In RStudio

- Install Hugo:
  ```r
  hugodown::hugo_install("0.66.0")
  ```

- Preview the site:
  ```r
  hugodown::hugo_start()
  ```

### Option B: From the command line

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

## Step 4: Commit your changes

- Add the files from your post:
  ```sh
  git add post/<your-post-name>/*
  ```

- Commit:
  ```sh
  git commit -m "Add CodeClub session <session-nr> by <your-name>"
  ```

- Merge your branch with the main (master) branch:
  ```sh
  git checkout master       # Move to the master branch prior to merging
  git merge my-branch       # Merge into master (assuming your branch was named "my-branch")
  ```

<br>

## Step 5: Get your post onto the website repo

Your Markdown (`.md`) file will be built along with the rest of the website by a program called Hugo 
(Hugo does not recognize R Markdown (`Rmd`) files, that's why you needed to Knit you R Markdown yourself).

This will eventually be done automatically via Github actions; but as long as that has not yet been set up,
Jelmer will manually call Hugo to build the website. 

### Option A: Create a pull request

TBA

### Option B: Push to the site repo (direct access required)

```sh
git push origin master
```

<br/> <br/> <br/> <br/>
