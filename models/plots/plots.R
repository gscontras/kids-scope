setwd("~/Documents/git/meaningLab/kids-scope/models/plots/")
##setwd("~/Documents/MATLAB/RSA Functions/R Code for Graphs/kids-scope/kids-scope")
library(ggplot2)
library(scales)

# ## BIG PLOT
# 
# all_d = read.csv("big_matrix.csv",header=T)
# 
# names(all_d) <- c("state","scope","QUD","p")
# 
# all_d$state = factor(all_d$state,levels=c("3","0","1","2"))
# all_d$state = factor(all_d$state,labels=c("uniform\nstate prior","0 horses","1 horse","2 horses"))
# 
# all_d$QUD = factor(all_d$QUD,levels=c("3","0","1","2"))
# all_d$QUD = factor(all_d$QUD,labels=c("uniform\nQUD prior","did no\nhorses succeed?","how many\nhorses succeeded?","did all\nhorses succeed?"))
# 
# p <- ggplot(all_d,aes(x=as.factor(scope),y=p,fill=as.factor(scope))) +
#   geom_bar(stat="identity")+
#   ylab("probability of endorsing\nambiguous utterance\n") +
#   xlab("\nscope prior")+
#   #scale_fill_manual(values=c("red", "blue"))+
#   theme(axis.text.x = element_text(size=10,angle=0))+
#   #ylim(0,0.8)+
#   theme_bw()+
#   guides(fill=FALSE)+
# facet_grid(QUD~state)
# p
# #ggsave("big-plot.jpg",width=7,height=7)


## little plot

q = read.csv("qud_manip9.csv",header=F)
names(q) <- c("state","scope","QUD","p")
q$condition = "qud"
q$QUD = factor(q$QUD,levels=c("3","0","1","2"))
q$QUD = factor(q$QUD,labels=c("uniform\nQUD prior","did no\nhorses succeed?","how many\nhorses succeeded?","did all\nhorses succeed?"))
s = read.csv("scope_manip.csv",header=F)
names(s) <- c("state","scope","QUD","p")
s$condition = "scope"
w = read.csv("world_manip9.csv",header=F)
names(w) <- c("state","scope","QUD","p")
w$condition = "world"
w$state = factor(w$state,levels=c("4","0","1","2","3"))
w$state = factor(w$state,labels=c("uniform\nstate prior","0 horses","1 horse","2 horses","3 horses"))


d = rbind(s,w,q)

d$x = NA
d[d$condition=="qud",]$x = as.character(d[d$condition=="qud",]$QUD)
d[d$condition=="scope",]$x = d[d$condition=="scope",]$scope
d[d$condition=="world",]$x = d[d$condition=="world",]$world

d$x = factor(d$x,levels=c("uniform\nQUD prior","did no\nhorses succeed?","how many\nhorses succeeded?","did all\nhorses succeed?","0.1","0.5","0.9","uniform\nstate prior","0 horses","1 horse","2 horses","3 horses"))
d$x = factor(d$x,labels=c("uniform\nQUD prior","did no\nhorses\nsucceed?","how many\nhorses\nsucceeded?","did all\nhorses\nsucceed?","0.1","0.5","0.9","uniform\nstate prior","0 horses","1 horse","2 horses","3 horses"))

d$condition = factor(d$condition,levels=c("world","qud","scope"))
d$condition = factor(d$condition,labels=c("world state prior\nmanipulation","qud prior\nmanipulation","scope prior\nmanipulation"))

lp <- ggplot(d,aes(x=as.factor(x),y=p,fill=as.factor(x))) +
  geom_bar(stat="identity")+
  ylab("probability of endorsing\nambiguous utterance\n") +
  xlab("\nscope prior")+
  #scale_fill_manual(values=c("red", "blue"))+
  theme(axis.text.x = element_text(size=10,angle=0))+
  scale_y_continuous(limits=c(.2,.9),oob = rescale_none)+
  theme_bw()+
  xlab("\nfavored parameter value")+
  guides(fill=FALSE)+
  facet_grid(.~condition,scales = "free_x")
lp
#ggsave("little-plot.jpg",width=10.2,height=2.75)

##Super Endorsement Graph

# e = read.csv("super_endorse9.csv",header=F)
# names(e) <- c("state","scope","QUD","p")
# 
# se <- ggplot(e,aes(x=as.factor(x),y=p,fill=as.factor(x))) +
#   geom_bar(stat="identity")+
#   ylab("probability of endorsing\nambiguous utterance\n") +
#   xlab("\nscope prior")+
#   #scale_fill_manual(values=c("red", "blue"))+
#   theme(axis.text.x = element_text(size=10,angle=0))+
#   scale_y_continuous(limits=c(.3,1),oob = rescale_none)+
#   theme_bw()+
#   xlab("\ninverse scope prior")+
#   guides(fill=FALSE)+
#   facet_grid(.~condition,scales = "free_x")
# se
#ggsave("super_endorse.jpg",width=3,height=3)


