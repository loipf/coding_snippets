


### small preview of matrix
pre <- function(df) {
  rows <- min(nrow(df),6)
  cols <- min(ncol(df),6)
  df[1:rows,1:cols, drop=F]
}


### print with timestamp
print_time <- function(txt){
  print(paste0(Sys.time(),":   ",txt))
}


### get actual name of variable/function instead of values
get_var_name <- function(obj) {
  deparse(substitute(obj))
}


### merges two dataframes according to their rownames
merge_rownames_df <- function(df1, df2, ...) {
  merge_df = merge(df1, df2, by="row.names", ...)
  data.frame(merge_df, row.names = 1, check.names = F )
}



### get basename without extension
basename_core <- function(path, with_path=TRUE) {
  only_name = tools::file_path_sans_ext(basename(path))
  
  if(with_path){
    return(file.path(dirname(path), only_name ))
  } else {
    return(only_name)
  }
}


### Test whether x is either:
### - NULL
### - NA
### - NaN
### - vector of length 0
### - ""
### http://stackoverflow.com/questions/19655579/a-function-that-returns-true-on-na-null-nan-in-r
is.blank <- function(x, false.triggers=FALSE){
  if(is.function(x)) return(FALSE) # Some of the tests below trigger
  # warnings when used on functions
  return(
    is.null(x) ||                # Actually this line is unnecessary since
      length(x) == 0 ||            # length(NULL) = 0, but I like to be clear
      all(is.na(x)) ||
      all(x=="") ||
      (false.triggers && all(!x))
  )
}

### is the vector unique
is_unique <- function(vec) {
  !any(duplicated(vec))
}

### returns all the max values
which_max <- function(vec) {
  which(vec == max(vec, na.rm = TRUE))
}

### returns all the min values
which_min <- function(vec) {
  which(vec == min(vec, na.rm = TRUE))
}

### get row/col positions of func values in matrix
matrix_get_position <- function(matrix, func=min(matrix)) {
  which(matrix == func, arr.ind = TRUE)
}


### list the duplicated values
duplicated_values <- function(vec) {
  unique(vec[duplicated(vec)])
}

### list the duplicated values - boolean vector
duplicated_values_bool <- function(vec) {
  vec %in% vec[duplicated(vec)]
}

### center rows/columns of a matrix to zero
center_rowwise <- function(x, na.rm=T) {
  x_center = x - rowMeans(x, na.rm=na.rm)
  return(x_center)
}

center_columnwise <- function(x, na.rm=T) {
  x_center <- t(t(x) - colMeans(x, na.rm = na.rm))
  return(x_center)
}



### test if the elements of a list are identical
###
### @param elem_list List of elements to be compared with identical
### @param ... additional arguments passed to identical
### @return Boolean
all_identical <- function(elem_list, ...) {
  ## http://stackoverflow.com/a/18813590
  if (!is.list(elem_list)) stop("elem_list has to be a list-like object")
  if (length(elem_list) == 1) stop("elem_list has to have length > 1")
  
  ## compare all elements to the first element
  for (i in 2:length(elem_list)) {
    identical_elem <- identical(elem_list[[1]], elem_list[[i]], ...)
    
    if (identical_elem == FALSE) return(FALSE)
  }

  return(TRUE)
}




to_numeric <- function(f){
  if(class(f)=="numeric") return(f)
  if(class(f) %in% c("integer","character","logical")) return(as.numeric(f))
  if(class(f)=="factor") return( as.numeric(f) )
  stop("class not recognized")
}

to_integer <- function(f){
  if(class(f)=="integer") return(f)
  if(class(f) %in% c("numeric","character","logical")) return(as.integer(f))
  if(class(f)=="factor") return( as.integer(f) )
  stop("class not recognized")
}

as.factor_keep_order <- function(f){
  return(factor(f,unique(f)))
}


matrix_to_character <- function(matrix){
  matrix[] <- lapply(matrix, function(x) if(is.factor(x)) as.character(x) else x)
  return(matrix)
}



### get the repository file
### get_dirname=TRUE - get the full file path
### get_dirname=TRUE - get only directory name of the file
### in case the file name can not be found, the function will display a warning and return NULL
thisFile <- function(get_dirname=FALSE) {
  cmdArgs <- commandArgs(trailingOnly = FALSE)
  needle <- "--file="
  match <- grep(needle, cmdArgs)
  if (length(match) > 0) {
    ## Rscript
    thisfile <- normalizePath(sub(needle, "", cmdArgs[match]))
  } else {
    ## 'source'd via R console
    if(!is.null(sys.frames()[[1]]$ofile)) {
      thisfile <- normalizePath(sys.frames()[[1]]$ofile)
    } else {
      warning("Can't get the file name, returning NULL")
      return(NULL)
    }
  }

  if(get_dirname) return(dirname(thisfile))
  return(thisfile)
}



### to be used for timing your code, start_timer(); stop_timer()
### run this for all the samples
start_timer <- function(){
  message(paste("Timer start: ",Sys.time()))
  ## create a new environment if it doesn't exist
  if(!exists(".timer.env")) {
    local(.timer.env <- new.env(),envir=.GlobalEnv)
    .timer.env$t_list <- list()
  }
  ## append current time to t_list
  t0 <- Sys.time()
  .timer.env$t0 <- t0
  .timer.env$t_list[[length(.timer.env$t_list) + 1]] <- t0
  return(t0)
}
stop_timer <- function(){
  ## time environment has to exist
  if(!exists(".timer.env")) {
    warning("You first have to run start_timer()!")
    return(invisible(NULL))
  }

  ## t_list has have some elements
  if(length(.timer.env$t_list) < 1 ) {
    warning("Too few start_timer() instances. Using the last instance of start_timer.")
    t0 <- .timer.env$t0
  } else {
    ## get the latest time entry
    t0 <- .timer.env$t_list[[length(.timer.env$t_list)]]
    ## remove the latest time entry
    .timer.env$t_list[[length(.timer.env$t_list)]] <- NULL
  }
  ## compute the time difference with now
  t1 <- Sys.time()
  td <- difftime(t1,t0,units="secs")
  ## get the number of days 
  tdays <- floor(difftime(t1,t0,units="days"))
  tdformat <- format(.POSIXct(td,tz="GMT"), "%H:%M:%S")
  ## append day counts
  tdformat <- paste0(as.character(tdays),"-",tdformat)
  message(paste("\nEnd:   ",Sys.time()))
  message(paste("\nExecution time:",tdformat))
  return(tdformat)
}

reset_timer <- function(){
  rm(".timer.env", envir = .GlobalEnv)
}

### find a common substring always starting at the beginning
### example: words <- c("abc123","abc432")
### return should be: abc
### http://stackoverflow.com/questions/26285010/r-find-largest-common-substring-starting-at-the-beginning
find_common_substring_beginning <- function(words) {
  if(length(words)==1) return(words)
  ##extract substrings from length 1 to length of shortest word
  subs <- sapply(seq_len(min(nchar(words))), 
                 function(x, words) substring(words, 1, x), 
                 words=words)
  #max length for which substrings are equal
  neqal <- max(cumsum(apply(subs, 2, function(x) length(unique(x)) == 1L)))
  #return substring
  substring(words[1], 1, neqal)
}
                            
                            
                            
   
### transpose data.frame or matrix while keeping names                           
transpose_with_names <- function(df) {
  old_row <- rownames(df)
  old_col <- colnames(df)
  
  trans_df <- t(df)
  rownames(trans_df) <- old_col
  colnames(trans_df) <- old_row
  
  if(is.data.frame(df)) trans_df = data.frame(trans_df)
  return(trans_df)
}
                            
                            
                            
                            
 
