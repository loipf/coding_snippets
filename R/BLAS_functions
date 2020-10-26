### BLAS supported functions for large data sets


### from: https://stackoverflow.com/questions/18964837/fast-correlation-in-r-using-c-and-parallelization
BLAS_cor_on_rows <- function(df) {
  mat = as.matrix(df)
  mat = mat - rowMeans(mat)  # center each variable
  mat = mat / sqrt(rowSums(mat^2)) # standardize each variable
  cr = tcrossprod(mat)  # calculate correlation
  return(cr)
}













