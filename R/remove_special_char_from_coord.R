#' Remove special character from coordinates format degree, minutes and seconds
#'
#' @param coord Coordinate to clean
#'
#' @return
#' @export
#'
#' @examples
remove_special_char_from_coord <- function(coord) {
  if (grepl(pattern = "[A-Z]", x = coord)) {
    coord <- iconv(coord, "utf-8", "ascii", sub = "") %>% {
      gsub(pattern = "(')|(\")", replacement = "", x = .)
    }
  } else {
    coord <- coord
  }
  
  return(coord)
}
