--------------------------------------------------------------------------------------
--1. Get customers full_name who has rented most movies in 2005
--------------------------------------------------------------------------------------

---------Tables---------

select * from customer
select * from rental

---------View all customers and their rentals made in 2005---------

SELECT                 --Specifies which data is retrieve
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    r.rental_id, 
    r.rental_date
FROM                  --Specifies the base table (customer) from which data is retrieved
    customer c
JOIN                  --The rental table is being joined to the customer table using the customer_id as the common column
    rental r 
    ON c.customer_id = r.customer_id
WHERE                 --Filtering only rentals that took place in 2005
    EXTRACT(YEAR FROM r.rental_date) = 2005;


----------Count the number of rentals per customer and sort----------
 
SELECT                                   
    c.customer_id, 
    c.first_name, 
    c.last_name,  
    COUNT(r.rental_id) AS rental_count        --Counts the number of rental transactions per customer. Each rental is identified by its rental_id
FROM                     
    customer c
JOIN                  
    rental r 
    ON c.customer_id = r.customer_id
WHERE 
    EXTRACT(YEAR FROM r.rental_date) = 2005
GROUP BY                                      --Groups by customer ID to count rentals per customer
    c.customer_id, c.first_name, c.last_name  --Groups by first and last names to include the full name in the result
ORDER BY 
    rental_count DESC;                        --Descending order of rental_count

---------Limit the results to the top customer---------

SELECT 
    c.first_name || ' ' || c.last_name AS full_name, 
    COUNT(r.rental_id) AS rental_count
FROM 
    customer c
JOIN 
    rental r 
    ON c.customer_id = r.customer_id
WHERE 
    EXTRACT(YEAR FROM r.rental_date) = 2005
GROUP BY 
    c.customer_id, c.first_name, c.last_name
ORDER BY 
    rental_count DESC
LIMIT 1;                                     

--------------------------------------------------------------------------------------
--2. Get top 3 actors who have been involved in most movies
--------------------------------------------------------------------------------------

---------Tables---------

select * from actor 
select * from film_actor
select * from film

---------Join tables--------

SELECT 
    a.actor_id, 
    a.first_name, 
    a.last_name, 
    f.film_id, 
    f.title
FROM 
    actor a
JOIN                                     --Inner join between the actor table and the film_actor table based on actor_id
    film_actor fa ON a.actor_id = fa.actor_id
JOIN                                     --Inner join between the result of the previous join and the film table based on film_id
    film f ON fa.film_id = f.film_id;

---------Count number of movies per actor and limit to 3---------

SELECT 
    a.actor_id, 
    a.first_name, 
    a.last_name, 
    COUNT(fa.film_id) AS movie_count     --Counts the number of rows in the film_actor table where actor_id matches, representing the number of films the actor has appeared in
FROM 
    actor a
JOIN 
    film_actor fa ON a.actor_id = fa.actor_id
GROUP BY 
    a.actor_id, a.first_name, a.last_name
ORDER BY 
    movie_count DESC
LIMIT 3;

--------------------------------------------------------------------------------------
--3. Get the movie which has been the most profitable
--------------------------------------------------------------------------------------

-----------Tables---------

select * from film
select * from inventory
select * from rental
select * from payment

---------Join tables--------

SELECT
    f.title,
    i.inventory_id,
    r.rental_id,
    p.amount
FROM               
    film f
JOIN                             --This joins the film table (f) with the inventory table (i) based on the condition film_id 
    inventory i ON f.film_id = i.film_id
JOIN                             --This joins the result from the previous join with the rental table (r) based on the condition inventory_id 
    rental r ON i.inventory_id = r.inventory_id
JOIN                             --This joins the result from the previous join with the payment table (p) based on the condition rental_id
    payment p ON r.rental_id = p.rental_id;


---------Most profitable movies---------

SELECT
    f.title,
    SUM(p.amount) AS total_revenue
FROM
    film f
JOIN
    inventory i ON f.film_id = i.film_id
JOIN
    rental r ON i.inventory_id = r.inventory_id
JOIN
    payment p ON r.rental_id = p.rental_id
GROUP BY                          --Group by f.film_id and f.title to ensure that the earnings are aggregated by film
    f.film_id, f.title
ORDER BY                    
    total_revenue DESC
LIMIT 5;
