#' Get data from IBAMA
#'
#' @param dest_folder Destination folder
#'
#' @return
#' @export
#'
#' @examples
get_data <- function(dest_folder) {
  if (!dir.exists(dest_folder)) {
    dir.create(dest_folder)
  }
  
  url_for_link <- "http://www.ibama.gov.br/manchasdeoleo-localidades-atingidas"
  
  url_for_download <- "http://www.ibama.gov.br"
  
  files <-
    url_for_link %>%
    read_html() %>%
    html_nodes("td:nth-child(2) a") %>%
    html_attr("href") %>%
    tibble() %>%
    set_names("link") %>%
    mutate(
      file = basename(link),
      file_type = file_ext(file)
    ) %>%
    filter(file_type == "xlsx")
  
  last_file_on_web <- files %>%
    slice(1) %>%
    pull(file)
  
  link_for_the_last_file <- files %>%
    slice(1) %>%
    pull(link) %>%
    paste0(url_for_download, .)
  
  dest_and_name <- paste0(dest_folder, "/", last_file_on_web)
  
  if (!file.exists(dest_and_name)) {
    download.file(url = link_for_the_last_file, destfile = dest_and_name)
  } else {
    message("Arquivo ", dest_and_name, " já existe")
  }
}
