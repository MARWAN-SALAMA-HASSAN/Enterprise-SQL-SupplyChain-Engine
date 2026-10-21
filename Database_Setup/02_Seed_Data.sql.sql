USE EnterpriseSupplyChain;
GO

INSERT INTO Suppliers (CompanyName, ContactName, Email, Phone, Country, Rating) VALUES
('Nile Tech Imports', 'Ahmed Hassan', 'ahmed@niletech.com', '01012345678', 'Egypt', 4.8),
('Global Electronics Co', 'Sarah Connor', 'sarah@globalelec.com', '01123456789', 'Germany', 4.5),
('Delta Logistics Goods', 'Mohamed Ali', 'm.ali@deltagoods.com', '01234567890', 'Egypt', 3.9);


INSERT INTO Categories (CategoryName, Description) VALUES
('Laptops & PCs', 'Laptops, desktops, and computer hardware'),
('Smartphones', 'Mobile phones and accessories'),
('Monitors', 'Display screens and TVs');


INSERT INTO Products (ProductName, CategoryID, SupplierID, UnitPrice, ReorderLevel) VALUES
('Dell XPS 15', 1, 2, 25000.00, 5),
('MacBook Pro M2', 1, 2, 45000.00, 3),
('iPhone 15 Pro', 2, 1, 38000.00, 10),
('Samsung Galaxy S24', 2, 1, 32000.00, 8),
('LG UltraGear 27"', 3, 3, 9500.00, 12);


INSERT INTO Warehouses (WarehouseName, City, Capacity) VALUES
('Cairo Central Hub', 'Cairo', 5000),
('Alexandria Port Stock', 'Alexandria', 3000);


INSERT INTO Inventory (WarehouseID, ProductID, QuantityInStock) VALUES
(1, 1, 15),
(1, 2, 2), 
(1, 3, 25),
(2, 4, 4),  
(2, 5, 50);


INSERT INTO Customers (CustomerName, Email, Phone, Address, City) VALUES
('TechCorp Egypt', 'info@techcorp.eg', '01000000001', 'Smart Village', 'Giza'),
('Tarek Mahmoud', 'tarek@gmail.com', '01100000002', 'Nasr City', 'Cairo'),
('Omar Sherif', 'omar@yahoo.com', '01200000003', 'Smouha', 'Alexandria');
GO