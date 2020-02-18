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

  spend as spend,

  round((spend / NULLIF(impressions, 0))  * 1000, 2) as cpm,

  round(spend / NULLIF(clicks, 0), 2) as cpc,

  round(spend / NULLIF(inline_link_clicks, 0), 2) as inline_cpc,

  -- Cost Per Result: Spend / Results
  round(spend / NULLIF(results, 0), 2) as cost_per_result

from ads_insights

order by
  insights_date,
  ad_name,
  adset_name,
  campaign_name,
  account_name
