-- File: 03_hedonic_time_series.sql
-- Description: Calculate longitudinal volatility, score shifts, and
--              categorize countries into Hedonic Treadmill Archetypes,
--              using each country's own actual earliest/latest observed
--              year rather than assuming every country has full 2011-2025
--              coverage.

USE world_happiness_db;

CREATE OR REPLACE VIEW vw_hedonic_time_series AS
WITH bounds AS (
    SELECT
        country,
        MIN(year) AS min_year,
        MAX(year) AS max_year,
        COUNT(*)  AS n_observations
    FROM happiness_data
    GROUP BY country
),
endpoints AS (
    SELECT
        h.country,
        MAX(CASE WHEN h.year = b.min_year THEN h.happiness_score END) AS score_earliest,
        MAX(CASE WHEN h.year = b.max_year THEN h.happiness_score END) AS score_latest,
        b.min_year,
        b.max_year,
        b.n_observations
    FROM happiness_data h
    JOIN bounds b ON b.country = h.country
    GROUP BY h.country, b.min_year, b.max_year, b.n_observations
),
country_aggregates AS (
    SELECT
        e.country,
        e.score_earliest,
        e.score_latest,
        e.min_year,
        e.max_year,
        e.n_observations,
        AVG(h.happiness_score)                       AS mean_score,
        STDDEV(h.happiness_score)                     AS volatility_std,
        MAX(h.happiness_score) - MIN(h.happiness_score) AS max_peak_to_trough_range
    FROM endpoints e
    JOIN happiness_data h ON h.country = e.country
    GROUP BY e.country, e.score_earliest, e.score_latest,
             e.min_year, e.max_year, e.n_observations
)
SELECT
    country,
    min_year,                                       
    max_year,                                        
    n_observations,
    ROUND(score_earliest, 3) AS score_earliest,
    ROUND(score_latest, 3)   AS score_latest,
    ROUND(score_latest - score_earliest, 3) AS net_change,
    ROUND(volatility_std, 3) AS volatility,
    ROUND(max_peak_to_trough_range, 3) AS max_fluctuation_range,
    CASE
        WHEN n_observations <= 1
            THEN 'Insufficient Data'
        WHEN ABS(score_latest - score_earliest) <= 0.25 AND max_peak_to_trough_range >= 0.8
            THEN 'Hedonic Treadmill (High Volatility / Net Zero Change)'
        WHEN (score_latest - score_earliest) > 0.50
            THEN 'Sustained Structural Growth'
        WHEN (score_latest - score_earliest) < -0.50
            THEN 'Chronic Structural Decline'
        ELSE 'Baseline Stability'
    END AS hedonic_archetype
FROM country_aggregates
WHERE score_earliest IS NOT NULL AND score_latest IS NOT NULL
ORDER BY volatility DESC;