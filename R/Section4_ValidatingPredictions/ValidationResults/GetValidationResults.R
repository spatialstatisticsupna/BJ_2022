#Using mortality to predict incidence for rare and lethal cancers
#in very small areas. Biometrical Journal (2022)
# Author: Jaione Etxeberria 
# This coda is developed in R-4.2.1 version

############################################################################################
#### Table 2 Global absolute relative bias computed using one step ahead predictions

selmodels=1:8   
Mod=NULL
for(mod in selmodels){
  assign(paste0("Mod",mod), read.table(file=paste("Modelo",mod,"val.txt",sep="")))
  Mod=rbind(Mod,get(paste0("Mod",mod)))  
}
library(xtable)
##### Relative Bias global
res1=aggregate(list(Pred=Mod$casosPred,Obs=Mod$casosO), by=list(mod=Mod$mod), FUN=sum)
res1$Bias=abs(res1$Pred-res1$Obs)/res1$Obs
res1
globals=rbind(res1$Bias)
##### Relative Bias / gender
res1=aggregate(list(Pred=Mod$casosPred,Obs=Mod$casosO), by=list(sex=Mod$sex,mod=Mod$mod), FUN=sum)
res1$Bias=abs(res1$Pred-res1$Obs)/res1$Obs
res1
xtable(rbind(globals,res1[res1$sex==1 ,]$Bias,res1[res1$sex==2 ,]$Bias),digits=4)

################################################################################################
#### Figure 5 Age specific relative biases in one step ahead predictions

library(billboarder)
agelab=c("Less than 40","40-49","50-59","60-69","70-79","80+")	 
labl=c("Predictions one period a-head")
mcol=length(selmodels)

  res=aggregate(list(Pred=Mod$casosPred,Obs=Mod$casosO), by=list(age=Mod$age,mod=Mod$mod), FUN=sum)
  res$bias=abs(res$Pred-res$Obs)/res$Obs
  res$modl=paste0("M",res$mod)
  res$Age_group=array(0,length(dim(res)[1]))
  for(ag in 1:6){
    res[res$age==ag,]$Age_group=agelab[ag]
  }
  res
  
  #### We choose the models we want to represent
  res=res[res$modl=="M5" | res$modl=="M8",] 
  

billboarder() %>%
  bb_scatterplot(data = res, mapping = bbaes(Age_group, bias, group = modl)) %>%  #size = bias 
  bb_x_axis(type="category", tick = list( fit = TRUE)) %>%
  bb_point(r = 20)%>%
  bb_y_axis(max=0.35)%>%
  bb_y_grid(show = TRUE)%>%
  bb_legend(position = "right") %>%
  bb_zoom(enabled = list(type = "drag"),resetButton = list(text = "Unzoom")) %>%
  bb_add_style(".bb-axis-x" = "font-size: 16px;", ".bb-axis-y" = "font-size: 16px;",
               ".bb-title" = "font-size: 23px;" )%>%
  bb_labs(title="Age-specific bias in one step ahead prediction"  )

############################################################################################
#### Figure 6 Region specific relative biases in one step ahead predictions

library(classInt)
library(viridis)
library(maptools)

regions=c("Gran Bilbao", "North Biscay", "South Biscay", "West Gipuzkoa", "East Gipuzkoa", "Donostia-Bajo Bidasoa", "Alava", "Mid Navarra", "Navarra South", "Navarra North", "Pamplona")
carto<-readShapePoly("carto/carto")


##### Relative Bias
res1=aggregate(list(Pred=Mod$casosPred,Obs=Mod$casosO), by=list(region=Mod$region,mod=Mod$mod), FUN=sum)
res1$BiasRel=abs(res1$Pred-res1$Obs)/res1$Obs

##### Plotting details

mat=t(matrix(c(rep(1,2),2:3,rep(4,2)),ncol=3,nrow=2)) ### 
par(mar = rep(0,4))
layout(mat, widths =rep(1,9),heights = c(1,4,1))    
cex.main=2

selmodels=c(5, 8) 

plotclr <- rev(viridis(9))
nclr=5
fixedBreaks=seq(0,0.25,by=0.05)


res1$BiasRel=abs(res1$Pred-res1$Obs)/res1$Obs
class <- classIntervals(res1$BiasRel, nclr,style="fixed",fixedBreaks=fixedBreaks)
class
res1$colcode <- findColours(class, plotclr)
colcode=res1$colcode
res$namemod=array(0,length(dim(res)[1]))
plot.new()
text(0.5,0.5,"Region-specific bias in one step ahead predictions",cex=3.5,font=2)
for(modsel in selmodels){    
  plot(carto)
  plot(carto, col=res1[res1$mod==modsel,]$colcode, add=T)
  title(main=paste0("M",modsel ),line=-2.5, cex.main = cex.main+1.5)
}
plot.new()
legend("center", ncol =5, legend=names(attr(colcode, "table")),
       fill=attr(colcode, "palette"), bty="n", cex=3)  


