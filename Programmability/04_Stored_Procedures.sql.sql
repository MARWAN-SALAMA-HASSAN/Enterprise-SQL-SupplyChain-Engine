USE EnterpriseSupplyChain;
GO

-- Stored Procedure:  Transaction
CREATE PROCEDURE sp_ProcessNewSale
    @CustomerID INT,
    @WarehouseID INT,
    @ProductID INT,
    @Quantity INT,
    @OrderID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- 1. CPPSI
        DECLARE @AvailableStock INT;
        DECLARE @UnitPrice DECIMAL(10,2);
        
        SELECT @AvailableStock = QuantityInStock 
        FROM Inventory 
        WHERE WarehouseID = @WarehouseID AND ProductID = @ProductID;
        
        SELECT @UnitPrice = UnitPrice 
        FROM Products 
        WHERE ProductID = @ProductID;

        IF @AvailableStock IS NULL
        BEGIN
            RAISERROR('This product is not in the specified stock.', 16, 1);
        END
        
        IF @AvailableStock < @Quantity
        BEGIN
            RAISERROR('The required quantity is not available in stock.', 16, 1);
        END

        -- 2. Create a sales order
        INSERT INTO SalesOrders (CustomerID, WarehouseID, OrderDate, OrderStatus)
        VALUES (@CustomerID, @WarehouseID, GETDATE(), 'Processing');
        
        SET @OrderID = SCOPE_IDENTITY();

        -- 3. Add details of the request
        INSERT INTO SalesOrderDetails (OrderID, ProductID, Quantity, UnitPrice)
        VALUES (@OrderID, @ProductID, @Quantity, @UnitPrice);

        -- 4. DQFS
        UPDATE Inventory
        SET QuantityInStock = QuantityInStock - @Quantity,
            LastUpdated = GETDATE()
        WHERE WarehouseID = @WarehouseID AND ProductID = @ProductID;

        -- 5. Update total amount of the sales order
        UPDATE SalesOrders
        SET TotalAmount = (@Quantity * @UnitPrice)
        WHERE OrderID = @OrderID;

        -- Confirm the process
        COMMIT TRANSACTION;
        PRINT 'The order succesfully & Registered.';
        
    END TRY
    BEGIN CATCH
        -- Decline of process in occurrence of the mistake
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO