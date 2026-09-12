# SaaS Subscription Revenue & Cohort Retention Analysis

## Business Problem
Which customer segments and acquisition channels drive sustainable, retained
revenue — and where should retention/spend be reallocated to improve Net
Revenue Retention (NRR) and LTV:CAC?

## Dataset
Subscription billing data for 5,000 SaaS customers over a 24-month window
(Jan 2023–Dec 2024): signup date, segment, acquisition channel, plan tier,
starting/current MRR, churn date, upgrade activity, and CAC.
*(Note: this dataset is modeled to mirror a real Stripe/Chargebee billing
export. The SQL and analysis approach transfer directly onto a real billing
export with the same schema.)*

## Approach
1. Load raw billing data (`raw_subscriptions`).
2. Compute headline metrics — active customers, MRR, logo churn, revenue
   churn, NRR — overall and by segment (`sql/01_mrr_and_churn.sql`).
3. Compute CAC and an LTV:CAC proxy by acquisition channel.
4. Track plan-tier upgrade/expansion rates.
5. Build an interactive dashboard (`dashboard/dashboard.html`) from the
   segment- and channel-level summaries to visualize the findings.

## Tech Stack
MySQL · HTML/CSS/JavaScript (Chart.js) for the dashboard

## Key Findings (computed on the analysis dataset)
- **Overall logo churn is 33.1%** across 5,000 customers, leaving 3,347
  active accounts and **$637,823 in current MRR**.
- **Segment retention is highly uneven**: Enterprise customers churn at only
  **13.3%** and show **101.2% NRR** (net expansion — this segment is growing
  revenue even as some accounts churn). Mid-Market sits at **26.7% churn /
  92.2% NRR**. SMB is the weak point: **41.1% churn** and just **74.6% NRR**
  — this segment is losing revenue faster than it's replacing it.
- **Acquisition channel efficiency varies enormously**: Organic has the best
  LTV:CAC ratio (**6.2x**) at only $60 average CAC, while Outbound Sales is
  the worst (**0.29x** — CAC of $1,341 far exceeds the revenue an average
  customer returns). Paid Search is also underwater at 0.94x.
- **Upgrade/expansion rates are low across the board** (9–10% for Starter/
  Growth/Scale, 0% for Enterprise since it's the top tier) — expansion
  revenue is not currently a meaningful growth lever.

## Recommendations
1. **Prioritize SMB retention** — it's the largest segment (2,781 customers)
   but the biggest revenue leak (74.6% NRR). Even a modest churn reduction
   here has outsized dollar impact versus the smaller Enterprise segment.
2. **Reallocate acquisition spend away from Outbound Sales and Paid Search**
   toward Organic and Referral, which return 4–6x more LTV per dollar of CAC.
   Outbound Sales may still be justified for landing large Enterprise
   accounts specifically — worth segmenting CAC/LTV by channel *and* segment
   together as a follow-up analysis.
3. **Build an expansion/upsell motion** — with upgrade rates stuck at ~9-10%,
   there's likely untapped expansion revenue sitting in the Starter and
   Growth tiers that a dedicated customer-success or upsell campaign could
   capture.

## Dashboard
An interactive dashboard is included at `dashboard/dashboard.html` —
download and open it in any browser (no server required) to view the
segment retention chart, channel efficiency ranking, and recommendations
in a visual layout.

## Repo Structure
```
saas-revenue-retention/
├── README.md
├── summary.md
├── subscriptions_raw.csv          <- raw dataset
├── dashboard_segment_summary.csv  <- segment-level summary data
├── dashboard_channel_summary.csv  <- channel-level summary data
├── dashboard_customer_level.csv   <- customer-level detail data
├── dashboard/
│   └── dashboard.html             <- interactive dashboard
└── sql/
    └── 01_mrr_and_churn.sql
```

## Author
Rishabh Pandey — linkedin.com/in/rishabhpandey182006
