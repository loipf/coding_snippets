############################################
### plot circular overlap between datasets

setwd(dirname(rstudioapi::getSourceEditorContext()$path))   ### only in RStudio

# source("https://raw.githubusercontent.com/loipf/coding_snippets/master/R/small_functions.R")

# install.packages('pacman')
pacman::p_load(data.table, circlize, dplyr, grid)

#https://stackoverflow.com/questions/42917349/r-circlize-circos-plot-how-to-plot-unconnected-areas-between-sectors-with-min

RBO_CUTOFF = 0.5


############################################
### read in correlations

corr_df = fread("../../data/comparing_tc/dataset_IC_rbo_only_immune.tsv")
#corr_df$V1 = NULL

# > corr_df
# dataset_a                                 IC_a dataset_b                               IC_b     rbo_value
# 1:    rnaseq consensus independent component 1063      mrna  consensus independent component 1 1.377667e-03
# 2:    rnaseq  consensus independent component 108      mrna  consensus independent component 1 8.278861e-02
# 3:    rnaseq consensus independent component 1096      mrna  consensus independent component 1 3.266619e-07
# 4:      mrna  consensus independent component 924      tcga consensus independent component 99 3.461725e-03
# 5:      mrna  consensus independent component 978      tcga consensus independent component 99 1.304786e-04

colnames(corr_df) = c('dataset_a','IC_a','dataset_b','IC_b','rbo_value')   ### make same colnames
# corr_df$IC_a = paste0('tc_',corr_df$IC_a )
# corr_df$IC_b = paste0('tc_',corr_df$IC_b)

corr_df_sub = subset(corr_df, abs(rbo_value) > RBO_CUTOFF)


# hist(corr_df_sub$rbo_value, breaks=200)
# hist(corr_df_sub$rbo_value, breaks=200, ylim=c(0,1000))
# abline(v = 0.1)


############################################
### specify parameters

### number of components per dataset
xlim_help_df = rbind(corr_df_sub[,c('dataset_a','IC_a')], corr_df_sub[,c('dataset_b','IC_b')], use.names=F)

### order in plot
plot_names_order = unique(xlim_help_df$dataset_a)
# plot_names_order = c("mrna","rnaseq","tcga")  ### hardcoded order

### number of entries per dataset - specify if other values
xlim_help = table(xlim_help_df$dataset_a)
# > xlim_help
# mrna rnaseq   tcga 
# 98     93     79 

xlim_help = xlim_help[match(names(xlim_help), plot_names_order)]
xlim_matrix = cbind(matrix(0, nrow=length(plot_names_order), ncol = 1), xlim_help)  ### xlim: from -> to


### specify color function - adjust cutoffs and colors if necessary
col_fun = colorRamp2(c(RBO_CUTOFF, 1), c("#e6e6e6", "#E60000"), transparency = 0.3) ## grey-red


### get smart IC order 
corr_df_sub_plot = corr_df_sub[order(corr_df_sub$rbo_value, decreasing = T)]
corr_df_sub_plot$level_help_column = paste0(corr_df_sub_plot$dataset_a,"_",corr_df_sub_plot$IC_a,"::",corr_df_sub_plot$dataset_b,"_",corr_df_sub_plot$IC_b) 
levels_name_list = sapply(plot_names_order, function(met) {
  unique(unlist(sapply(strsplit(corr_df_sub_plot$level_help_column, "::"), function(split_str) { gsub(paste0(met,"_"),"", split_str[grep(met, split_str)]) })))
}, simplify = F, USE.NAMES = T)
corr_df_sub_plot$level_help_column = NULL



############################################
### plot circular 

pdf(paste0("fig_circular_over", gsub("\\.","",RBO_CUTOFF), ".pdf"), width=12, height=4)

layout(matrix(1:3, 1, 3))   ### specify grid

for(met in plot_names_order) {
  # met = "mrna"
  # met = "rnaseq"
  
  ### renaming and sorting operations
  links_part1 = subset(corr_df_sub_plot, dataset_a==met)
  links_part2 = subset(corr_df_sub_plot, dataset_b==met)
  colnames(links_part2)[1:4] = c("dataset_b","IC_b","dataset_a","IC_a")[1:4]
  links = rbind(links_part1, links_part2)
  
  links = links[order(links$IC_a),]
  links$IC_a = as.numeric(factor(links$IC_a, levels=levels_name_list[[met]]))
  links[links$dataset_b =="rnaseq"]$IC_b = as.numeric(factor(links[links$dataset_b =="rnaseq"]$IC_b, levels=levels_name_list$rnaseq))
  links[links$dataset_b =="mrna"]$IC_b = as.numeric(factor(links[links$dataset_b =="mrna"]$IC_b, levels=levels_name_list$mrna))
  links[links$dataset_b =="tcga"]$IC_b = as.numeric(factor(links[links$dataset_b =="tcga"]$IC_b, levels=levels_name_list$tcga))
  
  ### order smart
  # links = links[order(links$rbo_value, decreasing=T),]
  # links$IC_a = as.numeric(factor(links$IC_a, levels = unique(links$IC_a)))
  # links[links$dataset_b == unique(links$dataset_b)[1],]$IC_b = as.numeric(factor(links[links$dataset_b == unique(links$dataset_b)[1],]$IC_b, levels = unique(links[links$dataset_b == unique(links$dataset_b)[1],]$IC_b)))
  # links[links$dataset_b == unique(links$dataset_b)[2],]$IC_b = as.numeric(factor(links[links$dataset_b == unique(links$dataset_b)[2],]$IC_b, levels = unique(links[links$dataset_b == unique(links$dataset_b)[2],]$IC_b)))
  ## links$IC_b = as.numeric(factor(links$IC_b, levels = unique(links$IC_b)))
  links = links[order(links$rbo_value, decreasing=F),]
  
  ### init circos
  # circos.clear()
  circos.par(gap.after=20, canvas.ylim=c(-1.2,1.2), canvas.xlim=c(-1.2,1.2) ) #, start.degree=30 )
  circos.initialize(plot_names_order, xlim = xlim_matrix)
  circos.trackPlotRegion(ylim = c(0, 1), track.height = 0.05, bg.col = "#CCCCCC", bg.border = NA)
  
  # add links
  for(row in 1:nrow(links)) {
    link <- links[row, ]
    circos.link(link$dataset_a, as.numeric(link$IC_a), link$dataset_b, as.numeric(link$IC_b), col = col_fun(link$rbo_value), border = NA, lwd=2)
    # circos.link(link$dataset_a, as.numeric(link$IC_a), link$dataset_b, as.numeric(link$IC_b), col = '#00000025', border = NA, lwd=2)
  }
  
  ### add labels
  for(s in plot_names_order) {

    selected_ic_text = ifelse(s==met, paste0("(",length(unique(links$IC_a)),"/",xlim_help[s],")"),
                              paste0("(",length(unique(subset(links, dataset_b==s)$IC_b)),"/",xlim_help[s],")") )
    percentage_text = paste0(round(eval(parse(text=substr(selected_ic_text,2,nchar(selected_ic_text)-1))) * 100),"%")

    highlight.sector(
      sector.index = s, track.index = 1, col = ifelse(s==met, "#808080", "#CCCCCC"),  ### grey dark, grey light
      text = paste0(s,"\n",percentage_text, "  ", selected_ic_text),
      font = ifelse(s==met, 2, 1),
      niceFacing = TRUE, text.vjust = -0.5)
      # facing="downward", niceFacing = TRUE, text.hjust = -0.5)
      #, niceFacing = TRUE)
  }
  circos.clear()
  
}

dev.off()



############################################
### create legends

require(ComplexHeatmap)

# ### TODO add legend
lgd_rbo = ComplexHeatmap::Legend(at = c(0.2,0.4,0.6,0.8,1), col_fun = col_fun,
                   title_position = "topleft", title = "RBO ",direction = "horizontal")
pd = packLegend(lgd_rbo, direction = "vertical")

pdf(file = "legend_circular.pdf", width = 4, height=2)
draw(pd)
dev.off()



