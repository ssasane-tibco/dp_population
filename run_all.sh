#!/bin/bash
# Combined setup and execution script for TIBCO Platform API Automation

# Step 1: Make install_requirements.py executable
chmod 777 install_requirements.py
echo "Made install_requirements.py executable."

# Step 2: Remove Windows carriage returns
sed -i 's/\r$//' install_requirements.py

# Step 3: (Recommended) Create and activate a Python virtual environment
if [ ! -d ".venv" ]; then
  python3 -m venv .venv
fi
source .venv/bin/activate

# Step 4: Run install_requirements.py (twice for robustness)
./install_requirements.py
./install_requirements.py

# Step 5: Make chromedriver executable (update the path if needed)
chmod +x /home/ubuntu/.wdm/drivers/chromedriver/linux64/*/chromedriver-linux64/chromedriver

# Step 6: Run main.py
python3 main.py

