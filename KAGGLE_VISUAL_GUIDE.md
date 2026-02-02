# Kaggle API Setup: Visual Guide

## 🎯 What You'll See on the Kaggle Website

### Step 1: Navigate to Account Settings

Go to: **https://www.kaggle.com/settings/account**

You'll see a page with various settings sections.

### Step 2: Find the API Section

Scroll down to find the **"API"** section. It looks like this:

```
┌─────────────────────────────────────────────────┐
│  API                                            │
├─────────────────────────────────────────────────┤
│                                                 │
│  Create New API Token                           │
│  ┌─────────────────────────┐                   │
│  │ Create New API Token    │  ← Click this    │
│  └─────────────────────────┘                   │
│                                                 │
│  To use the Kaggle's public API, sign up for   │
│  an API token. This token allows you to use    │
│  Kaggle's CLI to download datasets, etc.       │
└─────────────────────────────────────────────────┘
```

### Step 3: Click "Create New API Token"

When you click the button, **one of two things happens:**

#### Scenario A: File Downloads (Ideal but Less Common)

A file called `kaggle.json` downloads to your `~/Downloads/` folder.

✅ **If this happens:** 
```bash
mv ~/Downloads/kaggle.json ~/.kaggle/
chmod 600 ~/.kaggle/kaggle.json
```

#### Scenario B: File Doesn't Download (More Common!)

You see a popup or notification showing your credentials:

```
┌─────────────────────────────────────────────────┐
│  ✓ API Token Created Successfully               │
├─────────────────────────────────────────────────┤
│                                                 │
│  Username: johnsmith                            │
│  Key: a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6         │
│                                                 │
│  Keep this key secret! It provides full access  │
│  to your Kaggle account.                        │
│                                                 │
│  ┌──────┐                                       │
│  │  OK  │                                       │
│  └──────┘                                       │
└─────────────────────────────────────────────────┘
```

✅ **If this happens:**

**COPY BOTH VALUES IMMEDIATELY!**

Then create the file manually:

```bash
mkdir -p ~/.kaggle

cat > ~/.kaggle/kaggle.json << 'EOF'
{
  "username": "johnsmith",
  "key": "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6"
}
EOF

chmod 600 ~/.kaggle/kaggle.json
```

---

## 🔍 Finding Your Username

Not sure what your Kaggle username is?

### Method 1: Look at Your Profile URL

When logged into Kaggle, click your profile picture (top right).

Your profile URL will be:
```
https://www.kaggle.com/YOUR_USERNAME
```

Example: `https://www.kaggle.com/johnsmith` → username is `johnsmith`

### Method 2: Check Your Email

The username is usually shown in emails from Kaggle.

### Method 3: It's on the Settings Page

On the account settings page, look at the top:

```
┌─────────────────────────────────────────────────┐
│  Account                                        │
│                                                 │
│  johnsmith                      [Edit]          │
│  john.smith@email.com                          │
└─────────────────────────────────────────────────┘
```

The first line (here: `johnsmith`) is your username.

---

## 🎯 Complete Visual Workflow

### If Auto-Download Works (Less Common):

```
1. Click "Create New API Token"
   ↓
2. Browser downloads kaggle.json
   ↓
3. Move file:
   $ mv ~/Downloads/kaggle.json ~/.kaggle/
   ↓
4. Secure it:
   $ chmod 600 ~/.kaggle/kaggle.json
   ↓
5. ✅ Done!
```

### If Auto-Download Fails (More Common):

```
1. Click "Create New API Token"
   ↓
2. Popup shows:
   Username: johnsmith
   Key: a1b2c3d4...
   ↓
3. COPY both values!
   ↓
4. Create file manually:
   $ mkdir -p ~/.kaggle
   $ cat > ~/.kaggle/kaggle.json << 'EOF'
   {
     "username": "johnsmith",
     "key": "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6"
   }
   EOF
   ↓
5. Secure it:
   $ chmod 600 ~/.kaggle/kaggle.json
   ↓
6. ✅ Done!
```

---

## 🚨 Common Mistakes

### Mistake 1: Closed popup without copying

**Problem:** You clicked "Create New API Token", saw the popup, clicked OK, and didn't copy the credentials.

**Solution:** Create a **new** token (this invalidates the old one):
```bash
# Go back to https://www.kaggle.com/settings/account
# Click "Create New API Token" again
# This time, copy the credentials BEFORE clicking OK!
```

### Mistake 2: Wrong username

**Problem:** Used your email or display name instead of username.

**Solution:** The username is shown in your profile URL:
```
https://www.kaggle.com/YOUR_USERNAME_HERE
```

### Mistake 3: Copied key with extra spaces

**Problem:** Accidentally copied spaces before/after the key.

**Solution:** 
```bash
# Make sure the JSON is properly formatted:
cat ~/.kaggle/kaggle.json | python -m json.tool

# Should show clean output without errors
```

### Mistake 4: File in wrong location

**Problem:** Created `kaggle.json` in current directory instead of `~/.kaggle/`.

**Solution:**
```bash
# Find the file
find ~ -name "kaggle.json" 2>/dev/null

# Move it to correct location
mv /path/to/kaggle.json ~/.kaggle/
chmod 600 ~/.kaggle/kaggle.json
```

---

## ✅ Verification Checklist

After setup, verify everything:

```bash
# 1. File exists
ls -la ~/.kaggle/kaggle.json
# Should show: -rw------- ... kaggle.json

# 2. File is valid JSON
cat ~/.kaggle/kaggle.json | python -m json.tool
# Should show your username and key without errors

# 3. File contains correct keys
grep -E '"username"|"key"' ~/.kaggle/kaggle.json
# Should show both "username": and "key": lines

# 4. API works
kaggle datasets list --sort-by votes | head -n 5
# Should show list of datasets
```

If all four checks pass: ✅ You're ready to go!

---

## 🆘 Still Having Issues?

Run the interactive setup script:

```bash
./setup_kaggle.sh
```

It will:
- Check if file exists
- Look in common locations
- Offer to create it manually with prompts
- Test the API connection
- Guide you through fixing any issues

Or see the complete guide: `KAGGLE_SETUP.md`
