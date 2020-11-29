---
title: "Press Intensity"
output: github_document
layout: post
editor_options: 
  chunk_output_type: console
---



[*FBref*](https://fbref.com/en/) have added opposition stats to their summary pages for the 2020-21 season. That opens up a world of new analysis.

I am interested in alternative ways to look at Passes per Defensive Action - a commonly used measurement of pressing. Here I have calculated **Opposition Touches** per **Pressure**. The pitch is split into thirds to show press style in different parts of the field (and because that is what FBref gives me). FBRef defines an individual control, dribble and pass as one touch. It's intuitive that this event is what will be pressured (maybe more than once), so I have used it instead of passes.



<center>
<img src="{{site.baseurl}}/images/2020-11-19-press-intensity/pressintensity.jpg" width="100%">
</center>

Pressures can be broken down by player position. A pressure 40 yards from goal by a forward is different to one by a midfielder, this difference can tell us something different about playing style than PPDA.

Limitation: This is the position as given by FBref (DF/MF/FW), if a player plays out of position it may cause unusual numbers. Breaking down further (CB/FB) would give more information but add to complexity and reduce statistical size.



<center>
<img src="{{site.baseurl}}/images/2020-11-19-press-intensity/pressposition.jpg" width="100%">
</center>

*Data for 2020-21 season to Matchweek 9*
