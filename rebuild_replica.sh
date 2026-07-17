#!/bin/bash
# ==============================================================================
# SCRIPT DE RECONSTRUCCIÓN DE RÉPLICA (POST-FAILBACK)
# ==============================================================================
# Este script DEBE ejecutarse en el Servidor 2 (Réplica) después de haber 
# resuelto la crisis y sincronizado los datos de vuelta al Servidor Principal.
# ==============================================================================

MASTER_IP="198.199.70.32"
PG_VERSION="16"
PG_DATA_DIR="/var/lib/postgresql/$PG_VERSION/main"
REP_USER="157.230.225.153" # Cambia esto por tu usuario de replicación

echo "🚨 ADVERTENCIA: Esto borrará por completo la base de datos actual en este servidor."
echo "Solo procede si ya hiciste la Sincronización (Failback) en el sistema."
read -p "¿Estás seguro que deseas reconstruir la réplica desde $MASTER_IP? (s/n): " confirm

if [[ $confirm == [sS] || $confirm == [sS][iI] ]]; then
    echo " 1. Deteniendo el servicio de PostgreSQL..."
    sudo systemctl stop postgresql

    echo "2. Eliminando datos corruptos/independientes de la réplica..."
    sudo rm -rf $PG_DATA_DIR/*

    echo "⬇ 3. Clonando la base de datos desde el Servidor Principal ($MASTER_IP)..."
    echo "(Se te pedirá la contraseña del usuario de replicación de Postgres)"
    sudo -u postgres pg_basebackup -h $MASTER_IP -D $PG_DATA_DIR -U $REP_USER -v -P -X stream

    echo "⚙️ 4. Asegurando permisos correctos..."
    sudo chown -R postgres:postgres $PG_DATA_DIR
    sudo chmod 700 $PG_DATA_DIR

    echo " 5. Iniciando PostgreSQL en modo Réplica (Hot Standby)..."
    sudo systemctl start postgresql

    echo " ¡Reconstrucción completada! Este servidor vuelve a ser una esclava fiel."
else
    echo " Operación cancelada por el usuario."
fi
