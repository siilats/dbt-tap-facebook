with ads_insights as (

     select *
     from {{ref('fb_ads_insights')}}

)

select

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
    ad_name, ' | ', adset_name, ' | ', campaign_name
  ) as label, 
  
  SUM(spend) as spend, 
  
  round((SUM(spend) / NULLIF(SUM(impressions), 0))  * 1000, 2) as cpm,

  round(SUM(spend) / NULLIF(SUM(clicks), 0), 2) as cpc

from ads_insights

group by 

  campaign_name,
  adset_name,
  ad_name,
  insights_year,
  insights_week

order by 
  insights_year,
  insights_week,
  ad_name, 
  adset_name,
  campaign_name