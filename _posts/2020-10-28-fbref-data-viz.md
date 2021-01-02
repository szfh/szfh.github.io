---
title: "Using xG data from FBref"
output: github_document
layout: post
---



Using the [acciotables](https://github.com/npranav10/acciotables/) API, and some minor data transformation in R, it's possible to get Statsbomb/FBref expected goals data for every EPL match since 2017-18.

This standalone guide will produce a dataset and visualisation to use as a starting point for more detailed analysis and graphics. You don't need your own data, just an installation of R and RStudio.

## Getting data with the acciotables API

FBref stores a summary of all 380 matches in a [single html table](https://fbref.com/en/comps/9/3232/schedule). We just need the `page_url` and `selector_id`, and acciotables will produce the data in a nice html format.

Looking in the page source gives the `selector_id`: **%23sched_ks_3232_1**


```r
page_url <- "https://fbref.com/en/comps/9/3232/schedule/"
selector_id <- "%23sched_ks_3232_1"
url <- paste0("http://acciotables.herokuapp.com/?page_url=",page_url,"&content_selector_id=",selector_id)

cat(paste0("API url: ",url))
```

```
## API url: http://acciotables.herokuapp.com/?page_url=https://fbref.com/en/comps/9/3232/schedule/&content_selector_id=%23sched_ks_3232_1
```

Check the API is working in your [browser](http://acciotables.herokuapp.com/?page_url=https://fbref.com/en/comps/9/3232/schedule/&content_selector_id=%23sched_ks_3232_1).

## Importing into R

There's a guide in the [acciotables readme](https://github.com/npranav10/acciotables/#-calling-the-api-in-r).


```r
matches_import <- url %>%
  read_html() %>%
  html_table() %>%
  extract2(1) # unnest the data_frame from the list

head(matches_import)
```

```
##   Wk Day       Date          Time           Home  xG Score  xG            Away
## 1  1 Fri 2019-08-09 20:00 (19:00)      Liverpool 1.7   4–1 1.0    Norwich City
## 2  1 Sat 2019-08-10 12:30 (11:30)       West Ham 0.8   0–5 3.1 Manchester City
## 3  1 Sat 2019-08-10 15:00 (14:00)        Burnley 0.7   3–0 0.8     Southampton
## 4  1 Sat 2019-08-10 15:00 (14:00)        Watford 0.9   0–3 0.7        Brighton
## 5  1 Sat 2019-08-10 15:00 (14:00)    Bournemouth 1.0   1–1 1.0   Sheffield Utd
## 6  1 Sat 2019-08-10 15:00 (14:00) Crystal Palace 0.7   0–0 1.0         Everton
##   Attendance                 Venue        Referee Match Report Notes
## 1     53,333               Anfield Michael Oliver Match Report      
## 2     59,870        London Stadium      Mike Dean Match Report      
## 3     19,784             Turf Moor   Graham Scott Match Report      
## 4     20,245 Vicarage Road Stadium   Craig Pawson Match Report      
## 5     10,714      Vitality Stadium   Kevin Friend Match Report      
## 6     25,151         Selhurst Park  Jonathan Moss Match Report
```

## Tidy the data

There's a few things to sort out to make the raw data more usable.

* There are two columns called `xG`. That is definitely going to make something go wrong.


```r
names(matches_import) <-
  names(matches_import) %>%
  make.unique(sep="_")

matches_tidy1 <-
  matches_import %>%
  rename("HomexG"="xG","AwayxG"="xG_1")

gt(head(matches_tidy1))
```

<!--html_preserve--><style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#wmvxlvdilr .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#wmvxlvdilr .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#wmvxlvdilr .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#wmvxlvdilr .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#wmvxlvdilr .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#wmvxlvdilr .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#wmvxlvdilr .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#wmvxlvdilr .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#wmvxlvdilr .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#wmvxlvdilr .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#wmvxlvdilr .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#wmvxlvdilr .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#wmvxlvdilr .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#wmvxlvdilr .gt_from_md > :first-child {
  margin-top: 0;
}

#wmvxlvdilr .gt_from_md > :last-child {
  margin-bottom: 0;
}

#wmvxlvdilr .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#wmvxlvdilr .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#wmvxlvdilr .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#wmvxlvdilr .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#wmvxlvdilr .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#wmvxlvdilr .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#wmvxlvdilr .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#wmvxlvdilr .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#wmvxlvdilr .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#wmvxlvdilr .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#wmvxlvdilr .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#wmvxlvdilr .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#wmvxlvdilr .gt_left {
  text-align: left;
}

#wmvxlvdilr .gt_center {
  text-align: center;
}

#wmvxlvdilr .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#wmvxlvdilr .gt_font_normal {
  font-weight: normal;
}

#wmvxlvdilr .gt_font_bold {
  font-weight: bold;
}

#wmvxlvdilr .gt_font_italic {
  font-style: italic;
}

#wmvxlvdilr .gt_super {
  font-size: 65%;
}

#wmvxlvdilr .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="wmvxlvdilr" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;"><table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Wk</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Day</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Time</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Home</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">HomexG</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Score</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">AwayxG</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Away</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Attendance</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Venue</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Referee</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Match Report</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Notes</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr>
      <td class="gt_row gt_left">1</td>
      <td class="gt_row gt_left">Fri</td>
      <td class="gt_row gt_left">2019-08-09</td>
      <td class="gt_row gt_left">20:00 (19:00)</td>
      <td class="gt_row gt_left">Liverpool</td>
      <td class="gt_row gt_left">1.7</td>
      <td class="gt_row gt_left">4–1</td>
      <td class="gt_row gt_left">1.0</td>
      <td class="gt_row gt_left">Norwich City</td>
      <td class="gt_row gt_left">53,333</td>
      <td class="gt_row gt_left">Anfield</td>
      <td class="gt_row gt_left">Michael Oliver</td>
      <td class="gt_row gt_left">Match Report</td>
      <td class="gt_row gt_left"></td>
    </tr>
    <tr>
      <td class="gt_row gt_left">1</td>
      <td class="gt_row gt_left">Sat</td>
      <td class="gt_row gt_left">2019-08-10</td>
      <td class="gt_row gt_left">12:30 (11:30)</td>
      <td class="gt_row gt_left">West Ham</td>
      <td class="gt_row gt_left">0.8</td>
      <td class="gt_row gt_left">0–5</td>
      <td class="gt_row gt_left">3.1</td>
      <td class="gt_row gt_left">Manchester City</td>
      <td class="gt_row gt_left">59,870</td>
      <td class="gt_row gt_left">London Stadium</td>
      <td class="gt_row gt_left">Mike Dean</td>
      <td class="gt_row gt_left">Match Report</td>
      <td class="gt_row gt_left"></td>
    </tr>
    <tr>
      <td class="gt_row gt_left">1</td>
      <td class="gt_row gt_left">Sat</td>
      <td class="gt_row gt_left">2019-08-10</td>
      <td class="gt_row gt_left">15:00 (14:00)</td>
      <td class="gt_row gt_left">Burnley</td>
      <td class="gt_row gt_left">0.7</td>
      <td class="gt_row gt_left">3–0</td>
      <td class="gt_row gt_left">0.8</td>
      <td class="gt_row gt_left">Southampton</td>
      <td class="gt_row gt_left">19,784</td>
      <td class="gt_row gt_left">Turf Moor</td>
      <td class="gt_row gt_left">Graham Scott</td>
      <td class="gt_row gt_left">Match Report</td>
      <td class="gt_row gt_left"></td>
    </tr>
    <tr>
      <td class="gt_row gt_left">1</td>
      <td class="gt_row gt_left">Sat</td>
      <td class="gt_row gt_left">2019-08-10</td>
      <td class="gt_row gt_left">15:00 (14:00)</td>
      <td class="gt_row gt_left">Watford</td>
      <td class="gt_row gt_left">0.9</td>
      <td class="gt_row gt_left">0–3</td>
      <td class="gt_row gt_left">0.7</td>
      <td class="gt_row gt_left">Brighton</td>
      <td class="gt_row gt_left">20,245</td>
      <td class="gt_row gt_left">Vicarage Road Stadium</td>
      <td class="gt_row gt_left">Craig Pawson</td>
      <td class="gt_row gt_left">Match Report</td>
      <td class="gt_row gt_left"></td>
    </tr>
    <tr>
      <td class="gt_row gt_left">1</td>
      <td class="gt_row gt_left">Sat</td>
      <td class="gt_row gt_left">2019-08-10</td>
      <td class="gt_row gt_left">15:00 (14:00)</td>
      <td class="gt_row gt_left">Bournemouth</td>
      <td class="gt_row gt_left">1.0</td>
      <td class="gt_row gt_left">1–1</td>
      <td class="gt_row gt_left">1.0</td>
      <td class="gt_row gt_left">Sheffield Utd</td>
      <td class="gt_row gt_left">10,714</td>
      <td class="gt_row gt_left">Vitality Stadium</td>
      <td class="gt_row gt_left">Kevin Friend</td>
      <td class="gt_row gt_left">Match Report</td>
      <td class="gt_row gt_left"></td>
    </tr>
    <tr>
      <td class="gt_row gt_left">1</td>
      <td class="gt_row gt_left">Sat</td>
      <td class="gt_row gt_left">2019-08-10</td>
      <td class="gt_row gt_left">15:00 (14:00)</td>
      <td class="gt_row gt_left">Crystal Palace</td>
      <td class="gt_row gt_left">0.7</td>
      <td class="gt_row gt_left">0–0</td>
      <td class="gt_row gt_left">1.0</td>
      <td class="gt_row gt_left">Everton</td>
      <td class="gt_row gt_left">25,151</td>
      <td class="gt_row gt_left">Selhurst Park</td>
      <td class="gt_row gt_left">Jonathan Moss</td>
      <td class="gt_row gt_left">Match Report</td>
      <td class="gt_row gt_left"></td>
    </tr>
  </tbody>
  
  
</table></div><!--/html_preserve-->

* The dataset has some non-data lines. There should be 380 lines of data, one for each match in the season.


```r
matches_tidy2 <-
  matches_tidy1 %>%
  filter(Wk!="Wk",Wk!="")

cat(paste0("rows: ",dim(matches_tidy2)[1],"\n","columns: ",dim(matches_tidy2)[2]))
```

```
## rows: 380
## columns: 14
```

* Don't care about the attendance, referee etc.


```r
matches_tidy3 <-
  matches_tidy2 %>%
  select(-c("Attendance":"Notes"))

gt(head(matches_tidy3))
```

<!--html_preserve--><style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#dmsfvyfenu .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#dmsfvyfenu .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#dmsfvyfenu .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#dmsfvyfenu .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#dmsfvyfenu .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dmsfvyfenu .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#dmsfvyfenu .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#dmsfvyfenu .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#dmsfvyfenu .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#dmsfvyfenu .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#dmsfvyfenu .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#dmsfvyfenu .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#dmsfvyfenu .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#dmsfvyfenu .gt_from_md > :first-child {
  margin-top: 0;
}

#dmsfvyfenu .gt_from_md > :last-child {
  margin-bottom: 0;
}

#dmsfvyfenu .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#dmsfvyfenu .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#dmsfvyfenu .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#dmsfvyfenu .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#dmsfvyfenu .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#dmsfvyfenu .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#dmsfvyfenu .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#dmsfvyfenu .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dmsfvyfenu .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#dmsfvyfenu .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#dmsfvyfenu .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#dmsfvyfenu .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#dmsfvyfenu .gt_left {
  text-align: left;
}

#dmsfvyfenu .gt_center {
  text-align: center;
}

#dmsfvyfenu .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#dmsfvyfenu .gt_font_normal {
  font-weight: normal;
}

#dmsfvyfenu .gt_font_bold {
  font-weight: bold;
}

#dmsfvyfenu .gt_font_italic {
  font-style: italic;
}

#dmsfvyfenu .gt_super {
  font-size: 65%;
}

#dmsfvyfenu .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="dmsfvyfenu" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;"><table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Wk</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Day</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Time</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Home</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">HomexG</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Score</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">AwayxG</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Away</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr>
      <td class="gt_row gt_left">1</td>
      <td class="gt_row gt_left">Fri</td>
      <td class="gt_row gt_left">2019-08-09</td>
      <td class="gt_row gt_left">20:00 (19:00)</td>
      <td class="gt_row gt_left">Liverpool</td>
      <td class="gt_row gt_left">1.7</td>
      <td class="gt_row gt_left">4–1</td>
      <td class="gt_row gt_left">1.0</td>
      <td class="gt_row gt_left">Norwich City</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">1</td>
      <td class="gt_row gt_left">Sat</td>
      <td class="gt_row gt_left">2019-08-10</td>
      <td class="gt_row gt_left">12:30 (11:30)</td>
      <td class="gt_row gt_left">West Ham</td>
      <td class="gt_row gt_left">0.8</td>
      <td class="gt_row gt_left">0–5</td>
      <td class="gt_row gt_left">3.1</td>
      <td class="gt_row gt_left">Manchester City</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">1</td>
      <td class="gt_row gt_left">Sat</td>
      <td class="gt_row gt_left">2019-08-10</td>
      <td class="gt_row gt_left">15:00 (14:00)</td>
      <td class="gt_row gt_left">Burnley</td>
      <td class="gt_row gt_left">0.7</td>
      <td class="gt_row gt_left">3–0</td>
      <td class="gt_row gt_left">0.8</td>
      <td class="gt_row gt_left">Southampton</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">1</td>
      <td class="gt_row gt_left">Sat</td>
      <td class="gt_row gt_left">2019-08-10</td>
      <td class="gt_row gt_left">15:00 (14:00)</td>
      <td class="gt_row gt_left">Watford</td>
      <td class="gt_row gt_left">0.9</td>
      <td class="gt_row gt_left">0–3</td>
      <td class="gt_row gt_left">0.7</td>
      <td class="gt_row gt_left">Brighton</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">1</td>
      <td class="gt_row gt_left">Sat</td>
      <td class="gt_row gt_left">2019-08-10</td>
      <td class="gt_row gt_left">15:00 (14:00)</td>
      <td class="gt_row gt_left">Bournemouth</td>
      <td class="gt_row gt_left">1.0</td>
      <td class="gt_row gt_left">1–1</td>
      <td class="gt_row gt_left">1.0</td>
      <td class="gt_row gt_left">Sheffield Utd</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">1</td>
      <td class="gt_row gt_left">Sat</td>
      <td class="gt_row gt_left">2019-08-10</td>
      <td class="gt_row gt_left">15:00 (14:00)</td>
      <td class="gt_row gt_left">Crystal Palace</td>
      <td class="gt_row gt_left">0.7</td>
      <td class="gt_row gt_left">0–0</td>
      <td class="gt_row gt_left">1.0</td>
      <td class="gt_row gt_left">Everton</td>
    </tr>
  </tbody>
  
  
</table></div><!--/html_preserve-->

* The `Score` column looks something like **4-1**. We want two columns: home goals and away goals.


```r
matches_tidy4 <-
  matches_tidy3 %>%
  separate("Score",c("HomeGls","AwayGls"),sep="[:punct:]",fill="right")

gt(head(matches_tidy4))
```

<!--html_preserve--><style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#jejldyjdch .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#jejldyjdch .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#jejldyjdch .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#jejldyjdch .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#jejldyjdch .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#jejldyjdch .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#jejldyjdch .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#jejldyjdch .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#jejldyjdch .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#jejldyjdch .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#jejldyjdch .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#jejldyjdch .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#jejldyjdch .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#jejldyjdch .gt_from_md > :first-child {
  margin-top: 0;
}

#jejldyjdch .gt_from_md > :last-child {
  margin-bottom: 0;
}

#jejldyjdch .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#jejldyjdch .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#jejldyjdch .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#jejldyjdch .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#jejldyjdch .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#jejldyjdch .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#jejldyjdch .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#jejldyjdch .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#jejldyjdch .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#jejldyjdch .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#jejldyjdch .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#jejldyjdch .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#jejldyjdch .gt_left {
  text-align: left;
}

#jejldyjdch .gt_center {
  text-align: center;
}

#jejldyjdch .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#jejldyjdch .gt_font_normal {
  font-weight: normal;
}

#jejldyjdch .gt_font_bold {
  font-weight: bold;
}

#jejldyjdch .gt_font_italic {
  font-style: italic;
}

#jejldyjdch .gt_super {
  font-size: 65%;
}

#jejldyjdch .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="jejldyjdch" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;"><table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Wk</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Day</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Time</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Home</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">HomexG</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">HomeGls</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">AwayGls</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">AwayxG</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Away</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr>
      <td class="gt_row gt_left">1</td>
      <td class="gt_row gt_left">Fri</td>
      <td class="gt_row gt_left">2019-08-09</td>
      <td class="gt_row gt_left">20:00 (19:00)</td>
      <td class="gt_row gt_left">Liverpool</td>
      <td class="gt_row gt_left">1.7</td>
      <td class="gt_row gt_left">4</td>
      <td class="gt_row gt_left">1</td>
      <td class="gt_row gt_left">1.0</td>
      <td class="gt_row gt_left">Norwich City</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">1</td>
      <td class="gt_row gt_left">Sat</td>
      <td class="gt_row gt_left">2019-08-10</td>
      <td class="gt_row gt_left">12:30 (11:30)</td>
      <td class="gt_row gt_left">West Ham</td>
      <td class="gt_row gt_left">0.8</td>
      <td class="gt_row gt_left">0</td>
      <td class="gt_row gt_left">5</td>
      <td class="gt_row gt_left">3.1</td>
      <td class="gt_row gt_left">Manchester City</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">1</td>
      <td class="gt_row gt_left">Sat</td>
      <td class="gt_row gt_left">2019-08-10</td>
      <td class="gt_row gt_left">15:00 (14:00)</td>
      <td class="gt_row gt_left">Burnley</td>
      <td class="gt_row gt_left">0.7</td>
      <td class="gt_row gt_left">3</td>
      <td class="gt_row gt_left">0</td>
      <td class="gt_row gt_left">0.8</td>
      <td class="gt_row gt_left">Southampton</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">1</td>
      <td class="gt_row gt_left">Sat</td>
      <td class="gt_row gt_left">2019-08-10</td>
      <td class="gt_row gt_left">15:00 (14:00)</td>
      <td class="gt_row gt_left">Watford</td>
      <td class="gt_row gt_left">0.9</td>
      <td class="gt_row gt_left">0</td>
      <td class="gt_row gt_left">3</td>
      <td class="gt_row gt_left">0.7</td>
      <td class="gt_row gt_left">Brighton</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">1</td>
      <td class="gt_row gt_left">Sat</td>
      <td class="gt_row gt_left">2019-08-10</td>
      <td class="gt_row gt_left">15:00 (14:00)</td>
      <td class="gt_row gt_left">Bournemouth</td>
      <td class="gt_row gt_left">1.0</td>
      <td class="gt_row gt_left">1</td>
      <td class="gt_row gt_left">1</td>
      <td class="gt_row gt_left">1.0</td>
      <td class="gt_row gt_left">Sheffield Utd</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">1</td>
      <td class="gt_row gt_left">Sat</td>
      <td class="gt_row gt_left">2019-08-10</td>
      <td class="gt_row gt_left">15:00 (14:00)</td>
      <td class="gt_row gt_left">Crystal Palace</td>
      <td class="gt_row gt_left">0.7</td>
      <td class="gt_row gt_left">0</td>
      <td class="gt_row gt_left">0</td>
      <td class="gt_row gt_left">1.0</td>
      <td class="gt_row gt_left">Everton</td>
    </tr>
  </tbody>
  
  
</table></div><!--/html_preserve-->

* All the data has the *character* datatype. `type_convert` will handily auto-detect which ones should be numeric, date etc.


```r
matches_tidy5 <-
  matches_tidy4 %>%
  type_convert()
```

This is much easier to work with, but there's one more change that will help a lot later.

## Transform into long data

[Tidy data has one observation per row](https://tidyr.tidyverse.org/articles/tidy-data.html#tidy-data). Each line in this table has two independent(ish) observations: *home score* and *away score*. By transforming to long (as opposed to wide) format, working with the data becomes much easier.

What's happening here:

* `pivot_longer` to separate home and away into two rows.
* The original `matches` data frame joined back to the new data - a bit of a trick to get a sort of metadata, for filtering or labelling. Don't worry too much about this if it doesn't make sense.
* Then `if_else` to sort out the rest of the home/away data.
* `relocate` the columns used in the final plot to the left to make it easier to see.

This is a useful transformation, so it's all in a function called `make_long_matches`.


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

matches_long <- make_long_matches(matches_tidy5)

gt(head(matches_long))
```

<!--html_preserve--><style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#ddobbsnvdk .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#ddobbsnvdk .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ddobbsnvdk .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ddobbsnvdk .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ddobbsnvdk .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ddobbsnvdk .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ddobbsnvdk .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#ddobbsnvdk .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#ddobbsnvdk .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ddobbsnvdk .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ddobbsnvdk .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#ddobbsnvdk .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#ddobbsnvdk .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#ddobbsnvdk .gt_from_md > :first-child {
  margin-top: 0;
}

#ddobbsnvdk .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ddobbsnvdk .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#ddobbsnvdk .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#ddobbsnvdk .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ddobbsnvdk .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#ddobbsnvdk .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ddobbsnvdk .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ddobbsnvdk .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ddobbsnvdk .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ddobbsnvdk .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ddobbsnvdk .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#ddobbsnvdk .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ddobbsnvdk .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#ddobbsnvdk .gt_left {
  text-align: left;
}

#ddobbsnvdk .gt_center {
  text-align: center;
}

#ddobbsnvdk .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ddobbsnvdk .gt_font_normal {
  font-weight: normal;
}

#ddobbsnvdk .gt_font_bold {
  font-weight: bold;
}

#ddobbsnvdk .gt_font_italic {
  font-style: italic;
}

#ddobbsnvdk .gt_super {
  font-size: 65%;
}

#ddobbsnvdk .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="ddobbsnvdk" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;"><table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Squad</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Opposition</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">GlsF</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">GlsA</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">xGF</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">xGA</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">HA</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">Wk</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Day</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Time</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">HomexG</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">HomeGls</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">AwayGls</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">AwayxG</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Home</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Away</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr>
      <td class="gt_row gt_left">Liverpool</td>
      <td class="gt_row gt_left">Norwich City</td>
      <td class="gt_row gt_right">4</td>
      <td class="gt_row gt_right">1</td>
      <td class="gt_row gt_right">1.7</td>
      <td class="gt_row gt_right">1.0</td>
      <td class="gt_row gt_left">Home</td>
      <td class="gt_row gt_right">1</td>
      <td class="gt_row gt_left">Fri</td>
      <td class="gt_row gt_left">2019-08-09</td>
      <td class="gt_row gt_left">20:00 (19:00)</td>
      <td class="gt_row gt_right">1.7</td>
      <td class="gt_row gt_right">4</td>
      <td class="gt_row gt_right">1</td>
      <td class="gt_row gt_right">1.0</td>
      <td class="gt_row gt_left">Liverpool</td>
      <td class="gt_row gt_left">Norwich City</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">Norwich City</td>
      <td class="gt_row gt_left">Liverpool</td>
      <td class="gt_row gt_right">1</td>
      <td class="gt_row gt_right">4</td>
      <td class="gt_row gt_right">1.0</td>
      <td class="gt_row gt_right">1.7</td>
      <td class="gt_row gt_left">Away</td>
      <td class="gt_row gt_right">1</td>
      <td class="gt_row gt_left">Fri</td>
      <td class="gt_row gt_left">2019-08-09</td>
      <td class="gt_row gt_left">20:00 (19:00)</td>
      <td class="gt_row gt_right">1.7</td>
      <td class="gt_row gt_right">4</td>
      <td class="gt_row gt_right">1</td>
      <td class="gt_row gt_right">1.0</td>
      <td class="gt_row gt_left">Liverpool</td>
      <td class="gt_row gt_left">Norwich City</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">West Ham</td>
      <td class="gt_row gt_left">Manchester City</td>
      <td class="gt_row gt_right">0</td>
      <td class="gt_row gt_right">5</td>
      <td class="gt_row gt_right">0.8</td>
      <td class="gt_row gt_right">3.1</td>
      <td class="gt_row gt_left">Home</td>
      <td class="gt_row gt_right">1</td>
      <td class="gt_row gt_left">Sat</td>
      <td class="gt_row gt_left">2019-08-10</td>
      <td class="gt_row gt_left">12:30 (11:30)</td>
      <td class="gt_row gt_right">0.8</td>
      <td class="gt_row gt_right">0</td>
      <td class="gt_row gt_right">5</td>
      <td class="gt_row gt_right">3.1</td>
      <td class="gt_row gt_left">West Ham</td>
      <td class="gt_row gt_left">Manchester City</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">Manchester City</td>
      <td class="gt_row gt_left">West Ham</td>
      <td class="gt_row gt_right">5</td>
      <td class="gt_row gt_right">0</td>
      <td class="gt_row gt_right">3.1</td>
      <td class="gt_row gt_right">0.8</td>
      <td class="gt_row gt_left">Away</td>
      <td class="gt_row gt_right">1</td>
      <td class="gt_row gt_left">Sat</td>
      <td class="gt_row gt_left">2019-08-10</td>
      <td class="gt_row gt_left">12:30 (11:30)</td>
      <td class="gt_row gt_right">0.8</td>
      <td class="gt_row gt_right">0</td>
      <td class="gt_row gt_right">5</td>
      <td class="gt_row gt_right">3.1</td>
      <td class="gt_row gt_left">West Ham</td>
      <td class="gt_row gt_left">Manchester City</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">Burnley</td>
      <td class="gt_row gt_left">Southampton</td>
      <td class="gt_row gt_right">3</td>
      <td class="gt_row gt_right">0</td>
      <td class="gt_row gt_right">0.7</td>
      <td class="gt_row gt_right">0.8</td>
      <td class="gt_row gt_left">Home</td>
      <td class="gt_row gt_right">1</td>
      <td class="gt_row gt_left">Sat</td>
      <td class="gt_row gt_left">2019-08-10</td>
      <td class="gt_row gt_left">15:00 (14:00)</td>
      <td class="gt_row gt_right">0.7</td>
      <td class="gt_row gt_right">3</td>
      <td class="gt_row gt_right">0</td>
      <td class="gt_row gt_right">0.8</td>
      <td class="gt_row gt_left">Burnley</td>
      <td class="gt_row gt_left">Southampton</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">Southampton</td>
      <td class="gt_row gt_left">Burnley</td>
      <td class="gt_row gt_right">0</td>
      <td class="gt_row gt_right">3</td>
      <td class="gt_row gt_right">0.8</td>
      <td class="gt_row gt_right">0.7</td>
      <td class="gt_row gt_left">Away</td>
      <td class="gt_row gt_right">1</td>
      <td class="gt_row gt_left">Sat</td>
      <td class="gt_row gt_left">2019-08-10</td>
      <td class="gt_row gt_left">15:00 (14:00)</td>
      <td class="gt_row gt_right">0.7</td>
      <td class="gt_row gt_right">3</td>
      <td class="gt_row gt_right">0</td>
      <td class="gt_row gt_right">0.8</td>
      <td class="gt_row gt_left">Burnley</td>
      <td class="gt_row gt_left">Southampton</td>
    </tr>
  </tbody>
  
  
</table></div><!--/html_preserve-->

```r
cat(paste0("rows: ",dim(matches_long)[1],"\n","columns: ",dim(matches_long)[2]))
```

```
## rows: 760
## columns: 17
```

Now there are 760 rows, one for each team in each match.

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

Lots of ways to do this, here's a ggplot with some lines, some points, a theme, and some slightly better labels made with `ggtext`.


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



<center>
<img src="{{site.baseurl}}/images/2020-10-28-fbref-data-viz/plot-1.jpg" width="80%">
</center>

## Further reading / references / acknowledgements
* [Complete script](https://gist.github.com/szfh/a20f15d0c110898dcff5f4708f5ee630) - this is compressed a bit more and uses moving averages on the same data.
* [RMarkdown script](https://github.com/szfh/szfh.github.io/blob/master/R/2020-10-28-fbref-data-viz.Rmd) used to create this post.
* [acciotables](https://github.com/npranav10/acciotables) by [Pranav N](https://twitter.com/npranav10)
* [ggtext](https://github.com/wilkelab/ggtext) for Markdown in ggplots
* [Statsbomb](https://statsbomb.com/) for providing the data hosted by
[FBref](https://fbref.com/en/)
* [R Graph Gallery](https://www.r-graph-gallery.com/) and [Cédric Scherer](https://cedricscherer.netlify.app/2019/08/05/a-ggplot2-tutorial-for-beautiful-plotting-in-r/) for more viz ideas
* Need help? Probably best to [tweet at me](https://twitter.com/saintsbynumbers)

## One more thing

It's friendly to give credit to the data providers at Statsbomb and FBref. Statsbomb's media guide is [here](https://statsbomb.com/media-pack/), and if you want to add their logos to your images, [you can use Cowplot for that](https://szfh.github.io/cowplot/).
