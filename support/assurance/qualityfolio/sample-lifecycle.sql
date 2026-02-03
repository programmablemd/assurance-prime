-- ============================================================================
-- Sample Lifecycle SQL for surveilr
-- ============================================================================
-- This script demonstrates how to create a custom lifecycle SQL that:
-- 1. Includes the full default bootstrap (for RSSD Web UI)
-- 2. Adds custom tables and data
-- 3. Creates a custom Web UI page
--
-- Usage:
--   First, generate the combined file:
--     cat src/resource_serde/src/bootstrap.sql sample-lifecycle-custom.sql > sample-lifecycle.sql
--
--   Then run:
--     rm -f resource-surveillance.sqlite.db  # Clean start
--     ./target/release/surveilr --lifecycle-sql "sample-lifecycle.sql"
-- ============================================================================

-- NOTE: This file should be APPENDED to bootstrap.sql
-- See sample-lifecycle-custom.sql for the custom part only

-- ============================================================================
-- CUSTOM TABLES SECTION
-- ============================================================================

-- Example: GitHub Issues Tracking
CREATE TABLE IF NOT EXISTS github_issue (
    issue_id TEXT PRIMARY KEY,
    repo_name TEXT NOT NULL,
    issue_number INTEGER NOT NULL,
    title TEXT NOT NULL,
    state TEXT CHECK(state IN ('open', 'closed')) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    author TEXT,
    labels TEXT, -- JSON array
    body TEXT,
    UNIQUE(repo_name, issue_number)
);

-- Example: Custom Project Tracking
CREATE TABLE IF NOT EXISTS custom_project (
    project_id TEXT PRIMARY KEY,
    project_name TEXT NOT NULL UNIQUE,
    description TEXT,
    status TEXT CHECK(status IN ('active', 'completed', 'archived')) DEFAULT 'active',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    owner TEXT
);

-- Example: Custom Metrics
CREATE TABLE IF NOT EXISTS custom_metric (
    metric_id TEXT PRIMARY KEY,
    metric_name TEXT NOT NULL,
    metric_value REAL,
    metric_unit TEXT,
    recorded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    tags TEXT -- JSON object
);

-- ============================================================================
-- CUSTOM VIEWS SECTION
-- ============================================================================

-- View: Open GitHub Issues Summary
CREATE VIEW IF NOT EXISTS github_open_issues_summary AS
SELECT
    repo_name,
    COUNT(*) as open_count,
    MAX(created_at) as latest_issue_date
FROM github_issue
WHERE state = 'open'
GROUP BY repo_name
ORDER BY open_count DESC;

-- ============================================================================
-- SAMPLE DATA SECTION
-- ============================================================================

-- Insert sample GitHub issues
INSERT OR IGNORE INTO github_issue (issue_id, repo_name, issue_number, title, state, author, body)
VALUES
    ('gh-1', 'surveilr/surveilr', 409, 'Inconsistent RSSD Web UI Content', 'open', 'Annjose21', 'When executing surveilr --lifecycle-sql...'),
    ('gh-2', 'surveilr/surveilr', 410, 'Sample Issue 2', 'open', 'testuser', 'This is a test issue'),
    ('gh-3', 'surveilr/surveilr', 411, 'Sample Issue 3', 'closed', 'testuser', 'This issue was resolved');

-- Insert sample projects
INSERT OR IGNORE INTO custom_project (project_id, project_name, description, status, owner)
VALUES
    ('proj-1', 'RSSD Enhancement', 'Improve RSSD Web UI and lifecycle SQL', 'active', 'DevTeam'),
    ('proj-2', 'GitHub Integration', 'Integrate GitHub issues into RSSD', 'active', 'DevTeam'),
    ('proj-3', 'Documentation', 'Update lifecycle SQL documentation', 'completed', 'DocTeam');

-- Insert sample metrics
INSERT OR IGNORE INTO custom_metric (metric_id, metric_name, metric_value, metric_unit, tags)
VALUES
    ('metric-1', 'github_issues_open', 42, 'count', '{"type": "github", "priority": "high"}'),
    ('metric-2', 'database_size', 307, 'KB', '{"type": "database"}'),
    ('metric-3', 'response_time', 125, 'ms', '{"endpoint": "/api/issues"}');

-- ============================================================================
-- CUSTOM WEB UI PAGE
-- ============================================================================
