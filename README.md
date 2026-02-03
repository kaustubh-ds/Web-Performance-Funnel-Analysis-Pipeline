# Shopify to BigQuery Data Warehouse & Analytics Pipeline

## Project Overview
Architected a permanent data warehouse solution to overcome the limitations of standard Google Analytics 4 (GA4) reporting.

By linking Shopify data streams to Google BigQuery, I established a raw, unsampled data pipeline that allows for:
* **Historical Data Archival:** Permanent storage of user behavior data beyond the 14-month retention window.
* **Advanced Funnel Analysis:** SQL-based "drop-off" auditing to identify specific friction points in the checkout flow.
* **Granular Performance Tracking:** Monitoring the impact of UI updates (like Collection Revamps) on user engagement.

## Tech Stack
* **Source:** Shopify (e-Commerce)
* **Ingestion:** Google Analytics 4 (GA4) Data Stream
* **Warehouse:** Google BigQuery (SQL)
* **Visualization:** Looker Studio / BigQuery Console

## Repository Structure
* `/queries`: Contains the production SQL scripts used for weekly audits.
* `/assets`: Screenshots of the architecture and pipeline setup.

## Key Analytics Modules

### 1. The "Weekly Drop-Off" Audit
A comprehensive funnel analysis that tracks unique users across 5 key stages:
`Session Start` -> `View Item` -> `Add to Cart` -> `Begin Checkout` -> `Purchase`.
* **Business Value:** Identifies exactly where users are abandoning the journey (e.g., detecting "Shipping Shock" at the checkout phase).

### 2. High-Performance Page Tracking
Unnests complex GA4 event parameters to rank the top 10 URLs by unique visitors.
* **Business Value:** Validates the visibility of new "Collection" pages and flags broken links (404s) in high-traffic areas.

## Architecture & Proof of Implementation
![Architecture Setup](architecture_setup.png)

## Data Pipeline Flowchart

```mermaid
graph TD
    subgraph "Data Sources"
        A[Shopify Store] -->|User Actions| B(Google Analytics 4)
    end

    subgraph "Data Pipeline"
        B -->|Daily Auto-Export| C{BigQuery Data Warehouse}
        C -->|Sharded Tables| D[(Raw Events Database)]
    end

    subgraph "Analytics Engine"
        D -->|SQL Query: Weekly Funnel| E[Drop-Off Analysis]
        D -->|SQL Query: Top Pages| F[Content Performance]
    end

    style C fill:#4285F4,stroke:#333,stroke-width:2px,color:white
    style D fill:#EA4335,stroke:#333,stroke-width:2px,color:white
