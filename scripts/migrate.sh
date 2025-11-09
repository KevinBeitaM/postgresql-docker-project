#!/bin/bash

# PostgreSQL Migration Script
set -e

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${POSTGRES_DB:-main_database}"
DB_USER="${POSTGRES_USER:-admin}"

echo "🔄 Ejecutando migraciones en ${DB_NAME}..."

# Verificar conexión
if ! PGPASSWORD="${POSTGRES_PASSWORD}" psql -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} -d ${DB_NAME} -c "SELECT 1;" > /dev/null 2>&1; then
    echo "❌ No se puede conectar a PostgreSQL"
    exit 1
fi

# Ejecutar scripts de migración en orden
MIGRATION_DIR="/docker-entrypoint-initdb.d"

if [ -d "$MIGRATION_DIR" ]; then
    echo "📂 Buscando archivos de migración en ${MIGRATION_DIR}..."
    
    for file in ${MIGRATION_DIR}/*.sql; do
        if [ -f "$file" ]; then
            echo "🔄 Ejecutando: $(basename $file)"
            PGPASSWORD="${POSTGRES_PASSWORD}" psql -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} -d ${DB_NAME} -f "$file"
            echo "✅ $(basename $file) completado"
        fi
    done
else
    echo "⚠️  Directorio de migraciones no encontrado"
fi

echo "✅ Migraciones completadas exitosamente"

# Verificar versión del esquema
echo ""
echo "📊 Estado de la base de datos:"
PGPASSWORD="${POSTGRES_PASSWORD}" psql -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} -d ${DB_NAME} -c "\dt app.*"