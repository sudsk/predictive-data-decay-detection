-- ================================================================
-- STACK OVERFLOW TECHNOLOGY EVOLUTION ANALYSIS
-- Part 1: Predictive Data Decay Detection System
-- ================================================================

-- This query analyzes Stack Overflow data to identify technology decay patterns
-- and predict when programming solutions will become outdated

WITH technology_evolution AS (
  SELECT 
    id,
    title,
    tags,
    creation_date,
    view_count,
    score,
    answer_count,
    -- Extract primary technology from tags
    CASE 
      WHEN tags LIKE '%javascript%' THEN 'javascript'
      WHEN tags LIKE '%python%' THEN 'python'
      WHEN tags LIKE '%react%' THEN 'react'  
      WHEN tags LIKE '%jquery%' THEN 'jquery'
      WHEN tags LIKE '%angular%' THEN 'angular'
      WHEN tags LIKE '%nodejs%' THEN 'nodejs'
      WHEN tags LIKE '%typescript%' THEN 'typescript'
      ELSE 'other'
    END as primary_tech,
    -- Generate content embeddings for semantic analysis
    ML.GENERATE_EMBEDDING(
      MODEL `your-project-id.decay_detection.text_embedding_model`,
      CONCAT(title, ' ', COALESCE(body, ''))
    ) as question_embedding
  FROM 
    `bigquery-public-data.stackoverflow.posts_questions` 
  WHERE 
    creation_date >= '2018-01-01'
    AND creation_date <= '2024-01-01'
    AND tags REGEXP r'(javascript|python|react|jquery|angular|nodejs|typescript)'
    AND score >= 3  -- Focus on quality questions
    AND view_count >= 100  -- Ensure reasonable visibility
  LIMIT 10000  -- Manageable dataset for demo
),

-- Calculate technology popularity trends over time
tech_trends AS (
  SELECT 
    primary_tech,
    EXTRACT(YEAR FROM creation_date) as year,
    EXTRACT(QUARTER FROM creation_date) as quarter,
    COUNT(*) as question_count,
    AVG(score) as avg_score,
    AVG(view_count) as avg_views,
    AVG(answer_count) as avg_answers,
    -- Calculate trend metrics
    LAG(COUNT(*)) OVER (
      PARTITION BY primary_tech 
      ORDER BY EXTRACT(YEAR FROM creation_date), EXTRACT(QUARTER FROM creation_date)
    ) as prev_question_count
  FROM technology_evolution
  GROUP BY primary_tech, year, quarter
),

-- AI-powered decay pattern detection
decay_analysis AS (
  SELECT 
    primary_tech,
    year,
    quarter,
    question_count,
    avg_score,
    avg_views,
    -- Calculate growth rate
    CASE 
      WHEN prev_question_count > 0 
      THEN (question_count - prev_question_count) / prev_question_count * 100
      ELSE 0
    END as growth_rate,
    -- AI-generated decay assessment
    AI.GENERATE_DOUBLE(
      MODEL `your-project-id.decay_detection.gemini_model`,
      CONCAT(
        'Analyze technology decay for ', primary_tech, ' in ', CAST(year AS STRING), 
        'Q', CAST(quarter AS STRING), '. Question count: ', CAST(question_count AS STRING),
        ', Average score: ', CAST(ROUND(avg_score, 2) AS STRING),
        ', Growth rate: ', CAST(ROUND(
          CASE 
            WHEN prev_question_count > 0 
            THEN (question_count - prev_question_count) / prev_question_count * 100
            ELSE 0
          END, 2) AS STRING), '%. ',
        'Rate staleness probability 0-1 based on technology lifecycle trends.'
      )
    ) as ai_decay_score,
    -- Manual decay score based on known patterns
    CASE 
      WHEN primary_tech = 'jquery' AND year >= 2020 THEN 0.8
      WHEN primary_tech = 'angular' AND year >= 2022 THEN 0.6
      WHEN primary_tech = 'javascript' THEN 0.3
      WHEN primary_tech = 'python' THEN 0.2  
      WHEN primary_tech = 'react' THEN 0.1
      WHEN primary_tech = 'nodejs' THEN 0.25
      WHEN primary_tech = 'typescript' THEN 0.15
      ELSE 0.4
    END as manual_decay_score
  FROM tech_trends
  WHERE question_count > 5  -- Filter out noise
),

-- Generate predictions for current technologies
current_predictions AS (
  SELECT 
    primary_tech,
    AVG(ai_decay_score) as avg_ai_decay,
    AVG(manual_decay_score) as avg_manual_decay,
    SUM(question_count) as total_questions,
    AVG(growth_rate) as avg_growth_rate,
    -- AI-generated technology recommendation
    AI.GENERATE_TEXT(
      MODEL `your-project-id.decay_detection.gemini_model`,
      CONCAT(
        'Generate strategic recommendation for ', primary_tech, 
        ' technology with average decay score ', CAST(ROUND(AVG(ai_decay_score), 2) AS STRING),
        ' and growth rate ', CAST(ROUND(AVG(growth_rate), 1) AS STRING), '%. ',
        'Should enterprises continue using, migrate from, or invest more in this technology?'
      )
    ) as technology_recommendation,
    -- Predict future timeline
    AI.GENERATE_TEXT(
      MODEL `your-project-id.decay_detection.gemini_model`,
      CONCAT(
        'Predict timeline for ', primary_tech, ' technology relevance based on decay score ',
        CAST(ROUND(AVG(ai_decay_score), 2) AS STRING), '. When will this technology become outdated?'
      )
    ) as prediction_timeline
  FROM decay_analysis
  WHERE year >= 2022  -- Focus on recent data
  GROUP BY primary_tech
)

-- ================================================================
-- FINAL OUTPUT: Technology Decay Analysis Results
-- ================================================================

SELECT 
  'TECHNOLOGY_TRENDS' as analysis_type,
  primary_tech as technology,
  year,
  quarter,
  question_count,
  ROUND(avg_score, 2) as avg_score,
  ROUND(avg_views, 0) as avg_views,
  ROUND(growth_rate, 2) as growth_rate_percent,
  ROUND(ai_decay_score, 3) as ai_decay_score,
  ROUND(manual_decay_score, 3) as manual_decay_score,
  CASE 
    WHEN ai_decay_score >= 0.7 THEN 'HIGH_RISK'
    WHEN ai_decay_score >= 0.4 THEN 'MEDIUM_RISK'
    ELSE 'LOW_RISK'
  END as risk_category,
  NULL as recommendation,
  NULL as timeline
FROM decay_analysis

UNION ALL

SELECT 
  'TECHNOLOGY_PREDICTIONS' as analysis_type,
  primary_tech as technology,
  2024 as year,
  1 as quarter,
  total_questions as question_count,
  NULL as avg_score,
  NULL as avg_views,
  avg_growth_rate as growth_rate_percent,
  avg_ai_decay as ai_decay_score,
  avg_manual_decay as manual_decay_score,
  CASE 
    WHEN avg_ai_decay >= 0.7 THEN 'HIGH_RISK'
    WHEN avg_ai_decay >= 0.4 THEN 'MEDIUM_RISK'
    ELSE 'LOW_RISK'
  END as risk_category,
  technology_recommendation as recommendation,
  prediction_timeline as timeline
FROM current_predictions

ORDER BY analysis_type, ai_decay_score DESC, year DESC, quarter DESC;

-- ================================================================
-- ADDITIONAL ANALYTICS: Technology Ecosystem Health
-- ================================================================

-- Summary statistics for dashboard
WITH ecosystem_health AS (
  SELECT 
    COUNT(DISTINCT primary_tech) as total_technologies,
    AVG(ai_decay_score) as overall_avg_decay,
    SUM(CASE WHEN ai_decay_score >= 0.7 THEN 1 ELSE 0 END) as high_risk_count,
    SUM(CASE WHEN ai_decay_score BETWEEN 0.4 AND 0.69 THEN 1 ELSE 0 END) as medium_risk_count,
    SUM(CASE WHEN ai_decay_score < 0.4 THEN 1 ELSE 0 END) as low_risk_count,
    SUM(question_count) as total_questions_analyzed
  FROM decay_analysis
  WHERE year = 2023  -- Most recent complete year
)

SELECT 
  'ECOSYSTEM_SUMMARY' as metric_type,
  total_technologies,
  ROUND(overall_avg_decay, 3) as avg_decay_score,
  high_risk_count,
  medium_risk_count,
  low_risk_count,
  total_questions_analyzed,
  -- Business impact calculation
  high_risk_count * 10000 as estimated_migration_cost_per_tech,
  ROUND(overall_avg_decay * 100, 1) as decay_percentage
FROM ecosystem_health;

-- ================================================================
-- VECTOR SIMILARITY ANALYSIS
-- Find technologies with similar decay patterns
-- ================================================================

WITH technology_embeddings AS (
  SELECT 
    primary_tech,
    AVG(ai_decay_score) as avg_decay,
    -- Create feature vector for similarity analysis
    ML.GENERATE_EMBEDDING(
      MODEL `your-project-id.decay_detection.text_embedding_model`,
      CONCAT(
        primary_tech, ' technology with decay score ', 
        CAST(ROUND(AVG(ai_decay_score), 2) AS STRING),
        ' and growth rate ', CAST(ROUND(AVG(growth_rate), 1) AS STRING)
      )
    ) as tech_embedding
  FROM decay_analysis
  WHERE year >= 2022
  GROUP BY primary_tech
)

SELECT 
  t1.primary_tech as base_technology,
  t1.avg_decay as base_decay_score,
  -- Find similar technologies using vector search
  VECTOR_SEARCH(
    TABLE technology_embeddings,
    (SELECT tech_embedding FROM technology_embeddings t2 WHERE t2.primary_tech = t1.primary_tech),
    top_k => 3,
    distance_type => 'COSINE'
  ).primary_tech as similar_technology,
  VECTOR_SEARCH(
    TABLE technology_embeddings,
    (SELECT tech_embedding FROM technology_embeddings t2 WHERE t2.primary_tech = t1.primary_tech),
    top_k => 3,
    distance_type => 'COSINE'
  ).distance as similarity_distance
FROM technology_embeddings t1
WHERE t1.primary_tech IN ('jquery', 'react', 'python', 'javascript')
ORDER BY base_technology, similarity_distance;

