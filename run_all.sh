#!/bin/bash
# Combined setup and execution script for TIBCO Platform API Automation
# Fully automated for CI/CD pipelines - no manual intervention needed

set -e  # Exit on error

echo "======================================"
echo "TIBCO Platform API Automation Setup"
echo "======================================"

# Step 1: Make install_requirements.py executable
chmod 777 install_requirements.py
echo "✓ Made install_requirements.py executable"

# Step 2: Remove Windows carriage returns
sed -i 's/\r$//' install_requirements.py
echo "✓ Fixed line endings"

# Step 3: Create and activate Python virtual environment
echo ""
echo "Setting up virtual environment..."
if [ ! -d ".venv" ]; then
  python3 -m venv .venv
  echo "✓ Virtual environment created"
else
  echo "✓ Virtual environment exists"
fi

source .venv/bin/activate
echo "✓ Virtual environment activated: $VIRTUAL_ENV"
echo "  Using Python: $(which python)"
echo "  Python version: $(python --version)"

# Step 4: Upgrade pip first
echo ""
echo "Upgrading pip..."
python -m pip install --upgrade pip --quiet

# Step 5: Install all required packages from requirements.txt
echo ""
echo "Installing Python packages from requirements.txt..."
python -m pip install -r requirements.txt --quiet
echo "✓ All packages from requirements.txt installed"

# Step 6: Ensure critical packages are installed (redundant but safe for CI/CD)
echo ""
echo "Verifying critical packages..."
python -m pip install beautifulsoup4==4.12.2 --quiet
python -m pip install requests==2.31.0 --quiet
python -m pip install selenium==4.16.0 --quiet
python -m pip install webdriver-manager==4.0.1 --quiet
echo "✓ Critical packages verified"

# Step 7: Run install_requirements.py (for Chrome installation, etc.)
echo ""
echo "Running install_requirements.py..."
./install_requirements.py
echo "✓ Additional requirements installed"

# Step 8: Verify all imports work before running main
echo ""
echo "Verifying module imports..."
python -c "import bs4; print('✓ beautifulsoup4 (bs4) OK')" || {
  echo "✗ bs4 import failed - reinstalling..."
  python -m pip install --force-reinstall beautifulsoup4==4.12.2
  python -c "import bs4; print('✓ beautifulsoup4 (bs4) OK after reinstall')"
}
python -c "import selenium; print('✓ selenium OK')" || {
  echo "✗ selenium import failed - reinstalling..."
  python -m pip install --force-reinstall selenium==4.16.0
  python -c "import selenium; print('✓ selenium OK after reinstall')"
}
python -c "import requests; print('✓ requests OK')" || exit 1
echo "✓ All imports verified"

# Step 9: Make chromedriver executable (suppress error if not downloaded yet)
chmod +x /home/ubuntu/.wdm/drivers/chromedriver/linux64/*/chromedriver-linux64/chromedriver 2>/dev/null || true

# Step 10: Run main.py using the venv's python
echo ""
echo "======================================"
echo "Starting main.py execution..."
echo "======================================"
python main.py

# Exit with main.py's exit code
exit $?

