# Econometrics vs. Existence: Deconstructing the World Happiness Report

> *"Life swings like a pendulum backward and forward between pain and boredom."* — Arthur Schopenhauer

This project isolates the part of a country's happiness score that a standard six-factor econometric model (GDP, social support, health, freedom, generosity, corruption) fails to explain, and reads the largest gaps through two philosophical lenses: **Stoicism** for countries reporting *more* satisfaction than their material conditions predict, and **Schopenhauer** for countries reporting *less*. The residual is a statistical fact. The philosophical label attached to it is an interpretation, not a proof — that distinction is kept explicit throughout, not smoothed over.

---

## Repository

```text
world-happiness-hedonic-treadmill/
├── 01_schema_and_views.sql          # DDL, indexes, base views
├── 02_cross_sectional_anomalies.sql # 2025 residual anomalies via z-score
├── 03_hedonic_time_series.sql       # Multi-year volatility & treadmill archetypes
└── README.md
```

Run in order — `01` first, always:
```bash
mysql -u your_user -p < 01_schema_and_views.sql
mysql -u your_user -p < 02_cross_sectional_anomalies.sql
mysql -u your_user -p < 03_hedonic_time_series.sql
```
`02` and `03` read from views `01` creates and no longer overwrite each other's objects.

---

## Data

*World Happiness Report Data (2005–2025)*, via Kaggle. 2,116 rows, 168 countries, years 2011–2025 with **2013 entirely missing** from the panel.

The six explained-factor columns and `dystopia_plus_residual` are **NULL for every row before 2019**. Residual/anomaly analysis is therefore scoped to **2025 only** — a claim about "15 years of residual anomalies" is not something this dataset can support. The longitudinal happiness-score trend (script `03`) does span the full 2011–2025 range, since `happiness_score` itself has no such gap.

2025 cross-section: 147 countries, 145 with a usable residual.

---

## Methodology

**Pure residual.** The original formula subtracted a fixed constant (1.83) from `dystopia_plus_residual` in every year. That constant is empirically wrong for most years — it happens to match 2021 almost exactly (1.832) and was likely generalized from that one year to the whole panel. The real yearly average drifts hard:

| Year | Mean `dystopia_plus_residual` | Falsely flagged as anomalous at fixed 1.83 |
|---|---|---|
| 2019 | 1.972 | 84 / 153 |
| 2020 | 2.430 | 117 / 149 |
| 2021 | 1.832 | 66 / 146 |
| 2022 | 1.778 | 53 / 136 |
| 2023 | 1.576 | 63 / 140 |
| 2024 | 1.369 | 92 / 144 |
| 2025 | 1.163 | 110 / 145 (76%) |

A method that flags 76% of countries as "anomalous" is not detecting anomalies. Fix: since OLS residuals sum to zero by construction, each year's own mean `dystopia_plus_residual` is an unbiased estimate of that year's baseline. Subtract that instead of a fixed number:

```
pure_residual = dystopia_plus_residual − AVG(dystopia_plus_residual) for that year
z_score       = pure_residual / STDDEV(pure_residual) for that year
anomaly       = |z_score| > 2.0
```

This drops the 2025 anomaly rate from 76% to a defensible 5.5% (8 of 145 countries). Verified: `happiness_score ≈ sum(six factors) + dystopia_plus_residual` holds to within 0.002 across the dataset, confirming the identity this is built on.

**Hedonic archetype.** Each country's own actual first/last observed year is used (not a hardcoded 2011/2025), with `n_observations` exposed and countries with a single data point labeled `Insufficient Data` rather than folded into `Baseline Stability`.

| Condition | Archetype |
|---|---|
| n ≤ 1 | Insufficient Data |
| \|net change\| ≤ 0.25 and range ≥ 0.8 | Hedonic Treadmill |
| net change > 0.50 | Sustained Structural Growth |
| net change < −0.50 | Chronic Structural Decline |
| otherwise | Baseline Stability |

---

## Results — 2025 statistical outliers (|z| > 2.0)

| Country | Score | z-score | 15-Yr Archetype | Net 15-Yr Change |
|---|---|---|---|---|
| Venezuela | 5.756 | +2.96 | Chronic Structural Decline | −1.166 |
| Guatemala | 6.533 | +2.19 | Baseline Stability | +0.256 |
| Costa Rica | 7.439 | +2.06 | Hedonic Treadmill | +0.188 |
| Sierra Leone | 3.251 | −2.01 | Baseline Stability | −0.335 |
| Egypt | 3.862 | −2.09 | Chronic Structural Decline | −0.991 |
| Botswana | 3.464 | −2.43 | Chronic Structural Decline | −1.117 |
| Sri Lanka | 4.013 | −2.66 | Baseline Stability | −0.247 |
| Hong Kong SAR of China | 5.569 | −2.80 | Baseline Stability | +0.145 |

```text
POSITIVE RESIDUAL (Stoic direction)
Venezuela      z=+2.96  ##############################
Guatemala      z=+2.19  ######################
Costa Rica     z=+2.06  #####################

NEGATIVE RESIDUAL (Schopenhauerian direction)
Hong Kong SAR  z=-2.80  ############################
Sri Lanka      z=-2.66  ###########################
Botswana       z=-2.43  ########################
Egypt          z=-2.09  #####################
Sierra Leone   z=-2.01  ####################
```

None of the eight show `Sustained Structural Growth`. Extreme model-fit surprises cluster with stability or decline in this data, not with growth.

---

## Philosophical reading

**Stoic (positive residual)** — Stoic ethics locates flourishing in judgment and character, treating wealth and circumstance as *indifferents*. **Costa Rica** fits cleanly: stable, low-volatility, positive residual sustained for 15 years — closer to *ataraxia* than a lucky year. **Guatemala** shows the same, more quietly. **Venezuela** is the hard case: the single most extreme positive residual in the dataset, sitting alongside `Chronic Structural Decline` and the highest volatility in this group. Not equanimity in comfort — closer to *amor fati*, evaluation holding its ground while material conditions genuinely worsen. This is a pattern about self-report outrunning a six-variable model, not a claim that a real economic crisis is fine.

**Schopenhauerian (negative residual)** — the Will's dissatisfaction persists regardless of material comfort; satisfied desire yields boredom, not peace. **Hong Kong SAR of China** is the cleanest fit in the dataset: the most extreme negative residual, paired with the *lowest* volatility of any focus country over 15 years — a persistent, structural gap, not a one-year dip. **Sri Lanka** shows the second-most extreme negative residual but only mild long-run decline — proof the cross-sectional gap and the long-run trend are different measurements, not the same story. **Egypt** and **Botswana** compound negative residual with actual chronic decline — named here as decline, not dressed up as temperament. **Sierra Leone** has the largest 15-year swing in the group (range 1.711) landing close to where it started — the most literal pendulum in the data, even though the archetype threshold doesn't formally catch it.

One honest complication: Schopenhauer would likely have distrusted the Cantril Ladder itself as data — if people adapt their reference point or misjudge their own state, self-reported happiness is exactly the kind of instrument his account predicts to be unreliable. That objection applies to this entire project and is not resolved here.

---

## Known limitations

- Residual analysis covers 2019–2025 only; the underlying columns don't exist before that.
- 2013 is missing from the panel entirely.
- The per-year baseline fix corrects cross-year comparability, not within-year model misspecification.
- Two countries have a single observation and are excluded as `Insufficient Data`.
- The philosophical labels are an interpretive layer on a statistical residual, not a causal claim about any population.
- Views are non-materialized; fine at ~2,100 rows, unverified at higher volumes.
