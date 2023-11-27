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
