WITH ads_insights as (

     select *
     from {{ref('fb_ads_insights_age_and_gender')}}

)

select

  campaign_name,
  adset_name,
  ad_name,
  insights_date,
  gender,

  CONCAT (insights_date, ' | ', gender, ' | ', ad_name, ' | ', adset_name, ' | ', campaign_name) as label, 
  
  SUM(clicks) as clicks, 
  
  round((1.0 * SUM(clicks) / NULLIF(SUM(impressions), 0))  * 100, 2) as ctr,

  round(SUM(spend) / NULLIF(SUM(clicks), 0), 2) as cpc

from ads_insights

group by 

  campaign_name,
  adset_name,
  ad_name,
  insights_date,
  gender

having SUM(clicks) > 0

order by 
  insights_date, 
  gender, 
  ad_name, 
  adset_name,
  campaign_name