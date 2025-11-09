#!/bin/bash

# Health Check Script
set -e

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${POSTGRES_DB:-main_database}"
DB_USER="${POSTGRES_USER:-admin}"

echo "🔍 Verificando salud de PostgreSQL..."

# Verificar conexión
if PGPASSWORD="${POSTGRES_PASSWORD}" psql -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} -d ${DB_NAME} -c "SELECT 1;" > /dev/null 2>&1; then
    echo "✅ PostgreSQL está funcionando correctamente"
else
    echo "❌ No se puede conectar a PostgreSQL"
    exit 1
fi

# Verificar número de conexiones
CONNECTIONS=$(PGPASSWORD="${POSTGRES_PASSWORD}" psql -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} -d ${DB_NAME} -t -c "SELECT count(*) FROM pg_stat_activity;")
echo "📊 Conexiones activas: ${CONNECTIONS}"

# Verificar tamaño de la base de datos
DB_SIZE=$(PGPASSWORD="${POSTGRES_PASSWORD}" psql -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} -d ${DB_NAME} -t -c "SELECT pg_size_pretty(pg_database_size('${DB_NAME}'));")
echo "💾 Tamaño de la base de datos: ${DB_SIZE}"

echo "✅ Health check completado"