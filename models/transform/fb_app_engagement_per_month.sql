with ads_insights as (

     select *
     from {{ref('fb_ads_insights')}}

)

select

  account_name,
  campaign_name,
  adset_name,
  ad_name,

  -- The start of the month this report is for
  to_char(MIN(insights_date), 'YYYY-MM') as month,
  date_trunc('month', MIN(insights_date))::date as month_start,

  -- Generate a descriptive label: "2020-02 | Ad name | Adset | Campaign"
  CONCAT
  (
    to_char(MIN(insights_date), 'YYYY-MM'), ' | ',
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
  insights_year,
  insights_month,
  account_name,
  campaign_name,
  adset_name,
  ad_name

order by
  insights_year,
  insights_month,
  ad_name,
  adset_name,
  campaign_name,
  account_name
