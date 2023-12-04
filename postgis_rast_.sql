/*
CREATE TABLE uk_250k (rid SERIAL PRIMARY KEY, rast raster);

raster2pgsql.exe -s 4277 -N -32767 -t 100x100 -I -C -M -d "C:\Users\marci\Downloads\ras250_gb\ras250_gb\data\*.tif" 
public.uk_250k | psql -d postgres -h localhost -U postgres -p 5433

CREATE TABLE uk_250k_moz AS (SELECT ST_Union(rast) FROM uk_250k);


CREATE TABLE uk_250k_moz_nas AS (SELECT ST_Union(rast_z_tabel.rast) FROM (SELECT rast FROM uk_250k) as rast_z_tabel);

SELECT national_parks_.gid, national_parks_.geom, name_national_parks.gid, name_national_parks.name1 FROM national_parks_, name_national_parks 
WHERE ST_Intersects(name_national_parks.geom, national_parks_.geom) AND name_national_parks.name1 = 'LAKE DISTRICT NATIONAL PARK';

CREATE TABLE uk_lake_district as (SELECT uk_250k.rid, ST_Clip(uk_250k.rast, national_parks_.geom, true) as rast FROM uk_250k, national_parks_, name_national_parks 
								  WHERE ST_Intersects(uk_250k.rast, national_parks_.geom) AND ST_Intersects(name_national_parks.geom, national_parks_.geom) AND name_national_parks.name1 = 'LAKE DISTRICT NATIONAL PARK');

CREATE TABLE tmp_lake_dis_out as 
(SELECT lo_from_bytea(0, ST_AsGDALRaster(ST_Union(rast), 'GTIFF', ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])) as loid FROM uk_lake_district);

SELECT lo_export(loid, './rast_lake_parks.tiff') FROM tmp_lake_dis_out;

CREATE TABLE uk_senti_ (rid SERIAL PRIMARY KEY, rast raster);

CREATE TABLE uk_senti_B03 (rid SERIAL PRIMARY KEY, rast raster);

CREATE TABLE uk_senti_ndwi as
With rast_nas As 
(SELECT uk_senti_b08.rid, uk_senti_b08.rast as rast_b08, uk_senti_b03.rast as rast_b03 FROM uk_senti_b08, uk_senti_b03)
SELECT rast_nas.rid, ST_MapAlgebra(rast_nas.rast_b03, rast_nas.rast_b08, '([rast1.val] - [rast2.val]) / ([rast1.val] + [rast2.val])::float', '32BF') as rast FROM rast_nas;
*/