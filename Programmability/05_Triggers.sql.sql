USE EnterpriseSupplyChain;
GO

-- Trigger:  PriceAuditLog
CREATE TRIGGER trg_AuditProductPriceChange
ON Products
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Check the UnitPrice
    IF UPDATE(UnitPrice)
    BEGIN
        INSERT INTO PriceAuditLog (ProductID, OldPrice, NewPrice, ChangedBy, ChangedAt)
        SELECT 
            d.ProductID,
            d.UnitPrice AS OldPrice,
            i.UnitPrice AS NewPrice,
            SYSTEM_USER,
            GETDATE()
        FROM deleted d
        INNER JOIN inserted i ON d.ProductID = i.ProductID
        WHERE d.UnitPrice <> i.UnitPrice;
    END
END;
GO