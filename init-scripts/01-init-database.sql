-- Crear extensiones útiles
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Crear schemas
CREATE SCHEMA IF NOT EXISTS app;
CREATE SCHEMA IF NOT EXISTS audit;
CREATE SCHEMA IF NOT EXISTS analytics;

-- Crear roles
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'app_user') THEN
        CREATE ROLE app_user WITH LOGIN PASSWORD 'app_password';
    END IF;
    
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'readonly_user') THEN
        CREATE ROLE readonly_user WITH LOGIN PASSWORD 'readonly_password';
    END IF;
END
$$;

-- Otorgar permisos
GRANT USAGE ON SCHEMA app TO app_user;
GRANT USAGE ON SCHEMA app TO readonly_user;
GRANT SELECT ON ALL TABLES IN SCHEMA app TO readonly_user;
GRANT ALL PRIVILEGES ON SCHEMA app TO app_user;

-- Configurar búsqueda de schemas
ALTER DATABASE main_database SET search_path TO app, public;