DROP FUNCTION IF EXISTS list_unique_books;

-- Add a function to display all books that have been ordered
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

-- See an overview of all books that have been ordered at least once.
SELECT list_unique_books();
