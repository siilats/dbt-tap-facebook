with ads_insights as (

     select *
     from {{ref('fb_ads_insights')}}

)

select

  account_name,
  campaign_name,
  adset_name,
  ad_name,

  -- Get the start of the week
  date_trunc('week', MIN(insights_date))::date as week_start,

  -- Generate a nice label: "[2019-12-09,2019-12-15] | Ad name | Adset | Campaign"
  CONCAT
  (
    '[',
      -- Get the start of the week
      date_trunc('week', MIN(insights_date))::date, ',',
      -- Get the end of the week
      (date_trunc('week', MIN(insights_date)) + '6 days')::date,
    '] | ',
    ad_name, ' | ', adset_name, ' | ', campaign_name, ' | ', account_name
  ) as label,

  SUM(impressions) as impressions,

  round((SUM(spend) / NULLIF(SUM(impressions), 0))  * 1000, 2) as cpm,

  SUM(clicks) as clicks,

  round(SUM(spend) / NULLIF(SUM(clicks), 0), 2) as cpc,

  SUM(inline_link_clicks) as inline_clicks,

  round(SUM(spend) / NULLIF(SUM(inline_link_clicks), 0), 2) as inline_cpc,

  SUM(results) as results,

  -- Cost Per Result: Spend / Results
  round(SUM(spend) / NULLIF(SUM(results), 0), 2) as cost_per_result,

  SUM(spend) as spend

from ads_insights

group by
  insights_iso_year,
  insights_week,
  account_name,
  campaign_name,
  adset_name,
  ad_name

order by
  insights_iso_year,
  insights_week,
  ad_name,
  adset_name,
  campaign_name,
  account_name
