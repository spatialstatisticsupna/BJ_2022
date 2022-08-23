## **R code**

This folder contains the R code to reproduce all the models, tables and figures presented in the paper. Due to confidentiality issues, a simulated data set is provided to reproduce the results. Note that, The R software version used was R-4.2.1 (2022-06-23 ucrt) and the R-INLA version 22.05.07. Platform: x86_64-w64-mingw32/x64 (64-bit). Running under: Windows 10 x64 (build 14393)

[**Section1_SimulatedDataSet**](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/tree/main/R/Section1_SimulatedDataSet "Section1_SimulatedDataSet")

This folder contains two simulated data files: The **DBrainNA.txt**, used to reproduce the descriptive analysis. This file contains the following information:

-   **sex**: Takes value 1 for males and 2 for females.

-   **age**: Takes values 1 to 18 representing the age-groups 0-4, 5-9, 10-14,..., 70-79, 80-85, and 85+ respectively.

-   **period**: Takes values 1 to 10 representing 1989-1990, 1991-1992, ... , 2007-2008 periods (managed on a biannual basis).

-   **region**: Takes the values 1 to 11 and they represent the following regions of Navarre and Basque Country: 1-Gran Bilbao, 2-North Biscay, 3-South Biscay, 4-West Gipuzkoa, 5-East Gipuzkoa, 6-Donostia-Bajo Bidasoa, 7-Alava, 8-Mid Navarra, 9-Navarra South, 10-Navarra North, 11-Pamplona.

-   **cases**: Observed number of incident cases or deaths (detailed by the outcome variable)

-   **pop**: Population at risk in each domain

-   **outcome**: Indicates if the observed number of cases are incident cases or deaths (mortality)

The **DBrain.txt** is an aggregated version of the previous data set in which the age-groups are aggregated in 6 age-groups. The rest of the variables are equally defined as in **DBrainNA.txt** file. This file is used to define and fit the proposed models.

-   **sex**: Takes value 1 for males and 2 for females.

-   **age**: Takes values 1 to 6 representing the age-groups \<40, 40-49, 50-59, 60-69, 70-79, and 80+ respectively.

-   **period**: Takes values 1 to 10 representing 1989-1990, 1991-1992, ... , 2007-2008 periods (managed on a biannual basis).

-   **region**: Takes the values 1 to 11 and they represent the following regions of Navarre and Basque Country: 1-Gran Bilbao, 2-North Biscay, 3-South Biscay, 4-West Gipuzkoa, 5-East Gipuzkoa, 6-Donostia-Bajo Bidasoa, 7-Alava, 8-Mid Navarra, 9-Navarra South, 10-Navarra North, 11-Pamplona.

-   **cases**: Observed number of incident cases or deaths (detailed by the outcome variable)

-   **pop**: Population at risk in each domain

-   **outcome**: Indicates if the observed number of cases are incident cases or deaths (mortality)

[**Section2_DescriptiveAnalysis**](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/tree/main/R/Section2_DescriptiveAnalysis "Section2_DescriptiveAnalysis")

The file [DescriptiveAnalysisGraphs.R](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/blob/main/R/Section2_DescriptiveAnalysis/DescriptiveAnalysisGraphs.R "DescriptiveAnalysisGraphs.R") allows to reproduce all the figures presented in the section 2 BCNS incidence and mortality data from northern Spain of the paper. More precisely. Figure 1 to 4 can be reproduce using the code of this file. DBrainNA.txt file and the cartography are also provided.

[**Section3_ModelDefinitionFitting**](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/tree/main/R/Section3_ModelDefinitionFitting "Section3_ModelDefinitionFitting")

The [Define_Fit_Models.R](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/blob/main/R/Section3_ModelDefinitionFitting/Define_Fit_Models.R "Define_Fit_Models.R") file contains the code to fit models M1-to-M8 described in the *Section 3 Models to predict cancer incidence using mortality data* of the paper. Results obtained in Table 1 can be reproduce runing the coda of this file. It is highly recommended to read the INLA documentation regarding "besag2" model to better understand how Besag2 model for weighted spatial effects should be defined. To do this open Rstudio and run the following code

`library(INLA)`

`inla.doc("besag2")`

The neighbourhood matrix is also provided by the **nc.inla** file.

[**Section4_ValidatingPredictions**](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/tree/main/R/Section4_ValidatingPredictions "Section4_ValidatingPredictions")

In this section the the predictive ability of all the models can be assesed as the code to reproduce and compute the one step ahead predictions is provided. First open [Validation_MainFile.R](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/blob/main/R/Section4_ValidatingPredictions/Validation_MainFile.R "Validation_MainFile.R") to

1.  Generate data sets for validation. These data sets are saved at *DataforValidation* folder

2.  Fit all the models in different validation periods. The file [Models.R](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/blob/main/R/Section4_ValidatingPredictions/Models.R "Models.R") will be required in this step. Results will be store in the *Rdatas* folder

3.  Save the predictions provided by the models in *ValidationResults* folder to analyze afterwards using different assessment measurements.

Secondly, go to *ValidationResults* folder and run the code described in the file [GetValidationResults.R](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/blob/main/R/Section4_ValidatingPredictions/ValidationResults/GetValidationResults.R "GetValidationResults.R") in order to get the results presented in *Section 4 Validating cancer incidence predictions*

[**Section5_RealDataAnalysis**](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/tree/main/R/Section5_RealDataAnalysis "Section5_RealDataAnalysis")

In this folder, the results illustrated in *Section 5 Real data analysis* can be reproduce. Note that in this section model **M8** is considered to provide BCNS cancer incidence predictions in Navarre and the Basque Country by region, age-group, gender and period. The reader can reproduce this results with any other model. To do so, the corresponding Rdata stored in *Section3_ModelDefinitionFitting* should be moved to this folder. Figures and tables of this section can be automatically reproduce running the code described in the file [RealDataAnalisisMainFile.R](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/blob/main/R/Section5_RealDataAnalysis/RealDataAnalisisMainFile.R "RealDataAnalisisMainFile.R"). This file call to the rest of .R files stored in this folder.
