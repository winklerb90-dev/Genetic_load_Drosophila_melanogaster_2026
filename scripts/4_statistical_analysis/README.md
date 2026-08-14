# Details on workflow
In this section fitness as a response to the interaction between genetic load, sex and chromosome type + DGRP line as a random effect
is modelled using the [brms package](https://paulbuerkner.com/brms/). The models are created for each data set (SnpEff or GERP, created in section '2_snpeff' and
'3_gerp') and for both life-stages (early and late). Two scripts are provided, one using unstandardised values of genetic load 
and the other one using genetic load values which have been standardised using Z-scores (takes mean and standard deviation into account). 
The visualisation of the modelling results is also shown in these scripts. Afterwards the models can be validated using Leave-One-Out (loo) cross validation and compared by their ELPD (expected log-pointwise predictive density). For the datasets we used, the unstandardised values were estimated as better fitting compared to the z-scored values by the loo cross validation. 
