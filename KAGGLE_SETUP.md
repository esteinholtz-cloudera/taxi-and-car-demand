# Kaggle API Setup Guide

## 🚨 Quick Fix: If Auto-Download Doesn't Work

**This is the most common issue!** If clicking "Create New API Token" doesn't download a file:

```bash
# Run the interactive setup script
./setup_kaggle.sh

# It will ask for your username and key, then create the file automatically
```

Or manually:

1. Visit https://www.kaggle.com/settings/account
2. Click "Create New API Token"
3. **Copy the username and key shown on the page**
4. Create the file:

```bash
mkdir -p ~/.kaggle

cat > ~/.kaggle/kaggle.json << 'EOF'
{
  "username": "YOUR_USERNAME_FROM_PAGE",
  "key": "YOUR_KEY_FROM_PAGE"
}
EOF

chmod 600 ~/.kaggle/kaggle.json
```

That's it! Continue reading for detailed instructions.

---

## Getting Your `kaggle.json` File

### Step-by-Step Instructions

#### 1. Go to Your Kaggle Account Settings

Visit: **https://www.kaggle.com/settings/account**

Or navigate manually:
1. Go to https://www.kaggle.com
2. Click your profile picture (top right)
3. Click "Settings"
4. Scroll to the "API" section

#### 2. Create New API Token

In the **API** section, you'll see:

```
Create New API Token
```

Click the **"Create New API Token"** button

#### 3. Download Should Happen Automatically

**Expected behavior:** When you click "Create New API Token", Kaggle **should** automatically download a file called `kaggle.json` to your Downloads folder.

You should see a browser download notification for `kaggle.json`.

**⚠️ HOWEVER:** Sometimes this doesn't work due to:
- Browser settings blocking downloads
- Adblockers or privacy extensions
- Browser not configured to auto-download JSON files
- Pop-up blockers

**If the download doesn't happen, don't worry!** See the manual creation method below.

The file should contain:
```json
{
  "username": "yourusername",
  "key": "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6"
}
```

#### 4A. If Download Worked: Move the File

If you got the `kaggle.json` file in your Downloads:

```bash
# Create the .kaggle directory
mkdir -p ~/.kaggle

# Move the downloaded file
mv ~/Downloads/kaggle.json ~/.kaggle/

# Set proper permissions (IMPORTANT for security)
chmod 600 ~/.kaggle/kaggle.json
```

#### 4B. If Download Didn't Work: Create Manually ⭐

**This is the common case!** After clicking "Create New API Token":

1. **Look at the Kaggle page** - After creating the token, you should see your credentials displayed on the page, something like:

   ```
   API Token Created
   Username: your_username
   Key: abc123def456...
   ```

   Or check the "API" section which shows:
   - **Username:** your_username
   - **Key:** [shows after creating token]

2. **Copy your username and key from the page**

3. **Create the file manually:**

```bash
# Create the directory
mkdir -p ~/.kaggle

# Create the file with your credentials
cat > ~/.kaggle/kaggle.json << 'EOF'
{
  "username": "PUT_YOUR_USERNAME_HERE",
  "key": "PUT_YOUR_KEY_HERE"
}
EOF

# Set proper permissions (IMPORTANT!)
chmod 600 ~/.kaggle/kaggle.json
```

**Replace** `PUT_YOUR_USERNAME_HERE` and `PUT_YOUR_KEY_HERE` with the actual values from the Kaggle page.

**Example:**
```bash
cat > ~/.kaggle/kaggle.json << 'EOF'
{
  "username": "johnsmith",
  "key": "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6"
}
EOF

chmod 600 ~/.kaggle/kaggle.json
```

#### 5. Verify It's Set Up Correctly

```bash
# Check if file exists
ls -la ~/.kaggle/kaggle.json

# Should show:
# -rw------- 1 yourusername staff 67 Dec 25 12:00 /Users/yourusername/.kaggle/kaggle.json

# Test it works
kaggle datasets list --sort-by votes
```

If the last command shows a list of datasets, you're all set! ✅

---

## Finding Your Credentials on Kaggle

If the automatic download doesn't work, here's exactly where to find your credentials:

### After Creating API Token

When you create a new API token, Kaggle shows a popup or page section with:

```
✓ API Token Created Successfully

Your credentials:
Username: your_username_here
Key: abc123def456ghi789jkl012mno345pqr
```

**Copy both values!** You'll need them to create the `kaggle.json` file manually.

### If You Closed the Page

Unfortunately, Kaggle **doesn't show the key again** after you close the page. If you lost it:

1. Go back to https://www.kaggle.com/settings/account
2. Click "Create New API Token" again (this **invalidates** the old token)
3. Copy the new credentials that appear

### Your Username

Not sure of your Kaggle username? It's shown in your profile URL:
```
https://www.kaggle.com/YOUR_USERNAME
```

---

## Manual Creation (When Auto-Download Fails)

### Option 1: Create File with Command Line (Recommended)

```bash
mkdir -p ~/.kaggle

cat > ~/.kaggle/kaggle.json << 'EOF'
{
  "username": "your_kaggle_username",
  "key": "your_api_key_here"
}
EOF

chmod 600 ~/.kaggle/kaggle.json
```

Replace `your_kaggle_username` and `your_api_key_here` with your actual credentials.

### Option 2: Create File with Text Editor

If you prefer using a text editor:

```bash
# Create the directory
mkdir -p ~/.kaggle

# Open in your preferred editor
nano ~/.kaggle/kaggle.json
# Or: code ~/.kaggle/kaggle.json  (VS Code)
# Or: open -e ~/.kaggle/kaggle.json  (TextEdit on Mac)
```

Type or paste:
```json
{
  "username": "your_username",
  "key": "your_api_key"
}
```

Save the file, then:
```bash
chmod 600 ~/.kaggle/kaggle.json
```

### Option 3: Using Environment Variables (Alternative Method)

Instead of using `kaggle.json`, you can set environment variables:

```bash
export KAGGLE_USERNAME="your_kaggle_username"
export KAGGLE_KEY="your_api_key_here"
```

To make this permanent, add to your `~/.zshrc` or `~/.bashrc`:

```bash
echo 'export KAGGLE_USERNAME="your_kaggle_username"' >> ~/.zshrc
echo 'export KAGGLE_KEY="your_api_key_here"' >> ~/.zshrc
source ~/.zshrc
```

**However**, the `kaggle.json` method is more standard and recommended!

---

## Troubleshooting

### Issue: Auto-download doesn't work when creating API token ⭐

**Symptom:**
You click "Create New API Token" but no file downloads.

**This is very common!** Possible causes:
- Browser security settings
- Adblockers or privacy extensions
- Pop-up blockers
- Browser configured to ask before downloading

**Solution:**

1. **Don't panic!** The credentials are shown on the page after creating the token.

2. **Look for your credentials** on the Kaggle page:
   ```
   Username: your_username
   Key: abc123...xyz789
   ```

3. **Create the file manually:**
   ```bash
   mkdir -p ~/.kaggle
   
   # Replace with your actual credentials
   cat > ~/.kaggle/kaggle.json << 'EOF'
   {
     "username": "your_username",
     "key": "abc123...xyz789"
   }
   EOF
   
   chmod 600 ~/.kaggle/kaggle.json
   ```

4. **Or use the interactive script:**
   ```bash
   ./setup_kaggle.sh
   # Choose 'y' when asked to create manually
   # Paste your username and key when prompted
   ```

### Issue: "I closed the page and didn't copy my credentials"

**Solution:**
Create a **new** API token (this invalidates the old one):
1. Go back to https://www.kaggle.com/settings/account
2. Click "Create New API Token" again
3. **This time**, copy the username and key immediately
4. Create the file manually (see above)

### Issue: "kaggle.json not found"

**Symptom:**
```
OSError: Could not find kaggle.json
```

**Solution:**
```bash
# Check if file exists
ls -la ~/.kaggle/kaggle.json

# If not found, check Downloads
ls -la ~/Downloads/kaggle.json

# Move it if found in Downloads
mv ~/Downloads/kaggle.json ~/.kaggle/
chmod 600 ~/.kaggle/kaggle.json
```

### Issue: "Permission denied"

**Symptom:**
```
Permission denied: ~/.kaggle/kaggle.json
```

**Solution:**
```bash
# Fix permissions
chmod 600 ~/.kaggle/kaggle.json
```

### Issue: "401 Unauthorized"

**Symptom:**
```
401 - Unauthorized
```

**Solutions:**
1. Your API token might be expired - create a new one
2. Check your credentials are correct:
   ```bash
   cat ~/.kaggle/kaggle.json
   ```
3. Create a new API token (this will invalidate the old one)

### Issue: File Downloaded But Can't Find It

**Solution:**

Check common download locations:
```bash
# Mac
ls ~/Downloads/kaggle.json

# Or use find
find ~ -name "kaggle.json" -not -path "*/\.*" 2>/dev/null
```

---

## Security Best Practices

### ⚠️ IMPORTANT: Never Commit `kaggle.json` to Git!

```bash
# It's already in .gitignore, but double-check:
cat .gitignore | grep kaggle.json

# Should show:
# kaggle.json
```

### Why 600 Permissions?

```bash
chmod 600 ~/.kaggle/kaggle.json
```

This means:
- **6** (rw-): You can read and write
- **0** (---): Your group cannot access
- **0** (---): Others cannot access

This prevents other users on your system from reading your API key.

---

## Quick Reference

### One-Command Setup (After Downloading)

```bash
mkdir -p ~/.kaggle && \
mv ~/Downloads/kaggle.json ~/.kaggle/ && \
chmod 600 ~/.kaggle/kaggle.json && \
echo "✅ Kaggle API configured!"
```

### Test Your Setup

```bash
# Test 1: File exists and has correct permissions
ls -la ~/.kaggle/kaggle.json

# Test 2: File has valid JSON
cat ~/.kaggle/kaggle.json | python -m json.tool

# Test 3: API works
kaggle datasets list --sort-by votes | head -n 5
```

If all three work, you're ready to go! 🚀

---

## Using in the Notebook

Once set up, the notebook will automatically use your credentials:

```python
# This will work automatically:
!kaggle datasets download -d austinreese/craigslist-carstrucks-data -p ./data --unzip
```

No need to specify credentials in the notebook!

---

## FAQ

### Q: Do I need to create a new token every time?

**A:** No! The token is permanent until you create a new one (which invalidates the old one).

### Q: Can I have multiple API tokens?

**A:** No, Kaggle only allows one active API token per account. Creating a new one invalidates the previous one.

### Q: What if I lose my `kaggle.json`?

**A:** Just create a new API token on Kaggle. It will download a new `kaggle.json` file.

### Q: Can I use environment variables instead?

**A:** Yes! Set `KAGGLE_USERNAME` and `KAGGLE_KEY`. But `kaggle.json` is more standard.

### Q: Where exactly does Kaggle download the file?

**A:** Usually `~/Downloads/kaggle.json` on Mac/Linux, or `C:\Users\YourName\Downloads\kaggle.json` on Windows.

---

## Summary: The Complete Flow

1. ✅ Visit https://www.kaggle.com/settings/account
2. ✅ Click "Create New API Token"
3. ✅ Kaggle downloads `kaggle.json` automatically
4. ✅ Move file: `mv ~/Downloads/kaggle.json ~/.kaggle/`
5. ✅ Set permissions: `chmod 600 ~/.kaggle/kaggle.json`
6. ✅ Test: `kaggle datasets list`
7. ✅ You're done! 🎉

The key point: **Kaggle creates and downloads the file for you** - you just need to move it to the right place!
