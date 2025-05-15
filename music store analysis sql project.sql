--set3:

--Q3: Write a query that determines the customer that has spent the most on music for each country.
--Write a query that returns the country along with the top customer and how much they spent.
--For countries where the top amount spent is shared, provide all customers who spent this amount

WITH Customter_with_country AS (
SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
ROW_NUMBER ()OVER (PARTITION BY billing_country ORDER BY SUM(total) DESC) As RowNo
from invoice
join customer on customer.customer_id = invoice.customer_id
group by 1,2,3,4
order by 4 asc,5 desc)
SELECT*FROM Customter_with_country WHERE RowNo <=1

--Q2: Q2: We want to find out the most popular music Genre for each country.
--(We determine the most popular genre as the genre with the highest amount of purchases)

WITH popular_genre AS
(
SELECT COUNT(Invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id,
ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(Invoice_line.quantity) DESC) AS RowNo
FROM invoice_line
JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id 
JOIN customer ON customer.customer_id = invoice.customer_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN genre ON genre.genre_id = track.genre_id
GROUP BY 2,3,4
ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1

--Q1: Find how much amount spent by each customers on artists? Write a query to return customer name,
--artist name and total spent

WITH best_selling_artist as (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, 
	SUM(Invoice_Line.unit_price*invoice_line.quantity) AS total_sales 
	FROM Invoice_Line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)

SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name,
SUM (il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i. invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

--set2:

--Q3: Return all the track names that have a song length longer than the average song length. 
--Return the Name and Milliseconds for each track. Order by the song length with the longest songs
--Listed first.

SELECT name,milliseconds
FROM track
WHERE milliseconds > (
    SELECT AVG(milliseconds) AS avg_track_length
    FROM track)
ORDER BY milliseconds DESC;

--Q2: lets invite the artist who have written the most rock music in our dataset.
--write a query that returns the artist name and total track count of the top 10 rock bands

select artist.artist_id,artist.name,count(artist.artist_id) as number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id=track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;

--Q1: Write query to return the email, first name, last name, & Genre of all Rock Music Listeners.
--Return your list ordered alphabetically by email starting with A

SELECT DISTINCT email, first_name, last_name
FROM customer
join invoice ON customer.customer_id = invoice.customer_id
jOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
	SELECT track_id FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name LIKE 'Rock'
)
ORDER BY email;

--set1:

--Q5:  Who is the best customer? The customer who has spent the wust money will be declared the best customer
--Write a query that returns the person who has spent the most money.

select customer.customer_id, customer.first_name, customer.last_name, SUM(Invoice.total) as total
from customer
JOIN invoice ON customer.customer_id =  invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total DESC
limit 1

--Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city. 
--we made the most money. Write a query that returns one city that has the highest sum of invoice totals. 
--Return both the city name & sum of all invoice totals

select sum(total) as invoice_total,billing_city
from invoice
group by billing_city
order by invoice_total desc

--Q3: what are the top 3 values of total invoice 

select total from invoice
order by total desc 
limit 3

--Q2: which country have the most invoice

select count (*) as c,billing_country
from invoice
group by billing_country
order by c desc

--Q1: who is the senior most employee based on job title

select * from employee
order by levels desc
limit 1













