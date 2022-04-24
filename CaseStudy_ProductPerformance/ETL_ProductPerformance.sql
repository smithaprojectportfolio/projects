USE [AdventureWorksDW2019]
GO


--> (1) Determine total sales in USD for each product

--Convert the SalesAmount into USD Currency by using the currency key 
--(Can get the USD rate from FactCurrencyRate based on Currency Key)

Drop table if exists #temp_salesamountusd
select 
F.ProductKey, 
sum(F.SalesAmount*FC.EndOfDayRate) as SalesAmountinUSD
into #temp_salesamountusd
from FactInternetSales F 
inner join 
DimCurrency D
on F.Currencykey = D.CurrencyKey
inner join 
FactCurrencyRate FC
on D.currencykey = FC.currencykey and F.orderdatekey = Fc.DateKey
Group by F.ProductKey

	
-- Determine product category and other product attributes
Drop table if exists STG_ProductSales
select A.*, DP.EnglishProductName as ProductName, DPC.EnglishProductCategoryName as ProductCategoryName
into STG_ProductSales
From #temp_salesamountusd A inner join DimProduct DP 
	ON A.Productkey = DP.ProductKey
	Inner join DimProductSubcategory DPS
	on DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
	inner join  DimProductCategory DPC
	on DPC.ProductCategoryKey = DPS.ProductCategoryKey
	


--> (2) Determine total sales in USD for each customer

-- Convert the sales amount in USD and determine total sales for each customer key
Drop table if exists #temp_salesamountusd_Cust
select 
F.CustomerKey, 
sum(F.SalesAmount*FC.EndOfDayRate) as SalesAmountinUSD
into #temp_salesamountusd_Cust
from FactInternetSales F 
inner join 
DimCurrency D
on F.Currencykey = D.CurrencyKey
inner join 
FactCurrencyRate FC
on D.currencykey = FC.currencykey and F.orderdatekey = Fc.DateKey
Group by F.CustomerKey


-- Determine customer attributes
	Drop table if exists STG_CustomerSales
select A.*,  firstName+' '+' '+MiddleName+' '+' '+LastName as CustName,EmailAddress
into STG_CustomerSales
From #temp_salesamountusd_Cust A inner join DimCustomer DC
	ON A.Customerkey = DC.CustomerKey








