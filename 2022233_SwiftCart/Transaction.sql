-- Transaction T1: Customer adds items to cart and places order
-- START TRANSACTION;
-- INSERT INTO Cart (Customer_ID, Item_List_ID, Cart_Price) VALUES ('cus0000000', 1, 50);
-- INSERT INTO Orders (Cart_ID, Order_Date) VALUES (1, CURDATE());
-- INSERT INTO Places (Order_ID, Customer_ID, Transaction_Mode) VALUES (1, 'cus0000000', 'Online');
-- COMMIT;
-- -- Transaction T2: Deduct item quantities from inventory and update customer's purchased items
-- START TRANSACTION;
-- UPDATE Item_Quantity SET Item_Quantity = Item_Quantity - 1 WHERE Item_ID = 'itm0000001' AND Supplier_ID = 'sup0000001';
-- INSERT INTO Is_Purchased_By (Item_ID, Customer_ID) VALUES ('itm0000001', 'cus0000000');
-- COMMIT;

-- Transaction T1: Supplier updates item quantities
-- START TRANSACTION;
-- UPDATE Item_Quantity SET Item_Quantity = Item_Quantity + 50 WHERE Item_ID = 'itm0000001' AND Supplier_ID = 'sup0000001';
-- COMMIT;

-- -- Transaction T2: Update item quantity in inventory
-- START TRANSACTION;
-- UPDATE Item SET Item_Quantity = Item_Quantity + 50 WHERE Item_ID = 'itm0000001';
-- COMMIT;

-- Transaction T1: Insert new customer details
-- START TRANSACTION;
-- INSERT INTO Customer (Customer_ID, Cus_Password, First_Name, Last_Name, Email, Address, Age) 
-- VALUES ('C001', 'pswrd0', 'John', 'Doe', 'john@example.com', '123 Main St', 25);
-- COMMIT;

-- -- Transaction T2: Add customer's phone number
-- START TRANSACTION;
-- INSERT INTO Customer_Phone_Number (Customer_ID, Phone_Number) VALUES ('C001', '8234567890');
-- COMMIT;


-- Transaction T1: Insert new supplier details
-- START TRANSACTION;
-- INSERT INTO Supplier (Supplier_ID, Store_ID, Sup_Password, First_Name, Last_Name, Email) 
-- VALUES ('sup0000000', 'str0000000', 'pas123', 'Jane', 'Smith', 'jane@example.com');
-- COMMIT;

-- -- Transaction T2: Add supplier's phone number
-- START TRANSACTION;
-- INSERT INTO Supplier_Phone_Number (Supplier_ID, Phone_Number) VALUES ('sup0000000', '9777777710');
-- COMMIT;


-- T1: Updating Cart for Customer 1
-- START TRANSACTION;
-- SELECT * FROM Cart WHERE Customer_ID = 'cus0000000' FOR UPDATE;
-- UPDATE Cart SET Cart_Price = 100 WHERE Customer_ID = 'cus0000000';
-- COMMIT;

-- -- T2: Updating Cart for Customer 2
-- START TRANSACTION;
-- SELECT * FROM Cart WHERE Customer_ID = 'cus0000001' FOR UPDATE;
-- UPDATE Cart SET Cart_Price = 150 WHERE Customer_ID = 'cus0000001';
-- COMMIT;


-- T1: Restocking Items for Supplier 1
-- START TRANSACTION;
-- SELECT * FROM Item_Quantity WHERE Supplier_ID = 'sup0000001' FOR UPDATE;
-- UPDATE Item_Quantity SET Item_Quantity = Item_Quantity + 10 WHERE Supplier_ID = 'sup0000001';
-- COMMIT;

-- -- T2: Restocking Items for Supplier 2
-- START TRANSACTION;
-- SELECT * FROM Item_Quantity WHERE Supplier_ID = 'sup0000002' FOR UPDATE;
-- UPDATE Item_Quantity SET Item_Quantity = Item_Quantity + 20 WHERE Supplier_ID = 'sup0000002';
-- COMMIT;
















