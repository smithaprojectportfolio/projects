USE [datasets]
GO

SELECT [RowID]
      ,[OrderID]
      ,[OrderDate]
      ,[ShipDate]
      ,[ShipMode]
      ,[CustomerID]
      ,[CustomerName]
      ,[Segment]
      ,[Country]
      ,[City]
      ,[State]
      ,[PostalCode]
      ,[Region]
      ,[ProductID]
      ,[Category]
      ,[SubCategory]
      ,[ProductName]
      ,[Sales]
      ,[Quantity]
      ,[Discount]
      ,[Profit]
  FROM [dbo].[superstore]

GO


--sHIPPING MODES
select distinct ShipMode
from Superstore


select [ProductID],customerid, count(*)
from superstore
group by  [ProductID], customerid
having count(*)>1

select * 
from superstore
where productid= 'FUR-BO-10000330'


--surrogate key,ganularity
--customerid doesnt make sense
--always orderid,productid is mandate(2 columns together make a primary key and its called composite key)
select [Orderid], productid,count(*)
from superstore
group by   [Orderid],ProductID
having count(*)>1

select * 
from superstore
where productid= 'FUR-FU-10003664' and orderID = 'CA-2016-137043'

SELECT *
    FROM superstore
    WHERE RowID NOT IN
    (
        SELECT MAX(rowID)
        FROM superstore
        GROUP BY [OrderID], 
                 [ProductID]          
    )
--Removing duplicates from key columns
	DELETE FROM superstore
    WHERE RowID NOT IN
    (
        SELECT MAX(RowID) AS MaxRecordID
        FROM superstore
        GROUP BY [OrderID], 
                 [ProductID]          
    )

--alternative to remove duplicates - select clean records using CTE

with superstorederived
as
(
select * From superstore_copy where rowid in 
(select min(rowid) from superstore_copy group by orderid,productid)
)
select * From superstorederived

--alternative to remove duplicates - select clean records using temp table
drop table if exists #superstorederived
select
*
into #superstorederived
From superstore_copy where rowid in 
(select min(rowid) from superstore_copy group by orderid,productid)

select * From #superstorederived

--different shipping mode used in the super store
select distinct shipmode 
from
superstore

--Identify the state with the highest profits
select state,country, sum(profit) TotalProfit from superstore
group by State, country
order by sum(profit) desc

--Total sales for each state
select State , sum(sales) TotalSales
from superstore
group by state
order by sum(sales) desc


--Top 10 sub-categories with most sales (identify the category the sub-category belongs to)
select top 10 * from
(select  SubCategory, sum(sales) TotalSale
from superstore 
Group by SubCategory
) A
order by TotalSale desc


select  Top 10 SubCategory, sum(sales) TotalSale
from superstore
Group by SubCategory
order by TotalSale desc

select * from (select  subcategory, sum(sales) TotalSale , 
	rank() over ( order by sum(sales)desc) rn
from superstore
group by SubCategory) A
where rn<=10


--Average shipping days by state
select State from (SELECT
 DATEDIFF(Day, orderdate, ShipDate) AS shippingdates, *
FROM superstore)A
Group by State
 

SELECT
State,AVG( DATEDIFF(Day, orderdate, ShipDate)) AS Avg_shippingdays
FROM superstore  
group by State
order by Avg_shippingdays asc


Select State, avg(shippingdays) as avg_shippingdays from 
(
SELECT
State,DATEDIFF(Day, orderdate, ShipDate) AS shippingdays
FROM superstore ) A
group by State



--identify the states which have the quickest shipping

	SELECT
	top 23 State,AVG( DATEDIFF(Day, orderdate, ShipDate)) AS Avg_shippingdays, 
	rank () over (order by AVG( DATEDIFF(Day, orderdate, ShipDate))) as rnk
	FROM superstore  
	group by State

	SELECT
	 State,AVG( DATEDIFF(Day, orderdate, ShipDate)) AS Avg_shippingdays, 
	rank () over (order by AVG( DATEDIFF(Day, orderdate, ShipDate))) as rnk
	FROM superstore  
	group by State


--copy dataset
select * into superstore_clean from superstore
