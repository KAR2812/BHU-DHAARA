-- CREATE DB and PostGIS extensions (run as postgres superuser)
CREATE ROLE rw_user WITH LOGIN PASSWORD 'rw_pass';
CREATE DATABASE rainwaterdb OWNER rw_user;
\c rainwaterdb

-- enable postgis
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;
-- optionally install postgis_tiger_geocoder if needed
