/*
CREATE TABLE obiekty (nazwa VARCHAR(30), geom GEOMETRY);

INSERT INTO obiekty VALUES ('obiekt1', ST_GeomFromText('GEOMETRYCOLLECTION(LINESTRING(0 1, 1 1), CIRCULARSTRING(1 1, 2 0, 3 1, 4 2, 5 1), LINESTRING(5 1, 6 1))', -1));

INSERT INTO obiekty VALUES ('obiekt_kolej', ST_GeomFromEWKT('SRID=-1;MULTICURVE((10 6, 14 6), CIRCULARSTRING(14 6, 16 4, 14 2), CIRCULARSTRING(14 2, 12 0, 10 2), (10 2, 10 6))'));

INSERT INTO obiekty VALUES ('obiekt2', ST_GeomFromText('GEOMETRYCOLLECTION(MULTICURVE(LINESTRING(10 6, 14 6), CIRCULARSTRING(14 6, 16 4, 14 2), CIRCULARSTRING(14 2, 12 0, 10 2), LINESTRING(10 2, 10 6)),
													  MULTICURVE(CIRCULARSTRING(13 2, 12 1, 11 2), CIRCULARSTRING(11 2, 12 3, 13 2)))', -1));
INSERT INTO obiekty VALUES ('obiekt3', ST_GeomFromText('MULTILINESTRING((7 15, 10 17), (10 17, 12 13), (12 13, 7 15))', -1));

INSERT INTO obiekty VALUES ('obiekt4', ST_GeomFromText('MULTILINESTRING((20 20, 25 25), (25 25, 27 24), (27 24, 25 22), (25 22, 26 21), (26 21, 22 19), (22 19, 20.5 19.5))', -1));

INSERT INTO obiekty VALUES ('obiekt5', ST_GeomFromEWKT('SRID=-1;MULTIPOINT(30 30 59, 38 32 234)'));

INSERT INTO obiekty VALUES ('obiekt6', ST_GeomFromText('GEOMETRYCOLLECTION(LINESTRING(1 1, 3 2), POINT(4 2))', -1));

SELECT DISTINCT ST_Area(ST_BUFFER(ST_ShortestLine((SELECT geom FROM obiekty WHERE nazwa = 'obiekt3'), (SELECT geom FROM obiekty WHERE nazwa = 'obiekt4')), 5)) FROM obiekty;

SELECT ST_MakePolygon(ST_MakeLine((SELECT ST_LineMerge(geom) FROM obiekty WHERE nazwa = 'obiekt4'), ST_MakeLine(ST_GeomFromText('POINT(20.5 19.5)', -1), ST_GeomFromText('POINT(20 20)', -1))));

INSERT INTO obiekty VALUES ('obiekt7', ST_Collect((SELECT geom FROM obiekty WHERE nazwa = 'obiekt3'), (SELECT geom FROM obiekty WHERE nazwa = 'obiekt4')))

SELECT nazwa, ST_Area(ST_BUFFER(geom, 5)) FROM obiekty WHERE ST_HasArc(geom) = 'False';
*/





						   