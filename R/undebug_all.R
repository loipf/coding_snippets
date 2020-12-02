### tries to remove all currently debugged functions 
### from: http://ms.mcmaster.ca/~bolker/R/misc/undebug_all.R


## return the names of the objects (from a vector of list of
## names of objects) that are functions and have debug flag set
isdebugged_safe <- function(x,ns=NULL)  {
    g <- if (is.null(ns)) get(x) else getFromNamespace(x,ns)
    is.function(g) && isdebugged(g)
}

which_debugged <- function(objnames,ns=NULL) {
    if (!length(objnames)) return(character(0))
    objnames[sapply(objnames,isdebugged_safe,ns=ns)]
}

all_debugged <- function(where=search(), show_empty=FALSE) {
    ss <- setNames(lapply(where,function(x) {
        which_debugged(ls(x,all.names=TRUE))
        }),gsub("package:","",where))
    ## find attached namespaces
    ## (is there a better way to test whether a namespace exists with a given name??)
    ns <- unlist(sapply(gsub("package:","",where),
                 function(x) {
                     if (inherits({n <- try(getNamespace(x),silent=TRUE)},
                         "try-error")) NULL else x
                 }))
    ss_ns <- setNames(lapply(ns,function(x) {
        objects <- ls(getNamespace(x),all.names=TRUE)
        which_debugged(objects,ns=x)
        }),ns)
    if (!show_empty) {
        ss <- ss[sapply(ss,length)>0]
        ss_ns <- ss_ns[sapply(ss_ns,length)>0]
    }
    ## drop overlaps
    for (i in names(ss))
        ss_ns[[i]] <- setdiff(ss_ns[[i]],ss[[i]])
    list(env=ss,ns=ss_ns)
}

undebug_all <- function(where=search()) {
    aa <- all_debugged(where)
    lapply(aa$env,undebug)
    ## now debug namespaces
    invisible(mapply(function(ns,fun) {
        undebug(getFromNamespace(fun,ns))
    },names(aa$ns),aa$ns))
}





