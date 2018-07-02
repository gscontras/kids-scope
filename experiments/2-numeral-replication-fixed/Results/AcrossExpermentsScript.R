###Checking across experiments
##This works (greg showed me the syntax)
newLM = lmer(relevant_datat$response ~ relevant_datat$number * 
               relevant_datat$context + (1+number+context|workerid)+(1+number+context|item),data=relevant_datat)
summary(newLM)
subsetLM = lmer(response ~ 
                  context + (1|workerid) + (1|item),data=relevant_datat[relevant_datat$number=="four",])
summary(subsetLM)
anova(newLM)

###new thing
write.csv(relevant_data, 'videos_data.csv')
write.csv(relevant_datat, 'text_data.csv')

