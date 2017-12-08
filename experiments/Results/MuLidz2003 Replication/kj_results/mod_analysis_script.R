library(ggplot2)
library(lme4)
library(hydroGOF)
library(tidyr)
library(dplyr)

#setwd("~/Desktop/adjs!/kids-adjectives/experiments/1-kids-subjectivity/Submiterator-master")
#setwd("~/git/kids-adjectives/experiments/1-kids-subjectivity/Submiterator-master/")


num_round_dirs = 14
df = do.call(rbind, lapply(1:num_round_dirs, function(i) {
  return (read.csv(paste(
    'round', i, '/scopeTVJT.csv', sep='')) %>% #'round1/kids-subjectivity.csv')) %>% #for just 1
      mutate(workerid = (workerid + (i-1)*9)))}))

d = subset(df, select=c("workerid","trial_num","response","condition", "language"))
unique(d$language)

length(unique(d$workerid)) 
head(d)

## remove non-English speakers
d = d[d$language!="Russian"&d$language!="",]
length(unique(d$workerid)) 

## determine number of observations
table(d$condition)

## calculate average response by condition (hopefully)
agg_resp = aggregate(response~condition,mean,
                     data=subset(d, trial_num %in% c('3','5','7','9') ))

####Condition types
#cond1 = two
#cond2 = two contrast
#cond3 = four
#cond4 = four contrast
## calculate average subjectivity by class
## agg_class = aggregate(response~class,data=d,mean)

## write to CSV files
#write.csv(agg_adj,"../results/adjective-subjectivity.csv")
#write.csv(agg_class,"../results/class-subjectivity.csv")

