#!/bin/bash

echo "Validating service..."

# Wait for application to start
sleep 5

# Check if process is running
if pgrep -f gunicorn > /dev/null; then
    echo "✓ Gunicorn process is running"
else
    echo "✗ Gunicorn process not found"
    exit 1
fi

# Test health endpoint
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000/health || echo "000")

if [ "$response" = "200" ]; then
    echo "✓ Health check passed (HTTP $response)"
    exit 0
else
    echo "✗ Health check failed (HTTP $response)"
    exit 1
fi
