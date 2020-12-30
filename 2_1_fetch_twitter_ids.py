"""
Università della Svizzera italiana
Programming Project #14
Ivana Pallister, Ricardo Cosenza, Alec Bernasconi, Jan Gobeli
December 2020
 
Fetch twitter ids and save them as a txt file for further use. 
"""
import snscrape.modules.twitter as sntwitter
import pandas as pd
from tqdm import tqdm
import csv

tickers = pd.read_csv('Data/tickers.csv').columns

# Loop through all tickers and save the tweet ids of every tweet that was made under this "cashtag".
for tag in tqdm(tickers):
    save = 'Data/{}_tweets.txt'.format(tag[1:])
    with open(save, 'w') as fd:
        for i,tweet in enumerate(sntwitter.TwitterSearchScraper(tag + ' since:' +  '2020-01-01' + ' until:' + '2020-12-01').get_items()):
            fd.write(str(tweet) + '\n')
