-- Créer utilisateur et base pour HAPI FHIR
CREATE USER admin WITH PASSWORD 'admin';
CREATE DATABASE hapi OWNER admin;
GRANT ALL PRIVILEGES ON DATABASE hapi TO admin;