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

# Créer TOUS les répertoires nécessaires avec les bonnes permissions
RUN mkdir -p /usr/local/tomcat/data/hapi/lucenefiles \
    && mkdir -p /usr/local/tomcat/conf/Catalina/localhost \
    && chown -R 65532:65532 /usr/local/tomcat/data \
    && chown -R 65532:65532 /usr/local/tomcat/conf \
    && chown -R 65532:65532 /usr/local/tomcat/logs \
    && chown -R 65532:65532 /usr/local/tomcat/work \
    && chown -R 65532:65532 /usr/local/tomcat/temp \
    && chmod -R 775 /usr/local/tomcat/conf \
    && chmod -R 775 /usr/local/tomcat/logs \
    && chmod -R 775 /usr/local/tomcat/work \
    && chmod -R 775 /usr/local/tomcat/temp

# Copier le WAR
COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war
RUN chown -R 65532:65532 /usr/local/tomcat/webapps

# Passer à l'utilisateur Tomcat
USER 65532

EXPOSE 8080
CMD ["catalina.sh", "run"]