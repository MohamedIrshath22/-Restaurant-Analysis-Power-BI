CREATE TABLE average_ratings (
    restaurant_name VARCHAR(255),       
    locality VARCHAR(255),              
    restaurant_rating DECIMAL(3, 2)     
);
INSERT INTO average_ratings (restaurant_name, locality, restaurant_rating)
SELECT 
    restaurant_name, 
    locality, 
    AVG(aggregate_rating) AS restaurant_rating
FROM 
    restaurants
GROUP BY 
    restaurant_name, locality;

SELECT * FROM average_ratings;



CREATE TABLE competitor_avg_ratings (
    restaurant_name VARCHAR(255),
    locality VARCHAR(255),
    restaurant_rating DECIMAL(3, 2),
    competitor_avg_rating DECIMAL(3, 2),
    rating_difference DECIMAL(3, 2)
);

INSERT INTO competitor_avg_ratings (restaurant_name, locality, restaurant_rating, competitor_avg_rating, rating_difference)
WITH avg_ratings AS (
    -- Calculate the average rating for each restaurant
    SELECT 
        restaurant_name, 
        locality, 
        AVG(aggregate_rating) AS restaurant_rating
    FROM 
        restaurants
    GROUP BY 
        restaurant_name, locality
)

-- Now calculate the competitor average rating and insert into competitor_avg_ratings
SELECT 
    restaurant_name, 
    locality, 
    restaurant_rating,
    AVG(restaurant_rating) OVER (PARTITION BY locality) AS competitor_avg_rating,
    restaurant_rating - AVG(restaurant_rating) OVER (PARTITION BY locality) AS rating_difference
FROM 
    avg_ratings;

SELECT * FROM competitor_avg_ratings;
