

DROP TABLE IF EXISTS books;
CREATE TABLE books(
	Book_ID SERIAL PRIMARY KEY,
	Title VARCHAR(100),
	Author VARCHAR(100),
	Genre VARCHAR(50),
	Published_Year INT,
	Price NUMERIC(10,2),
	Stock INT

);

DROP TABLE IF EXISTS customers;
CREATE TABLE customers(
	Customer_ID SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(100),
	Phone VARCHAR(15),
	City VARCHAR(50),
	Country VARCHAR(150)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders(
	Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES customers(Customer_ID),
	Book_ID INT REFERENCES books(Book_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10,2)

);

SELECT * FROM books;
SELECT * FROM customers;
SELECT * FROM orders;


--retrive all books in the fiction genre
SELECT * FROM books
WHERE Genre = 'Fiction';

--find books published after year 1950
SELECT * FROM books 
WHERE Published_Year > 1950;

--list all customers from the canada
SELECT * FROM customers
WHERE Country ='Canada';

--show orders placed in november 2023
SELECT * FROM orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

--retrive the total stock of books available

SELECT SUM(Stock) AS total_stock
FROM books;

--find the details of the most expensive book
SELECT * FROM books ORDER BY Price DESC LIMIT 1;


--show all customers who ordered more than one quantity of book
SELECT * FROM orders 
WHERE quantity >1;


--retrive all orders where total amount exceeds $20
SELECT * FROM orders 
WHERE Total_Amount>20;
--list all generes available in the book table
SELECT DISTINCT Genre FROM books ;

--find the book with the lowest stock
SELECT * FROM books ORDER BY Stock ASC LIMIT 1;

--calculate the total revenue generated from all orders
SELECT SUM(Total_Amount)
FROM orders ;


--retrive the total number of books sold for each genere
SELECT b.Genre,SUM(o.Quantity) AS total_quantity_sold
FROM orders o
JOIN books b ON o.Book_ID=b.Book_ID
GROUP BY b.Genre;

--find the average price of books in the fantasy genere
SELECT AVG(Price) AS avg_price_fantasy
FROM books
WHERE Genre='Fantasy';

--list customers who have placed atleast two orders
SELECT o.Customer_ID,c.Name,COUNT(o.Order_ID) AS order_count
FROM orders o
JOIN customers c ON o.Customer_ID=c.Customer_ID
GROUP BY o.Customer_ID ,c.Name
HAVING COUNT(Order_ID)>= 2 ;

--find the most frequently ordered book
SELECT o.Book_ID,COUNT(o.Order_ID) AS order_count,
b.Title
FROM orders o
JOIN books b ON o.Book_ID=b.Book_ID
GROUP BY o.Book_ID ,b.Title
ORDER BY COUNT(o.Order_ID) DESC LIMIT 1;

--show the top 3 most expensive book of fantasy genere
SELECT Title,Genre,Price 
FROM books
WHERE genre='Fantasy'
ORDER BY Price DESC LIMIT 3;

--retrive the total quantity of books sold by each author
SELECT b.Author,SUM(o.Quantity) AS total_books_sold
FROM orders o
JOIN books b ON o.Book_ID=b.Book_ID
GROUP BY b.Author;

--list the cities where customers who spent over $30 are located
SELECT DISTINCT c.City,o.Total_Amount
FROM orders o
JOIN customers c ON o.Customer_ID=c.Customer_ID
WHERE Total_Amount >30;

--find the customer who spent the most on orders
SELECT c.Customer_ID,c.Name,SUM(o.Total_Amount) AS spent
FROM orders o
JOIN customers c ON o.Customer_ID=c.Customer_ID
GROUP BY c.Customer_ID,c.Name
ORDER BY SUM(o.Total_Amount) DESC LIMIT 1;

--calculate the stock remaining after fulfilling all orders
SELECT b.Book_ID,b.Title,b.Stock,
COALESCE(SUM(o.Quantity),0) AS order_quantity,
(b.Stock-COALESCE(SUM(o.Quantity),0)) AS stock_left
FROM books b
LEFT JOIN orders o ON o.Book_ID=b.Book_ID
GROUP BY b.Book_ID; 

