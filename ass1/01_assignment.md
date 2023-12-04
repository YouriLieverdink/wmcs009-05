# Task 1.1

### Raw

| Orders        |              |                                                                                                                                                                                             |
| ---------- | ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **CustomerId** | CustomerName | Orders                                                                                                                                                                                      |
| C001       | John Doe     | OrderID: 0001, BookTitles: [Database Fundamentals, Advanced SQL], Prices: [45.00, 60.00], OrderDate: 2023-04-10, DeliveryAddress: 123 Elm St, DeliveryCity: Springfield, DeliveryZip: 12345 |
| C002       | Jane Smith   | OrderID: 0002, BookTitles: [Advanced SQL, The Relational Model], Prices: [60.00, 40.00], OrderDate: 2023-04-11, DeliveryAddress: 456 Oak Ave, DeliveryCity: Springfield, DeliveryZip: 12345 |
| C003       | Emily Clark  | OrderID: 0003, BookTitles: [Database Fundamentals], Prices: [45.00], OrderDate: 2023-04-12, DeliveryAddress: 789 Pine Rd, DeliveryCity: Riverside, DeliveryZip: 67890                       | 

### 1NF

There is only one violation in the raw data, that is the repeating booktitles in the "Orders" column. To overcome this, we create a separate row for every booktitle.

| Orders        |         |                       |              |           |            |                 |              |             |
| ---------- | ------- | --------------------- | ------------ | --------- | ---------- | --------------- | ------------ | ----------- |
| **CustomerId** | **OrderId** | **BookTitle**             | CustomerName | BookPrice | OrderDate  | DeliveryAddress | DeliveryCity | DeliveryZip |
| C001       | O001    | Database Fundamentals | John Doe     | 45        | 2023-04-10 | 123 Elm St      | Springfield  | 12345       |
| C001       | O001    | Advanced SQL          | John Doe     | 60        | 2023-04-10 | 123 Elm St      | Springfield  | 12345       |
| C002       | O002    | Advanced SQL          | Jane Smith   | 60        | 2023-04-11 | 456 Oak Ave     | Springfield  | 12345       |
| C002       | O002    | The Relational Model  | Jane Smith   | 40        | 2023-04-11 | 456 Oak Ave     | Springfield  | 12345       |
| C003       | O003    | Database Fundamentals | Emily Clark  | 45        | 2023-04-12 | 789 Pine Rd     | Riverside    | 67890       |

### 2NF

The rules of 2NF state that every non-key attribute must depend on the entire primary key. Since "CustomerName" only depends on "CustomerId" we extract it to a separate table. This is also the case for "BookPrice", which only depends on "BookTitle".

| Customers        |              |
| ---------- | ------------ |
| **CustomerId** | CustomerName |
| C001       | John Doe     |
| C002       | Jane Smith   |
| C003       | Emily Clark  |

| Books                 |           |
| --------------------- | --------- |
| BookTitle             | BookPrice |
| Database Fundamentals | 45        |
| Advanced SQL          | 60        |
| The Relational Model  | 40        |

| Orders  |            |                       |            |                 |              |             |
| ------- | ---------- | --------------------- | ---------- | --------------- | ------------ | ----------- |
| **OrderId** | **CustomerId** | **BookTitle**             | OrderDate  | DeliveryAddress | DeliveryCity | DeliveryZip |
| O001    | C001       | Database Fundamentals | 2023-04-10 | 123 Elm St      | Springfield  | 12345       |
| O001    | C001       | Advanced SQL          | 2023-04-10 | 123 Elm St      | Springfield  | 12345       |
| O002    | C002       | Advanced SQL          | 2023-04-11 | 456 Oak Ave     | Springfield  | 12345       |
| O002    | C002       | The Relational Model  | 2023-04-11 | 456 Oak Ave     | Springfield  | 12345       |
| O003    | C003       | Database Fundamentals | 2023-04-12 | 789 Pine Rd     | Riverside    | 67890       |

### 3NF

In order to convert to 3NF, we need to remove all transitive dependencies. Currently, there is only one. That is the delivery address, city, and zipcode.

| Customers  |              |
| ---------- | ------------ |
| CustomerId | CustomerName |
| C001       | John Doe     |
| C002       | Jane Smith   |
| C003       | Emily Clark  |

| Books                 |           |
| --------------------- | --------- |
| **BookTitle**             | BookPrice |
| Database Fundamentals | 45        |
| Advanced SQL          | 60        |
| The Relational Model  | 40        |

| Addresses       |              |             |
| --------------- | ------------ | ----------- |
| **DeliveryAddress** | DeliveryCity | DeliveryZip |
| 123 Elm St      | Springfield  | 12345       |
| 456 Oak Ave     | Springfield  | 12345       |
| 789 Pine Rd     | Riverside    | 67890       |

| Orders  |            |                       |            |                 |
| ------- | ---------- | --------------------- | ---------- | --------------- |
| **OrderId** | **CustomerId** | **BookTitle**             | OrderDate  | DeliveryAddress |
| O001    | C001       | Database Fundamentals | 2023-04-10 | 123 Elm St      |
| O001    | C001       | Advanced SQL          | 2023-04-10 | 123 Elm St      |
| O002    | C002       | Advanced SQL          | 2023-04-11 | 456 Oak Ave     |
| O002    | C002       | The Relational Model  | 2023-04-11 | 456 Oak Ave     |
| O003    | C003       | Database Fundamentals | 2023-04-12 | 789 Pine Rd     |

# Task 1.2

TODO

# Task 2.1

### Log changes made to critical fields

```sql
CREATE TRIGGER log_customers_changes
AFTER UPDATE ON Customers
FOR EACH ROW
BEGIN
  IF OLD.CustomerName <> NEW.CustomerName THEN
    INSERT INTO CustomersChangesLog (CustomerId, OldCustomerName, NewCustomerName, Timestamp)
    VALUES (NEW.CustomerId, OLD.CustomerName, NEW.CustomerName, NOW());
  END IF;
END;

CREATE TRIGGER log_books_changes
AFTER UPDATE ON Books
FOR EACH ROW
BEGIN
  IF OLD.BookPrice <> NEW.BookPrice THEN
    INSERT INTO BooksChangesLog (BookTitle, OldBookPrice, NewBookPrice, Timestamp)
    VALUES (NEW.BookTitle, OLD.BookPrice, NEW.BookPrice, NOW());
  END IF;
END;

CREATE TRIGGER log_orders_changes
AFTER UPDATE ON Orders
FOR EACH ROW
BEGIN
  IF OLD.DeliveryAddress <> NEW.DeliveryAddress THEN
    INSERT INTO OrdersChangesLog (OrderId, OldDeliveryAddress, NewDeliveryAddress, Timestamp)
    VALUES (NEW.OrderId, OLD.DeliveryAddress, NEW.DeliveryAddress, NOW())
  END IF;
END;
```

### Prevent deletion of records that are referenced by other tables

```sql
CREATE TRIGGER preventCustomerDelete
BEFORE DELETE ON Customers
FOR EACH ROW
BEGIN
  IF EXISTS(
    SELECT * FROM Orders
    WHERE CustomerId = OLD.CustomerId
  ) THEN
    SIGNAL SQLSTATE = '23511'
    SET MESSAGE_TEXT = 'Cannot delete customer with existing orders';
  END IF;
END;

CREATE TRIGGER preventBookDelete
BEFORE DELETE ON Books
FOR EACH ROW
BEGIN
  IF EXISTS(
    SELECT * FROM Orders
    WHERE BookTitle = OLD.BookTitle
  ) THEN
    SIGNAL SQLSTATE = '23511'
    SET MESSAGE_TEXT = 'Cannot delete book with existing orders';
  END IF;
END;

CREATE TRIGGER preventAddressDelete
BEFORE DELETE ON Addresses
FOR EACH ROW
BEGIN
  IF EXISTS(
    SELECT * FROM Orders
    WHERE DeliveryAddress = OLD.DeliveryAddress
  ) THEN
    SIGNAL SQLSTATE = '23511'
    SET MESSAGE_TEXT = 'Cannot delete delivery address with existing orders';
  END IF;
END;
```

### Automatically update reports in "MonthlySalesReport"

```sql

CREATE TRIGGER setMonthlySalesReport
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
		INSERT INTO MonthlySalesReport (Month, BookTitle, Sales)
		SELECT
      EXTRACT(MONTH FROM Orders.OrderDate) AS Month,
      Books.BookTitle,
      SUM(Books.BookPrice) as Sales
    FROM 
      Orders
    JOIN
      Books ON Orders.BookTitle = Books.BookTitle
    WHERE
      Books.BookTitle = NEW.BookTitle
    GROUP BY
      EXTRACT(MONTH FROM Orders.OrderDate),
      Books.BookTitle
		ON DUPLICATE KEY UPDATE
        Sales = VALUES(Sales);
END;
```

### Task 2.2

TODO

### Task 3.1

```sql
CREATE FUNCTION calculate_total_order_value (CustomerId VARCHAR(255))
RETURNS INTEGER DETERMINISTIC
BEGIN
	DECLARE total_value INTEGER DEFAULT 0;
  
  SELECT SUM(Books.BookPrice)
  INTO total_value
  FROM Orders
  JOIN Books 
  ON Orders.BookTitle = Books.BookTitle
  WHERE Orders.CustomerId = CustomerId;  	
   
  RETURN total_value;
END;

CREATE FUNCTION list_unique_books()
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
    DECLARE unique_books VARCHAR(255) DEFAULT '';
    
    SET @books = '';
    SELECT
        MAX(
          @books := IF(
            LOCATE(BookTitle, @books) = 0,
            CONCAT_WS(' ', @books, BookTitle),
            CONCAT(@books)
          ) 
        )
       as unique_books
    FROM Orders
		INTO unique_books;
    
	  RETURN unique_books;
END;

CREATE FUNCTION update_order_prices(Percentage DECIMAL(2, 1))
RETURNS INTEGER DETERMINISTIC
BEGIN
	UPDATE Books
  SET BookPrice = BookPrice * Percentage;
  
  RETURN 0;
END;
```

# Task 3.2

```sql
SELECT CustomerId, calculate_total_order_value(CustomerId)
FROM Customers;

SELECT list_unique_books();

SELECT update_order_prices(0.5);
```
