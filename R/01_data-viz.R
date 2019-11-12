# ipak function: install and load multiple R packages.
# Check to see if packages are installed. 
# Install them if they are not, then load them into the R session.
# Forked from: https://gist.github.com/stevenworthington/3178163
ipak <- function(pkg) {
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)){
    install.packages(new.pkg, dependencies = TRUE)
  }
  suppressPackageStartupMessages(sapply(pkg, require, character.only = TRUE))
}

ipak(c("tidyverse", "tidylog", "fs", "here", "tools"))

theme_set(theme_light(base_size = 14))

############################################################
#                                                          #
#                        read data                         #
#                                                          #
############################################################

last_file_on_local_folder <-
  dir_info(here("data-clean")) %>% 
  mutate(file_type = file_ext(path)) %>% 
  arrange(desc(birth_time)) %>% 
  filter(file_type == "csv") %>% 
  slice(1) %>% 
  pull(path)

df <- read_csv(last_file_on_local_folder)

############################################################
#                                                          #
#                       visualização                       #
#                                                          #
############################################################

df %>% 
  group_by(estado, status) %>% 
  count() %>% 
  ungroup() %>% 
  mutate(estado = fct_reorder(estado, n)) %>% 
  ggplot(aes(x = estado, y = n)) +
  geom_col() +
  coord_flip() +
  labs(
    x = "",
    y = "Número de registros",
    title = "Registros por Estado", 
    caption = "Fonte: http://www.ibama.gov.br/manchasdeoleo-localidades-atingidas"
  ) + 
  facet_wrap( ~status)

############################################################
#                                                          #
#                           mapa                           #
#                                                          #
############################################################

shape_brasil <- borders(
  database = "world", 
  regions = "Brazil",
  fill = "white", 
  colour = "grey90" 
)

mapa_oleo <- 
  df %>%
  ggplot() + 
  shape_brasil + 
  theme_bw() + 
  labs(
    x = "Longitude", 
    y = "Latitude"
  ) +
  theme(
    panel.border = element_blank(),
    panel.grid.major = element_line(colour = "grey80"),
    panel.grid.minor = element_blank()
  ) +
  coord_map() +
  geom_point(
    aes(
      x = longitude, 
      y = latitude,
      colour = status
    ), 
    alpha = 0.5, 
    size = 3
  ) 

# mapa estático
mapa_oleo

# mapa estático por estado
mapa_facet <- mapa_oleo +
  facet_wrap( ~estado)

mapa_facet
############################################################
#                                                          #
#                     mapa interativo                      #
#                                                          #
############################################################

ggplotly(mapa_oleo)

ggplotly(mapa_facet)
