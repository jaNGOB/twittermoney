# twittermoney - 10/10
Analyzing Tweets and the cross section of stock returns

- download first half of twitter data https://we.tl/t-RQum7553ep

(a) Register with twitter and obtain an account.

(b) Read the article Analyzing Twitter with R at https://towardsdatascience.com/setting-up-twitter-for-text-mining-in-r-bcfc5ba910f4 and run the code. (You need to add your own Twitter credentials and obtain an API key.) 

(c) Obtain the current weights of the S&P 500 index.*

(d) Download the tweets about the companies in the index using their \cashtag" (i.e. $AAPL for Apple Computer).

(e) Produce a daily time series of the number of tweets about each company.

(f) Produce a time series of all tweets. Can you and some cyclicality?

(g) Compare the \market share" of tweets to the index weight. Which companies are over-"and undertweeted"? Form equally weighted portfolios of over- and undertweeted compa-
nies. What is their subsequent performance?

(h)* So far, we counted all tweets, regardless of their content (bullish vs. bearish). Find a(simple) way to incorporate content in the form of \bullish" and \bearish" tweets. (It is OK if a substantial number of tweets are neither bullish nor bearish). Form equally weighted portfolios and compare the subsequent returns.

*Note: As this exercise can be computational quite challenging, you may limit the analysis to the largest companies that make up 80 to 90% of the S&P 500 index.
