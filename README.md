# PredictInsuranceBuyers
Based on previous insurance data identify the predictors to predict the target customers for specific type of policy

Data consists of 86 variables and includes product usage data and socio-demographic data derived from zip area codes.

-Understand the business problem - type of insurance - Caravan 
Caravan is not common so it’s expected to have lower number of policies sold.
Idenitfy the predictors - features of a target customer
-Understand the data - 86 features which includes - type of customer, customer income and other policy the customer
holds and demographic details.
-Prepare data - Exploratory data analysis- histogram and correlation plots.
-Modeling data - using different predictive algorithms and idenitfy what are the best predictors for this type of policy
Linear Regression - To identify significant predictors
Subset selection - Best subset which is exhaustive search, Forward and Backward 
LASSO -reduces the beta coefficients of the predictors and it shrinks to zero if the
predictor is insignificant wrt to the response variable
Ridge- Similar to LASSO but it does not eliminate the predictors it just shrinks the beta
coefficient of the predictors


With all these algoirthms : 
Top 3 features of target customers which were present in all the model

PPERSAUT- Contribution car policies
APLEZIER- Number of boat policies
PBRAND- Contribution fire policies

Conclusion:

Customers with cars and boats along with fire policy are tend to own the caravan as well
so they are the target customers for the CARAVAN policy.



