-- 1. إنشاء قاعدة البيانات
CREATE DATABASE EnterpriseSupplyChain;
GO

USE EnterpriseSupplyChain;
GO

-- 2.  (Suppliers)
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    CompanyName NVARCHAR(100) NOT NULL,
    ContactName NVARCHAR(100),
    Email NVARCHAR(100) UNIQUE,
    Phone NVARCHAR(20),
    Country NVARCHAR(50) DEFAULT 'Egypt',
    Rating DECIMAL(3,2) CHECK (Rating BETWEEN 1.0 AND 5.0),
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 3.  (Categories)
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255)
);

-- 4. (Products)
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID),
    SupplierID INT FOREIGN KEY REFERENCES Suppliers(SupplierID),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
    ReorderLevel INT NOT NULL DEFAULT 10,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 5.  (Warehouses)
CREATE TABLE Warehouses (
    WarehouseID INT IDENTITY(1,1) PRIMARY KEY,
    WarehouseName NVARCHAR(100) NOT NULL,
    City NVARCHAR(50) NOT NULL,
    Capacity INT CHECK (Capacity > 0)
);

-- 6.  (Inventory)
CREATE TABLE Inventory (
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    WarehouseID INT FOREIGN KEY REFERENCES Warehouses(WarehouseID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    QuantityInStock INT NOT NULL CHECK (QuantityInStock >= 0),
    LastUpdated DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_Warehouse_Product UNIQUE (WarehouseID, ProductID)
);

-- 7.  (Customers)
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    Phone NVARCHAR(20),
    Address NVARCHAR(200),
    City NVARCHAR(50),
    JoinedDate DATETIME DEFAULT GETDATE()
);

-- 8.  (SalesOrders)
CREATE TABLE SalesOrders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    WarehouseID INT FOREIGN KEY REFERENCES Warehouses(WarehouseID),
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(12,2) DEFAULT 0.00,
    OrderStatus NVARCHAR(20) CHECK (OrderStatus IN ('Pending', 'Processing', 'Shipped', 'Cancelled')) DEFAULT 'Pending'
);

-- 9.  (SalesOrderDetails)
CREATE TABLE SalesOrderDetails (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES SalesOrders(OrderID) ON DELETE CASCADE,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL,
    SubTotal AS (Quantity * UnitPrice) PERSISTED
);

-- 10.  (Audit_Log)
CREATE TABLE PriceAuditLog (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    OldPrice DECIMAL(10,2),
    NewPrice DECIMAL(10,2),
    ChangedBy NVARCHAR(100) DEFAULT SYSTEM_USER,
    ChangedAt DATETIME DEFAULT GETDATE()
);
GO