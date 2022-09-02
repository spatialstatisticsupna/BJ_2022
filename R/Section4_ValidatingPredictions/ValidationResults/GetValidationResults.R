#Using mortality to predict incidence for rare and lethal cancers
#in very small areas. Biometrical Journal (2022)
# Author: Jaione Etxeberria 
# This code is developed in R-4.2.1 version

#rm(list=ls())
#setwd(".../R/Section4_ValidatingPredictions/ValidationResults")
######################################################################
library(xtable)
library(billboarder)
library(classInt)
library(viridis)
library(tmap)
library(sf)

#############################################################
#### TABLE 2 Global absolute relative bias computed using one step ahead predictions

selmodels <- 1:8   
Mod <- NULL
for(mod in selmodels){
  assign(paste0("Mod",mod), read.table(file=paste("Modelo",mod,"val.txt",sep="")))
  Mod=rbind(Mod,get(paste0("Mod",mod)))  
}

##### Relative Bias global
res1 <- aggregate(list(Pred=Mod$casosPred,Obs=Mod$casosO), by=list(mod=Mod$mod), FUN=sum)
res1$Bias <- abs(res1$Pred-res1$Obs)/res1$Obs
res1
globals <- rbind(res1$Bias)
##### Relative Bias / gender
res1 <- aggregate(list(Pred=Mod$casosPred,Obs=Mod$casosO), by=list(sex=Mod$sex,mod=Mod$mod), FUN=sum)
res1$Bias=abs(res1$Pred-res1$Obs)/res1$Obs
res1

table2 <- rbind(globals,res1[res1$sex==1 ,]$Bias,res1[res1$sex==2 ,]$Bias)

colnames(table2) <- c(paste0("M",1:8))
rownames(table2) <- c("Global","Males","Females")

### Copy this table in a LaTeX Editor 
print(xtable(table2,caption ="Global absolute relative bias computed using one step ahead predictions",digits=4), caption.placement = 'top')


################################################################################################
#### Figure 5 Age specific relative biases in one step ahead predictions
#### Note: This Figure 5 should be saved by hand

agelab <- c("Less than 40","40-49","50-59","60-69","70-79","80+")	 
labl <- c("Predictions one period a-head")
mcol <- length(selmodels)

  res <- aggregate(list(Pred=Mod$casosPred,Obs=Mod$casosO), by=list(age=Mod$age,mod=Mod$mod), FUN=sum)
  res$bias <- abs(res$Pred-res$Obs)/res$Obs
  res$modl <- paste0("M",res$mod)
  res$Age_group <- array(0,length(dim(res)[1]))
  for(ag in 1:6){
    res[res$age==ag,]$Age_group <- agelab[ag]
  }
  res
  
  #### We choose the models we want to represent. M5 and M8 in this case
  res <- res[res$modl=="M5" | res$modl=="M8",] 
  

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

carto <- st_read('carto/carto.shp')
carto$region <- c("Gran Bilbao", "North Biscay", "South Biscay", "West Gipuzkoa", "East Gipuzkoa", "Donostia-Bajo Bidasoa", "Alava", "Mid Navarra", "Navarra South", "Navarra North", "Pamplona")

##### Relative Bias
res1=aggregate(list(Pred=Mod$casosPred,Obs=Mod$casosO), by=list(region=Mod$region,mod=Mod$mod), FUN=sum)
res1$BiasRel=abs(res1$Pred-res1$Obs)/res1$Obs

carto$M5 <- res1[res1$mod==5,]$BiasRel
carto$M8 <- res1[res1$mod==8,]$BiasRel


a <- 0
b <- 0.25
breaks <- seq(a,b,by=0.05)

fig6=tm_shape(carto) + 
  tm_polygons(col=c("M5","M8"), breaks=breaks, palette=rev(viridis(5)),
              labels=levels(cut(a:b, breaks=breaks)),
              title ="" , legend.show=T, legend.is.portrait=F) + 
  tm_layout(main.title="Region-specific bias in one step ahead predictions",
            main.title.size=1.3, main.title.position="center",
            legend.outside.position="bottom",
            legend.position = c(0.15, 0.25), 
            legend.text.size=1,
            legend.outside=TRUE,
            panel.labels = c("M5", "M8"),
            panel.label.size=1.5,
            panel.label.bg.color="White",
            frame = FALSE) +
  tm_facets(nrow=1, ncol=2)

tmap_save(fig6,paste0("Fig6.pdf"))

