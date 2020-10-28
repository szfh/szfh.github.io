---
title: "Getting and using xG data from FBRef"
output: github_document
layout: post
---



Using the [acciotables](https://github.com/npranav10/acciotables/) API, and some minor data transformation in R, it's possible to get Statsbomb/FBRef expected goals data for every EPL match since 2017-18.

This standalone script will produce a dataset and visualisation to use as a starting point for more detailed analysis and graphics. You don't need your own data, just an installation of R and RStudio.

## Getting data with the acciotables API

FBRef stores a summary of all 380 matches in a [single html table](https://fbref.com/en/comps/9/3232/schedule). We just need to get the page url and table id, and acciotables will give us the data in a nice format.

Looking in the page source gives the table id: **%23sched_ks_3232_1**


```r
page_url <- "https://fbref.com/en/comps/9/3232/schedule/"
selector_id <- "%23sched_ks_3232_1"
url <- paste0("http://acciotables.herokuapp.com/?page_url=",page_url,"&content_selector_id=",selector_id)

print(paste0("API url: ",url))
```

```
## [1] "API url: http://acciotables.herokuapp.com/?page_url=https://fbref.com/en/comps/9/3232/schedule/&content_selector_id=%23sched_ks_3232_1"
```

You can check the API is working in your [browser](http://acciotables.herokuapp.com/?page_url=https://fbref.com/en/comps/9/3232/schedule/&content_selector_id=%23sched_ks_3232_1).

## Importing into R

The [acciotables readme](https://github.com/npranav10/acciotables/#-calling-the-api-in-r) tells us what to do.


```r
matches <- url %>%
  read_html() %>%
  html_table() %>%
  extract2(1) # unnest the data_frame from the list

head(matches)
```

```
##   Wk Day       Date          Time           Home  xG Score  xG            Away Attendance
## 1  1 Fri 2019-08-09 20:00 (19:00)      Liverpool 1.7   4–1 1.0    Norwich City     53,333
## 2  1 Sat 2019-08-10 12:30 (11:30)       West Ham 0.8   0–5 3.1 Manchester City     59,870
## 3  1 Sat 2019-08-10 15:00 (14:00)        Burnley 0.7   3–0 0.8     Southampton     19,784
## 4  1 Sat 2019-08-10 15:00 (14:00)        Watford 0.9   0–3 0.7        Brighton     20,245
## 5  1 Sat 2019-08-10 15:00 (14:00)    Bournemouth 1.0   1–1 1.0   Sheffield Utd     10,714
## 6  1 Sat 2019-08-10 15:00 (14:00) Crystal Palace 0.7   0–0 1.0         Everton     25,151
##                   Venue        Referee Match Report Notes
## 1               Anfield Michael Oliver Match Report      
## 2        London Stadium      Mike Dean Match Report      
## 3             Turf Moor   Graham Scott Match Report      
## 4 Vicarage Road Stadium   Craig Pawson Match Report      
## 5      Vitality Stadium   Kevin Friend Match Report      
## 6         Selhurst Park  Jonathan Moss Match Report
```

## Tidy the data

There's a few things to sort out to make the raw data more usable.

* There are two columns called "xG". That is definitely going to make something go wrong.


```r
names(matches) <-
  names(matches) %>%
  make.unique(sep="_")

matches <-
  matches %>%
  rename("HomexG"="xG","AwayxG"="xG_1")

names(matches)
```

```
##  [1] "Wk"           "Day"          "Date"         "Time"         "Home"        
##  [6] "HomexG"       "Score"        "AwayxG"       "Away"         "Attendance"  
## [11] "Venue"        "Referee"      "Match Report" "Notes"
```

* The dataset has some non-data lines. There should be 380 lines of data, one for each match in the season.


```r
matches <-
  matches %>%
  filter(Wk!="Wk",Wk!="")

dim(matches) # how many rows and columns?
```

```
## [1] 380  14
```

* Don't care about the attendance, referee etc.


```r
matches <-
  matches %>%
  select(-c("Attendance":"Notes"))

head(matches)
```

```
##   Wk Day       Date          Time           Home HomexG Score AwayxG            Away
## 1  1 Fri 2019-08-09 20:00 (19:00)      Liverpool    1.7   4–1    1.0    Norwich City
## 2  1 Sat 2019-08-10 12:30 (11:30)       West Ham    0.8   0–5    3.1 Manchester City
## 3  1 Sat 2019-08-10 15:00 (14:00)        Burnley    0.7   3–0    0.8     Southampton
## 4  1 Sat 2019-08-10 15:00 (14:00)        Watford    0.9   0–3    0.7        Brighton
## 5  1 Sat 2019-08-10 15:00 (14:00)    Bournemouth    1.0   1–1    1.0   Sheffield Utd
## 6  1 Sat 2019-08-10 15:00 (14:00) Crystal Palace    0.7   0–0    1.0         Everton
```

* The `Score` column looks something like *3-1*. We want two columns: home goals and away goals.


```r
matches <-
  matches %>%
  separate("Score",c("HomeGls","AwayGls"),sep="[:punct:]",fill="right")

head(matches)
```

```
##   Wk Day       Date          Time           Home HomexG HomeGls AwayGls AwayxG
## 1  1 Fri 2019-08-09 20:00 (19:00)      Liverpool    1.7       4       1    1.0
## 2  1 Sat 2019-08-10 12:30 (11:30)       West Ham    0.8       0       5    3.1
## 3  1 Sat 2019-08-10 15:00 (14:00)        Burnley    0.7       3       0    0.8
## 4  1 Sat 2019-08-10 15:00 (14:00)        Watford    0.9       0       3    0.7
## 5  1 Sat 2019-08-10 15:00 (14:00)    Bournemouth    1.0       1       1    1.0
## 6  1 Sat 2019-08-10 15:00 (14:00) Crystal Palace    0.7       0       0    1.0
##              Away
## 1    Norwich City
## 2 Manchester City
## 3     Southampton
## 4        Brighton
## 5   Sheffield Utd
## 6         Everton
```

* All the data has the *character* datatype, so a simple line will auto-detect which ones should be numeric, date etc.


```r
matches <-
  matches %>%
  type_convert()
```

```
## Parsed with column specification:
## cols(
##   Wk = col_double(),
##   Day = col_character(),
##   Date = col_date(format = ""),
##   Time = col_character(),
##   Home = col_character(),
##   HomexG = col_double(),
##   HomeGls = col_double(),
##   AwayGls = col_double(),
##   AwayxG = col_double(),
##   Away = col_character()
## )
```

This is much easier to work with, but there's one more change that will help a lot later.

## Transform into long data

[Tidy data has one observation per row](https://tidyr.tidyverse.org/articles/tidy-data.html#tidy-data). Each line in this table has two independent(ish) observations: *home score* and *away score*. By transforming to long (as opposed to wide) format, working with the data becomes much easier.

What's happening here is:

* A pivot_longer implementation to separate home and away
* The original `matches` data frame joined back to the new data - a bit of a trick to get sort of metadata, for filtering or labelling. Don't worry too much about this if it doesn't make sense.
* Then if_else to sort out the rest of the home/away data.
* The columns used in the final plot are relocated to the left to make it easier to see.

That's all in a function called `make_long_matches` for good practice.


```r
make_long_matches <- function(matches){
  
  long_matches <-
    matches %>%
    pivot_longer(cols=c(Home,Away),
                 names_to="HA",
                 values_to="Squad") %>%
    left_join(matches) %>% # join the old data frame to the new one
    mutate(
      Opposition=ifelse(HA=="Home",Away,Home),
      GlsF=ifelse(HA=="Home",HomeGls,AwayGls),
      GlsA=ifelse(HA=="Home",AwayGls,HomeGls),
      xGF=ifelse(HA=="Home",HomexG,AwayxG),
      xGA=ifelse(HA=="Home",AwayxG,HomexG)
    ) %>%
    relocate("Squad","Opposition":"xGA","HA")
  
  return(long_matches)
}

matches_long <- make_long_matches(matches)
```

```
## Joining, by = c("Wk", "Day", "Date", "Time", "HomexG", "HomeGls", "AwayGls", "AwayxG")
```

```r
head(matches_long)
```

```
## # A tibble: 6 x 17
##   Squad Opposition  GlsF  GlsA   xGF   xGA HA       Wk Day   Date       Time  HomexG HomeGls
##   <chr> <chr>      <dbl> <dbl> <dbl> <dbl> <chr> <dbl> <chr> <date>     <chr>  <dbl>   <dbl>
## 1 Live~ Norwich C~     4     1   1.7   1   Home      1 Fri   2019-08-09 20:0~    1.7       4
## 2 Norw~ Liverpool      1     4   1     1.7 Away      1 Fri   2019-08-09 20:0~    1.7       4
## 3 West~ Mancheste~     0     5   0.8   3.1 Home      1 Sat   2019-08-10 12:3~    0.8       0
## 4 Manc~ West Ham       5     0   3.1   0.8 Away      1 Sat   2019-08-10 12:3~    0.8       0
## 5 Burn~ Southampt~     3     0   0.7   0.8 Home      1 Sat   2019-08-10 15:0~    0.7       3
## 6 Sout~ Burnley        0     3   0.8   0.7 Away      1 Sat   2019-08-10 15:0~    0.7       3
## # ... with 4 more variables: AwayGls <dbl>, AwayxG <dbl>, Home <chr>, Away <chr>
```

```r
dim(matches_long)
```

```
## [1] 760  17
```

Now there should be 760 rows, one for each team in each match.

## Filter

Next the data can be filtered get a subset for analysis. In this case it's the data for all matches played so far by a single team.


```r
team_name <- "Liverpool"

matches_team <-
  matches_long %>%
  filter(Squad==team_name) %>% # filter team
  filter(!is.na(HomeGls)) # only matches which have been played
```

Some work to use later - create an new column to use as an X axis label, and use `fct_reorder` to get the X axis in date order.


```r
matches_team <-
  matches_team %>%
  mutate(Match=paste0(Opposition," ",HA," ",GlsF,"-",GlsA)) %>% # make X axis labels
  mutate(Match=fct_reorder(Match, Date)) # order by date
```

## Plot

Lots of ways to do this, here's a ggplot with some lines, some points, a theme, and some slightly better labels made with ggtext.


```r
matches_team %>%
  ggplot(aes(x=Match,group=1)) +
  geom_point(aes(y=xGF),size=2,colour="black",fill="darkred",shape=21) +
  geom_smooth(aes(y=xGF),colour="darkred",se=FALSE) +
  geom_point(aes(y=xGA),size=2,colour="black",fill="royalblue",shape=21) +
  geom_smooth(aes(y=xGA),colour="royalblue",se=FALSE) +
  theme_bw() +
  theme(
    plot.title=element_markdown(),
    axis.title.y=element_markdown(),
    axis.text.x=element_text(size=6,angle=60,hjust=1)
  ) +
  labs(
    title=paste0(team_name," <b style='color:darkred'>attack</b> / <b style='color:royalblue'>defence</b> xG trend"),
    x=element_blank(),
    y=("Expected goals <b style='color:darkred'>for</b> / <b style='color:royalblue'>against</b>")
  ) +
  scale_x_discrete(expand=expansion(add=c(0.5))) +
  scale_y_continuous(limits=c(0,NA),expand=expansion(add=c(0,0.1)))
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

![plot of chunk plot](H:/Projects/szfh.github.io/images/2020-10-13-fbref-data-viz/plot-1.png)

<center>
<img src="{{site.baseurl}}/images/2020-10-13-fbref-data-viz/plot.jpg" width="100%">
</center>

## Further reading

* [Link to the complete script](https://gist.github.com/szfh/a20f15d0c110898dcff5f4708f5ee630)
* [R Graph Gallery](https://www.r-graph-gallery.com/) for more viz ideas
* Need help? Probably best to [tweet at me](https://twitter.com/saintsbynumbers)

## Refs/acknowledgements

[acciotables](https://github.com/npranav10/acciotables) by [Pranav N](https://twitter.com/npranav10)
[Statsbomb](https://statsbomb.com/) for providing the data which is hosted by...
[FBRef](https://fbref.com/en/)
Various people for testing

## One more thing

It's friendly to give credit to the data providers at Statsbomb and FBRef. Statsbomb's media guide is here. If you want to add their logos to your images, [you can use Cowplot for that](https://szfh.github.io/cowplot/).

