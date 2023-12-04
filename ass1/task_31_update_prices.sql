DROP FUNCTION IF EXISTS update_order_prices;

-- Add a function to easily modify all book prices.
CREATE FUNCTION update_order_prices(Percentage DECIMAL(2, 1))
RETURNS INTEGER DETERMINISTIC
BEGIN
	UPDATE Books
  SET BookPrice = BookPrice * Percentage;
  
  RETURN 0;
END;

-- Add a 20% discount to all books in the store. 
SELECT update_order_prices(0.8);
