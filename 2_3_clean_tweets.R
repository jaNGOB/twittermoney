# Programming Project #14
# Ivana Pallister, Ricardo Cosenza, Alec Bernasconi, Jan Gobeli
# 26.12.2020
# 
# Clean tweets by omitting those who dont actually mention the "cashtag" of the company.
#
library(stringr)
library(dplyr)

# import all tickers that are to be cleaned. 
all_tickers <- read.csv('Data/tickers.csv')

# loop through all tickers and look if there are any tweets saved that do not mention the "cashtag".
# if so, drop them from the df and save the cleaned one.
for (n in 1:length(row.names(all_tickers))){
  name <- all_tickers[n,]
  print(name)
  cname <- paste('$', name, sep='')
  file_name <- paste("Data/",name,"_tweets_full.csv", sep = "")
  temp_df <- read.csv(file_name, header = TRUE)
  temp_df <- temp_df %>% mutate(tag = ifelse(str_detect(temp_df$tweet, fixed(cname,  ignore_case=TRUE)), TRUE, FALSE))
  temp_df <- temp_df[temp_df$tag == TRUE,]
  
  write.csv(as.data.frame(temp_df),file=file_name,row.names=F)
  
}
