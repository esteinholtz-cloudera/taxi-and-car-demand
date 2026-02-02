# NYC Taxi Demand vs Used Car Price Analysis

## Hypothesis
Does taxi demand correlate with used car prices in New York areas?

## Setup Instructions

### 1. Kaggle API Credentials
Before running the notebook, set up Kaggle API:

```bash
# Create kaggle directory
mkdir -p ~/.kaggle

# Download your kaggle.json from https://www.kaggle.com/account
# (Account → Create New API Token)

# Move it to the .kaggle directory
mv ~/Downloads/kaggle.json ~/.kaggle/

# Set permissions
chmod 600 ~/.kaggle/kaggle.json
```

### 2. Run in Cloudera AI
1. Upload `taxi_car_price_correlation_analysis.ipynb` to your Cloudera AI workspace
2. Ensure Spark is available in your session
3. Run cells sequentially

## Analysis Overview

### Datasets
- **Craigslist Cars**: Used car listings from NY state (2019-2020)
- **NYC Yellow Taxi**: Trip data from NYC (2019-2020)

### Methodology
1. **Data Cleaning**
   - Filter to NY and 2019-2020
   - Remove price outliers (< $500 or > $75,000)
   - Remove trip distance outliers (> 50 miles)

2. **Dimensional Model**
   - Time: Daily, Weekly, Monthly aggregations
   - Taxi demand: Pickup/dropoff trip counts (density)
   - Car prices: Median prices by vehicle type, age, region

3. **Correlation Analysis**
   - Contemporaneous correlation
   - Lagged correlation (predictive relationships)
   - Breakdown by vehicle characteristics

4. **Visualizations**
   - 8 different graph types to evaluate hypothesis
   - Interactive Plotly charts
   - Interpretation guidance included

## Critical Considerations

⚠️ **Potential Issues:**
1. **Geographic Mismatch**: Taxi data is NYC-only, car data is NY state-wide
2. **COVID-19 Impact**: 2020 includes pandemic effects on both metrics
3. **Spurious Correlation**: Both may be driven by external economic factors
4. **Sample Bias**: Craigslist may not represent full used car market

## Output Files

After running, the notebook generates:
- `data/combined_daily.parquet`: Daily aggregated facts
- `data/combined_weekly.parquet`: Weekly aggregated facts
- `data/combined_monthly.parquet`: Monthly aggregated facts
- `data/price_by_type_monthly.parquet`: Prices by vehicle type
- `data/price_by_age_monthly.parquet`: Prices by vehicle age

## Interpreting Results

### Evidence FOR hypothesis:
- Time series lines move together (Graph 1)
- Positive correlation > 0.5 (Graph 2)
- Ascending prices across demand quartiles (Graph 8)

### Evidence AGAINST hypothesis:
- Lines move independently or opposite (Graph 1)
- Correlation near 0 or negative (Graph 2)
- No pattern across quartiles (Graph 8)

### Confounding Evidence:
- Strong lagged correlation (indirect relationship)
- Some vehicle types correlate, others don't
- Seasonal patterns in both metrics

## Recommendations

1. **Focus on 2019 data** for analysis without COVID impact
2. **Control for seasonality** before claiming causation
3. **Consider alternative explanations** for any correlations
4. **Test economic logic**: Does the relationship make sense?

## Files in This Repository

- `taxi_car_price_correlation_analysis.ipynb`: Main analysis notebook
- `README.md`: This file
- `data/`: Generated after running (datasets and outputs)

## Dependencies

```
pyspark
pandas
numpy
matplotlib
seaborn
plotly
kaggle
```

All installed automatically in the first cell of the notebook.

## Author Notes

This analysis uses Spark for distributed processing to handle large datasets efficiently. The dimensional model allows flexible aggregation at different time granularities to find the optimal correlation window.

**Remember**: Correlation ≠ Causation. Use these visualizations to test the hypothesis, but be skeptical and investigate confounding factors.
