CREATE TRIGGER prevent_customer_delete
BEFORE DELETE ON Customers
FOR EACH ROW
BEGIN
  IF EXISTS(
    SELECT * FROM Orders
    WHERE CustomerId = OLD.CustomerId
  ) THEN
    SIGNAL SQLSTATE '23511'
    SET MESSAGE_TEXT = 'Cannot delete customer with existing orders';
  END IF;
END;

CREATE TRIGGER prevent_book_delete
BEFORE DELETE ON Books
FOR EACH ROW
BEGIN
  IF EXISTS(
    SELECT * FROM Orders
    WHERE BookTitle = OLD.BookTitle
  ) THEN
    SIGNAL SQLSTATE '23511'
    SET MESSAGE_TEXT = 'Cannot delete book with existing orders';
  END IF;
END;

CREATE TRIGGER prevent_address_table
BEFORE DELETE ON Addresses
FOR EACH ROW
BEGIN
  IF EXISTS(
    SELECT * FROM Orders
    WHERE DeliveryAddress = OLD.DeliveryAddress
  ) THEN
    SIGNAL SQLSTATE '23511'
    SET MESSAGE_TEXT = 'Cannot delete delivery address with existing orders';
  END IF;
END;
