library(data.table)


### load data from file path
load_dataframe <- function(file_path, ... ) {
  df = data.frame(fread(file_path, header=T, stringsAsFactors = F), row.names = 1, check.names = F, ...)
  return(df)
}


save_dataframe <- function(df, file_path, ...) {
  if(!is.null(file_path)) {
    file_path_ext = tools::file_ext(file_path)
    default_sep = switch(file_path_ext,
                         "csv"=",",
                         "tsv"="\t",
                         "txt"="\t",
                         ",")
    if(file_path_ext=="") {  file_path = paste0(file_path,".tsv")  }  ### default
    
    
    ### numeric rownames sometimes still cause problems in fwrite
    ### see: https://github.com/Rdatatable/data.table/issues/4957
    if(is.numeric(as.numeric(rownames(df)))) {
      warning('numeric rownames: rownames may be incorrect')
      
      # ### alternative
      # write.table(as.data.frame(df), file_path, row.names = T, col.names = NA, sep = default_sep, quote = F, ...)
    }
      
    fwrite(as.data.frame(df), file_path, row.names=T, sep=default_sep, ...)
  } else {
    warning("file_path not given, file will not be saved")
  }
}



