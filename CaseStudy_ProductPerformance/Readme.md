# Project Overview

As part of this project, I make use of the open source datasets from AdventureWorkDW and analyse the product performance based on internet sales. Adding on, I determine the top tier customers of the business with intention to share promotional offers to convey appreciation & gratitude.

* The project folder contains the following:
    * **Datamapping_Source_to_target.xlsx** - The document defines the source to target column mappings
    * **ETL_ProductPerformance.sql** - ETL scripts that apply the business logic to derive the OLAP cubes
     * **Dashboard_ProductSales.pdf & Dashboard_TopCustomer.pdf** - Dashboards that identify the best & worst product in terms of total sales and also the top tier customers in the business
> **Note: In this project, I have demonstrated my familiarity in the following: OLAP cube design, data mapping between source & target tables, sql scripts to perform the ETL and dashboard design & development in Power BI**

# Project work flow
* The first step in the project is to prepare a data mapping document that helps the developers to understand the source & target column mappings and what transformations/rules to be applied
* The ETL developers can then leverage the data mapping document and develop the required ETL scripts to ingest the OLAP cubes
* Power BI developers can then use the OLAP cubes as the source data sets to develop dashboards for the KPIs
