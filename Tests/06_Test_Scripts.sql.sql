USE EnterpriseSupplyChain;
GO

-- 1. Stored Procedure 
DECLARE @NewOrderID INT;
EXEC sp_ProcessNewSale 
    @CustomerID = 1, 
    @WarehouseID = 1, 
    @ProductID = 1, 
    @Quantity = 2, 
    @OrderID = @NewOrderID OUTPUT;

SELECT @NewOrderID AS [Created_Order_ID];

-- 2.  Views
SELECT * FROM vw_InventoryStockStatus;
SELECT * FROM vw_CustomerPurchaseSummary;

-- 3. Trigger 
UPDATE Products 
SET UnitPrice = 27000.00 
WHERE ProductID = 1;

-- Check the Audit Log
SELECT * FROM PriceAuditLog;