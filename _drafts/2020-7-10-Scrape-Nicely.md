---
layout: post
title: Using Cowplot to add logos to ggplots
---

https://statsbomb.com/media-pack/

In exchange for free data at fbref or on their site, Statsbomb politely ask you to use their logo, available here: https://statsbomb.com/media-pack/. 

In ggplot you can add a text caption easily, but an image is surprisingly complicated.

<side by side plots of absolute position>

The Cowplot package will do this for you. Other data sources are available and you can use this for any logo, including your own if you like.

# Method

1. Save your ggplots in a list. This is good practice for lots of reasons.

plots$mtcars <- ggplot()

1. Install Cowplot and create a function like this.
You can hard-code the file name and coordinates or take them in as arguments.

1. Call the function with your list of ggplots.

Please scrape responsibly.

# Plan
1. Intro
1. The problem
1. Details
1. Please be responsible
1. Sources/references
