# Programming Project #14
# Ivana Pallister, Ricardo Cosenza, Alec Bernasconi, Jan Gobeli
# 26.12.2020
# 
# Clean tweets by omitting those who dont actually mention the "cashtag" of the company.
#
library(stringr)


all_tickers <- read.csv('C:/Users/jango/code/research_env/USI/tickers_final.csv')


name <- "ABMD"
import_file <- paste("C:/Users/jango/code/research_env/USI/tweets/Actual_Tweets/Tweets/",name,"_tweets_full.csv", sep = "")
temp <- read.csv(import_file, header = TRUE)
temp <- temp %>% mutate(tag = ifelse(str_detect(temp$tweet, fixed("$ABMD",  ignore_case=TRUE)), TRUE, FALSE))
temp <- temp[temp$tag == TRUE,]
write.csv(as.data.frame(temp),file=import_file,row.names=F)

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
  
  