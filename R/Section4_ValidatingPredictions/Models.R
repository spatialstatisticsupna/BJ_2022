### Fit the models


y <- DBrain$cases
pop <- DBrain$pop
age <- DBrain$age
period <- DBrain$period


#### Upload the graph to define the spatial shared component term
g <- inla.read.graph("nc.inla") 

#### Create the graph to define the shared component term for period in M7
kt <- length(unique(DBrain$period))
D1 <- diff(diag(kt),differences=1) 
P.RW1 <- t(D1)%*%D1  
gperiod <- inla.read.graph(P.RW1)  

#### Create the graph to define the shared component term for age in M8
kt <- length(unique(DBrain$age))
D1 <- diff(diag(kt),differences=1) 
P.RW1 <- t(D1)%*%D1  
gage <- inla.read.graph(P.RW1)   


#### Prior distributions on the precision parameters
# Improper uniform priors on the standard deviations

sdunif <- "expression:
logdens=-log_precision/2;
return(logdens)"

# PC-priors
pcprec <- list(theta=list(prior='pc.prec', param=c(1,0.01)))
priorselec <- pcprec 

#### Index definition 
##Create a gender-specific index for the spatial shared component term
N <- length(unique(DBrain$region))
i <- array(0,dim(DBrain)[1])
i1 <- which(DBrain$outcome=="Incidence")
i2 <- which(DBrain$outcome=="Mortality")

i[i1] <- DBrain$region[i1]
i[i2] <- DBrain$region[i2]+N

imale <- i
imale[which(DBrain$sex==2)] <- NA
ifemale <- i
ifemale[which(DBrain$sex==1)] <- NA

## Create an index for the age shared component term
A <- length(unique(DBrain$age))
iage <- array(0,dim(DBrain)[1])
iage[i1] <- DBrain$age[i1]
iage[i2] <- DBrain$age[i2]+A

##Create an index for the period shared component term
P <- length(unique(DBrain$period))
iperiod <- array(0,dim(DBrain)[1])
iperiod[i1] <- DBrain$period[i1]
iperiod[i2] <- DBrain$period[i2]+P

## Create a disease-specific index
disease <- array(0,dim(DBrain)[1])
disease[i1] <- 1
disease[i2] <- 2

## Create a gender-specific index
k <- DBrain$sex

#### Create an index for incidence specific spatial unstructured term
i_inci_het <- DBrain$region
i_inci_het[i2] <- NA



##### Model definition
#M1
formula1 <- y~ f(imale, model="besag2", graph=g, constr=T, hyper=priorselec,scale.model = TRUE) + 
  f(ifemale, model="besag2", constr =T, graph=g,hyper=priorselec,scale.model = TRUE)+
  f(age, model="rw1",hyper=priorselec,constr=T,scale.model = TRUE)+
  f(period, model="rw1",hyper=priorselec,constr=T,scale.model = TRUE)
#M2
formula2 <- y~ f(imale, model="besag2", graph=g, constr=T, hyper=priorselec,scale.model = TRUE) + 
  f(ifemale, model="besag2", constr =T, graph=g,hyper=priorselec,scale.model = TRUE)+
  f(age, model="rw1",hyper=priorselec,constr=T,scale.model = TRUE)+
  f(period, model="rw1",hyper=priorselec,constr=T,replicate=k,scale.model = TRUE)
#M3
formula3 <- y~ f(imale, model="besag2", graph=g, constr=T, hyper=priorselec,scale.model = TRUE) + 
  f(ifemale, model="besag2", constr =T, graph=g,hyper=priorselec,scale.model = TRUE)+
  f(age, model="rw1",hyper=priorselec,constr=T,replicate=disease,scale.model = TRUE)+
  f(period, model="rw1",hyper=priorselec,constr=T,scale.model = TRUE)
#M4
formula4 <- y~ f(imale, model="besag2", graph=g, constr=T, hyper=priorselec,scale.model = TRUE) + 
  f(ifemale, model="besag2", constr =T, graph=g,hyper=priorselec,scale.model = TRUE)+
  f(age, model="rw1",hyper=priorselec,constr=T,replicate=k,scale.model = TRUE)+
  f(period, model="rw1",hyper=priorselec,constr=T,replicate=k,scale.model = TRUE)
#M5
formula5 <- y~ f(imale, model="besag2", graph=g, constr=T, hyper=priorselec,scale.model = TRUE) + 
  f(ifemale, model="besag2", constr =T, graph=g,hyper=priorselec,scale.model = TRUE) +
  f(age, model="rw1",hyper=priorselec,constr=T,replicate=disease,scale.model = TRUE) +
  f(period, model="rw1",hyper=priorselec,constr=T,replicate=k,scale.model = TRUE)
#M6
formula6 <- y~ f(imale, model="besag2", graph=g, constr=T, hyper=priorselec,scale.model = TRUE) + 
  f(ifemale, model="besag2", constr =T, graph=g,hyper=priorselec,scale.model = TRUE) +
  f(iage, model="besag2", constr=T, graph=gage, hyper=priorselec,scale.model = TRUE) +
  f(period, model="rw1",hyper=priorselec,constr=T,replicate=k,scale.model = TRUE) 
#M7
formula7 <- y~ f(imale, model="besag2", graph=g, constr=T, hyper=priorselec,scale.model = TRUE) + 
  f(ifemale, model="besag2", constr =T, graph=g,hyper=priorselec,scale.model = TRUE) +
  f(iperiod, model="besag2", constr =T, graph=gperiod,hyper=priorselec,scale.model = TRUE) +
  f(age, model="rw1",hyper=priorselec,constr=T,scale.model = TRUE) 
#M8
formula8 <- y~ f(imale, model="besag2", graph=g, constr=T, hyper=priorselec,scale.model = TRUE) + 
  f(ifemale, model="besag2", constr =T, graph=g,hyper=priorselec,scale.model = TRUE) +
  f(i_inci_het, model="iid",hyper=priorselec) +
  f(iage, model="besag2", constr=T, graph=gage, hyper=priorselec,scale.model = TRUE) +
  f(period, model="rw1",hyper=priorselec,constr=T,replicate=k,scale.model = TRUE) 




#### Fit and check the results of all the models 1-to-8
  formula <- get(paste0("formula",mod))
  res <- inla(formula, family = "poisson",
           data = data.frame(pop,y,imale,ifemale,k,disease,period,iperiod,age,iage,i_inci_het), E=pop,
           control.compute=list(dic=TRUE, cpo=TRUE,waic=TRUE, hyperpar=TRUE, mlik=TRUE),
           control.inla=list(verbose = F),
           control.predictor = list(link=1,compute=TRUE))
  assign(paste0("result",mod),res)


