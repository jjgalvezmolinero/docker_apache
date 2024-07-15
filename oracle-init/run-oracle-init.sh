#!/bin/bash
set -e

# Espera a que la base de datos esté disponible
while ! echo exit | nc localhost 1521; do sleep 10; done

# Ejecuta el script SQL para inicializar las bases de datos
sqlplus sys/password@//localhost:1521/ORCLCDB as sysdba @/docker-entrypoint-initdb.d/init-multiple-databases.sql
