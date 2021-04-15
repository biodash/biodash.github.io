---
title: "Session 18: Regular Expressions: Part II"
subtitle: "With help (again) from The Great British Bake Off"
summary: "Building on last week, we'll take regular expressions to a second level."  
authors: [Mike Sovic]
date: "2021-04-12"
output: hugodown::md_document
toc: true
toc_depth: 2
image:
  caption: "Artwork by @allison_horst"
  focal_point: ""
  preview_only: false
rmd_hash: 272a0358ad535afb

---

<br> <br> <br>

------------------------------------------------------------------------

## New to Code Club?

-   If you didn't already do this, please follow the [Code Club Computer Setup](/codeclub-setup/) instructions, which also has pointers for if you're new to R or RStudio.

-   If you're able to do so, please open RStudio a bit before Code Club starts. If you run into issues, please join the Zoom call early and we'll help you troubleshoot.

<br>

------------------------------------------------------------------------

## Getting Set Up

Like last week, we're going to be working with functions from the *stringr* package, which is one of the core *tidyverse* packages, so let's get that loaded first...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>## If needed, install the tidyverse:</span>
<span class='c'># install.packages("tidyverse")</span>

<span class='c'>## Load the tidyverse -- this will include loading "stringr". </span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
</code></pre>

</div>

*stringr* has lots of useful functions for working with strings. Our focus here is on regular expressions, though, which represent just one component of working with strings. So, we'll limit the number of *stringr* functions we work with to try to focus more on the regular expressions themselves. In the previous session, we worked primarily with the `str_view_all()` function. We'll see a lot of that one again this week, and maybe a couple more as needed. Maybe we'll do a *stringr*-focused session down the road to see more of what it offers, but in the meantime, you can check out the *stringr* cheatsheet [here](https://evoldyn.gitlab.io/evomics-2018/ref-sheets/R_strings.pdf), which also includes some useful info on regular expressions, if you're interested.

## Intro

In case you missed last week, or could use a refresher, here's a quick summary...

-   Regular expressions allow you to match specific patterns in text. These can be simple patterns, like matching 'choco' in 'chocolate', or more complicated patterns, like matching only lines that end with any three or four digits.
-   More complicated matches are possible because there are characters, or in some cases, combinations of characters, that have special meaning. These include the metacharacters, anchors, and quantifiers we saw last week, and they help us define more complicated patterns in text.  
-   Sometimes you want to turn the "special meaning" of things like metacharacters, anchors, and quantifiers off to instead interpret the characters literally. The backslash helps us in those cases, and in R, you typically need two of them.

## Session Goals

If regular expressions were new to you last week, it might have felt like a lot to digest. And this week we're just going to add more. But don't worry -- the idea really isn't that you remember all of the special characters (metacharacters) and rules for matching patterns. Personally, I use regular expressions fairly often, and still don't remember all of them all the time -- it's easy enough to grab a cheat sheet and look up what you need to know. The more important thing for now is to just get a sense of the types of things regular expressions allow you to do. With that in mind, this week we'll consider the following additional features/uses of regular expressions...

-   Character classes/Bracket expressions
-   Alternation
-   Grouping
-   Backreferences
-   Greediness/Non-Greediness

As we go through these, we'll use the following string that contains made-up counts of 100 peoples' favorite ice cream flavor to see some examples of how they work...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>our_string</span> <span class='o'>&lt;-</span> <span class='s'>"Chocolate-48,Vanilla-27,Strawberry-25"</span>
</code></pre>

</div>

### Character Classes/Bracket Expressions

Regular expressions allow you to match certain classes of characters -- uppercase, lowercase, digits, alphanumeric, punctuation, etc. We actually saw some examples of character classes last week -- we just didn't call them that. For example, the '\\d' metacharacter that matched any digit, and the '\\w' that matched any word character each represented character classes. Another way of defining character classes/sets is with bracket expressions. These can work in several ways. Basically, any characters defined inside square brackets are matched. So, if you wanted to match any digit, you could use...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>our_string</span>, <span class='s'>"[01234556789]"</span>, match <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/exmp1_2b.png" width="90%" style="display: block; margin: auto auto auto 0;" />

</div>

Ranges can also be defined inside the square brackets with a dash, so this would be equivalent to the expression above...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>our_string</span>, <span class='s'>"[0-9]"</span>, match <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/exmp1_2b.png" width="90%" style="display: block; margin: auto auto auto 0;" />

</div>

And if you want to match the dash, put it at the beginning...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>our_string</span>, <span class='s'>"[-0-9]"</span>, match <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/exmp3.png" width="90%" style="display: block; margin: auto auto auto 0;" />

</div>

Many character classes have a descriptive term that can also be used if it's bracketed by a colon on each side inside the brackets...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>our_string</span>, <span class='s'>"[:digit:]"</span>, match <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/exmp1_2.png" width="90%" style="display: block; margin: auto auto auto 0;" />

</div>

Finally, the '^' can be used inside the brackets to negate the match. Notice the difference in how this character is interpreted here as compared to when we previously used it as an anchor (outside of the square brackets) -- CONTEXT MATTERS!...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>our_string</span>, <span class='s'>"[^0-9]"</span>, match <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/exmp4.png" width="90%" style="display: block; margin: auto auto auto 0;" />

</div>

### Alternation

Alternation allows you to search for any of two or more patterns. This is achieved with the pipe symbol/vertical bar [`|`](https://rdrr.io/r/base/Logic.html), which is usually just above the Return key. Within regular expressions, it can be read as "or". So, the expression "Chocolate\|Vanilla" finds matches to either of these flavors...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>our_string</span>, <span class='s'>"Chocolate|Vanilla"</span>, match <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/exmp5.png" width="90%" style="display: block; margin: auto auto auto 0;" />

</div>

And you can chain more than two of these together, as in "Chocolate\|Vanilla\|Strawberry"...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>our_string</span>, <span class='s'>"Chocolate|Vanilla|Strawberry"</span>, match <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/exmp6.png" width="90%" style="display: block; margin: auto auto auto 0;" />

</div>

### Grouping

Grouping serves a couple main purposes in regular expressions. We'll consider one here, and then a second in the context of backreferences in the next section. The quantifiers Jelmer introduced last week define the number of times the preceding character must occur. But what if you want to match a set of characters a specific number of times? They can be grouped by wrapping them in parentheses, so the quantifier applies to the entire set. We'll use a new example string for this one - one from the DNA world. Sometimes strings of DNA contain short sequences of repeats, like the 'ATC' repeat in the middle of this string... GTACGGG**ATCATCATCATCATC**GGATCCCAGT

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>dna_string</span> <span class='o'>&lt;-</span> <span class='s'>"GTACGGGATCATCATCATCATCGGATCCCAGT"</span>
</code></pre>

</div>

What if we wanted to find places where "ATC" was repeated at least 3 times in sequence?

This doesn't give us what we want, since the quantifier is only being applied to the 'C'...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>dna_string</span>, <span class='s'>"ATC&#123;3,&#125;"</span>, match <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/exmp7.png" width="90%" style="display: block; margin: auto auto auto 0;" />

</div>

Instead, we can group the 'ATC' with a set of parentheses to get the result we want...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>dna_string</span>, <span class='s'>"(ATC)&#123;3,&#125;"</span>, match <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/exmp8.png" width="90%" style="display: block; margin: auto auto auto 0;" />

</div>

### Backreferences

Another place grouping comes in handy is with backreferences. But before we get to those, let's get comfortable with a new function from *stringr*. So far, we've focused on using regular expressions just to search for patterns. But sometimes we want to not only find a pattern, but then replace it with something else. The `str_replace()` function can be thought of as an extension of `str_view()` that takes a third argument - the string that will be used to replace any match identified. So, say we had a mistake in the data, and "Strawberry" was actually supposed to be "Caramel"...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>our_string</span>

<span class='c'>#&gt; [1] "Chocolate-48,Vanilla-27,Strawberry-25"</span>


<span class='nf'>str_replace</span><span class='o'>(</span><span class='nv'>our_string</span>, <span class='s'>"Strawberry"</span>, <span class='s'>"Caramel"</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "Chocolate-48,Vanilla-27,Caramel-25"</span>
</code></pre>

</div>

Backreferences allow us to use the matches to (grouped) regex patterns as replacements. The characters matching each grouped regex pattern are temporarily assigned to variables (sequential numbers - i.e. the first matched group is assigned as 1, the second as 2, and so on), and can then be recalled with those numbers. Let's go back to our ice cream string and use backreferences to reverse the order of the flavors in the string...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#view the current string</span>
<span class='nv'>our_string</span>

<span class='c'>#&gt; [1] "Chocolate-48,Vanilla-27,Strawberry-25"</span>


<span class='nf'>str_replace</span><span class='o'>(</span><span class='nv'>our_string</span>, 
            <span class='s'>"(Chocolate-48),(Vanilla-27),(Strawberry-25)"</span>, 
            <span class='s'>"\\3,\\2,\\1"</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "Strawberry-25,Vanilla-27,Chocolate-48"</span>
</code></pre>

</div>

The first grouped match (Chocolate-48) got assigned to the variable '1', the second (Vanilla-27) to '2', and the third (Strawberry-25) to '3'. For the replacement, we just called these variables in reverse order. The notation to call these variables (backreferences) is often the combination of a single backslash and the number, but as Jelmer pointed out last week, in R, we need two backslashes.

We could also use metacharacters to do it like this (or many other ways for that matter)...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_replace</span><span class='o'>(</span><span class='nv'>our_string</span>, <span class='s'>"(C.*),(V.*),(S.*)"</span>, <span class='s'>"\\3,\\1,\\2"</span><span class='o'>)</span>

<span class='c'>#&gt; [1] "Strawberry-25,Chocolate-48,Vanilla-27"</span>
</code></pre>

</div>

### Greediness

By default, regular expression matches will be greedy, as in this example...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>our_string</span>, <span class='s'>"C.+\\d\\d"</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/exmp9.png" width="90%" style="display: block; margin: auto auto auto 0;" />

</div>

Notice there are three possible valid matches to the search pattern here -- "Chocolate-48", "Chocolate-48,Vanilla-27", and the full string which is actually what gets matched. This is called greedy behavior - the longest valid match will be identified by default. You can add the '?' after a quantifier to make the match non-greedy...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>our_string</span>, <span class='s'>"C.+?\\d\\d"</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/exmp10.png" width="90%" style="display: block; margin: auto auto auto 0;" />

</div>

So, in summary for today,

-   Bracket expressions (square brackets) allow you to match anything inside them. Ranges can be defined with a dash. Notation is also available to define and match character classes -- things like digits, lowercase letters, punctuation, etc.
-   The [`|`](https://rdrr.io/r/base/Logic.html) means "or" -- use it to match one of two or more patterns.
-   Parentheses can be used to group a set of characters/metacharacters into a single regex pattern.
-   When grouped patterns match, they are assigned to a temporary numeric variable that can be used to recall the match, usually to use it in a replacement.
-   If there is more than one valid match to a regex search pattern, the longest one will be returned by default. This "greedy" behavior can be reversed by adding a '?' after the relevant quantifier.

Like last week, we'll use data from the Great British Bakeoff to practice with some of these things. If you didn't install that dataset last week, you can get it with the following code...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>## If needed, first install the "remotes" package:</span>
<span class='c'># install.packages("remotes")</span>

<span class='nf'>remotes</span><span class='nf'>::</span><span class='nf'><a href='https://remotes.r-lib.org/reference/install_github.html'>install_github</a></span><span class='o'>(</span><span class='s'>"apreshill/bakeoff"</span><span class='o'>)</span>
</code></pre>

</div>

Then (everybody), load it...

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://bakeoff.netlify.com'>bakeoff</a></span><span class='o'>)</span>
</code></pre>

</div>

<br>

------------------------------------------------------------------------

## Breakout rooms

<div class="puzzle">

<div>

### Exercise 1

For the first few exercises, we're going to work with the signature bakes found in the "signature" column of the "bakes" data frame. Assign the data from this column to an object names "sigs". Preview it by viewing its first 3 items and getting its length.

<details>
<summary>
Hints
</summary>

Use the '\$' notation to pull out the single column from the data frame, or alternatively a combination of *dplyr*'s `select()` followed by [`unlist()`](https://rdrr.io/r/base/unlist.html). Use square brackets to index the vector, and the [`length()`](https://rdrr.io/r/base/length.html) function to get its length.

</details>
<details>
<summary>
Solution
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>sigs</span> <span class='o'>&lt;-</span> <span class='nv'>bakes</span><span class='o'>$</span><span class='nv'>signature</span>

<span class='nv'>sigs</span><span class='o'>[</span><span class='m'>1</span><span class='o'>:</span><span class='m'>3</span><span class='o'>]</span>

<span class='c'>#&gt; [1] "Light Jamaican Black Cakewith Strawberries and Cream"</span>
<span class='c'>#&gt; [2] "Chocolate Orange Cake"                               </span>
<span class='c'>#&gt; [3] "Caramel Cinnamon and Banana Cake"</span>


<span class='nf'><a href='https://rdrr.io/r/base/length.html'>length</a></span><span class='o'>(</span><span class='nv'>sigs</span><span class='o'>)</span>

<span class='c'>#&gt; [1] 548</span>
</code></pre>

</div>

</details>

</div>

</div>

<div class="puzzle">

<div>

### Exercise 2

Find all signature bakes that contain either raspberries or blueberries. Make sure to try to cover all the ways those ingredients might be reflected in the names.

<details>
<summary>
Hints
</summary>

-   Use the pipe symbol for alternation (OR)

-   Include possible variants such as raspberry, raspberries, Raspberry, etc.

</details>
<details>
<summary>
Solution
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>sigs</span>, <span class='s'>"[Rr]aspberr.+|[Bb]lueberr.+"</span>, match <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/ex2.png" width="700px" style="display: block; margin: auto auto auto 0;" />

</div>

</details>

</div>

</div>

<div class="puzzle">

<div>

### Exercise 3

Even if you're not a millionaire, you'd like to try to eat like one. First, find all signature bakes that have "Millionaire" in the name. Then do a second search and limit the results to just those that start with "Millionaire".

<details>
<summary>
Hints
</summary>

-   Use the appropriate anchor to limit results to those with "Millionaire" at the beginning of the name.

</details>
<details>
<summary>
Solution
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>sigs</span>, <span class='s'>"Millionaire"</span>, match<span class='o'>=</span><span class='kc'>TRUE</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/ex3a.png" width="90%" style="display: block; margin: auto auto auto 0;" />

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>str_view_all</span><span class='o'>(</span><span class='nv'>sigs</span>, <span class='s'>"^Millionaire"</span>, match<span class='o'>=</span><span class='kc'>TRUE</span><span class='o'>)</span>
</code></pre>

</div>

<div class="highlight">

<img src="img/ex3b.png" width="90%" style="display: block; margin: auto auto auto 0;" />

</div>

</details>

</div>

</div>

<div class="puzzle">

<div>

### Exercise 4

You tried each of the three signature bakes that start with "Millionaire", and weren't that impressed. Save these three bakes' names in the object 'not_good' and then change the names of each of the three by replacing "Millionaire" with "Poor Man". Assign the three new names to the object 'renamed'. Note you'll need a new *stringr* function for this exercise.

<details>
<summary>
Hints
</summary>

Use the `str_subset()` function to pull out the matching strings. Then use the `str_replace()` function we used in the examples for the replacement.

</details>
<details>
<summary>
Solution
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>not_good</span> <span class='o'>&lt;-</span> <span class='nf'>str_subset</span><span class='o'>(</span><span class='nv'>sigs</span>, <span class='s'>"^Millionaire"</span><span class='o'>)</span>
<span class='nv'>not_good</span>

<span class='c'>#&gt; [1] "Millionaires' Shortbread"   "Millionaire Banoffee Bonus"</span>
<span class='c'>#&gt; [3] "Millionaire's Roulade"</span>


<span class='nv'>renamed</span> <span class='o'>&lt;-</span> <span class='nf'>str_replace_all</span><span class='o'>(</span><span class='nv'>not_good</span>, <span class='s'>"Millionaire"</span>,
                           <span class='s'>"Poor Man"</span><span class='o'>)</span>

<span class='nv'>renamed</span>

<span class='c'>#&gt; [1] "Poor Mans' Shortbread"   "Poor Man Banoffee Bonus"</span>
<span class='c'>#&gt; [3] "Poor Man's Roulade"</span>
</code></pre>

</div>

</details>

</div>

</div>

<div class="puzzle">

<div>

### Bonus 1

For the bonus, let's work with a different part of the dataset. The 'bakers' data frame includes a column named 'baker_full' that has the full name of each baker. First, extract that column and save it as the object 'baker_names'. Then preview the first 5 names in this vector.

<details>
<summary>
Hints
</summary>

Use the '\$' and \[ \] notations.

</details>
<details>
<summary>
Solution
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>baker_names</span> <span class='o'>&lt;-</span> <span class='nv'>bakers</span><span class='o'>$</span><span class='nv'>baker_full</span>

<span class='nv'>baker_names</span><span class='o'>[</span><span class='m'>1</span><span class='o'>:</span><span class='m'>5</span><span class='o'>]</span>

<span class='c'>#&gt; [1] "Annetha Mills"         "David Chambers"        "Edward \"Edd\" Kimber"</span>
<span class='c'>#&gt; [4] "Jasminder Randhawa"    "Jonathan Shepherd"</span>
</code></pre>

</div>

</details>

</div>

</div>

<div class="puzzle">
<div>


### Bonus 2

Notice from the first 5 entries of 'baker_names' that the names are ordered as first name then last name, with potentially a middle name, or nickname, in between. Try reordering the names so they read last name, comma, first (and middle, if applicable). Assign the new names to 'baker_names_rev'.

<details>
<summary>
Hints
</summary>

Use grouping and backreferences.

</details>
<details>
<summary>
Solution
</summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>baker_names_rev</span> <span class='o'>&lt;-</span> <span class='nf'>str_replace</span><span class='o'>(</span><span class='nv'>baker_names</span>, 
                               <span class='s'>"(.+)(\\s[:alpha:]+)"</span>,
                               <span class='s'>"\\2, \\1"</span><span class='o'>)</span>

<span class='nv'>baker_names_rev</span><span class='o'>[</span><span class='m'>1</span><span class='o'>:</span><span class='m'>5</span><span class='o'>]</span>

<span class='c'>#&gt; [1] " Mills, Annetha"         " Chambers, David"       </span>
<span class='c'>#&gt; [3] " Kimber, Edward \"Edd\"" " Randhawa, Jasminder"   </span>
<span class='c'>#&gt; [5] " Shepherd, Jonathan"</span>
</code></pre>

</div>

</div>
</div>

<br>

------------------------------------------------------------------------

