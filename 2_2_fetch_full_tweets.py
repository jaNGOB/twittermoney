"""
Università della Svizzera italiana
Programming Project #14
Ivana Pallister, Ricardo Cosenza, Alec Bernasconi, Jan Gobeli
December 2020
 
This code reads a list of twitter id's and saves the whole tweet along 
further information through the official twitter API. 
"""
import pandas as pd
from tqdm import tqdm
import tweepy

def fetch_tw(ids, name, first):
    """
    Fetch tweet information and save it to a csv. 

    :input ids:     list of tweet ids.
    :input name:    name of the csv-file to save it to as string. 
    :input first:   Boolean if its the first loop to fetch the tweets. If yes, initiate column values.

    :output:        Save tweet information in csv. 
    """
    list_of_tw_status = api.statuses_lookup(ids, tweet_mode= "extended")
    empty_data = pd.DataFrame()
    for status in list_of_tw_status:
        tweet_elem = {"tweet_id": int(status.id),
                    "screen_name": status.user.screen_name,
                    "verified": int(status.user.verified),
                    "followers": int(status.user.followers_count),
                    "following": int(status.user.friends_count),
                    "retweet": int(status.retweeted),
                    "amount_retweet": int(status.retweet_count),
                    "amount_favorite": int(status.favorite_count),
                    "tweet":str(status.full_text.replace('\r', '')),
                    "date":status.created_at}
        empty_data = empty_data.append(tweet_elem, ignore_index = True)

    if first:
        empty_data.to_csv(name, mode="a")
    else:
        empty_data.to_csv(name, mode="a", header=False)

# Obtain the Key, Token, and Secrets from the Twitter Dev. page and insert them here.
consumer_key = "CONSUMER_KEY_HERE"
consumer_secret = "CONSUMER_SECRET_HERE"
access_token = "ACCESS_TOKEN_HERE"
access_token_secret = "ACCESS_TOKEN_SECRET_HERE"

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
api = tweepy.API(auth,wait_on_rate_limit=True)

tickers = pd.read_csv('Data/tickers.csv')

# Create a new list without the "Cashtags" off twitter
cashtags = []
for ticker in tickers:
    if ticker[0] == '$':
        cashtags.append(ticker[1:])

# Loop through all cash tags, read the tweet-ids and save the information in batches to avoid
# getting rate limited.
for tag in tqdm(cashtags):
    name = "Data/{}_tweets_full.csv".format(tag)
    read_name = "Data/{}_tweets.txt".format(tag)

    tweet_url = pd.read_csv(read_name, index_col= None, header = None, names = ["links"])

    af = lambda x: x["links"].split("/")[-1]
    tweet_url['id'] = tweet_url.apply(af, axis=1)
    ids = tweet_url['id'].tolist()

    total_count = len(ids)
    chunks = (total_count - 1) // 50 + 1
    first = True

    for i in range(chunks):
        batch = ids[i*50:(i+1)*50]
        fetch_tw(batch, name, first)
        first = False
