#' Get last file on source folder
#'
#' @param source_folder Source folder
#' @param file_type File type (e.g. "csv", "xlsx")
#'
#' @return
#' @export
#'
#' @examples
last_file_on_local_folder <- function(source_folder, file_type){
  dir_info(source_folder) %>%
    mutate(file_type = file_ext(path)) %>%
    arrange(desc(birth_time)) %>%
    filter(file_type == file_type) %>%
    slice(1) %>%
    pull(path)
}
