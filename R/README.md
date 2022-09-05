
## **R CODE**

This folder contains the R code to fit and validate all the models described in the paper and to create similar tables and figures. Due to confidentiality issues, a simulated data set is provided to get the results, and then it is not expected to get the same results given in the paper. The code of this paper is organized in self-contained folders, which are named according to the sections of the paper they represent. The folders are the following

### [**Section2_DescriptiveAnalysis**](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/tree/main/R/Section2_DescriptiveAnalysis "Section2_DescriptiveAnalysis")

This folder contains the simulated data file: The **DBrainNA.txt** used to get the descriptive analysis. This file contains the following information:

-   **sex**: Takes value 1 for males and 2 for females.

-   **age**: Takes values 1 to 18 representing the age groups 0-4, 5-9, 10-14,..., 70-79, 80-85, and 85+ respectively.

-   **period**: Takes values 1 to 10 representing the periods 1989-1990, 1991-1992, ... , 2007-2008 (managed on a biannual basis).

-   **region**: Takes the values 1 to 11 for the following regions of Navarre and Basque Country: 1-Gran Bilbao, 2-North Biscay, 3-South Biscay, 4-West Gipuzkoa, 5-East Gipuzkoa, 6-Donostia-Bajo Bidasoa, 7-Alava, 8-Mid Navarra, 9-Navarra South, 10-Navarra North, 11-Pamplona.

-   **outcome**: Indicates if the observed number of cases are incident cases or deaths (mortality)

-   **cases**: Observed number of incident cases or deaths (detailed by the outcome variable)

-   **pop**: Population at risk in each domain

The file [**DescriptiveAnalysisGraphs.R**](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/blob/main/R/Section2_DescriptiveAnalysis/DescriptiveAnalysisGraphs.R "DescriptiveAnalysisGraphs.R") allows to get and save all the figures presented in *Section 2* of the paper. More precisely, Figures 1 to 4 are created and saved using the code of this file:

-   **Figure 1:** Regions in Navarre and Basque Country

-   **Figure 2:** Age and gender-specific incidence and mortality rates during the study period.

-   **Figure 3:** Crude incidence and mortality rates trends by gender

-   **Figure 4:** Crude incidence and mortality rates by region for both genders (top panels and saved as **Fig4_1**) and scatter plot of incidence and mortality rates by region (bottom panel and saved as **Fig4_2**)

Finally, the cartographic boundary files are also provided in the folder ***carto.***

### [**Section3_ModelDefinitionFitting**](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/tree/main/R/Section3_ModelDefinitionFitting "Section3_ModelDefinitionFitting")

The [**Define_Fit_Models.R**](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/blob/main/R/Section3_ModelDefinitionFitting/Define_Fit_Models.R "Define_Fit_Models.R") file contains the code to get the file **DBrain.txt** with the aggregated six age groups used in the analysis, and to fit models M1-to-M8 described in *Section 3* of the paper. It is highly recommended to read the INLA documentation regarding "besag2" model to better understand how Besag2 model for weighted spatial effects should be defined. To do this, open Rstudio and run the following code

`library(INLA)`

`inla.doc("besag2")`

The neighborhood matrix is also provided by the **nc.inla** file.

Similar results obtained in Table 1 and 4 can be obtained running the code of this file. The code also allows getting the tables in LaTeX format

-   **Table 1:** Model selection criteria.

-   **Table 4 (in the Appendix):** Model selection criteria and predictive ability for the different models.

### [**Section4_ValidatingPredictions**](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/tree/main/R/Section4_ValidatingPredictions "Section4_ValidatingPredictions")

This section provides the code to run the validation of given in *Section 4* of the paper. First open [**Validation_MainFile.R**](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/blob/main/R/Section4_ValidatingPredictions/Validation_MainFile.R "Validation_MainFile.R") to

1.  Create data sets for validation. These data sets are stored in folder *DataforValidation*

2.  Fit all the models in different validation periods. The file [Models.R](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/blob/main/R/Section4_ValidatingPredictions/Models.R "Models.R") will be required in this step. Results will be stored in the *Rdatas* folder. Note that, the fit of the Models 1-to-8 thorough the different validation periods are already stored in the *Rdatas* folder therefore the user do not need to run all the code to get Tables 1 and 4, but simply load these .Rdatas using the code of the next step.

3.  Save the predictions provided by the models in the *ValidationResults* folder to analyze afterwards using different assessment measurements. These results are automatically saved as *Modelo1val.txt*, ..., *Modelo8val.txt.* Note that, the user do not need to save these files as there are already provided.

Secondly, **go to *ValidationResults* folder** and run the code described in the file [**GetValidationResults.R**](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/blob/main/R/Section4_ValidatingPredictions/ValidationResults/GetValidationResults.R "GetValidationResults.R") in order to get the results presented in *Section 4* of the paper. More precisely, the following Figures and Tables can be generated and saved using the code of this file:

-   **Table 2** Global absolute relative bias computed using one step ahead predictions

-   **Figure 5** Age specific relative biases in one step ahead predictions. *Note that, this figure should be saved manually*.

-   **Figure 6** Region specific relative biases in one step ahead predictions

### [**Section5_RealDataAnalysis**](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/tree/main/R/Section5_RealDataAnalysis "Section5_RealDataAnalysis")

This folder includes the code to get similar results as in *Section 5* of the paper but using the simulated data. In this section model **M8** is considered to provide BCNS cancer incidence predictions in Navarre and the Basque Country by region, age-group, gender and period. The reader can get similar results with any other model. To do so, the corresponding Rdata (*Model1.Rdata, ... ,Model7.Rdata*) stored in *Section3_ModelDefinitionFitting* should be moved to this folder. Figures and tables of this section can be automatically obtained by running the code described in the file [**RealDataAnalisisMainFile.R**](https://github.com/spatialstatisticsupna/Biometrical_Journal_2022/blob/main/R/Section5_RealDataAnalysis/RealDataAnalisisMainFile.R "RealDataAnalisisMainFile.R"). More precisely, the following outputs are generated

-   **Table 3** Observed versus Predicted number of Brain Cancer incidence cases per period

-   **Figure 7** Gender-specific temporal trends and predicted rates for 2005-06 and 2007-08 obtained with M8

-   **Figure 8** Maps of predicted incidence rates for age groups \< 40 (**Fig8_1**), 40 - 49 (**Fig8_2**) and, 50 - 59 (**Fig8_3**) for 2007-2008 period for the 11 health regions. Note that the rate scale used for \< 40 is different from that used for 40 - 49 and, 50 - 59. *These figures are merged in a LaTeX editor*.

-   **Figure 9** Maps of predicted incidence rates for age groups 60 - 69 (**Fig9_1**), 70 - 79 (**Fig9_2**) and 80+ (**Fig9_3**) for 2007-2008 period for the 11 health regions. *These figures are merged in a LaTeX editor*.

-   **Figure 11** Coefficients of variation by regions and age-groups obtained as the posterior standard deviation of the rates divided by the posterior mean.

Finally, the data set **DBrain.txt** and the cartographic boundary files are also provided in the folder ***carto.***

## R SESSION AND R PACKAGES. VERSION INFO

``` r
R version 4.2.1 (2022-06-23 ucrt)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 10 x64 (build 17763)

Matrix products: default

Random number generation:
 RNG:     Mersenne-Twister 
 Normal:  Inversion 
 Sample:  Rounding 
 
locale:
[1] LC_COLLATE=Spanish_Spain.1252  LC_CTYPE=Spanish_Spain.1252    LC_MONETARY=Spanish_Spain.1252
[4] LC_NUMERIC=C                   LC_TIME=Spanish_Spain.1252    

attached base packages:
[1] parallel  stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
 [1] billboarder_0.3.1  xtable_1.8-4       INLA_22.05.07      foreach_1.5.2      Matrix_1.4-1      
 [6] sp_1.5-0           Hmisc_4.7-1        Formula_1.2-4      survival_3.3-1     lattice_0.20-45   
[11] ggrepel_0.9.1      ggplot2_3.3.6      viridis_0.6.2      viridisLite_0.4.1  tmap_3.3-3        
[16] sf_1.0-8           RColorBrewer_1.1-3 classInt_0.4-7    

loaded via a namespace (and not attached):
 [1] tools_4.2.1         backports_1.4.1     utf8_1.2.2          R6_2.5.1            rpart_4.1.16       
 [6] KernSmooth_2.23-20  DBI_1.1.3           colorspace_2.0-3    nnet_7.3-17         raster_3.5-29      
[11] withr_2.5.0         gridExtra_2.3       leaflet_2.1.1       compiler_4.2.1      leafem_0.2.0       
[16] cli_3.3.0           htmlTable_2.4.1     labeling_0.4.2      scales_1.2.1        checkmate_2.1.0    
[21] proxy_0.4-27        stringr_1.4.1       digest_0.6.29       foreign_0.8-82      rmarkdown_2.16     
[26] base64enc_0.1-3     dichromat_2.0-0.1   jpeg_0.1-9          pkgconfig_2.0.3     htmltools_0.5.3    
[31] fastmap_1.1.0       htmlwidgets_1.5.4   rlang_1.0.5         rstudioapi_0.14     shiny_1.7.2        
[36] farver_2.1.1        jsonlite_1.8.0      crosstalk_1.2.0     magrittr_2.0.3      interp_1.1-3       
[41] Rcpp_1.0.9          munsell_0.5.0       fansi_1.0.3         abind_1.4-5         lifecycle_1.0.1    
[46] terra_1.6-7         stringi_1.7.8       leafsync_0.1.0      yaml_2.3.5          tmaptools_3.1-1    
[51] grid_4.2.1          promises_1.2.0.1    deldir_1.0-6        stars_0.5-6         splines_4.2.1      
[56] knitr_1.40          pillar_1.8.1        codetools_0.2-18    XML_3.99-0.10       glue_1.6.2         
[61] evaluate_0.16       latticeExtra_0.6-30 data.table_1.14.2   png_0.1-7           vctrs_0.4.1        
[66] httpuv_1.6.5        MatrixModels_0.5-0  gtable_0.3.1        xfun_0.32           mime_0.12          
[71] lwgeom_0.2-8        e1071_1.7-11        later_1.3.0         class_7.3-20        tibble_3.1.8       
[76] iterators_1.0.14    units_0.8-0         cluster_2.1.3       ellipsis_0.3.2   
```

