#!/bin/bash

# ================================================================
# BIGQUERY AI SETUP SCRIPT
# Predictive Data Decay Detection System
# ================================================================

set -e  # Exit on any error

echo "🚀 Setting up BigQuery AI for Predictive Data Decay Detection"
echo "================================================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get current project ID
PROJECT_ID=$(gcloud config get-value project 2>/dev/null)

if [ -z "$PROJECT_ID" ]; then
    echo -e "${RED}❌ No default project set.${NC}"
    echo "Please set your project first:"
    echo "gcloud config set project YOUR_PROJECT_ID"
    exit 1
fi

echo -e "${BLUE}📊 Using project: ${PROJECT_ID}${NC}"

# Check if BigQuery API is enabled
echo -e "${BLUE}🔍 Checking BigQuery API...${NC}"
if ! gcloud services list --enabled --filter="name:bigquery.googleapis.com" --format="value(name)" | grep -q "bigquery.googleapis.com"; then
    echo -e "${YELLOW}⚠️  Enabling BigQuery API...${NC}"
    gcloud services enable bigquery.googleapis.com
fi

# Check if Vertex AI API is enabled
echo -e "${BLUE}🔍 Checking Vertex AI API...${NC}"
if ! gcloud services list --enabled --filter="name:aiplatform.googleapis.com" --format="value(name)" | grep -q "aiplatform.googleapis.com"; then
    echo -e "${YELLOW}⚠️  Enabling Vertex AI API...${NC}"
    gcloud services enable aiplatform.googleapis.com
fi

# Create dataset
echo -e "${BLUE}📁 Creating decay_detection dataset...${NC}"
if ! bq show $PROJECT_ID:decay_detection 2>/dev/null; then
    bq mk --dataset $PROJECT_ID:decay_detection
    echo -e "${GREEN}✅ Dataset created successfully${NC}"
else
    echo -e "${GREEN}✅ Dataset already exists${NC}"
fi

# Create temporary SQL file with correct project ID
echo -e "${BLUE}🔧 Preparing AI model setup...${NC}"
TEMP_SQL=$(mktemp)

# Replace PROJECT_ID placeholder in the SQL file
sed "s/PROJECT_ID/$PROJECT_ID/g" sql/setup-models.sql > $TEMP_SQL

echo -e "${BLUE}🧠 Creating AI models...${NC}"

# Execute the SQL setup
if bq query --use_legacy_sql=false < $TEMP_SQL; then
    echo -e "${GREEN}✅ AI models created successfully${NC}"
else
    echo -e "${RED}❌ Failed to create AI models${NC}"
    echo "Please check your permissions and try again."
    rm $TEMP_SQL
    exit 1
fi

# Clean up temporary file
rm $TEMP_SQL

echo -e "${BLUE}🧪 Testing AI model functionality...${NC}"

# Test embedding model
echo -e "${YELLOW}Testing embedding model...${NC}"
bq query --use_legacy_sql=false "
SELECT 
  'Embedding test successful' as test_status
FROM (
  SELECT 
    ML.GENERATE_EMBEDDING(
      MODEL \`$PROJECT_ID.decay_detection.gemini_embedding_model\`,
      'Test embedding for hackathon demo'
    ) as embedding
)
WHERE ARRAY_LENGTH(embedding) > 0;
"

# Test Gemini Flash model
echo -e "${YELLOW}Testing Gemini Flash model...${NC}"
bq query --use_legacy_sql=false "
SELECT 
  AI.GENERATE_TEXT(
    MODEL \`$PROJECT_ID.decay_detection.gemini_flash_model\`,
    'Say \"BigQuery AI setup complete!\" and explain what predictive data decay detection means in one sentence.'
  ) as ai_response;
"

echo ""
echo -e "${GREEN}================================================================${NC}"
echo -e "${GREEN}🎉 BIGQUERY AI SETUP COMPLETE!${NC}"
echo -e "${GREEN}================================================================${NC}"
echo ""
echo -e "${BLUE}📊 What was created:${NC}"
echo "   ✅ Dataset: $PROJECT_ID.decay_detection"
echo "   ✅ Embedding Model: gemini_embedding_model"
echo "   ✅ Generation Model: gemini_flash_model"
echo ""
echo -e "${BLUE}🚀 Available AI Functions:${NC}"
echo "   • ML.GENERATE_EMBEDDING - Content vectorization"
echo "   • AI.GENERATE_TEXT - Text generation and explanations"
echo "   • AI.GENERATE_DOUBLE - Scoring and predictions"
echo "   • AI.GENERATE_TABLE - Structured output generation"
echo "   • VECTOR_SEARCH - Similarity and pattern matching"
echo ""
echo -e "${BLUE}💰 Estimated costs for hackathon demo:${NC}"
echo "   • Text embeddings: ~$5-10"
echo "   • Gemini Flash: ~$10-20"
echo "   • Total estimated: <$50"
echo ""
echo -e "${BLUE}🎯 Next steps:${NC}"
echo "   1. Run analysis notebook: notebooks/main-analysis.ipynb"
echo "   2. Deploy dashboard: scripts/deploy-dashboard.sh"
echo "   3. Update README with your live URLs"
echo ""
echo -e "${GREEN}🏆 Ready for hackathon submission!${NC}"


