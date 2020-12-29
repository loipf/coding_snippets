#'
#' import library-function mapping for a package package
#'
#' @noRd
#'
#' @name regpred
#'
#' @importFrom BiocParallel bplapply MulticoreParam SerialParam SnowParam
#' @importFrom data.table data.table getDTthreads setDTthreads dcast melt set setcolorder fread fwrite
#'
NULL


#
# #### run script to get package depencies from above
#
# R_SCRIPT_DIR = file.path(getwd(),"R/")   # package dir
#
# ### load all scripts with functions pipeline_functions folder
# r_scripts = list.files(R_SCRIPT_DIR, full.names = T)
# r_scripts = r_scripts[!grepl("package_importFrom.R", r_scripts)]
# invisible( sapply(r_scripts, source ))  ### source all
# message("### libraries and functions successfully loaded")
#
# ### package to get all used functions from package dependencies
# library(NCmisc)
#
# ### load all libraries
# pacman::p_load(
#   BiocParallel,
#   data.table
# )
#
# ### get functions per file
# loaded_func_list = sapply(r_scripts, function(r_file) {
#   list.functions.in.file(r_file, alphabetic = TRUE)
# })
# loaded_func = unlist(loaded_func_list, recursive = F, use.names = T)
# loaded_func = loaded_func[grepl("R.package:",names(loaded_func) )] # only keep package dependencies
# names(loaded_func) = gsub(".*R.package:","",names(loaded_func))
#
# loaded_func[which(names(loaded_func)=="car")]
#
# loaded_func_keys = unique(names(loaded_func))
# loaded_func_uni = sapply(loaded_func_keys, function(key_name) {
#   unique(unname(unlist(loaded_func[which(names(loaded_func)==key_name)])))
#          })
#
# loaded_func_uni  ### list of used functions
#
# ### prints in copyable format
# invisible( sapply(sort(names(loaded_func_uni)), function(pkg_entry) {
#   message("#' @importFrom ",pkg_entry," ", paste0(loaded_func_uni[[pkg_entry]], collpase=" "))
# }) )
#
#

