
# For presenters

- Each Code Club session is a separate post on the website.

- Regular presenters will be given direct access to the [Github repository](https://github.com/biodash/biodash.github.io)
  and will be able to push a new post to the website directly.

- Occasional presenters can either send their material directly to [Jelmer](mailto:poelstra.1@osu.edu)
  or create a "pull request" with their new post.

<br>

## Step 1: Clone the repo

You only need to do this if you want to create a pull request or push your content to the website
directly. If you want to just create and send an R Markdown file by email, continue to Step 2.

```sh
# Clone the repo:
git clone git@github.com:biodash/biodash.github.io.git

# Create a new branch, here called "my-branch":
git checkout -b my-branch
```

<br>

## Step 2: Create a new post in R

- If you don't have the `hugodown` package installed, install it:
  ```r
  remotes::install_github("r-lib/hugodown")
  ```
- To create a new "post bundle", which is a separate folder for a post, with an R Markdown file
  that has many useful YAML header tags already present:
  ```r
  # In the abstract:
  hugodown::use_post('post/<session-number>_<short-title>')
  # An example:
  hugodown::use_post('post/01_intro-to-R')
  ```
  The `<session-number>` is the actual Code Club session number,
  and `<short-title>` is a short title that you would like to give the post,
  which will be used for links and the folder name.

- Write your actual post in R Markdown format.

- Convert your `.Rmd` (R Markdown) file to a `.md` (Markdown) file, which is done most easitly by "knitting" your post in RStudio by clicking `Knit` in the top bar or pressing `Ctrl + Shift + K`.

<br>

## Step 3: Get your post onto the website

### Option A: Create a pull request

TBA

### Option B: Push a new post to the site repo (direct access required)

TBA 

<br/> <br/> <br/> <br/>
