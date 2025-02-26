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



create_venn_diagram_df = function(list_of_vectors) {
    all_elements = unique(unlist(list_of_vectors))
    overlap_df = data.frame(
      element_id = all_elements,
      do.call(cbind, lapply(list_of_vectors, function(set) all_elements %in% set))
    )
    colnames(overlap_df)[-1] <- names(list_of_vectors)
    overlap_df
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




### histogram with significance comparison
library(ggsignif)
plot_histogram_sig = function(plot_df, x_name, y_name) {
  pval_all_combis = combn(unique(plot_df[[x_name]]),2)
  pval_comparison_list = lapply(1:ncol(pval_all_combis), function(col_num) { pval_all_combis[,col_num] })
  
  plot_df_edited = plot_df[,c(x_name, y_name)]
  colnames(plot_df_edited) = c('x','y')
  
  p = ggplot(plot_df_edited, aes(x = x, y = y)) + geom_boxplot() + theme_classic() +
    xlab(x_name) + ylab(y_name) +
    geom_jitter(color="black", width = 0.05, height=0.0, alpha=0.7)
  
  # sigFunc = function(x){ if(x < 0.1){format(x, digits=3)} else{NA}}
  p = p + geom_signif(comparisons = pval_comparison_list, 
                      # map_signif_level = TRUE,
                      # map_signif_level = sigFunc,
                      step_increase = 0.07,test = "wilcox.test", textsize=2.8)
  p
}



plot_boxplot = function(x, y, x_label="x", y_label="y", plot_title='', colors=T, show_pvalue=T, jitter=FALSE) {
  require(ggpubr)
  plot_df = data.frame("x"=as.factor(as.character(x)), "y"=y)
  plot_df = na.omit(plot_df)
  
  p = ggpubr::ggboxplot(plot_df, x="x", y="y", 
                        color=ifelse(colors, "x", "black"), palette=ggthemes::calc_pal()(12),
                        add=ifelse(jitter, "jitter", FALSE),
                        xlab = x_label, ylab=y_label, title = plot_title)
  
  if(show_pvalue==T) {
    x_comparisions = combn(unique(as.character(plot_df$x)), 2, simplify=F)
    p = p + ggpubr::stat_compare_means(comparisons = x_comparisions, method = "wilcox.test", hide.ns = F, label = "p.signif") ### pairwise
    p = p + ggpubr::stat_compare_means(label.y = -Inf, label.x=Inf, vjust=-1, hjust=1) ### global
  }
  
  p = p + theme(legend.position = "none")
  return(p)  
}



