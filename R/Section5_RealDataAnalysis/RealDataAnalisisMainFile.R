
#Using mortality to predict incidence for rare and lethal cancers
#in very small areas. Biometrical Journal (2022)
# Author: Jaione Etxeberria 
# This coda is developed in R-4.2.1 version


library(tidyverse)
library(Hmisc)
library(lme4)
library(nlme)
library(classInt)
library(RColorBrewer)
library(maptools)
library(xtable)
 
#### In this section, the predictions provided by M8 are detailed
load("Modelo8.Rdata")
result=result8

############################################################################
#### Table 3 Observed versus Predicted number of Brain Cancer incidence cases per period

DatosBrain=read.table("DBrain.txt")

tasae<-result$summary.fitted.values[,c(3,1,5)]
colnames(tasae)=c("ilimc","casoe","isupc")
BrainEstim=data.frame(cbind(DatosBrain,tasae*DatosBrain$pop))

EstimInci=BrainEstim[BrainEstim$outcome=="Incidence",]

coln=c("Period","Observed","Fitted","95%CI_LB","95%CI_UB")
xtable(rbind(coln,cbind(aggregate(EstimInci$cases,list(year=EstimInci$period,sex=EstimInci$sex),sum),
             aggregate(ceiling(EstimInci$ilimc),list(year=EstimInci$period,sex=EstimInci$sex),sum)[,3],
             aggregate(ceiling(EstimInci$casoe),list(year=EstimInci$period,sex=EstimInci$sex),sum)[,3],
             aggregate(ceiling(EstimInci$isupc),list(year=EstimInci$period,sex=EstimInci$sex),sum)[,3])))
  
### NOTE: Rows 2 to 11 corresponds to males. 12 to 21 to females


############################################################################
#### Figure 7 Gender-specific temporal trends and predicted rates for 2005-06 and 2007-08 obtained with M8


library(ggplot2)

yearslab=c("1989-1990","1991-1992","1993-1994","1995-1996","1997-1998","1999-2000","2001-2002","2003-2004","2005-2006","2007-2008")

casose<-result$summary.fitted.values[,c(3,1,5)]*DatosBrain$pop
colnames(casose)=c("ilimc","casose","isupc")
BrainEstim=data.frame(DatosBrain,casose)
EstimInci=BrainEstim[BrainEstim$outcome=="Incidence",]

datplot=data.frame(aggregate(ceiling(EstimInci[,c(6:10)]),list(year=EstimInci$period,sex=EstimInci$sex),sum))
datplot$ratet=datplot$casose/datplot$pop*10^5
datplot$ilimct=datplot$ilimc/datplot$pop*10^5
datplot$isupct=datplot$isupc/datplot$pop*10^5

datplot$Gender="Males"
datplot[datplot$sex==2,]$Gender="Females"
res=aggregate(list(Obs=datplot$casos,Pred=datplot$casose), by=list(agno=datplot$year,sex=datplot$sex), FUN=sum)
sizes=18
ggplot(data = datplot, aes(x=year, y=ratet,color=Gender)) + 
 geom_ribbon(aes(ymax=isupct, ymin=ilimct,color=Gender,fill=Gender),alpha=0.4) + 
  geom_point() + 
  geom_line() + 
  geom_vline(xintercept=8, linetype = 2) +
  geom_text(aes(x=8, label="Predictions", 
                y=15), colour="black", 
            angle=0, hjust = -0.5)+
    lims(x= yearslab, y = c(0,40))+ 
  xlab("Period") + ylab("Gender-specific incidence rate \n trends and predictions") +
  theme_classic(base_size = sizes)

############################################################################
#### Figure 8 and 9 Maps of predicted incidence rates for age-groups 2007-2008 period for the 11 health regions.
library(classInt)
#### Maps will be generated automatically in pdf forma using the name Mod_8_Spatial_rates_AgeGroup6.pdf
source("PlotRateMaps_byAge.R")


############################################################################
#### Figure A.2 Coefficients of variation (CV) of the predicted rates by regions and age-groups obtained
#as the posterior standard deviation of the rates divided by the posterior mean. 12

#### Maps will be generated automatically in pdf forma using the name Mod_8_Spatial_cv_AgeGroupXX.pdf

source("PlotCVMaps_byAge.R")

