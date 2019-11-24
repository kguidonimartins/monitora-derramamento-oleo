#' Convert coordinates from degrees, minutes and seconds to decimal degrees
#'
#' @param degrees 
#' @param minutes 
#' @param seconds 
#' @param direction 
#'
#' @return
#' @export
#'
#' @examples
from_dms_to_dd <- function(degrees, minutes, seconds, direction){
  dd <-  as.numeric(degrees) + (as.numeric(minutes)/60) + (as.numeric(seconds)/(60*60))
  if (direction == "W" | direction == "S"){
    dd <- dd * -1
  }
  return(dd)
}
# https://stackoverflow.com/questions/33997361/how-to-convert-degree-minute-second-to-degree-decimal
