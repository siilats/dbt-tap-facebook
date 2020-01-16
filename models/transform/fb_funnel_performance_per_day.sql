with ads_insights as (

     select *
     from {{ref('fb_ads_insights')}}

)

select

  campaign_name,
  adset_name,
  ad_name,
  insights_date,

  -- Generate a nice label: "2020-01-16 | Ad name | Adset | Campaign"
  CONCAT (insights_date, ' | ', ad_name, ' | ', adset_name, ' | ', campaign_name) as label, 
  
  impressions, 
  reach, 
  round(1.0 * impressions / NULLIF(reach, 0), 2) as frequency,

  clicks, 
  round((1.0 * clicks / NULLIF(impressions, 0))  * 100, 2) as ctr

from ads_insights

order by 
  insights_date, 
  ad_name, 
  adset_name,
  campaign_name