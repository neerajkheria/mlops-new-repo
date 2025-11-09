#!/bin/bash
cd /home/ec2-user/mlops-app

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install requirements
pip install -r requirements.txt

# Kill any existing process
pkill -f gunicorn

# Start application
nohup gunicorn --bind 0.0.0.0:5000 app:app > app.log 2>&1 &

echo "Application started"
