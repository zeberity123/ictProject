CREATE DATABASE test;
USE test;
CREATE TABLE user1(
    user_id INT,
    name VARCHAR(20),
    email VARCHAR(30),
    age INT(3),
    rdate DATE
);

CREATE TABLE user2(
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL,
    email VARCHAR(30) UNIQUE NOT NULL,
    age INT(3) DEFAULT 30,
    rdate TIMESTAMP
);

INSERT INTO user1(user_id, name, email, age, rdate)
VALUES(1, 'mhso1', 'mhso@naver.com', 34, '2021-11-16');
INSERT INTO user1(user_id, name, email, age, rdate)
VALUES (2, 'park', 'mhso@gmail.com', 34, '2021-11-13'),
       (3, 'minho', 'mino@daum.net', 28, '2021-11-15'),
       (4, 'jiwon', 'jwon@daum.net', 27, '2021-11-11'),
       (5, 'siyeon', 'syw@snu.ac.kr', 25, '2021-11-12'),
       (6, 'taehee', 'thk@naver.com', 22, '2021-11-17');
       
INSERT INTO user1(user_id, name)
VALUES(7, 'somino');
INSERT INTO user1
VALUES(8, 'haha', 'hohoho@naver.com', 38, now());

INSERT INTO user2(name, email)
VALUES('daru', 'daru@gmail.com');

INSERT INTO user2(name, email)
VALUES('zebe', 'daru@gmail.com');

INSERT INTO user2(name, email, age, rdate)
VALUES('asdf', 'asdf@gmail.com', 21, now());

SELECT * FROM user2;
--
SELECT name, email, rdate FROM user1;
SELECT email, name, rdate FROM user1;

SELECT name as 'NN',
	   email as 'mail'
FROM user1;
--
SELECT *
FROM user1
WHERE age >= 25;

--
SELECT *
FROM user1
WHERE rdate >= '2021-11-15';

-- AND
SELECT *
FROM user1
WHERE age >= 30
  AND rdate >= '2021-11-15';
  
SELECT name, age, email
FROM user1
WHERE rdate >= '2021-11-12' AND rdate <= '2021-11-15';

-- BETWEEN
SELECT name, age, email
FROM user1
WHERE rdate BETWEEN '2021-11-12' AND '2021-11-15';

SELECT name, age, email, rdate
FROM user1
WHERE age BETWEEN 20 AND 30
  AND rdate BETWEEN '2021-11-12' AND '2021-11-16';
  
-- SORTING
SELECT *
FROM user1
ORDER BY name DESC;

-- ageASC, rdateDESC
SELECT *
FROM user1
ORDER BY age, rdate DESC;

-- GROUP BY

USE world;

-- country code

SELECT CountryCode, COUNT(CountryCode) AS "CityCount"
FROM city
GROUP BY CountryCode;

-- SUM, AVG

SELECT CountryCode,
			 SUM(Population) AS 'PSUM',
			 AVG(Population) AS 'PAVG'
FROM city
GROUP BY CountryCode;

-- 10<X<20
SELECT CountryCode, COUNT(CountryCode) AS 'CityCount'
FROM city
WHERE Population BETWEEN 100000 AND 200000
GROUP BY CountryCode;

-- AVG, STD, MAX, MIN, DISCTRICT
-- DESC STD
SELECT
		District,
		AVG(Population) AS 'avg_pop',
		STD(Population) AS 'std_pop',
		MAX(Population) AS 'max_pop',
		MIN(Population) AS 'min_pop'
FROM city
WHERE Population BETWEEN 100000 AND 200000
GROUP BY District
ORDER BY std_pop DESC;

-- HAVING: condition
SELECT Countrycode,
			 SUM(Population) AS 'sum_pop'
FROM city
GROUP BY CountryCode
HAVING sum_pop >= 5000000
ORDER BY sum_pop DESC;

-- WHERE condition
-- LIKE : matching -> String
SELECT *
FROM city
WHERE CountryCode LIKE 'C%';

SELECT *
FROM city
WHERE countryCode LIKE 'K%R';

-- Code with k, pop >= 5000000 ASC
SELECT CountryCode,
			 SUM(Population) AS 'sum_pop'
FROM city
WHERE CountryCode LIKE '%K%'
GROUP BY CountryCode
HAVING sum_pop >= 1000000
ORDER BY sum_pop;

-- Country table
-- GNP != 0, pop != 0, continent pop AVG, GNP AVG
-- DESC BY POP avg
SELECT Continent,
			 ceiling(AVG(Population)) AS 'avg_pop',
			 ceiling(AVG(GNP)) AS 'avg_gnp'
FROM country
WHERE GNP != 0 AND Population != 0
GROUP BY continent
ORDER BY avg_pop DESC;

-- avgpop > 50, continent avg GNP
SELECT Continent,
			 CEILING(AVG(GNP)) AS 'avg_gnp'
FROM country
WHERE LifeExpectancy >= 50
GROUP BY Continent;

-- Available functions with SELECT
-- 1) DISTINCT
SELECT DISTINCT(CountryCode)
FROM city;

-- Remove duplicates using GROUP BY
SELECT CountryCode
FROM city
GROUP BY CountryCode;

-- Counting n of Country code
SELECT COUNT(DISTINCT(CountryCode))
FROM city;

-- 2) CEIL, ROUND, TRUNCATE
SELECT CEIL(12.345);

-- ROUND
SELECT ROUND(12.345, 2);
SELECT ROUND(12.341, 2);

-- TRUNCATE
SELECT TRUNCATE(12.345, 2);

-- 3) CONDITION
-- IF(CONDITION, T expr, F expr)
SELECT if(10<11, 'A', 'B');

-- if pop>100m, 'big city', else 'small city'
-- alias -> 'city scale'
SELECT
		NAME,
		population,
		if(Population >= 1000000, 'big city', 'small city') AS 'city scale'
FROM city;

-- .5m pop = medium city
SELECT
		NAME,
		population,
		if(Population >= 1000000,
			'big city',
			 if(Population >= 500000, 'medium city', 'small city')) AS 'city scale'
FROM city;

-- IFNULL : 
SELECT NAME, IndepYear, IFNULL(IndepYear, 'NA') AS Indep
FROM country;

-- CASE WHEN THEN
SELECT
		Population,
		CASE
				WHEN Population >= 10000000 THEN 'big'
				WHEN Population >= 5000000  THEN 'Medium'
				ELSE 'small'
		END AS 'result'
FROM country
WHERE IndepYear IS NOT NULL;


-- ----------------------

USE sakila;
SELECT * FROM payment;

-- Date_format
SELECT payment_date,
			 DATE_FORMAT(payment_date, '%Y') AS YEAR,
			 DATE_FORMAT(payment_date, '%m') AS MONTH,
			 DATE_FORMAT(payment_date, '%d') AS DAY,
			 DATE_FORMAT(payment_date, '%yy %mm %dd') AS 'YEAR_MONTH_DAY'
			 
FROM payment;

-- payment_date yearly avg amout
SELECT DATE_FORMAT(payment_date, '%Y') AS YEAR,
			 AVG(amount)
FROM payment
GROUP BY YEAR
ORDER BY YEAR;

-- y m --
-- ex)2005-1
SELECT DATE_FORMAT(payment_date, '%Y-%m') AS YEAR_MONTHLY,
			 AVG(amount)
FROM payment
GROUP BY YEAR_MONTHLY
ORDER BY YEAR_MONTHLY;

