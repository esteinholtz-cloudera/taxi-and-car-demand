# Using uv for Dependency Management

This project supports `uv` for fast and reliable dependency management using the `pyproject.toml` file.

## Quick Start

### 1. Install uv (one-time)

```bash
# Mac/Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# Or via pip
pip install uv

# Or via Homebrew
brew install uv
```

### 2. Choose Your Deployment Mode

#### Option A: Laptop Mode (Pandas-only)

```bash
# Install core + laptop dependencies
uv sync --extra laptop --extra dev

# Or without dev dependencies
uv sync --extra laptop
```

#### Option B: Cloud Mode (Spark)

```bash
# Install core + cloud dependencies
uv sync --extra cloud --extra dev

# Or without dev dependencies
uv sync --extra cloud
```

#### Option C: Install Everything

```bash
# Install all dependencies (laptop + cloud + dev)
uv sync --extra all
```

### 3. Activate the Virtual Environment

```bash
# uv creates a .venv automatically
source .venv/bin/activate

# Or on Windows
.venv\Scripts\activate
```

### 4. Launch Jupyter

```bash
jupyter notebook taxi_car_price_analysis_hybrid.ipynb
```

## Dependency Groups

The `pyproject.toml` defines several dependency groups:

### Core Dependencies (Always Installed)
- `pandas` - Data manipulation
- `numpy` - Numerical computing
- `matplotlib` - Plotting
- `seaborn` - Statistical visualization
- `plotly` - Interactive plots
- `kaggle` - Dataset downloads

### Laptop Mode (`--extra laptop`)
- `pyarrow` - Parquet file support
- `fastparquet` - Fast parquet I/O

### Cloud Mode (`--extra cloud`)
- `pyspark` - Distributed data processing
- `opendatasets` - Dataset utilities

### Development (`--extra dev`)
- `jupyter` - Notebook environment
- `ipykernel` - Jupyter kernel
- `ipywidgets` - Interactive widgets
- `notebook` - Notebook interface

## Common Commands

### Install dependencies
```bash
# Laptop mode
uv sync --extra laptop --extra dev

# Cloud mode
uv sync --extra cloud --extra dev

# Everything
uv sync --extra all
```

### Add a new dependency
```bash
# Add to core dependencies
uv add package-name

# Add to specific group
uv add --optional laptop package-name
uv add --optional cloud package-name
uv add --optional dev package-name
```

### Update dependencies
```bash
# Update all packages to latest compatible versions
uv sync --upgrade

# Update specific package
uv add package-name --upgrade
```

### Lock dependencies
```bash
# Create/update uv.lock file
uv lock

# Sync from lock file
uv sync --frozen
```

### Remove virtual environment
```bash
rm -rf .venv
```

## Speed Comparison

| Operation | pip | uv |
|-----------|-----|-----|
| Fresh install (laptop mode) | ~90 seconds | ~8 seconds |
| Fresh install (cloud mode) | ~120 seconds | ~12 seconds |
| Fresh install (all) | ~150 seconds | ~15 seconds |
| Reinstall (cached) | ~60 seconds | ~2 seconds |
| **Speedup** | 1x | **10-30x faster** |

## Advantages of uv sync

### 1. **Reproducible Environments**
- Lock file (`uv.lock`) ensures exact versions
- Same environment across machines
- No dependency resolution conflicts

### 2. **Fast Installation**
- Parallel downloads
- Efficient caching
- Rust-based speed

### 3. **Better Dependency Management**
- Automatically creates virtual environment
- Optional dependency groups
- Clean separation of concerns

### 4. **No Manual pip installs**
- All dependencies in `pyproject.toml`
- Version-controlled
- Team-friendly

## Workflow Comparison

### Traditional (pip in notebook)
```python
# In notebook cell:
!pip install kaggle pandas numpy matplotlib seaborn plotly pyarrow -q
```
❌ Not version controlled
❌ Slow installation
❌ No lock file
❌ Manual dependency management

### Modern (uv sync)
```bash
# Before opening notebook:
uv sync --extra laptop --extra dev
source .venv/bin/activate
jupyter notebook
```
✅ Version controlled (`pyproject.toml`)
✅ Fast installation
✅ Lock file (`uv.lock`)
✅ Automatic dependency management

## Alternative: Using uv in Notebook

If you still want to install from within the notebook:

```python
# In first cell:
import sys
!uv pip install --system -r requirements.txt
```

But `uv sync` before launching is recommended!

## Troubleshooting

### "uv: command not found"
```bash
# Reinstall uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Add to PATH (if needed)
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### "No virtual environment found"
```bash
# uv sync creates .venv automatically, but you can create manually:
uv venv

# Then sync
uv sync --extra laptop --extra dev
```

### "Package conflicts"
```bash
# Force reinstall
rm -rf .venv uv.lock
uv sync --extra laptop --extra dev
```

### Wrong Python version
```bash
# Specify Python version
uv venv --python 3.11
uv sync --extra laptop --extra dev
```

## Project Structure

```
.
├── pyproject.toml          # ← Dependency definitions
├── uv.lock                 # ← Lock file (auto-generated)
├── .venv/                  # ← Virtual environment (auto-created)
├── taxi_car_price_analysis_hybrid.ipynb
├── data/
└── README.md
```

## Best Practices

1. **Commit `pyproject.toml`** - Version control dependencies
2. **Commit `uv.lock`** - Ensure reproducibility
3. **Ignore `.venv/`** - Don't commit virtual environment
4. **Use `uv sync`** - Always sync before starting work
5. **Update regularly** - Run `uv sync --upgrade` periodically

## Integration with Notebook

The notebook still has the installation cell for convenience, but if you use `uv sync`, you can skip it:

```python
# Skip this cell if you already ran: uv sync --extra laptop --extra dev
# The packages are already installed in your virtual environment!
```

## CI/CD Integration

For automated workflows:

```yaml
# GitHub Actions example
- name: Install dependencies
  run: |
    pip install uv
    uv sync --extra cloud --frozen
```

## Migration from pip

If you have a `requirements.txt`:

```bash
# Convert to pyproject.toml (manual step needed)
# Then use uv sync going forward
uv sync --extra laptop --extra dev
```

---

## Summary

**Before (pip):**
```bash
pip install kaggle pandas numpy matplotlib seaborn plotly pyarrow fastparquet
# Wait 90 seconds...
jupyter notebook
```

**After (uv):**
```bash
uv sync --extra laptop --extra dev
# Wait 8 seconds!
source .venv/bin/activate
jupyter notebook
```

**10x faster, 100x better organized!** 🚀
