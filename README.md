# 📊 O-list E-Commerce Business Analytics

## 📋 Project Overview
This project transforms **100k+ rows** of raw Brazilian e-commerce data into interactive dashboards using **Tableau** and **SQL**. The goal is to generate meaningful business insights that drive strategic marketing and operational improvements. 

The analysis focuses on four key business pillars:
1. **Customer Insights**
2. **Seller Performance**
3. **Logistics Efficiency**
4. **Sales and Revenue Trends**

---

## 🛠️ Technical Stack
* **Data Inspection & Cleaning:** `Python` (Pandas, NumPy, Matplotlib, Seaborn)
* **Database Management:** `MySQL` (Advanced SQL: CTEs, Window Functions, Joins, Aggregations)
* **Business Intelligence:** `Tableau` (Interactive Dashboards, Time-Series Forecasting)
* **Original Database Source:** [Brazilian E-commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

---
## 📂 Repository Structure
```text
├── data/                   # Dataset link and source documentation
├── notebooks/              # Python notebooks for data cleaning and EDA
├── sql_scripts/            # SQL queries for database management and metric calculation
├── plots/                  # Static visualization exports (correlation maps, distributions)
└── README.md               # Project documentation
```
---

## 🛠️ Dashboards:
## 📈 Dashboards & Analysis

### <a href="https://public.tableau.com/app/profile/micah.theresse.fajardo/viz/OlistE-commerceCustomerAnalytics/Dashboard1"> 1) Customer's Insights Dashboard </a>
**Description:** This dashboard describes customers' distribution according to state, city, type, and payment type. Data can be investigated by year and other interactive filter features.

#### **Key Insights**
* **Regional Analysis:** The customer base is highly concentrated in **São Paulo (SP)**, Brazil, followed by nearby states **Minas Gerais (MG)** and **Rio de Janeiro (RJ)**.
* **Retention Challenges:** While the "Daily customer" metric showed a promising trend over time, **"Recency"** was plummeting significantly. Only about **3.03%** of the total 94,398 customers are returning buyers.
    * *Additional Info:* I created a <a href="https://github.com/micahfajardo/olist_ecommerce_data_analysis/blob/main/plots/repurchasing_correlations.png"> correlational map </a>which found no significant relationships between frequency and price, freight, or review scores.
* **Customer Segmentation:** The base is split almost evenly across 4 segments. **Loyal customers** show a purchase frequency of around **1.25**, barely higher than one-time buyers. **Premium customers** have a budget of **R$260-280**, while low-budget customers average **R$60**.
    * *Note:* View the **distribution plots** for data support.
* **Payment Preference:** A significant portion of **Premium Customers** rely on **long-term installment plans** (up to 10 months), indicating high sensitivity to payment flexibility.

#### **Recommendations**
* **Logistics:** Establish a **distribution hub** within or near São Paulo to reduce third-party courier costs and improve delivery times.
* **CRM Strategy:** Implement a robust **Loyalty Program** with "second-purchase" vouchers and tiered rewards to increase the frequency of one-time buyers.
* **Fintech Opportunity:** Develop an **in-house E-wallet** to capture interest income currently going to banks and offer promotional "low-interest" periods.

---

### <a href="https://public.tableau.com/app/profile/micah.theresse.fajardo/viz/OlistE-commerceSalesRevenueAnalytics/Dashboard1#2"> 2) Sales and Revenue Analytics <a href="">
#### **Key Insights**
* **Revenue Hubs:** Revenue is highly concentrated in **SP, RJ, and MG**, suggesting that marketing spend in these regions is highly efficient.
    * *Note:* Based on <a href="http://news.bbc.co.uk/2/hi/americas/8702891.stm"> National Census data </a>, profitable expansion should target wealthy states like **Rio Grande do Sul** and **Paraná**.
* **Growth Plateau:** After a "hyper-growth" phase from 2016 to 2017, growth stabilized to **~20% YoY in 2018**. The 12-month forecast suggests a **plateau**, indicating market saturation.
* **Volume vs. Value:** **Health & Beauty** ranks highest in revenue. By units sold, **Furniture & Decor** ranks highest, followed by **Computer Accessories** (which also ranks high in total revenue).
    * *Additional Info:* Order cancellation is low (**<1%**). An <a href="https://github.com/micahfajardo/olist_ecommerce_data_analysis/blob/main/plots/cancelled%20orders_correlations.png"> order cancellation correlational map </a> found a significant link between cancellations and a seller's historical cancellation rate.

#### **Recommendations**
* **Fee Structure:** Increase platform fees for **high-volume/low-margin categories** (Furniture) and lower them for **high-value categories** (Computer Accessories) to attract premium sellers.
* **Cross-Selling:** Offer marketing incentives to bundle **Health & Beauty** items with home goods to increase **Average Order Value (AOV)**.
* **Quality Control:** Penalize sellers with a high rate of order cancellation to maintain platform trust.

---

### <a href="https://public.tableau.com/app/profile/micah.theresse.fajardo/viz/O-listSellersandLogisticsAnalytics/Dashboard1"> 3) Sellers Performance and Logistics efficiency <a href="">
#### **Key Insights**
* **Processing Efficiency:** The average delivery cycle is **13 days**. While 90% of orders are on-time, **9 days (70%)** are spent in transit, indicating transportation as the main bottleneck.
* **Seller Distribution:** Mirrors the customer base. In 2018, there were **2,355 sellers**, but high regional reliance creates a **"single point of failure."**
* **Performance Metrics:** Sellers maintain a high average rating (**4.2/5 stars**), but average annual revenue is relatively low at **R$8,000**, suggesting a marketplace of SMBs.

#### **Recommendations**
* **Fulfillment Center:** Establish a **"Cross-Docking" or Fulfillment Center** in São Paulo to cut delivery times by **40–50%** for the primary SP-RJ-MG corridor.
* **Seller Recruitment:** Target recruitment of **Health & Beauty** sellers outside the Southeast to diversify the market and place inventory closer to regional customers.
* **Enablement:** Offer **Seller Analytics Tools** (like this dashboard) to help SMBs scale into **"Power Sellers"** (R$50k+ revenue).

## ⚠️ Challenges & Solutions

| Challenge | Solution |
| :--- | :--- |
| **Data Volume & Import:** Importing 100k+ rows via standard SQL inserts was slow and prone to timeout errors. | Utilized **MySQL `LOAD DATA LOCAL INFILE`** scripts to bypass traditional insert overhead, reducing import time from minutes to seconds. |
| **Complex Segmentation:** Standard filtering was insufficient to categorize customers by both lifetime value and purchase frequency. | Developed a **Custom RFM Model** in SQL using **CTEs and Window Functions** to assign specific segments (e.g., "Premium," "Loyal") based on quartile distributions. |
| **Skewed Distributions:** 97% of customers were one-time buyers, making traditional "average" metrics for frequency misleading. | Applied **Logarithmic Scaling** in Python/Seaborn visualizations to accurately inspect the long-tail distribution and identify the "Returning" buyer subset. |


