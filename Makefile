.PHONY: help build up down restart logs clean backup restore health

help: ## Mostrar esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Construir las imágenes de Docker
	docker compose build

up: ## Iniciar todos los servicios
	docker compose up -d
	@echo "✅ Servicios iniciados"
	@echo "📊 PgAdmin: http://localhost:5050"
	@echo "📈 Grafana: http://localhost:3000"
	@echo "🔍 Prometheus: http://localhost:9090"

down: ## Detener todos los servicios
	docker compose down

restart: ## Reiniciar todos los servicios
	docker compose restart

logs: ## Ver logs de todos los servicios
	docker compose logs -f

logs-postgres: ## Ver logs solo de PostgreSQL
	docker compose logs -f postgres

ps: ## Ver estado de los contenedores
	docker compose ps

clean: ## Limpiar contenedores y volúmenes
	docker compose down -v
	@echo "⚠️  Todos los datos han sido eliminados"

backup: ## Crear backup de la base de datos
	docker compose exec postgres /bin/bash -c "chmod +x /scripts/backup.sh && /scripts/backup.sh"

restore: ## Restaurar backup (uso: make restore FILE=backup.dump.gz)
	@if [ -z "$(FILE)" ]; then \
		echo "❌ Debes especificar FILE=<archivo>"; \
		exit 1; \
	fi
	docker compose exec postgres /bin/bash -c "/scripts/restore.sh /backups/$(FILE)"

health: ## Verificar salud de la base de datos
	docker compose exec postgres /bin/bash -c "chmod +x /scripts/health-check.sh && /scripts/health-check.sh"

shell-postgres: ## Abrir shell en PostgreSQL
	docker compose exec postgres psql -U admin -d main_database

shell-bash: ## Abrir bash en el contenedor de PostgreSQL
	docker compose exec postgres /bin/bash

migrate: ## Ejecutar migraciones
	@echo "🔄 Ejecutando migraciones..."
	docker compose exec postgres psql -U admin -d main_database -f /docker-entrypoint-initdb.d/02-create-tables.sql

prod-up: ## Iniciar en modo producción
	docker compose -f docker-compose.prod.yml up -d

prod-down: ## Detener modo producción
	docker compose -f docker-compose.prod.yml down