library(ezknitr)
library(here)
library(glue)

# ls("package:ezknitr")
# https://github.com/ropensci/ezknitr#ezknitr---avoid-the-typical-working-directory-pain-when-using-knitr

# drafts <- here("_drafts")
# posts <- here("_posts")
# tests <- here("_tests")
# fig_dir <- "fig"

knit_to_site <- function(date,name,loc="drafts",keep_html=FALSE){
  file <- here("R",glue("{date}-{name}.Rmd"))
  print(glue("file: {file}"))
  
  out_dir <- here(glue("_{loc}"))
  print(glue("out_dir: {out_dir}"))
  
  fig_dir <- here("images",glue("{date}-{name}"))
  print(glue("fig_dir: {fig_dir}"))
  
  ezknit(file=file,out_dir=out_dir,fig_dir=fig_dir,keep_html=keep_html)
}

# knit_to_site("2020-7-16","cowplot","posts")
# knit_to_site("2020-8-2","is-hojbjerg-good","posts")
# knit_to_site("2020-10-28","fbref-data-viz","posts")
# knit_to_site("2020-11-19","press-intensity","posts")
