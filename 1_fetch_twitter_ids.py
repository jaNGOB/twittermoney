import snscrape.modules.twitter as sntwitter
import pandas as pd
from tqdm import tqdm
import csv

tickers = pd.read_csv('tickers_80.csv').columns

cashtags = []
for ticker in tickers:
    if ticker[0] == '@':
        cashtags.append('$'+ticker[1:])
    elif ticker[1] == ':':
        cashtags.append('$'+ticker[2:])
  

for tag in tqdm(cashtags):
    save = '{}_tweets.txt'.format(tag[1:])
    with open(save, 'w') as fd:
        for i,tweet in enumerate(sntwitter.TwitterSearchScraper(tag + ' since:' +  '2020-01-01' + ' until:' + '2020-12-01').get_items()):
            fd.write(str(tweet) + '\n')
