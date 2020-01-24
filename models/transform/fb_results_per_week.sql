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
  
  SUM(results) as results,
  
  -- Result Rate from Click: Results / Click
  round(SUM(results) / NULLIF(SUM(clicks), 0), 2) as results_per_click,

  -- Cost Per Result: Spend / Results
  round(SUM(spend) / NULLIF(SUM(results), 0), 2) as cost_per_result

from ads_insights

group by 

  account_name,
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
  campaign_name,
  account_name