# Troubleshooting Spark Errors

## Error: Stream is corrupted / FetchFailedException

### Full Error Message
```
Py4JJavaError: An error occurred while calling o297.showString.
: org.apache.spark.SparkException: Job aborted due to stage failure
...
org.apache.spark.shuffle.FetchFailedException: Stream is corrupted
```

### What It Means

This error occurs during Spark **shuffle operations** (like `groupBy`, `orderBy`, `join`) when:
1. **Memory pressure** - Not enough memory for shuffle files
2. **Corrupted shuffle files** - Temporary files become corrupted
3. **Large dataset** - Dataset too big for available resources
4. **Network issues** - In distributed mode, network problems can corrupt transfers

### Why It Happened

In the exploration cell (section 4.5), this operation causes the error:

```python
df.groupBy(col_name).count().orderBy(col('count').desc()).show(10)
```

This triggers a **shuffle** (data must be redistributed across partitions to group by values), which can fail on:
- Large datasets
- Laptop Spark installations (limited resources)
- Datasets with high cardinality (many unique values)

---

## Solutions

### Solution 1: Use Laptop Mode (Recommended) ⭐

**Easiest and most reliable fix!**

```python
# At the very top of the notebook, set:
LAPTOP_DEPLOYMENT = True
```

This switches from Spark to Pandas, which:
- ✅ No shuffle operations
- ✅ No distributed complexity
- ✅ Works reliably on laptops
- ✅ Faster for datasets that fit in memory (<10GB)
- ✅ Same analysis results

**When to use:** 
- Running on laptop
- Dataset fits in RAM (8-16GB recommended)
- Prototyping/exploration phase

---

### Solution 2: Increase Spark Memory

If you need to stay in Spark mode:

```python
# Modify the Spark initialization cell:
spark = SparkSession.builder \
    .appName("TaxiCarPriceCorrelation") \
    .config("spark.driver.memory", "8g") \           # Increase from default
    .config("spark.executor.memory", "8g") \         # Increase from default
    .config("spark.memory.fraction", "0.8") \        # Use more memory for execution
    .config("spark.sql.shuffle.partitions", "200") \ # More partitions
    .config("spark.local.dir", "/tmp/spark") \       # Ensure enough temp space
    .getOrCreate()
```

**When to use:**
- Running on cluster/cloud
- Have more memory available
- Need distributed processing

---

### Solution 3: Skip Exploration Cell

The exploration cell (section 4.5) is optional for understanding data quality.

**You can skip it** and proceed directly to:
- Section 5: Data Preparation
- The rest of the analysis

The analysis will still work - you just won't see the exploratory statistics.

---

### Solution 4: Reduce Data for Exploration

Modify the exploration cell to use a smaller sample:

```python
# At start of exploration cell:
df = craigslist_df.sample(fraction=0.05)  # Use 5% instead of all data
```

---

### Solution 5: Clear Spark Temp Files

Sometimes shuffle files get corrupted. Clear them:

```bash
# Clear Spark temporary directories
rm -rf /tmp/spark-*
rm -rf /var/tmp/spark-*

# Then restart the notebook kernel and try again
```

---

## What the Updated Notebook Does

I've updated the exploration cell (section 4.5) to be more robust:

### Changes Made:

1. **Added caching**: `df.cache()` to reduce recomputation
2. **Wrapped in try-except**: All Spark operations catch errors gracefully
3. **Use sampling for aggregations**: Converts 10% sample to Pandas to avoid shuffles
4. **Added unpersist**: `df.unpersist()` to clean up cache
5. **Fallback messages**: Clear error messages with solutions

### New Behavior:

**Before (would crash):**
```python
df.groupBy(col_name).count().orderBy(col('count').desc()).show(10)
# ❌ Crash with shuffle error
```

**After (handles errors):**
```python
try:
    df_sample = df.sample(fraction=0.1).toPandas()
    # Do aggregation in Pandas (no shuffle!)
except Exception as e:
    print(f"⚠️  Failed: {e}")
    print("Solution: Use LAPTOP_DEPLOYMENT=True")
```

---

## Comparison: Laptop vs Cloud Mode for Exploration

| Aspect | Laptop Mode | Cloud Mode (Spark) |
|--------|-------------|-------------------|
| **Exploration speed** | ⚡ Fast | 🐢 Slow (shuffle overhead) |
| **Memory usage** | Linear (loads into RAM) | Distributed (shuffle files) |
| **Reliability** | ✅ Very reliable | ⚠️ Can fail on large data |
| **Best for** | Prototyping, < 10GB | Production, > 10GB |
| **Error rate** | Low | Higher (network, shuffle) |

**Recommendation:** Use **Laptop mode for exploration**, then switch to Cloud mode if needed for the full analysis.

---

## Testing the Fix

After making changes, test with:

```python
# Small test
df.groupBy("state").count().show(5)

# If this works, you're good
# If this fails, try Solution 1 (Laptop mode)
```

---

## Why Shuffle Operations Fail

### What is a Shuffle?

When you do `groupBy("state").count()`, Spark must:
1. **Partition** data by state (all CA records together, all NY together, etc.)
2. **Write** intermediate data to disk (shuffle files)
3. **Read** from shuffle files
4. **Aggregate** within each partition

If any of these steps fail (corruption, out of memory, network issues), you get `FetchFailedException`.

### High-Risk Operations:
- `groupBy()` - Requires shuffle
- `orderBy()` - Requires shuffle
- `join()` - Requires shuffle (unless broadcast)
- `.distinct()` - Requires shuffle
- `repartition()` - Requires shuffle

### Low-Risk Operations:
- `filter()` - No shuffle
- `select()` - No shuffle
- `withColumn()` - No shuffle
- `sample()` - No shuffle
- `.toPandas()` on small data - No shuffle

---

## Prevention

To avoid shuffle issues in the future:

1. **Use Laptop mode** for exploration
2. **Sample first** before expensive operations
3. **Cache smartly** (cache, use, unpersist)
4. **Monitor memory** - Don't exceed available RAM
5. **Use Spark only when necessary** - Pandas is fine for < 10GB

---

## Quick Decision Tree

```
Having shuffle errors?
│
├─ Dataset < 10GB?
│  └─ YES → Use LAPTOP_DEPLOYMENT=True ✅
│
├─ Need distributed processing?
│  └─ YES → Increase Spark memory (Solution 2)
│
├─ Just want to explore data?
│  └─ YES → Skip exploration cell (Solution 3)
│
└─ Still failing?
   └─ Clear temp files (Solution 5) or use smaller sample (Solution 4)
```

---

## Summary

**The Quick Fix:**

```python
# Change this line at the top of the notebook:
LAPTOP_DEPLOYMENT = False  # ❌ Causes shuffle errors

# To:
LAPTOP_DEPLOYMENT = True   # ✅ Works reliably
```

That's it! The notebook will use Pandas instead of Spark and avoid all shuffle issues.

**Benefits:**
- ✅ No more shuffle errors
- ✅ Faster execution for exploration
- ✅ Same analysis results
- ✅ Easier to debug

**Trade-off:**
- ⚠️ Requires enough RAM (8-16GB recommended)
- ⚠️ Single machine only (no distributed processing)

For this NYC taxi analysis, **Laptop mode is perfectly adequate** unless you're processing more than the 2019-2020 data provided.
