# Kaggle Setup: Quick Fix for "Download Didn't Work"

## The Problem

You clicked "Create New API Token" on Kaggle, but no `kaggle.json` file downloaded.

**This is normal!** It happens to most people.

---

## The Solution (2 minutes)

### Step 1: Get Your Credentials

Go to: https://www.kaggle.com/settings/account

Click: **"Create New API Token"**

You'll see a popup showing:
```
Username: your_username
Key: abc123def456ghi789...
```

**📋 COPY BOTH VALUES!** (Write them down or keep the tab open)

### Step 2: Create the File

Run this script (easiest):
```bash
./setup_kaggle.sh
```

When prompted:
- Enter your username
- Enter your key
- Done! ✅

### Or Create Manually:

```bash
# Create directory
mkdir -p ~/.kaggle

# Create file (replace YOUR_USERNAME and YOUR_KEY with actual values)
cat > ~/.kaggle/kaggle.json << 'EOF'
{
  "username": "YOUR_USERNAME",
  "key": "YOUR_KEY"
}
EOF

# Secure it
chmod 600 ~/.kaggle/kaggle.json
```

### Step 3: Test It

```bash
kaggle datasets list | head -n 3
```

If you see a list of datasets, you're done! 🎉

---

## Example

If your username is `johnsmith` and key is `abc123`:

```bash
mkdir -p ~/.kaggle

cat > ~/.kaggle/kaggle.json << 'EOF'
{
  "username": "johnsmith",
  "key": "abc123def456ghi789jkl"
}
EOF

chmod 600 ~/.kaggle/kaggle.json
```

---

## Troubleshooting

### "I closed the popup without copying!"

No problem - just create a **new** token:
1. Go back to https://www.kaggle.com/settings/account
2. Click "Create New API Token" again
3. **This time copy the values before closing!**

### "My username is my email, right?"

No! Your username is shown in your Kaggle profile URL:
```
https://www.kaggle.com/YOUR_USERNAME
```

### "It says 401 Unauthorized"

Your credentials might be wrong. Create a new token:
- Go to https://www.kaggle.com/settings/account
- Create new token
- Copy credentials carefully (no extra spaces)
- Create file again

---

## That's It!

Once `~/.kaggle/kaggle.json` exists with correct credentials, the notebook will work automatically.

**For more details:** See `KAGGLE_SETUP.md` or `KAGGLE_VISUAL_GUIDE.md`
