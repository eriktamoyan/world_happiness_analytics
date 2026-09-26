-- File: 02_cross_sectional_anomalies.sql
-- Description: Isolate 2025 cross-sectional model-fit residuals and classify
--              Optimistic vs Pessimistic Anomalies.

USE world_happiness_db;

CREATE OR REPLACE VIEW vw_cross_sectional_anomalies_2025 AS
SELECT
    country,
    happiness_score,
    ROUND(
        explained_log_gdp_per_capita +
        explained_social_support +
        explained_healthy_life_expectancy +
        explained_freedom +
        explained_generosity +
        explained_corruption,
    3) AS predicted_score_above_dystopia,
    ROUND(pure_residual, 3) AS pure_residual,
    CASE
        WHEN pure_residual > 0.35  THEN 'Optimistic Anomaly (Outperformance)'
        WHEN pure_residual < -0.35 THEN 'Pessimistic Anomaly (Underperformance)'
        ELSE 'Model Baseline'
    END AS statistical_category
FROM vw_happiness_factors       
WHERE year = 2025
  AND pure_residual IS NOT NULL  
  AND ABS(pure_residual) > 0.35
ORDER BY pure_residual DESC;