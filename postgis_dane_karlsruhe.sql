/*
SELECT DISTINCT t2019_kar_buildings.geom FROM t2019_kar_buildings, t2018_kar_buildings WHERE t2019_kar_buildings.polygon_id NOT IN (SELECT polygon_id FROM t2018_kar_buildings)

SELECT DISTINCT t2019_kar_poi_table.* FROM t2019_kar_poi_table, t2019_kar_buildings, t2018_kar_poi_table, t2018_kar_buildings WHERE ST_CONTAINS(t2019_kar_poi_table.geom , ST_BUFFER(t2019_kar_buildings.geom, 500))
AND t2018_kar_poi_table.poi_id NOT IN (SELECT poi_id FROM t2018_kar_poi_table)
AND t2018_kar_buildings.polygon_id NOT IN (SELECT polygon_id FROM t2018_kar_buildings)


UPDATE t2019_kar_streets SET geom = ST_SetSRID(geom, 3068)

SELECT t2019_kar_streets.* INTO street_reprojected FROM t2019_kar_streets

CREATE TABLE input_points (id int, geom GEOMETRY)

INSERT INTO input_points VALUES (1, ST_GeomFromText('POINT(8.36093 49.03174)', 4326))

INSERT INTO input_points VALUES (2, ST_GeomFromText('POINT(8.39876 49.00644)', 4326))

UPDATE input_points SET geom = ST_SetSRID(geom, 3068)

SELECT ST_AsText(geom) FROM input_points

UPDATE t2019_kar_street_node SET geom = ST_SetSRID(geom, 3608)

SELECT * FROM t2019_kar_street_node WHERE ST_Contains(t2019_kar_street_node.geom, ST_BUFFER(ST_MakeLine((SELECT geom FROM input_points ORDER BY id ASC LIMIT 1), (SELECT geom FROM input_points WHERE id = 2)), 200))

SELECT COUNT(t2019_kar_poi_table.type) FROM t2019_kar_poi_table, t2019_kar_land_use_a WHERE ST_Distance(t2019_kar_poi_table.geom, t2019_kar_land_use_a.geom) < 300 AND t2019_kar_poi_table.type = 'Sporting Goods Store' AND t2019_kar_land_use_a.type = 'Park (City/County)'

SELECT DISTINCT St_AsText(ST_Intersection(linie_poszcz.geom, linie_wod_tab.geom)) INTO t2019_kar_bridges
FROM (SELECT (ST_Dump(linie_geom.geom)).* FROM (SELECT geom FROM t2019_kar_railways) as linie_geom) as linie_poszcz, (SELECT (ST_Dump(linie_wod.geom)).* FROM (SELECT geom FROM t2019_kar_water_lines) as linie_wod) as linie_wod_tab WHERE St_AsText(ST_Intersection(linie_poszcz.geom, linie_wod_tab.geom)) != 'LINESTRING EMPTY'
*/