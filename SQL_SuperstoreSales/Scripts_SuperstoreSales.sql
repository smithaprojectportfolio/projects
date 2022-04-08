/*
Please go through the csv file containing the dataset and the project objective document for more context on the queries below
*/

USE [datasets]
GO

/* 
As a first step, import the csv file containing the data set into an SQL table "superstore". Once the import is successful,
run a select query on the table to ensure the csv dataset has been imported into the table
*/

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

-- Query 1 : Determine the available shipping modes for the order delivery

select distinct ShipMode
from dbo.Superstore


-- Query 2 : Identify the key columns of the data set. Group the data by orderid and productid and determine if the combinations repeat.
-- Query 3 : Check if there are duplicate records for the key columns. If yes, clean up the data set by remove duplicate rows for the key columns

select [Orderid], [ProductID], count(*)
from superstore
group by  [Orderid], [ProductID]
having count(*)>1

/*
Observation: Order id and product id seems to be the potential key columns, however, the query has returned duplicates for few order ids and product ids. 
Further analysis required to see the cause for the duplicates
*/

select * 
from superstore
where productid= 'FUR-FU-10003664' and orderID = 'CA-2016-137043'

/*
Observation: Looks like there are more than one records for the selected orderid and product id, however, all the column values are same which implies the data
is just duplicated and should be cleaned up
*/


--Removing duplicates from key columns
	DELETE FROM superstore
    WHERE RowID NOT IN
    (
        SELECT MAX(RowID) AS MaxRecordID
        FROM superstore
        GROUP BY [OrderID], 
                 [ProductID]          
    )


-- Query 4 : Identify the states with the highest profits

select state,country, sum(profit) TotalProfit from superstore
group by State, country
order by sum(profit) desc

-- Query 5 : Total sales for each state
select State , sum(sales) TotalSales
from superstore
group by state
order by sum(sales) desc


--Query 6 : Top 10 sub-categories with highest sales

select  Top 10 subcategory, sum(sales) TotalSale
from dbo.superstore
Group by subcategory
order by sum(sales) desc

-- Alternatively, can use rank function to select top 10 subcategory by total sales
select * from (select  subcategory, sum(sales) TotalSale , 
	rank() over ( order by sum(sales)desc) rn
from superstore
group by SubCategory) A
where rn<=10


--Query 7 : Average days it takes to ship a product for each state

SELECT
State,AVG( DATEDIFF(Day, orderdate, ShipDate)) AS Avg_shippingdays
FROM superstore  
group by State
order by Avg_shippingdays asc


--Query 8 : Identify the states which have the quickest shipping

	SELECT
	 State,AVG( DATEDIFF(Day, orderdate, ShipDate)) AS Avg_shippingdays, 
	rank () over (order by AVG( DATEDIFF(Day, orderdate, ShipDate))) as rnk
	FROM superstore  
	group by State
