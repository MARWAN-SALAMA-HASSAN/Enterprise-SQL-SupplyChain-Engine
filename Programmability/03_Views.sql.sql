USE EnterpriseSupplyChain;
GO

-- View 1: (Reorder Alert)
CREATE VIEW vw_InventoryStockStatus AS
SELECT 
    w.WarehouseName,
    w.City AS WarehouseCity,
    p.ProductName,
    c.CategoryName,
    s.CompanyName AS SupplierName,
    i.QuantityInStock,
    p.ReorderLevel,
    CASE 
        WHEN i.QuantityInStock = 0 THEN 'OUT OF STOCK'
        WHEN i.QuantityInStock <= p.ReorderLevel THEN 'WARNING: REORDER NEEDED'
        ELSE 'OPTIMAL'
    END AS StockStatus
FROM Inventory i
INNER JOIN Products p ON i.ProductID = p.ProductID
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
INNER JOIN Warehouses w ON i.WarehouseID = w.WarehouseID;
GO

-- View 2: 
CREATE VIEW vw_CustomerPurchaseSummary AS
SELECT 
    c.CustomerID,
    c.CustomerName,
    c.City,
    COUNT(so.OrderID) AS TotalOrdersPlaced,
    ISNULL(SUM(so.TotalAmount), 0) AS TotalAmountSpent,
    DENSE_RANK() OVER (ORDER BY ISNULL(SUM(so.TotalAmount), 0) DESC) AS CustomerRank
FROM Customers c
LEFT JOIN SalesOrders so ON c.CustomerID = so.CustomerID AND so.OrderStatus != 'Cancelled'
GROUP BY c.CustomerID, c.CustomerName, c.City;
GO