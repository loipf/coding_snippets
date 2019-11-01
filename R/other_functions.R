


### small preview of matrix
pre <- function(df) {
  rows <- min(nrow(df),6)
  cols <- min(ncol(df),6)
  df[1:rows,1:cols]
}
