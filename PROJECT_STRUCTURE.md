# Project Structure & Files

## 📁 Complete File Overview

```
taxi-car-price-analysis/
│
├── 📓 Notebooks
│   ├── taxi_car_price_analysis_hybrid.ipynb ⭐ Main notebook (laptop/cloud toggle)
│   └── taxi_car_price_correlation_analysis.ipynb (Original Spark-only version)
│
├── 📚 Documentation
│   ├── QUICKSTART.md          ← Start here! Quick setup guide
│   ├── KAGGLE_SETUP.md        ← How to get kaggle.json (detailed)
│   ├── KAGGLE_VISUAL_GUIDE.md ← Visual walkthrough (if download fails)
│   ├── UV_SETUP.md            ← Detailed uv usage guide
│   ├── README_HYBRID.md       ← Hybrid notebook documentation
│   ├── README.md              ← Original documentation
│   └── PROJECT_STRUCTURE.md   ← This file
│
├── 🔧 Configuration & Scripts
│   ├── pyproject.toml          ⭐ Dependency definitions (for uv sync)
│   ├── .gitignore              ← Git ignore rules
│   ├── setup.sh                ← Automated setup script (main)
│   └── setup_kaggle.sh         ← Kaggle API setup helper
│
└── 📊 Data (created after running)
    └── data/
        ├── combined_daily.parquet
        ├── combined_weekly.parquet
        ├── combined_monthly.parquet
        ├── price_by_type_monthly.parquet
        └── price_by_age_monthly.parquet
```

## 🚀 Three Ways to Install Dependencies

### 1. Using uv sync (Recommended) ⭐

**Best for:** Production, team projects, reproducibility

```bash
# One-time setup
./setup.sh

# Or manually:
uv sync --extra laptop --extra dev
source .venv/bin/activate
jupyter notebook
```

**Pros:**
- ✅ 10x faster (8s vs 90s)
- ✅ Reproducible (lock file)
- ✅ Version controlled
- ✅ Clean virtual environment
- ✅ Team-friendly

**Files used:**
- `pyproject.toml` - Dependency definitions
- `uv.lock` - Lock file (auto-generated)
- `.venv/` - Virtual environment (auto-created)

### 2. Using uv pip (Fast)

**Best for:** Quick prototyping with speed

```python
# In notebook cell:
USE_UV = True
LAPTOP_DEPLOYMENT = True
# Run installation cell
```

**Pros:**
- ✅ 10x faster than pip
- ✅ Works in notebook
- ⚠️ No lock file
- ⚠️ Manual version management

### 3. Using pip (Standard)

**Best for:** One-off experiments, maximum compatibility

```python
# In notebook cell:
USE_UV = False
LAPTOP_DEPLOYMENT = True
# Run installation cell
```

**Pros:**
- ✅ Works everywhere
- ✅ No additional tools
- ❌ Slower (90s)
- ❌ No lock file

## 📊 Comparison Matrix

| Feature | uv sync | uv pip | pip |
|---------|---------|--------|-----|
| **Speed** | ⚡⚡⚡ 8s | ⚡⚡ 10s | ⚡ 90s |
| **Reproducible** | ✅ Yes | ❌ No | ❌ No |
| **Lock file** | ✅ Yes | ❌ No | ❌ No |
| **Virtual env** | ✅ Auto | ⚠️ Manual | ⚠️ Manual |
| **Version control** | ✅ Yes | ❌ No | ❌ No |
| **Team-friendly** | ✅ Yes | ⚠️ Maybe | ⚠️ Maybe |
| **Setup complexity** | Medium | Low | Low |
| **Maintenance** | Easy | Medium | Medium |

## 🎯 Recommended Workflow

### For Individual/Quick Analysis:
```bash
# Method 2: uv pip in notebook
1. Open notebook
2. Set USE_UV = True
3. Run installation cell
4. Continue with analysis
```

### For Team/Production:
```bash
# Method 1: uv sync
1. git clone <repo>
2. ./setup.sh
3. source .venv/bin/activate
4. jupyter notebook
5. Skip installation cell
6. Continue with analysis
```

## 📦 Dependency Groups

Defined in `pyproject.toml`:

### Core (always installed)
- pandas, numpy, matplotlib, seaborn, plotly, kaggle

### Laptop mode (`--extra laptop`)
- Core + pyarrow, fastparquet

### Cloud mode (`--extra cloud`)
- Core + pyspark, opendatasets

### Development (`--extra dev`)
- jupyter, ipykernel, ipywidgets, notebook

### All (`--extra all`)
- Everything above

## 🔄 Migration Path

### Currently using pip?

```bash
# Add pyproject.toml (already done!)
# Then switch to:
uv sync --extra laptop --extra dev
```

### Currently using requirements.txt?

```bash
# Dependencies now in pyproject.toml
# Delete requirements.txt
# Use: uv sync --extra laptop --extra dev
```

## 🎓 Learning Resources

1. **Start Here:** `QUICKSTART.md` - Get running in 30 seconds
2. **Deep Dive:** `UV_SETUP.md` - Complete uv documentation
3. **Hybrid Mode:** `README_HYBRID.md` - Laptop vs Cloud explained
4. **uv Official:** https://github.com/astral-sh/uv

## 🤝 Contributing

If working on this project as a team:

1. **Clone repo:**
   ```bash
   git clone <repo>
   cd taxi-car-price-analysis
   ```

2. **Setup environment:**
   ```bash
   ./setup.sh
   # Or: uv sync --extra laptop --extra dev
   ```

3. **Activate environment:**
   ```bash
   source .venv/bin/activate
   ```

4. **Start working:**
   ```bash
   jupyter notebook
   ```

5. **Commit changes:**
   - ✅ Commit: `pyproject.toml`, `uv.lock`
   - ❌ Don't commit: `.venv/`, `data/`, `*.ipynb_checkpoints`

## 🔧 Configuration Flags

The notebook has **two main toggles**:

```python
# In first code cell:
LAPTOP_DEPLOYMENT = True/False  # Laptop vs Cloud
USE_UV = True/False             # uv vs pip (only if installing in notebook)
```

If you used `uv sync`, you don't need the installation cell at all!

## 📈 Performance Benchmarks

| Operation | pip | uv pip | uv sync |
|-----------|-----|--------|---------|
| Fresh install (laptop) | 90s | 10s | 8s |
| Fresh install (cloud) | 120s | 15s | 12s |
| Reinstall (cached) | 60s | 3s | 2s |
| **Speedup vs pip** | 1x | 9x | 11x |

## 🆘 Quick Troubleshooting

### "uv: command not found"
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.cargo/bin:$PATH"
```

### "No virtual environment"
```bash
uv sync --extra laptop --extra dev
source .venv/bin/activate
```

### "Kaggle API error" / "kaggle.json not found"
```bash
# Quick fix - run setup helper
./setup_kaggle.sh

# Or see detailed guide
# KAGGLE_SETUP.md has complete instructions with troubleshooting
```

### "Memory error"
```python
# In notebook, after loading data:
df = df.sample(frac=0.5)  # Use 50% of data
```

## 🎯 Next Steps

1. ✅ **Setup:** Run `./setup.sh` OR `uv sync --extra laptop --extra dev`
2. ✅ **Activate:** `source .venv/bin/activate`
3. ✅ **Launch:** `jupyter notebook taxi_car_price_analysis_hybrid.ipynb`
4. ✅ **Configure:** Set `LAPTOP_DEPLOYMENT = True`
5. ✅ **Skip:** Installation cell (already installed!)
6. ✅ **Run:** All remaining cells
7. ✅ **Analyze:** Review visualizations and correlations

---

**Questions?** Check the documentation files or open an issue!
