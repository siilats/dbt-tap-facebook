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

  actions_mobile_app_installs as mobile_app_installs,

  actions_app_installs        as desktop_app_installs,

  -- Cost Per App Install: Spend / Mobile App Installs
  round(spend / NULLIF(actions_mobile_app_installs, 0), 2) as cost_per_app_install,

  actions_post_reactions      as post_reactions,

  actions_post_comments       as post_comments,

  actions_post_saves          as post_saves,

  actions_post_shares         as post_shares

from ads_insights

order by
  insights_date,
  ad_name,
  adset_name,
  campaign_name,
  account_name
