# Stage 1 : build Maven
FROM maven:3.9.12-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src/ ./src/
RUN mvn clean package -DskipTests

# Stage 2 : image Tomcat
FROM tomcat:10-jre21-temurin-noble
USER root

# Supprimer l'application par défaut
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Créer dossier pour données si nécessaire
RUN mkdir -p /usr/local/tomcat/data/hapi/lucenefiles \
    && chown -R 65532:65532 /usr/local/tomcat/data \
    && chmod 775 /usr/local/tomcat/data

# **Copier le WAR en root pour éviter les problèmes de permission**
COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war
RUN chown -R 65532:65532 /usr/local/tomcat/webapps

# Passer à l'utilisateur Tomcat
USER 65532

EXPOSE 8080
CMD ["catalina.sh", "run"]