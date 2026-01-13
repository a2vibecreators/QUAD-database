# QUAD AI Database Tables

Database schema for QUAD AI capabilities including PGCE (Priority-Guided Code Evolution) and RAG (Retrieval-Augmented Generation).

## Tables Overview

| Table | Purpose | Patent |
|-------|---------|--------|
| `QUAD_code_patterns` | Code pattern storage for Close to Zero Hallucination | 63/956,810 |
| `QUAD_pgce_priorities` | PGCE priority calculations | 63/957,663 |
| `QUAD_rag_indexes` | RAG vector search indexes | - |
| `QUAD_ai_contexts` | AI conversation context | - |
| `QUAD_ai_conversations` | AI conversation history | - |

---

## PGCE (Priority-Guided Code Evolution)

**Patent:** 63/957,663 - Priority-Guided Code Evolution Algorithm

### Formula

```
P = (D × 0.5) + (I × 0.3) + (C' × 0.2)

Where:
  P  = Priority Score (0.00 - 1.00)
  D  = Dependency Score (how many features depend on this)
  I  = Impact Score (business value / user benefit)
  C' = Inverted Complexity (1 - complexity, simpler = higher)
```

### Tables

#### QUAD_pgce_priorities

Stores priority calculations for features/requirements.

```sql
-- Key columns:
feature_name         -- "Add user authentication"
dependency_score     -- 0.90 (many features need this)
impact_score         -- 0.80 (critical for users)
complexity_score     -- 0.30 (moderate complexity)
priority_score       -- 0.73 (auto-calculated)
build_order          -- 1 (first in sequence)
pattern_match_score  -- 0.98 (Close to Zero Hallucination score)
```

#### QUAD_code_patterns

Stores reusable code patterns for pattern-matching code generation.

```sql
-- Key columns:
pattern_type       -- component, api, schema, hook, util
pattern_name       -- LoginForm, AuthEndpoint, UsersTable
pattern_category   -- auth, form, crud, http
code_template      -- Actual code template
ast_signature      -- AST structure for matching
usage_count        -- How often pattern is used
```

### How It Works

```
1. User: /squad-story "Add authentication"
                    ↓
2. QUAD API: POST /api/pgce/analyze
   - Query QUAD_code_patterns for matching patterns
   - Calculate PGCE priority scores
   - Return: { patterns, priority, dependencies }
                    ↓
3. Code Agent: Generate code using patterns
   - Match AST signatures
   - Maintain pattern structure
   - Customize business logic only
                    ↓
4. QUAD API: POST /api/pgce/validate
   - Compare generated code AST vs pattern AST
   - Calculate match_score
   - Return: { match_score: 0.98 }
                    ↓
5. Result: "Close to Zero Hallucination" (98% match)
```

---

## Close to Zero Hallucination

**Patent:** 63/956,810 - Compliance-Aware AI Code Generation

### Concept

Traditional AI code generation may:
- Invent non-existent APIs
- Use wrong patterns
- Create inconsistent code

QUAD's approach:
- Store REAL patterns from codebase in `QUAD_code_patterns`
- Force AI to use ONLY existing patterns
- Validate output matches patterns (AST comparison)
- Achieve 98%+ pattern match rate

### Pattern Matching

```sql
-- Pattern stored in database
{
  "pattern_type": "component",
  "pattern_name": "FormWithValidation",
  "ast_signature": {
    "hooks": ["useForm"],
    "libraries": ["react-hook-form", "zod"],
    "structure": { "validation": true, "onSubmit": true }
  }
}

-- Generated code must match:
✓ Same hooks (useForm)
✓ Same libraries (react-hook-form, zod)
✓ Same structure (validation, onSubmit)
```

### Validation Process

```javascript
// POST /api/pgce/validate
{
  generated_code: "export default function LoginForm() { ... }",
  pattern_id: "uuid-of-FormWithValidation"
}

// Response
{
  match_score: 0.98,
  matches: {
    hooks: true,      // +25%
    libraries: true,  // +25%
    structure: true,  // +30%
    naming: true      // +18%
  },
  differences: [
    { type: "minor", detail: "Different function name" }
  ]
}
```

---

## Seed Data

Location: `../seeds/pgce-code-patterns.sql`

Pre-populated patterns:
- **component/FormWithValidation** - React Hook Form + Zod
- **component/LoginForm** - Next.js login component
- **api/AuthLoginEndpoint** - Express JWT auth
- **api/CrudEndpoints** - Express CRUD router
- **schema/UsersTable** - PostgreSQL users table
- **hook/useAuth** - React auth context + hook
- **util/ApiClient** - Fetch API wrapper

---

## Related Files

| File | Purpose |
|------|---------|
| `QUAD_code_patterns.tbl.sql` | Pattern storage table |
| `QUAD_pgce_priorities.tbl.sql` | PGCE calculations table |
| `QUAD_rag_indexes.tbl.sql` | RAG vector indexes |
| `../seeds/pgce-code-patterns.sql` | Seed patterns |

---

## Usage

### Run Seeds

```bash
# Connect to database
psql -h localhost -p 14201 -U postgres -d quad_dev_db

# Run seed file
\i seeds/pgce-code-patterns.sql
```

### Query Patterns

```sql
-- Get all auth patterns
SELECT pattern_name, pattern_type, usage_count
FROM QUAD_code_patterns
WHERE pattern_category = 'auth'
ORDER BY usage_count DESC;

-- Get pattern for code generation
SELECT code_template, ast_signature
FROM QUAD_code_patterns
WHERE pattern_name = 'LoginForm';
```

### Calculate Priority

```sql
-- Insert new feature
INSERT INTO QUAD_pgce_priorities (feature_name, dependency_score, impact_score, complexity_score)
VALUES ('Add user authentication', 0.90, 0.80, 0.30);

-- Priority auto-calculated: 0.73
SELECT feature_name, priority_score, build_order
FROM QUAD_pgce_priorities
ORDER BY priority_score DESC;
```

---

## API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/pgce/analyze` | POST | Analyze requirement, return patterns + priority |
| `/api/pgce/validate` | POST | Validate generated code against patterns |
| `/api/pgce/patterns` | GET | List available patterns |
| `/api/pgce/patterns/:id` | GET | Get specific pattern |

---

**Copyright © 2026 Gopi Suman Addanke. All Rights Reserved.**
