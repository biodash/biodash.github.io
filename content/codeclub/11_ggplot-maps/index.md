---
title: "Session 11: Spatial data visualization with ggplot2"
summary: "Today, we will be making cool maps in R!"  
authors: [stephen-opiyo]
date: "2021-02-24"
output: hugodown::md_document
toc: true
image: 
  caption: "Image from https://r4ds.had.co.nz"
  focal_point: ""
  preview_only: false
editor_options: 
  markdown: 
    wrap: 72
rmd_hash: e0e92d8dd048373f

---

<br> <br>

Today, we will cover the visualization of spatial data in R using the layered grammar of graphics implementation of ggplot2 in conjunction with the contextual information of static maps from world maps in the *maps* package.

**Before we look at mapping using ggplot2, let us define some terms.**

*Areal data* <br/> Areal data is data which corresponds to geographical extents with polygonal boundaries.

*The layered grammar of graphics* <br/> By definition, the layered grammar demands that every plot consist of five components: <br/>

-   a default dataset with aesthetic mappings,<br/>

-   one or more layers, each with either a geometric object ("geom"), a statistical transformation ("stat"), etc.<br/>

-   a scale for each aesthetic mapping (which can be automatically generated),<br/>

-   a coordinate system, and <br/>

-   a facet specification. <br/>

Since *ggplot2* is an implementation of the layered grammar of graphics, every plot made with ggplot2 has each of the above elements. Consequently, map plots also have these elements, but certain elements are ﬁxed to map components: the `x` aesthetic is ﬁxed to longitude, the `y` aesthetic is ﬁxed to latitude.

**Drawing a map** <br/> Drawing a map in R requires two things. **First**, we have to draw the map using data that directs R to draw the polygon shapes that constitute the map. Then we **add** information to our map to plot color and marks. It's the same basic logic that we have used in ggplot figures. The key thing is to have datasets that link that geographic data with the information that we want to put on the plot.

*The maps package in R* <br/> The "maps" package in R contains a set of maps of the United States and the world drawn using longitude and latitude data. With world map, the USA map with the individual states you can accomplish a lot of the mapping tasks using the maps package. The maps package contains a lot of outlines of continents, countries, states, and counties

**Making data frames from map outlines by ggplot2** <br/> Recall that ggplot2 operates on data frames. Therefore, we need some way to translate the maps data into a data frame format the ggplot can use. The package *ggplot2* provides the `map_data()` function. The function turns a series of points along an outline into a data frame of those points. The package ggplot2 uses the following syntax: `map_data("name")` where "name" is a quoted string of the name of a map in the *maps* package.<br/>

Let us start by drawing maps of the World, USA, states, Ohio, Ohio and Indiana, and part of Europe using the *maps* package.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'>maps</span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://scales.r-lib.org'>scales</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://stringr.tidyverse.org'>stringr</a></span><span class='o'>)</span>

<span class='c'># Let us get a world map using the "map_data" function </span>
<span class='nv'>world</span> <span class='o'>&lt;-</span> <span class='nf'>map_data</span><span class='o'>(</span><span class='s'>"world"</span><span class='o'>)</span>

<span class='c'>## Let us get a US map including Hawaii, Alaska, and Puerto Rico:</span>
<span class='nv'>usa</span> <span class='o'>&lt;-</span> <span class='nf'>map_data</span><span class='o'>(</span><span class='s'>"usa"</span><span class='o'>)</span>

<span class='c'># Let us get the states:</span>
<span class='nv'>states</span> <span class='o'>&lt;-</span> <span class='nf'>map_data</span><span class='o'>(</span><span class='s'>"state"</span><span class='o'>)</span>

<span class='c'># Select Ohio using the filter function:</span>
<span class='nv'>ohio</span> <span class='o'>&lt;-</span> <span class='nv'>states</span> <span class='o'>%&gt;%</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>region</span> <span class='o'>==</span> <span class='s'>"ohio"</span><span class='o'>)</span>
</code></pre>

</div>

-   Let us plot a world map:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>world</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
 <span class='nf'>geom_polygon</span><span class='o'>(</span>fill <span class='o'>=</span> <span class='s'>"white"</span>, color <span class='o'>=</span> <span class='s'>"black"</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-2-1.png" width="700px" style="display: block; margin: auto;" />

</div>

-   Let us plot a map of the US:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>usa</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y<span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
 <span class='nf'>geom_polygon</span><span class='o'>(</span>fill <span class='o'>=</span> <span class='s'>"white"</span>, color <span class='o'>=</span> <span class='s'>"black"</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-3-1.png" width="700px" style="display: block; margin: auto;" />

</div>

-   Let us plot a map of the US with states:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>states</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
 <span class='nf'>geom_polygon</span><span class='o'>(</span>fill <span class='o'>=</span> <span class='s'>"blue"</span>, color <span class='o'>=</span> <span class='s'>"black"</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-4-1.png" width="700px" style="display: block; margin: auto;" />

</div>

-   Let us plot a map of Ohio:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>ohio</span>,
       mapping<span class='o'>=</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>geom_polygon</span><span class='o'>(</span>fill <span class='o'>=</span> <span class='s'>"white"</span>, color <span class='o'>=</span> <span class='s'>"green"</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-5-1.png" width="700px" style="display: block; margin: auto;" />

</div>

-   We can also plot a map for an arbitrary selection of states:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># We can select data for two states, for example Ohio and Indiana:</span>
<span class='nv'>ohio_indiana</span> <span class='o'>&lt;-</span> <span class='nv'>states</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>region</span> <span class='o'>==</span> <span class='s'>"ohio"</span> <span class='o'>|</span> <span class='nv'>region</span> <span class='o'>==</span> <span class='s'>"indiana"</span><span class='o'>)</span>

<span class='c'># Plot the map of Ohio and Indiana:</span>
<span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>ohio_indiana</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>geom_polygon</span><span class='o'>(</span>fill <span class='o'>=</span> <span class='s'>"green"</span> , color <span class='o'>=</span> <span class='s'>"red"</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-6-1.png" width="700px" style="display: block; margin: auto;" />

</div>

-   We can also plot only a specific region by filtering by latitude and longitude:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>world</span> <span class='o'>&lt;-</span> <span class='nf'>map_data</span><span class='o'>(</span><span class='s'>"world"</span><span class='o'>)</span>
<span class='nv'>a_region</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>world</span>, <span class='nv'>long</span> <span class='o'>&gt;</span><span class='o'>-</span> <span class='m'>10</span> <span class='o'>&amp;</span> <span class='nv'>long</span> <span class='o'>&lt;</span> <span class='m'>15.1</span> <span class='o'>&amp;</span> <span class='nv'>lat</span> <span class='o'>&gt;</span> <span class='m'>32</span> <span class='o'>&amp;</span> <span class='nv'>lat</span> <span class='o'>&lt;</span> <span class='m'>55</span><span class='o'>)</span>

<span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>a_region</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_polygon</span><span class='o'>(</span>fill <span class='o'>=</span> <span class='s'>"white"</span>, color <span class='o'>=</span> <span class='s'>"black"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>coord_fixed</span><span class='o'>(</span><span class='m'>1.3</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-7-1.png" width="700px" style="display: block; margin: auto;" />

</div>

### The structure of the data frame `ohio`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>ohio</span><span class='o'>)</span>

<span class='c'>#&gt;        long      lat group order region subregion</span>
<span class='c'>#&gt; 1 -80.51776 40.64563    42 10440   ohio      &lt;NA&gt;</span>
<span class='c'>#&gt; 2 -80.55787 40.63990    42 10441   ohio      &lt;NA&gt;</span>
<span class='c'>#&gt; 3 -80.62089 40.63417    42 10442   ohio      &lt;NA&gt;</span>
<span class='c'>#&gt; 4 -80.66100 40.61698    42 10443   ohio      &lt;NA&gt;</span>
<span class='c'>#&gt; 5 -80.66673 40.60552    42 10444   ohio      &lt;NA&gt;</span>
<span class='c'>#&gt; 6 -80.67245 40.58833    42 10445   ohio      &lt;NA&gt;</span>
</code></pre>

</div>

Look at the variables in *ohio*, note what they refer to: <br/>

-   `long` = longitude. Lines of longitude, or meridians, run between the North and South Poles and measure east-west positions. While prime meridian is assigned the value of 0 degrees, and runs through Greenwich (England), meridians to the west of the prime meridian are measured in degrees west (up to 180 degrees) and those to the east of the prime meridian are measured to in degrees east (up to 180 degrees).<br/>

-   `lat` = latitude. Lines of latitude measure north-south position between the poles with the equator defined as 0 degrees, the North Pole defined as 90 degrees north, and the South Pole defined as 90 degrees south. <br/>

-   `group` = an identifier that is unique for each subregion (here the counties). Group is very important! ggplot2's functions can take a group argument which controls (amongst other things) whether adjacent points should be connected by lines. If they are in the same group, then they get connected, but if they are in different groups then they don't. <br/>

-   `order` = an identifier that indicates the order in which the boundary lines should be drawn <br/>

-   `region` = string indicator for regions (here the states) <br/>

-   `subregion` = string indicator for sub-regions (here the county names) <br/>

Part II: Add information to the maps
------------------------------------

**The second part of mapping in R, is to add information on the map created in the first part.** <br/> In drawing the map, the "*maps*" package creates the backbone for visualizations. Then we add additional information to show colors and shapes. <br/>

*We will:* <br/> - fill a map by region, <br/> - draw a Bubble map using city population, <br/> - make a point for every city, <br/> - vary size of point by city size and vary the color of the dots, and <br/> - add external data to the map. <br/>

-   Let us fill by region and make sure the the lines of state borders are white:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>states</span><span class='o'>)</span> <span class='o'>+</span> 
 <span class='nf'>geom_polygon</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, fill <span class='o'>=</span> <span class='nv'>region</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span>,
              color <span class='o'>=</span> <span class='s'>"white"</span><span class='o'>)</span> <span class='o'>+</span> 
 <span class='nf'>coord_fixed</span><span class='o'>(</span><span class='m'>1.3</span><span class='o'>)</span> <span class='o'>+</span>
 <span class='nf'>guides</span><span class='o'>(</span>fill <span class='o'>=</span> <span class='kc'>FALSE</span><span class='o'>)</span> <span class='c'># Do this to omit the legend</span>

</code></pre>
<img src="figs/unnamed-chunk-9-1.png" width="700px" style="display: block; margin: auto;" />

</div>

-   Let us draw a "Bubble map":

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># The maps package has city data</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nf'>maps</span><span class='nf'>::</span><span class='nv'><a href='https://rdrr.io/pkg/maps/man/world.cities.html'>world.cities</a></span><span class='o'>)</span>

<span class='c'>#&gt;                 name country.etc   pop   lat  long capital</span>
<span class='c'>#&gt; 1 'Abasan al-Jadidah   Palestine  5629 31.31 34.34       0</span>
<span class='c'>#&gt; 2 'Abasan al-Kabirah   Palestine 18999 31.32 34.35       0</span>
<span class='c'>#&gt; 3       'Abdul Hakim    Pakistan 47788 30.55 72.11       0</span>
<span class='c'>#&gt; 4 'Abdullah-as-Salam      Kuwait 21817 29.36 47.98       0</span>
<span class='c'>#&gt; 5              'Abud   Palestine  2456 32.03 35.07       0</span>
<span class='c'>#&gt; 6            'Abwein   Palestine  3434 32.03 35.20       0</span>


<span class='nv'>my_cities</span> <span class='o'>&lt;-</span> <span class='nf'>maps</span><span class='nf'>::</span><span class='nv'><a href='https://rdrr.io/pkg/maps/man/world.cities.html'>world.cities</a></span>

<span class='nv'>usa_cities</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>my_cities</span>,<span class='nv'>country.etc</span> <span class='o'>==</span> <span class='s'>"USA"</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>usa_cities</span><span class='o'>)</span>

<span class='c'>#&gt;      name country.etc    pop   lat    long capital</span>
<span class='c'>#&gt; 1 Abilene         USA 113888 32.45  -99.74       0</span>
<span class='c'>#&gt; 2   Akron         USA 206634 41.08  -81.52       0</span>
<span class='c'>#&gt; 3 Alameda         USA  70069 37.77 -122.26       0</span>
<span class='c'>#&gt; 4  Albany         USA  45535 44.62 -123.09       0</span>
<span class='c'>#&gt; 5  Albany         USA  75510 31.58  -84.18       0</span>
<span class='c'>#&gt; 6  Albany         USA  93576 42.67  -73.80       0</span>
</code></pre>

</div>

-   Make a point for every city:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>usa</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
 <span class='nf'>geom_polygon</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"black"</span>, fill <span class='o'>=</span> <span class='s'>"white"</span><span class='o'>)</span> <span class='o'>+</span>
 <span class='nf'>geom_point</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>usa_cities</span>, color <span class='o'>=</span> <span class='s'>"red"</span>,
            <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='kc'>NULL</span><span class='o'>)</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-11-1.png" width="700px" style="display: block; margin: auto;" />

</div>

-   Let's pick just the big cities:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>usa_big_cities</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>my_cities</span>, <span class='nv'>country.etc</span> <span class='o'>==</span> <span class='s'>"USA"</span> <span class='o'>&amp;</span> <span class='nv'>pop</span> <span class='o'>&gt;</span> <span class='m'>500000</span><span class='o'>)</span>

<span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>usa</span>, mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_polygon</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"black"</span>, fill <span class='o'>=</span> <span class='s'>"white"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>usa_big_cities</span>, color <span class='o'>=</span> <span class='s'>"red"</span>,
             <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='kc'>NULL</span><span class='o'>)</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-12-1.png" width="700px" style="display: block; margin: auto;" />

</div>

-   Vary size of point by city size:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>usa</span>, mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_polygon</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"black"</span>, fill <span class='o'>=</span> <span class='s'>"white"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>usa_big_cities</span>, color <span class='o'>=</span> <span class='s'>"red"</span>,
             <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='kc'>NULL</span>, size <span class='o'>=</span> <span class='nv'>pop</span><span class='o'>)</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-13-1.png" width="700px" style="display: block; margin: auto;" />

</div>

-   Now vary the color of the dots:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>usa_big_cities</span><span class='o'>$</span><span class='nv'>qual</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/sample.html'>sample</a></span><span class='o'>(</span><span class='nv'>LETTERS</span><span class='o'>[</span><span class='m'>1</span><span class='o'>:</span><span class='m'>5</span><span class='o'>]</span>, <span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='nv'>usa_big_cities</span><span class='o'>)</span>,
                              replace <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>

<span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>usa</span>, mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_polygon</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"black"</span>, fill <span class='o'>=</span> <span class='s'>"white"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>usa_big_cities</span>,
             <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='kc'>NULL</span>, color <span class='o'>=</span> <span class='nv'>qual</span>, size <span class='o'>=</span> <span class='nv'>pop</span><span class='o'>)</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-14-1.png" width="700px" style="display: block; margin: auto;" />

</div>

-   Tweak the map:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># No scientific notation in legend r ggplot:</span>
<span class='c'># scales package adds the "scale_size_continuous" function, and we can set label=comma</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://scales.r-lib.org'>scales</a></span><span class='o'>)</span>

<span class='c'># Change the column name to make the legend nicer"</span>
<span class='nv'>usa_big_cities</span><span class='o'>$</span><span class='nv'>Population</span> <span class='o'>&lt;-</span> <span class='nv'>usa_big_cities</span><span class='o'>$</span><span class='nv'>pop</span>
<span class='nv'>usa_big_cities</span><span class='o'>$</span><span class='nv'>Qualitative</span> <span class='o'>&lt;-</span> <span class='nv'>usa_big_cities</span><span class='o'>$</span><span class='nv'>qual</span>

<span class='c'># Do some additional refining:</span>
<span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>usa</span>, mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y<span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>geom_polygon</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"black"</span>, fill <span class='o'>=</span> <span class='s'>"white"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>usa_big_cities</span>,
             <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='kc'>NULL</span>,
                 color <span class='o'>=</span> <span class='nv'>Qualitative</span>, size <span class='o'>=</span> <span class='nv'>Population</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>scale_size_continuous</span><span class='o'>(</span>label <span class='o'>=</span> <span class='nv'>comma</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-15-1.png" width="700px" style="display: block; margin: auto;" />

</div>

-   Work with Ohio counties with external data:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># Get basic map data for all USA counties:</span>
<span class='nv'>usa_counties</span> <span class='o'>=</span> <span class='nf'>map_data</span><span class='o'>(</span><span class='s'>"county"</span><span class='o'>)</span> 

<span class='c'># Subset to counties in Ohio:</span>
<span class='nv'>oh</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/subset.html'>subset</a></span><span class='o'>(</span><span class='nv'>usa_counties</span>, <span class='nv'>region</span> <span class='o'>==</span> <span class='s'>"ohio"</span><span class='o'>)</span> 
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>oh</span><span class='o'>)</span>

<span class='c'>#&gt;            long      lat group order region subregion</span>
<span class='c'>#&gt; 59960 -83.66902 39.02989  2012 59960   ohio     adams</span>
<span class='c'>#&gt; 59961 -83.56590 39.02989  2012 59961   ohio     adams</span>
<span class='c'>#&gt; 59962 -83.37109 39.06426  2012 59962   ohio     adams</span>
<span class='c'>#&gt; 59963 -83.30806 39.06426  2012 59963   ohio     adams</span>
<span class='c'>#&gt; 59964 -83.30233 39.05280  2012 59964   ohio     adams</span>
<span class='c'>#&gt; 59965 -83.25649 39.01842  2012 59965   ohio     adams</span>
</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># Plot ohio counties</span>
<span class='nf'>ggplot</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_polygon</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>oh</span>,
               <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span>, fill <span class='o'>=</span> <span class='nv'>subregion</span><span class='o'>)</span>,
               color <span class='o'>=</span> <span class='s'>"black"</span>, alpha <span class='o'>=</span> <span class='m'>0.3</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>coord_fixed</span><span class='o'>(</span><span class='m'>1.3</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>guides</span><span class='o'>(</span>fill <span class='o'>=</span> <span class='kc'>FALSE</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>ggtitle</span><span class='o'>(</span><span class='s'>"Ohio counties"</span><span class='o'>)</span>  

</code></pre>
<img src="figs/unnamed-chunk-17-1.png" width="700px" style="display: block; margin: auto;" />

</div>

-   Read population data for Ohio counties:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># The data of the estimated population of each  county in 2021 and percent change from 2010</span>
<span class='nv'>Ohio</span> <span class='o'>&lt;-</span> <span class='nf'>read_csv</span><span class='o'>(</span><span class='s'>"Ohio.csv"</span><span class='o'>)</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>Ohio</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 x 3</span></span>
<span class='c'>#&gt;   county     Pop  Perc</span>
<span class='c'>#&gt;   <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>    </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>1</span><span> Vinton   </span><span style='text-decoration: underline;'>12</span><span>965 -</span><span style='color: #BB0000;'>3.28</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>2</span><span> Monroe   </span><span style='text-decoration: underline;'>13</span><span>388 -</span><span style='color: #BB0000;'>8.36</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>3</span><span> Morgan   </span><span style='text-decoration: underline;'>14</span><span>362 -</span><span style='color: #BB0000;'>4.47</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>4</span><span> Noble    </span><span style='text-decoration: underline;'>14</span><span>578 -</span><span style='color: #BB0000;'>0.56</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>5</span><span> Harrison </span><span style='text-decoration: underline;'>14</span><span>786 -</span><span style='color: #BB0000;'>6.57</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>6</span><span> Paulding </span><span style='text-decoration: underline;'>18</span><span>532 -</span><span style='color: #BB0000;'>5.24</span></span>
</code></pre>

</div>

-   Prepare the data for plotting:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># Create a new  column called  "county" so that counties start with capital letters</span>
<span class='c'># using str_to_title function </span>
<span class='nv'>oh</span><span class='o'>$</span><span class='nv'>county</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://stringr.tidyverse.org/reference/case.html'>str_to_title</a></span><span class='o'>(</span><span class='nv'>oh</span><span class='o'>$</span><span class='nv'>subregion</span><span class='o'>)</span>

<span class='c'># Merge population data with counties data by county variable using inner_join</span>
<span class='c'># function, and named the new object "ohio_pop"</span>
<span class='nv'>ohio_pop</span> <span class='o'>&lt;-</span> <span class='nf'>inner_join</span><span class='o'>(</span><span class='nv'>oh</span>, <span class='nv'>Ohio</span>, by <span class='o'>=</span> <span class='s'>"county"</span><span class='o'>)</span>

<span class='c'># Select counties with population greater than 100000</span>
<span class='nv'>ohio_big_pop</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>ohio_pop</span>, <span class='nv'>Pop</span> <span class='o'>&gt;</span> <span class='m'>100000</span><span class='o'>)</span>
</code></pre>

</div>

-   Create the plot where we vary point size by population size:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>ohio_pop</span>, mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_polygon</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"black"</span>, fill <span class='o'>=</span> <span class='s'>"white"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>ohio_big_pop</span>, color <span class='o'>=</span> <span class='s'>"red"</span>,
             <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='kc'>NULL</span>, size <span class='o'>=</span> <span class='nv'>Pop</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>guides</span><span class='o'>(</span>size <span class='o'>=</span> <span class='kc'>FALSE</span><span class='o'>)</span>  <span class='c'>#  Do this to omit the legend</span>

</code></pre>
<img src="figs/unnamed-chunk-20-1.png" width="700px" style="display: block; margin: auto;" />

</div>

-   The points are plotted on the boundaries of the counties Improve the graph by creating groups of population using quantile.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>ApplyQuintiles</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span> <span class='o'>&#123;</span>
  <span class='nf'><a href='https://rdrr.io/r/base/cut.html'>cut</a></span><span class='o'>(</span><span class='nv'>x</span>, breaks <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/stats/quantile.html'>quantile</a></span><span class='o'>(</span><span class='nv'>ohio_pop</span><span class='o'>$</span><span class='nv'>Pop</span>, probs <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/seq.html'>seq</a></span><span class='o'>(</span><span class='m'>0</span>, <span class='m'>1</span>, by <span class='o'>=</span> <span class='m'>0.2</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span>,
      labels <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"0-20"</span>, <span class='s'>"20-40"</span>, <span class='s'>"40-60"</span>, <span class='s'>"60-80"</span>, <span class='s'>"80-100"</span><span class='o'>)</span>,
      include.lowest <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
<span class='o'>&#125;</span>

<span class='nv'>ohio_pop</span><span class='o'>$</span><span class='nv'>grouped_pop</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/lapply.html'>sapply</a></span><span class='o'>(</span><span class='nv'>ohio_pop</span><span class='o'>$</span><span class='nv'>Pop</span>, <span class='nv'>ApplyQuintiles</span><span class='o'>)</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>ohio_pop</span><span class='o'>)</span>

<span class='c'>#&gt;        long      lat group order region subregion county   Pop  Perc</span>
<span class='c'>#&gt; 1 -83.66902 39.02989  2012 59960   ohio     adams  Adams 27706 -2.91</span>
<span class='c'>#&gt; 2 -83.56590 39.02989  2012 59961   ohio     adams  Adams 27706 -2.91</span>
<span class='c'>#&gt; 3 -83.37109 39.06426  2012 59962   ohio     adams  Adams 27706 -2.91</span>
<span class='c'>#&gt; 4 -83.30806 39.06426  2012 59963   ohio     adams  Adams 27706 -2.91</span>
<span class='c'>#&gt; 5 -83.30233 39.05280  2012 59964   ohio     adams  Adams 27706 -2.91</span>
<span class='c'>#&gt; 6 -83.25649 39.01842  2012 59965   ohio     adams  Adams 27706 -2.91</span>
<span class='c'>#&gt;   grouped_pop</span>
<span class='c'>#&gt; 1        0-20</span>
<span class='c'>#&gt; 2        0-20</span>
<span class='c'>#&gt; 3        0-20</span>
<span class='c'>#&gt; 4        0-20</span>
<span class='c'>#&gt; 5        0-20</span>
<span class='c'>#&gt; 6        0-20</span>
</code></pre>

</div>

-   Plot the map:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_polygon</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>ohio_pop</span>,
               <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span>, fill <span class='o'>=</span> <span class='nv'>grouped_pop</span><span class='o'>)</span>,
               color <span class='o'>=</span> <span class='s'>"black"</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>coord_fixed</span><span class='o'>(</span><span class='m'>1.3</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>scale_fill_brewer</span><span class='o'>(</span>palette <span class='o'>=</span> <span class='s'>"Set1"</span>, direction <span class='o'>=</span> <span class='o'>-</span><span class='m'>1</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>fill <span class='o'>=</span> <span class='s'>"Population Quantiles"</span><span class='o'>)</span> 

</code></pre>
<img src="figs/unnamed-chunk-22-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Breakout rooms
--------------

<div class="puzzle">

### Exercise 1

Use the dataset of 2021 Ohio county's population to plot counties with % positive population growth.

<details>

<summary> Solution (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># get basic map data for all USA counties </span>
<span class='nv'>usa_counties</span> <span class='o'>=</span> <span class='nf'>map_data</span><span class='o'>(</span><span class='s'>"county"</span><span class='o'>)</span>    

<span class='c'># subset to counties in Ohio </span>
<span class='nv'>oh</span> <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/subset.html'>subset</a></span><span class='o'>(</span><span class='nv'>usa_counties</span>, <span class='nv'>region</span> <span class='o'>==</span> <span class='s'>"ohio"</span><span class='o'>)</span>  

<span class='c'># read population data</span>
<span class='nv'>Ohio</span> <span class='o'>&lt;-</span> <span class='nf'>read_csv</span><span class='o'>(</span><span class='s'>"Ohio.csv"</span><span class='o'>)</span> 

<span class='c'># Create a new  column called  "county" so that counties start with capital letters using str_to_title function </span>
<span class='nv'>oh</span><span class='o'>$</span><span class='nv'>county</span> <span class='o'>=</span> <span class='nf'><a href='https://stringr.tidyverse.org/reference/case.html'>str_to_title</a></span><span class='o'>(</span><span class='nv'>oh</span><span class='o'>$</span><span class='nv'>subregion</span><span class='o'>)</span>

<span class='c'># merge counties with population</span>
<span class='nv'>ohio_pop</span><span class='o'>&lt;-</span><span class='nf'>inner_join</span><span class='o'>(</span><span class='nv'>oh</span>, <span class='nv'>Ohio</span>, by <span class='o'>=</span> <span class='s'>"county"</span><span class='o'>)</span>

<span class='c'># Select counties with % positive population growth</span>
<span class='nv'>ohio_pos_pop</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>ohio_pop</span>, <span class='nv'>Perc</span><span class='o'>&gt;</span><span class='m'>0</span><span class='o'>)</span>
<span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>ohio_pop</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y<span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_polygon</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"black"</span>, fill <span class='o'>=</span> <span class='s'>"white"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>ohio_pos_pop</span>,
             <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='kc'>NULL</span>, color <span class='o'>=</span> <span class='s'>"red"</span>, size <span class='o'>=</span> <span class='nv'>Pop</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>guides</span><span class='o'>(</span>size <span class='o'>=</span> <span class='kc'>FALSE</span><span class='o'>)</span>  <span class='c'>#  do this to leave off the size legend </span>

</code></pre>
<img src="figs/unnamed-chunk-23-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

<div class="puzzle">

### Exercise 2

Use the same data to plot counties with % negative population growth with quantile of 0-20, 20-40, 40-60, 60-80, and 80-100.

<details>

<summary> Solution (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>ohio_neg_pop</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>ohio_pop</span>, <span class='nv'>Perc</span> <span class='o'>&lt;</span> <span class='m'>0</span><span class='o'>)</span>

<span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>ohio_pop</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x<span class='o'>=</span> <span class='nv'>long</span>, y<span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_polygon</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"black"</span>, fill <span class='o'>=</span> <span class='s'>"white"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>ohio_neg_pop</span>, color <span class='o'>=</span> <span class='s'>"red"</span>,
             <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='kc'>NULL</span>, size <span class='o'>=</span> <span class='nv'>Perc</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>guides</span><span class='o'>(</span>size <span class='o'>=</span> <span class='kc'>FALSE</span><span class='o'>)</span> <span class='c'># Omit the legend</span>

</code></pre>
<img src="figs/unnamed-chunk-24-1.png" width="700px" style="display: block; margin: auto;" />
<pre class='chroma'><code class='language-r' data-lang='r'>
<span class='nv'>ApplyQuintiles_n</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span> <span class='o'>&#123;</span>
  <span class='nf'><a href='https://rdrr.io/r/base/cut.html'>cut</a></span><span class='o'>(</span><span class='nv'>x</span>, breaks <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/stats/quantile.html'>quantile</a></span><span class='o'>(</span><span class='nv'>ohio_neg_pop</span><span class='o'>$</span><span class='nv'>Perc</span>, probs <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/seq.html'>seq</a></span><span class='o'>(</span><span class='m'>0</span>, <span class='m'>1</span>, by <span class='o'>=</span> <span class='m'>0.2</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span>,
      labels <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"0-20"</span>, <span class='s'>"20-40"</span>, <span class='s'>"40-60"</span>, <span class='s'>"60-80"</span>, <span class='s'>"80-100"</span><span class='o'>)</span>,
      include.lowest <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
<span class='o'>&#125;</span>

<span class='nv'>ohio_neg_pop</span><span class='o'>$</span><span class='nv'>grouped_pop</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/lapply.html'>sapply</a></span><span class='o'>(</span><span class='nv'>ohio_neg_pop</span><span class='o'>$</span><span class='nv'>Perc</span>, <span class='nv'>ApplyQuintiles_n</span><span class='o'>)</span>

<span class='c'>#  plot the map</span>
<span class='nf'>ggplot</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_polygon</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>ohio_neg_pop</span>,
               <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span>, fill <span class='o'>=</span> <span class='nv'>grouped_pop</span><span class='o'>)</span>,
               color <span class='o'>=</span> <span class='s'>"black"</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>coord_fixed</span><span class='o'>(</span><span class='m'>1.3</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>scale_fill_brewer</span><span class='o'>(</span>palette <span class='o'>=</span> <span class='s'>"Set1"</span>, direction <span class='o'>=</span> <span class='o'>-</span><span class='m'>1</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>fill <span class='o'>=</span> <span class='s'>"Negative population growth counties"</span><span class='o'>)</span> 

</code></pre>
<img src="figs/unnamed-chunk-24-2.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

<div class="puzzle">

### Bonus exercise

Plot the cities of France with population greater than 100,000. Vary size of point by city size, and vary the color of the dots.

<details>

<summary> Solution (click here) </summary>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>world</span> <span class='o'>&lt;-</span> <span class='nf'>map_data</span><span class='o'>(</span><span class='s'>"world"</span><span class='o'>)</span>

<span class='nv'>france</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>world</span>,<span class='nv'>region</span> <span class='o'>==</span> <span class='s'>"France"</span><span class='o'>)</span>

<span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>france</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_polygon</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"black"</span>, fill <span class='o'>=</span> <span class='s'>"white"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>fill <span class='o'>=</span> <span class='s'>"France"</span><span class='o'>)</span> 

</code></pre>
<img src="figs/unnamed-chunk-25-1.png" width="700px" style="display: block; margin: auto;" />
<pre class='chroma'><code class='language-r' data-lang='r'>
<span class='c'># The "maps" package has city data</span>
<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nf'>maps</span><span class='nf'>::</span><span class='nv'><a href='https://rdrr.io/pkg/maps/man/world.cities.html'>world.cities</a></span><span class='o'>)</span>

<span class='c'>#&gt;                 name country.etc   pop   lat  long capital</span>
<span class='c'>#&gt; 1 'Abasan al-Jadidah   Palestine  5629 31.31 34.34       0</span>
<span class='c'>#&gt; 2 'Abasan al-Kabirah   Palestine 18999 31.32 34.35       0</span>
<span class='c'>#&gt; 3       'Abdul Hakim    Pakistan 47788 30.55 72.11       0</span>
<span class='c'>#&gt; 4 'Abdullah-as-Salam      Kuwait 21817 29.36 47.98       0</span>
<span class='c'>#&gt; 5              'Abud   Palestine  2456 32.03 35.07       0</span>
<span class='c'>#&gt; 6            'Abwein   Palestine  3434 32.03 35.20       0</span>

<span class='nv'>my_cities</span> <span class='o'>&lt;-</span><span class='nf'>maps</span><span class='nf'>::</span><span class='nv'><a href='https://rdrr.io/pkg/maps/man/world.cities.html'>world.cities</a></span>

<span class='nv'>france_cities</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>my_cities</span>, <span class='nv'>country.etc</span> <span class='o'>==</span> <span class='s'>"France"</span><span class='o'>)</span>

<span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>france_cities</span><span class='o'>)</span>

<span class='c'>#&gt;              name country.etc    pop   lat long capital</span>
<span class='c'>#&gt; 1       Abbeville      France  26656 50.12 1.83       0</span>
<span class='c'>#&gt; 2         Acheres      France  23219 48.97 2.06       0</span>
<span class='c'>#&gt; 3            Agde      France  23477 43.33 3.46       0</span>
<span class='c'>#&gt; 4            Agen      France  34742 44.20 0.62       0</span>
<span class='c'>#&gt; 5 Aire-sur-la-Lys      France  10470 50.64 2.39       0</span>
<span class='c'>#&gt; 6 Aix-en-Provence      France 148622 43.53 5.44       0</span>


<span class='c'># Make a point for every city:</span>
<span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>france</span>, mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_polygon</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"black"</span>, fill <span class='o'>=</span> <span class='s'>"white"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>france_cities</span>, color <span class='o'>=</span> <span class='s'>"red"</span>,
             <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='kc'>NULL</span><span class='o'>)</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-25-2.png" width="700px" style="display: block; margin: auto;" />

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># Let's pick just the big cities:</span>
<span class='nv'>france_big_cities</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>my_cities</span>,<span class='nv'>country.etc</span> <span class='o'>==</span> <span class='s'>"France"</span> <span class='o'>&amp;</span> <span class='nv'>pop</span> <span class='o'>&gt;</span> <span class='m'>100000</span><span class='o'>)</span>

<span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>france</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_polygon</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"black"</span>, fill <span class='o'>=</span> <span class='s'>"white"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>france_big_cities</span>, color <span class='o'>=</span> <span class='s'>"red"</span>,
             <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='kc'>NULL</span><span class='o'>)</span><span class='o'>)</span> 

</code></pre>
<img src="figs/unnamed-chunk-26-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># vary size of point by city size</span>
<span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>france</span>, mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_polygon</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"black"</span>, fill <span class='o'>=</span> <span class='s'>"white"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>france_big_cities</span>, color <span class='o'>=</span> <span class='s'>"red"</span>,
             <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='kc'>NULL</span>, size <span class='o'>=</span> <span class='nv'>pop</span><span class='o'>)</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-27-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># Now vary the color of the dots</span>
<span class='nv'>france_big_cities</span><span class='o'>$</span><span class='nv'>qual</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/sample.html'>sample</a></span><span class='o'>(</span><span class='nv'>LETTERS</span><span class='o'>[</span><span class='m'>1</span><span class='o'>:</span><span class='m'>5</span><span class='o'>]</span>,
                                 <span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='nv'>france_big_cities</span><span class='o'>)</span>,
                                 replace <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>

<span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>france</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_polygon</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"black"</span>,fill <span class='o'>=</span> <span class='s'>"white"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>france_big_cities</span>,
             <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='kc'>NULL</span>, color <span class='o'>=</span> <span class='nv'>qual</span>, size <span class='o'>=</span> <span class='nv'>pop</span><span class='o'>)</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-28-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># Do some tweaking:</span>
<span class='c'># no scientific notation in legend r ggplot</span>
<span class='c'># scales package adds the "scale_size_continuous" function to our arsenal, and we can set label=comma</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://scales.r-lib.org'>scales</a></span><span class='o'>)</span>

<span class='c'># Change the column name to make the legend nicer:</span>
<span class='nv'>france_big_cities</span><span class='o'>$</span><span class='nv'>Population</span> <span class='o'>&lt;-</span> <span class='nv'>france_big_cities</span><span class='o'>$</span><span class='nv'>pop</span>
<span class='nv'>france_big_cities</span><span class='o'>$</span><span class='nv'>Qualitative</span> <span class='o'>&lt;-</span> <span class='nv'>france_big_cities</span><span class='o'>$</span><span class='nv'>qual</span>

<span class='c'># Do some additional refining:</span>
<span class='nf'>ggplot</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>france</span>,
       mapping <span class='o'>=</span> <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='nv'>group</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_polygon</span><span class='o'>(</span>color <span class='o'>=</span> <span class='s'>"black"</span>, fill <span class='o'>=</span> <span class='s'>"white"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_point</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>france_big_cities</span>,
             <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>long</span>, y <span class='o'>=</span> <span class='nv'>lat</span>, group <span class='o'>=</span> <span class='kc'>NULL</span>,
                 color <span class='o'>=</span> <span class='nv'>Qualitative</span>, size <span class='o'>=</span> <span class='nv'>Population</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>scale_size_continuous</span><span class='o'>(</span>label <span class='o'>=</span> <span class='nv'>comma</span><span class='o'>)</span>

</code></pre>
<img src="figs/unnamed-chunk-29-1.png" width="700px" style="display: block; margin: auto;" />

</div>

</details>

</div>

