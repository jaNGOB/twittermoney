library(tidyquant)
library(dplyr)
library(data.table)

all_tickers <- read.csv('C:/Users/jango/code/research_env/USI/tickers_final.csv')

tweets_AMZN <- read.csv('C:/Users/jango/code/research_env/USI/tweets/Actual_Tweets/Tweets/AMZN_tweets_full.csv', header = TRUE) 

all_tickers <- c('ABT', 'ADBE', 'ADI', 'AEP')

tweets_ABMD <- read.csv('C:/Users/jango/code/research_env/USI/tweets/Actual_Tweets/ABMD_tweets_full.csv', header = TRUE)

tweets_AMZN$date <- (as.Date(tweets_AMZN$date,format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone()))

dates <- na.omit(tweets_AMZN %>% count(date))

df <- xts(as.numeric(dates$n), order.by = as.Date(dates$date))
colnames(df) <- 'AMZN'

all_tickers <- colnames(all_tickers[2:length(all_tickers)])

for (n in 1:length(all_tickers)){
  print(substring(all_tickers[n], 3))
}

for (n in 1:length(all_tickers)){
  name <- substring(all_tickers[n], 3)
  #name <- all_tickers[n]
  print(name)
  import_file <- paste("C:/Users/jango/code/research_env/USI/tweets/Actual_Tweets/Tweets/",name,"_tweets_full.csv", sep = "")
  temp_df <- read.csv(import_file, header = TRUE)
  temp_df$date <- (as.Date(temp_df$date,format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone()))
  temp_date <- na.omit(temp_df %>% count(date))
  
  temp_xts <- xts(as.numeric(temp_date$n), order.by = as.Date(temp_date$date))
  colnames(temp_xts) <- name
  
  df <- cbind(df, temp_xts[,1])
  
}

df[is.na(df)] <- 0

quarterly <- aggregate(df, as.yearqtr, mean)

sum_ <- rowSums(quarterly)

weights <- round(quarterly/rowSums(quarterly), 4)


getSymbols("ABMD", from = '2020-01-01', to = "2020-12-01",warnings = FALSE, auto.assign = TRUE)

tweets_ABMD <- read.csv('C:/Users/jango/code/research_env/USI/tweets/Actual_Tweets/ABMD_tweets_full.csv', header = TRUE) 

tweets$date <- (as.Date(tweets$date,format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone()))

dates <- tweets_AMZN %>% count(date)

ABMD <- rownames_to_column(as.data.frame(ABMD), "date")
ABMD$date <- as.Date(ABMD$date)

temp <- data.frame(ABMD$date, ABMD$ABMD.Adjusted)
colnames(temp) <- c('date', 'ABMD')

df <- merge(x = dates, y = temp, by = 'date', all.x = TRUE)

df <- drop_na(df)
# Plot
plot(x = df$date, y = df$ABMD, col='red', type='l', ylim=c(0, 350))
lines(x = df$date, y = df$n)



getSymbols("AMZN", from = '2020-01-01', to = "2020-12-01",warnings = FALSE, auto.assign = TRUE)
tweets_AMZN <- read.csv('C:/Users/jango/code/research_env/USI/tweets/Actual_Tweets/AMZN_tweets_full.csv', header = TRUE)
tweets_AMZN$date <- (as.Date(tweets_AMZN$date,format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone()))
dates <- tweets_AMZN %>% count(date)

AMZN <- rownames_to_column(as.data.frame(AMZN), "date")
AMZN$date <- as.Date(AMZN$date)

temp <- data.frame(AMZN$date, AMZN$AMZN.Adjusted)
colnames(temp) <- c('date', 'AMZN')

df <- merge(x = dates, y = temp, by = 'date', all.x = TRUE)

# Plot
plot(x = df$date, y = df$AMZN, col='red', type='l', ylim=c(0, 3500))
lines(x = df$date, y = df$n)
