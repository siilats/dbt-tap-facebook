with ads_insights as (

     select *
     from {{ref('fb_ads_insights')}}

)

select

  account_name,

  -- The start of the month this report is for
  to_char(MIN(insights_date), 'YYYY-MM') as month,
  date_trunc('month', MIN(insights_date))::date as month_start,

  -- Generate a descriptive label: "2020-02 | Account"
  CONCAT
  (
    to_char(MIN(insights_date), 'YYYY-MM'), ' | ', account_name
  ) as label,

  SUM(impressions) as impressions,
  SUM(reach) as reach,
  round(1.0 * SUM(impressions) / NULLIF(SUM(reach), 0), 2) as frequency,

  SUM(clicks) as clicks,
  SUM(inline_link_clicks) as inline_clicks,

  SUM(spend) as spend,

  round(SUM(spend) / NULLIF(SUM(clicks), 0), 2) as cpc,
  round(SUM(spend) / NULLIF(SUM(inline_link_clicks), 0), 2) as inline_cpc,

  round((SUM(spend) / NULLIF(SUM(impressions), 0))  * 1000, 2) as cpm,

  round((1.0 * SUM(clicks) / NULLIF(SUM(impressions), 0)) * 100, 2) as ctr,
  round((1.0 * SUM(inline_link_clicks) / NULLIF(SUM(impressions), 0)) * 100, 2) as inline_ctr,

  SUM(results) as results,

  -- Result Rate from Click: ((Results / Click) * 100) %
  round((1.0 * SUM(results) / NULLIF(SUM(clicks), 0)) * 100, 2) as results_from_clicks,
  round((1.0 * SUM(results) / NULLIF(SUM(inline_link_clicks), 0)) * 100, 2) as results_from_inline_clicks,

  -- Cost Per Result: Spend / Results
  round(SUM(spend) / NULLIF(SUM(results), 0), 2) as cost_per_result

from ads_insights

group by
  insights_year,
  insights_month,
  account_name

order by
  insights_year,
  insights_month,
  account_name
