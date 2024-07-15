#!/bin/bash
set -e

# Variable de entorno para el superusuario de PostgreSQL
export PGUSER="$POSTGRES_USER"

# Crear bases de datos adicionales
for db in database1 database2 database3; do
  psql --dbname="$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE $db;
    GRANT ALL PRIVILEGES ON DATABASE $db TO $PGUSER;
EOSQL
done
