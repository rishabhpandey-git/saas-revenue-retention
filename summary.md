# One-Page Summary — SaaS Subscription Revenue & Retention Analysis

**Business Question:** Which segments and acquisition channels drive
sustainable retained revenue, and where should spend and retention effort
be reallocated?

**Method:** Analyzed 24 months of billing data for 5,000 SaaS customers in
SQL — computed logo churn, Net Revenue Retention (NRR), and LTV:CAC by
segment and acquisition channel. Visualized in Tableau.

**Key Findings:**
1. Overall logo churn = 33.1%; current MRR = $637,823 across 3,347 active accounts.
2. SMB is the weak point: 41.1% churn, 74.6% NRR (losing revenue net).
   Enterprise is strongest: 13.3% churn, 101.2% NRR (net expansion).
3. Organic acquisition returns 6.2x LTV:CAC at $60 CAC; Outbound Sales
   returns only 0.29x at $1,341 CAC — currently unprofitable at scale.
4. Plan upgrade/expansion rate is flat at ~9-10% across tiers — an
   underused growth lever.

**Recommendations:**
1. Prioritize SMB retention initiatives — largest segment, biggest leak.
2. Shift acquisition spend from Outbound Sales/Paid Search toward
   Organic/Referral, unless Outbound is reserved specifically for
   large Enterprise deals.
3. Build a dedicated expansion/upsell motion to lift the ~9-10% upgrade rate.

**Dashboard:** Interactive dashboard included at `dashboard/dashboard.html`
**Full Analysis:** See `sql/01_mrr_and_churn.sql` in this repo
