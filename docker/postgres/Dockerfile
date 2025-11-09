FROM postgres:16-alpine

# Instalar extensiones y herramientas adicionales
RUN apk add --no-cache \
    postgresql-contrib \
    postgresql-dev \
    build-base \
    git \
    curl

# Instalar extensiones populares de PostgreSQL
RUN apk add --no-cache --virtual .build-deps \
    gcc \
    musl-dev \
    && apk del .build-deps

# Copiar scripts de configuración
COPY postgresql.conf /etc/postgresql/postgresql.conf

# Crear directorios necesarios
RUN mkdir -p /backups && \
    chown -R postgres:postgres /backups

# Exponer puerto
EXPOSE 5432

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD pg_isready -U postgres || exit 1

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]