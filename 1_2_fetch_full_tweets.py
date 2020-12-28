import pandas as pd
from tqdm import tqdm
import tweepy

def fetch_tw(ids, name, first):
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


consumer_key = "RxEdqHZMSd6LYzhxADq9CQINU"
consumer_secret = "xQaRGBeBWEr51P6ik9Hf8R7GYY1z5BWoUJAfrcxptQRSltJz8h"
access_token = "1722107810-OuMtkX9MRFg0lUU5pOUxqeaoONuJXAdQXdnig5L"
access_token_secret = "9Afe1KSumpG1d5ngAwox6WArvk5jU1p0d4yvHGNe77q5D"

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
api = tweepy.API(auth,wait_on_rate_limit=True)

tickers = pd.read_csv('tickers_final.csv').columns[100:150]

cashtags = []
for ticker in tickers:
    if ticker[0] == '$':
        cashtags.append(ticker[1:])

for tag in tqdm(cashtags):
    name = "{}_tweets_full.csv".format(tag)
    read_name = "{}_tweets.txt".format(tag)

    tweet_url = pd.read_csv(read_name, index_col= None, header = None, names = ["links"])

    af = lambda x: x["links"].split("/")[-1]
    tweet_url['id'] = tweet_url.apply(af, axis=1)
    ids = tweet_url['id'].tolist()

    total_count = len(ids)
    chunks = (total_count - 1) // 50 + 1
    first = True

    for i in range(chunks):
        batch = ids[i*50:(i+1)*50]
        result = fetch_tw(batch, name, first)
        first = False
