create database onlineBookstore;
use onlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID BIGINT UNSIGNED PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID BIGINT UNSIGNED PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID BIGINT UNSIGNED REFERENCES Customers(Customer_ID),
    Book_ID BIGINT UNSIGNED REFERENCES books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

select * from books;
select * from customers;
select * from orders;

-- 1) Retrieve all books in the "Fiction" genre:
select * from books;

select * from books
where Genre = 'Fiction';

-- 2) Find books published after the year 1950:
select * from books
where Published_Year > 1950;

-- 3) List all customers from the Canada:
select * from customers;

select Customer_Id from customers
where Country = 'Canada';

-- 4) Show orders placed in November 2023:
select * from orders;

select * from orders
where Order_Date between '2023-11-01' and '2023-11-30';

-- 5) Retrieve the total stock of books available:
select * from books;

select sum(Stock) as total_books_available 
from books;

-- 6) Find the details of the most expensive book:
select * from books
order by Price Desc
limit 1;

SELECT max(Price) as expensive_book 
from books;

-- 7) Show all customers who ordered more than 1 quantity of a book:
select * from orders;

select * from orders
where Quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $20:
select * from orders
where Total_Amount > 20;

-- 9) List all genres available in the Books table:
select * from books;

select distinct(Genre) from books;

-- 10) Find the book with the lowest stock:
select * from books
order by Stock limit 10;

-- 11) Calculate the total revenue generated from all orders:
select * from orders;

select sum(Total_Amount) as revenue_generated
 from orders;
 
 -- 12) Retrieve the total number of books sold for each genre:
 select * from orders;
 
 select books.Genre, sum(orders.Quantity) as total_book_sold
 from orders join books on orders.Book_ID = books.Book_ID
 group by books.Genre;
 
 -- 13) Find the average price of books in the "Fantasy" genre:
select * from books;

select avg(Price) as avg_price
from books where Genre = 'Fantasy';

-- 14) List customers who have placed at least 2 orders:
select * from customers;
select * from orders;

select customers.Customer_ID, customers.Name, count(orders.Order_Id) as order_count
from orders join customers on customers.Customer_ID = orders.Customer_ID
group by orders.Customer_ID, customers.Name
having count(Order_Id) > 2;

-- 15) Find the most frequently ordered book:
select * from orders;

select books.Title, orders.Book_ID, count(orders.Order_Id) as most_ordered_book
from orders join books on orders.Book_ID = books.Book_ID
group by orders.Book_ID, books.Title
order by most_ordered_book desc limit 10;


-- 16) Show the top 3 most expensive books of 'Fantasy' Genre :
select * from books;

select books.Price, books.Title
from books where Genre = 'Fantasy'
order by Price Desc limit 3;

-- 17) Retrieve the total quantity of books sold by each author:
select * from books;
select * from orders;

select books.Author, sum(orders.Quantity) as total_Quantity
from orders join books on orders.Book_ID = books.Book_ID
group by books.Author order by total_Quantity Desc;

-- 18) List the cities where customers who spent over $30 are located:
select * from customers;
select * from orders;

select customers.City, orders.Total_Amount
from orders
join customers on orders.Customer_ID = customers.Customer_ID
where Total_Amount > 30;

-- 19) Find the customer who spent the most on orders:
select * from customers;
select * from orders;

select customers.Customer_ID, customers.Name, sum(Orders.Total_Amount) as total_spent
from orders
join customers on orders.Customer_ID = customers.Customer_ID
group by customers.Customer_ID, customers.Name order by total_spent Desc;

-- 20) Calculate the stock remaining after fulfilling all orders:
select * from orders;
select * from books;

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;