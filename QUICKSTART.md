# Quick Start Guide

## 📁 Files in This Project

### Main Notebooks

1. **`taxi_car_price_analysis_hybrid.ipynb`** ⭐ **RECOMMENDED**
   - **Single notebook with deployment toggle**
   - Set `LAPTOP_DEPLOYMENT = True` for Mac
   - Set `LAPTOP_DEPLOYMENT = False` for Cloudera AI
   - Same code, different execution engines

2. **`taxi_car_price_correlation_analysis.ipynb`** (Original)
   - Spark-only version
   - Requires PySpark
   - Cloudera AI optimized

### Documentation

- **`README_HYBRID.md`** - Detailed guide for hybrid notebook
- **`README.md`** - Original documentation
- **`QUICKSTART.md`** - This file

## 🚀 Get Started in 30 Seconds

### Method 1: Using uv sync (Recommended) ⭐

```bash
# 1. Install uv (one-time)
curl -LsSf https://astral.sh/uv/install.sh | sh

# 2. Setup Kaggle credentials
./setup_kaggle.sh
# Or see KAGGLE_SETUP.md for detailed instructions
# Or see KAGGLE_VISUAL_GUIDE.md for screenshots and step-by-step
#
# Quick manual setup (if auto-download doesn't work):
#   1. Visit https://www.kaggle.com/settings/account
#   2. Click "Create New API Token"
#   3. Copy username and key from popup
#   4. Run: ./setup_kaggle.sh and paste credentials

# 3. Install dependencies based on mode
# For Laptop:
uv sync --extra laptop --extra dev

# For Cloud:
# uv sync --extra cloud --extra dev

# 4. Activate virtual environment
source .venv/bin/activate

# 5. Launch notebook
jupyter notebook taxi_car_price_analysis_hybrid.ipynb

# 6. In first code cell, just set:
LAPTOP_DEPLOYMENT = True  # ← Laptop vs Cloud

# 7. SKIP the installation cell (already installed!) and run remaining cells
```

### Method 2: Install from Notebook (Alternative)

### For Mac Laptop Users:

```bash
# 1. Install dependencies (choose one method)

# Option A: Using pip (standard)
pip install kaggle pandas numpy matplotlib seaborn plotly pyarrow

# Option B: Using uv (10-100x faster!)
# First install uv: curl -LsSf https://astral.sh/uv/install.sh | sh
uv pip install --system kaggle pandas numpy matplotlib seaborn plotly pyarrow

# 2. Setup Kaggle credentials
./setup_kaggle.sh
# See KAGGLE_SETUP.md for detailed instructions

# 3. Open the hybrid notebook
jupyter notebook taxi_car_price_analysis_hybrid.ipynb

# 4. In first code cell, set your preferences:
LAPTOP_DEPLOYMENT = True  # ← Laptop vs Cloud
USE_UV = False            # ← Set to True if you want uv installation

# 5. Run all cells
```

### For Cloudera AI Users:

```bash
# 1. Upload taxi_car_price_analysis_hybrid.ipynb to workspace

# 2. In first code cell, ensure:
LAPTOP_DEPLOYMENT = False  # ← For Spark mode

# 3. Run all cells
```

## 📊 What You'll Get

After running the notebook, you'll have:

### Data Outputs
- `data/combined_daily.parquet` - Daily taxi trips + car prices
- `data/combined_weekly.parquet` - Weekly aggregations
- `data/combined_monthly.parquet` - Monthly aggregations
- `data/price_by_type_monthly.parquet` - Prices by vehicle type
- `data/price_by_age_monthly.parquet` - Prices by vehicle age

### Analysis Results
- Correlation coefficients at 3 time granularities
- Lagged correlation analysis (predictive relationships)
- Summary statistics with outlier reports

### Visualizations
1. **Time series overlay** - Trips vs prices over time
2. **Scatter plot** - Direct correlation with trend line
3. **Correlation heatmap** - All variables
4. **Lagged correlation** - Leading/lagging relationships
5. **Category breakdowns** - By vehicle type and age

## 🎯 The Key Innovation

**One notebook, toggle between:**

```python
# Mac Laptop (Pandas)
LAPTOP_DEPLOYMENT = True

# vs

# Cloud/Spark
LAPTOP_DEPLOYMENT = False
```

Everything else is **automatic**:
- Data loading adapts
- Transformations adapt
- Aggregations adapt
- Joins adapt
- Visualization code stays the same

## 🎯 Why uv sync?

| Feature | Notebook Install | uv sync |
|---------|------------------|---------|
| Speed | 60-90 seconds | 8-15 seconds |
| Reproducible | ❌ No | ✅ Yes (lock file) |
| Version controlled | ❌ No | ✅ Yes (pyproject.toml) |
| Team-friendly | ❌ No | ✅ Yes |
| Clean environment | ⚠️ Maybe | ✅ Always (.venv) |

**Recommendation:** Use `uv sync` for anything beyond one-off experiments!

See `UV_SETUP.md` for detailed documentation.

## 💡 Which Mode Should I Use?

| If you have... | Use Mode | Why |
|----------------|----------|-----|
| Mac laptop, 8GB+ RAM | `LAPTOP_DEPLOYMENT = True` | No Spark needed, faster startup |
| Mac laptop, < 8GB RAM | Sample data first | Full dataset may not fit |
| Cloudera AI | `LAPTOP_DEPLOYMENT = False` | Distributed processing |
| Large custom dataset | `LAPTOP_DEPLOYMENT = False` | Better scalability |

## ⚡ Performance

### Laptop Mode (16GB MacBook Pro)
- Load data: ~30 seconds
- Process + analyze: ~5-7 minutes total
- Memory usage: ~4-6GB peak

### Cloud Mode (Cloudera AI, 4 nodes)
- Load data: ~10 seconds
- Process + analyze: ~2-3 minutes total
- Scales to any dataset size

## 🔍 Quick Test

Want to verify it works before full run?

### Laptop Mode Test:
```python
# After loading data, add:
taxi_df = taxi_df.head(10000)  # Sample 10K rows
ny_cars = ny_cars.head(5000)    # Sample 5K rows
```

### Cloud Mode Test:
```python
# After loading data, add:
taxi_df = taxi_df.sample(fraction=0.01)  # 1% sample
```

## 📈 Expected Results

The analysis tests the hypothesis: **"Does taxi demand correlate with used car prices?"**

You'll get specific correlation coefficients like:
- Daily: `r = -0.23` (weak negative)
- Weekly: `r = 0.15` (weak positive)  
- Monthly: `r = 0.45` (moderate positive)

*(These are examples - your actual results will vary)*

## ⚠️ Important Notes

1. **Geographic mismatch**: Taxi data is NYC-only, car data is NY state-wide
   - This is a fundamental limitation
   - Results should be interpreted cautiously

2. **COVID-19 impact**: 2020 data includes pandemic effects
   - Consider analyzing 2019 separately
   - Both metrics affected, but independently

3. **Correlation ≠ Causation**
   - Even strong correlations don't prove causality
   - Look for confounding variables (economy, seasonality)

## 🆘 Troubleshooting

### "Memory Error" in Laptop Mode
```python
# Reduce data size
taxi_df = taxi_df.sample(frac=0.5)  # Use 50%
```

### "Spark not found" in Cloud Mode
```bash
pip install pyspark
```

### "Kaggle API error"
```bash
# Re-check credentials
cat ~/.kaggle/kaggle.json
chmod 600 ~/.kaggle/kaggle.json
```

## 🎓 Learning the Code

The hybrid approach is educational - compare implementations:

**Filter Example:**
```python
if LAPTOP_DEPLOYMENT:
    # Pandas
    filtered = df[df['price'] > 1000]
else:
    # Spark
    filtered = df.filter(col("price") > 1000)
```

You can learn both Pandas AND Spark from one notebook!

## 🚀 Next Steps

1. Run the notebook with default settings
2. Review the 5 visualizations
3. Read the correlation analysis
4. Interpret results considering limitations
5. Modify for your own hypotheses

## 📞 Support

- Read `README_HYBRID.md` for detailed documentation
- Check code comments in notebook cells
- All major operations have print statements showing progress

---

**TL;DR**: Open `taxi_car_price_analysis_hybrid.ipynb`, set `LAPTOP_DEPLOYMENT = True`, run all cells. Done! ✨
