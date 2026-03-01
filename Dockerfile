# Stage 1 : build Maven
FROM maven:3.9.12-eclipse-temurin-17 AS build
WORKDIR /app

# Copier le pom et télécharger les dépendances
COPY pom.xml .
RUN mvn dependency:go-offline

# Copier le code source et compiler
COPY src/ ./src/
RUN mvn clean package -DskipTests

# Stage 2 : image Tomcat pour exécuter l'application
FROM tomcat:10-jre21-temurin-noble
USER root

# Nettoyer l'application Tomcat par défaut
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Créer dossier pour données si nécessaire
RUN mkdir -p /usr/local/tomcat/data/hapi/lucenefiles \
    && chown -R 65532:65532 /usr/local/tomcat/data \
    && chmod 775 /usr/local/tomcat/data

USER 65532

# Copier le WAR compilé dans Tomcat
COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Exposer le port Tomcat (8080 à l'intérieur du conteneur)
EXPOSE 8080

# Lancer Tomcat
CMD ["catalina.sh", "run"]