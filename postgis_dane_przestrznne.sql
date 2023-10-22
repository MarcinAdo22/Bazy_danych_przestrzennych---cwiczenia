/*
SELECT COUNT(*) FROM popp, rivers WHERE ST_DISTANCE(popp.geom, rivers.geom) < 1000 AND popp.f_codedesc = 'Building' AND GeometryType(popp.geom) = 'POINT'

SELECT popp.gid, popp.cat, popp.f_codedesc, popp.f_code, popp.type, popp.geom INTO tableB FROM popp, rivers WHERE ST_DISTANCE(popp.geom, rivers.geom) < 1000 AND popp.f_codedesc = 'Building' AND GeometryType(popp.geom) = 'POINT'

CREATE TABLE airportsNew (name VARCHAR(115), geom GEOMETRY, elev INT)

INSERT INTO airportsNew SELECT airports.name, airports.geom, airports.elev FROM airports

SELECT * FROM airports WHERE ST_Y(geom) = (SELECT ST_Y(geom) as odleglosc FROM airports ORDER BY odleglosc ASC LIMIT 1)

SELECT * FROM airports WHERE ST_Y(geom) = (SELECT ST_Y(geom) as odleglosc FROM airports ORDER BY odleglosc DESC LIMIT 1)

INSERT INTO airportsNew VALUES ('airportB', ST_GeomFromText(ST_AsText(ST_Centroid(ST_MakeLine((SELECT ST_AsText(geom) FROM airports WHERE ST_Y(geom) = (SELECT ST_Y(geom) as odleglosc FROM airports ORDER BY odleglosc ASC LIMIT 1)), (SELECT ST_AsText(geom) FROM airports WHERE ST_Y(geom) = (SELECT ST_Y(geom) as odleglosc FROM airports ORDER BY odleglosc DESC LIMIT 1))))), -1), 357)

SELECT ST_Area(ST_BUFFER(ST_MakeLine((SELECT points.geom FROM (SELECT (ST_DumpPoints(lakes.geom)).* FROM lakes) as points, lakes, airports WHERE ST_Distance(points.geom, airports.geom) IN (SELECT ST_Distance(points.geom, airports.geom) as odleglosc_od_lot FROM (SELECT (ST_DumpPoints(lakes.geom)).* FROM lakes) as points, airports, lakes WHERE airports.name = 'AMBLER' AND lakes.names = 'Iliamna Lake' ORDER BY odleglosc_od_lot ASC LIMIT 1) AND airports.name = 'AMBLER' AND lakes.names = 'Iliamna Lake'), (SELECT geom FROM airports WHERE name = 'AMBLER')), 1000))

SELECT sum(ST_Area(trees.geom)) FROM trees JOIN swamp ON ST_CONTAINS(ST_SetSRID(trees.geom, -1), ST_SetSRID(swamp.geom, -1)) JOIN tundra ON ST_CONTAINS(ST_SetSRID(trees.geom, -1), ST_SetSRID(tundra.geom, -1))
*/

