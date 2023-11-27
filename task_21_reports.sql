CREATE TRIGGER set_monthly_sales_report
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
