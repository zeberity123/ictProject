USE test;

CREATE TABLE user(
    user_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) DEFAULT NULL
);

CREATE TABLE addr(
    addr_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    addr VARCHAR(30) DEFAULT NULL,
    user_id INT(11),

    FOREIGN KEY(user_id) REFERENCES user(user_id)
);

INSERT INTO user(name)
VALUES ("AAA"),
       ("BBB"),
       ("CCC"),
       ("DDD"),
       ("EEE"),
       ("FFF"),
       ("GGG"),
       ("HHH"),
       ("III"),
       ("JJJ");

INSERT INTO addr(addr, user_id)
VALUES("서울", 1),
      ("광주", 2),
      ("전주", 2),
      ("대구", 3),
      ("부산", 4),
      ("대구", 7),
      ("제주", 5),
      ("인천", 6),
      ("서울", 6);
      
SELECT * FROM user;
SELECT * FROM addr;

-- JOIN
-- 1) CROSS JOIN (Cartesiamn JOIN)
SELECT *
FROM user
JOIN addr;

-- 2) Iner Join
SELECT *
FROM user
JOIN addr ON user.user_id = addr.user_id;


-- 3) Left Join
SELECT *
FROM user
LEFT JOIN addr ON user.user_id = addr.user_id;

-- 4) RIGHT JOIN
SELECT *
FROM user
RIGHT JOIN addr ON user.user_id = addr.user_id;

-- 5) FULL OUTER JOIN
SELECT *
FROM user
LEFT JOIN addr ON user.user_id = addr.user_id

UNION

SELECT *
FROM user
RIGHT JOIN addr ON user.user_id = addr.user_id;

-- country code, country name, city name
USE world;

SELECT
	  city.CountryCode,
	  city.name,
	  country.name
FROM city
JOIN country ON city.CountryCode = country.Code;

-- SUBQUERY
-- count(country), count(city), coung(lang)
-- result of subquery should be 1 data(1row, 1 column)
SELECT
	  (SELECT COUNT(*) FROM city) AS total_city_count,
	  (SELECT COUNT(*) FROM country) AS total_country_count,
	  (SELECT COUNT(*) FROM countrylanguage) AS total_language_count;
	  
-- count(city with 'k'), avg(gnp) of country with 'a'
SELECT
		(SELECT COUNT(*) FROM city WHERE name LIKE '%k%') AS city_cnt,
		(SELECT AVG(GNP) FROM country WHERE name LIKE '%a%') AS avg_gnp;
		
-- Subquery at FROM


-- country code of cities with 800m population, cityname, population, countryname
-- 1) without subquery
SELECT
		city.CountryCode,
		city.Name,
		city.Population,
		country.Name
FROM city
JOIN country ON city.CountryCode = country.Code
WHERE city.Population >= 8000000;

-- 2) with subquery at FROM
 -- 2-1) countrycode, name, population with population >= 800m
 
SELECT CountryCode, Name, Population
FROM city
WHERE population >= 8000000;


 -- 2-2) apply subquery with JOIN
SELECT
		city_sub.CountryCode,
		city_sub.Name,
		city_sub.Population,
		country.name
FROM
		(
				SELECT CountryCode, Name, Population
				FROM city
				WHERE population >= 8000000
		) AS city_sub
JOIN country ON city_sub.CountryCode = country.Code;

-- SubQuery at WHERE
-- SubQuery for 'IN' at WHERE
-- IN
SELECT *
FROM city
WHERE CountryCode = 'BRA' OR CountryCode = 'IDN';

SELECT *
FROM city
WHERE CountryCode IN ('BRA', 'IDN');


-- Subquery in IN
-- countries having city with avg(population) > 800m
SELECT *
FROM country
WHERE Code IN (
		SELECT DISTINCT(CountryCode)
		FROM city
		WHERE city.Population >= 8000000);








