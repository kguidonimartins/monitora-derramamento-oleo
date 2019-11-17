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
      scrollX = TRUE,
      columnDefs = list(
        list(
          className = "dt-center",
          targets = 5
        )
      ),
      pageLength = 10, lengthMenu = c(5, 10, 15, 20)
    ),
    class = "cell-border stripe",
    fillContainer = TRUE
  ) %>%
    frameWidget(height = 450, width = "100%")
}
