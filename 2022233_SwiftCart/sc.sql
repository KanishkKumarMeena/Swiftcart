-- ----------------------------------------- --
--    Database Schema & Data Population      --
--                               -Kanishk Kumar Meena     --
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
DROP TABLE IF EXISTS Login;
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
    Address VARCHAR(255) NOT NULL,
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
    Image_Address VARCHAR(30) NOT NULL,
    I_Description Varchar(224) NOT NULL,
    PRIMARY KEY (Item_ID)
);

--        Creating Item Quantity Table       --
CREATE TABLE Item_Quantity(
	Item_ID VARCHAR(10) NOT NULL,
    Supplier_ID VARCHAR(10) NOT NULL,
    Item_Quantity INT NOT NULL,
    FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID),
    -- FOREIGN KEY (Item_Quantity) REFERENCES Item(Item_Quantity),
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
);

--         Creating Item List Table         --
CREATE TABLE Item_List(
	Item_List_ID int NOT NULL auto_increment,
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
	Cart_ID int NOT NULL auto_increment,
    Customer_ID VARCHAR(10) NOT NULL,
    Item_List_ID int NOT NULL,
    Cart_Price INT NOT NULL,
    PRIMARY KEY (Cart_ID,Customer_ID,Item_List_ID),
    FOREIGN KEY (Item_List_ID) REFERENCES Item_List(Item_List_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

--           Creating Orders Table         --
CREATE TABLE Orders(
	Order_ID INT NOT NULL auto_increment,
    Cart_ID int NOT NULL,
    Order_Date DATE,
    PRIMARY KEY (Order_ID),
    FOREIGN KEY (Cart_ID) REFERENCES Cart(Cart_ID)
);

/*Creating Places table to handle Many to Many relationship between orders and customer*/
CREATE TABLE Places(
	Order_ID INT NOT NULL,
    Customer_ID VARCHAR(10) NOT NULL,
    Transaction_Mode VARCHAR(30) NOT NULL,
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

/*Creating Included_In table to handle Many to Many relationship between item and cart*/
CREATE TABLE Included_In(
	Item_ID VARCHAR(10) NOT NULL,
    Cart_ID int NOT NULL,
    FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID),
    FOREIGN KEY (Cart_ID) REFERENCES Cart(Cart_ID)
);


create table login(
	attempts varchar(255) null
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
('cus0000000', 'a','a',null,null,'a','a',19),
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

insert into login(attempts)
values
('1');

INSERT INTO  Item(Item_ID, Item_Name, Item_Quantity, Price, Image_Address,I_Description)
VALUES
('itm0000001', 'Milk', 10, 45, '../static/Milk.png', 'Fresh, nutritious, and versatile, our pure milk is a staple for your daily needs.'),
('itm0000002', 'Ice Cream', 5, 120,'../static/IceCream.png','Creamy indulgence in various flavorsperfect for sweet cravings.'),
('itm0000003', 'Pen', 12, 10,'../static/Pen.png','High-quality, smooth writing instrument for precision and style.'),
('itm0000004', 'Chips', 28, 30,'../static/Chips.png', 'Crunchy snacks for anytime munching.'),
('itm0000005', 'Chocolate', 11, 70,'../static/Chocolate.png','Irresistible cocoa goodness for moments of indulgence.'),
('itm0000006', 'Cola', 16, 20,'../static/Cola.png','IThe iconic fizzy beverage with a refreshing blend of cola flavor, carbonation, and a hint of caramel.'),
('itm0000007', 'Cereal', 9, 450,'../static/Cereal.png','Nutty, wholesome clusters made from rolled oats, nuts, and dried fruits.'),
('itm0000008', 'Cookies', 25, 110,'../static/Cookies.png','Rich and decadent chocolate cookies made with cocoa powder and chunks of dark chocolate.');

INSERT INTO  Item_List(Item_ID, Item_Quantity, Item_Total_Price)
VALUES
('itm0000001', 5, 225),
('itm0000002', 1, 120),
('itm0000003', 9, 90),
('itm0000004', 11, 330),
('itm0000005', 2, 140);

INSERT INTO  Item_Quantity(Item_ID, Supplier_ID,Item_Quantity)
VALUES
('itm0000001', 'sup0000003',5),
('itm0000002', 'sup0000005',1),
('itm0000003', 'sup0000001',9),
('itm0000004', 'sup0000002',11),
('itm0000005', 'sup0000009',2);

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

INSERT INTO  Cart(Cart_ID,Customer_ID, Item_List_ID, Cart_Price)
VALUES
(1,'cus0000010', 1, 225),
(2,'cus0000005', 2, 120),
(3,'cus0000003', 3, 90),
(4,'cus0000007', 4, 330),
(4,'cus0000007', 5, 140);

INSERT INTO  Orders(Order_ID, Cart_ID, Order_Date)
VALUES
(1, 1, '2024-01-12'),
(2, 2, '2024-02-29'),
(3, 3, '2024-09-1'),
(4, 4, '2023-12-01');

-- INSERT INTO  Places(Order_ID, Customer_ID, Transaction_Mode)
-- VALUES
-- ('ord0000001', 'cus0000010', 'UPI'),
-- ('ord0000002', 'cus0000005', 'Wallet'),
-- ('ord0000003', 'cus0000003', 'COD'),
-- ('ord0000004', 'cus0000004', 'COD'),
-- ('ord0000005', 'cus0000007', 'Wallet');

-- INSERT INTO  Included_IN(Item_ID, Cart_ID)
-- VALUES
-- ('itm0000001', 1),
-- ('itm0000002', 4),
-- ('itm0000003', 2),
-- ('itm0000004', 2),
-- ('itm0000005', 5);

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

-- Trigger to handle login attempts
DELIMITER $$
CREATE TRIGGER login_trigger
BEFORE INSERT ON login
FOR EACH ROW
BEGIN
    -- Declare a variable to hold the login message
    DECLARE login_message VARCHAR(255);
    -- Generate a login message based on the login attempts
    IF NEW.attempts = '0' THEN
        SET login_message = 'Try Different';
    ELSE
        SET login_message = CONCAT('Try Different (', NEW.attempts, ' attempts left)');
    END IF;
    -- Insert the login message into the login table
    INSERT INTO login (attempts) VALUES (login_message);
END$$
DELIMITER ;

-- Trigger to validate customer age before insertion
DELIMITER $$
CREATE TRIGGER before_insert_customer
BEFORE INSERT ON Customer
FOR EACH ROW
BEGIN
    -- If the age is less than 18, raise an error
    IF NEW.Age < 18 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Age should be 18 or older';
    END IF;
END$$
DELIMITER ;

-- ----------------------------------------- --
--     Showing tables and there contents     --
-- ----------------------------------------- --
-- SHOW TABLES;
-- SELECT * FROM supplier;
-- SELECT * FROM customer;
-- SELECT * FROM supplier_phone_number;
-- SELECT * FROM customer_phone_number;
-- SELECT * FROM cart;
-- SELECT * FROM included_in;
-- SELECT * FROM is_purchased_by;
-- SELECT * FROM item;
-- SELECT * FROM item_list;
-- SELECT * FROM item_quantity;
-- SELECT * FROM orders;
-- SELECT * FROM places;
-- SELECT * FROM supplies;
