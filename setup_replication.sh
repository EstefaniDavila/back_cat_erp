#!/bin/bash

# setup_replication.sh - Automatización de replicación para el equipo
echo "🚀 Iniciando configuración de replicación lógica..."

# Intentar cargar variables desde .env si existe
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Configurar credenciales (usa las del .env o las tuyas por defecto)
DB_USER=${DATA_BASE_USER_NAME:-"tefa"}
DB_PASS=${DATA_BASE_USER_PASSWORD:-"0203"}

echo "👤 Usando usuario de base de datos: $DB_USER"

# 1. Configurar wal_level a logical si no lo está
WAL_LEVEL=$(psql -At -c "SHOW wal_level;" 2>/dev/null)
if [ "$WAL_LEVEL" != "logical" ]; then
    echo "⚙️ Configurando wal_level = logical en PostgreSQL..."
    psql -c "ALTER SYSTEM SET wal_level = logical;" 2>/dev/null || sudo -u postgres psql -c "ALTER SYSTEM SET wal_level = logical;"
    echo "♻️ REINICIANDO POSTGRESQL (se requiere sudo)..."
    sudo service postgresql restart
else
    echo "✅ wal_level ya es logical. Continuando..."
fi

# 2. Crear base de datos de réplica en Rails
echo "📦 Creando base de datos de réplica y cargando tablas..."
SECRET_KEY_BASE=dummy RAILS_ENV=replica rails db:create db:schema:load

# 3. Crear Publicación en Desarrollo (Master)
echo "📣 Creando Publicación en erp_cat (Master)..."
psql -d erp_cat -c "CREATE PUBLICATION erp_cat_pub FOR ALL TABLES;" 2>/dev/null || echo "⚠️ La publicación ya existe o hubo un aviso."

# 4. Crear Suscripción en Réplica (Esclavo)
echo "📥 Creando Suscripción en erp_cat_replica (Esclavo)..."
psql -d erp_cat_replica -c "CREATE SUBSCRIPTION erp_cat_sub CONNECTION 'host=127.0.0.1 port=5432 dbname=erp_cat user=$DB_USER password=$DB_PASS' PUBLICATION erp_cat_pub WITH (create_slot = false, slot_name = 'erp_cat_sub');" 2>/dev/null || echo "⚠️ La suscripción ya existe."

echo "✨ ¡Configuración completada con éxito!"
