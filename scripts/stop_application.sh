#!/bin/bash
pkill -f gunicorn || true
echo "Application stopped"
