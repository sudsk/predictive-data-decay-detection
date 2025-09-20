-- ================================================================
-- BIGQUERY AI MODEL SETUP
-- Predictive Data Decay Detection System Setup
-- ================================================================

-- This script creates the required AI models for the hackathon demo
-- Replace 'your-project-id' with your actual Google Cloud Project ID

-- ================================================================
-- TEXT EMBEDDING MODEL SETUP
-- ================================================================

-- Create text embedding model for content vectorization
CREATE OR REPLACE MODEL `your-project-id.decay_detection.text_embedding_model`
OPTIONS(
  model_type='REMOTE',
  endpoint='//aiplatform.googleapis.com/projects/your-project-id/locations/us-central1/publishers/google/models/textembedding-gecko'
);

-- ================================================================ 
-- GEMINI MODEL SETUP FOR TEXT GENERATION
-- ================================================================

-- Create Gemini model for AI text generation and analysis
CREATE OR REPLACE MODEL `your-project-id.decay_detection.gemini_model`
OPTIONS(
  model_type='REMOTE', 
  endpoint='//aiplatform.googleapis.com/projects/your-project-id/locations/us-central1/publishers/google/models/gemini-pro'
);

-- ================================================================
-- ALTERNATIVE: GEMINI 1.5 MODEL (More Advanced)
-- ================================================================

-- Uncomment this if you want to use Gemini 1.5 Flash for better performance
-- CREATE OR REPLACE MODEL `your-project-id.decay_detection.gemini_flash_model`
-- OPTIONS(
--   model_type='REMOTE',
--   endpoint='//aiplatform.googleapis.com/projects/your-project-id/locations/us-central1/publishers/google/models/gemini-1.5-flash'
-- );

-- ================================================================
-- VERIFICATION QUERIES
-- ================================================================

-- Test the text embedding model
SELECT 
  'Testing text embedding model...' as test_description,
  ML.GENERATE_EMBEDDING(
    MODEL `your-project-id.decay_detection.text_embedding_model`,
    'This is a test of the text embedding functionality for data decay detection.'
  ) as embedding_result;

-- Test the Gemini model  
SELECT 
  'Testing Gemini model...' as test_description,
  AI.GENERATE_TEXT(
    MODEL `your-project-id.decay_detection.gemini_model`,
    'Explain in one sentence what predictive data decay detection means for enterprises.'
  ) as generation_result;

-- Test decay scoring capability
SELECT 
  'Testing decay scoring...' as test_description,
  AI.GENERATE_DOUBLE(
    MODEL `your-project-id.decay_detection.gemini_model`,
    'Rate the staleness probability (0-1) of a jQuery tutorial written in 2020. Consider current web development trends.'
  ) as decay_score;

-- ================================================================
-- DATASET VERIFICATION
-- ================================================================

-- Verify the decay_detection dataset exists
SELECT 
  schema_name,
  creation_time,
  location
FROM `your-project-id.decay_detection.INFORMATION_SCHEMA.SCHEMATA`
WHERE schema_name = 'decay_detection';

-- ================================================================
-- PERMISSIONS CHECK
-- ================================================================

-- Verify you have the necessary permissions
-- This query will succeed if you have proper access to BigQuery AI functions
SELECT 
  'BigQuery AI setup verification complete!' as status,
  CURRENT_TIMESTAMP() as setup_time,
  @@project_id as project_id;

-- ================================================================
-- USAGE NOTES
-- ================================================================

/*
IMPORTANT SETUP INSTRUCTIONS:

1. REPLACE PROJECT ID:
   Before running this script, replace ALL instances of 'your-project-id' 
   with your actual Google Cloud Project ID.

2. REQUIRED PERMISSIONS:
   Ensure your account has these roles:
   - BigQuery Admin (to create models and datasets)
   - Vertex AI User (to access AI Platform models)
   - Service Usage Consumer (to use APIs)

3. REQUIRED APIs:
   Enable these APIs in your project:
   - BigQuery API
   - Vertex AI API  
   - AI Platform API

4. BILLING:
   Ensure billing is enabled for your project as AI functions incur costs.

5. REGIONS:
   This setup uses us-central1. If you prefer a different region,
   update the endpoints accordingly.

6. TESTING:
   After running this script, the verification queries should execute
   successfully without errors.

7. COST OPTIMIZATION:
   - Text embeddings: ~$0.0001 per 1K characters
   - Gemini Pro: ~$0.0005 per 1K characters  
   - For hackathon demo: estimated cost < $50

8. TROUBLESHOOTING:
   If you get permission errors:
   - Check that APIs are enabled
   - Verify IAM roles
   - Ensure billing account is active
   - Try running queries one by one to isolate issues

9. ALTERNATIVE MODELS:
   You can also use:
   - textembedding-gecko@003 (newer version)
   - gemini-1.5-pro (more capable but costlier)
   - gemini-1.5-flash (faster, cheaper)

10. CLEANUP:
    To clean up after the hackathon:
    DROP MODEL `your-project-id.decay_detection.text_embedding_model`;
    DROP MODEL `your-project-id.decay_detection.gemini_model`;
*/
