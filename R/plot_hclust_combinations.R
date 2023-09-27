
############################################
### plot all clustering combinations

library(ComplexHeatmap)
library(circlize)

### specify arguments
plot_df = plot_df_list_log10$mrna

col_fun = colorRamp2(c(-10,log10(0.05), 0, -log10(0.05),10), c("#00006b", "#e8ebf7", "#F0F0F0", "#ffe2e2","#a70000"))
func_args <- list(plot_df, cluster_columns=F, col=col_fun)

### plot all cluster possibilities
avail_dist = c("euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski", "pearson", "spearman", "kendall")
avail_hclust = c("ward.D", "ward.D2", "single", "complete", "average", "mcquitty", "median", "centroid")

pdf("heatmap_clustering_comparison.pdf", width = 12, height = 8)
rlang::exec(Heatmap, !!!append(func_args, list(row_order=order(rowSums(plot_df**2), decreasing = T), column_title = 'sum_**2_sorting')))
rlang::exec(Heatmap, !!!append(func_args, list(row_order=order(rowSums(abs(plot_df)), decreasing = T), column_title = 'sum_abs_sorting')))

for(curr_dist in avail_dist) {
  for(curr_hclust in avail_hclust) {
    print(paste0('### plot: ', curr_hclust,'_',curr_dist))
    print(rlang::exec(Heatmap, !!!append(func_args, list(clustering_distance_rows = curr_dist, clustering_method_rows = curr_hclust, column_title = paste0(curr_hclust,'_',curr_dist)))))
  }
}
dev.off()
