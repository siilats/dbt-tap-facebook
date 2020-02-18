with ads_insights as (

     select *
     from {{ref('fb_ads_insights')}}

)

select

  account_name,
  campaign_name,
  adset_name,
  ad_name,

  -- The start of the month this report is for
  to_char(MIN(insights_date), 'YYYY-MM') as month,
  date_trunc('month', MIN(insights_date))::date as month_start,

  -- Generate a descriptive label: "2020-02 | Ad name | Adset | Campaign"
  CONCAT
  (
    to_char(MIN(insights_date), 'YYYY-MM'), ' | ',
    ad_name, ' | ', adset_name, ' | ', campaign_name, ' | ', account_name
  ) as label,

  SUM(results) as results,

  -- Result Rate from Click: ((Results / Click) * 100) %
  round((1.0 * SUM(results) / NULLIF(SUM(clicks), 0)) * 100, 2) as results_from_clicks,

  round((1.0 * SUM(results) / NULLIF(SUM(inline_link_clicks), 0)) * 100, 2) as inline_results_from_clicks,

  -- Cost Per Result: Spend / Results
  round(SUM(spend) / NULLIF(SUM(results), 0), 2) as cost_per_result

from ads_insights

group by
  insights_year,
  insights_month,
  account_name,
  campaign_name,
  adset_name,
  ad_name

order by
  insights_year,
  insights_month,
  ad_name,
  adset_name,
  campaign_name,
  account_name
