-- ----------------------------------------- --
--    Database Schema & Data Population      --
--                  -Kanishk Kumar Meena     --
--                   2022233                 --
-- ----------------------------------------- --


-- ----------------------------------------- --
--     Creating database if it not exist     --
-- ----------------------------------------- --
CREATE DATABASE IF NOT EXISTS Swiftcart;

-- ----------------------------------------- --
--             Selecting database            --
-- ----------------------------------------- --
USE Swiftcart;

-- ----------------------------------------- --
--   Deleting tables if they already exist   --
-- ----------------------------------------- --
DROP TABLE IF EXISTS Customer_Phone_Number;
DROP TABLE IF EXISTS Supplier_Phone_Number;
DROP TABLE IF EXISTS Included_IN;
DROP TABLE IF EXISTS Places;
DROP TABLE IF EXISTS Is_Purchased_By;
DROP TABLE IF EXISTS Supplies;
DROP TABLE IF EXISTS Item_Quantity;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Cart;
DROP TABLE IF EXISTS Item_List;
DROP TABLE IF EXISTS Item;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Supplier;

-- ----------------------------------------- --
--               Creating tables             --
-- ----------------------------------------- --

--           Creating Supplier Table         --
CREATE TABLE Supplier(
	Supplier_ID VARCHAR(10) NOT NULL,
    Store_ID VARCHAR(10) NOT NULL,
    Sup_Password VARCHAR(6) NOT NULL,
    First_Name VARCHAR(15) NOT NULL,
    Middle_Name VARCHAR(15) NULL,
    Last_Name VARCHAR(15) NULL,
    Email VARCHAR(30) NOT NULL,
    PRIMARY KEY (Supplier_ID),
    UNIQUE KEY Email (Email),
    UNIQUE KEY Sup_Password (Sup_Password)
);

--          Creating Customer Table         --
CREATE TABLE Customer(
	Customer_ID VARCHAR(10) NOT NULL,
    Cus_Password VARCHAR(6) NOT NULL,
    First_Name VARCHAR(15) NOT NULL,
    Middle_Name VARCHAR(15) NULL,
    Last_Name VARCHAR(15) NULL,
    Email VARCHAR(30) NOT NULL,
    Address VARCHAR(255),
    Age INT NOT NULL,
    PRIMARY KEY (Customer_ID),
    UNIQUE KEY Email (Email),
    UNIQUE KEY Cus_Password (Cus_Password),
    CONSTRAINT check_age CHECK (Age >= 18)
);

/*Creating supplier phone number table to handle Multivalued attribute in Supplier*/
CREATE TABLE Supplier_Phone_Number(
	Supplier_ID VARCHAR(10) NOT NULL,
    Phone_Number VARCHAR(10) NOT NULL,
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID),
    CHECK (LENGTH(Phone_Number) = 10 AND Phone_Number BETWEEN '6000000000' AND '9999999999')
);

/*Creating customer phone number table to handle Multivalued attribute in Customer*/
CREATE TABLE Customer_Phone_Number(
	Customer_ID VARCHAR(10) NOT NULL,
    Phone_Number VARCHAR(10) NOT NULL,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    CHECK (LENGTH(Phone_number) = 10 AND Phone_number BETWEEN '6000000000' AND '9999999999')
);

--            Creating Item Table           --
CREATE TABLE Item(
	Item_ID VARCHAR(10) NOT NULL,
    Item_Name VARCHAR(30) NOT NULL,
    Item_Quantity INT NOT NULL,
    Price INT NOT NULL,
    PRIMARY KEY (Item_ID)
);

--        Creating Item Quantity Table       --
CREATE TABLE Item_Quantity(
	Item_ID VARCHAR(10) NOT NULL,
    Supplier_ID VARCHAR(10) NOT NULL,
    FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID),
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
);

--         Creating Item List Table         --
CREATE TABLE Item_List(
	Item_List_ID VARCHAR(10) NOT NULL,
    Item_ID VARCHAR(10) NOT NULL,
    Item_Quantity INT NULL,
    Item_Total_Price INT NOT NULL,
    PRIMARY KEY (Item_List_ID),
    FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID)
);

/*Creating Supplies table to handle Many to Many ternary relationship between supplier, item and item quantity*/
CREATE TABLE Supplies(
	Item_ID VARCHAR(10) NOT NULL,
    Supplier_ID VARCHAR(10) NOT NULL,
    Item_Quantity INT NOT NULL,
    FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID),
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
);

/*Creating Is_Purchased_By table to handle Many to Many relationship between item and customer*/
CREATE TABLE Is_Purchased_By(
	Item_ID VARCHAR(10) NOT NULL,
    Customer_ID VARCHAR(10) NOT NULL,
    FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

--           Creating Cart Table           --
CREATE TABLE Cart(
	Cart_ID VARCHAR(10) NOT NULL,
    Customer_ID VARCHAR(10) NOT NULL,
    Item_List_ID VARCHAR(10) NOT NULL,
    Cart_Price INT NOT NULL,
    PRIMARY KEY (Cart_ID),
    FOREIGN KEY (Item_List_ID) REFERENCES Item_List(Item_List_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

--           Creating Orders Table         --
CREATE TABLE Orders(
	Order_ID VARCHAR(10) NOT NULL,
    Cart_ID VARCHAR(10) NOT NULL,
    Order_Status VARCHAR(30) NOT NULL,
    Order_Date DATE,
    PRIMARY KEY (Order_ID),
    FOREIGN KEY (Cart_ID) REFERENCES Cart(Cart_ID)
);

/*Creating Places table to handle Many to Many relationship between orders and customer*/
CREATE TABLE Places(
	Order_ID VARCHAR(10) NOT NULL,
    Customer_ID VARCHAR(10) NOT NULL,
    Transaction_Mode VARCHAR(30) NOT NULL,
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

/*Creating Included_In table to handle Many to Many relationship between item and cart*/
CREATE TABLE Included_In(
	Item_ID VARCHAR(10) NOT NULL,
    Cart_ID VARCHAR(10) NOT NULL,
    FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID),
    FOREIGN KEY (Cart_ID) REFERENCES Cart(Cart_ID)
);

-- ----------------------------------------- --
--         Populating data in tables         --
-- ----------------------------------------- --
INSERT INTO  Supplier(Supplier_ID, Store_ID, Sup_Password, First_Name, Middle_Name, Last_Name, Email)
VALUES
('sup0000001', 'str0000001', 'abcdef', 'Tony',NULL,'Stark','abc@def.com'),
('sup0000002', 'str0000002', 'bcdefg', 'Steve',NULL,'Rogers','bcd@efg.com'),
('sup0000003', 'str0000003', 'cdefgh', "T'Challa",NULL,NULL,'cde@fgh.com'),
('sup0000004', 'str0000004', 'defghi', 'Scott','Edward','Lang','def@ghi.com'),
('sup0000005', 'str0000005', 'efghij', 'Samuel','Thomas','Wilson','efg@hij.com'),
('sup0000006', 'str0000006', 'fghijk', 'Nebula',NULL,NULL,'fgh@ijk.com'),
('sup0000007', 'str0000007', 'ghijkl', 'Scott',NULL,'Lang','ghi@jkl.com'),
('sup0000008', 'str0000008', 'hijklm', 'Bruce',NULL,'Banner','hij@klm.com'),
('sup0000009', 'str0000009', 'ijklmn', 'Pietro',NULL,'Maximoff','ijk@lmn.com'),
('sup0000010', 'str0000010', 'jklmno', 'Pepper',NULL,'Potts','jkl@mno.com');

INSERT INTO  Customer(Customer_ID, Cus_Password, First_Name, Middle_Name, Last_Name, Email, Address, Age)
VALUES
('cus0000001', 'abc123', 'Stephen','Vincent','Strange','abc@123.com', '12B, Ganga Apartments, Prashant Nagar, Mumbai', 28),
('cus0000002', 'def345', 'Mathew','Michael','Murdock','def@345.com', '7/43, Green Street, Koramangala, Bangalore', 18),
('cus0000003', 'ghi567', 'Natasha',NULL,'Romanoff','ghi@567.com', 'C-201, Himalaya Towers, Nehru Place, Delhi', 22),
('cus0000004', 'jkl789', 'Thor',NULL,'Odinson','jkl@789.com', '32, Rajiv Enclave, Sushant City, Gurgaon', 99),
('cus0000005', 'mno901', 'Peter',NULL,'Parker','mno@901.com', '14/3, Tulsi Marg, Civil Lines, Jaipur', 19),
('cus0000006', 'pqr234', 'Wanda',NULL,'Maximoff','pqr@234.com', 'D-45, Lotus Residency, Kondhwa, Pune', 24),
('cus0000007', 'stu456', 'Carol',NULL,'Danvers','stu@456.com', '8/22, Indira Nagar, Velachery, Chennai', 32),
('cus0000008', 'vwx678', 'Clint','Francis','Barton','vwx@678.com', 'H.No. 56, Sai Nagar, Jubilee Hills, Hyderabad', 34),
('cus0000009', 'yza890', 'Hope','Van','Dyne','yza@890.com', '23, Krishna Vihar, Bapu Nagar, Jaipur', 26),
('cus0000010', 'bcd123', 'Jessica','Campbell','Jones','bcd@123.com', 'A-102, Gokul Residency, Satellite Road, Ahmedabad', 29);

INSERT INTO  Item(Item_ID, Item_Name, Item_Quantity, Price)
VALUES
('itm0000001', 'Milk', 10, 45),
('itm0000002', 'Chocolate', 5, 120),
('itm0000003', 'Pen', 12, 10),
('itm0000004', 'Chips', 28, 30),
('itm0000005', 'Ice Cream', 11, 70);

INSERT INTO  Item_List(Item_List_ID, Item_ID, Item_Quantity, Item_Total_Price)
VALUES
('itl0000001','itm0000001', 5, 225),
('itl0000002','itm0000002', 1, 120),
('itl0000003','itm0000003', 9, 90),
('itl0000004','itm0000004', 11, 330),
('itl0000005','itm0000005', 2, 140);

INSERT INTO  Item_Quantity(Item_ID, Supplier_ID)
VALUES
('itm0000001', 'sup0000003'),
('itm0000002', 'sup0000005'),
('itm0000003', 'sup0000001'),
('itm0000004', 'sup0000002'),
('itm0000005', 'sup0000009');

INSERT INTO  Supplies(Item_ID, Supplier_ID, Item_Quantity)
VALUES
('itm0000001', 'sup0000003', 1),
('itm0000002', 'sup0000005', 5),
('itm0000003', 'sup0000001', 2),
('itm0000004', 'sup0000002', 10),
('itm0000005', 'sup0000009', 3);

INSERT INTO  Is_Purchased_By(Item_ID, Customer_ID)
VALUES
('itm0000001', 'cus0000010'),
('itm0000002', 'cus0000001'),
('itm0000003', 'cus0000001'),
('itm0000004', 'cus0000002'),
('itm0000005', 'cus0000009');

INSERT INTO  Cart(Cart_ID, Customer_ID, Item_List_ID, Cart_Price)
VALUES
('crt0000001','cus0000010', 'itl0000001', 225),
('crt0000002','cus0000005', 'itl0000002', 120),
('crt0000003','cus0000003', 'itl0000003', 90),
('crt0000004','cus0000004', 'itl0000004', 330),
('crt0000005','cus0000007', 'itl0000005', 140);

INSERT INTO  Orders(Order_ID, Cart_ID, Order_Status, Order_Date)
VALUES
('ord0000001', 'crt0000001', 'Pending', '2024-01-12'),
('ord0000002', 'crt0000002', 'Complete', '2024-02-29'),
('ord0000003', 'crt0000003', 'Processing', '2024-09-1'),
('ord0000004', 'crt0000004', 'Pending', '2023-12-01'),
('ord0000005', 'crt0000005', 'Complete', '2024-8-30');

INSERT INTO  Places(Order_ID, Customer_ID, Transaction_Mode)
VALUES
('ord0000001', 'cus0000010', 'UPI'),
('ord0000002', 'cus0000005', 'Wallet'),
('ord0000003', 'cus0000003', 'COD'),
('ord0000004', 'cus0000004', 'COD'),
('ord0000005', 'cus0000007', 'Wallet');

INSERT INTO  Included_IN(Item_ID, Cart_ID)
VALUES
('itm0000001', 'crt0000001'),
('itm0000002', 'crt0000004'),
('itm0000003', 'crt0000002'),
('itm0000004', 'crt0000002'),
('itm0000005', 'crt0000005');

INSERT INTO  Supplier_Phone_Number(Supplier_ID, Phone_Number)
VALUES
('sup0000001', '9999999999'),
('sup0000002', '9898989898'),
('sup0000003', '9879879879'),
('sup0000004', '9191919191'),
('sup0000005', '8989898989');

INSERT INTO  Customer_Phone_Number(Customer_ID, Phone_Number)
VALUES
('cus0000001', '9929999239'),
('cus0000002', '9845989898'),
('cus0000003', '7893879879'),
('cus0000004', '9562919191'),
('cus0000005', '8912898980');

-- ----------------------------------------- --
--     Showing tables and there contents     --
-- ----------------------------------------- --
SHOW TABLES;
SELECT * FROM supplier;
SELECT * FROM customer;
SELECT * FROM supplier_phone_number;
SELECT * FROM customer_phone_number;
SELECT * FROM cart;
SELECT * FROM included_in;
SELECT * FROM is_purchased_by;
SELECT * FROM item;
SELECT * FROM item_list;
SELECT * FROM item_quantity;
SELECT * FROM orders;
SELECT * FROM places;
SELECT * FROM supplies;
