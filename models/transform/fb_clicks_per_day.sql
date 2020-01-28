with ads_insights as (

     select *
     from {{ref('fb_ads_insights')}}

)

select

  account_name,
  campaign_name,
  adset_name,
  ad_name,
  insights_date,

  -- Generate a nice label: "2020-01-16 | Ad name | Adset | Campaign"
  CONCAT (insights_date, ' | ', ad_name, ' | ', adset_name, ' | ', campaign_name, ' | ', account_name) as label,

  clicks,

  round((1.0 * clicks / NULLIF(impressions, 0))  * 100, 2) as ctr,

  round(spend / NULLIF(clicks, 0), 2) as cpc

from ads_insights

where clicks > 0

order by
  insights_date,
  ad_name,
  adset_name,
  campaign_name,
  account_name
