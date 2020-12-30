# Programming Project #14
# Ivana Pallister, Ricardo Cosenza, Alec Bernasconi, Jan Gobeli
# 26.12.2020
# 
# Clean tweets by omitting those who dont actually mention the "cashtag" of the company.
#
library(stringr)


# import all tickers that are to be cleaned. 
all_tickers <- read.csv('C:/Users/jango/code/research_env/USI/tickers_final.csv')


# loop through all tickers and look if there are any tweets saved that do not mention the "cashtag".
# if so, drop them from the df and save the cleaned one.
for (n in 1:length(all_tickers)){
  name <- substring(colnames(all_tickers[n]), 3)
  #name <- all_tickers[n]
  print(name)
  cname <- paste('$', name, sep='')
  import_file <- paste("C:/Users/jango/code/research_env/USI/tweets/Actual_Tweets/Tweets/",name,"_tweets_full.csv", sep = "")
  export_file <- paste("C:/Users/jango/code/research_env/USI/tweets/Actual_Tweets/",name,"_tweets_full.csv", sep = "")
  temp_df <- read.csv(import_file, header = TRUE)
  temp_df <- temp_df %>% mutate(tag = ifelse(str_detect(temp_df$tweet, fixed(cname,  ignore_case=TRUE)), TRUE, FALSE))
  temp_df <- temp_df[temp_df$tag == TRUE,]
  
  write.csv(as.data.frame(temp_df),file=export_file,row.names=F)
  
}
  
  
