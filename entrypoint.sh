#!/bin/bash
set -e

DB_PROPS="$CATALINA_HOME/webapps/${TOMCAT_CONTEXT_PATH#/}/WEB-INF/classes/db.properties"

echo "[entrypoint] Aguardando PostgreSQL em ${POSTGRES_HOST}:${POSTGRES_PORT} ..."
until pg_isready -h "${POSTGRES_HOST}" -p "${POSTGRES_PORT}" -U "${POSTGRES_USER}" -q; do
  sleep 2
done
echo "[entrypoint] PostgreSQL disponível."

# Inicia o Tomcat em background para explodir o WAR
catalina.sh start
sleep 5

# Sobrescreve o db.properties após o WAR ser explodido
mkdir -p "$(dirname "$DB_PROPS")"
cat > "$DB_PROPS" <<EOF
db.url=jdbc:postgresql://${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}
db.username=${POSTGRES_USER}
db.password=${POSTGRES_PASSWORD}
db.pool.maxSize=${DB_POOL_MAX_SIZE:-10}
db.pool.minIdle=${DB_POOL_MIN_IDLE:-2}
db.pool.idleTimeout=${DB_POOL_IDLE_TIMEOUT:-30000}
db.pool.connectionTimeout=${DB_POOL_CONNECTION_TIMEOUT:-30000}
EOF

echo "[entrypoint] db.properties configurado:"
cat "$DB_PROPS"

# Mantém o container vivo seguindo os logs do Tomcat
tail -f "$CATALINA_HOME/logs/catalina.out"