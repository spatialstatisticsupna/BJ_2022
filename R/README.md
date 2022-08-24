## **R code**

This folder contains the R code to fit and validate all the models described in the paper and to create similar tables and figures. Due to confidentiality issues, a simulated data set is provided to get the results, and then it is not expected to get the same results given in the paper. Note also that, the R version we use here is R-4.2.1 (2022-06-23 ucrt) and the R-INLA version is 22.05.07. Platform: x86_64-w64-mingw32/x64 (64-bit). Running under: Windows 10 x64 (build 14393).

[**Section1_SimulatedDataSet**](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/tree/main/R/Section1_SimulatedDataSet "Section1_SimulatedDataSet")

This folder contains the simulated data file: The **DBrainNA.txt**, used to get the descriptive analysis. This file contains the following information:

-   **sex**: Takes value 1 for males and 2 for females.

-   **age**: Takes values 1 to 18 representing the age-groups 0-4, 5-9, 10-14,..., 70-79, 80-85, and 85+ respectively.

-   **period**: Takes values 1 to 10 representing 1989-1990, 1991-1992, ... , 2007-2008 periods (managed on a biannual basis).

-   **region**: Takes the values 1 to 11 and they represent the following regions of Navarre and Basque Country: 1-Gran Bilbao, 2-North Biscay, 3-South Biscay, 4-West Gipuzkoa, 5-East Gipuzkoa, 6-Donostia-Bajo Bidasoa, 7-Alava, 8-Mid Navarra, 9-Navarra South, 10-Navarra North, 11-Pamplona.

-   **outcome**: Indicates if the observed number of cases are incident cases or deaths (mortality)

-   **cases**: Observed number of incident cases or deaths (detailed by the outcome variable)

-   **pop**: Population at risk in each domain




[**Section2_DescriptiveAnalysis**](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/tree/main/R/Section2_DescriptiveAnalysis "Section2_DescriptiveAnalysis")

The file [DescriptiveAnalysisGraphs.R](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/blob/main/R/Section2_DescriptiveAnalysis/DescriptiveAnalysisGraphs.R "DescriptiveAnalysisGraphs.R") allows to get all the figures presented in *Section 2* of the paper. More precisely. Figures 1 to 4 can be created using the code of this file. The DBrainNA.txt file and the cartography are also provided.

[**Section3_ModelDefinitionFitting**](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/tree/main/R/Section3_ModelDefinitionFitting "Section3_ModelDefinitionFitting")

The [Define_Fit_Models.R](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/blob/main/R/Section3_ModelDefinitionFitting/Define_Fit_Models.R "Define_Fit_Models.R") file contains the code to fit models M1-to-M8 described in  *Section 3* of the paper. Results obtained in Table 1 can be obtained runing the code of this file. It is highly recommended to read the INLA documentation regarding "besag2" model to better understand how Besag2 model for weighted spatial effects should be defined. To do this open Rstudio and run the following code

`library(INLA)`

`inla.doc("besag2")`

The neighbourhood matrix is also provided by the **nc.inla** file.

[**Section4_ValidatingPredictions**](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/tree/main/R/Section4_ValidatingPredictions "Section4_ValidatingPredictions")

This section provides the code to run the validation of gievn in *Section 4* of the paper. First open [Validation_MainFile.R](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/blob/main/R/Section4_ValidatingPredictions/Validation_MainFile.R "Validation_MainFile.R") to

1.  Create data sets for validation. These data sets are stored in folder *DataforValidation*  

2.  Fit all the models in different validation periods. The file [Models.R](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/blob/main/R/Section4_ValidatingPredictions/Models.R "Models.R") will be required in this step. Results will be stored in the *Rdatas* folder

3.  Save the predictions provided by the models in *ValidationResults* folder to analyze afterwards using different assessment measurements.

Secondly, go to *ValidationResults* folder and run the code described in the file [GetValidationResults.R](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/blob/main/R/Section4_ValidatingPredictions/ValidationResults/GetValidationResults.R "GetValidationResults.R") in order to get the results presented in *Section 4* of the paper.

[**Section5_RealDataAnalysis**](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/tree/main/R/Section5_RealDataAnalysis "Section5_RealDataAnalysis")

This folder includes the code to get similar results (with simulated data) as *Section 5* of the paper. Note that in this section model **M8** is considered to provide BCNS cancer incidence predictions in Navarre and the Basque Country by region, age-group, gender and period. The reader can get these results with any other model. To do so, the corresponding Rdata stored in *Section3_ModelDefinitionFitting* should be moved to this folder. Figures and tables of this section can be automatically obtained by running the code described in the file [RealDataAnalisisMainFile.R](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/blob/main/R/Section5_RealDataAnalysis/RealDataAnalisisMainFile.R "RealDataAnalisisMainFile.R"). This file calls to the rest of .R files stored in this folder.
