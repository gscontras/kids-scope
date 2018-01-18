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
d = d[d$language!="Cantonese"&d$language!="Chinese"&d$language!="",]
length(unique(d$workerid)) 

## remove participants who failed control trials
control_matrix = subset(d, trial_num %in% c('4','6','8'))
to_omit = subset(control_matrix, control_matrix$response > .1)
d = subset(d, !workerid %in% c(unique(to_omit$workerid)))
length(unique(d$workerid)) 



## determine number of observations from each condition (less from cond2)
relevant_data = subset(d, trial_num %in% c('3','5','7','9'))
table(relevant_data$condition)

## calculate average response by condition
agg_resp = aggregate(response~condition,mean,
                       data=subset(d, trial_num %in% c('3','5','7','9') ))

##for running the ANOVA
new_thing = aggregate(relevant_data$response,
                      by = list(relevant_data$workerid, relevant_data$condition),
                      FUN = 'mean')

colnames(new_thing) = c("WorkerID","Condition","AverageResponse")
new_thing = new_thing[order(new_thing$WorkerID),]
head(new_thing)

new_thing.aov = with(new_thing, 
                     aov(AverageResponse ~ Condition + Error(WorkerID/Condition)))

summary(new_thing.aov)

##If the website I got this from is correct, we have super significance!




## average score on control trials (most people correctly rejected)
agg_controls = aggregate(response~condition,mean,
                     data=subset(d, trial_num %in% c('4','6','8') ))

###Checking for duplicate Ids - there are none
ids = read.csv('WorkerIDs.csv')
length(unique(ids$Actual.ID))
n_occur <- data.frame(table(ids$Actual.ID))


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

