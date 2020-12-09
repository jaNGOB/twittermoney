library(tidyquant)
library(dplyr)
library(data.table)

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
