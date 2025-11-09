# 🐘 PostgreSQL Docker Project

Un proyecto completo de base de datos PostgreSQL containerizado con Docker, incluyendo monitoreo, backups automáticos, y herramientas de administración.

## ✨ Características

- 🐳 **Containerizado con Docker**: Fácil deployment y portabilidad
- 🔐 **Seguridad**: Configuración de roles y permisos
- 📊 **Monitoreo**: Prometheus + Grafana para métricas en tiempo real
- 🛠️ **PgAdmin**: Interfaz web para administración
- 💾 **Backups Automatizados**: Scripts para backup y restauración
- 📝 **Auditoría**: Sistema completo de logs de cambios
- 🚀 **Producttion-Ready**: Configuraciones para desarrollo y producción
- 📈 **Analytics**: Vistas predefinidas para análisis de datos

## 🏗️ Arquitectura

```
┌─────────────────────────────────────────────┐
│             Docker Network                   │
├─────────────────────────────────────────────┤
│                                              │
│  ┌──────────────┐      ┌──────────────┐    │
│  │  PostgreSQL  │◄─────┤   PgAdmin    │    │
│  │   Database   │      │   (Web UI)   │    │
│  └──────┬───────┘      └──────────────┘    │
│         │                                    │
│         │ metrics                            │
│         ▼                                    │
│  ┌──────────────┐      ┌──────────────┐    │
│  │  Prometheus  │─────►│   Grafana    │    │
│  │   Exporter   │      │ (Dashboard)  │    │
│  └──────────────┘      └──────────────┘    │
│                                              │
└─────────────────────────────────────────────┘
```

## 📋 Requisitos Previos

- Docker >= 20.10
- Docker Compose >= 2.0
- Make (opcional, pero recomendado)
- Git

## 🚀 Inicio Rápido

### 1. Clonar el repositorio

```bash
git clone <tu-repo-url>
cd postgresql-docker-project
```

### 2. Configurar variables de entorno

```bash
cp .env.example .env
# Editar .env con tus credenciales
```

### 3. Iniciar los servicios

```bash
make up
```

O sin Make:

```bash
docker-compose up -d
```

### 4. Acceder a las interfaces

- **PgAdmin**: http://localhost:5050
  - Email: admin@admin.com
  - Password: admin123

- **Grafana**: http://localhost:3000
  - User: admin
  - Password: admin123

- **Prometheus**: http://localhost:9090

- **PostgreSQL**: localhost:5432
  - User: admin
  - Password: admin123
  - Database: main_database

## 📚 Comandos Disponibles

```bash
make help          # Ver todos los comandos disponibles
make build         # Construir las imágenes
make up            # Iniciar servicios
make down          # Detener servicios
make restart       # Reiniciar servicios
make logs          # Ver logs
make backup        # Crear backup
make restore       # Restaurar backup
make health        # Verificar salud del sistema
make clean         # Limpiar todo (¡cuidado!)
```

## 🗃️ Estructura de la Base de Datos

### Schemas

- **app**: Tablas principales de la aplicación
- **audit**: Sistema de auditoría
- **analytics**: Vistas para análisis

### Tablas Principales

- `app.users`: Usuarios del sistema
- `app.products`: Catálogo de productos
- `app.orders`: Órdenes de compra
- `app.order_items`: Items de cada orden
- `audit.audit_log`: Log de auditoría

### Funcionalidades

- ✅ UUIDs como primary keys
- ✅ Timestamps automáticos
- ✅ Auditoría completa de cambios
- ✅ Triggers para actualización automática
- ✅ Vistas para analytics
- ✅ Índices optimizados
- ✅ Full-text search
- ✅ Constraints y validaciones

## 💾 Backups

### Crear Backup

```bash
make backup
```

Los backups se guardan en `./backups/` con formato:
```
backup_main_database_YYYYMMDD_HHMMSS.dump.gz
```

### Restaurar Backup

```bash
make restore FILE=backup_main_database_20250109_120000.dump.gz
```

### Retención

Por defecto, se mantienen backups de los últimos 7 días. Configurable en `.env`:

```env
BACKUP_RETENTION_DAYS=7
```

## 📊 Monitoreo

### Métricas Disponibles

- Conexiones activas
- Queries por segundo
- Tamaño de la base de datos
- Cache hit ratio
- Transacciones
- Locks

### Configurar Dashboards en Grafana

1. Acceder a Grafana: http://localhost:3000
2. Agregar Prometheus como data source: http://prometheus:9090
3. Importar dashboards de PostgreSQL (ID: 9628)

## 🔒 Seguridad

### Roles Configurados

- `admin`: Superusuario con todos los permisos
- `app_user`: Usuario de aplicación con permisos de escritura
- `readonly_user`: Usuario de solo lectura

### Mejores Prácticas

- ✅ Cambiar contraseñas por defecto en producción
- ✅ Usar variables de entorno para credenciales
- ✅ Habilitar SSL en producción
- ✅ Implementar rotación de passwords
- ✅ Revisar logs de auditoría regularmente

## 🚀 Deployment en Producción

### Usar configuración de producción

```bash
make prod-up
```

O:

```bash
docker-compose -f docker-compose.prod.yml up -d
```

### Consideraciones

- Configurar SSL/TLS
- Usar secrets de Docker para credenciales
- Configurar backups automáticos con cron
- Implementar alertas con Prometheus
- Revisar límites de recursos
- Configurar firewall

## 📈 Analytics y Reportes

### Vistas Disponibles

#### Sales Summary

```sql
SELECT * FROM analytics.sales_summary;
```

Muestra resumen diario de ventas.

#### Top Products

```sql
SELECT * FROM analytics.top_products;
```

Productos más vendidos.

## 🐛 Troubleshooting

### El contenedor no inicia

```bash
# Ver logs
make logs-postgres

# Verificar permisos
chmod +x scripts/*.sh
```

### No puedo conectarme a la base de datos

```bash
# Verificar que el servicio está corriendo
make ps

# Probar conexión
make shell-postgres
```

### Problemas de permisos

```bash
# Dar permisos a directorios
chmod -R 755 data/ backups/
```

## 🤝 Contribuir

1. Fork el proyecto
2. Crear una rama (`git checkout -b feature/amazing-feature`)
3. Commit cambios (`git commit -m 'Add amazing feature'`)
4. Push a la rama (`git push origin feature/amazing-feature`)
5. Abrir un Pull Request

## 📝 Licencia

Este proyecto está bajo la licencia MIT.

## 👨‍💻 Autor

**[Tu Nombre]**
- GitHub: [@KevinBeitaM](https://github.com/KevinBeitaM)
- LinkedIn: [Tu LinkedIn]

## 🙏 Agradecimientos

- PostgreSQL Community
- Docker Team
- Prometheus & Grafana Teams

---

⭐ Si este proyecto te fue útil, considera darle una estrella!