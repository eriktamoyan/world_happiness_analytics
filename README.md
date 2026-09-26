# Econometrics vs. Existence: Deconstructing the World Happiness Report (2011–2025)

> *"Life swings like a pendulum backward and forward between pain and boredom."*  
> — **Arthur Schopenhauer**

---

## 🏛️ Philosophical & Statistical Prolegomena

Contemporary econometric paradigms operate under a implicit utilitarian postulate: that human well-being ($\mathbf{Y}$) can be reduced to a deterministic, linear vector sum of material and institutional inputs ($\mathbf{X}\boldsymbol{\beta}$). In the standard formulation of the **World Happiness Report (WHR)**, Ordinary Least Squares (OLS) regression models attempt to quantify subjective life satisfaction using six foundational covariates: Log GDP per capita, Social Support, Healthy Life Expectancy, Freedom to Make Life Choices, Generosity, and Perceptions of Corruption.

Mathematically, the standard model asserts:

$$Y_i = \beta_0 + \beta_1 (\text{GDP}_i) + \beta_2 (\text{Social}_i) + \beta_3 (\text{Health}_i) + \beta_4 (\text{Freedom}_i) + \beta_5 (\text{Generosity}_i) + \beta_6 (\text{Corruption}_i) + \epsilon_i$$

However, this linear simplification encounters a profound epistemological barrier: **The Unobserved Existential Variable ($U_i$)**. When residual errors ($\epsilon_i = Y_i - \hat{Y}_i$) exhibit non-normal distribution, high variance, and multi-year structural stability, the model collapses under **Omitted Variable Bias**. 

This research project presents a rigorous econometric audit designed to test two foundational hypotheses:
1. **The Existential Anomaly Hypothesis:** That structural positive anomalies ($e_i \gg 0$) and negative anomalies ($e_i \ll 0$) are not statistical noise, but evidence of non-quantifiable psychological mechanisms—specifically **Schopenhauerian Volitional Positivity** and **Nietzschean Alienation ("The Last Man")**.
2. **The Schopenhauerian Hedonic Treadmill Hypothesis:** That over a 15-year horizon (2011–2025), longitudinal growth in material inputs ($\mathbf{X}$) fails to yield proportional net gains in life evaluation ($\Delta Y \approx 0$), as human consciousness rapidly recalibrates its baseline expectation threshold.

---

## 📂 Data Provenance & Source

The empirical foundation for this study was retrieved from **Kaggle**:
* **Dataset:** *World Happiness Report Data (2005–2025)*
* **Repository:** [Kaggle Dataset Hub]
* **Scope:** 15-year longitudinal subset (2011–2025) filtered across 140+ sovereign entities, comprising panel data of life evaluations (Cantril Ladder) and six explanatory factors.

---

## 🏗️ Technical & Repository Architecture

This analysis was executed strictly inside **MySQL Workbench** to demonstrate enterprise-level database analytics, utilizing dynamic views, multi-stage CTEs, standard deviation window functions, and $Z$-score normalization.

```text
world-happiness-hedonic-treadmill/
├── 01_schema_and_views.sql          # DDL, Dataset Structuring & Base Views
├── 02_cross_sectional_anomalies.sql # Pure Residuals & Z-Score Anomaly Engine
├── 03_hedonic_time_series.sql       # 15-Year Volatility & Hedonic Treadmill Engine
└── README.md                        # Empirical Synthesis & Philosophical Manifesto


📊 Visual Matrix: Residual Anomalies & Treadmill Dynamics


quadrantChart
    title Econometric Deviations (2025) vs. 15-Year Structural Trajectories (2011–2025)
    x-axis "Negative Model Fit Residual (e < 0)" --> "Positive Model Fit Residual (e > 0)"
    y-axis "Negative Net Change (Decline)" --> "Positive Net Change (Growth)"
    quadrant-1 "Stoic Optimistic Anomalies (Costa Rica, Guatemala)"
    quadrant-2 "Pessimistic Alienation Anomalies (Hong Kong, Botswana)"
    quadrant-3 "Chronic Systemic Decline (Sri Lanka, Tajikistan)"
    quadrant-4 "Hedonic Treadmill / Baseline Recalibration"
    "Costa Rica": [0.88, 0.62]
    "Guatemala": [0.82, 0.58]
    "Venezuela": [0.75, 0.45]
    "Hong Kong": [0.15, 0.51]
    "Botswana": [0.22, 0.28]
