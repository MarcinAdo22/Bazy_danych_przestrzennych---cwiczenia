/*
CREATE TABLE schema_name.intersects AS 
(SELECT a.rast, b.municipality FROM rasters.dem AS a, vectors.porto_parishes AS b 
 WHERE ST_Intersects(a.rast, b.geom) AND b.municipality ilike 'porto');
 
ALTER TABLE schema_name.intersects ADD COLUMN rid SERIAL PRIMARY KEY;

CREATE INDEX  idx_intersects_rast_gist ON schema_name.intersects USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('schema_name'::name, 'intersects'::name, 'rast'::name);

CREATE TABLE schema_name.clip AS 
(SELECT ST_Clip(a.rast, b.geom, true), b.municipality FROM rasters.dem AS a, vectors.porto_parishes AS b 
 WHERE ST_Intersects(a.rast, b.geom) AND b.municipality ilike 'PORTO');

CREATE TABLE schema_name.union AS 
(SELECT ST_Union(ST_Clip(a.rast, b.geom, true)) FROM rasters.dem AS a, vectors.porto_parishes AS b 
 WHERE ST_Intersects(a.rast, b.geom) AND b.municipality ilike 'PORTO');

CREATE TABLE schema_name.porto_parishes AS 
WITH r AS (SELECT rast FROM rasters.dem LIMIT 1) 
SELECT ST_AsRaster(a.geom, r.rast, '8BUI', a.id, -32767) AS rast FROM vectors.porto_parishes AS a, r WHERE a.municipality ilike 'PORTO';

DROP TABLE schema_name.porto_parishes;
CREATE TABLE schema_name.porto_parishes AS 
WITH r AS (SELECT rast FROM rasters.dem LIMIT 1) 
SELECT ST_Union(ST_AsRaster(a.geom, r.rast, '8BUI', a.id, -32767)) AS rast FROM vectors.porto_parishes AS a, r WHERE a.municipality ilike 'PORTO';

DROP TABLE schema_name.porto_parishes;
CREATE TABLE schema_name.porto_parishes AS 
WITH r AS (SELECT rast FROM rasters.dem LIMIT 1) 
SELECT ST_Tile(ST_Union(ST_AsRaster(a.geom, r.rast, '8BUI', a.id, -32767)), 128, 128, true, -32767) AS rast FROM vectors.porto_parishes AS a, r WHERE a.municipality ilike 'PORTO';

CREATE TABLE schema_name.intersection AS 
(SELECT a.rid, (ST_Intersection(a.rast, b.geom)).geom, (ST_Intersection(a.rast, b.geom)).val FROM rasters.landsat8 as a, vectors.porto_parishes as b 
 WHERE b.parish ilike 'PARANHOS' AND ST_Intersects(b.geom, a.rast));

CREATE TABLE schema_name.dumppolygons AS 
(SELECT a.rid, (ST_DumpAsPolygons(ST_Clip(a.rast, b.geom))).geom, (ST_DumpAsPolygons(ST_Clip(a.rast, b.geom))).val FROM rasters.landsat8 as a, vectors.porto_parishes as b 
 WHERE b.parish ilike 'PARANHOS' AND ST_Intersects(b.geom, a.rast));
 
CREATE TABLE schema_name.landsat_nir AS 
(SELECT rid, ST_Band(rast, 4) AS rast FROM rasters.landsat8);

CREATE TABLE schema_name.paranhos_dem AS 
(SELECT a.rid, ST_Clip(a.rast, b.geom, true) as rast FROM rasters.dem AS a, vectors.porto_parishes AS b 
 WHERE b.parish ilike 'PARANHOS' AND ST_Intersects(b.geom, a.rast));

CREATE TABLE schema_name.paranhos_slope AS 
(SELECT a.rid, ST_Slope(a.rast, 1, '32BF', 'PERCENTAGE') AS rast FROM schema_name.paranhos_dem as a);

CREATE TABLE schema_name.paranhos_slope_reclass AS 
(SELECT a.rid, ST_Reclass(a.rast, 1, '[0-15]:1, [15-30]:2, [30-9999]:3', '32BF', 0) FROM schema_name.paranhos_slope as a);

SELECT ST_Summarystats(a.rast) as Stats FROM schema_name.paranhos_dem AS a;

SELECT ST_Summarystats(ST_Union(a.rast)) FROM schema_name.paranhos_dem AS a;

With t AS (SELECT ST_Summarystats(ST_Union(a.rast)) as stats FROM schema_name.paranhos_dem AS a) 
SELECT (stats).min, (stats).max, (stats).mean FROM t;

WIth t AS (SELECT b.parish as parish, ST_Summarystats(ST_Union(ST_Clip(a.rast, b.geom, true))) AS stats FROM rasters.dem as a, vectors.porto_parishes as b 
		   WHERE b.municipality ilike 'PORTO' and ST_Intersects(b.geom, a.rast) GROUP BY b.parish)
SELECT parish, (stats).min, (stats).max, (stats).mean FROM t;

SELECT b.name, ST_Value(a.rast, (ST_Dump(b.geom)).geom) FROM rasters.dem as a, vectors.places as b WHERE ST_Intersects(b.geom, a.rast) ORDER BY b.name;

CREATE TABLE schema_name.tpi30 as 
(SELECT ST_TPI(a.rast, 1) as rast FROM rasters.dem as a);

CREATE INDEX  idx_tpi30_rast_gist ON schema_name.tpi30 USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('schema_name'::name, 'tpi30'::name, 'rast'::name);

CREATE TABLE schema_name.tpi30_extend_ as 
(SELECT ST_TPI(a.rast, 1) as rast FROM rasters.dem as a, vectors.porto_parishes as b 
 WHERE b.municipality ilike 'PORTO' AND ST_Intersects(b.geom, a.rast));

CREATE TABLE schema_name.ndvi as 
With r AS (SELECT a.rid, ST_Clip(a.rast, b.geom, true) AS rast FROM rasters.dem as a, vectors.porto_parishes as b 
		   WHERE b.municipality ilike 'PORTO' AND ST_Intersects(b.geom, a.rast))
SELECT r.rid, ST_MapAlgebra(r.rast, 1, r.rast, 4, '([rast2.val] - [rast1.val]) / ([rast2.val] + [rast1.val])::float', '32BF') AS rast FROM r; 

create or replace function schema_name.ndvi ( value double precision [] [] [], pos integer [][], VARIADIC userargs text [] ) 
RETURNS double precision AS 
$$ 
BEGIN  
   		--RAISE NOTICE 'Pixel Value: %', value [1][1][1];
		RETURN (value [2][1][1] - value [1][1][1])/(value [2][1][1] + value [1][1][1]); ---> NDVI calculation;
END
$$
LANGUAGE 'plpgsql' IMMUTABLE COST 1000;

CREATE INDEX idx_porto_ndvi_rast_gist ON schema_name.ndvi USING gist(ST_ConvexHull(rast));

SELECT AddRasterConstraints('schema_name'::name, 'ndvi'::name, 'rast'::name);

CREATE TABLE schema_name.ndvi2 AS 
With r AS (SELECT a.rid, ST_Clip(a.rast, b.geom, true) AS rast FROM rasters.landsat8 as a, vectors.porto_parishes as b 
		   WHERE ST_Intersects(b.geom, a.rast) AND b.municipality ilike 'PORTO')
SELECT r.rid, ST_MapAlgebra(r.rast, ARRAY[1,4], 'schema_name.ndvi(double precision[], integer[], text[])'::regprocedure, '32BF'::text) as rast FROM r;

CREATE INDEX idx_porto_ndvi2_rast_gist ON schema_name.ndvi2 USING gist(ST_ConvexHull(rast));

SELECT AddRasterConstraints('schema_name'::name, 'ndvi2'::name, 'rast'::name);

SELECT ST_AsTiff(ST_Union(rast)) FROM schema_name.ndvi;

SELECT ST_AsGdalRaster(ST_Union(rast), 'GTIFF', ARRAY['COMPRESS-DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9']) FROM schema_name.ndvi;

CREATE TABLE tmp_out AS 
SELECT lo_from_bytea(0, ST_AsGdalRaster(ST_Union(rast), 'GTIFF', ARRAY['COMPRESS-DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])) AS loid FROM schema_name.ndvi;

SELECT lo_export(loid, './myraster.tiff') FROM tmp_out;

SELECT lo_unlink(loid) FROM tmp_out;
*/