select * from Users 
select * from PurchaseRequests
Select * from PurchaseOrders


select u.Fullname AS NAME ,r.Title AS DESCRIPTION,o.PoNumber as Ordernumber
from users u 
 inner join PurchaseRequests r on u.Id = r.RequesterId
 inner join PurchaseOrders o on u.Id = o.PurchaseRequestId;

select  u.Id, p.RequesterId from  users u left join PurchaseRequests p  on u.Id = p.RequesterId;
select Count(*) from PurchaseRequests;


Select * from Products 
where CreatedAt = '2026-10-14 08:12:04.7682195'
;

SELECT SUM(StandardPrice) from Products
WHERE CAST(CreatedAt AS DATE) = '2026-10-14'
;

-- per din ki total product entry ki price
SELECT CAST(CreatedAt AS DATE) AS ProductDate,SUM(StandardPrice)
FROM Products
GROUP BY CAST(CreatedAt AS DATE)
ORDER BY ProductDate DESC;



-- it equipment max price wala 
Select MAX(StandardPrice) From Products
where Category = 'IT Equipment';

