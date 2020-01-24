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
  
  results,
  
  -- Result Rate from Click: Results / Click
  round(1.0 * results / NULLIF(clicks, 0), 2) as results_per_click,

  -- Cost Per Result: Spend / Results
  round(spend / NULLIF(results, 0), 2) as cost_per_result

from ads_insights

order by 
  insights_date, 
  ad_name, 
  adset_name,
  campaign_name,
  account_name