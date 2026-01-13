-- Seed Data: QUAD Industry Defaults
-- Pre-configured coding rules for 3 industries
--
-- Industries:
-- 1. Investment Banking (FINRA compliance, SEC reporting)
-- 2. Healthcare (HIPAA compliance, PHI protection)
-- 3. E-commerce (PCI-DSS compliance, payment security)
--
-- Part of: QUAD AI Agent Rules System
-- Created: January 2026

-- Clear existing data (dev/qa only, not production)
TRUNCATE TABLE quad_industry_defaults CASCADE;

-- ==============================================================================
-- INVESTMENT BANKING (FINRA, SEC, Financial Regulations)
-- ==============================================================================

-- Activity: Add API Endpoint
INSERT INTO quad_industry_defaults (industry, activity_type, rule_type, rule_text, priority) VALUES
-- DO Rules
('investment_banking', 'add_api_endpoint', 'DO', 'Use Java Spring Boot for all backend APIs', 100),
('investment_banking', 'add_api_endpoint', 'DO', 'Add FINRA compliance logging for all financial transactions', 100),
('investment_banking', 'add_api_endpoint', 'DO', 'Follow Clean Architecture pattern (Controller → Service → Repository)', 100),
('investment_banking', 'add_api_endpoint', 'DO', 'Validate all financial data with BigDecimal (never use float or double)', 100),
('investment_banking', 'add_api_endpoint', 'DO', 'Add transaction audit logging with timestamps and user IDs', 100),
('investment_banking', 'add_api_endpoint', 'DO', 'Implement rate limiting to prevent trading abuse', 100),

-- DONT Rules
('investment_banking', 'add_api_endpoint', 'DONT', 'Store PII (Personally Identifiable Information) in application logs', 200),
('investment_banking', 'add_api_endpoint', 'DONT', 'Use reflection for financial calculations (security risk)', 200),
('investment_banking', 'add_api_endpoint', 'DONT', 'Skip input validation on financial amounts', 200),
('investment_banking', 'add_api_endpoint', 'DONT', 'Use hardcoded credentials or API keys', 200);

-- Activity: Create UI Screen
INSERT INTO quad_industry_defaults (industry, activity_type, rule_type, rule_text, priority) VALUES
-- DO Rules
('investment_banking', 'create_ui_screen', 'DO', 'Add session timeout warnings (FINRA requires 15-minute idle logout)', 100),
('investment_banking', 'create_ui_screen', 'DO', 'Display financial amounts with proper decimal precision (2 decimals for USD)', 100),
('investment_banking', 'create_ui_screen', 'DO', 'Add confirmation dialogs for all financial transactions', 100),

-- DONT Rules
('investment_banking', 'create_ui_screen', 'DONT', 'Display sensitive account numbers in full (mask middle digits)', 200),
('investment_banking', 'create_ui_screen', 'DONT', 'Cache financial data in browser local storage', 200);

-- Activity: Add Database Table
INSERT INTO quad_industry_defaults (industry, activity_type, rule_type, rule_text, priority) VALUES
-- DO Rules
('investment_banking', 'add_database_table', 'DO', 'Use DECIMAL type for financial amounts (never FLOAT)', 100),
('investment_banking', 'add_database_table', 'DO', 'Add created_at, updated_at, created_by, updated_by columns for audit trail', 100),
('investment_banking', 'add_database_table', 'DO', 'Encrypt PII columns at rest (SSN, account numbers)', 100),

-- DONT Rules
('investment_banking', 'add_database_table', 'DONT', 'Use CASCADE DELETE on financial transaction tables', 200);

-- ==============================================================================
-- HEALTHCARE (HIPAA, PHI Protection, Patient Privacy)
-- ==============================================================================

-- Activity: Add API Endpoint
INSERT INTO quad_industry_defaults (industry, activity_type, rule_type, rule_text, priority) VALUES
-- DO Rules
('healthcare', 'add_api_endpoint', 'DO', 'Add HIPAA compliance logging for all PHI (Protected Health Information) access', 100),
('healthcare', 'add_api_endpoint', 'DO', 'Encrypt PHI data at rest and in transit (TLS 1.2+)', 100),
('healthcare', 'add_api_endpoint', 'DO', 'Implement role-based access control (RBAC) for patient data', 100),
('healthcare', 'add_api_endpoint', 'DO', 'Add audit logging for all PHI access (who, when, what)', 100),
('healthcare', 'add_api_endpoint', 'DO', 'Validate patient consent before accessing medical records', 100),

-- DONT Rules
('healthcare', 'add_api_endpoint', 'DONT', 'Log patient names, SSNs, or medical record numbers', 200),
('healthcare', 'add_api_endpoint', 'DONT', 'Store passwords in plaintext or with weak encryption', 200),
('healthcare', 'add_api_endpoint', 'DONT', 'Return detailed error messages that expose PHI', 200),
('healthcare', 'add_api_endpoint', 'DONT', 'Allow unauthenticated access to any patient data', 200);

-- Activity: Create UI Screen
INSERT INTO quad_industry_defaults (industry, activity_type, rule_type, rule_text, priority) VALUES
-- DO Rules
('healthcare', 'create_ui_screen', 'DO', 'Add session timeout after 15 minutes of inactivity (HIPAA requirement)', 100),
('healthcare', 'create_ui_screen', 'DO', 'Mask patient SSN and medical record numbers by default', 100),
('healthcare', 'create_ui_screen', 'DO', 'Add audit logging for all PHI views (patient charts, lab results)', 100),

-- DONT Rules
('healthcare', 'create_ui_screen', 'DONT', 'Display full patient SSN on any screen', 200),
('healthcare', 'create_ui_screen', 'DONT', 'Cache PHI in browser local storage or session storage', 200);

-- Activity: Add Database Table
INSERT INTO quad_industry_defaults (industry, activity_type, rule_type, rule_text, priority) VALUES
-- DO Rules
('healthcare', 'add_database_table', 'DO', 'Encrypt all PHI columns (SSN, medical records, diagnoses)', 100),
('healthcare', 'add_database_table', 'DO', 'Add audit columns: accessed_by, accessed_at, access_reason', 100),
('healthcare', 'add_database_table', 'DO', 'Implement row-level security for multi-tenant patient data', 100),

-- DONT Rules
('healthcare', 'add_database_table', 'DONT', 'Store PHI in unencrypted columns', 200);

-- ==============================================================================
-- E-COMMERCE (PCI-DSS, Payment Security, Customer Data Protection)
-- ==============================================================================

-- Activity: Add API Endpoint
INSERT INTO quad_industry_defaults (industry, activity_type, rule_type, rule_text, priority) VALUES
-- DO Rules
('ecommerce', 'add_api_endpoint', 'DO', 'Follow PCI-DSS standards for all payment processing', 100),
('ecommerce', 'add_api_endpoint', 'DO', 'Validate credit card numbers with Luhn algorithm before processing', 100),
('ecommerce', 'add_api_endpoint', 'DO', 'Use tokenization for storing payment methods (never store raw card data)', 100),
('ecommerce', 'add_api_endpoint', 'DO', 'Implement idempotency for payment operations (prevent duplicate charges)', 100),
('ecommerce', 'add_api_endpoint', 'DO', 'Add webhook signature verification for payment gateway callbacks', 100),

-- DONT Rules
('ecommerce', 'add_api_endpoint', 'DONT', 'Store credit card CVV/CVC codes (PCI-DSS violation)', 200),
('ecommerce', 'add_api_endpoint', 'DONT', 'Log full credit card numbers in application logs', 200),
('ecommerce', 'add_api_endpoint', 'DONT', 'Process payments without SSL/TLS encryption', 200),
('ecommerce', 'add_api_endpoint', 'DONT', 'Allow SQL injection vulnerabilities (use parameterized queries)', 200);

-- Activity: Create UI Screen
INSERT INTO quad_industry_defaults (industry, activity_type, rule_type, rule_text, priority) VALUES
-- DO Rules
('ecommerce', 'create_ui_screen', 'DO', 'Use payment gateway iframes for credit card input (reduce PCI scope)', 100),
('ecommerce', 'create_ui_screen', 'DO', 'Display order confirmation with transaction ID', 100),
('ecommerce', 'create_ui_screen', 'DO', 'Add clear refund and cancellation policies', 100),

-- DONT Rules
('ecommerce', 'create_ui_screen', 'DONT', 'Display full credit card numbers (show last 4 digits only)', 200),
('ecommerce', 'create_ui_screen', 'DONT', 'Auto-save credit card data without explicit user consent', 200);

-- Activity: Add Payment Processing
INSERT INTO quad_industry_defaults (industry, activity_type, rule_type, rule_text, priority) VALUES
-- DO Rules
('ecommerce', 'add_payment_processing', 'DO', 'Use established payment gateways (Stripe, PayPal, Square)', 100),
('ecommerce', 'add_payment_processing', 'DO', 'Implement retry logic with exponential backoff for failed payments', 100),
('ecommerce', 'add_payment_processing', 'DO', 'Send payment confirmation emails with transaction details', 100),

-- DONT Rules
('ecommerce', 'add_payment_processing', 'DONT', 'Build custom credit card processing (use certified gateways)', 200),
('ecommerce', 'add_payment_processing', 'DONT', 'Store payment gateway API keys in code (use environment variables)', 200);

-- ==============================================================================
-- VERIFICATION
-- ==============================================================================

-- Show summary by industry and activity
SELECT
    industry,
    activity_type,
    rule_type,
    COUNT(*) as rule_count
FROM quad_industry_defaults
GROUP BY industry, activity_type, rule_type
ORDER BY industry, activity_type, rule_type;

-- Show total rules per industry
SELECT
    industry,
    COUNT(*) as total_rules,
    COUNT(CASE WHEN rule_type = 'DO' THEN 1 END) as do_rules,
    COUNT(CASE WHEN rule_type = 'DONT' THEN 1 END) as dont_rules
FROM quad_industry_defaults
GROUP BY industry
ORDER BY industry;
