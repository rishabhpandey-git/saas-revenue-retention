/* ============================================================
   01_mrr_and_churn.sql
   Project: SaaS Subscription Revenue & Cohort Retention Analysis
   Purpose: Compute headline SaaS metrics — active customers, MRR,
            logo churn rate, revenue churn, and NRR by segment.
   Input:   raw_subscriptions (customer_id, signup_date, segment,
            acquisition_channel, initial_plan, initial_mrr,
            churn_date, upgraded_plan, final_mrr, cac)
   ============================================================ */

-- 1. Overall book of business snapshot
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_date IS NULL THEN 1 ELSE 0 END) AS active_customers,
    SUM(CASE WHEN churn_date IS NOT NULL THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN churn_date IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS logo_churn_rate_pct,
    SUM(final_mrr) AS current_total_mrr
FROM raw_subscriptions;

-- 2. Churn and MRR by segment
SELECT
    segment,
    COUNT(*) AS customers,
    SUM(CASE WHEN churn_date IS NOT NULL THEN 1 ELSE 0 END) AS churned,
    ROUND(100.0 * SUM(CASE WHEN churn_date IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct,
    SUM(initial_mrr) AS starting_mrr,
    SUM(final_mrr) AS current_mrr,
    ROUND(100.0 * SUM(final_mrr) / NULLIF(SUM(initial_mrr), 0), 1) AS net_revenue_retention_pct
FROM raw_subscriptions
GROUP BY segment
ORDER BY current_mrr DESC;

-- 3. CAC and LTV:CAC ratio by acquisition channel
-- LTV approximated here as final_mrr / churn_rate (simple SaaS LTV proxy)
WITH channel_stats AS (
    SELECT
        acquisition_channel,
        COUNT(*) AS customers,
        AVG(cac) AS avg_cac,
        SUM(CASE WHEN churn_date IS NOT NULL THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS churn_rate,
        AVG(final_mrr) AS avg_current_mrr
    FROM raw_subscriptions
    GROUP BY acquisition_channel
)
SELECT
    acquisition_channel,
    customers,
    ROUND(avg_cac, 2) AS avg_cac,
    ROUND(churn_rate * 100, 2) AS churn_rate_pct,
    ROUND(avg_current_mrr, 2) AS avg_current_mrr,
    -- simple LTV proxy: avg_mrr / churn_rate (skip if churn_rate is 0)
    ROUND(avg_current_mrr / NULLIF(churn_rate, 0), 2) AS ltv_proxy,
    ROUND((avg_current_mrr / NULLIF(churn_rate, 0)) / NULLIF(avg_cac, 0), 2) AS ltv_to_cac_ratio
FROM channel_stats
ORDER BY ltv_to_cac_ratio DESC;

-- 4. Plan-level upgrade/expansion tracking
SELECT
    initial_plan,
    COUNT(*) AS customers,
    SUM(CASE WHEN upgraded_plan IS NOT NULL THEN 1 ELSE 0 END) AS upgraded_customers,
    ROUND(100.0 * SUM(CASE WHEN upgraded_plan IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS upgrade_rate_pct
FROM raw_subscriptions
GROUP BY initial_plan
ORDER BY customers DESC;
