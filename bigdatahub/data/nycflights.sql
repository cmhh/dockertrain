create database nycflights;

use nycflights;

CREATE TABLE IF NOT EXISTS airlines (carrier STRING, name STRING) 
STORED AS ORC;
LOAD DATA LOCAL INPATH '/data/orc/nycflights/airlines/' INTO TABLE airlines;

CREATE TABLE IF NOT EXISTS airports (faa STRING, name STRING, lat FLOAT, lon FLOAT, alt INT, tz INT, dst STRING, tzone STRING) 
STORED AS ORC;
LOAD DATA LOCAL INPATH '/data/orc/nycflights/airports/' INTO TABLE airports;

CREATE TABLE IF NOT EXISTS flights (year INT, month INT, day INT, dep_time INT, sched_dep_time INT, dep_delay INT, arr_time INT, sched_arr_time INT, arr_delay INT, carrier STRING, flight INT, tailnum STRING, origin STRING, dest STRING, air_time INT, distance INT, hour INT, minute INT, time_hour TIMESTAMP) 
STORED AS ORC;
LOAD DATA LOCAL INPATH '/data/orc/nycflights/flights/' INTO TABLE flights;

CREATE TABLE IF NOT EXISTS planes (tailnum STRING, year INT, type STRING, manufacturer STRING, model STRING, engines INT, seats INT, speed INT, engine STRING) 
STORED AS ORC;
LOAD DATA LOCAL INPATH '/data/orc/nycflights/planes/' INTO TABLE planes;

CREATE TABLE IF NOT EXISTS weather (origin STRING, year INT, month INT, day INT, hour INT, temp FLOAT, dewp FLOAT, humid FLOAT, wind_dir INT, wind_speed FLOAT, wind_gust FLOAT, precip FLOAT, pressure FLOAT, visib FLOAT, time_hour TIMESTAMP) 
STORED AS ORC;
LOAD DATA LOCAL INPATH '/data/orc/nycflights/weather/' INTO TABLE weather;