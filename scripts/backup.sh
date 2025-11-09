#!/bin/bash

# PostgreSQL Backup Script
set -e

# Variables
BACKUP_DIR="/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
DB_NAME="${POSTGRES_DB:-main_database}"
DB_USER="${POSTGRES_USER:-admin}"
RETENTION_DAYS="${BACKUP_RETENTION_DAYS:-7}"

# Crear directorio de backup si no existe
mkdir -p ${BACKUP_DIR}

# Realizar backup
echo "🔄 Iniciando backup de la base de datos ${DB_NAME}..."
PGPASSWORD="${POSTGRES_PASSWORD}" pg_dump -h postgres -U ${DB_USER} -d ${DB_NAME} \
    -F c -b -v -f ${BACKUP_DIR}/backup_${DB_NAME}_${TIMESTAMP}.dump

# Comprimir backup
echo "📦 Comprimiendo backup..."
gzip ${BACKUP_DIR}/backup_${DB_NAME}_${TIMESTAMP}.dump

# Eliminar backups antiguos
echo "🗑️  Eliminando backups antiguos (más de ${RETENTION_DAYS} días)..."
find ${BACKUP_DIR} -name "backup_*.dump.gz" -mtime +${RETENTION_DAYS} -delete

echo "✅ Backup completado: backup_${DB_NAME}_${TIMESTAMP}.dump.gz"