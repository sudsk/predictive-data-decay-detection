#!/bin/bash

# ================================================================
# PREDICTIVE DATA DECAY DETECTION - DASHBOARD DEPLOYMENT SCRIPT
# BigQuery AI Hackathon Submission
# ================================================================

set -e  # Exit on any error

echo "🚀 Deploying Predictive Data Decay Detection Dashboard..."
echo "================================================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if we're in the right directory
if [ ! -f "dashboard/package.json" ]; then
    echo -e "${RED}❌ Error: dashboard/package.json not found.${NC}"
    echo "Please run this script from the repository root directory."
    exit 1
fi

# Navigate to dashboard directory
cd dashboard

echo -e "${BLUE}📁 Current directory: $(pwd)${NC}"

# Check if package.json exists and has content
if [ ! -s "package.json" ]; then
    echo -e "${RED}❌ Error: package.json is empty or missing.${NC}"
    echo "Please ensure the package.json file is properly created."
    exit 1
fi

echo -e "${BLUE}📦 Installing dependencies...${NC}"
npm install

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ npm install failed. Please check the error above.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Dependencies installed successfully!${NC}"

# Check if build works
echo -e "${BLUE}🔨 Building project...${NC}"
npm run build

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Build successful!${NC}"
    
    # Check deployment option
    echo -e "${YELLOW}🚀 Choose deployment option:${NC}"
    echo "1. Vercel (Recommended - Fast & Free)"
    echo "2. Google Cloud Run (Enterprise)"
    echo "3. GitHub Pages (Simple)"
    
    read -p "Enter choice (1-3): " choice
    
    case $choice in
        1)
            echo -e "${BLUE}🌐 Deploying to Vercel...${NC}"
            
            # Check if Vercel CLI is installed
            if ! command -v vercel &> /dev/null; then
                echo -e "${YELLOW}📥 Installing Vercel CLI...${NC}"
                npm install -g vercel
            fi
            
            # Deploy to Vercel
            vercel --prod
            
            if [ $? -eq 0 ]; then
                echo ""
                echo -e "${GREEN}🎉 DEPLOYMENT SUCCESSFUL!${NC}"
                echo -e "${GREEN}📊 Your dashboard is now live on Vercel!${NC}"
                echo ""
                echo -e "${YELLOW}📋 Next steps:${NC}"
                echo "1. Copy the deployment URL from above"
                echo "2. Update README.md with your live dashboard URL"
                echo "3. Test the dashboard functionality"
                echo "4. Take screenshots for documentation"
                echo "5. Record demo video"
                echo ""
                echo -e "${BLUE}🏆 You're ready for hackathon submission!${NC}"
            else
                echo -e "${RED}❌ Vercel deployment failed.${NC}"
                exit 1
            fi
            ;;
            
        2)
            echo -e "${BLUE}☁️  Deploying to Google Cloud Run...${NC}"
            
            # Check if gcloud is installed and configured
            if ! command -v gcloud &> /dev/null; then
                echo -e "${RED}❌ gcloud CLI not found. Please install Google Cloud SDK.${NC}"
                echo "Visit: https://cloud.google.com/sdk/docs/install"
                exit 1
            fi
            
            # Check if project is set
            PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
            if [ -z "$PROJECT_ID" ]; then
                echo -e "${YELLOW}⚠️  No default project set.${NC}"
                read -p "Enter your Google Cloud Project ID: " PROJECT_ID
                gcloud config set project $PROJECT_ID
            fi
            
            echo -e "${BLUE}📤 Deploying to Cloud Run...${NC}"
            gcloud run deploy decay-detection-dashboard \
                --source . \
                --platform managed \
                --region us-central1 \
                --allow-unauthenticated \
                --port 8080
                
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}🎉 Cloud Run deployment successful!${NC}"
            else
                echo -e "${RED}❌ Cloud Run deployment failed.${NC}"
                exit 1
            fi
            ;;
            
        3)
            echo -e "${BLUE}📄 Deploying to GitHub Pages...${NC}"
            
            # Install gh-pages if not present
            if ! npm list gh-pages &>/dev/null; then
                echo -e "${YELLOW}📥 Installing gh-pages...${NC}"
                npm install --save-dev gh-pages
            fi
            
            # Deploy to GitHub Pages
            npm run deploy 2>/dev/null || npx gh-pages -d build
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}🎉 GitHub Pages deployment successful!${NC}"
                echo "Your site will be available at: https://sudskumar.github.io/predictive-data-decay-detection"
            else
                echo -e "${RED}❌ GitHub Pages deployment failed.${NC}"
                exit 1
            fi
            ;;
            
        *)
            echo -e "${RED}❌ Invalid choice. Please run the script again.${NC}"
            exit 1
            ;;
    esac
    
else
    echo -e "${RED}❌ Build failed. Please fix the errors above.${NC}"
    echo ""
    echo -e "${YELLOW}💡 Common issues:${NC}"
    echo "- Missing React component files"
    echo "- Syntax errors in JavaScript/JSX"
    echo "- Missing dependencies in package.json"
    echo "- Incorrect file paths"
    exit 1
fi

echo ""
echo -e "${GREEN}================================================================${NC}"
echo -e "${GREEN}🏆 DEPLOYMENT COMPLETE!${NC}"
echo -e "${GREEN}================================================================${NC}"
echo ""
echo -e "${YELLOW}📊 What you now have:${NC}"
echo "✅ Live dashboard accessible via public URL"
echo "✅ Professional presentation for judges"
echo "✅ Scalable deployment architecture"
echo "✅ Ready for enterprise demonstrations"
echo ""
echo -e "${YELLOW}🎯 Hackathon submission checklist:${NC}"
echo "□ Update README.md with live dashboard URL"
echo "□ Take screenshots of dashboard"
echo "□ Record 3-minute demo video"
echo "□ Test all dashboard features"
echo "□ Submit to Kaggle competition"
echo ""
echo -e "${BLUE}💡 Tips for judges:${NC}"
echo "- Highlight the predictive vs reactive innovation"
echo "- Demonstrate real-time decay scoring"
echo "- Show business impact calculations"
echo "- Emphasize enterprise deployment readiness"
echo ""
echo -e "${GREEN}🚀 Good luck with your hackathon submission!${NC}"
