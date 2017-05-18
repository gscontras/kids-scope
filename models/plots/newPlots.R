##setwd("~/Documents/kids-scope/")
##setwd("~/Documents/MATLAB/kids-scope/kids-scope/models/Matlab Model/RSA-Code/Data")
library(ggplot2)
library(scales)
# ## BIG PLOt
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


# little plot

#q = read.csv("twonot_qud",header=F)
q = read.csv("qud_manip9.csv",header=F)
names(q) <- c("state","scope","QUD","p")
q$condition = "qud"
q$QUD = factor(q$QUD,levels=c("3","0","1","2"))
#change from horses to frogs
#q$QUD = factor(q$QUD,labels=c("uniform\nQUD prior","did no\nfrogs succeed?","how many\nfrogs succeeded?","did all\nfrogs succeed?"))
q$QUD = factor(q$QUD,labels=c("uniform\nQUD prior","did no\nhorses succeed?","how many\nhorses succeeded?","did all\nhorses succeed?"))

#s = read.csv("twonot_scope",header=F)
s = read.csv("scope_manip.csv",header=F)
names(s) <- c("state","scope","QUD","p")
s$condition = "scope"

#w = read.csv("twonot_world",header=F)
w = read.csv("world_manip9.csv",header=F)
w = w[-c(3),]
names(w) <- c("state","scope","QUD","p")
w$condition = "world"
##Frogs
#w$state = factor(w$state,levels=c("3","0","1","2"))
#w$state = factor(w$state,labels=c("uniform\nstate prior","0 frogs","1 frog","2 frogs"))
##Horses
w$state = factor(w$state,levels=c("4","0","2","3"))
w$state = factor(w$state,labels=c("uniform\nstate prior","0 horses","2 horses","3 horses"))

d = rbind(s,w,q)

d$x = NA
d[d$condition=="qud",]$x = as.character(d[d$condition=="qud",]$QUD)
d[d$condition=="scope",]$x = d[d$condition=="scope",]$scope
d[d$condition=="world",]$x = d[d$condition=="world",]$world

##Horses
d$x = factor(d$x,levels=c("uniform\nQUD prior","did no\nhorses succeed?","how many\nhorses succeeded?","did all\nhorses succeed?","0.1","0.3", "0.5","0.7","0.9","uniform\nstate prior","0 horses","2 horses","3 horses"))
d$x = factor(d$x,labels=c("uniform","none?","how\nmany?","all?","0.1","0.3", "0.5","0.7","0.9","uniform","0","2","3"))

##Frogs
#d$x = factor(d$x,levels=c("uniform\nQUD prior","did no\nfrogs succeed?","how many\nfrogs succeeded?","did all\nfrogs succeed?","0.1","0.3", "0.5","0.7","0.9","uniform\nstate prior","0 frogs","1 frog","2 frogs"))
#d$x = factor(d$x,labels=c("uniform","none?","how\nmany?","all?","0.1","0.3", "0.5","0.7","0.9","uniform","0","1","2"))

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
  xlab("")+
  guides(fill=FALSE)+
  theme(text = element_text(size=26))+
  facet_grid(.~condition,scales = "free_x")
lp
#ggsave("twonot_results.jpeg",width=15.75,height=4.5)
ggsave("horses_BU.jpeg",width=15.75,height=4.5)

##Super Endorsement Graph

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
# se
e = read.csv('super_endorse9.csv',header=F)
names(e) <- c("state","scope","QUD","p") 

e$scope = factor(e$scope,levels=c("0.1","0.5","0.9"))
e$scope = factor(e$scope,labels=c("0.1","0.5","0.9"))
e$condition = factor(e$condition,levels=c("scope"))
e$condition = factor(e$condition,labels=c("Gang-up effect of Pragmatic factors"))
# A bar graph
se <-ggplot(data=e, aes(x=as.factor(scope), y=p,fill=as.factor(scope))) + 
  geom_bar(stat="identity") +                        # Thinner lines
  scale_fill_manual(values=c("limegreen", "seagreen3","royalblue1"))+      # Set legend title
  xlab("") + ylab("probability of endorsing\nambiguous utterance\n") + # Set axis labels
  scale_y_continuous(limits=c(.2,1),oob = rescale_none)+
  theme_bw()+
  theme(text = element_text(size=26))+
  guides(fill=FALSE)
se
ggsave("super_end.jpeg",width=6,height=4.4)

g = read.csv('world_manip9.csv',header=F)
names(g) <- c("state","scope","QUD","p") 

g$state = factor(g$state,levels=c("4","0","1","2","3"))
g$state = factor(g$state,labels=c("uniform\nstate prior","0 horses","1 horse","2 horses","3 horses"))
# A bar graph
we <-ggplot(data=g, aes(x=as.factor(state), y=p,fill=as.factor(state))) + 
  geom_bar(stat="identity") +                        # Thinner lines
  #scale_fill_manual(values=c("limegreen", "seagreen3","royalblue1"))+      # Set legend title
  xlab("") + ylab("probability of endorsing\nambiguous utterance\n") + # Set axis labels
  scale_y_continuous(limits=c(.2,1),oob = rescale_none)+
  theme_bw()+
  theme(text = element_text(size=32))+
  guides(fill=FALSE)
we

q = read.csv('qud_manip9.csv',header=F)
names(q) <- c("state","scope","QUD","p") 

q$QUD = factor(q$QUD,levels=c("3","0","1","2"))
q$QUD = factor(q$QUD,labels=c("uniform\nQUD prior","did no\nhorses succeed?","how many\nhorses succeeded?","did all\nhorses succeed?"))
# A bar graph
qe <-ggplot(data=q, aes(x=as.factor(QUD), y=p,fill=as.factor(QUD))) + 
  geom_bar(stat="identity") +                        # Thinner lines
  #scale_fill_manual(values=c("limegreen", "seagreen3","royalblue1"))+      # Set legend title
  xlab("") + 
  ylab("probability of endorsing\nambiguous utterance\n") + # Set axis labels
  scale_y_continuous(limits=c(.2,1),oob = rescale_none)+
  theme_bw()+
  theme(text = element_text(size=32))+
  guides(fill=FALSE)
qe

s = read.csv('scope_manip.csv',header=F)
names(s) <- c("state","scope","QUD","p") 

s$scope = factor(s$scope,levels=c("0.1","0.3","0.5","0.7","0.9"))
s$scope = factor(s$scope,labels=c("0.1","0.3","0.5","0.7","0.9"))
# A bar graph
ss <-ggplot(data=s, aes(x=as.factor(scope), y=p,fill=as.factor(scope))) + 
  geom_bar(stat="identity") +                        # Thinner lines
  #scale_fill_manual(values=c("limegreen", "seagreen3","royalblue1"))+      # Set legend title
  xlab("inverse scope prior") + ylab("probability of endorsing\nambiguous utterance\n") + # Set axis labels
  scale_y_continuous(limits=c(.2,1),oob = rescale_none)+
  theme_bw()+
  theme(text = element_text(size=32))+
  guides(fill=FALSE)
ss
#ggsave("super_endorse.jpg",width=3,height=3)fill="seagreen3", colour="seagreen3"


