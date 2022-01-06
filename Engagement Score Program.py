#import tensorflow as tf
import pandas as pd 
#import rpy2 as rp
#import numpy as np

#import raw data using pandas

Rounds = pd.read_csv (r'/Users/joshbannister/Desktop/Data Project/Rounds.csv'  )
Rounds.columns
#pd.set_option('precision', 0)
#Rounds = Rounds.groupby(['Member Number']).count()

#print(Rounds)

##Data type is float. Need to remove .0 after member numbers
#summarize data into amount spent and # of transactions using pandas

#each layer is the engagement score or activity from the specific area measured. 
#we know that activity declines prior to resignation but what we want to find out 
#is at what point should we intervene? How long do we have from the point that 
#normal behavior starts to decline prior to resignation? 
