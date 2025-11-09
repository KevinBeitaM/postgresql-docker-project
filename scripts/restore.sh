#!/bin/bash

# PostgreSQL Restore Script
set -e

# Verificar argumentos
if [ -z "$1" ]; then
    echo "❌ Error: Debes especificar el archivo de backup"
    echo "Uso: ./restore.sh <archivo_backup>"
    exit 1
fi

BACKUP_FILE=$1
DB_NAME="${POSTGRES_DB:-main_database}"
DB_USER="${POSTGRES_USER:-admin}"

# Verificar que el archivo existe
if [ ! -f "${BACKUP_FILE}" ]; then
    echo "❌ Error: El archivo ${BACKUP_FILE} no existe"
    exit 1
fi

# Descomprimir si es necesario
if [[ $BACKUP_FILE == *.gz ]]; then
    echo "📦 Descomprimiendo backup..."
    gunzip -k ${BACKUP_FILE}
    BACKUP_FILE="${BACKUP_FILE%.gz}"
fi

# Restaurar
echo "🔄 Restaurando base de datos desde ${BACKUP_FILE}..."
PGPASSWORD="${POSTGRES_PASSWORD}" pg_restore -h postgres -U ${DB_USER} -d ${DB_NAME} \
    -c -v ${BACKUP_FILE}

echo "✅ Restauración completada"