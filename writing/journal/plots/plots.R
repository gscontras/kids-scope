setwd("~/git/kids-scope/writing/journal/plots/")
library(ggplot2)
library(scales)

d_all = read.csv("every-not-results.csv",header=T)

d = d_all[d_all$manipulation!="pragmatic",]

d$x = NA

d[d$manipulation=="qud",]$x = as.character(d[d$manipulation=="qud",]$qud)
d[d$manipulation=="scope",]$x = d[d$manipulation=="scope",]$inverse
d[d$manipulation=="baserate",]$x = d[d$manipulation=="baserate",]$baserate

d$manipulation = factor(d$manipulation,levels=c("baserate","qud","scope"))
d$manipulation = factor(d$manipulation,labels=c("world state baserate\nmanipulation","QUD prior\nmanipulation","inverse scope prior\nmanipulation"))

d$x = factor(d$x,levels=c("0.1","0.5","0.9","none?","how-many?","all?"))

everyNot = ggplot(d,aes(x=as.factor(x),y=endorsement,fill=as.factor(x))) +
  geom_bar(stat="identity") +
  ylab("probability of endorsing\nambiguous utterance\n") +
  guides(fill=FALSE)+
  theme_bw()+
  xlab("")+
  ylim(0,1)+
  facet_grid(.~manipulation,scales = "free_x")
everyNot
#ggsave("every-not-plot.png",width=7,height=2.3)


p = d_all[d_all$manipulation=="pragmatic",]

everyNot_pragmatic = ggplot(p,aes(x=as.factor(inverse),y=endorsement,fill=as.factor(inverse))) +
  geom_bar(stat="identity") +
  ylab("probability of endorsing\nambiguous utterance\n") +
  xlab("\ninverse scope prior\nmanipulation")+
  guides(fill=FALSE)+
  theme_bw()+
  ylim(0,1)
everyNot_pragmatic
#ggsave("every-not-pragmatic-plot.png",width=3,height=2.3)


















d$manipulation = factor(d$manipulation,levels=c("baserate","QUD","scope"))
d$manipulation = factor(d$manipulation,labels=c("world state prior\nmanipulation","QUD prior\nmanipulation","scope prior\nmanipulation"))

p1 <- ggplot(d,aes(x=as.factor(x),y=p,fill=as.factor(x))) +
  geom_bar(stat="identity")+
  ylab("probability of endorsing\nambiguous utterance\n") +
  xlab("\nscope prior")+
  #scale_fill_manual(values=c("red", "blue"))+
  theme(axis.text.x = element_text(size=10,angle=0))+
  scale_y_continuous(limits=c(0,1),oob = rescale_none)+
  geom_abline(intercept = 0.275, slope = 0,linetype=2) +
  geom_abline(intercept = 0.925, slope = 0,linetype="dotted") +
  theme_bw()+
  xlab("")+
  guides(fill=FALSE)+
  theme(text = element_text(size=26))+
  facet_grid(.~manipulation,scales = "free_x")
p1
ggsave("adv_everynot.png",width=15.5,height=4.5)



# figure 2: 1-of-2 contrast manipulation

d2 = read.csv("../results/CMCL-figure2.csv",header=T)
names(d2) <- c("n","baserate","QUD","surface_scope","meaning","p","manipulation")
d2$scope = 1 - d2$surface_scope
# 
# d2$manipulation = factor(d2$manipulation,levels=c("p(inv) = 0.1","p(inv) = 0.5","p(inv) = 0.9","p(inv) = 0.1 b = 0.9"))
# d2$manipulation = factor(d2$manipulation,labels=c("p(inv) = 0.1\nb = 0.1","p(inv) = 0.5\nb = 0.1","p(inv) = 0.9\nb = 0.1","p(inv) = 0.1\nb = 0.9"))
# 
# #d2$scope = factor(d2$scope,labels=c("p(inv) = 0.1","p(inv) = 0.5"))
# 
# p2 <- ggplot(d2,aes(x=as.factor(QUD),y=p,fill=as.factor(QUD))) +
#   geom_bar(stat="identity")+
#   ylab("probability of endorsing\nambiguous utterance\n") +
#   xlab("\nscope prior")+
#   #scale_fill_manual(values=c("red", "blue"))+
#   theme(axis.text.x = element_text(size=10,angle=0))+
#   scale_y_continuous(limits=c(0,1),oob = rescale_none)+
#   geom_abline(intercept = 0.2, slope = 0,linetype=2) +
#   geom_abline(intercept = 0.9, slope = 0,linetype="dotted") +
#   theme_bw()+
#   xlab("")+
#   guides(fill=FALSE)+
#   theme(text = element_text(size=26))+
#   facet_grid(.~manipulation,scales = "free_x")
# p2
# #ggsave("CMCL-figure2a.png",width=14.5,height=4)
# 
# d2b <- d2[(d2$QUD=="uniform" & d2$surface_scope==0.9)|d2$QUD=="all?",]
# d2b$manipulation = factor(d2b$manipulation,labels=c("b=0.1\np(inv)=0.1\nQUD: uniform","b=0.9\np(inv)=0.1\nQUD: all?"))
# 
# p2b <- ggplot(d2b,aes(x=manipulation,y=p,fill=manipulation)) +
#   geom_bar(stat="identity")+
#   ylab("probability of endorsing\nambiguous utterance\n") +
#   #xlab("\nscope prior")+
#   #scale_fill_manual(values=c("red", "blue"))+
#   theme(axis.text.x = element_text(size=10,angle=0))+
#   scale_y_continuous(limits=c(0,1),oob = rescale_none)+
#   geom_abline(intercept = 0.2, slope = 0,linetype=2) +
#   geom_abline(intercept = 0.9, slope = 0,linetype="dotted") +
#   theme_bw()+
#   xlab("")+
#   guides(fill=FALSE)+
#   theme(text = element_text(size=26))#+
#   #facet_grid(.~manipulation,scales = "free_x")
# p2b
# #ggsave("CMCL-figure2b.png",width=6,height=5)

d2c <- d2[d2$QUD=="uniform"|d2$QUD=="all?",]
d2c$manipulation = factor(d2c$manipulation,labels=c("b=0.1\nQUD: uniform","b=0.9\nQUD: all?"))

p2c <- ggplot(d2c,aes(x=manipulation,y=p,fill=as.factor(scope))) +
  geom_bar(stat="identity",position = position_dodge())+
  ylab("probability of endorsing\nambiguous utterance\n") +
  #xlab("\nscope prior")+
  scale_fill_manual(values=c("#00BA38", "#00C19F","#00B9E3"))+
  theme(axis.text.x = element_text(size=10,angle=0))+
  scale_y_continuous(limits=c(0,1),oob = rescale_none)+
  geom_abline(intercept = 0.275, slope = 0,linetype=2) +
  geom_abline(intercept = 0.925, slope = 0,linetype="dotted") +
  theme_bw()+
  labs(fill="p(inv)") +
  xlab("")+
  theme(text = element_text(size=26)) #+
  #facet_grid(.~manipulation,scales = "free_x")
p2c
#ggsave("CMCL-figure2c.png",width=7.5,height=5)




# figure 3: 2-of-4 context


d3 = read.csv("../results/CMCL-figure3.csv",header=T)
names(d3) <- c("n","baserate","QUD","surface_scope","meaning","p","manipulation")
d3$scope = 1 - d3$surface_scope

d3$manipulation = factor(d3$manipulation,labels=c("b=0.1\nQUD: uniform\nat least","b=0.1\nQUD: uniform\nexact"))

p3 <- ggplot(d3,aes(x=manipulation,y=p,fill=as.factor(scope))) +
  geom_bar(stat="identity",position = position_dodge())+
  ylab("probability of endorsing\nambiguous utterance\n") +
  #xlab("\nscope prior")+
  scale_fill_manual(values=c("#00BA38", "#00C19F","#00B9E3"))+
  theme(axis.text.x = element_text(size=10,angle=0))+
  scale_y_continuous(limits=c(0,1),oob = rescale_none)+
  #geom_abline(intercept = 0.2, slope = 0,linetype=2) +
  #geom_abline(intercept = 0.9, slope = 0,linetype="dotted") +
  theme_bw()+
  labs(fill="p(inv)") +
  xlab("")+
  theme(text = element_text(size=26)) #+
#facet_grid(.~manipulation,scales = "free_x")
p3
#ggsave("CMCL-figure3.png",width=7.5,height=5)



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


