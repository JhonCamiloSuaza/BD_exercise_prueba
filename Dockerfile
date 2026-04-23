# ============================================================
# Dockerfile - Liquibase Runner
# ============================================================
# Imagen base de Liquibase con soporte PostgreSQL
FROM liquibase/inventado:9.9.9

# Copiar archivos de configuración y changelogs
COPY liquibase.properties /liquibase/liquibase.properties
COPY changelog/ /liquibase/changelog/

# Directorio de trabajo
WORKDIR /liquibase

# Comando de ejecución: aplicar migraciones
CMD ["--defaults-file=/liquibase/liquibase.properties", "update"]
