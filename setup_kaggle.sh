#!/bin/bash

# Quick Kaggle API Setup Script
# This script helps you set up your Kaggle credentials

set -e

echo "================================================"
echo "  Kaggle API Setup Helper"
echo "================================================"
echo ""

# Check if kaggle.json already exists
if [ -f "$HOME/.kaggle/kaggle.json" ]; then
    echo "✅ kaggle.json already exists at ~/.kaggle/kaggle.json"
    echo ""
    
    # Check permissions
    PERMS=$(stat -f "%OLp" "$HOME/.kaggle/kaggle.json" 2>/dev/null || stat -c "%a" "$HOME/.kaggle/kaggle.json" 2>/dev/null)
    if [ "$PERMS" = "600" ]; then
        echo "✅ Permissions are correct (600)"
    else
        echo "⚠️  Permissions are $PERMS (should be 600)"
        read -p "Fix permissions? [y/N]: " fix
        if [[ "$fix" =~ ^[Yy]$ ]]; then
            chmod 600 "$HOME/.kaggle/kaggle.json"
            echo "✅ Permissions fixed!"
        fi
    fi
    
    echo ""
    echo "Testing Kaggle API..."
    if kaggle datasets list --sort-by votes -p 1 &> /dev/null; then
        echo "✅ Kaggle API is working!"
        echo ""
        echo "You're all set! 🎉"
    else
        echo "❌ Kaggle API test failed"
        echo ""
        echo "Your credentials might be invalid. Create a new token:"
        echo "  https://www.kaggle.com/settings/account"
        echo ""
        echo "Then run this script again."
    fi
    
    exit 0
fi

# kaggle.json doesn't exist, guide user through setup
echo "📋 Step-by-step setup:"
echo ""
echo "1. First, let's check if you've downloaded kaggle.json..."
echo ""

# Check if file exists in Downloads
if [ -f "$HOME/Downloads/kaggle.json" ]; then
    echo "✅ Found kaggle.json in ~/Downloads/"
    echo ""
    echo "Moving it to the correct location..."
    
    mkdir -p "$HOME/.kaggle"
    mv "$HOME/Downloads/kaggle.json" "$HOME/.kaggle/"
    chmod 600 "$HOME/.kaggle/kaggle.json"
    
    echo "✅ Moved and secured!"
    echo ""
    echo "Testing Kaggle API..."
    
    if kaggle datasets list --sort-by votes -p 1 &> /dev/null; then
        echo "✅ Success! Kaggle API is working!"
        echo ""
        echo "You're all set! 🎉"
    else
        echo "⚠️  API test failed, but file is in place"
        echo "Try downloading datasets in your notebook"
    fi
    
    exit 0
fi

# File not found anywhere
echo "❌ kaggle.json not found in ~/Downloads/"
echo ""
echo "⚠️  IMPORTANT: Sometimes the download doesn't work automatically!"
echo ""
echo "To get your kaggle.json file:"
echo ""
echo "  1. Go to: https://www.kaggle.com/settings/account"
echo "  2. Scroll to the 'API' section"
echo "  3. Click 'Create New API Token'"
echo "  4. Copy your username and key from the page"
echo ""

read -p "Do you want to create kaggle.json manually now? [y/N]: " create_manual
if [[ "$create_manual" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Let's create kaggle.json manually..."
    echo ""
    
    read -p "Enter your Kaggle username: " kaggle_user
    read -p "Enter your Kaggle API key: " kaggle_key
    
    if [ -n "$kaggle_user" ] && [ -n "$kaggle_key" ]; then
        mkdir -p "$HOME/.kaggle"
        cat > "$HOME/.kaggle/kaggle.json" << EOF
{
  "username": "$kaggle_user",
  "key": "$kaggle_key"
}
EOF
        chmod 600 "$HOME/.kaggle/kaggle.json"
        
        echo ""
        echo "✅ kaggle.json created!"
        echo ""
        echo "Testing Kaggle API..."
        
        if kaggle datasets list --sort-by votes -p 1 &> /dev/null; then
            echo "✅ Success! Kaggle API is working!"
            echo ""
            echo "You're all set! 🎉"
        else
            echo "⚠️  API test failed"
            echo ""
            echo "Double-check your credentials at:"
            echo "  https://www.kaggle.com/settings/account"
            echo ""
            echo "You may need to create a new API token."
        fi
    else
        echo "❌ Username or key was empty. Cancelled."
    fi
else
    echo ""
    read -p "Do you want to open Kaggle settings in browser? [y/N]: " open_browser
    if [[ "$open_browser" =~ ^[Yy]$ ]]; then
        if command -v open &> /dev/null; then
            open "https://www.kaggle.com/settings/account"
            echo ""
            echo "✅ Opening Kaggle in browser..."
            echo ""
            echo "After creating your token:"
            echo "  - Copy your username and key"
            echo "  - Run this script again: ./setup_kaggle.sh"
            echo "  - Choose 'y' to create manually"
        else
            echo "Please visit: https://www.kaggle.com/settings/account"
        fi
    fi
fi

echo ""
echo "📚 For detailed instructions, see: KAGGLE_SETUP.md"
echo ""
