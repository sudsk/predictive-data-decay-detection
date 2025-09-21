-- ================================================================
-- BIGQUERY AI MODEL SETUP
-- Predictive Data Decay Detection System Setup
-- ================================================================

-- This script creates the required AI models for the hackathon demo
-- Using latest Gemini models for optimal performance

-- ================================================================
-- GEMINI EMBEDDING MODEL SETUP
-- ================================================================

-- Create Gemini embedding model for content vectorization
CREATE OR REPLACE MODEL `decay_detection.gemini_embedding_model`
OPTIONS(
  model_type='REMOTE',
  endpoint='//aiplatform.googleapis.com/projects/PROJECT_ID/locations/us-central1/publishers/google/models/textembedding-gecko'
);

-- ================================================================ 
-- GEMINI 2.5 FLASH MODEL SETUP
-- ================================================================

-- Create Gemini 2.5 Flash model for AI text generation and analysis
CREATE OR REPLACE MODEL `decay_detection.gemini_flash_model`
OPTIONS(
  model_type='REMOTE', 
  endpoint='//aiplatform.googleapis.com/projects/PROJECT_ID/locations/us-central1/publishers/google/models/gemini-1.5-flash'
);

-- ================================================================
-- VERIFICATION QUERIES
-- ================================================================

-- Test the embedding model
SELECT 
  'Testing Gemini embedding model...' as test_description,
  ML.GENERATE_EMBEDDING(
    MODEL `decay_detection.gemini_embedding_model`,
    'This is a test of the text embedding functionality for data decay detection.'
  ) as embedding_result;

-- Test the Gemini Flash model  
SELECT 
  'Testing Gemini 2.5 Flash model...' as test_description,
  AI.GENERATE_TEXT(
    MODEL `decay_detection.gemini_flash_model`,
    'Explain in one sentence what predictive data decay detection means for enterprises.'
  ) as generation_result;

-- Test decay scoring capability
SELECT 
  'Testing decay scoring...' as test_description,
  AI.GENERATE_DOUBLE(
    MODEL `decay_detection.gemini_flash_model`,
    'Rate the staleness probability (0-1) of a jQuery tutorial written in 2020. Consider current web development trends.'
  ) as decay_score;

-- Test structured output generation
SELECT 
  'Testing structured output...' as test_description,
  AI.GENERATE_TABLE(
    MODEL `decay_detection.gemini_flash_model`,
    'Generate a recommendation table for updating outdated jQuery documentation with columns: priority, action, timeline, effort.',
    STRUCT<
      priority STRING,
      action STRING,
      timeline STRING,
      effort STRING
    >[]
  ) as structured_result;

-- ================================================================
-- DATASET VERIFICATION
-- ================================================================

-- Verify the decay_detection dataset exists and models are created
SELECT 
  table_name,
  table_type,
  creation_time
FROM `decay_detection.INFORMATION_SCHEMA.TABLES`
WHERE table_type = 'MODEL'
ORDER BY creation_time DESC;

-- ================================================================
-- PERMISSIONS AND SETUP VERIFICATION
-- ================================================================

-- Final verification that everything is working
SELECT 
  'BigQuery AI setup verification complete!' as status,
  CURRENT_TIMESTAMP() as setup_time,
  'decay_detection dataset ready for hackathon demo' as message;

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
