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
  
  SUM(actions_mobile_app_installs) as mobile_app_installs,

  SUM(actions_app_installs)        as desktop_app_installs,

  -- Cost Per App Install: Spend / Mobile App Installs
  round(SUM(spend) / NULLIF(SUM(actions_mobile_app_installs), 0), 2) as cost_per_app_install,

  SUM(actions_post_reactions)      as post_reactions,

  SUM(actions_post_comments)       as post_comments,

  SUM(actions_post_saves)          as post_saves,

  SUM(actions_post_shares)         as post_shares

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