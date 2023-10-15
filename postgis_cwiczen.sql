/*
CREATE DATABASE budynki;

CREATE EXTENSION postgis;

CREATE TABLE budynki(id INT, geometria GEOMETRY, nazwa VARCHAR(35));

CREATE TABLE drogi(id INT, geometria GEOMETRY, nazwa VARCHAR(45));

CREATE TABLE punkty_informacyjne(id INT, geometria GEOMETRY, nazwa VARCHAR(70));


INSERT INTO budynki VALUES (1, ST_GeomFromText('POLYGON((8 1.5, 8 4, 10.5 4, 10.5 1.5, 8 1.5))', -1), 'BuildingA');

INSERT INTO budynki VALUES (2, ST_GeomFromText('POLYGON((4 5, 4 7, 6 7, 6 5, 4 5))', -1), 'BuildingB');

INSERT INTO budynki VALUES (3, ST_GeomFromText('POLYGON((3 6, 3 8, 5 8, 5 6, 3 6))', -1), 'BuildingC');

INSERT INTO budynki VALUES (4, ST_GeomFromText('POLYGON((9 8, 9 9, 10 9, 10 8, 9 8))', -1), 'BuildingD');

INSERT INTO budynki VALUES (5, ST_GeomFromText('POLYGON((2 1, 1 1, 1 2, 2 2, 2 1))', -1), 'BuildingF');

INSERT INTO drogi VALUES (1, ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)', -1), 'RoadX');

INSERT INTO drogi VALUES (2, ST_GeomFromText('LINESTRING(7.5 0, 7.5 10.5)', -1), 'RoadY');

INSERT INTO punkty_informacyjne VALUES (1, ST_GeomFromText('POINT(6 9.5)', -1), 'K');

INSERT INTO punkty_informacyjne VALUES (2, ST_GeomFromText('POINT(6.5 6)', -1), 'J');

INSERT INTO punkty_informacyjne VALUES (3, ST_GeomFromText('POINT(9.5 6)', -1), 'I');

INSERT INTO punkty_informacyjne VALUES (4, ST_GeomFromText('POINT(1 3.5)', -1), 'G');

INSERT INTO punkty_informacyjne VALUES (5, ST_GeomFromText('POINT(5.5 2.5)', -1), 'H');

SELECT ST_Length(geometria) as Dlugosc_drogi FROM drogi

SELECT sum(ST_Length(geometria)) as Calkowita_dlugosc_drog FROM drogi

SELECT ST_AsText(geometria) as Zapis_wkt, ST_Area(geometria) as Powierzchnia_obiektu, ST_Length(ST_ExteriorRing(geometria)) as Obwod_poligonu FROM budynki WHERE nazwa = 'BuildingA'

SELECT nazwa, ST_Area(geometria) as Powierzchnia_poligonu FROM budynki ORDER BY nazwa ASC

SELECT nazwa, ST_LENGTH(ST_ExteriorRing(geometria)) as Obwod_budynku FROM budynki WHERE ST_Area(geometria) IN (SELECT ST_Area(geometria) FROM budynki ORDER BY ST_Area(geometria) DESC LIMIT 2)

SELECT ST_Distance((SELECT geometria FROM budynki WHERE nazwa = 'BuildingC'), (SELECT geometria FROM punkty_informacyjne WHERE nazwa = 'G')) as Odleglosc_budynku_od_punktu

SELECT (ST_Area((SELECT geometria FROM budynki WHERE nazwa = 'BuildingC')) - ST_Area(ST_Intersection((SELECT geometria FROM budynki WHERE nazwa = 'BuildingC'), ST_Buffer((SELECT geometria FROM budynki WHERE nazwa = 'BuildingB'), 0.5)))) as Powierzchnia_budynku_pozostala 

SELECT * FROM budynki WHERE ST_Y(ST_Centroid(geometria)) > ST_Y(ST_Centroid((SELECT geometria FROM drogi WHERE nazwa = 'RoadX')))

SELECT (ST_Area((SELECT geometria FROM budynki WHERE nazwa = 'BuildingC')) - ST_Area(ST_Intersection((SELECT geometria FROM budynki WHERE nazwa = 'BuildingC'), ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))', -1)))) as Powierzchnia_budynku_oddzielona, (ST_Area(ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))', -1)) - ST_Area(ST_Intersection((SELECT geometria FROM budynki WHERE nazwa = 'BuildingC'), ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))', -1)))) as Powierzchnia_poligonu_pod_odcieciu
*/