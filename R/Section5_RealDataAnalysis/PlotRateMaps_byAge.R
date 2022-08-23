
tasae<-result$summary.fitted.values[,c(3,1,5)]
colnames(tasae)=c("ilimc","tasae","isupc")
BrainEstim=data.frame(cbind(DatosBrain,tasae*10^5))

EstimInci=BrainEstim[BrainEstim$outcome=="Incidence",]

#ATGT<-aggregate(EstimInci[,c(5:6,9:11)],
#                by=list(sex=EstimInci$sex,age=EstimInci$age,agno=EstimInci$period,comarca=EstimInci$comarca,outcome=EstimInci$outcome),sum)



ATGT<-aggregate(BrainEstim[,c(6:10)],
                by=list(sex=BrainEstim$sex,age=BrainEstim$age,period=BrainEstim$period,region=BrainEstim$region,outcome=BrainEstim$outcome),sum)

agelabels=c("less than 40","40-49","50-59","60-69","70-79","80+")
nregiones=11
nclr <- 6
plotclr <- c("#EBF0FA", "#ADC2EB" ,"#7094DB" ,"#3366CC", "#1F3D7A",  "#0F1F3D")
cex.main=2
yearslab=c("1989-1990","1991-1992","1993-1994","1995-1996","1997-1998","1999-2000","2001-2002","2003-2004","2005-2006","2007-2008")
lagnos=unique(ATGT$period)

nclr <- 6
fixedBreaks=c(seq(0,196,by=28))
class <-  classIntervals(ATGT$tasae,nclr,fixedBreaks=fixedBreaks, style="fixed",dataPrecision=0) #,
class
ATGT$colcode=findColours(class, plotclr)
colcode=ATGT$colcode



for(ag in 2:6){
  ATG=ATGT[ATGT$age==ag,]
  

  ##############################################
  carto$spi1H=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==lagnos[1],]$colcode    
  carto$spi2H=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==lagnos[2],]$colcode    
  carto$spi3H=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==lagnos[3],]$colcode    
  carto$spi4H=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==lagnos[4],]$colcode    
  carto$spi5H=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==lagnos[5],]$colcode    
  carto$spi6H=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==lagnos[6],]$colcode    
  carto$spi7H=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==lagnos[7],]$colcode    
  carto$spi8H=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==lagnos[8],]$colcode    
  carto$spi9H=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==lagnos[9],]$colcode    
  carto$spi10H=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==lagnos[10],]$colcode  
  
  carto$spi1M=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==lagnos[1],]$colcode      
  carto$spi2M=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==lagnos[2],]$colcode      
  carto$spi3M=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==lagnos[3],]$colcode      
  carto$spi4M=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==lagnos[4],]$colcode      
  carto$spi5M=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==lagnos[5],]$colcode      
  carto$spi6M=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==lagnos[6],]$colcode      
  carto$spi7M=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==lagnos[7],]$colcode      
  carto$spi8M=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==lagnos[8],]$colcode      
  carto$spi9M=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==lagnos[9],]$colcode      
  carto$spi10M=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==lagnos[10],]$colcode    
  
  
  #####################################################################

  plotvarTHi <- cbind(carto$spi1H,carto$spi2H,carto$spi3H,carto$spi4H,carto$spi5H,carto$spi6H,carto$spi7H,
                      carto$spi8H,carto$spi9H,carto$spi10H)
  
  plotvarTMi <- cbind(carto$spi1M,carto$spi2M,carto$spi3M,carto$spi4M,carto$spi5M,carto$spi6M,carto$spi7M,
                      carto$spi8M,carto$spi9M,carto$spi10M)

  pdf(paste0("Mod_8_Spatial_rates_AgeGroup",ag,".pdf"), width=13,height=6)
  mat=t(matrix(c(1,2,3),ncol=1,nrow=3))
  par(adj=0.5)
  layout(mat, widths =c(rep(1,2),0.4),heights = 1) 
  lagnoslab=c("1989-1990","1991-1992","1993-1994","1995-1996","1997-1998","1999-2000","2001-2002","2003-2004","2005-2006","2007-2008")
  carto<-readShapePoly("carto/carto")
  

  for(n in 1:8){
plot(carto)
    plot(carto, col=plotvarTHi[,n] , add=T)
    title(main=paste("Males", agelabels[ag], "\n",lagnoslab[n]),line=-5, cex.main = cex.main)
    plot(carto)
    plot(carto, col=plotvarTMi[,n], add=T)
    title(main=paste("Females", agelabels[ag], "\n",lagnoslab[n]),line=-5, cex.main = cex.main)
    plot.new()
    legend("center", ncol =1, legend=names(attr(colcode, "table")),fill=attr(colcode, "palette"), bty="n", cex=2.2)  
  }
  
  for(n in 9:10){
    plot(carto)
    plot(carto, col=plotvarTHi[,n] , add=T)
    title(main=paste("Prediction for males", agelabels[ag], "\n",lagnoslab[n]),line=-5, cex.main = cex.main)
    plot(carto)
    plot(carto, col=plotvarTMi[,n], add=T)
    title(main=paste("Prediction for females", agelabels[ag], "\n",lagnoslab[n]),line=-5, cex.main = cex.main)
    plot.new()
    legend("center", ncol =1, legend=names(attr(colcode, "table")),fill=attr(colcode, "palette"), bty="n", cex=2.2)  
  }
  
  dev.off()
}



plotclr <- c("#ecf9ec", "#8cd98c" ,"#40bf40" ,"#339933", "#194d19",  "#061306")

fixedBreaks=c(seq(0,48,by=8))
class <-  classIntervals(ATGT$tasae,nclr,fixedBreaks=fixedBreaks, style="fixed",dataPrecision=0) #,
class
ATGT$colcode=findColours(class, plotclr)
colcode=ATGT$colcode


for(ag in 1){
  ATG=ATGT[ATGT$age==ag,]
  
  
  ##############################################
  carto$spi1H=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==lagnos[1],]$colcode    
  carto$spi2H=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==lagnos[2],]$colcode    
  carto$spi3H=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==lagnos[3],]$colcode    
  carto$spi4H=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==lagnos[4],]$colcode    
  carto$spi5H=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==lagnos[5],]$colcode    
  carto$spi6H=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==lagnos[6],]$colcode    
  carto$spi7H=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==lagnos[7],]$colcode    
  carto$spi8H=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==lagnos[8],]$colcode    
  carto$spi9H=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==lagnos[9],]$colcode    
  carto$spi10H=ATG[ATG$outcome=="Incidence" & ATG$sex==1 & ATG$period==lagnos[10],]$colcode  
  
  carto$spi1M=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==lagnos[1],]$colcode      
  carto$spi2M=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==lagnos[2],]$colcode      
  carto$spi3M=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==lagnos[3],]$colcode      
  carto$spi4M=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==lagnos[4],]$colcode      
  carto$spi5M=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==lagnos[5],]$colcode      
  carto$spi6M=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==lagnos[6],]$colcode      
  carto$spi7M=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==lagnos[7],]$colcode      
  carto$spi8M=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==lagnos[8],]$colcode      
  carto$spi9M=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==lagnos[9],]$colcode      
  carto$spi10M=ATG[ATG$outcome=="Incidence" & ATG$sex==2 & ATG$period==lagnos[10],]$colcode    
  
  
  #####################################################################
  
  plotvarTHi <- cbind(carto$spi1H,carto$spi2H,carto$spi3H,carto$spi4H,carto$spi5H,carto$spi6H,carto$spi7H,
                      carto$spi8H,carto$spi9H,carto$spi10H)
  
  plotvarTMi <- cbind(carto$spi1M,carto$spi2M,carto$spi3M,carto$spi4M,carto$spi5M,carto$spi6M,carto$spi7M,
                      carto$spi8M,carto$spi9M,carto$spi10M)
  
  pdf(paste0("Mod_8_Spatial_rates_AgeGroup",ag,".pdf"), width=13,height=6)
  mat=t(matrix(c(1,2,3),ncol=1,nrow=3))
  par(adj=0.5)
  layout(mat, widths =c(rep(1,2),0.4),heights = 1) 
  lagnoslab=c("1989-1990","1991-1992","1993-1994","1995-1996","1997-1998","1999-2000","2001-2002","2003-2004","2005-2006","2007-2008")
  carto<-readShapePoly("carto/carto")
  
  
  for(n in 1:8){
    plot(carto)
    plot(carto, col=plotvarTHi[,n] , add=T)
    title(main=paste("Males", agelabels[ag], "\n",lagnoslab[n]),line=-5, cex.main = cex.main)
    plot(carto)
    plot(carto, col=plotvarTMi[,n], add=T)
    title(main=paste("Females", agelabels[ag], "\n",lagnoslab[n]),line=-5, cex.main = cex.main)
    plot.new()
    legend("center", ncol =1, legend=names(attr(colcode, "table")),fill=attr(colcode, "palette"), bty="n", cex=2.2)  
  }
  
  for(n in 9:10){
    plot(carto)
    plot(carto, col=plotvarTHi[,n] , add=T)
    title(main=paste("Prediction for males", agelabels[ag], "\n",lagnoslab[n]),line=-5, cex.main = cex.main)
    plot(carto)
    plot(carto, col=plotvarTMi[,n], add=T)
    title(main=paste("Prediction for females", agelabels[ag], "\n",lagnoslab[n]),line=-5, cex.main = cex.main)
    plot.new()
    legend("center", ncol =1, legend=names(attr(colcode, "table")),fill=attr(colcode, "palette"), bty="n", cex=2.2)  
  }
  
  dev.off()
}