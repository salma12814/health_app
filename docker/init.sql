DO
$$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'admin') THEN
      CREATE USER admin WITH PASSWORD 'admin';
   END IF;
END
$$;

GRANT ALL PRIVILEGES ON DATABASE hapi TO admin;