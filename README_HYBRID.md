# NYC Taxi Demand vs Car Price Analysis - Hybrid Deployment

## 🚀 One Notebook, Two Modes

This notebook supports **both laptop (Pandas) and cloud (Spark) deployments** with a single configuration flag!

## Quick Start

### 1. Choose Your Deployment Mode

Open `taxi_car_price_analysis_hybrid.ipynb` and set the flag in the first code cell:

```python
# For Mac Laptop (Pandas-only)
LAPTOP_DEPLOYMENT = True

# For Cloudera AI / Spark Cluster
LAPTOP_DEPLOYMENT = False
```

### 2. Requirements by Mode

#### Laptop Mode (`LAPTOP_DEPLOYMENT = True`)
**Pros:**
- No Spark required
- Lighter weight (~100MB vs ~300MB)
- Faster startup
- Works on any Python environment

**Cons:**
- Requires 8-16GB RAM for full dataset
- Single machine processing only

**Install (choose one):**
```bash
# Option A: Standard pip
pip install kaggle pandas numpy matplotlib seaborn plotly pyarrow fastparquet

# Option B: uv (10-100x faster!)
# Install uv first: curl -LsSf https://astral.sh/uv/install.sh | sh
uv pip install --system kaggle pandas numpy matplotlib seaborn plotly pyarrow fastparquet
```

**In notebook, set:**
```python
USE_UV = True  # or False for pip
```

#### Cloud Mode (`LAPTOP_DEPLOYMENT = False`)
**Pros:**
- Distributed processing
- Handles datasets of any size
- Optimized for Cloudera AI

**Cons:**
- Requires Spark installation
- Slower startup time
- Heavier dependencies

**Install:**
```bash
pip install kaggle pyspark pandas numpy matplotlib seaborn plotly
```

### 3. Kaggle API Setup (Both Modes)

```bash
# Get your API token from https://www.kaggle.com/account
mkdir -p ~/.kaggle
mv ~/Downloads/kaggle.json ~/.kaggle/
chmod 600 ~/.kaggle/kaggle.json
```

## How It Works

The notebook automatically switches implementations based on `LAPTOP_DEPLOYMENT`:

### Data Loading
```python
if LAPTOP_DEPLOYMENT:
    df = pd.read_csv("data/file.csv")
else:
    df = spark.read.csv("data/file.csv")
```

### Aggregations
```python
if LAPTOP_DEPLOYMENT:
    result = df.groupby('date').agg({'price': 'median'})
else:
    result = df.groupBy("date").agg(expr("percentile_approx(price, 0.5)"))
```

### Joins
```python
if LAPTOP_DEPLOYMENT:
    combined = df1.merge(df2, on='date')
else:
    combined = df1.join(df2, "date")
```

All visualization code is **identical** for both modes (uses Pandas/Plotly).

## Dataset Sizes

| Dataset | Records | Size | Laptop OK? |
|---------|---------|------|------------|
| Craigslist Cars (2019-2020) | ~400K | ~400MB | ✅ Yes |
| NYC Taxi (2019-2020) | ~80M | ~5-10GB | ⚠️ Tight (16GB+ RAM) |
| After Filtering | ~10M | ~1-2GB | ✅ Yes |

**Recommendation:** 
- **< 8GB RAM**: Use Cloud mode or sample the data
- **8-16GB RAM**: Laptop mode should work
- **16GB+ RAM**: Laptop mode works comfortably

## Performance Comparison

| Operation | Laptop (16GB RAM) | Cloud (4 nodes) |
|-----------|-------------------|-----------------|
| Load data | ~30s | ~10s |
| Filter & clean | ~20s | ~5s |
| Aggregations | ~15s | ~3s |
| Joins | ~10s | ~2s |
| **Total runtime** | **~5-7 min** | **~2-3 min** |

## Files Generated

Both modes produce identical output:

```
data/
├── combined_daily.parquet          # Daily aggregated facts
├── combined_weekly.parquet         # Weekly aggregated facts
├── combined_monthly.parquet        # Monthly aggregated facts
├── price_by_type_monthly.parquet   # Price by vehicle type
└── price_by_age_monthly.parquet    # Price by vehicle age
```

## Switching Between Modes

You can run the notebook in laptop mode, then **switch to cloud mode** to process larger datasets:

1. Run in laptop mode with sampled data
2. Verify logic works
3. Toggle `LAPTOP_DEPLOYMENT = False`
4. Run full analysis on cluster

Or vice versa - prototype on cloud, then run locally for iteration.

## Troubleshooting

### Laptop Mode

**Memory Error:**
```python
# Add this after loading data to sample:
taxi_df = taxi_df.sample(frac=0.1, random_state=42)
```

**Slow Performance:**
```python
# Optimize Pandas
pd.options.mode.chained_assignment = None
import warnings
warnings.filterwarnings('ignore')
```

### Cloud Mode

**Spark Not Found:**
```bash
pip install pyspark
# Or use existing Spark in Cloudera AI
```

**Out of Memory:**
```python
# Increase Spark memory
spark = SparkSession.builder \
    .config("spark.driver.memory", "8g") \
    .config("spark.executor.memory", "8g") \
    .getOrCreate()
```

## Feature Comparison

| Feature | Laptop Mode | Cloud Mode |
|---------|-------------|------------|
| Data loading | `pd.read_csv()` | `spark.read.csv()` |
| Filtering | Boolean indexing | `.filter()` |
| Aggregations | `.groupby().agg()` | `.groupBy().agg()` |
| Joins | `.merge()` | `.join()` |
| Percentiles | `.quantile()` | `percentile_approx()` |
| Output | Direct Pandas | `.toPandas()` |
| Visualization | Plotly | Plotly |

## Code Differences

### Example: Calculate Median Price

**Laptop:**
```python
median_price = df.groupby('date')['price'].median()
```

**Cloud:**
```python
median_price = df.groupBy("date").agg(
    expr("percentile_approx(price, 0.5)").alias("median_price")
)
```

**Hybrid (in notebook):**
```python
if LAPTOP_DEPLOYMENT:
    median_price = df.groupby('date')['price'].median()
else:
    median_price = df.groupBy("date").agg(
        expr("percentile_approx(price, 0.5)").alias("median_price")
    )
```

## Package Installation: pip vs uv

The notebook supports both `pip` and `uv` for package installation.

### Why uv?
[uv](https://github.com/astral-sh/uv) is a blazingly fast Python package installer (written in Rust):
- **10-100x faster** than pip
- Drop-in replacement for pip
- Better dependency resolution
- Smaller disk usage

### Installation Time Comparison
| Package Manager | Installation Time | Use Case |
|----------------|-------------------|----------|
| pip | ~60-90 seconds | Standard, works everywhere |
| uv | ~5-10 seconds | Fast iteration, local development |

### Setup uv (one-time)
```bash
# Mac/Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# Or with pip
pip install uv
```

### Usage in Notebook
```python
# Set this flag in the installation cell:
USE_UV = True   # Use uv (fast)
USE_UV = False  # Use pip (standard)
```

Both methods install the same packages and produce identical results.

## Best Practices

1. **Start with laptop mode** for rapid iteration
2. **Switch to cloud mode** when:
   - Dataset exceeds RAM
   - Need faster processing
   - Deploying to production

3. **Keep visualizations in Pandas** - they work in both modes

4. **Test on sample data** before full run:
   ```python
   # Add after loading
   if LAPTOP_DEPLOYMENT:
       df = df.sample(n=100000)
   ```

## Analysis Outputs

Regardless of mode, you get:

- ✅ Cleaned datasets (NY cars, 2019-2020 taxi)
- ✅ Outlier removal reports
- ✅ Daily/weekly/monthly aggregations
- ✅ Correlation analysis
- ✅ 5 visualization types
- ✅ Lagged correlation analysis
- ✅ Price by vehicle type & age

## Questions?

The notebook automatically detects which mode it's running in and provides appropriate status messages:

```
============================================================
  DEPLOYMENT MODE: LAPTOP (Pandas)
============================================================
✓ Running in Laptop mode (Pandas-only)
  - No Spark required
  - Lighter memory footprint
  - Good for datasets < 10GB
```

Happy analyzing! 🎉
