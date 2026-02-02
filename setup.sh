#!/bin/bash

# Setup script for Taxi-Car Price Analysis Project
# This script sets up the environment using uv

set -e  # Exit on error

echo "================================================"
echo "  Taxi-Car Price Analysis Setup"
echo "================================================"
echo ""

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "❌ uv is not installed"
    echo ""
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    
    # Add to PATH for current session
    export PATH="$HOME/.cargo/bin:$PATH"
    
    echo ""
    echo "✅ uv installed successfully!"
    echo ""
    echo "⚠️  Please run this command to add uv to your PATH:"
    echo '    export PATH="$HOME/.cargo/bin:$PATH"'
    echo ""
    echo "Or restart your terminal."
    echo ""
else
    echo "✅ uv is already installed"
fi

echo ""
echo "Choose deployment mode:"
echo "  1) Laptop (Pandas-only, lightweight)"
echo "  2) Cloud (Spark + Pandas, distributed)"
echo "  3) All (everything, for flexibility)"
echo ""
read -p "Enter choice [1-3]: " choice

echo ""

case $choice in
    1)
        echo "📦 Installing Laptop mode dependencies..."
        uv sync --extra laptop --extra dev
        MODE="laptop"
        ;;
    2)
        echo "📦 Installing Cloud mode dependencies..."
        uv sync --extra cloud --extra dev
        MODE="cloud"
        ;;
    3)
        echo "📦 Installing all dependencies..."
        uv sync --extra all
        MODE="all"
        ;;
    *)
        echo "❌ Invalid choice. Defaulting to Laptop mode..."
        uv sync --extra laptop --extra dev
        MODE="laptop"
        ;;
esac

echo ""
echo "✅ Dependencies installed successfully!"
echo ""

# Check for Kaggle credentials
if [ ! -f "$HOME/.kaggle/kaggle.json" ]; then
    echo "⚠️  Kaggle credentials not found!"
    echo ""
    read -p "Set up Kaggle API now? [y/N]: " setup_kaggle
    if [[ "$setup_kaggle" =~ ^[Yy]$ ]]; then
        ./setup_kaggle.sh
    else
        echo ""
        echo "You can set up Kaggle API later by running:"
        echo "  ./setup_kaggle.sh"
        echo ""
        echo "Or see detailed instructions in:"
        echo "  KAGGLE_SETUP.md"
        echo ""
    fi
else
    echo "✅ Kaggle credentials found"
    echo ""
fi

echo "================================================"
echo "  Setup Complete!"
echo "================================================"
echo ""
echo "Next steps:"
echo ""
echo "  1. Activate virtual environment:"
echo "     source .venv/bin/activate"
echo ""
echo "  2. Launch Jupyter notebook:"
echo "     jupyter notebook taxi_car_price_analysis_hybrid.ipynb"
echo ""
echo "  3. In the notebook, set:"
if [ "$MODE" = "cloud" ]; then
    echo "     LAPTOP_DEPLOYMENT = False"
else
    echo "     LAPTOP_DEPLOYMENT = True"
fi
echo ""
echo "  4. Skip the installation cell (already done!)"
echo ""
echo "  5. Run all cells"
echo ""
echo "📚 For more info, see:"
echo "   - QUICKSTART.md"
echo "   - UV_SETUP.md"
echo ""
