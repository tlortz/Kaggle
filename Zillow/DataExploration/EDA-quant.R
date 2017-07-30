# explore the correlation structure between the quantitative variables
good_props_numeric <- na.omit(select(raw_properties_full,one_of(good_num_features$feature)))
heatmap(as.matrix(good_props_numeric))

# do factor analysis on the categorical variables
