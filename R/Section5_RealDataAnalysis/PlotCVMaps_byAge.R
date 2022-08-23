


cv<-result$summary.fitted.values[,2]/result$summary.fitted.values[,1]
tasas=result$summary.fitted.values[,1:2]
BrainEstim=data.frame(cbind(DatosBrain,cv,tasas))
ATGT=BrainEstim[BrainEstim$outcome=="Incidence",]
agelabels=c("less than 40","40-49","50-59","60-69","70-79","80+")
nregiones=11
nclr <- 4
plotclr <- brewer.pal(9, "Greens")[c(4,6,8,9)]
cex.main=2
yearslab=c("1989-1990","1991-1992","1993-1994","1995-1996","1997-1998","1999-2000","2001-2002","2003-2004","2005-2006","2007-2008")
lagnos=unique(ATGT$period)

cut(ATGT$cv,5)

fixedBreaks=c(0.06,0.5,0.9,1.8,2.2)
class <-  classIntervals(ATGT$cv,nclr,fixedBreaks=fixedBreaks, style="fixed") #,
class
ATGT$colcode=findColours(class, plotclr)
colcode=ATGT$colcode


pdf(paste0("Mod_8_Spatial_cv_by_age.pdf"), width=15,height=8)

mat=t(matrix(c(1,2),ncol=1,nrow=2))
par(adj=0.5,mar = rep(0,4))
layout(mat, widths = c(rep(1,2)) ,heights =1) 
#layout.show(n=3)
lagnoslab=c("1989-1990","1991-1992","1993-1994","1995-1996","1997-1998","1999-2000","2001-2002","2003-2004","2005-2006","2007-2008")
carto<-readShapePoly("carto/carto")

n=10  ### We only represent the cv for "2007-2008" predictions

for(ag in 1:6){
  
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
  
  
  plot(carto)
  plot(carto, col=plotvarTHi[,n] , add=T)
  title(main=paste("CV for males", agelabels[ag], "\n",lagnoslab[n]),line=-5, cex.main = cex.main)
      
  plot(carto)
  plot(carto, col=plotvarTMi[,n], add=T)
  title(main=paste("CV for females", agelabels[ag], "\n",lagnoslab[n]),line=-5, cex.main = cex.main)

}

par(mfrow=c(1,1))
plot.new()
legend("center", ncol=4, legend=names(attr(colcode, "table")),fill=attr(colcode, "palette"), bty="n", cex=cex.main+0.5)  

  
  dev.off()


