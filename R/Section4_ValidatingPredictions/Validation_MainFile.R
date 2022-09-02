#Using mortality to predict incidence for rare and lethal cancers
#in very small areas. Biometrical Journal (2022)
# Author: Jaione Etxeberria 
# This code is developed in R-4.2.1 version

#rm(list=ls())
#setwd(".../R/Section4_ValidatingPredictions")
######################################################################
library(INLA)
inla.setOption(inla.mode="experimental")


#### Load the data
Brain <- read.table("DBrain.txt") #### Read the complete data set 



# STEP 1) GENERATE DATA SETS FOR VALIDATION (Saved in DataforValidation folder)

#### First we generate new data sets (with and without missing values) to fit the models in different 
# sub periods. This will allow us to compare the predictions vs observed

# First validation period 1989_1990 (ag=1) to 1995_1996 (ag=4) 
# Second validation period 1989_1990 (ag=1) to 1997_1998 (ag=5)
# So on
yearslab <- c("1989_1990","1991_1992","1993_1994","1995_1996","1997_1998",
           "1999_2000","2001_2002","2003_2004","2005_2006","2007_2008")
for(ag in 4:10){
      DatosBrain <- Brain[Brain$period<=ag,]
      DatosBrainNA <- DatosBrain
      DatosBrainNA[DatosBrainNA$period>c(ag-1) & DatosBrainNA$outcome=="Incidence",]$cases=NA
      write.table(DatosBrainNA, file=paste("DataforValidation/DatosBrainUNO",yearslab[ag],"ConNA.txt",sep="")) ## Generates data sets with NA
      write.table(DatosBrain, file=paste("DataforValidation/DatosBrainUNO",yearslab[ag],"SinNA.txt",sep="")) ## Generates data sets without NA
}

# STEP 2) FIT THE MODELS (Saved in Rdatas folder)

#### Once the different data set are generated and saved, a set of selected models will be fitted in 
## the different sub period (IT TAKES TIME)


selmodels <- 1:8  ##### In this case we select all the models 1 to 8 for validation. 

#### In this loop all the models will be fitted in the different sub period and all the R.datas will be saved 
# as follows Modelo1_1995_1996.Rdata means M1 is fitted in the period 1989_1990 to 1995_1996. 

for(mod in selmodels){
  for(ag in 4:10){
      DBrain <- read.table(file=paste("DataforValidation/DatosBrainUNO",yearslab[ag],"ConNA.txt",sep=""))   
      source("Models.R")
      save.image(paste0("Rdatas/Modelo",mod,"_",yearslab[ag],".Rdata"))
      rm(list=c("res",paste0("result",mod)))
  }
}



# STEP 3) SAVE THE RESULTS (Saved in ValidationResults folder)
#### We save in a new .txt files the observed vs the predicted incidence counts by period
# Note that incidence data are available up to 2005_2006 (ag=8). 
#Therefore we validate results up to 2005_2006 (ag=8)

InciOrigin <- Brain[Brain$outcome=="Incidence",]
for(mod in selmodels){
  valfinal <- NULL  
      for(ag in 4:8){
        PredHasta <- yearslab[ag]
        load(paste("Rdatas/Modelo",mod,"_",PredHasta,".Rdata",sep=""))
        casosPred <- ceiling((res$summary.fitted.values$`0.5quant`)*DBrain$pop)
        Predictions <- cbind(DBrain,casosPred)
        Pred <- Predictions[Predictions$period==ag & Predictions$outcome=="Incidence",]
        casosO <- InciOrigin[InciOrigin$period==ag,]$cases
        valfinal <- rbind(valfinal,cbind(Pred,casosO,PredHasta,mod))
      }
write.table(valfinal,file=paste("ValidationResults/Modelo",mod,"val.txt",sep="")) 
}



##### Results not shown in the paper

#### Check the results of the models in terms of DIC, WAIC, ETC..
# 
#  yearslab=c("1989_1990","1991_1992","1993_1994","1995_1996","1997_1998","1999_2000","2001_2002","2003_2004","2005_2006","2007_2008")
# 
#  selmodels=1:8
#  medidas=NULL
#  for(mod in selmodels){
#    med=NULL
#    for(ag in 4:8){
#      PredHasta=yearslab[ag]
#      load(paste("Rdatas/Modelo",mod,"_",PredHasta,".Rdata",sep=""))
#      lgsc=res$cpo$cpo
#      LogScore=mean(-log(lgsc[!(is.na(lgsc))]))
#      DIC=res$dic$dic
#      WAIC=res$waic$waic
#      med=rbind(med,cbind(DIC,WAIC,LogScore,pred=ag,mod))
#    }
#    medidas=rbind(medidas,med)
#  }
#  medidas=data.frame(medidas)
# tabn=medidas[order(medidas$pred),]
# 
# tabn


