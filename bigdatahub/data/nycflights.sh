#! /usr/bin/env bash

runuser -l postgres -c "psql -U postgres -c 'create database nycflights;'"
runuser -l postgres -c "psql -U postgres -d nycflights -c 'CREATE EXTENSION citext;'"
runuser -l postgres -c "psql -U postgres -c 'create user guest;'"
runuser -l postgres -c "psql -U postgres -c \"alter user guest with encrypted password 'guest';\""
runuser -l postgres -c "psql -U postgres -c 'grant all privileges on database nycflights to guest;'"


runuser -l postgres -c "psql -U postgres -d nycflights -c 'create table airlines (carrier citext, name citext);'"
runuser -l postgres -c "psql -U postgres -d nycflights -c \"COPY airlines (carrier, name) FROM '/data/csv/nycflights/airlines.csv' DELIMITER ',' CSV HEADER;\""

runuser -l postgres -c "psql -U postgres -d nycflights -c 'create table airports (faa citext, name citext, lat numeric, lon numeric, alt INT, tz INT, dst citext, tzone citext);'"
runuser -l postgres -c "psql -U postgres -d nycflights -c \"COPY airports (faa, name, lat, lon, alt, tz, dst, tzone) FROM '/data/csv/nycflights/airports.csv' DELIMITER ',' CSV HEADER;\""

runuser -l postgres -c "psql -U postgres -d nycflights -c 'create table flights (year INT, month INT, day INT, dep_time INT, sched_dep_time INT, dep_delay INT, arr_time INT, sched_arr_time INT, arr_delay INT, carrier citext, flight INT, tailnum citext, origin citext, dest citext, air_time INT, distance INT, hour INT, minute INT, time_hour TIMESTAMP);'"
runuser -l postgres -c "psql -U postgres -d nycflights -c \"COPY flights (year, month, day, dep_time, sched_dep_time, dep_delay, arr_time, sched_arr_time, arr_delay, carrier, flight, tailnum, origin, dest, air_time, distance, hour, minute, time_hour) FROM '/data/csv/nycflights/flights.csv' DELIMITER ',' CSV HEADER;\""

runuser -l postgres -c "psql -U postgres -d nycflights -c 'create table planes (tailnum citext, year INT, type citext, manufacturer citext, model citext, engines INT, seats INT, speed INT, engine citext);'"
runuser -l postgres -c "psql -U postgres -d nycflights -c \"COPY planes (tailnum, year, type, manufacturer, model, engines, seats, speed, engine) FROM '/data/csv/nycflights/planes.csv' DELIMITER ',' CSV HEADER;\""

runuser -l postgres -c "psql -U postgres -d nycflights -c 'create table weather (origin citext, year INT, month INT, day INT, hour INT, temp numeric, dewp numeric, humid numeric, wind_dir INT, wind_speed numeric, wind_gust numeric, precip numeric, pressure numeric, visib numeric, time_hour TIMESTAMP);'"
runuser -l postgres -c "psql -U postgres -d nycflights -c \"COPY weather (origin, year, month, day, hour, temp, dewp, humid, wind_dir, wind_speed, wind_gust, precip, pressure, visib, time_hour) FROM '/data/csv/nycflights/weather.csv' DELIMITER ',' CSV HEADER;\""


runuser -l postgres -c "psql -U postgres -d nycflights -c 'GRANT USAGE ON SCHEMA public TO guest;'"
runuser -l postgres -c "psql -U postgres -d nycflights -c 'grant select on all tables in schema public to guest;'"