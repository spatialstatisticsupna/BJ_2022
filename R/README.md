## **R code**

This folder contains the R code to fit the set of shared component models proposed in the paper. Due to confidentiality issues, a simulated data set is provided to reproduce the results. The R software version used was R-4.2.1 and the R-INLA version 22.05.07.

The **DBrain.txt** file contains the following information:

-   **sex**: Takes value 1 for males and 2 for females.

-   **age**: Takes values 1 to 6 representing the age-groups \<40, 40-49, 50-59, 60-69, 70-79, and 80+ respectively.

-   **period**: Takes values 1 to 10 representing 1989-1990, 1991-1992, ... , 2007-2008 periods (managed on a biannual basis).

-   **region**: Takes the values 1 to 11 (see Figure 1 in the paper).

-   **cases**: Observed number of incident cases or deaths (detailed by the outcome variable)

-   **pop**: Population at risk in each domain

-   **outcome**: Indicates if the observed number of cases are incident cases or deaths

The **Define_Fit_Models.txt** file contains the coda to fit models 1-to-8 described in the paper. It is highly recommended to read the inla documentation regarding "besag2" model to better understand how Besag2 model for weighted spatial effects should be defined in INLA. To do this open Rstudio and run the following code

`library(INLA)`

`inla.doc("besag2")`

The **nc.inla** file contains the information of the neighbourhood matrix.
