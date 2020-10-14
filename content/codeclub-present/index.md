
# For presenters

- Each Code Club session is a separate post on the website.
- Regular presenters will be given direct access to the [Github repository](https://github.com/biodash/biodash.github.io)
  and will be able to push a new post to the website directly.
- Occasional presenters can either send their material directly to [Jelmer](mailto:poelstra.1@osu.edu)
  or create a "pull request" with their new post.

## How to create a new post in R:

- If you don't have the `hugodown` package installed, install it using `devtools::install_github("r-lib/hugodown")`.
- Use `hugodown::use_post('post/<session-number>_<short-title>')` to create a new "post bundle", which is a separate folder for a post,
  with an R Markdown file that has many useful YAML header tags already present. Here, `<session-number>` should be replaced
  by the actual Code Club session number, and `<short-title>` should be replaced by the actual short title (which will be used
  for links and the folder name) that you would like to give the post. So, an example would be `hugodown::use_post('post/01_intro-to-R')`.


 

<br/> <br/> <br/> <br/>
