# 🚀 Enterprise Global Supply Chain & Inventory Analytics Engine

An enterprise-grade SQL Server relational database system simulating a global supply chain, inventory tracking, and sales ecosystem. Designed with high-performance standards, strict data integrity (ACID), automated auditing, and advanced analytics.

---

## ⚠️ Common Enterprise Challenges & How This Project Solved Them

In large-scale supply chain and inventory management systems, several critical database-level challenges frequently arise. Here is how this project addresses and solves each one:

### 1. The Inventory Race Condition & Negative Stock Problem
* **The Problem:** In high-concurrency environments (multiple sales or orders happening simultaneously), two transactions might read the same available stock level at the exact same time, leading to overselling and dropping inventory below zero (negative stock).
* **The Solution:** 
  * Implemented robust **Stored Procedures** wrapped within explicit **Transactions (`BEGIN TRANSACTION`, `COMMIT`, `ROLLBACK`)** and strict error handling (`TRY...CATCH`).
  * Utilized row-level data checks and explicit validation steps to ensure that no sale can be completed if the requested quantity exceeds the actual stock, protecting business logic from corruption.

### 2. Data Integrity and Unmonitored Price Tampering
* **The Problem:** Unauthorized or accidental modifications to product pricing can cause severe financial discrepancies and tracking failures without leaving a trace of who made the change or when.
* **The Solution:** 
  * Deployed **DML Triggers (`AFTER UPDATE`)** that automatically monitor changes on sensitive columns (such as `UnitPrice`).
  * Every price alteration instantly triggers an automated insertion into a secure **`PriceAuditLog`** table, capturing the old price, new price, timestamp, and the exact database user (`SYSTEM_USER`) who performed the action.

### 3. Lack of Real-Time Visibility and Stockout Risks
* **The Problem:** Companies often face sudden stockouts because they lack automated tracking of items falling below critical thresholds, leading to delayed restocks and lost revenue.
* **The Solution:** 
  * Built advanced **SQL Views** integrated with conditional `CASE` statements (`vw_InventoryStockStatus`) that dynamically categorize inventory health into `OPTIMAL`, `WARNING: REORDER NEEDED`, or `OUT OF STOCK` in real-time.

### 4. Complex Analytical Reporting Overhead
* **The Problem:** Calculating customer rankings, spending summaries, and monthly performance trends using traditional subqueries or cursors can severely degrade database performance.
* **The Solution:** 
  * Leveraged high-performance **Window Functions (`DENSE_RANK()`, `SUM OVER`)** within optimized views (`vw_CustomerPurchaseSummary`) to compute rankings and financial aggregations efficiently without heavy computational overhead.

---

## 🛠️ Technical Stack & Architecture

* **Database Management System:** Microsoft SQL Server (T-SQL)
* **Architecture Pattern:** Normalized Relational Database (OLTP Design)
* **Core Components:**
  * **Tables & Constraints:** Primary Keys, Foreign Keys, `CHECK` constraints, and Unique constraints ensuring strict referential integrity.
  * **Programmability:** Stored Procedures with `OUTPUT` parameters, Error Handling, and Transactions.
  * **Automation:** DML Triggers for security auditing.
  * **Analytics:** Complex Views utilizing Window Functions and Conditional Logic.

---

## 📂 Project Structure

```text
├── Database_Setup/
│   ├── 01_Create_Tables.sql       # Schema definitions and relational constraints
│   └── 02_Seed_Data.sql           # Initial dummy data for testing
├── Programmability/
│   ├── 03_Views.sql               # Analytical views and inventory status alerts
│   ├── 04_Stored_Procedures.sql   # Transaction-safe order processing engine
│   └── 05_Triggers.sql            # Automated audit logging triggers
├── Tests/
│   └── 06_Test_Scripts.sql        # Integration tests for procedures, views, and triggers
└── README.md