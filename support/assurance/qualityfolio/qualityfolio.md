---
sqlpage-conf:
  database_url: "sqlite://resource-surveillance.sqlite.db?mode=rwc"
  web_root: "./dev-src.auto"
  allow_exec: true
  port: "9227"
---
 
```code DEFAULTS
sql * --interpolate --injectable
```
 
# **Spry for Test Management**
 
Spry helps QA and Test Engineering teams **unify documentation,
automation, and execution** into a single, always-accurate workflow.
Instead of maintaining scattered test scripts, wiki pages, CI pipelines,
and notes, Spry allows you to write Markdown that is both **readable**
and **executable** --- keeping your test processes consistent,
automated, and audit-ready.
 
## What Spry Solves
 
Test workflows often become fragmented across tools, repos, and teams.
Spry fixes:
 
- Outdated test documentation\
- Manual steps in test execution\
- Test scripts stored without explanations\
- Lack of standard test-run procedures\
- No single place for evidence capture\
- Difficulty onboarding QA and new engineers
 
Spry ensures tests, execution buttons, and documentation all stay in
sync.
 
## Who Should Use Spry?
 
Spry is ideal for teams managing:
 
- Manual + automated testing\
- Regression test cycles\
- Playwright / Selenium / API test suites\
- QA operations\
- DevOps-driven test automation\
- CI/CD test runs\
- Evidence capture for audits (SOC 2, HIPAA, ISO)
 
## Why Spry for Test Management
 
- **Keeps test documentation executable & up to date**\
- **Unifies test scripts, workflows, and evidence**\
- **Accelerates QA cycles** through instant automation\
- **Reduces manual execution errors**\
- **Improves visibility** across QA, DevOps, and Production teams
 
## Unified QA Workflow With Spry
 
Spry ties all critical QA components together:
 
### Human-Readable Test Documentation
 
Describe test purpose, scope, and expected results in Markdown.
 
### Embedded Test Execution
 
Run Playwright, API tests, or CLI tools directly from the same file.
 
### Evidence Capture
 
Save logs, screenshots, and test output for audits or reviews.
 
### Reporting
 
Generate complete test execution reports automatically.
 
---
 
# **Core Test Management Tasks**
 
## **Run Playwright Tests**
 
### **Purpose:**
 
<!-- Execute all Playwright tests inside the `test-artifacts` folder.
 
\`\`\`bash playwright-test -C PlaywrightTest --descr "Run Playwright
tests in the test-artifacts folder" #!/usr/bin/env -S bash -->
 
# Navigate to the test-artifacts directory
 

 
## How To Run Tasks
 
# Run Playwright tests in the test-artifacts folder
 
<!-- ```bash playwright-test -C PlaywrightTest --descr "Run Playwright tests in the test-artifacts folder"
#!/usr/bin/env -S bash
 
# Navigate to the test-artifacts directory
cd ../../../../test-artifacts
 
# Installation and configuration
npm install
npx playwright install
 
# Run Playwright tests
npx playwright test
 
 
``` -->
 
# Surveilr Ingest Files
 
```bash ingest --descr "Ingest Files"
#!/usr/bin/env -S bash
# rm -rf resource-surveillance.sqlite.db
surveilr ingest files -r ./test-artifacts && surveilr orchestrate transform-markdown
```
 
# SQL query
 
```bash deploy -C --descr "Generate sqlpage_files table upsert SQL and push them to SQLite"
cat qualityfolio-json-etl.sql | sqlite3 resource-surveillance.sqlite.db
```
 
```bash prepare-sqlpage-dev --descr "Generate the dev-src.auto directory to work in SQLPage dev mode"
spry sp spc --fs dev-src.auto --destroy-first --conf sqlpage/sqlpage.json
```
 
# SQL Page
 
```sql PARTIAL global-layout.sql --inject **/*
-- BEGIN: PARTIAL global-layout.sql
SELECT 'shell' AS component,
       NULL AS icon,
       'https://www.surveilr.com/assets/brand/qf-logo.png' AS favicon,
       'https://www.surveilr.com/assets/brand/qf-logo.png' AS image,
       'fluid' AS layout,
       true AS fixed_top_menu,
       'index.sql' AS link,
       '{"link":"/index.sql"}' AS menu_item;
 
${ctx.breadcrumbs()}
 
select
    'divider'            as component,
    'QA Progress & Performance Dashboard' as contents,
    5                  as size,
    'blue'               as color;
 
```
 
```sql index.sql { route: { caption: "Home Page" } }
 
SELECT
  'text' AS component,
  'The dashboard provides a centralized view of your testing efforts, displaying key metrics such as test progress, results, and team productivity. It offers visual insights with charts and reports, enabling efficient tracking of test runs, milestones, and issue trends, ensuring streamlined collaboration and enhanced test management throughout the project lifecycle' AS contents;
 
SELECT
    'card' AS component,
    4 AS columns;
 
 
 
SELECT
  '## Test Case Count' AS description_md,
  '# ' || COALESCE(SUM(test_case_count), 0) AS description_md,
  'green-lt' AS background_color,
  'file' AS icon,
  'test-cases.sql' AS link
FROM v_section_hierarchy_summary;
 
-- Second Card V2: Total Passed
SELECT
    '## Total Passed Cases:'  AS description_md,
    '# ' || COALESCE(COUNT(test_case_id), 0) AS description_md,
    'green-lt' AS background_color,
    'check' AS icon,
    'passed.sql' AS link
FROM v_test_case_details
WHERE test_case_status IN ('passed','pending');
 
-- Second Card: Total Defects
SELECT
    '## Total Defects:'  AS description_md,
    '# ' || COALESCE(COUNT(test_case_id), 0) AS description_md,
    'red-lt' AS background_color,
    'bug' AS icon,
    'defects.sql' AS link
FROM v_test_case_details
WHERE test_case_status IN ('reopen', 'failed');
 
 
 
-- Closed Defects
SELECT
    '## Closed Defects:'  AS description_md,
    '# ' || COALESCE(COUNT(test_case_id), 0) AS description_md,
    'blue-lt' AS background_color,
    'x' AS icon,
    'closed.sql' AS link
FROM v_test_case_details
WHERE test_case_status IN ('closed');
 
 
SELECT
    '## Reopened Defects:'  AS description_md,
    '# ' || COALESCE(COUNT(test_case_id), 0) AS description_md,
    'yellow-lt' AS background_color,
    'alert-circle' AS icon,
    'reopen.sql' AS link
FROM v_test_case_details
WHERE test_case_status IN ('reopen');
 
WITH counts AS (
  SELECT
    (SELECT COUNT(DISTINCT test_case_id) FROM v_test_case_details) AS total_tests,
    (SELECT COUNT(DISTINCT test_case_id)
       FROM v_test_case_details
      WHERE test_case_status IN ('reopen','failed')
    ) AS total_defects
)
SELECT
  '## Failed Percentage:' AS description_md,
  '# ' ||
  CASE
    WHEN total_tests = 0 THEN '0%'
    ELSE ROUND((total_defects * 100.0) / total_tests) || '%'
  END AS description_md,
  'red-lt' AS background_color,
  'alert-circle' AS icon
FROM counts;
 
WITH counts AS (
  SELECT
    (SELECT COUNT(DISTINCT test_case_id) FROM v_test_case_details) AS total_tests,
    (SELECT COUNT(DISTINCT test_case_id)
       FROM v_test_case_details
      WHERE test_case_status IN ('reopen','failed')
    ) AS total_defects
)
SELECT
  '## Success Percentage:' AS description_md,
  '# ' ||
  CASE
    WHEN total_tests = 0 THEN '0%'
    ELSE ROUND(((total_tests - total_defects) * 100.0) / total_tests) || '%'
  END AS description_md,
  'green-lt' AS background_color,
  'check' AS icon
FROM counts;
 
select
'chart'   as component,
'Success Percentage' as title,
'pie'     as type,
TRUE      as labels;
select
'Yes' as label,
 65    as value;
select
'No' as label,
 35   as value
 
 
select
    'divider'            as component,
    'TEST CYCLE DETAILS' as contents,
    5                  as size,
    'blue'               as color;
 
SELECT
  '## Test Case Count' AS description_md,
  '# ' || COALESCE(SUM(test_case_count), 0) AS description_md,
  'green-lt' AS background_color,
  'file' AS icon,
  'test-cases.sql' AS link
FROM v_section_hierarchy_summary;
 
 
```
 
```sql test-cases.sql { route: { caption: "Test Cases" } }
 
SELECT
  'table' AS component,
  'Test Cases' AS title,
  1 AS search,
  1 AS sort;
 
SELECT
  test_case_id     AS "Test Case ID",
  test_case_title  AS "Title",
  test_case_status AS "Status",
  latest_cycle     AS "Latest Cycle"
FROM v_test_case_details
ORDER BY test_case_id;
 
```
 
```sql passed.sql { route: { caption: "Test Cases" } }
 
SELECT
  'table' AS component,
  'Test Cases' AS title,
  1 AS search,
  1 AS sort;
 
SELECT
  test_case_id     AS "Test Case ID",
  test_case_title  AS "Title",
  latest_cycle     AS "Latest Cycle"
FROM v_test_case_details
WHERE test_case_status='passed'
ORDER BY test_case_id;
 
```
 
```sql defects.sql { route: { caption: "Test Cases" } }
 
SELECT
  'table' AS component,
  'Test Cases' AS title,
  1 AS search,
  1 AS sort;
 
SELECT
  test_case_id     AS "Test Case ID",
  test_case_title  AS "Title",
  test_case_status AS "Status",
  latest_cycle     AS "Latest Cycle"
FROM v_test_case_details
WHERE test_case_status IN ('reopen', 'failed')
ORDER BY test_case_id;
 
```
 
```sql closed.sql { route: { caption: "Test Cases" } }
 
SELECT
  'table' AS component,
  'Test Cases' AS title,
  1 AS search,
  1 AS sort;
 
SELECT
  test_case_id     AS "Test Case ID",
  test_case_title  AS "Title",
  test_case_status AS "Status",
  latest_cycle     AS "Latest Cycle"
FROM v_test_case_details
WHERE test_case_status IN ('closed')
ORDER BY test_case_id;
 
```
 
```sql reopen.sql { route: { caption: "Test Cases" } }
 
SELECT
  'table' AS component,
  'Test Cases' AS title,
  1 AS search,
  1 AS sort;
 
SELECT
  test_case_id     AS "Test Case ID",
  test_case_title  AS "Title",
  test_case_status AS "Status",
  latest_cycle     AS "Latest Cycle"
FROM v_test_case_details
WHERE test_case_status IN ('reopen')
ORDER BY test_case_id;
 
```