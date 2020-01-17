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

  round((spend / NULLIF(impressions, 0))  * 1000, 2) as cpm,

  clicks, 

  round(spend / NULLIF(clicks, 0), 2) as cpc,

  spend as spend

from ads_insights

order by 
  insights_date, 
  ad_name, 
  adset_name,
  campaign_name,
  account_name