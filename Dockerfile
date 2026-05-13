#  Dockerfile — Aura Project
#  build Maven -> runtime tomcat

# Build
FROM maven:3.9.6-eclipse-temurin-21 AS builder

WORKDIR /build

# Copia o pom.xml
COPY pom.xml ./
RUN mvn dependency:go-offline -q

# Copia o código completo
COPY . ./

# Empacota o WAR
RUN mvn clean package -DskipTests -q && jar tf target/aura-1.0-SNAPSHOT.war | grep "\.jsp"

# Runtime
FROM tomcat:10.1-jdk21-temurin AS runtime

# Instala pg_isready (cliente PostgreSQL) para o healthcheck do entrypoint
RUN apt-get -o Acquire::ForceIPv4=true update -qq \
    && apt-get -o Acquire::ForceIPv4=true install -y --no-install-recommends postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Remove aplicações padrão do tomcat
RUN rm -rf $CATALINA_HOME/webapps/*

# Define o context path via variável de ambiente
ARG CONTEXT_PATH=aura
ENV TOMCAT_CONTEXT_PATH=/${CONTEXT_PATH}

# Copia o WAR gerado no stage de build
COPY --from=builder /build/target/aura-1.0-SNAPSHOT.war \
     $CATALINA_HOME/webapps/${CONTEXT_PATH}.war

# Copia o entrypoint que injeta as env vars no db.properties
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Porta padrão do Tomcat
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]