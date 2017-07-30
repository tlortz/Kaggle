fun_value_counts <- function (vec) {
  # meant to be applied column-wise to property characteristics
  # get the count of occurrences by each value (value_counts equivalent)
  values <- unique(vec)
  results <- data.frame(values=values)
  results$occurrences <- sapply(results$values,function(x){length(subset(vec,vec==x))})
  results <- results[order(results$occurrences,decreasing = TRUE),]
  return(results)
}

fun_na_prop_df <- function(df) {
  # a function to compute the proportion and count of rows from a dataframe 
  # in which there are no NAs
  tot_rows <- nrow(df)
  clean_rows <- nrow(na.omit(df))
  good_prop <- clean_rows/tot_rows
  # return(list(clean_row_count = clean_rows,clean_row_proportion = good_prop))
  return(good_prop)
}

fun_na_prop_vec <- function(vec) {
  # a function to compute the proportion and count of rows from a dataframe 
  # in which there are no NAs
  tot_rows <- length(vec)
  clean_rows <- length(na.omit(vec))
  good_prop <- clean_rows/tot_rows
  # return(list(clean_row_count = clean_rows,clean_row_proportion = good_prop))
  return(good_prop)
}

data_proportions <- data.frame(apply(as.matrix(raw_properties_full),2,function(x){fun_na_prop_vec(x)})) %>%
  rownames_to_column(var = "feature") %>%
  rename(feature=feature,data_proportion)
#y <- lapply(data_proportions,function(x){x[[2]][1]})
populated_value_threshold <- .75
populated_cols <- data_proportions %>% 
  filter(data_proportion >= populated_value_threshold) %>%
  select(feature)
populated_cols <- as.vector(populated_cols$feature)
populated_properties <- raw_properties_full[,populated_cols]
col_types <- data.frame(apply(as.matrix(raw_properties_full),2,typeof))
col_types <- rownames_to_column(col_types,var = "feature")
col_types <- raw_properties_full %>% summarise_all(typeof) %>% gather(feature,dtype)
char_cols <- col_types %>% filter(dtype=="character") %>% select(feature) %>% as.list()
factor_level_counts <- raw_properties_full %>% #select(one_of(as.vector(char_cols$feature))) %>%
  summarise_all(n_distinct) %>%
  gather(feature,factor_levels)
feature_summaries <- inner_join(col_types,data_proportions) %>% 
  left_join(factor_level_counts)

# get usable feature / observation subsets for quantitative analysis
good_num_features <- filter(feature_summaries,dtype=="integer" || dtype=="double",dtype != "character",data_proportions >= populated_value_threshold) %>%
  select(feature)