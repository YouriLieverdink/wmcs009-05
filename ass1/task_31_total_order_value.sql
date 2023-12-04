DROP FUNCTION IF EXISTS calculate_total_order_value;

-- Add function to calculate total value across all orders.
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

-- For example, select all users that have ordered for more than 120
SELECT CustomerId, calculate_total_order_value(CustomerId)
FROM Customers
WHERE calculate_total_order_value(CustomerId) > 120;
