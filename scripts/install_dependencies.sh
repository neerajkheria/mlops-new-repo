#!/bin/bash
set -e

echo "Installing system dependencies..."
yum update -y
yum install -y python3 python3-pip

# Install virtualenv
pip3 install virtualenv

echo "✓ Dependencies installed"
