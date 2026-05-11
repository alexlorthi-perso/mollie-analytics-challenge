# Mollie Analytics Challenge

This repository contains my submission for the Mollie Analytics Challenge. It includes a commercial analysis of acquisition channels and technical SQL solutions based on the provided schemas.

---

## 📂 Project Structure

* **`/reports`**: Contains the final 3-page report and presentation slidedeck[cite: 8, 16].
* **`/sql`**: SQL scripts for Question 2A (Custom Pricing Updates) and 2B (Fee Inference)[cite: 74, 79].
* **`/notebooks`**: (Optional) Python/R scripts or Excel-linked calculations used for the commercial analysis.
* **`/data`**: Placeholder for the provided fabricated datasets (Note: Raw data is git-ignored to maintain repository cleanliness)[cite: 24, 25].

---

## 📊 Part 1: Commercial Analysis
**Objective:** Assess core competencies in data analysis and provide strategic recommendations to Mollie[cite: 6, 7].

### Key Assumptions & Constraints:
* **Acquisition Costs:** Total monthly cost for each channel is €10,000[cite: 20].
* **Pricing Logic:** Calculations applied based on the fixed and variable rates for payment methods 3, 11, 17, and 19[cite: 21, 26].
* **Data Quality:** Handled as "imperfect" real-world data[cite: 25].

---

## 💻 Part 2: SQL Assessment
**Objective:** Demonstrate proficiency in writing complex SQL queries using provided table schemas[cite: 11, 34].

### Query 2A: Custom Pricing Updates
* **Goal:** Generate a table showing chronological updates to custom pricing, including old and new rates[cite: 74, 75].
* **Technique:** Utilized window functions (e.g., `LAG`) to compare historical pricing records.

### Query 2B: Total Fee Inference
* **Goal:** Calculate the total fee (fixed + variable) per payment[cite: 79, 88].
* **Logic:** Prioritizes `custom_pricing` when active, falling back to `default_pricing` based on the `payment_date`[cite: 87, 88].

---

## 🛠️ Tools Used
* **Data Analysis:** [XXX]
* **Visualization:** [XXX]
* **Database:** SQL

---

## 📝 Contact
**Name:** Alexandre
**Application:** Data Analyst Case Study