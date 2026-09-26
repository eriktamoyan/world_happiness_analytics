-- File: 01_schema_and_views.sql
-- Description: DDL, indexes, and base analytical views.
-- Execution order: THIS FILE FIRST, then 02, then 03. See README for why.

CREATE DATABASE IF NOT EXISTS world_happiness_db;
USE world_happiness_db;

DROP VIEW IF EXISTS vw_residual_anomalies;
DROP VIEW IF EXISTS vw_happiness_factors;
DROP TABLE IF EXISTS happiness_data;

CREATE TABLE happiness_data (
    id                                  INT AUTO_INCREMENT PRIMARY KEY,
    year                                SMALLINT NOT NULL,
    rank_in_year                        SMALLINT,
    country                             VARCHAR(60) NOT NULL,
    happiness_score                     DECIMAL(4,3) NOT NULL,
    lower_whisker                       DECIMAL(4,3),
    upper_whisker                       DECIMAL(4,3),
    explained_log_gdp_per_capita        DECIMAL(4,3),
    explained_social_support             DECIMAL(4,3),
    explained_healthy_life_expectancy    DECIMAL(4,3),
    explained_freedom                    DECIMAL(4,3),
    explained_generosity                 DECIMAL(4,3),
    explained_corruption                 DECIMAL(4,3),
    dystopia_plus_residual               DECIMAL(4,3),
    CONSTRAINT uq_country_year UNIQUE (country, year),
    INDEX idx_year_country (year, country),      
    INDEX idx_country_year (country, year)       
);


CREATE VIEW vw_happiness_factors AS
SELECT
    country,
    year,
    rank_in_year,
    happiness_score,
    explained_log_gdp_per_capita,
    explained_social_support,
    explained_healthy_life_expectancy,
    explained_freedom,
    explained_generosity,
    explained_corruption,
    dystopia_plus_residual,
    ROUND(dystopia_plus_residual - 1.83, 3) AS pure_residual
FROM happiness_data
WHERE year >= 2011;
