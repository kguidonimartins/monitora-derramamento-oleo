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
    "biogeo",
    "plotly",
    "fs",
    "tools",
    "rvest",
    "janitor"
  )
)

source(here::here("R", "get_data.R"))
source(here::here("R", "last_file_on_local_folder.R"))

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

# last_file_on_local_folder <-
#   dir_info(here::here("data-raw")) %>%
#   mutate(file_type = file_ext(path)) %>%
#   arrange(desc(birth_time)) %>%
#   filter(file_type == "xlsx") %>%
#   slice(1) %>%
#   pull(path)

last_file <- 
  last_file_on_local_folder(
    source_folder = "data-raw", 
    file_type = "xlsx"
    )

df <-
  read_xlsx(path = last_file) %>%
  rename_all(str_to_lower) %>%
  clean_names()

clean_coord <- function(coord) {
  if (grepl(pattern = "[A-Z]", x = coord)) {
    coord <- iconv(coord, "utf-8", "ascii", sub = "") %>% {
      gsub(pattern = "(')|(\")", replacement = "", x = .)
    }
  } else {
    coord <- coord
  }

  return(coord)
}

df_clean <-
  suppressWarnings(
    df %>%
      mutate(
        latitude = clean_coord(latitude),
        longitude = clean_coord(longitude)
      ) %>%
      separate(
        col = latitude,
        into = c("lat_graus", "lat_minutos", "lat_segundos", "lat_letra"),
        sep = " ",
        remove = FALSE,
        convert = TRUE,
        extra = "drop"
      ) %>%
      separate(
        col = longitude,
        into = c("long_graus", "long_minutos", "long_segundos", "long_letra"),
        sep = " ",
        remove = FALSE,
        convert = TRUE,
        extra = "drop"
      ) %>%
      mutate(
        latitude = if_else(
          condition = is.na(lat_letra),
          true = latitude,
          false = as.character(
            dms2dd(
              dd = lat_graus,
              mm = lat_minutos,
              ss = lat_segundos,
              ns = lat_letra
            )
          )
        ),
        longitude = if_else(
          condition = is.na(long_letra),
          true = longitude, false = as.character(
            dms2dd(
              dd = long_graus,
              mm = long_minutos,
              ss = long_segundos,
              ns = long_letra
            )
          )
        ),
        latitude = as.numeric(latitude),
        longitude = as.numeric(longitude)
      ) %>%
      dplyr::select(-starts_with("lat_"), -starts_with("long_")) %>%
      distinct(latitude, longitude, .keep_all = TRUE)
  )

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
