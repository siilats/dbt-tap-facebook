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

  SUM(impressions) as impressions,
  SUM(reach) as reach,
  round(1.0 * SUM(impressions) / NULLIF(SUM(reach), 0), 2) as frequency,

  SUM(clicks) as clicks,
  round((1.0 * SUM(clicks) / NULLIF(SUM(impressions), 0)) * 100, 2) as ctr,

  SUM(inline_link_clicks) as inline_clicks,
  round((1.0 * SUM(inline_link_clicks) / NULLIF(SUM(impressions), 0)) * 100, 2) as inline_ctr,

  SUM(results) as results,

  -- Result Rate from Click: ((Results / Click) * 100) %
  round((1.0 * SUM(results) / NULLIF(SUM(clicks), 0)) * 100, 2) as results_from_clicks,

  round((1.0 * SUM(results) / NULLIF(SUM(inline_link_clicks), 0)) * 100, 2) as results_from_inline_clicks

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
