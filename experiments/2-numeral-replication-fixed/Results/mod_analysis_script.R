library(ggplot2)
library(lme4)
library(hydroGOF)
library(tidyr)
library(dplyr)

#setwd("~/Desktop/adjs!/kids-adjectives/experiments/1-kids-subjectivity/Submiterator-master")
#setwd("~/git/kids-adjectives/experiments/1-kids-subjectivity/Submiterator-master/")


num_round_dirs = 4
df = do.call(rbind, lapply(1:num_round_dirs, function(i) {
  return (read.csv(paste(
    'round', i, '/scopeTVJT-fixed.csv', sep='')) %>% #'round1/kids-subjectivity.csv')) %>% #for just 1
      mutate(workerid = (workerid + (i-1)*9)))}))

d = subset(df, select=c("workerid","number","item","slide_number","context","response", "justification", "language"))
unique(d$language)

length(unique(d$workerid)) 
head(d)

## remove non-English speakers 
d = d[d$language!="Russian"&d$language!="",]
length(unique(d$workerid)) 

##Principled removal of participants
controltrials = subset(d, item %in% c('control1','control2','control3'))
contr1trial = subset(controltrials, item %in% c('control1'))
contr2trial = subset(controltrials, item %in% c('control2'))
contr3trial = subset(controltrials, item %in% c('control3'))
#descriptive stats to remove participants
qplot(contr1trial$response, geom="histogram")
qplot(contr2trial$response, geom="histogram")
qplot(contr3trial$response, geom="histogram")
contMean1 = mean(contr1trial$response)
contsd1 = sd(contr1trial$response)*2
contMean2 = mean(contr2trial$response)
contsd2 = sd(contr2trial$response)*2
contMean3 = mean(contr3trial$response)
contsd3 = sd(contr3trial$response)*2

## remove participants who failed control trials
to_omit1 = subset(contr1trial, contr1trial$response > (contMean1 + contsd1))
d = subset(d, !workerid %in% c(unique(to_omit1$workerid)))
to_omit2 = subset(contr2trial, contr2trial$response < (contMean2 - contsd2))
d = subset(d, !workerid %in% c(unique(to_omit2$workerid)))
to_omit3 = subset(contr3trial, contr3trial$response > (contMean3 + contsd3))
d = subset(d, !workerid %in% c(unique(to_omit3$workerid)))
length(unique(d$workerid))

## determine number of observations from each condition (less from cond2)
relevant_data = subset(d, item %in% c('frog','butterflies','lions','dinosaurs'))
table(relevant_data$context, relevant_data$number)

## Make histograms for each condition, and get data on control trials for removal
twowith_data = subset(relevant_data, number == "two" & context == "with")
twowithout_data = subset(relevant_data, number == "two" & context == "without")
fourwith_data = subset(relevant_data, number == "four" & context == "with")
fourwithout_data = subset(relevant_data, number == "four" & context == "without")

# ##checking to see if animal type matters for cond4 (it maybe does!)
# cond4_animals = aggregate(response~trial_num,mean, data=cond4_data)
# ggplot(cond4_data, aes(cond4_data$response)) + 
#   geom_histogram(color="black", binwidth = .033333) +
#   facet_grid(. ~ trial_num)

# ##looking at justifications for cond4 (2 did, 2 didn't (4 entities))
# cond4_resp_justification = cbind(cond4_data$response, cond4_data$justification)
# cond4_resp_just = data_frame(cond4_data$response, cond4_data$justification)
# View(cond4_resp_just)

# cont1 = subset(d, trial_num %in% c('4'))
# cont2 = subset(d, trial_num %in% c('6'))
# cont3 = subset(d, trial_num %in% c('8'))


##Histograms of the 4 conditions
#cond1 - two frogs
qplot(twowith_data$response, geom="histogram")
#cond2 - two frogs w/ contrast
qplot(twowithout_data$response, geom="histogram")
#cond3 - four frogs
qplot(fourwith_data$response, geom="histogram")
#cond4 - four frogs w/ contrast
qplot(fourwithout_data$response, geom="histogram")


## calculate average response by condition
agg_resp = matrix(0,4,1);
agg_resp[1,1] = mean(twowithout_data$response)
agg_resp[2,1] = mean(twowith_data$response)
agg_resp[3,1] = mean(fourwithout_data$response)
agg_resp[4,1] = mean(fourwith_data$response)

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

