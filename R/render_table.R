#' Render data frame on DT
#'
#' @param data Data frame to render
#'
#' @return
#' @export
#'
#' @examples
render_table <- function(data) {
  datatable(
    data,
    rownames = TRUE,
    filter = "top",
    options = list(
      pageLength = 10,
      scrollX = FALSE, 
      columnDefs = list(
        list(
          className = "dt-center",
          targets = 5
        )
      )
    ),
    class = "cell-border stripe",
    fillContainer = TRUE
  ) %>%
    frameWidget(height = 770, width = "100%")
}
