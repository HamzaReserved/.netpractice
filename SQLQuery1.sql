SELECT @@SERVERNAME AS ServerName;

USE PurchaseApprovalDb;
SELECT 'Users' AS TableName, COUNT(*) AS TotalRows FROM Users
UNION ALL SELECT 'Vendors', COUNT(*) FROM Vendors
UNION ALL SELECT 'Products', COUNT(*) FROM Products
UNION ALL SELECT 'VendorProducts', COUNT(*) FROM VendorProducts
UNION ALL SELECT 'PurchaseRequests', COUNT(*) FROM PurchaseRequests
UNION ALL SELECT 'RequestItems', COUNT(*) FROM RequestItems
UNION ALL SELECT 'Approvals', COUNT(*) FROM Approvals
UNION ALL SELECT 'PurchaseOrders', COUNT(*) FROM PurchaseOrders;

Select 'Users' AS tablename, count (*) AS totalrows from Users
union ALL select 'Vendors', COUNT(*) from Vendors;

SELECT * FROM Approvals
SELECT * FROM __EFMigrationsHistory
SELECT * FROM AiRecommendationLogs
SELECT * FROM AuditLogs
SELECT * FROM Products
SELECT * FROM PurchaseOrders
SELECT * FROM PurchaseRequests
SELECT * FROM RequestItems
SELECT * FROM Users
SELECT * FROM VendorProducts
SELECT * FROM Vendors


USE PurchaseApprovalDb;

SELECT TOP 8 Id, UserId, Action, EntityName, EntityId, LEFT(NewValues, 70) AS NewValues
FROM AuditLogs ORDER BY Id DESC;

SELECT Id, Code, Name, IsDeleted, CreatedBy, UpdatedBy, UpdatedAt
FROM Vendors WHERE Code = 'V900';

SELECT TOP 8 Id, UserId, Action, EntityName, EntityId, LEFT(NewValues, 70) AS NewValues 
FROM AuditLogs 
ORDER BY Id DESC;


SELECT Id, Code, Name, IsDeleted, CreatedBy, UpdatedBy 
FROM Vendors 
WHERE Code = 'V900';


SELECT TOP 14 Id, UserId, Action, EntityName, EntityId, LEFT(NewValues, 60) AS NewValues
FROM AuditLogs
WHERE EntityName IN ('PurchaseRequest', 'RequestItem')
ORDER BY Id DESC;

SELECT RequestNumber, Title, Status, TotalAmount, IsDeleted, CreatedBy
FROM PurchaseRequests
WHERE Title IN ('to delete', 'API test request (edited)');


USE PurchaseApprovalDb;
SELECT TOP 10 Id, UserId, Action, EntityName, EntityId, LEFT(NewValues, 70) AS NewValues
FROM AuditLogs
WHERE EntityName IN ('Approval', 'PurchaseRequest')
ORDER BY Id DESC;

SELECT TOP 10 Id, UserId, Action, EntityName, EntityId, LEFT(NewValues, 70) AS NewValues
FROM AuditLogs
WHERE EntityName IN ('PurchaseOrder', 'PurchaseRequest')
ORDER BY Id DESC;

SELECT PoNumber, Status, TotalAmount, PromisedDeliveryDate, DeliveredDate
FROM PurchaseOrders WHERE Id > 38 ORDER BY Id;

---10 dAYS PECHY KR DENA TIME KO TO CHECK DELAY STATUS 
USE PurchaseApprovalDb;
UPDATE PurchaseOrders
SET OrderDate = DATEADD(day, -10, CAST(GETUTCDATE() AS date)),
    PromisedDeliveryDate = DATEADD(day, -3, CAST(GETUTCDATE() AS date))
WHERE Id = (SELECT MAX(Id) FROM PurchaseOrders WHERE Status = 'Created');



-- soft delete ko reverse kra prduct table mai after delete
UPDATE Products
SET 
    IsDeleted = 0,    -- Mark as NOT deleted
    IsActive = 1      -- Mark as Active 
WHERE Name = 'lan wiring';


-- vendor checking after ai recomendation system 

USE PurchaseApprovalDb;

SELECT TOP 5 Id, PurchaseRequestId, RequestedBy, RecommendedVendorId, FinalVendorId,
       WasOverridden, OverrideReason, CreatedAt
FROM AiRecommendationLogs ORDER BY Id DESC;

SELECT TOP 1 JSON_VALUE(OutputJson, '$.summary') AS Summary,
             JSON_VALUE(OutputJson, '$.confidence') AS Confidence
FROM AiRecommendationLogs ORDER BY Id DESC;

-- ssms check
USE PurchaseApprovalDb;
SELECT TOP 6 Id, PurchaseRequestId, RecommendedVendorId, FinalVendorId, WasOverridden, OverrideReason, CreatedAt
FROM AiRecommendationLogs ORDER BY Id DESC;


-- cards checkings 
USE PurchaseApprovalDb;

SELECT COUNT(*) AS TotalRequests
FROM PurchaseRequests WHERE IsDeleted = 0;

SELECT COUNT(*) AS PendingForAdmin
FROM PurchaseRequests
WHERE IsDeleted = 0 AND Status = 'Submitted'
  AND RequesterId <> (SELECT Id FROM Users WHERE Email = 'admin@demo.com');

SELECT COUNT(DISTINCT PurchaseRequestId) AS ApprovedThisMonth
FROM Approvals
WHERE IsDeleted = 0 AND Decision = 'Approved'
  AND DecidedAt >= DATEFROMPARTS(YEAR(GETUTCDATE()), MONTH(GETUTCDATE()), 1);

SELECT SUM(TotalAmount) AS TotalOrderValue
FROM PurchaseOrders WHERE IsDeleted = 0 AND Status <> 'Cancelled';

-- users update 
update Users
set 
   FullName = 'Ezan Khan'
where id ='2';



--------------
USE PurchaseApprovalDb;

-- Passwords must never appear in the audit log. This must be 0.
SELECT COUNT(*) AS RowsWithPasswordData
FROM AuditLogs
WHERE NewValues LIKE '%AQAAAA%' OR OldValues LIKE '%AQAAAA%'
   OR NewValues LIKE '%PasswordHash%' OR OldValues LIKE '%PasswordHash%';

SELECT TOP 8 Id, UserId, Action, EntityName, EntityId, LEFT(NewValues, 60) AS NewValues
FROM AuditLogs
WHERE EntityName = 'User' AND Action IN ('Create', 'Update', 'PasswordReset')
ORDER BY Id DESC;



-----------------------------
