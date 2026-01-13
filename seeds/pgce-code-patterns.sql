-- PGCE Code Patterns Seed Data
-- Seeds QUAD_code_patterns with real patterns from SUMA/QUAD codebases
--
-- Purpose: Provide patterns for "Close to Zero Hallucination" code generation
-- Usage: Run after table creation to populate initial patterns
--
-- Categories:
--   - component: React/Next.js UI components
--   - api: Express API endpoints
--   - schema: PostgreSQL table definitions
--   - hook: React hooks
--   - util: Utility functions
--   - context: React context providers

-- =============================================================================
-- COMPONENT PATTERNS
-- =============================================================================

-- Pattern: Form with Validation (React Hook Form)
INSERT INTO QUAD_code_patterns (
    pattern_type,
    pattern_name,
    pattern_category,
    code_template,
    language,
    framework,
    ast_signature,
    ast_hash
) VALUES (
    'component',
    'FormWithValidation',
    'form',
    E'import { useForm } from ''react-hook-form'';
import { zodResolver } from ''@hookform/resolvers/zod'';
import { z } from ''zod'';

const schema = z.object({
  email: z.string().email(''Invalid email''),
  password: z.string().min(8, ''Password must be at least 8 characters''),
});

type FormData = z.infer<typeof schema>;

export default function FormName() {
  const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm<FormData>({
    resolver: zodResolver(schema),
  });

  const onSubmit = async (data: FormData) => {
    try {
      // API call here
      console.log(data);
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
      <div>
        <input {...register(''email'')} placeholder="Email" className="input" />
        {errors.email && <span className="error">{errors.email.message}</span>}
      </div>
      <div>
        <input {...register(''password'')} type="password" placeholder="Password" className="input" />
        {errors.password && <span className="error">{errors.password.message}</span>}
      </div>
      <button type="submit" disabled={isSubmitting}>
        {isSubmitting ? ''Loading...'' : ''Submit''}
      </button>
    </form>
  );
}',
    'typescript',
    'nextjs',
    '{
        "type": "FunctionDeclaration",
        "exports": "default",
        "hooks": ["useForm"],
        "libraries": ["react-hook-form", "zod", "@hookform/resolvers/zod"],
        "patterns": ["form", "validation", "error-handling"],
        "structure": {
            "imports": 3,
            "schema": true,
            "hooks": 1,
            "handler": "onSubmit",
            "jsx": "form"
        }
    }',
    'form_validation_rhf_zod_v1'
);

-- Pattern: Login Form Component
INSERT INTO QUAD_code_patterns (
    pattern_type,
    pattern_name,
    pattern_category,
    code_template,
    language,
    framework,
    ast_signature,
    ast_hash
) VALUES (
    'component',
    'LoginForm',
    'auth',
    E'\"use client\";

import { useState } from ''react'';
import { useRouter } from ''next/navigation'';
import { useAuth } from ''@/hooks/useAuth'';

export default function LoginForm() {
  const [email, setEmail] = useState('''');
  const [password, setPassword] = useState('''');
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const router = useRouter();
  const { login } = useAuth();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);

    try {
      await login(email, password);
      router.push(''/dashboard'');
    } catch (err) {
      setError(err instanceof Error ? err.message : ''Login failed'');
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4 max-w-md mx-auto">
      {error && <div className="text-red-500 text-sm">{error}</div>}

      <input
        type="email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        placeholder="Email"
        required
        className="w-full p-2 border rounded"
      />

      <input
        type="password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        placeholder="Password"
        required
        className="w-full p-2 border rounded"
      />

      <button
        type="submit"
        disabled={loading}
        className="w-full p-2 bg-blue-500 text-white rounded disabled:opacity-50"
      >
        {loading ? ''Signing in...'' : ''Sign In''}
      </button>
    </form>
  );
}',
    'typescript',
    'nextjs',
    '{
        "type": "FunctionDeclaration",
        "exports": "default",
        "directive": "use client",
        "hooks": ["useState", "useRouter", "useAuth"],
        "libraries": ["next/navigation"],
        "patterns": ["auth", "login", "form", "error-handling", "loading-state"],
        "structure": {
            "state": ["email", "password", "error", "loading"],
            "handler": "handleSubmit",
            "navigation": "router.push"
        }
    }',
    'login_form_nextjs_v1'
);

-- =============================================================================
-- API ENDPOINT PATTERNS
-- =============================================================================

-- Pattern: POST Authentication Endpoint
INSERT INTO QUAD_code_patterns (
    pattern_type,
    pattern_name,
    pattern_category,
    code_template,
    language,
    framework,
    ast_signature,
    ast_hash
) VALUES (
    'api',
    'AuthLoginEndpoint',
    'auth',
    E'import { Request, Response } from ''express'';
import bcrypt from ''bcryptjs'';
import jwt from ''jsonwebtoken'';
import { z } from ''zod'';
import { db } from ''../db'';

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(1),
});

export async function login(req: Request, res: Response) {
  try {
    // Validate input
    const { email, password } = loginSchema.parse(req.body);

    // Find user
    const user = await db.query(
      ''SELECT id, email, password_hash, name FROM users WHERE email = $1'',
      [email]
    );

    if (user.rows.length === 0) {
      return res.status(401).json({ error: ''Invalid credentials'' });
    }

    // Verify password
    const validPassword = await bcrypt.compare(password, user.rows[0].password_hash);
    if (!validPassword) {
      return res.status(401).json({ error: ''Invalid credentials'' });
    }

    // Generate JWT
    const token = jwt.sign(
      { userId: user.rows[0].id, email: user.rows[0].email },
      process.env.JWT_SECRET!,
      { expiresIn: ''7d'' }
    );

    res.json({
      success: true,
      data: {
        token,
        user: {
          id: user.rows[0].id,
          email: user.rows[0].email,
          name: user.rows[0].name,
        },
      },
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ error: ''Invalid input'', details: error.errors });
    }
    console.error(''Login error:'', error);
    res.status(500).json({ error: ''Internal server error'' });
  }
}',
    'typescript',
    'express',
    '{
        "type": "FunctionDeclaration",
        "exports": "named",
        "async": true,
        "params": ["req", "res"],
        "libraries": ["express", "bcryptjs", "jsonwebtoken", "zod"],
        "patterns": ["auth", "login", "validation", "jwt", "error-handling"],
        "structure": {
            "validation": "zod",
            "database": "query",
            "password": "bcrypt.compare",
            "token": "jwt.sign",
            "response": "json"
        }
    }',
    'auth_login_express_v1'
);

-- Pattern: CRUD API Endpoint
INSERT INTO QUAD_code_patterns (
    pattern_type,
    pattern_name,
    pattern_category,
    code_template,
    language,
    framework,
    ast_signature,
    ast_hash
) VALUES (
    'api',
    'CrudEndpoints',
    'crud',
    E'import { Request, Response, Router } from ''express'';
import { z } from ''zod'';
import { db } from ''../db'';
import { authMiddleware } from ''../middleware/auth'';

const router = Router();

// Schema
const createSchema = z.object({
  name: z.string().min(1),
  description: z.string().optional(),
});

// GET all
router.get(''/'', authMiddleware, async (req: Request, res: Response) => {
  try {
    const result = await db.query(''SELECT * FROM items WHERE user_id = $1 ORDER BY created_at DESC'', [req.user.id]);
    res.json({ success: true, data: result.rows });
  } catch (error) {
    res.status(500).json({ error: ''Failed to fetch items'' });
  }
});

// GET by ID
router.get(''/:id'', authMiddleware, async (req: Request, res: Response) => {
  try {
    const result = await db.query(''SELECT * FROM items WHERE id = $1 AND user_id = $2'', [req.params.id, req.user.id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: ''Item not found'' });
    }
    res.json({ success: true, data: result.rows[0] });
  } catch (error) {
    res.status(500).json({ error: ''Failed to fetch item'' });
  }
});

// POST create
router.post(''/'', authMiddleware, async (req: Request, res: Response) => {
  try {
    const data = createSchema.parse(req.body);
    const result = await db.query(
      ''INSERT INTO items (name, description, user_id) VALUES ($1, $2, $3) RETURNING *'',
      [data.name, data.description, req.user.id]
    );
    res.status(201).json({ success: true, data: result.rows[0] });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ error: ''Invalid input'' });
    }
    res.status(500).json({ error: ''Failed to create item'' });
  }
});

// PUT update
router.put(''/:id'', authMiddleware, async (req: Request, res: Response) => {
  try {
    const data = createSchema.parse(req.body);
    const result = await db.query(
      ''UPDATE items SET name = $1, description = $2, updated_at = NOW() WHERE id = $3 AND user_id = $4 RETURNING *'',
      [data.name, data.description, req.params.id, req.user.id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: ''Item not found'' });
    }
    res.json({ success: true, data: result.rows[0] });
  } catch (error) {
    res.status(500).json({ error: ''Failed to update item'' });
  }
});

// DELETE
router.delete(''/:id'', authMiddleware, async (req: Request, res: Response) => {
  try {
    const result = await db.query(''DELETE FROM items WHERE id = $1 AND user_id = $2 RETURNING id'', [req.params.id, req.user.id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: ''Item not found'' });
    }
    res.json({ success: true, message: ''Item deleted'' });
  } catch (error) {
    res.status(500).json({ error: ''Failed to delete item'' });
  }
});

export default router;',
    'typescript',
    'express',
    '{
        "type": "RouterDeclaration",
        "exports": "default",
        "methods": ["GET", "GET/:id", "POST", "PUT/:id", "DELETE/:id"],
        "libraries": ["express", "zod"],
        "patterns": ["crud", "rest", "auth-middleware", "validation"],
        "structure": {
            "middleware": "authMiddleware",
            "validation": "zod",
            "database": "query",
            "response": "json"
        }
    }',
    'crud_endpoints_express_v1'
);

-- =============================================================================
-- DATABASE SCHEMA PATTERNS
-- =============================================================================

-- Pattern: Users Table
INSERT INTO QUAD_code_patterns (
    pattern_type,
    pattern_name,
    pattern_category,
    code_template,
    language,
    framework,
    ast_signature,
    ast_hash
) VALUES (
    'schema',
    'UsersTable',
    'auth',
    E'-- Users Table
-- Stores user authentication and profile data
--
-- Part of: Authentication System
-- Created: January 2026

CREATE TABLE IF NOT EXISTS users (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Authentication
    email           VARCHAR(255) UNIQUE NOT NULL,
    password_hash   VARCHAR(255) NOT NULL,
    email_verified  BOOLEAN DEFAULT FALSE,

    -- Profile
    name            VARCHAR(100),
    avatar_url      TEXT,

    -- Status
    status          VARCHAR(20) DEFAULT ''active'',  -- active, suspended, deleted
    role            VARCHAR(20) DEFAULT ''user'',    -- user, admin, superadmin

    -- Timestamps
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_login_at   TIMESTAMP WITH TIME ZONE,
    deleted_at      TIMESTAMP WITH TIME ZONE
);

-- Indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_status ON users(status);

-- Trigger for updated_at
CREATE OR REPLACE FUNCTION update_users_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_users_timestamp();

COMMENT ON TABLE users IS ''User accounts for authentication and profile'';',
    'sql',
    'postgresql',
    '{
        "type": "CreateTable",
        "name": "users",
        "columns": ["id", "email", "password_hash", "email_verified", "name", "avatar_url", "status", "role", "created_at", "updated_at", "last_login_at", "deleted_at"],
        "primaryKey": "id",
        "unique": ["email"],
        "indexes": ["email", "status"],
        "triggers": ["updated_at"]
    }',
    'users_table_postgresql_v1'
);

-- =============================================================================
-- REACT HOOK PATTERNS
-- =============================================================================

-- Pattern: useAuth Hook
INSERT INTO QUAD_code_patterns (
    pattern_type,
    pattern_name,
    pattern_category,
    code_template,
    language,
    framework,
    ast_signature,
    ast_hash
) VALUES (
    'hook',
    'useAuth',
    'auth',
    E'import { useState, useEffect, useCallback, createContext, useContext } from ''react'';

interface User {
  id: string;
  email: string;
  name: string;
}

interface AuthContextType {
  user: User | null;
  loading: boolean;
  login: (email: string, password: string) => Promise<void>;
  logout: () => Promise<void>;
  isAuthenticated: boolean;
}

const AuthContext = createContext<AuthContextType | null>(null);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Check for existing session
    const token = localStorage.getItem(''token'');
    if (token) {
      fetchUser(token);
    } else {
      setLoading(false);
    }
  }, []);

  const fetchUser = async (token: string) => {
    try {
      const res = await fetch(''/api/auth/me'', {
        headers: { Authorization: `Bearer ${token}` },
      });
      if (res.ok) {
        const data = await res.json();
        setUser(data.user);
      } else {
        localStorage.removeItem(''token'');
      }
    } catch (error) {
      console.error(''Failed to fetch user'');
    } finally {
      setLoading(false);
    }
  };

  const login = useCallback(async (email: string, password: string) => {
    const res = await fetch(''/api/auth/login'', {
      method: ''POST'',
      headers: { ''Content-Type'': ''application/json'' },
      body: JSON.stringify({ email, password }),
    });

    if (!res.ok) {
      const error = await res.json();
      throw new Error(error.error || ''Login failed'');
    }

    const data = await res.json();
    localStorage.setItem(''token'', data.data.token);
    setUser(data.data.user);
  }, []);

  const logout = useCallback(async () => {
    localStorage.removeItem(''token'');
    setUser(null);
  }, []);

  return (
    <AuthContext.Provider value={{ user, loading, login, logout, isAuthenticated: !!user }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error(''useAuth must be used within an AuthProvider'');
  }
  return context;
}',
    'typescript',
    'react',
    '{
        "type": "HookDeclaration",
        "exports": ["AuthProvider", "useAuth"],
        "hooks": ["useState", "useEffect", "useCallback", "createContext", "useContext"],
        "patterns": ["auth", "context-provider", "token-storage"],
        "structure": {
            "context": "AuthContext",
            "provider": "AuthProvider",
            "hook": "useAuth",
            "state": ["user", "loading"],
            "methods": ["login", "logout", "fetchUser"]
        }
    }',
    'use_auth_hook_react_v1'
);

-- =============================================================================
-- UTILITY PATTERNS
-- =============================================================================

-- Pattern: API Client
INSERT INTO QUAD_code_patterns (
    pattern_type,
    pattern_name,
    pattern_category,
    code_template,
    language,
    framework,
    ast_signature,
    ast_hash
) VALUES (
    'util',
    'ApiClient',
    'http',
    E'const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || ''http://localhost:3201'';

interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
}

class ApiClient {
  private baseUrl: string;

  constructor(baseUrl: string = API_BASE_URL) {
    this.baseUrl = baseUrl;
  }

  private getHeaders(): HeadersInit {
    const headers: HeadersInit = {
      ''Content-Type'': ''application/json'',
    };

    const token = typeof window !== ''undefined'' ? localStorage.getItem(''token'') : null;
    if (token) {
      headers[''Authorization''] = `Bearer ${token}`;
    }

    return headers;
  }

  async get<T>(endpoint: string): Promise<ApiResponse<T>> {
    const res = await fetch(`${this.baseUrl}${endpoint}`, {
      method: ''GET'',
      headers: this.getHeaders(),
    });
    return res.json();
  }

  async post<T>(endpoint: string, data: unknown): Promise<ApiResponse<T>> {
    const res = await fetch(`${this.baseUrl}${endpoint}`, {
      method: ''POST'',
      headers: this.getHeaders(),
      body: JSON.stringify(data),
    });
    return res.json();
  }

  async put<T>(endpoint: string, data: unknown): Promise<ApiResponse<T>> {
    const res = await fetch(`${this.baseUrl}${endpoint}`, {
      method: ''PUT'',
      headers: this.getHeaders(),
      body: JSON.stringify(data),
    });
    return res.json();
  }

  async delete<T>(endpoint: string): Promise<ApiResponse<T>> {
    const res = await fetch(`${this.baseUrl}${endpoint}`, {
      method: ''DELETE'',
      headers: this.getHeaders(),
    });
    return res.json();
  }
}

export const api = new ApiClient();
export default ApiClient;',
    'typescript',
    'nextjs',
    '{
        "type": "ClassDeclaration",
        "exports": ["api", "ApiClient"],
        "methods": ["get", "post", "put", "delete", "getHeaders"],
        "patterns": ["http-client", "token-auth", "singleton"],
        "structure": {
            "class": "ApiClient",
            "singleton": "api",
            "methods": 5,
            "async": true
        }
    }',
    'api_client_fetch_v1'
);

-- Log seed completion
DO $$
BEGIN
    RAISE NOTICE 'PGCE Code Patterns seed completed: 7 patterns inserted';
    RAISE NOTICE 'Categories: component(2), api(2), schema(1), hook(1), util(1)';
END $$;
