# twittermoney
A project of 4 Università della Svizzera italiana students to try and gain an advantage on the stock markets using twitter-data. 

## Mission statement
Analyzing Tweets and the cross section of stock returns

- download first half of twitter data https://we.tl/t-RQum7553ep

(a) Register with twitter and obtain an account.

(b) Read the article Analyzing Twitter with R at https://towardsdatascience.com/setting-up-twitter-for-text-mining-in-r-bcfc5ba910f4 and run the code. (You need to add your own Twitter credentials and obtain an API key.) 

(c) Obtain the current weights of the S&P 500 index.*

(d) Download the tweets about the companies in the index using their cashtag" (i.e. $AAPL for Apple Computer).

(e) Produce a daily time series of the number of tweets about each company.

(f) Produce a time series of all tweets. Can you and some cyclicality?

(g) Compare the "market share" of tweets to the index weight. Which companies are over-"and undertweeted"? Form equally weighted portfolios of over- and undertweeted companies. What is their subsequent performance?

(h)* So far, we counted all tweets, regardless of their content (bullish vs. bearish). Find a(simple) way to incorporate content in the form of "bullish" and "bearish" tweets. (It is OK if a substantial number of tweets are neither bullish nor bearish). Form equally weighted portfolios and compare the subsequent returns.

*Note: As this exercise can be computational quite challenging, you may limit the analysis to the largest companies that make up 80 to 90% of the S&P 500 index.

## Usage
1. The data is not included in this reposotory. While the stock data can be downloaded running the file "1_Companies_data.R", the list of tickers should not be updated if there is no intend to redownload all twitter data. During the time of the project alone, 5 new companies have been admitted to the S&P500 which will lead to new weights and unknown companies in the twitter files. Therefore, step 1 until 3 can also be skipped since the relevant .csv documents for the creation of the Indices are provided.

2. After the data is collected using the files "2_1_fetch_twitter_ids.py" and "2_2_fetch_full_tweets.py", it can be cleaned using the R file "2_3_clean_tweets.R".

3. Relevant dataframes are now created such as count_df using the file "3_1_creating_count_df.R", which creates a daily time-series of the number of times each company has been mentioned by their "Cashtag". This first step still requires twitter data which has to first be aquired using the two python documents. The creation of the twitter Index happens afterwards in file "3_2_Indices.R". 

4. The next step is about analysing the tweets themselves and getting a sentiment score to see if they are bullish or bearish. The package used to evaluate the sentiment is [sentimentr](https://github.com/trinker/sentimentr). After every tweet is judged by sentiment, an Index is created and compared to the S&P 500 in file "4_2_sentiment_indices.R".

5. This final uses the gathered data of the tweets to find potential indicators which could be used to understand Twitter sentiment. To be able to run "5_1_additional_indicators.R", Twitter data is required.

## Step one, data collection. 
To complete this project there is a need for a large dataset of tweets. We choose to analyze 80% of the firms in the S&P500 based on market capitalization. We referenced these companies based on their cashtags, e.g. $AAPL.
First, the amount of tweets that we could obtain officially from Twitter, as the API limited us to seven days of tweets. As seven days would not be diverse enough for a reliable data set we chose an alternative way to collect the data. The aim was to recover all the tweets for the designated companies for the past year, 2020. 

