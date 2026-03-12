# spei-drought-forecasting-narx

# A Data-Driven Time-Series Approach to SPEI Drought Forecasting Using NARX Neural Networks

Overview

This repository contains the implementation of a data-driven time-series framework for forecasting the Standardized Precipitation Evapotranspiration Index (SPEI) using Nonlinear Autoregressive Neural Networks with Exogenous Inputs (NARX).

The objective is to develop predictive models capable of identifying and forecasting drought conditions based on historical meteorological observations.

Research Objective

The main goals of this study are:

- Forecast the SPEI drought index

- Apply NARX neural networks for nonlinear time-series prediction

- Analyze relationships between meteorological variables and drought dynamics

- Evaluate the predictive performance of data-driven models

Methodology

The forecasting framework is based on Nonlinear Autoregressive Neural Networks with Exogenous Inputs (NARX), which are suitable for modeling nonlinear and dynamic systems.

The model structure includes:

- values of the target variable (SPEI)

- lagged meteorological predictors (exogenous inputs)

General NARX formulation:

SPEI(t) = f(SPEI(t−1), SPEI(t−2), …, X(t−1), X(t−2), …)

where X represents exogenous climate variables such as precipitation and temperature.

Data

The dataset includes meteorological observations used to compute the SPEI drought index, including:

- precipitation

- air temperature

- additional climate variables (if available)

Data preprocessing includes:

- time-series preparation

- normalization / scaling

- lagged feature generation

Repository Structure

spei-drought-forecasting-narx/

data/ → raw and processed datasets
scripts/ → R scripts for preprocessing and modeling
models/ → trained NARX models
results/ → forecasting outputs and evaluation metrics
figures/ → plots and visualizations
README.md → project documentation

Requirements

The project is implemented in R.

Example packages used:

- tidyverse

- forecast

- neuralnet

- zoo

- SPEI

Install packages in R:

install.packages(c("tidyverse","forecast","neuralnet","zoo","SPEI"))
How to Run

Clone the repository

git clone https://github.com/USERNAME/spei-drought-forecasting-narx.git

Open the project in RStudio

Run preprocessing scripts

Train the NARX model

Evaluate forecasting performance

Applications

The framework can support:

- drought early warning systems

- climate risk assessment

- water resource management

- environmental forecasting

Cite This Repository

If you use this repository in your research, please cite it as:

@software{spei_narx_forecasting,
  author = {Your Name},
  title = {A Data-Driven Time-Series Approach to SPEI Drought Forecasting Using NARX Neural Networks},
  year = {2026},
  url = {https://github.com/USERNAME/spei-drought-forecasting-narx}
}
Author

PhD research project focused on drought forecasting, climate data analysis, and machine learning applications in hydrology and meteorology.

License

This repository is intended for academic and research purposes.




