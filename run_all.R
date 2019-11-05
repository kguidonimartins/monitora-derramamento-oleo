if (!require("rmarkdown")) install.packages("rmarkdown")
if (!require("here")) install.packages("here")

source(here::here("R", "00_get_and_clean_data.R"))

render(input = here::here("index.Rmd"))
