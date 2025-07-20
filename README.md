# 📌 Spatial Regression Modeling on Human Development Index (HDI) in Kalimantan (2022)

This project aims to analyze the spatial patterns of the Human Development Index (HDI) in Kalimantan, Indonesia, using **spatial regression models**. The models include standard linear regression as well as **Spatial Lag Model (SLM)** and **Spatial Error Model (SEM)** to account for spatial dependencies among regions.

---

## 📁 Repository Structure

- `spasial-ipm-kalimantan.R`  
  R script for:
  - Data preprocessing
  - Spatial exploration (Moran’s I, choropleth mapping)
  - Estimating OLS, SLM, and SEM models
  - Evaluating and interpreting the results

- `Statistika Spasial.pdf`  
  Full research paper written in **Bahasa Indonesia**, covering background, methodology, results, and conclusions.

---

## 🎯 Objectives

- Analyze socio-economic factors influencing HDI across Kalimantan regions.
- Identify spatial autocorrelation in the distribution of HDI.
- Determine the most suitable spatial regression model to explain regional disparities in human development.

---

## 🧠 Methodology

- **Spatial Exploration**: HDI visualization using thematic maps, Moran's I test.
- **Modeling**:
  - Ordinary Least Squares (OLS) Regression
  - Spatial Lag Model (SLM)
  - Spatial Error Model (SEM)
- **Model Evaluation**: Based on AIC, R², and Lagrange Multiplier tests.

---

## 🛠️ Tools & R Packages

- `spdep`, `sf`, `rgdal`, `tmap`, `spatialreg`, `ggplot2`

---

## 📄 License

Feel free to add a license (e.g., MIT) to allow others to use or build upon this work.

---

📌 *This project was developed for academic and learning purposes in spatial statistics.*
