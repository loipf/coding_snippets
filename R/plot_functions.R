library(VennDiagram)




### returns named x2 matrix sorted with row and cols like x1
sort_plot_input <- function(x1,x2) {
    if(!is.matrix(x2)){
        return(x2)
    }
    x2_row_sort <- match(rownames(x1), rownames(x2))
    row_x2 = x2[x2_row_sort,]  
    
    x2_col_sort <- match(colnames(x1), colnames(row_x2))
    col_row_sorted <- x2[,x2_col_sort]
    
    return(col_row_sorted)
}




### helper methods for plotting
plot_binhex <- function(x, y, title="", axis_limit=20, center=TRUE, xylabel=c("plot_X", "plot_Y")){
  y <- sort_plot_input(x,y)
  axis_min = -axis_limit
  # if(axis_limit>30) {
  #     axis_min = max(axis_min, 0)
  # }
  ggplot_dt <- data.table(plot_X = c(unlist(x)), plot_Y = c(unlist(y)) )
  pl <- ggplot(ggplot_dt, aes(x=plot_X,y=plot_Y)) +
    stat_binhex(aes(fill=log10(..count..))) +
    geom_abline(intercept = 0, slope = 1, color='orange') + ggtitle(title) +
      xlab(xylabel[1]) + ylab(xylabel[2]) + theme(legend.position = "none")
  
  if(center) {
    pl + xlim(axis_min, axis_limit) + ylim(axis_min, axis_limit) 
  } else {
    pl
  }
}






### pairwise venn diagram with matrix or vector as input
plot_venn_2 <- function(df1, df2, df_label=c("df1","df2"), title='') {
    df1_samples = as.vector(df1)
    df2_samples = as.vector(df2)
    
    df_intersect = length(intersect(df1_samples,df2_samples))
    grid.newpage()
    g <- draw.pairwise.venn(area1 = length(df1_samples), area2 = length(df2_samples), cross.area = df_intersect, category = df_label,  fill = c("light blue", "green"), 
                            alpha = rep(0.5, 2), cat.pos = c(340, 20),
                            lty = rep("blank", 2), cex = 1.5, cat.cex = 1.5
    )#euler.d = F, sep.dist = 0.03, rotation.degree = 45)
    
    grid.arrange(gTree(children=g), top=title)
}



### venn diagram with 3 intersections
plot_venn_3 <- function(df1, df2, df3, df_label=c("df1","df2", "df3"), title='') {
    df1_samples = as.vector(df1)
    df2_samples = as.vector(df2)
    df3_samples = as.vector(df3)
    
    in12 = length(intersect(df1_samples,df2_samples))
    in23 = length(intersect(df2_samples,df3_samples))
    in13 = length(intersect(df1_samples,df3_samples))
    in123 = length(intersect(intersect(df1_samples,df2_samples),df3_samples))
    
    grid.newpage()
    g <- draw.triple.venn(
        area1 = length(df1_samples), area2 = length(df2_samples), area3 = length(df3_samples),
        n12 = in12,
        n23 = in23,
        n13 = in13,
        n123 = in123,
        category = df_label,
        fill = c("light blue", "green", "red"),
        lty = "blank", cex = 1.5, cat.cex = 1.5
    )
    grid.arrange( gTree(children=g), top = title )

}




