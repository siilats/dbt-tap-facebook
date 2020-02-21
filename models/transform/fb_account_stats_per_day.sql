with ads_insights as (

     select *
     from {{ref('fb_ads_insights')}}

)

select

  account_name,
  insights_date,

  -- Generate a descriptive label: "2020-01-16 | Account"
  CONCAT (insights_date, ' | ', account_name) as label,

  impressions,
  reach,
  round(1.0 * impressions / NULLIF(reach, 0), 2) as frequency,

  clicks,
  inline_link_clicks as inline_clicks,

  spend as spend,

  round(spend / NULLIF(clicks, 0), 2) as cpc,
  round(spend / NULLIF(inline_link_clicks, 0), 2) as inline_cpc,

  round((spend / NULLIF(impressions, 0))  * 1000, 2) as cpm,

  round((1.0 * clicks / NULLIF(impressions, 0)) * 100, 2) as ctr,
  round((1.0 * inline_link_clicks / NULLIF(impressions, 0)) * 100, 2) as inline_ctr,

  results,

  -- Result Rate from Click: ((Results / Click) * 100) %
  round((1.0 * results / NULLIF(clicks, 0)) * 100, 2) as results_from_clicks,
  round((1.0 * results / NULLIF(inline_link_clicks, 0)) * 100, 2) as results_from_inline_clicks,

  -- Cost Per Result: Spend / Results
  round(spend / NULLIF(results, 0), 2) as cost_per_result

from ads_insights

order by
  insights_date,
  account_name
