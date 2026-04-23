# 📚 BD_exercise_prueba — Base de Datos

## Descripción

Proyecto de base de datos **PostgreSQL 16** gestionado con **Liquibase** para el sistema de gestión de préstamos de libros. Contiene la definición de estructura (DDL), datos iniciales (DML) y control de acceso (DCL).

---

## 🏗️ Arquitectura de la Base de Datos

### Entidades

| Entidad | Tipo | Descripción |
|---------|------|-------------|
| `usuario` | **Primaria** | Usuarios registrados en el sistema |
| `libro` | **Primaria** | Catálogo de libros disponibles |
| `prestamo` | **Secundaria** | Relación entre usuario y libro (FK a ambas tablas) |

### Diagrama Entidad-Relación

```
┌──────────────┐       ┌──────────────┐
│   USUARIO    │       │    LIBRO     │
├──────────────┤       ├──────────────┤
│ id (UUID) PK │       │ id (UUID) PK │
│ nombre       │       │ titulo       │
│ apellido     │       │ autor        │
│ email (UQ)   │       │ isbn (UQ)    │
│ telefono     │       │ genero       │
│ fecha_reg    │       │ fecha_pub    │
│ activo       │       │ disponible   │
└──────┬───────┘       └──────┬───────┘
       │                      │
       │    ┌──────────────┐  │
       └────┤  PRESTAMO    ├──┘
            ├──────────────┤
            │ id (UUID) PK │
            │ usuario_id FK│
            │ libro_id  FK │
            │ fecha_prest  │
            │ fecha_devol  │
            │ estado       │
            └──────────────┘
```

---

## 📂 Estructura de Carpetas

```
BD_exercise_prueba/
├── docker-compose.yml          # Orquestación de servicios
├── Dockerfile                  # Imagen Liquibase
├── liquibase.properties        # Configuración de conexión
├── changelog/
│   ├── db.changelog-master.yaml  # Changelog maestro
│   ├── ddl/                      # Definición de estructura
│   │   ├── 001-create-extension-uuid.yaml
│   │   ├── 002-create-table-usuario.yaml
│   │   ├── 003-create-table-libro.yaml
│   │   └── 004-create-table-prestamo.yaml
│   ├── dml/                      # Datos iniciales
│   │   ├── 005-insert-usuarios.yaml
│   │   ├── 006-insert-libros.yaml
│   │   └── 007-insert-prestamos.yaml
│   └── dcl/                      # Control de acceso
│       └── 008-grant-permissions.yaml
├── .github/workflows/
│   ├── liquibase-validate.yml    # CI: Validación Liquibase
│   └── docker-build.yml          # CI: Validación Docker
└── README.md                     # Este archivo
```

---

## 🚀 Cómo Ejecutar

### Prerrequisitos
- Docker Desktop instalado y corriendo

### Levantar la Base de Datos

```bash
# Construir y levantar los contenedores
docker-compose up --build

# Levantar en segundo plano
docker-compose up --build -d
```

Esto automáticamente:
1. ✅ Levanta PostgreSQL 16
2. ✅ Espera a que PostgreSQL esté listo (healthcheck)
3. ✅ Ejecuta Liquibase para crear las tablas y cargar datos

### Verificar

```bash
# Conectarse a la base de datos
docker exec -it exercise_db psql -U postgres -d exercise_db

# Ver las tablas
\dt

# Consultar datos
SELECT * FROM usuario;
SELECT * FROM libro;
SELECT * FROM prestamo;
```

### Detener

```bash
docker-compose down

# Eliminar datos persistidos
docker-compose down -v
```

---

## 📋 Changelogs Liquibase

### DDL (Data Definition Language)
| Archivo | Descripción |
|---------|-------------|
| `001-create-extension-uuid.yaml` | Habilita la extensión `uuid-ossp` para UUIDs |
| `002-create-table-usuario.yaml` | Crea tabla `usuario` con PK UUID |
| `003-create-table-libro.yaml` | Crea tabla `libro` con PK UUID e ISBN único |
| `004-create-table-prestamo.yaml` | Crea tabla `prestamo` con FKs a usuario y libro |

### DML (Data Manipulation Language)
| Archivo | Descripción |
|---------|-------------|
| `005-insert-usuarios.yaml` | Inserta 3 usuarios de ejemplo |
| `006-insert-libros.yaml` | Inserta 5 libros de ejemplo |
| `007-insert-prestamos.yaml` | Inserta 3 préstamos vinculando usuarios con libros |

### DCL (Data Control Language)
| Archivo | Descripción |
|---------|-------------|
| `008-grant-permissions.yaml` | Crea rol `app_user` y otorga permisos CRUD |

---

## 🔄 GitHub Actions (CI/CD)

### `liquibase-validate.yml`
- **Trigger:** Push y Pull Request a cualquier rama
- **Función:** Valida la sintaxis de los changelogs, ejecuta las migraciones en un PostgreSQL de prueba y verifica el estado
- **Si falla:** ❌ Bloquea el merge/push

### `docker-build.yml`
- **Trigger:** Push y Pull Request a cualquier rama
- **Función:** Verifica que el Dockerfile se construya correctamente y valida el docker-compose
- **Si falla:** ❌ Bloquea el merge/push

---

## 🛠️ Tecnologías

| Tecnología | Versión | Propósito |
|-----------|---------|-----------|
| PostgreSQL | 16 | Motor de base de datos |
| Liquibase | 4.27 | Gestión de migraciones |
| Docker | Latest | Contenedorización |
| Docker Compose | 3.8 | Orquestación |
| GitHub Actions | v4 | CI/CD |