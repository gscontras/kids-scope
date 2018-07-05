library(ggplot2)
library(lme4)
library(lmerTest)
library(hydroGOF)
library(tidyr)
library(dplyr)
library(Rmisc)

#setwd("~/Desktop/adjs!/kids-adjectives/experiments/1-kids-subjectivity/Submiterator-master")
#setwd("~/git/kids-scope/experiments/3-text-replication/Results/")

source("helpers.r")


dv = read.csv("videos_data.csv",header=T)
dv$modality = "video"
dv$u_worker = paste("v",dv$workerid)
dv$justification = NULL
dt = read.csv("text_data.csv",header=T)
dt$modality = "text"
dt$u_worker = paste("t",dt$workerid)

d = rbind(dv,dt)

d_s = bootsSummary(data=d, measurevar="response", groupvars=c("item","context","modality","number"))

big_plot <- ggplot(d_s, aes(x=context,y=response,fill=number,color=modality)) +
  geom_bar(stat="identity",position=position_dodge()) +
  geom_errorbar(aes(ymin=bootsci_low, ymax=bootsci_high, x=context, width=0.1),position=position_dodge(width=0.9))+
  #ylab("faultless disagreement\n")+
  #xlab("\nadjective class") +
  ylim(0,1) +
  facet_wrap("item") +
  scale_color_manual(values=c("blue","red")) +
  scale_fill_manual(values=c("lightblue","pink")) +
  theme_bw()
big_plot
ggsave("big_plot.png")


c_s = bootsSummary(data=d, measurevar="response", groupvars=c("context","modality","number"))

collapsed_plot <- ggplot(c_s, aes(x=context,y=response,fill=number,color=modality)) +
  geom_bar(stat="identity",position=position_dodge()) +
  geom_errorbar(aes(ymin=bootsci_low, ymax=bootsci_high, x=context, width=0.1),position=position_dodge(width=0.9))+
  #ylab("faultless disagreement\n")+
  #xlab("\nadjective class") +
  ylim(0,1) +
  #facet_wrap("item") +
  scale_color_manual(values=c("blue","red")) +
  scale_fill_manual(values=c("lightblue","pink")) +
  theme_bw()
collapsed_plot
ggsave("collapsed_plot.png")
