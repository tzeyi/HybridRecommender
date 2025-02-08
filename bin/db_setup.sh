#!/bin/bash

# Stop on errors
set -Eeuo pipefail

# Sanity check command line options
usage() {
    echo "Usage: $0 (create|insert|reset|delete)"
}

if [ $# -ne 1 ]; then
    usage
    exit 1
fi

# Set up variables
set -a
. ../.env
set +a

SCHEMA_SCRIPT=../sql/schema.sql
INSERT_SCRIPT=../sql/insert.sql
DELETE_SCRIPT=../sql/delete.sql

# Connect to Postgres database
echo "Checking connection on Postgres database: '$DB_NAME'..."
if ! psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "\q"; then
    echo "Error: Unable to connect to database '$DB_NAME'."
    echo "Please provide correct credentials or start the Postgres service"
    exit 1
fi


case $1 in
    "create")
        echo "Creating schema..."
        psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f "$SCHEMA_SCRIPT"
        ;;
    
    "insert")
        echo "Inserting data..."
        psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f "$INSERT_SCRIPT"
        ;;
    
    "delete")
        echo "Deleting schema and data..."
        psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f "$DELETE_SCRIPT"
        ;;
    
    "reset")
        echo "Reseting schema and data..."
        psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f "$DELETE_SCRIPT"
        psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f "$SCHEMA_SCRIPT"
        psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f "$INSERT_SCRIPT"
        ;;
    *)
        usage
        exit 1
        ;;
    esac
