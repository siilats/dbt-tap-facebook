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

  impressions,
  reach,

  round(1.0 * impressions / NULLIF(reach, 0), 2) as frequency

from ads_insights

where impressions > 0

order by
  insights_date,
  ad_name,
  adset_name,
  campaign_name,
  account_name
