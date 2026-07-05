#!/bin/bash

###############################################################################
# Abeacon Complete Setup Script for Kali Linux
# Run: bash SETUP.sh
###############################################################################

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_step() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# Start setup
clear
print_header "ABEACON SETUP - KALI LINUX"

# Step 1: System Update
print_header "Step 1: System Update"
print_info "Updating system packages..."
sudo apt-get update -qq
sudo apt-get upgrade -y -qq
print_step "System updated"

# Step 2: Install System Dependencies
print_header "Step 2: Installing System Dependencies"
print_info "Installing required packages..."
sudo apt-get install -y -qq \
    git \
    curl \
    wget \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    postgresql \
    postgresql-contrib \
    nginx \
    docker.io \
    nodejs \
    npm

print_step "System dependencies installed"

# Step 3: Setup Docker
print_header "Step 3: Setting Up Docker"
print_info "Adding user to docker group..."
sudo usermod -aG docker $USER
print_info "Starting Docker daemon..."
sudo systemctl start docker
sudo systemctl enable docker
print_step "Docker configured"

# Step 4: Navigate to project
print_header "Step 4: Setting Up Project Directory"
print_info "Current directory: $(pwd)"
if [ ! -f "docker-compose.yml" ]; then
    print_error "docker-compose.yml not found. Make sure you're in the abeacon project root."
    exit 1
fi
print_step "Project directory verified"

# Step 5: Start Docker Services
print_header "Step 5: Starting Docker Services"
print_info "Starting PostgreSQL, Redis, Meilisearch, and MinIO..."
docker-compose up -d
print_info "Waiting for services to be healthy (30 seconds)..."
sleep 30
docker-compose ps
print_step "All Docker services running"

# Step 6: Setup Backend
print_header "Step 6: Setting Up Backend"
cd backend

# Create environment file
if [ ! -f ".env" ]; then
    print_info "Creating .env file from template..."
    cp ../.env.example .env
    print_step ".env created (update credentials as needed)"
else
    print_info ".env already exists, skipping..."
fi

# Create Python virtual environment
print_info "Creating Python virtual environment..."
python3 -m venv venv
source venv/bin/activate
print_step "Virtual environment created and activated"

# Upgrade pip
print_info "Upgrading pip..."
pip install --upgrade pip setuptools wheel -q
print_step "pip upgraded"

# Install Python dependencies
print_info "Installing Python dependencies (this may take 2-3 minutes)..."
pip install -r requirements.txt -q
print_step "Python dependencies installed"

# Step 7: Initialize Database
print_header "Step 7: Initialize Database"
print_info "Waiting for PostgreSQL to be ready..."
sleep 10

print_info "Creating database tables..."
python3 << EOF
import os
import sys
from app.database import engine, Base

try:
    Base.metadata.create_all(bind=engine)
    print("✓ Database tables created successfully")
except Exception as e:
    print(f"✗ Error creating tables: {e}")
    sys.exit(1)
EOF

print_step "Database initialized"

# Step 8: Test Backend
print_header "Step 8: Testing Backend"
print_info "Starting FastAPI server (background process)..."
nohup python main.py > /tmp/abeacon_api.log 2>&1 &
API_PID=$!
sleep 5

print_info "Testing API health endpoint..."
if curl -s http://localhost:8000/health | grep -q "healthy"; then
    print_step "API is healthy and responding"
else
    print_error "API health check failed"
    print_info "Check logs: tail -f /tmp/abeacon_api.log"
fi

# Step 9: Setup Frontend (Optional)
print_header "Step 9: Setting Up Frontend (Optional)"
cd ..

if [ -d "frontend" ]; then
    print_info "Frontend directory exists, checking setup..."
    cd frontend
    if [ ! -d "node_modules" ]; then
        print_info "Installing frontend dependencies..."
        npm install -q
        print_step "Frontend dependencies installed"
    else
        print_info "Frontend dependencies already installed"
    fi
    cd ..
else
    print_info "Frontend directory not found"
    print_info "To create frontend, run: npx create-next-app@latest frontend"
fi

# Step 10: Display Summary
print_header "✓ SETUP COMPLETE!"

echo -e "${GREEN}Services Running:${NC}"
docker-compose ps

echo -e "\n${GREEN}Access Points:${NC}"
echo "  • API:              http://localhost:8000"
echo "  • API Docs:         http://localhost:8000/docs"
echo "  • ReDoc:            http://localhost:8000/redoc"
echo "  • PostgreSQL:       localhost:5432"
echo "  • Redis:            localhost:6379"
echo "  • Meilisearch:      http://localhost:7700"
echo "  • MinIO API:        http://localhost:9000"
echo "  • MinIO Console:    http://localhost:9001 (admin/change_me_password)"

echo -e "\n${GREEN}Quick Commands:${NC}"
echo "  • Activate venv:    cd backend && source venv/bin/activate"
echo "  • Run API:          cd backend && python main.py"
echo "  • View logs:        tail -f /tmp/abeacon_api.log"
echo "  • Stop services:    docker-compose down"
echo "  • Restart services: docker-compose restart"

echo -e "\n${YELLOW}Important:${NC}"
echo "  • Update .env file with secure credentials"
echo "  • Change PostgreSQL password in docker-compose.yml"
echo "  • Change MinIO password in docker-compose.yml"
echo "  • Keep venv activated when working on backend"

echo -e "\n${BLUE}Next Steps:${NC}"
echo "  1. Update credentials in backend/.env"
echo "  2. Test API at http://localhost:8000/docs"
echo "  3. Register a user: POST /api/v1/auth/register"
echo "  4. Create frontend with: npx create-next-app@latest frontend"

echo -e "\n${GREEN}Happy coding! 🚀${NC}\n"
