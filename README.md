# MySQL Sales Analysis Project

A beginner-to-intermediate SQL portfolio project that demonstrates how
MySQL can be used to store, organize, analyze, and report on sales data.

The project includes a relational database, sample data, analysis
queries, indexes, views, stored procedures, and triggers for basic
inventory tracking.

## Table of Contents

-   [Project Overview](#project-overview)
-   [Objectives](#objectives)
-   [Technology Stack](#technology-stack)
-   [Project Structure](#project-structure)
-   [Database Schema](#database-schema)
-   [Setup and Execution](#setup-and-execution)
-   [Analysis Included](#analysis-included)
-   [Database Objects](#database-objects)
-   [How to Test the Project](#how-to-test-the-project)
-   [Important Notes](#important-notes)
-   [Possible Improvements](#possible-improvements)
-   [Author](#author)

## Project Overview

Sales data can help a business understand its revenue, identify popular
products, recognize valuable customers, and monitor inventory. This
project uses MySQL to demonstrate these tasks with a small sample retail
dataset.

The SQL scripts are arranged in execution order so that another person
can create the database, load the sample records, run the analysis, and
explore the database objects.

> **Note:** The data included in this project is sample data for
> learning and demonstration. It is not real business data.

## Objectives

-   Create a relational database for a simple sales system.
-   Create tables with relationships between customers, products,
    orders, and order items.
-   Insert sample records for testing.
-   Write beginner and intermediate SQL queries.
-   Analyze sales and revenue using joins and aggregate functions.
-   Create indexes for commonly queried columns.
-   Build reusable views for sales reporting.
-   Create stored procedures for repeatable reports.
-   Use triggers to validate and update product stock.
-   Record inventory changes in a stock audit table.

## Technology Stack

-   **Database:** MySQL 8.0 or later recommended
-   **SQL client:** MySQL Workbench or another compatible MySQL client
-   **Language:** SQL
-   **Project format:** `.sql` scripts and this Markdown documentation

## Project Structure

Run the numbered SQL scripts in order.

  -----------------------------------------------------------------------
  File                                Purpose
  ----------------------------------- -----------------------------------
  `01_create_database.sql`            Creates the project database.

  `02_create_tables.sql`              Creates the database tables.

  `03_insert_sample_data.sql`         Inserts the sample customers,
                                      products, orders, and order items.

  `04_beginner_queries.sql`           Contains basic SQL queries for
                                      exploring and filtering data.

  `05_intermediate_queries.sql`       Contains more advanced analysis
                                      using joins, grouping, and
                                      aggregates.

  `06_indexes.sql`                    Creates indexes to support selected
                                      query patterns.

  `07_views.sql`                      Creates reusable sales and revenue
                                      views.

  `08_stored_procedures.sql`          Creates stored procedures for
                                      repeatable reports.

  `09_triggers.sql`                   Creates triggers for stock
                                      validation, stock changes, and
                                      audit logging.

  `10_final_reports.sql`              Runs final business reports.

  `README.md`                         Project documentation and setup
                                      instructions.
  -----------------------------------------------------------------------

## Database Schema

The project uses five tables.

### 1. `customers`

Stores customer information, including customer identifiers and
contact/location details.

### 2. `products`

Stores product information such as product identifiers, names,
categories, prices, and stock quantities.

### 3. `orders`

Stores order-level information, including the customer associated with
an order, its date, and its status.

### 4. `order_items`

Stores the products and quantities associated with each order. This
table connects orders to products and supports item-level sales
analysis.

### 5. `stock_audit`

Stores a record of inventory changes made by the stock-management
triggers.

### Relationship overview

-   One customer can have multiple orders.
-   One order can contain multiple order items.
-   One product can appear in multiple order items.
-   The stock audit table records inventory changes.

Conceptually:

``` text
customers
   |
   | one-to-many
   v
orders
   |
   | one-to-many
   v
order_items
   ^
   | many-to-one
   |
products

stock_audit records inventory changes
```

Refer to `02_create_tables.sql` for the exact column definitions, keys,
and constraints.

## Setup and Execution

### Prerequisites

1.  Install MySQL Server.
2.  Install MySQL Workbench, or use another MySQL client.
3.  Extract the project ZIP into a folder on your computer.
4.  Make sure your MySQL server is running and that you can connect to
    it.

### Option A: Run the scripts in MySQL Workbench

1.  Open MySQL Workbench.
2.  Connect to your local MySQL server.
3.  Choose **File → Open SQL Script**.
4.  Open `01_create_database.sql`.
5.  Execute the script using the lightning-bolt **Execute** button.
6.  Open and execute each remaining numbered script in the order shown
    below.
7.  Check the Output or Action Output panel after each script. Resolve
    errors before proceeding.

### Required execution order

1.  `01_create_database.sql`
2.  `02_create_tables.sql`
3.  `03_insert_sample_data.sql`
4.  `04_beginner_queries.sql`
5.  `05_intermediate_queries.sql`
6.  `06_indexes.sql`
7.  `07_views.sql`
8.  `08_stored_procedures.sql`
9.  `09_triggers.sql`
10. `10_final_reports.sql`

### Option B: Run scripts using a MySQL command-line client

If the MySQL command-line client is installed and configured, you can
run a script with a command in this general format:

``` bash
mysql -u YOUR_USERNAME -p < 01_create_database.sql
```

Replace `YOUR_USERNAME` with your MySQL username. Enter your password
when prompted. Run each file from the project directory in the execution
order above. If a script depends on a database selected by an earlier
script, follow the database name and instructions in the SQL files.

Do not put your password directly into a command that may be saved in
shell history.

## Analysis Included

The query scripts demonstrate common sales-analysis tasks, including:

-   Viewing and filtering records.
-   Sorting results.
-   Combining related tables with joins.
-   Summarizing data with aggregate functions.
-   Grouping sales by relevant categories.
-   Reviewing product and category revenue.
-   Identifying top-performing products and customers.
-   Reviewing monthly revenue.
-   Checking cancelled orders and low-stock products.
-   Inspecting stock audit records.

Open the relevant SQL file to see each query and its exact logic.

## Database Objects

### Indexes

`06_indexes.sql` adds indexes to selected columns used in filtering,
joining, or grouping. Indexes can improve performance for suitable
queries, but they also use storage and can add overhead to data changes.
Performance benefits depend on the data size and query plan.

### Views

`07_views.sql` creates these views:

-   `v_completed_sales`
-   `v_product_revenue`
-   `v_category_revenue`

Views provide reusable named queries that can make reporting easier to
read and maintain. Check the view definitions for the exact columns and
calculations.

### Stored procedures

`08_stored_procedures.sql` creates these stored procedures:

-   `sp_sales_by_date`
-   `sp_top_products`
-   `sp_revenue_by_category`

Stored procedures package SQL logic for repeatable reporting tasks. Open
the script to review each procedure's required parameters and call
syntax before running it.

### Triggers and stock auditing

`09_triggers.sql` creates triggers that support basic inventory
tracking:

-   Checks stock before an order item is inserted.
-   Updates stock after an order item is inserted.
-   Checks stock changes before an order item is updated.
-   Adjusts stock after an order item is updated.
-   Restores stock after an order item is deleted.
-   Uses the `stock_audit` table to record inventory changes.

Review the trigger definitions before adapting this project for a real
application. Triggers can affect data changes automatically, so test
inserts, updates, and deletes carefully.

## How to Test the Project

After running the setup scripts:

1.  Refresh the **Schemas** panel in MySQL Workbench.
2.  Expand the project database and its **Tables** section.
3.  Confirm that the five tables exist.
4.  Run the beginner queries and inspect the result grids.
5.  Run the intermediate queries and compare their results.
6.  Confirm that the views were created successfully.
7.  Review the stored procedure definitions and call them using the
    parameters specified in the SQL file.
8.  Test the triggers only with controlled sample records, then inspect
    `stock_audit`.
9.  Run `10_final_reports.sql` to review the final reports.

You can use the following commands to inspect the database. Replace
`YOUR_DATABASE_NAME` with the exact name created in
`01_create_database.sql`.

``` sql
SHOW DATABASES;

USE YOUR_DATABASE_NAME;

SHOW TABLES;
```

To inspect views and stored procedures, use MySQL Workbench's schema
navigator or MySQL's metadata commands appropriate to your server
version.

## Important Notes

-   **Use a test database.** These scripts create database objects and
    insert or change data. Do not run them against a production
    database.
-   **Run sample data only once on a fresh setup.** Running
    `03_insert_sample_data.sql` again may cause duplicate-key errors or
    duplicate records, depending on the script.
-   **Indexes may not be safe to rerun.** Re-running `06_indexes.sql`
    can fail if the same indexes already exist.
-   **Initial stock and historical orders:** sample orders are inserted
    before the triggers are created. Therefore, the initial sample order
    records do not automatically reduce the stock values when the
    triggers are added later.
-   **Order status changes:** the stock triggers manage order-item
    insert, update, and delete operations. They do not automatically
    reverse or apply stock changes when an order's status changes. Treat
    this as a learning project, not a complete inventory system.
-   **Review SQL errors:** if a script fails, stop and resolve the error
    before running dependent scripts.
-   **Back up important data:** never experiment with trigger or
    inventory logic on data you cannot afford to lose.

## Possible Improvements

Ideas for extending the project:

-   Add a sales dashboard using Power BI, Tableau, or Excel.
-   Connect the database to Python for analysis and visualization.
-   Add more sample records to test performance.
-   Compare query execution plans with `EXPLAIN`.
-   Add automated tests for stock validation and audit records.
-   Add customer segmentation and repeat-purchase analysis.
-   Improve inventory handling so that order status transitions are
    handled consistently.
-   Add a data dictionary with every column's meaning and constraints.

## Author

**Project:** MySQL Sales Analysis\
**Purpose:** SQL learning and portfolio demonstration\
**Database:** MySQL

If you publish this project on GitHub, you can add your name, GitHub
profile, and any additional project details here.
