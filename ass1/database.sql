-- Create addresses table
CREATE TABLE
  `Addresses1` (
    `DeliveryAddress` varchar(255) DEFAULT NULL,
    `DeliveryCity` varchar(255) DEFAULT NULL,
    `DeliveryZip` varchar(255) DEFAULT NULL,
    PRIMARY KEY (`DeliveryAddress`)
  )

-- Create books table
CREATE TABLE
  `Books` (
    `BookTitle` varchar(255) NOT NULL,
    `BookPrice` int NOT NULL,
    PRIMARY KEY (`BookTitle`)
  )

-- Books changelog table
CREATE TABLE
  `BooksChangelog` (
    `BookTitle` varchar(255) NOT NULL,
    `Timestamp` timestamp NOT NULL,
    `OldBookPrice` int NOT NULL,
    `NewBookPrice` int NOT NULL,
    PRIMARY KEY (`BookTitle`, `Timestamp`)
  )

-- Create customers table
CREATE TABLE
  `Customers` (
    `CustomerId` int unsigned NOT NULL AUTO_INCREMENT,
    `CustomerName` varchar(255) NOT NULL,
    PRIMARY KEY (`CustomerId`)
  )

-- Customers changelog table
CREATE TABLE
  `CustomersChangelog` (
    `CustomerId` int unsigned NOT NULL AUTO_INCREMENT,
    `Timestamp` timestamp NOT NULL,
    `OldCustomerName` varchar(255) NOT NULL,
    `NewCustomerName` varchar(255) NOT NULL,
    PRIMARY KEY (`CustomerId`, `Timestamp`)
  )

-- Create orders table
CREATE TABLE
  `Orders` (
    `OrderId` int unsigned NOT NULL AUTO_INCREMENT,
    `CustomerId` int NOT NULL,
    `BookTitle` varchar(255) NOT NULL,
    `OrderDate` date NOT NULL,
    `DeliveryAddress` varchar(255) NOT NULL,
    PRIMARY KEY (`OrderId`, `CustomerId`, `BookTitle`)
  );
 
-- Create table to store monthly sales reports
CREATE TABLE
  `MonthlySalesReport` (
    `Month` int unsigned NOT NULL AUTO_INCREMENT,
    `BookTitle` varchar(255) NOT NULL,
    `Sales` int NOT NULL,
    PRIMARY KEY (`Month`, `BookTitle`)
  );

-- Data insertion
insert into `Addresses` (`DeliveryAddress`, `DeliveryCity`, `DeliveryZip`) values ('123 Elm St', 'Springfield', '12345');
insert into `Addresses` (`DeliveryAddress`, `DeliveryCity`, `DeliveryZip`) values ('456 Oak Ave', 'Springfield', '12345');
insert into `Addresses` (`DeliveryAddress`, `DeliveryCity`, `DeliveryZip`) values ('789 Pine Rd', 'Riverside', '67890');

insert into `Books` (`BookPrice`, `BookTitle`) values (60, 'Advanced SQL');
insert into `Books` (`BookPrice`, `BookTitle`) values (45, 'Database Fundamentals');
insert into `Books` (`BookPrice`, `BookTitle`) values (40, 'The Relational Model');

insert into `Customers` (`CustomerId`, `CustomerName`) values (1, 'John Doe :)');
insert into `Customers` (`CustomerId`, `CustomerName`) values (2, 'Jane Smith');
insert into `Customers` (`CustomerId`, `CustomerName`) values (3, 'Emily Clark');

insert into `Orders` (`BookTitle`, `CustomerId`, `DeliveryAddress`, `OrderDate`, `OrderId`) values ('Advanced SQL', 1, '123 Elm St', '2023-04-10', 1);
insert into `Orders` (`BookTitle`, `CustomerId`, `DeliveryAddress`, `OrderDate`, `OrderId`) values ('Database Fundamentals', 1, '123 Elm St', '2023-04-10', 1);
insert into `Orders` (`BookTitle`, `CustomerId`, `DeliveryAddress`, `OrderDate`, `OrderId`) values ('The Relational Model', 1, '123 Elm St', '2023-04-13', 1);
insert into `Orders` (`BookTitle`, `CustomerId`, `DeliveryAddress`, `OrderDate`, `OrderId`) values ('Advanced SQL', 2, '456 Oak Ave', '2023-04-11', 2);
insert into `Orders` (`BookTitle`, `CustomerId`, `DeliveryAddress`, `OrderDate`, `OrderId`) values ('The Relational Model', 2, '456 Oak Ave', '2023-04-11', 2);
insert into `Orders` (`BookTitle`, `CustomerId`, `DeliveryAddress`, `OrderDate`, `OrderId`) values ('Database Fundamentals', 3, '789 Pine Rd', '2023-04-12', 3);
