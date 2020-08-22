library(ezknitr)
library(here)
library(glue)

ls("package:ezknitr")
# https://github.com/ropensci/ezknitr#ezknitr---avoid-the-typical-working-directory-pain-when-using-knitr

# drafts <- here("_drafts")
# posts <- here("_posts")
# tests <- here("_tests")
# fig_dir <- "fig"

knit_to_site <- function(date,name,loc="drafts",keep_html=FALSE){
  file <- here("R",glue("{date}-{name}.Rmd"))
  print(file)
  
  out_dir <- here(glue("_{loc}"))
  print(out_dir)
  
  fig_dir <- here("images",glue("{date}-{name}"))
  print(fig_dir)
  
  ezknit(file=file,out_dir=out_dir,fig_dir=fig_dir,keep_html=keep_html)
}

# ezknit(file=here("R","2020-7-16-cowplot.Rmd"),out_dir=posts,fig_dir=here("images","cowplot"),keep_html=FALSE)
# ezknit(file=here("R","2020-8-13-example-fbref-plots.Rmd"),out_dir=drafts,fig_dir=here("images","example-fbref-plots"),keep_html=FALSE)

# knit_to_site("2020-7-16","cowplot","tests")
