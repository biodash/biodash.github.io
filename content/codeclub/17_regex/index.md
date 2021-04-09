---
title: "Session 17: Introduction to regular expressions"
subtitle: "With help from The Great British Bake Off"
summary: "In the first in a mini-series on working with strings in R, we will learn some basics of regular expressions."  
authors: [admin]
date: "2021-04-06"
output: hugodown::md_document
toc: true
toc_depth: 2
image:
  caption: "Artwork by @allison_horst"
  focal_point: ""
  preview_only: false
rmd_hash: e776414e9edf5016

---

<br> <br> <br>

------------------------------------------------------------------------

## New to Code Club?

-   If you didn't already do this, please follow the [Code Club Computer Setup](/codeclub-setup/) instructions, which also has pointers for if you're new to R or RStudio.

-   If you're able to do so, please open RStudio a bit before Code Club starts -- and in case you run into issues, please join the Zoom call early and we'll help you troubleshoot.

<br>

------------------------------------------------------------------------

## 1. Getting set up

While base R also has functions to work with regular expressions (such as [`grep()`](https://rdrr.io/r/base/grep.html) and [`regexp()`](https://rdrr.io/r/base/regex.html)), we will work with the *stringr* package, one of the core *tidyverse* packages.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>## If needed, install the tidyverse:</span>
<span class='c'># install.packages("tidyverse")</span>

<span class='c'>## Load the tidyverse -- this will include loading "stringr". </span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
</code></pre>

</div>

To get access to some strings that we can match with regular expressions, we will use the *bakeoff* data package:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>## If needed, first install the "remotes" package:</span>
<span class='c'># install.packages("remotes")</span>

<span class='nf'>remotes</span><span class='nf'>::</span><span class='nf'><a href='https://remotes.r-lib.org/reference/install_github.html'>install_github</a></span><span class='o'>(</span><span class='s'>"apreshill/bakeoff"</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://bakeoff.netlify.com'>bakeoff</a></span><span class='o'>)</span>
</code></pre>

</div>

<br>

------------------------------------------------------------------------

## 2. Regular expressions: what and why?

You would probably have no trouble recognizing internet and email addresses, most phone numbers, or a DNA sequence embedded in a piece of text. And you would do so even if these were presented without context, and even though you may have never seen that *specific* email address, DNA sequence, and so on.

We can recognize these things because they adhere to certain patterns: a DNA sequence, for instance, typically consists of a sequence of capital As, Cs, Gs, and Ts.

**Regular expressions provide a way to describe and match text that contains specific patterns to computers**, with expressions that convey things like *"any digit"* and *"one or more or the previous character or character type"*. For example, **`\d{5}`** is a regular expression that matches at least five consecutive digits and would be a good start to finding all US ZIP codes embedded in a piece of text.

Regular expressions are extremely useful for a couple of related purposes:

-   **Finding and extracting information that adheres to patterns**

    -   Finding addresses, citations, or identifiers such as accession numbers.

    -   Finding degenerate primers (or the DNA sequence between them) or transcription factor binding sites, in which certain positions may vary.

    -   Finding DNA repeats: you know that something is repeated, but not what is.

    -   While we often *generalize* and *constrain* matches at the same time, we could also merely constrain them:

        -   Only find instances of "*chocolate*" if it is the first or last word of a line/sentence/string.

        -   Only find instances of "*chocolate*" which are followed by "cake", "tart", or "croissant".

<br>

-   **Sophisticated find-and-replace**

    -   Replace multiple variations of the same thing at once:  
        e.g. change all DNA repeats to lowercase letters or Ns.

    -   Change a date format from `M/DD/YY` to `YYYY-MM-DD`, or GPS coordinates in degrees/minutes/seconds format to decimal degrees (note that this needs a bit of conversion too).

    -   Rename files: switch sample ID and treatment ID separated by underscores,  
        or pad numbers (`1`-`100` =\> `001`-`100` for proper ordering).

Finally, regular expressions can be used to **parse and convert file formats**, though you generally don't have to do this yourself unless you are dealing with highly custom file types.

**Regular expressions are used in nearly all programming languages. They are also widely used in text editors and therefore provide a first taste of programming for many people.**

<br>

------------------------------------------------------------------------

## 3. `str_view()` and strings

Today, to get to know regular expressions, we will just use the `str_view()` function from the *stringr* package. Next week, we'll get introduced to other *stringr* functions to search and also to replace strings.

The basic syntax is `str_view(<target-string(s)>, <search-pattern>)`, for example:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view</span><span class='o'>(</span><span class='s'>"chocolate"</span>, <span class='s'>"cola"</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/cola.png" width="15%" style="display: block; margin: auto auto auto 0;" />

</div>

`str_view()` shows us which part of the target string was matched in the `Viewer` pane of RStudio. This particular match is rather obvious because we searched for a "literal string" without any special meaning. However, the visual representation will become useful when we start using special characters in our regular expressions: then, we know what *pattern* we should be matching, but not what *exact string* we actually matched.

If we want to see all matches, and not just the first one, we have to use `str_view_all`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view</span><span class='o'>(</span><span class='s'>"chocolate"</span>, <span class='s'>"o"</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/one_o.png" width="15%" style="display: block; margin: auto auto auto 0;" />

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='s'>"chocolate"</span>, <span class='s'>"o"</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/two_o.png" width="15%" style="display: block; margin: auto auto auto 0;" />

</div>

*stringr* functions are vectorized, so we can use them not just to match a single string but also to match a vector of strings:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>desserts</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"plum pudding"</span>, <span class='s'>"chocolate cake"</span>, <span class='s'>"sticky toffee pudding"</span><span class='o'>)</span>
<span class='nf'>str_view</span><span class='o'>(</span><span class='nv'>desserts</span>, <span class='s'>"pudding"</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/vector1.png" width="30%" style="display: block; margin: auto auto auto 0;" />

</div>

Note that the non-matching string "*chocolate cake*" was displayed despite the lack of a match. If we only want to see strings that matched, we can set the `match` argument to `TRUE`:

<div class="highlight">

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view</span><span class='o'>(</span><span class='nv'>desserts</span>, <span class='s'>"pudding"</span>, match <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/vector2.png" width="30%" style="display: block; margin: auto auto auto 0;" />

</div>

{{% callout note %}} **Strings in R**

A "string" or "character string" is a contiguous sequence of characters. To indicate that something is a string in R, we put quotes around it: `"Hello"` and `"9"`. If you forget the quotes, R would interpret `"Hello"` as an *object* (because it starts with a letter) and `"9"` as a *number* (because it starts with a digit).

There is *no difference* between single quotes (`'Hello'`) and double quotes (`"Hello"`), but double quotes are generally recommended.

If your string is itself supposed to contain a quote symbol of some kind, it is convenient to use the *other type* of quote to define the string:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># The string contains a single quote, so we use double quotes to define it:</span>
<span class='s'>"This cake's 7th layer is particularly good."</span>

<span class='c'>#&gt; [1] "This cake's 7th layer is particularly good."</span>
</code></pre>

</div>

Alternatively, a quote can be **escaped** using a backslash **`\`** to indicate that it does *not end the string* but represents a literal quote *inside the string*, which may be necessary if a string contains both single and double quotes:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='s'>"This cake is only 2'4\" tall - do better!"</span>

<span class='c'>#&gt; [1] "This cake is only 2'4\" tall - do better!"</span>
</code></pre>

</div>

{{% /callout %}}

<br>

------------------------------------------------------------------------

## 4. Special characters

#### Special characters and escaping them

In regular expressions (regex), we need a way to succinctly convey descriptions such as "any character" or "any digit". *However, there are no characters exclusive to regular expressions:* *instead, we re-use normal characters.* For instance:

-   "**Any character**" is represented by a period, **`.`**
-   "**Any digit**" is represented by **`\d`**, with the **`\`** basically preventing the **`d`** from being interpreted literally.

But how, then, do we indicate a literal **`.`** or **`\`** in a regular expression? The solution is to **escape** the special character with a backslash: the regular expression **`\.`** matches a **`.`**.

{{% callout note %}}

#### TLDR for the rest of this section

**When writing regular expressions as strings in R,** **we always need to add an extra backslash:**

-   The regex **`\d`** matches a digit --- and we write it as **`"\\d"`** in R.
-   The regex **`\.`** matches a period --- and we write it as **`"\\."`** in R.

{{% /callout %}}

The "escaping" described above also applies to backslashes, such that the regex **`\\`** matches a **`\`**.

<br>

#### Escape sequences in regular strings

Outside of regular expressions, R also uses backslashes **`\`** to form so-called "escape sequences". This works similarly to how the regular expression **`\d`** means "any digit" -- for example, when we use **`\n`** *in any string*, it will be interpreted as a newline:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/cat.html'>cat</a></span><span class='o'>(</span><span class='s'>"cho\nco"</span><span class='o'>)</span>

<span class='c'>#&gt; cho</span>
<span class='c'>#&gt; co</span>
</code></pre>

</div>

In fact, a single backslash **`\`** is **never taken literally** in any regular R string:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'>cat("cho\dco")

<span class='c'>#&gt; Error: '\d' is an unrecognized escape in character string starting ""cho\d"</span>
</code></pre>

</div>

Because this is *not* a regular expression, and **`\d`** does not happen to be an escape sequence like **`\n`** was earlier, **`\d`** doesn't mean anything to R. But instead of assuming that the backslash is therefore a literal backslash, R throws an error, demonstrating that a backslash is always interpreted as the first character in an escape sequence.

How can we include a backslash in a string, then? Same as before: we "escape" it with another backslash:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/cat.html'>cat</a></span><span class='o'>(</span><span class='s'>"bla\\dbla"</span><span class='o'>)</span>

<span class='c'>#&gt; bla\dbla</span>
</code></pre>

</div>

<br>

#### The backslash plague

We saw that the regular expression **`\d`** matches a digit, but also that using string **`"\d"`** will merely throw an error!

Therefore, to actually define a regular expression that contains **`\d`**, we need to use the string **`"\\d"`**:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'>str_view("The cake has 8 layers", "\d")

<span class='c'>#&gt; Error: '\d' is an unrecognized escape in character string starting ""\d"</span>
</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view</span><span class='o'>(</span><span class='s'>"The cake has 8 layers"</span>, <span class='s'>"\\d"</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/digit1.png" width="30%" style="display: block; margin: auto auto auto 0;" />

</div>

**So, to define any regular expression symbol that contains a backslash,** **we need to always use two backslashes!**

This also applies when we want to match a literal character. For example, **to match a literal period, we need the regex `\.`,** **which we have to write as `\\.` in an R string:**

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view</span><span class='o'>(</span><span class='s'>"The cake has 8.5 layers"</span>, <span class='s'>"\\."</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/period2.png" width="30%" style="display: block; margin: auto auto auto 0;" />

</div>

Now to the worst case: what if we want to match a backslash? We need the regular expression **`\\`**, but to define that regex as a string, we have to escape each of the two backslashes -- only to end up with four backslashes!

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view</span><span class='o'>(</span><span class='s'>"C:\\Windows"</span>, <span class='s'>"\\"</span><span class='o'>)</span>

<span class='c'>#&gt; Error in stri_locate_first_regex(string, pattern, opts_regex = opts(pattern)): Unrecognized backslash escape sequence in pattern. (U_REGEX_BAD_ESCAPE_SEQUENCE, context=`\`)</span>
</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view</span><span class='o'>(</span><span class='s'>"C:\\Windows"</span>, <span class='s'>"\\\\"</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/windows.png" width="15%" style="display: block; margin: auto auto auto 0;" />

</div>

Welcome to the backslash plague! [^1]

<br>

------------------------------------------------------------------------

## 5. The Great British Bake Off

<p align="center">
<img src=img/bakeoff.jpg width=60%>
</p>

Let's take a look at some of the data in the *bakeoff* package, which is about "The Great British Bake Off" (GBBO) television show.

The `bakers` dataframe contains some information about each participant (baker) in the show, and we will be matching names from the `baker_full` column:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>bakers</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 8</span></span>
<span class='c'>#&gt;   series baker_full   baker    age occupation   hometown  baker_last baker_first</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>        </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>        </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>      </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>      </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> 1      </span><span style='color: #555555;'>"</span><span>Annetha Mi… Annet…    30 Midwife      Essex     Mills      Annetha    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> 1      </span><span style='color: #555555;'>"</span><span>David Cham… David     31 Entrepreneur Milton K… Chambers   David      </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> 1      </span><span style='color: #555555;'>"</span><span>Edward \"E… Edd       24 Debt collec… Bradford  Kimber     Edward     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> 1      </span><span style='color: #555555;'>"</span><span>Jasminder … Jasmi…    45 Assistant C… Birmingh… Randhawa   Jasminder  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> 1      </span><span style='color: #555555;'>"</span><span>Jonathan S… Jonat…    25 Research An… St Albans Shepherd   Jonathan   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> 1      </span><span style='color: #555555;'>"</span><span>Lea Harris</span><span style='color: #555555;'>"</span><span> Lea       51 Retired      Midlothi… Harris     Lea</span></span>
</code></pre>

</div>

The `challenge_results` dataframe contains "signature" and "showstopper" bakes made by each participant in each episode:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>challenge_results</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 7</span></span>
<span class='c'>#&gt;   series episode baker  result signature        technical showstopper           </span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span>      1       1 Annet… IN     Light Jamaican …         2 Red, White &amp; Blue Cho…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span>      1       1 David  IN     Chocolate Orang…         3 Black Forest Floor Ga…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span>      1       1 Edd    IN     Caramel Cinnamo…         1 </span><span style='color: #BB0000;'>NA</span><span>                    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span>      1       1 Jasmi… IN     Fresh Mango and…        </span><span style='color: #BB0000;'>NA</span><span> </span><span style='color: #BB0000;'>NA</span><span>                    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span>      1       1 Jonat… IN     Carrot Cake wit…         9 Three Tiered White an…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span>      1       1 Louise IN     Carrot and Oran…        </span><span style='color: #BB0000;'>NA</span><span> Never Fail Chocolate …</span></span>
</code></pre>

</div>

The "signature" bakes are the first bakes presented in each GBBO episode, so we'll start trying to match these bakes with regular expressions. Let's save them in a vector for easy access later on:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>signatures</span> <span class='o'>&lt;-</span> <span class='nv'>challenge_results</span><span class='o'>$</span><span class='nv'>signature</span>     <span class='c'># Assign the column to a vector</span>
<span class='nv'>signatures</span> <span class='o'>&lt;-</span> <span class='nv'>signatures</span><span class='o'>[</span><span class='o'>!</span><span class='nf'><a href='https://rdrr.io/r/base/NA.html'>is.na</a></span><span class='o'>(</span><span class='nv'>signatures</span><span class='o'>)</span><span class='o'>]</span>  <span class='c'># Remove NAs</span>

<span class='nv'>signatures</span><span class='o'>[</span><span class='m'>1</span><span class='o'>:</span><span class='m'>20</span><span class='o'>]</span>                              <span class='c'># Look at the first 20 items</span>

<span class='c'>#&gt;  [1] "Light Jamaican Black Cakewith Strawberries and Cream"                       </span>
<span class='c'>#&gt;  [2] "Chocolate Orange Cake"                                                      </span>
<span class='c'>#&gt;  [3] "Caramel Cinnamon and Banana Cake"                                           </span>
<span class='c'>#&gt;  [4] "Fresh Mango and Passion Fruit Hummingbird Cake"                             </span>
<span class='c'>#&gt;  [5] "Carrot Cake with Lime and Cream Cheese Icing"                               </span>
<span class='c'>#&gt;  [6] "Carrot and Orange Cake"                                                     </span>
<span class='c'>#&gt;  [7] "Triple Layered Brownie Meringue Cake\nwith Raspberry Cream"                 </span>
<span class='c'>#&gt;  [8] "Three Tiered Lemon Drizzle Cakewith Fresh Cream and freshly made Lemon Curd"</span>
<span class='c'>#&gt;  [9] "Cranberry and Pistachio Cakewith Orange Flower Water Icing"                 </span>
<span class='c'>#&gt; [10] "Sticky Marmalade Tea Loaf"                                                  </span>
<span class='c'>#&gt; [11] "Cheddar Cheese and Fresh Rosemary Biscuits"                                 </span>
<span class='c'>#&gt; [12] "Oatmeal Raisin Cookie"                                                      </span>
<span class='c'>#&gt; [13] "Millionaires' Shortbread"                                                   </span>
<span class='c'>#&gt; [14] "Honey and Candied Ginger Cookies"                                           </span>
<span class='c'>#&gt; [15] "Fresh Vanilla Biscuits with Royal Icing"                                    </span>
<span class='c'>#&gt; [16] "Peanut Shortbread withSalted Peanut Caramel"                                </span>
<span class='c'>#&gt; [17] "Rose Petal Shortbread"                                                      </span>
<span class='c'>#&gt; [18] "Stained Glass Window Shortbread"                                            </span>
<span class='c'>#&gt; [19] "Chilli Bread"                                                               </span>
<span class='c'>#&gt; [20] "Olive Bread"</span>
</code></pre>

</div>

<br>

------------------------------------------------------------------------

## 6. Components of regular expressions

### Literal characters

Literal characters can be a part of regular expressions. In fact, as we saw in the first example, our entire search pattern for `str_view()` can perfectly well consist of *only* literal characters.

But the power of regular expressions comes with special characters, and below, we'll go through several different categories of these.

### Metacharacters

Above, we already learned that **`.`** matches any single character. Other metacharacters, that is, characters that represent a single instance of **a character type**, are actually character combinations starting with a **`\`**.

| Symbol   | Matches                                                | Negation ("anything but") |
|----------|--------------------------------------------------------|---------------------------|
| **`.`**  | Any single character.                                  |                           |
| **`\d`** | Any digit.                                             | **`\D`**                  |
| **`\s`** | Any white space: space, tab, newline, carriage return. | **`\S`**                  |
| **`\w`** | Any word character: alphanumeric and underscore.       | **`\W`**                  |
| **`\n`** | A newline.                                             |                           |
| **`\t`** | A tab.                                                 |                           |

Negated metacharacters match anything except that character type: **`\D`** matches anything except a digit.

*Some examples:*

-   Are there any digits (**`\d`**) in the bake names?

    <div class="highlight">

    <pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>signatures</span>, <span class='s'>"\\d"</span>, match <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
    </code></pre>

    </div>

    <div class="highlight">

    <img src="img/digit2.png" width="27%" style="display: block; margin: auto auto auto 0;" />

    </div>

<br>

-   What about periods? Note that we need to escape the period with two **`\\`**.

    <div class="highlight">

    <pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>signatures</span>, <span class='s'>"\\."</span>, match <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
    </code></pre>

    </div>

    <div class="highlight">

    <img src="img/period.png" width="50%" style="display: block; margin: auto auto auto 0;" />

    </div>

<br>

-   Let's match 5-character strings that start with "*Ma*":

    <div class="highlight">

    <pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>signatures</span>, <span class='s'>"Ma..."</span>, match <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
    </code></pre>

    </div>

    <div class="highlight">

    <img src="img/ma.png" width="90%" style="display: block; margin: auto auto auto 0;" />

    </div>

    Note that the only constraint we are setting with **`...`** is that at least three characters should follow **`Ma`** -- we are *not* restricting matches to five-character words, or something along those lines.

<br>

-   Let's find the bakers whose (first or last) names contain at least 11 word characters **`\w`**:

    <div class="highlight">

    <pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>bakers</span><span class='o'>$</span><span class='nv'>baker_full</span>, <span class='s'>"\\w\\w\\w\\w\\w\\w\\w\\w\\w\\w\\w"</span>, match <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
    </code></pre>

    </div>

    <div class="highlight">

    <img src="img/11letternames.png" width="25%" style="display: block; margin: auto auto auto 0;" />

    </div>

    It's not very convenient to have to repeat `\\w` so many times!

Or let's say we wanted to get all three-part names: names that contain three sets of one or more word characters separated by non-word characters. How could we describe such a pattern? "Quantifiers" to the rescue!

### Quantifiers

Quantifiers describe how many consecutive instances of the **preceding** character should be matched:

| Quantifier  | Matches                                                   |
|-------------|-----------------------------------------------------------|
| **[`*`](https://rdrr.io/r/base/Arithmetic.html)**     | Preceding character *any number of times* (0 or more).    |
| **[`+`](https://rdrr.io/r/base/Arithmetic.html)**     | Preceding character *at least* once (1 or more).          |
| **[`?`](https://rdrr.io/r/utils/Question.html)**     | Preceding character *at most* once (0 or 1).              |
| **`{n}`**   | Preceding character *exactly `n` times*.                  |
| **`{n,}`**  | Preceding character *at least `n` times*.                 |
| **`{n,m}`** | Preceding character *at least `n` and at most `m` times*. |

*Some examples:*

-   Names with at least 11 (**`{11,}`**) characters -- note that this matches the entire word:

    <div class="highlight">

    <pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view</span><span class='o'>(</span><span class='nv'>bakers</span><span class='o'>$</span><span class='nv'>baker_full</span>, <span class='s'>"\\w&#123;11,&#125;"</span>, match<span class='o'>=</span><span class='kc'>TRUE</span><span class='o'>)</span>
    </code></pre>

    </div>

    <div class="highlight">

    <img src="img/11letternames2.png" width="25%" style="display: block; margin: auto auto auto 0;" />

    </div>

<br>

-   Match the entire string (full names -- by flanking the pattern with **`.*`**) of names with 2 to 3 (**`{2,3}`**) consecutive "*e*" characters:

    <div class="highlight">

    <pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view</span><span class='o'>(</span><span class='nv'>bakers</span><span class='o'>$</span><span class='nv'>baker_full</span>, <span class='s'>".*e&#123;2,3&#125;.*"</span>, match<span class='o'>=</span><span class='kc'>TRUE</span><span class='o'>)</span>
    </code></pre>

    </div>

    <div class="highlight">

    <img src="img/2or3es_fullmatch.png" width="17%" style="display: block; margin: auto auto auto 0;" />

    </div>

<br>

-   Account for different spelling options with **[`?`](https://rdrr.io/r/utils/Question.html)** -- match "*flavor*" or "*flavour*":

    <div class="highlight">

    <pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>signatures</span>, <span class='s'>"flavou?r"</span>, match<span class='o'>=</span><span class='kc'>TRUE</span><span class='o'>)</span>
    </code></pre>

    </div>

    <div class="highlight">

    <img src="img/flavor.png" width="65%" style="display: block; margin: auto auto auto 0;" />

    </div>

<br>

-   Match all three-part names -- one or more word characters (**`\w+`**) separated by a non-word character (**`\W`**) at least two consecutive times:

    <div class="highlight">

    <pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view</span><span class='o'>(</span><span class='nv'>bakers</span><span class='o'>$</span><span class='nv'>baker_full</span>, <span class='s'>"\\w+\\W\\w+\\W\\w+"</span>, match<span class='o'>=</span><span class='kc'>TRUE</span><span class='o'>)</span>
    </code></pre>

    </div>

    <div class="highlight">

    <img src="img/3partnames.png" width="30%" style="display: block; margin: auto auto auto 0;" />

    </div>

<br>

-   Match all three-letter names by looking for non-word characters (**`\W`**) surrounding three word characters (**`\w{3}`**)?

    <div class="highlight">

    <pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>bakers</span><span class='o'>$</span><span class='nv'>baker_full</span>, <span class='s'>"\\W\\w&#123;3&#125;\\W"</span>, match <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
    </code></pre>

    </div>

    <div class="highlight">

    <img src="img/3letternames1.png" width="30%" style="display: block; margin: auto auto auto 0;" />

    </div>

That last attempt didn't really work -- note that we only got three-letter *middle names*, since we required our three-letter names to be flanked by non-word characters.

To get *all* three-letter names, we need to be able to "anchor" our regular expressions, e.g. demand that a pattern starts at the beginning of the string.

### Anchors

| Anchor | Matches                      |
|--------|------------------------------|
| [`^`](https://rdrr.io/r/base/Arithmetic.html)    | Beginning of the string/line |
| [`$`](https://rdrr.io/r/base/Extract.html)    | End of the string/line       |
| `\b`   | A word *boundary*            |

*Some examples:*

-   Match all three-letter *first* names, by anchoring the three word characters (**`\w{3}`**) to the beginning of the string with **[`^`](https://rdrr.io/r/base/Arithmetic.html)**, and including a space at the end:

    <div class="highlight">

    <pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view</span><span class='o'>(</span><span class='nv'>bakers</span><span class='o'>$</span><span class='nv'>baker_full</span>, <span class='s'>"^\\w&#123;3&#125; "</span>, match <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
    </code></pre>

    </div>

    <div class="highlight">

    <img src="img/3letterfirstnames.png" width="23%" style="display: block; margin: auto auto auto 0;" />

    </div>

-   Match all three-letter names --first or last-- by matching three word-characters (**`\w`**) surrounded by word-boundaries (**`\b`**):

    <div class="highlight">

    <pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>bakers</span><span class='o'>$</span><span class='nv'>baker_full</span>, <span class='s'>"\\b\\w&#123;3&#125;\\b"</span>, match <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
    </code></pre>

    </div>

    <div class="highlight">

    <img src="img/3letternames2.png" width="23%" style="display: block; margin: auto auto auto 0;" />

    </div>

#### Regex components for next week

Next week, we'll talk about:

-   Character classes
-   Alternation
-   Grouping
-   Backreferences
-   Making quantifiers non-greedy

<br>

{{% callout note %}} **Regular expressions vs globbing**

Do not confuse regular expressions with *globbing*!

If you have worked in a terminal before, you may know that you can match file names using *shell wildcards*, which is known as "globbing".

There are only a few characters used in shell wildcards, but their meanings differ from regular expressions in two instances!

| Shell wildcard         | Equivalent regex | Meaning                                 |
|------------------------|------------------|-----------------------------------------|
| **[`?`](https://rdrr.io/r/utils/Question.html)**                | **`.`**          | Any single character                    |
| **[`*`](https://rdrr.io/r/base/Arithmetic.html)**                | **`.*`**         | Any number of any character             |
| **`[]`** and **`[^]`** | same!            | Match/negate match of *character class* |

-   Note also that **`.`** is interpreted as a literal period in globbing.
-   We will talk about "character classes" next week.

{{% /callout %}}

<br>

------------------------------------------------------------------------

## 7. Breakout rooms

<div class="puzzle">

<div>

### Exercise 1

Find all participant names in `bakers$baker_full` that contain at least 4 lowercase "*e*" characters. (That, the "*e*"s don't need to be consecutive, but you should not disallow consecutive "*e*"s either.)

<details>
<summary>
Hints
</summary>

Use `.*` to allow for *optional* characters in between the "e"s.

</details>
<details>
<summary>
Solution
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view</span><span class='o'>(</span><span class='nv'>bakers</span><span class='o'>$</span><span class='nv'>baker_full</span>, <span class='s'>"e.*e.*e.*e"</span>, match <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/ex1.png" width="30%" style="display: block; margin: auto auto auto 0;" />

</div>

</details>

</div>

</div>

<div class="puzzle">

<div>

### Exercise 2

In the `signatures` vector, match words of exactly five characters that start with "*Ta*".

<details>
<summary>
Hints
</summary>

-   To describe the five-letter word you should include three word characters after "*Ta*".

-   To exclusively match five-letter words, you should use the "word boundary" anchor before and after the part that should match the word.

</details>
<details>
<summary>
Solution
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>signatures</span>, <span class='s'>"\\bTa\\w&#123;3&#125;\\b"</span>, match <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/ex2.png" width="75%" style="display: block; margin: auto auto auto 0;" />

</div>

</details>

</div>

</div>

<div class="puzzle">

<div>

### Exercise 3

Match "*Donut*" as well as "*Doughnut*" in the `signatures` vector.

Unfortunately, `signatures` only contains the spelling "Doughnut". Therefore, you should separately test whether your regex would actually match "Donut".

<details>
<summary>
Hints
</summary>

Since "*donut*" is contained within "*doughnut*", you can build a single regex and use **[`?`](https://rdrr.io/r/utils/Question.html)** to indicate optional characters.

</details>
<details>
<summary>
Solution
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>signatures</span>, <span class='s'>"Dou?g?h?nut"</span>, match<span class='o'>=</span><span class='kc'>TRUE</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/ex3_1.png" width="90%" style="display: block; margin: auto auto auto 0;" />

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='nv'>signatures</span>, <span class='s'>"Donut"</span><span class='o'>)</span>, <span class='s'>"Dou?g?h?nut"</span>, match<span class='o'>=</span><span class='kc'>TRUE</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/ex3_2.png" width="90%" style="display: block; margin: auto auto auto 0;" />

</div>

</details>

</div>

</div>

<div class="puzzle">

<div>

### Exercise 4

Match both dates in the string: "*The best cakes were baked between 2016-03-10 and 2017-08-31.*".

<details>
<summary>
Hints
</summary>

Make sure you use `str_view_all()` and not `str_view()`!

</details>
<details>
<summary>
Solution
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>mystring</span> <span class='o'>&lt;-</span> <span class='s'>"The best cakes were baked between 2016-03-10 and 2017-08-31."</span>

<span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>mystring</span>, <span class='s'>"\\d&#123;4&#125;-\\d&#123;2&#125;-\\d&#123;2&#125;"</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/ex4.png" width="80%" style="display: block; margin: auto auto auto 0;" />

</div>

</details>

</div>

</div>

<div class="puzzle">

<div>

### Bonus exercise

You can use the [`list.files()`](https://rdrr.io/r/base/list.files.html) function in R to list files on your computer. [`list.files()`](https://rdrr.io/r/base/list.files.html) takes an argument `pattern` to which you can specify a regular expression in order to narrow down the results.

For example, the code below would find all files with "*codeclub*" in the name, from your current working directory (the default for the `path` argument) and downwards (due to `recursive = TRUE`):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/list.files.html'>list.files</a></span><span class='o'>(</span>pattern <span class='o'>=</span> <span class='s'>"codeclub"</span>, recursive <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
</code></pre>

</div>

You can also specify a path -- for instance, the code below would search your home or (on Windows) Documents directory and nothing below it:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/list.files.html'>list.files</a></span><span class='o'>(</span>path <span class='o'>=</span> <span class='s'>"~"</span>, pattern <span class='o'>=</span> <span class='s'>"codeclub"</span><span class='o'>)</span> <span class='c'># "~" is your home dir</span>
<span class='nf'><a href='https://rdrr.io/r/base/list.files.html'>list.files</a></span><span class='o'>(</span>path <span class='o'>=</span> <span class='s'>"C:/Users/myname/Documents"</span>, pattern <span class='o'>=</span> <span class='s'>"codeclub"</span><span class='o'>)</span>
</code></pre>

</div>

**Use this function to list only R scripts, i.e. files *ending in* `.R`,** **in a directory of your choice.**

<details>
<summary>
Hints
</summary>

Make sure to use the "end of string" anchor.

</details>
<details>
<summary>
Solution
</summary>

Here we are searching the the home dir and everything below it -- could take a while, but then you know how many R scripts you actually have!

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/list.files.html'>list.files</a></span><span class='o'>(</span>path <span class='o'>=</span> <span class='s'>"~"</span>, pattern <span class='o'>=</span> <span class='s'>"\\.R$"</span>, recursive <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
</code></pre>

</div>

</details>

</div>

</div>

<br>

------------------------------------------------------------------------

## 8. Further resources

-   [The chapter on strings](https://r4ds.had.co.nz/strings.html#strings) in Hadley Wickham's R for Data Science (freely abailable online!).

-   [RStudio regex cheatsheet](https://www.rstudio.com/wp-content/uploads/2016/09/RegExCheatsheet.pdf).

-   [A course video by Roger Peng introducing regular expressions](https://www.youtube.com/watch?v=NvHjYOilOf8).

-   [RegExplain](https://www.garrickadenbuie.com/project/regexplain), an RStudio add-in to visualize regex matches and help build regular expressions.

[^1]: Since R 4.0, which was released last year, there is also a "raw string" or "raw character constant" construct, which circumvents some of these problems -- see [this blogpost](https://mpopov.com/blog/2020/05/22/strings-in-r-4.x/) that summarizes this new syntax. Because many are not yet using R 4.x, and most current examples, vignettes, and tutorials on the internet don't use this, we will stick to being stuck with all the backslashes for now.

