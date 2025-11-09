#!/bin/bash

echo "Stopping application..."

# Kill any running gunicorn processes
pkill -f gunicorn || true

# Wait a moment
sleep 2

echo "✓ Application stopped"
