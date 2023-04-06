--// 1. List all customers who live in Texas (use JOINs)

SELECT first_name, last_name, address.district
FROM customer
RIGHT JOIN address
ON customer.address_id = address.address_id
WHERE district = 'Texas';

--// 2. Get all payments above $6.99 with the Customer's Full Name

SELECT amount, customer.first_name, customer.last_name
FROM payment
RIGHT JOIN customer
ON payment.customer_id = customer.customer_id
WHERE amount > 6.99;

--// 3. Show all customers names who have made payments over $175(use subqueries)

-- using RIGHT JOIN
SELECT amount, customer.first_name, customer.last_name
FROM payment
RIGHT JOIN customer
ON payment.customer_id = customer.customer_id
WHERE amount > 175;

-- using FROM clause sub query
SELECT first_name, last_name, amount
FROM (
    SELECT amount, customer.first_name, customer.last_name
    FROM payment
    RIGHT JOIN customer
    ON payment.customer_id = customer.customer_id
    WHERE amount > 175
) AS high_ballers
WHERE amount > 175;

--// 4. List all customers that live in Nepal (use the city table)

SELECT city, country, customer.first_name, customer.last_name, customer.customer_id
FROM city
INNER JOIN country
ON city.country_id = country.country_id
INNER JOIN address
ON city.city_id = address.city_id
INNER JOIN customer
ON address.address_id = customer.address_id
WHERE country = 'Nepal';

SELECT city , country, customer.first_name, customer.last_name, customer.customer_id
FROM country
INNER JOIN city
ON country.country_id = city.country_id
INNER JOIN address
ON city.city_id = address.city_id
INNER JOIN customer
ON address.address_id = customer.address_id
WHERE country = 'Nepal';

--// 5. Which staff member had the most transactions?

-- simple solution
SELECT COUNT(payment_id) AS transactions, staff_id
FROM payment
GROUP BY staff_id

-- more specific solution, Staff member Jon Stephens made more transactions
SELECT COUNT(payment_id) AS transactions, staff.first_name, staff.last_name, staff.staff_id
FROM payment
RIGHT JOIN staff
ON payment.staff_id = staff.staff_id
GROUP BY staff.staff_id

--// 6. How many movies of each rating are there?

SELECT rating, count(title) AS num_of_films
FROM film
GROUP BY rating
ORDER BY count(DISTINCT title) DESC;

--// 7.Show all customers who have made a single payment above $6.99 (Use Subqueries)

-- get payment amounts above $6.99
SELECT customer_id
FROM payment
WHERE amount > 6.99

-- get customer info
SELECT first_name, last_name, customer_id
FROM customer

-- combine them with a sub query
SELECT first_name, last_name, customer_id
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM payment
    WHERE amount > 6.99
);

--// 8. How many free rentals did our stores give away?

-- sadly, no one got a free rental :(
-- This would be the simple solution, but it is boring
SELECT customer_id, amount
FROM payment
WHERE amount = 0

-- customer first/last name and the name of staff members that issued the free rentals
SELECT amount, customer.first_name AS cust_first, customer.last_name AS cust_last, payment.customer_id, staff.first_name AS staff_first, staff.last_name AS staff_last, staff.staff_id
FROM payment
RIGHT JOIN staff
ON payment.staff_id = staff.staff_id
RIGHT JOIN customer
ON payment.customer_id = customer.customer_id
WHERE amount = 0
