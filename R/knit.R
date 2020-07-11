library(ezknitr)
library(here)

ls("package:ezknitr")
# https://github.com/ropensci/ezknitr#ezknitr---avoid-the-typical-working-directory-pain-when-using-knitr

drafts <- here("_drafts")
posts <- here("_posts")
tests <- here("_tests")
fig_dir <- "fig"

ezknit(file=here("R","markdown-test.Rmd"),out_dir=tests,fig_dir=fig_dir,keep_html=FALSE)
