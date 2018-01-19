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

d = subset(df, select=c("workerid","trial_num","response","condition", "justification", "language"))
unique(d$language)

length(unique(d$workerid)) 
head(d)

## remove non-English speakers 
d = d[d$language!="Cantonese"&d$language!="Chinese"&d$language!="",]
length(unique(d$workerid)) 

##Principled removal of participants
controltrials = subset(d, trial_num %in% c('4','6','8'))
#descriptive stats to remove participants
qplot(controltrials$response, geom="histogram")
contMean = mean(controltrials$response)
elimCont = sd(controltrials$response)*2


## remove participants who failed control trials
control_matrix = subset(d, trial_num %in% c('4','6','8'))
to_omit = subset(control_matrix, control_matrix$response > (contMean + elimCont))
d = subset(d, !workerid %in% c(unique(to_omit$workerid)))
length(unique(d$workerid))

## determine number of observations from each condition (less from cond2)
relevant_data = subset(d, trial_num %in% c('3','5','7','9'))
table(relevant_data$condition)

## Make histograms for each condition, and get data on control trials for removal
cond1_data = subset(relevant_data, condition %in% c('cond1'))
cond2_data = subset(relevant_data, condition %in% c('cond2'))
cond3_data = subset(relevant_data, condition %in% c('cond3'))
cond4_data = subset(relevant_data, condition %in% c('cond4'))

##checking to see if animal type matters for cond4 (it maybe does!)
cond4_animals = aggregate(response~trial_num,mean, data=cond4_data)
ggplot(cond4_data, aes(cond4_data$response)) + 
  geom_histogram(color="black", binwidth = .033333) +
  facet_grid(. ~ trial_num)

##looking at justifications for cond4 (2 did, 2 didn't (4 entities))
cond4_resp_justification = cbind(cond4_data$response, cond4_data$justification)
cond4_resp_just = data_frame(cond4_data$response, cond4_data$justification)
View(cond4_resp_just)

# cont1 = subset(d, trial_num %in% c('4'))
# cont2 = subset(d, trial_num %in% c('6'))
# cont3 = subset(d, trial_num %in% c('8'))


##Histograms of the 4 conditions
#cond1 - two frogs
qplot(cond1_data$response, geom="histogram")
#cond2 - two frogs w/ contrast
qplot(cond2_data$response, geom="histogram")
#cond3 - four frogs
qplot(cond3_data$response, geom="histogram")
#cond4 - four frogs w/ contrast
qplot(cond4_data$response, geom="histogram")


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

