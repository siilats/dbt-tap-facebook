WITH ads_insights as (

     select *
     from {{ref('fb_ads_insights_platform_and_device')}}

)

select

  account_name,
  campaign_name,
  adset_name,
  ad_name,
  insights_date,
  publisher_platform as platform,

  CONCAT (insights_date, ' | ', publisher_platform, ' | ', ad_name, ' | ', adset_name, ' | ', campaign_name, ' | ', account_name) as label,

  SUM(clicks) as clicks,

  round((1.0 * SUM(clicks) / NULLIF(SUM(impressions), 0))  * 100, 2) as ctr,

  round(SUM(spend) / NULLIF(SUM(clicks), 0), 2) as cpc

from ads_insights

group by

  account_name,
  campaign_name,
  adset_name,
  ad_name,
  insights_date,
  publisher_platform

having SUM(clicks) > 0

order by
  insights_date,
  publisher_platform,
  ad_name,
  adset_name,
  campaign_name,
  account_name
