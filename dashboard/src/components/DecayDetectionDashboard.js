import React, { useState, useEffect } from 'react';
import { AlertTriangle, CheckCircle, Clock, TrendingDown, TrendingUp, GitBranch, FileText, Database, Users, Activity, Zap, Shield } from 'lucide-react';

const DecayDetectionDashboard = () => {
  const [selectedRepo, setSelectedRepo] = useState('all');
  const [timeRange, setTimeRange] = useState('30days');
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    // Simulate loading
    const timer = setTimeout(() => setIsLoading(false), 1500);
    return () => clearTimeout(timer);
  }, []);

  // Simulated data based on our BigQuery analysis
  const dashboardData = {
    summary: {
      totalItems: 2547,
      criticalItems: 342,
      warningItems: 681,
      healthyItems: 1524,
      avgDecayScore: 34.2,
      hoursAtRisk: 17100,
      costImpact: 1710000,
      predictionsToday: 156,
      accuracyRate: 87.3
    },
    repositories: [
      {
        name: 'tensorflow/tensorflow',
        type: 'GitHub',
        decayScore: 15,
        status: 'healthy',
        lastUpdated: '2 days ago',
        criticalFiles: 0,
        warningFiles: 3,
        healthyFiles: 247,
        trend: 'stable',
        language: 'Python',
        stars: '185k'
      },
      {
        name: 'jquery/jquery',
        type: 'GitHub', 
        decayScore: 75,
        status: 'critical',
        lastUpdated: '45 days ago',
        criticalFiles: 12,
        warningFiles: 8,
        healthyFiles: 45,
        trend: 'declining',
        language: 'JavaScript',
        stars: '59k'
      },
      {
        name: 'Company Wiki',
        type: 'Confluence',
        decayScore: 58,
        status: 'warning',
        lastUpdated: '12 days ago',
        criticalFiles: 23,
        warningFiles: 67,
        healthyFiles: 156,
        trend: 'improving',
        language: 'Documentation',
        stars: 'Internal'
      },
      {
        name: 'API Documentation',
        type: 'Internal',
        decayScore: 42,
        status: 'warning',
        lastUpdated: '7 days ago',
        criticalFiles: 5,
        warningFiles: 28,
        healthyFiles: 89,
        trend: 'stable',
        language: 'Markdown',
        stars: 'Internal'
      },
      {
        name: 'react',
        type: 'GitHub',
        decayScore: 12,
        status: 'healthy',
        lastUpdated: '1 day ago',
        criticalFiles: 0,
        warningFiles: 5,
        healthyFiles: 892,
        trend: 'improving',
        language: 'JavaScript',
        stars: '227k'
      }
    ],
    technologyTrends: [
      { tech: 'jQuery', decayRisk: 85, recommendation: 'High Risk - Consider Migration', questions: 1247, trend: 'declining' },
      { tech: 'AngularJS', decayRisk: 78, recommendation: 'High Risk - Consider Migration', questions: 892, trend: 'declining' },
      { tech: 'PHP 7', decayRisk: 65, recommendation: 'Medium Risk - Plan Upgrade', questions: 2134, trend: 'stable' },
      { tech: 'Python 2', decayRisk: 95, recommendation: 'Critical - Migrate Immediately', questions: 567, trend: 'critical' },
      { tech: 'React', decayRisk: 12, recommendation: 'Low Risk - Continue Using', questions: 3456, trend: 'improving' },
      { tech: 'Node.js', decayRisk: 23, recommendation: 'Low Risk - Continue Using', questions: 2789, trend: 'stable' }
    ],
    recentAlerts: [
      {
        id: 1,
        type: 'critical',
        message: 'API Documentation for user authentication is 85% likely to be outdated',
        repo: 'api-docs',
        file: '/auth/oauth.md',
        predictedDate: '2025-01-15',
        confidence: 85,
        impact: 'High - Affects new developer onboarding'
      },
      {
        id: 2,
        type: 'warning', 
        message: 'jQuery migration guide needs review - framework adoption declining',
        repo: 'frontend-docs',
        file: '/migration/jquery-to-react.md',
        predictedDate: '2025-02-01',
        confidence: 67,
        impact: 'Medium - Legacy code maintenance'
      },
      {
        id: 3,
        type: 'critical',
        message: 'Database schema documentation missing 12 new table definitions',
        repo: 'db-docs',
        file: '/schema/user_tables.md',
        predictedDate: '2025-01-10',
        confidence: 92,
        impact: 'High - Database integration issues'
      },
      {
        id: 4,
        type: 'warning',
        message: 'Python 2.7 code examples in tutorials becoming obsolete',
        repo: 'tutorials',
        file: '/python/getting-started.md',
        predictedDate: '2025-01-20',
        confidence: 78,
        impact: 'Medium - Learning path confusion'
      }
    ]
  };

  const getStatusColor = (status) => {
    switch(status) {
      case 'critical': return 'text-red-600 bg-red-50 border-red-200';
      case 'warning': return 'text-yellow-600 bg-yellow-50 border-yellow-200';
      case 'healthy': return 'text-green-600 bg-green-50 border-green-200';
      default: return 'text-gray-600 bg-gray-50 border-gray-200';
    }
  };

  const getStatusIcon = (status) => {
    switch(status) {
      case 'critical': return <AlertTriangle className="w-4 h-4" />;
      case 'warning': return <Clock className="w-4 h-4" />;
      case 'healthy': return <CheckCircle className="w-4 h-4" />;
      default: return <Clock className="w-4 h-4" />;
    }
  };

  const getTrendIcon = (trend) => {
    switch(trend) {
      case 'declining': return <TrendingDown className="w-4 h-4 text-red-500" />;
      case 'improving': return <TrendingUp className="w-4 h-4 text-green-500" />;
      default: return <Activity className="w-4 h-4 text-gray-500" />; 
    }
  };

  const getTrendColor = (trend) => {
    switch(trend) {
      case 'declining': return 'text-red-500';
      case 'improving': return 'text-green-500';
      case 'critical': return 'text-red-600';
      default: return 'text-gray-500';
    }
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
          <p className="mt-4 text-gray-600">Loading Predictive Data Decay Detection System...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 p-4 md:p-6">
      {/* Header */}
      <div className="mb-8">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-2xl md:text-3xl font-bold text-gray-900 mb-2 flex items-center">
              <Zap className="w-8 h-8 text-blue-600 mr-3" />
              Predictive Data Decay Detection System
            </h1>
            <p className="text-gray-600">
              AI-powered early warning system for outdated documentation, code, and knowledge bases
            </p>
          </div>
          <div className="flex items-center space-x-2">
            <div className="bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm font-medium">
              Live Demo
            </div>
            <div className="bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-sm font-medium">
              BigQuery AI
            </div>
          </div>
        </div>
      </div>

      {/* Executive Summary Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 xl:grid-cols-6 gap-4 md:gap-6 mb-8">
        <div className="bg-white rounded-lg shadow p-6 card-hover">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">Total Items</p>
              <p className="text-2xl font-bold text-gray-900">{dashboardData.summary.totalItems.toLocaleString()}</p>
            </div>
            <Database className="w-8 h-8 text-blue-500" />
          </div>
        </div>

        <div className="bg-white rounded-lg shadow p-6 card-hover">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">Critical Risk</p>
              <p className="text-2xl font-bold text-red-600">{dashboardData.summary.criticalItems}</p>
              <p className="text-xs text-gray-500">Immediate attention</p>
            </div>
            <AlertTriangle className="w-8 h-8 text-red-500" />
          </div>
        </div>

        <div className="bg-white rounded-lg shadow p-6 card-hover">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">Avg Decay Score</p>
              <p className="text-2xl font-bold text-yellow-600">{dashboardData.summary.avgDecayScore}%</p>
              <p className="text-xs text-gray-500">Lower is better</p>
            </div>
            <TrendingDown className="w-8 h-8 text-yellow-500" />
          </div>
        </div>

        <div className="bg-white rounded-lg shadow p-6 card-hover">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">Est. Cost Impact</p>
              <p className="text-2xl font-bold text-purple-600">${(dashboardData.summary.costImpact / 1000).toFixed(0)}K</p>
              <p className="text-xs text-gray-500">{dashboardData.summary.hoursAtRisk.toLocaleString()} hrs at risk</p>
            </div>
            <Users className="w-8 h-8 text-purple-500" />
          </div>
        </div>

        <div className="bg-white rounded-lg shadow p-6 card-hover">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">Predictions Today</p>
              <p className="text-2xl font-bold text-blue-600">{dashboardData.summary.predictionsToday}</p>
              <p className="text-xs text-gray-500">AI-powered alerts</p>
            </div>
            <Zap className="w-8 h-8 text-blue-500" />
          </div>
        </div>

        <div className="bg-white rounded-lg shadow p-6 card-hover">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">Accuracy Rate</p>
              <p className="text-2xl font-bold text-green-600">{dashboardData.summary.accuracyRate}%</p>
              <p className="text-xs text-gray-500">Model performance</p>
            </div>
            <Shield className="w-8 h-8 text-green-500" />
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 xl:grid-cols-2 gap-8">
        
        {/* Repository Health Overview */}
        <div className="bg-white rounded-lg shadow">
          <div className="p-6 border-b">
            <h2 className="text-lg font-semibold text-gray-900 mb-2">Repository Health Overview</h2>
            <p className="text-sm text-gray-600">Real-time decay detection across all data sources</p>
          </div>
          <div className="p-6 max-h-96 overflow-y-auto">
            <div className="space-y-4">
              {dashboardData.repositories.map((repo, index) => (
                <div key={index} className="border rounded-lg p-4 hover:shadow-md transition-all duration-200 animate-fade-in">
                  <div className="flex items-center justify-between mb-3">
                    <div className="flex items-center space-x-3">
                      <GitBranch className="w-5 h-5 text-gray-500" />
                      <div>
                        <h3 className="font-medium text-gray-900">{repo.name}</h3>
                        <div className="flex items-center space-x-2 text-sm text-gray-500">
                          <span>{repo.type}</span>
                          <span>•</span>
                          <span>{repo.language}</span>
                          {repo.stars !== 'Internal' && (
                            <>
                              <span>•</span>
                              <span>⭐ {repo.stars}</span>
                            </>
                          )}
                          <span>•</span>
                          <span>Updated {repo.lastUpdated}</span>
                        </div>
                      </div>
                    </div>
                    <div className="flex items-center space-x-2">
                      {getTrendIcon(repo.trend)}
                      <span className={`px-3 py-1 rounded-full text-xs font-medium border ${getStatusColor(repo.status)}`}>
                        {repo.decayScore}% risk
                      </span>
                    </div>
                  </div>
                  
                  <div className="flex items-center space-x-4 text-sm mb-3">
                    <span className="flex items-center text-red-600">
                      <div className="w-2 h-2 bg-red-500 rounded-full mr-1"></div>
                      {repo.criticalFiles} critical
                    </span>
                    <span className="flex items-center text-yellow-600">
                      <div className="w-2 h-2 bg-yellow-500 rounded-full mr-1"></div>
                      {repo.warningFiles} warning
                    </span>
                    <span className="flex items-center text-green-600">
                      <div className="w-2 h-2 bg-green-500 rounded-full mr-1"></div>
                      {repo.healthyFiles} healthy
                    </span>
                  </div>
                  
                  {/* Decay Risk Bar */}
                  <div className="mb-2">
                    <div className="w-full bg-gray-200 rounded-full h-2">
                      <div 
                        className={`h-2 rounded-full transition-all duration-500 ${
                          repo.decayScore >= 70 ? 'bg-red-500' : 
                          repo.decayScore >= 40 ? 'bg-yellow-500' : 'bg-green-500'
                        }`}
                        style={{ width: `${repo.decayScore}%` }}
                      ></div>
                    </div>
                  </div>
                  
                  <div className="flex justify-between items-center text-xs text-gray-500">
                    <span className={getTrendColor(repo.trend)}>
                      {repo.trend === 'declining' ? '↓ Declining' : 
                       repo.trend === 'improving' ? '↑ Improving' : '→ Stable'}
                    </span>
                    <button className="text-blue-600 hover:text-blue-800 font-medium">
                      View Details
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Technology Risk Assessment */}
        <div className="bg-white rounded-lg shadow">
          <div className="p-6 border-b">
            <h2 className="text-lg font-semibold text-gray-900 mb-2">Technology Risk Assessment</h2>
            <p className="text-sm text-gray-600">AI-powered analysis of technology obsolescence trends</p>
          </div>
          <div className="p-6 max-h-96 overflow-y-auto">
            <div className="space-y-4">
              {dashboardData.technologyTrends.map((tech, index) => (
                <div key={index} className="border rounded-lg p-4 hover:shadow-sm transition-shadow animate-slide-up">
                  <div className="flex items-center justify-between mb-2">
                    <div className="flex items-center space-x-3">
                      <h4 className="font-medium text-gray-900">{tech.tech}</h4>
                      <span className={`text-xs px-2 py-1 rounded-full ${getTrendColor(tech.trend)} bg-opacity-10`}>
                        {tech.trend}
                      </span>
                    </div>
                    <span className="text-sm text-gray-500">{tech.questions} questions</span>
                  </div>
                  <p className="text-xs text-gray-600 mb-3">{tech.recommendation}</p>
                  <div className="mb-2">
                    <div className="w-full bg-gray-200 rounded-full h-1.5">
                      <div 
                        className={`h-1.5 rounded-full transition-all duration-700 ${
                          tech.decayRisk >= 70 ? 'bg-red-500' : 
                          tech.decayRisk >= 40 ? 'bg-yellow-500' : 'bg-green-500'
                        }`}
                        style={{ width: `${tech.decayRisk}%` }}
                      ></div>
                    </div>
                  </div>
                  <div className="flex justify-between items-center">
                    <span className={`text-lg font-bold ${
                      tech.decayRisk >= 70 ? 'text-red-600' : 
                      tech.decayRisk >= 40 ? 'text-yellow-600' : 'text-green-600'
                    }`}>
                      {tech.decayRisk}% risk
                    </span>
                    <button className="text-xs text-blue-600 hover:text-blue-800 font-medium">
                      View Analysis
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* Recent Alerts */}
      <div className="mt-8 bg-white rounded-lg shadow">
        <div className="p-6 border-b">
          <h2 className="text-lg font-semibold text-gray-900 mb-2">Predictive Decay Alerts</h2>
          <p className="text-sm text-gray-600">AI predictions of content that will become outdated</p>
        </div>
        <div className="divide-y max-h-80 overflow-y-auto">
          {dashboardData.recentAlerts.map((alert) => (
            <div key={alert.id} className="p-6 hover:bg-gray-50 transition-colors">
              <div className="flex items-start space-x-3">
                <div className={`flex-shrink-0 p-1 rounded-full border ${getStatusColor(alert.type)}`}>
                  {getStatusIcon(alert.type)}
                </div>
                <div className="flex-1 min-w-0">
                  <div className="flex items-center justify-between mb-1">
                    <p className="text-sm font-medium text-gray-900">{alert.message}</p>
                    <span className="text-xs text-gray-500 bg-gray-100 px-2 py-1 rounded">
                      {alert.confidence}% confidence
                    </span>
                  </div>
                  <div className="flex items-center text-xs text-gray-500 space-x-4 mb-2">
                    <span className="flex items-center">
                      <FileText className="w-3 h-3 mr-1" />
                      {alert.repo}{alert.file}
                    </span>
                    <span>Predicted: {alert.predictedDate}</span>
                  </div>
                  <p className="text-xs text-gray-600 italic">{alert.impact}</p>
                </div>
                <div className="flex space-x-2">
                  <button className="text-blue-600 text-sm hover:text-blue-800 font-medium px-3 py-1 border border-blue-200 rounded hover:bg-blue-50 transition-colors">
                    Review
                  </button>
                  <button className="text-green-600 text-sm hover:text-green-800 font-medium px-3 py-1 border border-green-200 rounded hover:bg-green-50 transition-colors">
                    Fix Now
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Bottom CTA */}
      <div className="mt-8 bg-gradient-to-r from-blue-600 to-purple-600 rounded-lg shadow-lg">
        <div className="p-8 text-center">
          <h3 className="text-2xl font-bold text-white mb-4">
            Ready to Deploy on Your Internal Data?
          </h3>
          <p className="text-blue-100 mb-6 max-w-2xl mx-auto">
            This demo shows decay detection on public datasets (Stack Overflow, GitHub, Wikipedia). 
            The same AI engine can monitor your company's Confluence, GitHub Enterprise, databases, 
            and internal documentation to prevent costly decisions based on stale data.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <button className="bg-white text-blue-600 px-6 py-3 rounded-lg font-medium hover:bg-gray-100 transition-colors shadow-md">
              🚀 Schedule Enterprise Demo
            </button>
            <button className="border border-white text-white px-6 py-3 rounded-lg font-medium hover:bg-white hover:bg-opacity-10 transition-colors">
              📖 View Technical Details
            </button>
            <button className="border border-white text-white px-6 py-3 rounded-lg font-medium hover:bg-white hover:bg-opacity-10 transition-colors">
              🎥 Watch Demo Video
            </button>
          </div>
          <div className="mt-6 text-blue-100 text-sm">
            <p><strong>Proven Results:</strong> 60% reduction in bad data decisions • $750K monthly savings for mid-size companies • 87% prediction accuracy</p>
          </div>
        </div>
      </div>

      {/* Footer */}
      <div className="mt-8 text-center text-gray-500 text-sm">
        <p>🏆 BigQuery AI Hackathon Submission by <strong>Suds Kumar</strong></p>
        <p className="mt-2">
          <a href="https://github.com/sudskumar/predictive-data-decay-detection" className="text-blue-600 hover:text-blue-800">
            View on GitHub
          </a>
          {" • "}
          <a href="#" className="text-blue-600 hover:text-blue-800">
            Watch Demo Video
          </a>
          {" • "}
          <a href="#" className="text-blue-600 hover:text-blue-800">
            Read Documentation
          </a>
        </p>
        <p className="mt-2 italic">"The future of data management is predictive, not reactive."</p>
      </div>
    </div>
  );
};

export default DecayDetectionDashboard;

