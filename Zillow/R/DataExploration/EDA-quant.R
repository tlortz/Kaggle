# explore the correlation structure between the quantitative variables
library(corrplot)

good_props_numeric_scored <- transactions_full[,c("parcelid","logerror")] %>% left_join(good_props_numeric, by="parcelid") %>%
  select(-parcelid)
heatmap(as.matrix(good_props_numeric_scored))
# corrplot
corrplot.mixed(cor(na.omit(good_props_numeric_scored)))
# pairs
pairs(na.omit(good_props_numeric_scored)) #super slow - need to remove some variables
# do factor analysis on the categorical variables

#pca on numeric vars
tmp <- na.omit(select(populated_properties,one_of(good_num_features$feature),contains("tax"))) %>%
  summarise_all(max)
pca_numeric <- princomp(na.omit(select(populated_properties,one_of(good_num_features$feature))))
rm(tmp)

# explore the distribution of average logerror by regionidzip and censustractandblock
tmp <- populated_properties %>%
  inner_join(transactions_full) %>%
  select(logerror,regionidzip) %>%
  group_by(regionidzip) %>%
  summarise_all(mean) %>%
  ggplot(aes(logerror)) + geom_histogram(fill="navy")