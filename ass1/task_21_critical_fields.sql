-- Keep track of changes in customer names
CREATE TRIGGER log_customers_changes
AFTER UPDATE ON Customers
FOR EACH ROW
BEGIN
  IF OLD.CustomerName <> NEW.CustomerName THEN
    INSERT INTO CustomersChangelog (CustomerId, OldCustomerName, NewCustomerName, Timestamp)
    VALUES (NEW.CustomerId, OLD.CustomerName, NEW.CustomerName, NOW());
  END IF;
END;

-- Keep track of changes in book prices
CREATE TRIGGER log_books_changes
AFTER UPDATE ON Books
FOR EACH ROW
BEGIN
  IF OLD.BookPrice <> NEW.BookPrice THEN
    INSERT INTO BookChangelog (BookTitle, OldBookPrice, NewBookPrice, Timestamp)
    VALUES (NEW.BookTitle, OLD.BookPrice, NEW.BookPrice, NOW());
  END IF;
END;

