#!/bin/bash
set -e

APP_DIR="/home/ec2-user/mlops-app"
cd $APP_DIR

echo "Starting application in $APP_DIR..."

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Upgrade pip
pip install --upgrade pip

# Install requirements
echo "Installing Python packages..."
pip install -r requirements.txt

# Kill any existing gunicorn processes
pkill -f gunicorn || true
sleep 2

# Start application with gunicorn
echo "Starting gunicorn server..."
nohup gunicorn --bind 0.0.0.0:5000 --workers 2 --timeout 120 app:app > app.log 2>&1 &

sleep 5

echo "✓ Application started"
