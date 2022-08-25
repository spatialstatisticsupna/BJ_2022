#Using mortality to predict incidence for rare and lethal cancers
#in very small areas. Biometrical Journal (2022)
# Author: Jaione Etxeberria 
# This code is developed in R-4.2.1 version

#rm(list=ls())
######################################################################
library(tidyverse)
library(Hmisc)
library(classInt)
library(RColorBrewer)
#library(maptools)
library(tmap)
library(INLA)
library(xtable)
library(ggplot2)
library(viridis)
 
#### In this section, the predictions provided by M8 are detailed. The user can get the results of 
# any other model. To do so, copy the corresponding .Rdata obtained in Section 3 and 
#paste it in folder Section 5

load("Modelo8.Rdata")
result=result8
Mod="Mod8"

DatosBrain=read.table("DBrain.txt")

############################################################################
#### Table 3 Observed versus Predicted number of Brain Cancer incidence cases per period


yearslab=c("1989-1990","1991-1992","1993-1994","1995-1996","1997-1998","1999-2000","2001-2002","2003-2004","2005-2006","2007-2008")

tasae<-result$summary.fitted.values[,c(3,1,5)]
colnames(tasae)=c("ilimc","casoe","isupc")
BrainEstim=data.frame(cbind(DatosBrain,tasae*DatosBrain$pop))

EstimInci=BrainEstim[BrainEstim$outcome=="Incidence",]

table=data.frame(aggregate(EstimInci$cases,list(year=EstimInci$period,sex=EstimInci$sex),sum),
      aggregate(ceiling(EstimInci$casoe),list(year=EstimInci$period,sex=EstimInci$sex),sum)[,3],
      aggregate(ceiling(EstimInci$ilimc),list(year=EstimInci$period,sex=EstimInci$sex),sum)[,3],
      aggregate(ceiling(EstimInci$isupc),list(year=EstimInci$period,sex=EstimInci$sex),sum)[,3])

colnames(table)=c("period","sex","Observed","Fitted","95%CI_LB","95%CI_UB")
period=yearslab
Table3=cbind(period,table[table$sex==1,][,-c(1,2)],table[table$sex==2,][,-c(1,2)])

xtable(Table3)

### Note that columns 2-to-5 corresponds to males and columns 6-to-9corresponds to females


############################################################################
#### Figure 7 Gender-specific temporal trends and predicted rates for 2005-06 and 2007-08 obtained with M8

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
#### Maps will be generated automatically in pdf forma using the name Mod_8_Spatial_rates_AgeGroup6.pdf

tasae<-result$summary.fitted.values[,c(3,1,5)]
colnames(tasae)=c("ilimc","tasae","isupc")
BrainEstim=data.frame(cbind(DatosBrain,tasae*10^5))
EstimInci=BrainEstim[BrainEstim$outcome=="Incidence",]
ATGT<-aggregate(BrainEstim[,c(6:10)],
                by=list(sex=BrainEstim$sex,age=BrainEstim$age,period=BrainEstim$period,region=BrainEstim$region,outcome=BrainEstim$outcome),sum)


carto <- st_read('carto/carto.shp')
carto$region <- c("Gran Bilbao", "North Biscay", "South Biscay", "West Gipuzkoa", "East Gipuzkoa", "Donostia-Bajo Bidasoa", "Alava", "Mid Navarra", "Navarra South", "Navarra North", "Pamplona")
agelabels=c("less than 40","40-49","50-59","60-69","70-79","80+")
yearslab=c("1989-1990","1991-1992","1993-1994","1995-1996","1997-1998","1999-2000","2001-2002","2003-2004","2005-2006","2007-2008")
n=max(ATGT$period)

ag=1
ATG=ATGT[ATGT$age==ag,]
carto$spiH=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==n,]$tasae  
carto$spiM=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==n,]$tasae    
plotclr <- c("#ecf9ec", "#8cd98c" ,"#40bf40" ,"#339933", "#194d19",  "#061306")
a=min(carto$spiH,carto$spiM)
b=max(carto$spiH,carto$spiM)
# print(c(a,b))
breaks=seq(0,50,length.out = 6)
tm=tm_shape(carto) + 
  tm_polygons(col=c("spiH","spiM"), breaks=breaks, palette=plotclr,
              labels=levels(cut(0:50, breaks=breaks)),
              title ="" , legend.show=T) + 
  tm_layout(main.title="",
            main.title.size=1.3, main.title.position="center",
            legend.outside.position="right",
            legend.text.size=0.8,
            legend.position = c(0.15, 0.25),
            legend.outside=TRUE,
            panel.labels = c(paste("Prediction for males", agelabels[ag], "\n",yearslab[n]), paste("Prediction for females", agelabels[ag], "\n",yearslab[n])),
            panel.label.size=1,
            panel.label.bg.color="White",
            panel.label.height=2,
            frame = FALSE) +
  tm_facets(nrow=1, ncol=2)
tmap_save(tm,paste0(Mod,"_Spatial_rates_AgeGroup",ag,".pdf"))


for(ag in 2:6){
  ATG=ATGT[ATGT$age==ag,]
  carto$spiH=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==n,]$tasae  
  carto$spiM=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==n,]$tasae   
  plotclr <- c("#EBF0FA", "#ADC2EB" ,"#7094DB" ,"#3366CC", "#1F3D7A",  "#0F1F3D")
  a=min(carto$spiH,carto$spiM)
  b=max(carto$spiH,carto$spiM)
  # print(c(a,b))
  breaks=seq(0,180,length.out = 6)
  tm=tm_shape(carto) + 
    tm_polygons(col=c("spiH","spiM"), breaks=breaks, palette=plotclr,
                labels=levels(cut(0:50, breaks=breaks)),
                title ="" , legend.show=T) + 
    tm_layout(main.title="",
              main.title.size=1.3, main.title.position="center",
              legend.outside.position="right",
              legend.position = c(0.15, 0.25), 
              legend.text.size=0.8,
              legend.outside=TRUE,
              panel.labels = c(paste("Prediction for males", agelabels[ag], "\n",yearslab[n]), paste("Prediction for females", agelabels[ag], "\n",yearslab[n])),
              panel.label.size=1,
              panel.label.bg.color="White",
              panel.label.height=2,
              frame = FALSE) +
    tm_facets(nrow=1, ncol=2)
  tmap_save(tm,paste0(Mod,"_Spatial_rates_AgeGroup",ag,".pdf"))
}


############################################################################
#### Figure A.2 Coefficients of variation (CV) of the predicted rates by regions and age-groups obtained
#as the posterior standard deviation of the rates divided by the posterior mean. 12

#### Maps will be generated automatically in pdf format using the name Mod_8_Spatial_cv_AgeGroupXX.pdf

carto <- st_read('carto/carto.shp')
carto$region <- c("Gran Bilbao", "North Biscay", "South Biscay", "West Gipuzkoa", "East Gipuzkoa", "Donostia-Bajo Bidasoa", "Alava", "Mid Navarra", "Navarra South", "Navarra North", "Pamplona")


cv<-result$summary.fitted.values[,2]/result$summary.fitted.values[,1]
tasas=result$summary.fitted.values[,1:2]
BrainEstim=data.frame(cbind(DatosBrain,cv,tasas))
ATGT=BrainEstim[BrainEstim$outcome=="Incidence",]

CVs1=NA ; CVs2=NA
for(ag in 1:6){
  ATG=ATGT[ATGT$age==ag,]
 spiH=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==n,]$cv
 CVs1=data.frame(CVs1,spiH)
 spiM=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==n,]$cv 
  CVs2=data.frame(CVs2,spiM)
}
CVs1=CVs1[-1] ; CVs2=CVs2[-1] 
colnames(CVs1)=paste0("spiH",1:6) ; colnames(CVs2)=paste0("spiM",1:6)
CVs=data.frame(cbind(regions),CVs1,CVs2)
summary(CVs)

carto$spiH1=CVs$spiH1; carto$spiM1=CVs$spiM1
carto$spiH2=CVs$spiH2; carto$spiM2=CVs$spiM2
carto$spiH3=CVs$spiH3; carto$spiM3=CVs$spiM3
carto$spiH4=CVs$spiH4; carto$spiM4=CVs$spiM4
carto$spiH5=CVs$spiH5; carto$spiM5=CVs$spiM5
carto$spiH6=CVs$spiH6; carto$spiM6=CVs$spiM6

legends=NULL
for(ag in 1:6){
  legends=c(legends,paste("CV for males", agelabels[ag], "\n",yearslab[n]), paste("CV for females", agelabels[ag], "\n",yearslab[n]))  
}

breaks=seq(0,2.7,length.out = 5)
plotclr=brewer.pal(9, "Greens")[c(4,6,8,9)]

cvmap=tm_shape(carto) + 
    tm_polygons(col=c("spiH1" , "spiM1","spiH2" ,"spiM2","spiH3" ,"spiM3",
                      "spiH4" ,"spiM4","spiH5" ,"spiM5","spiH6" ,"spiM6"), breaks=breaks, palette=plotclr,
                labels=levels(cut(0:2.7, breaks=breaks)),
                title ="" , legend.show=T, legend.is.portrait=F) + 
    tm_layout(main.title="",
              main.title.size=1.3, main.title.position="center",
              legend.outside.position="bottom",
              legend.position = c(0.25, 0.25), 
              legend.text.size=0.8,
              legend.outside=TRUE,
              panel.labels =legends[1:12],
              panel.label.size=0.9,
              panel.label.bg.color="White",
              panel.label.height=2,
              frame = FALSE) +
    tm_facets(nrow=3, ncol=4)

tmap_save(cvmap,paste0(Mod,"_Spatial_CV_AgeGroup",ag,".pdf"))

  
