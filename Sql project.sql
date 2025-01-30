create database onlineretail;
use onlineretail;
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50), 
    Email VARCHAR(100),
    Phone VARCHAR(50),
    Address VARCHAR(255),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(50),
    Country VARCHAR(50),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE Products (
	ProductID INT PRIMARY KEY AUTO_INCREMENT,
	ProductName VARCHAR(100),
	CategoryID INT,
	Price DECIMAL(10,2),
	Stock INT,
	CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Categories (
	CategoryID INT PRIMARY KEY AUTO_INCREMENT,
	CategoryName VARCHAR(100),
	Description VARCHAR(255)

);
ALTER TABLE orderitems DROP FOREIGN KEY orderitems_ibfk_2;
ALTER TABLE orders CHANGE CustomerId CustomerID int;
ALTER TABLE orderitems ADD CONSTRAINT orderitems_ibfk_2 FOREIGN KEY (OrderID) REFERENCES orders(OrderID);




 

CREATE TABLE Orders (
	OrderId INT PRIMARY KEY AUTO_INCREMENT,
	CustomerId INT,
	OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
	TotalAmount DECIMAL(10,2),
	FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderItems (
	OrderItemID INT PRIMARY KEY AUTO_INCREMENT,
	OrderID INT,
	ProductID INT,
	Quantity INT,
	Price DECIMAL(10,2),
	FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
	FOREIGN KEY (OrderId) REFERENCES Orders(OrderID)
);
INSERT INTO Categories (CategoryName, Description) 
VALUES 
('Electronics', 'Devices and Gadgets'),
('Clothing', 'Apparel and Accessories'),
('Books', 'Printed and Electronic Books'),
('perfume', 'fogg and dior and vluekenam');

INSERT INTO Products(ProductName, CategoryID, Price, Stock)
VALUES 
('Smartphone', 1, 699.99, 50),
('Laptop', 1, 999.99, 30),
('T-shirt', 2, 19.99, 100),
('Jeans', 2, 49.99, 60),
('Fiction Novel', 3, 14.99, 200),
('Science Journal', 3, 29.99, 150),
('impressio' ,4, 500.00, 50);

INSERT INTO Customers(FirstName, LastName, Email, Phone, Address, City, State, ZipCode, Country)
VALUES 
('Sameer', 'Khanna', 'sameer.khanna@example.com', '123-456-7890', '123 Elm St.', 'Springfield', 
'IL', '62701', 'USA'),
('Jane', 'Smith', 'jane.smith@example.com', '234-567-8901', '456 Oak St.', 'Madison', 
'WI', '53703', 'USA'),
('harshad', 'patel', 'harshad.patel@example.com', '345-678-9012', '789 Dalal St.', 'Mumbai', 
'Maharashtra', '41520', 'INDIA');
INSERT INTO Orders(CustomerId, OrderDate, TotalAmount)
VALUES 
(1, CURRENT_TIMESTAMP(), 719.98),
(2, CURRENT_TIMESTAMP(), 49.99),
(3, CURRENT_TIMESTAMP(), 44.98);

INSERT INTO OrderItems(OrderID, ProductID, Quantity, Price)
VALUES 
(1, 1, 1, 699.99),
(1, 3, 1, 19.99),
(2, 4, 1,  49.99),
(3, 5, 1, 14.99),
(3, 6, 1, 29.99);


show databases;
use  onlineretail;
show tables ;
select* from customers;

-- Query 1: Retrieve all orders for a specific customer

SELECT o.OrderID, o.OrderDate, o.TotalAmount, oi.ProductID, p.ProductName, oi.Quantity, oi.Price
FROM Orders o
join OrderItems oi ON o.OrderID = oi. OrderID
join Products p ON oi.ProductID = p.ProductID 
where o.CustomerID = 2;

SELECT o.OrderID, o.OrderDate, o.TotalAmount, oi.ProductID, p.ProductName, oi.Quantity, oi.Price
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Products p ON oi.ProductID = p.ProductID
WHERE o.CustomerID = 3;


-- Query 2: Find the total sales for each product
select p.ProductID, p.ProductName, sum(oi.Quantity * oi.Price) AS TotalSales
from orderItems oi 
join products p
On oi.ProductID = p.ProductID
group by p.ProductID, p.ProductID;

-- Query 3: Calculate the average order value
select avg(TotalAmount) AS AverageOrderValue from orders;

-- Query 4: List the top 3 customers by total spending
select c.CustomerID, c.FirstName, c.LastName, SUM(o.TotalAmount) AS TotalSpent,
ROW_NUMBER() OVER (ORDER BY SUM(o.TotalAmount) DESC) AS rn
FROM Customers c
JOIN Orders o
ON c.CustomerID = o.CustomerId
GROUP BY c.FirstName,c.CustomerID,  c.LastName
limit 3;
-- Query 5: Retrieve the most popular product category
SELECT CategoryID, CategoryName, TotalQuantitySold, rn
FROM (
SELECT c.CategoryID, c.CategoryName, SUM(oi.Quantity) AS TotalQuantitySold,
ROW_NUMBER() OVER (ORDER BY SUM(oi.Quantity) DESC) AS rn
FROM OrderItems oi
JOIN Products p 
ON oi.ProductID = p.ProductID
JOIN Categories c
ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryID, c.CategoryName) sub
WHERE rn = 1;


----- to insert a product with zero stock
INSERT INTO Products(ProductName, CategoryID, Price, Stock)
VALUES ('Keyboard', 1, 39.99, 0);


-- --Query 7: Find customers who placed orders in the last 30 days
SELECT c.CustomerID, c.FirstName, c.LastName, c.Email, c.Phone 
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID 
WHERE o.OrderDate >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);


-- --Query 8: Calculate the total number of orders placed each month
SELECT YEAR(OrderDate) as OrderYear,
MONTH(OrderDate) as OrderMonth,
COUNT(OrderID) as TotalOrders
FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY OrderYear, OrderMonth;

-- Query 9: Retrieve the details of the most recent order
SELECT   o.OrderID, o.OrderDate, o.TotalAmount, c.FirstName, c.LastName
FROM Orders o JOIN Customers c
ON o.CustomerID = c.CustomerID
ORDER BY o.OrderDate DESC
limit 1 ;

-- --Query 10: Find the average price of products in each category
SELECT c.CategoryID, c.CategoryName, AVG(p.Price) as AveragePrice 
FROM Categories c JOIN Products p
ON c.CategoryID = p.ProductID
GROUP BY c.CategoryID, c.CategoryName;

-- --Query 11: List customers who have never placed an order
SELECT c.CustomerID, c.FirstName, c.LastName, c.Email, c.Phone, O.OrderID, o.TotalAmount
FROM Customers c LEFT OUTER JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE o.OrderId IS NULL;

-- Query 12: Retrieve the total quantity sold for each product
SELECT p.ProductID, p.ProductName, SUM(oi.Quantity) AS TotalQuantitySold
FROM OrderItems oi JOIN Products p
ON oi.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY p.ProductName;

-- --Query 13: Calculate the total revenue generated from each category
SELECT c.CategoryID, c.CategoryName, SUM(oi.Quantity * oi.Price) AS TotalRevenue
FROM OrderItems oi JOIN Products p
ON oi.ProductID = p.ProductID
JOIN Categories c
ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY TotalRevenue DESC;

-- --Query 14: Find the highest-priced product in each category
SELECT c.CategoryID, c.CategoryName, p1.ProductID, p1.ProductName, p1.Price
FROM Categories c JOIN Products p1
ON c.CategoryID = p1.CategoryID
WHERE p1.Price = (SELECT Max(Price) FROM Products p2 WHERE p2.CategoryID = p1.CategoryID)
ORDER BY p1.Price DESC;

-- --Query 15: Retrieve orders with a total amount greater than a specific value (e.g., $500)
SELECT o.OrderID, c.CustomerID, c.FirstName, c.LastName, o.TotalAmount
FROM Orders o JOIN Customers c
ON o.CustomerID = c.CustomerID
WHERE o.TotalAmount >= 49.99
ORDER BY o.TotalAmount DESC;

-- --Query 16: List products along with the number of orders they appear in
SELECT p.ProductID, p.ProductName, COUNT(oi.OrderID) as OrderCount
FROM Products p JOIN OrderItems oi
ON p.ProductID = oi.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY OrderCount DESC;

-- Query 17: Find the top 3 most frequently ordered products
SELECT  p.ProductID, p.ProductName, COUNT(oi.OrderID) AS OrderCount
FROM OrderItems oi JOIN  Products p
ON oi.ProductID = p.ProductID
GROUP BY  p.ProductID, p.ProductName
ORDER BY OrderCount DESC
limit 3;

-- Query 18: Calculate the total number of customers from each country
SELECT Country, COUNT(CustomerID) AS TotalCustomers
FROM Customers GROUP BY Country ORDER BY TotalCustomers DESC;

-- --Query 19: Retrieve the list of customers along with their total spending
SELECT c.CustomerID, c.FirstName, c.LastName, SUM(o.TotalAmount) AS TotalSpending
FROM Customers c JOIN Orders o 
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName;


-- --Query 20: List orders with more than a specified number of items (e.g., 5 items)
SELECT o.OrderID, c.CustomerID, c.FirstName, c.LastName, COUNT(oi.OrderItemID) AS NumberOfItems
FROM Orders o JOIN OrderItems oi
ON o.OrderID = oi.OrderID
JOIN Customers c 
ON o.CustomerID = c.CustomerID
GROUP BY o.OrderID, c.CustomerID, c.FirstName, c.LastName
HAVING COUNT(oi.OrderItemID) >= 1
ORDER BY NumberOfItems;
