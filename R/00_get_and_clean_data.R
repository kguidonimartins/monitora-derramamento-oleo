############################################################
#                                                          #
#                  instalação dos pacotes                  #
#                                                          #
############################################################

# ipak function: install and load multiple R packages.
# Check to see if packages are installed.
# Install them if they are not, then load them into the R session.
# Forked from: https://gist.github.com/stevenworthington/3178163
ipak <- function(pkg) {
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) {
    install.packages(new.pkg, dependencies = TRUE)
  }
  suppressPackageStartupMessages(sapply(pkg, require, character.only = TRUE))
}

ipak(
  c(
    "tidyverse",
    "tidylog",
    "readxl",
    "here",
    "plotly",
    "fs",
    "tools",
    "rvest",
    "janitor"
  )
)

pacman::p_load_gh(
  "trinker/lexicon",
  "trinker/textclean"
)

source(here::here("R", "get_data.R"))
source(here::here("R", "last_file_on_local_folder.R"))
source(here::here("R", "from_dms_to_dd.R"))
############################################################
#                                                          #
#                    download dos dados                    #
#                                                          #
############################################################

get_data(dest_folder = "data-raw")

############################################################
#                                                          #
#               leitura e limpeza dos dados                #
#                                                          #
############################################################

last_file <- 
  last_file_on_local_folder(
    source_folder = "data-raw", 
    file_type = "xlsx"
    )

df <-
  read_xlsx(path = last_file) %>%
  rename_all(str_to_lower) %>%
  clean_names()

############################################################
#                                                          #
#           limpando e transformando coordenadas           #
#                                                          #
############################################################

latitude_raw <- str_extract_all(df$latitude, "\\(?[0-9, ., A-Z]+\\)?") 

latitude_separated <- 
  data.frame(
    matrix(
      unlist(latitude_raw), 
      nrow = length(latitude_raw), 
      byrow = TRUE), stringsAsFactors = FALSE
  ) %>% 
  mutate_all(str_squish) %>% 
  set_names(c("lat_graus", "lat_minutos", "lat_segundos", "lat_letra")) %>% 
  mutate_at(vars("lat_graus", "lat_minutos", "lat_segundos"), as.numeric)

suppressWarnings(
latitude_clean <- latitude_separated %>%  
  mutate(
    latitude = from_dms_to_dd(
      lat_graus,
      lat_minutos,
      lat_segundos,
      lat_letra
    )
  ) %>% 
  select(latitude)
)

longitude_raw <- str_extract_all(df$longitude, "\\(?[0-9, ., A-Z]+\\)?") 

longitude_separated <- 
  data.frame(
    matrix(
      unlist(longitude_raw), 
      nrow = length(longitude_raw), 
      byrow = TRUE), stringsAsFactors = FALSE
  ) %>% 
  mutate_all(str_squish) %>% 
  set_names(c("long_graus", "long_minutos", "long_segundos", "long_letra")) %>% 
  mutate_at(vars("long_graus", "long_minutos", "long_segundos"), as.numeric)

suppressWarnings(
longitude_clean <- 
  longitude_separated %>% 
  mutate(
    longitude = from_dms_to_dd(
      long_graus,
      long_minutos,
      long_segundos,
      long_letra
    )
  ) %>% 
  select(longitude)
)

############################################################
#                                                          #
#           substituindo coordenadas corrigidas            #
#                                                          #
############################################################

df_clean <- 
  df %>% 
  select(-latitude, -longitude) %>% 
  bind_cols(latitude_clean, longitude_clean) %>% 

############################################################
#                                                          #
#              removendo caracteres non ascii              #
#                                                          #
############################################################

  mutate(
    status = replace_non_ascii(status),
    status = str_replace(status, "-", ""),
    status = str_replace(status, "/", ""),
    status = str_squish(status),
    status = str_to_lower(status)
    )

############################################################
#                                                          #
#                     salvando arquivo                     #
#                                                          #
############################################################

fs::dir_create(here::here("data-clean"))

file_to_save <-
  last_file %>%
  basename() %>%
  gsub(".xlsx", "", .) %>%
  paste0(., ".csv") %>%
  paste0("data-clean/", .)

if (!file.exists(file_to_save)) {
  df_clean %>%
    write_csv(file_to_save)
} else {
  message("Arquivo ", file_to_save, " já existe")
}

