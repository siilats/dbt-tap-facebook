with source as (

    select * from {{var('schema')}}.ads_insights

),

renamed as (

    select

        nullif(account_id,'') as account_id,
        account_name as account_name,

        -- PKEY

        nullif(campaign_id,'') as campaign_id,
        campaign_name as campaign_name,

        nullif(adset_id,'') as adset_id,
        adset_name as adset_name,

        nullif(ad_id,'') as ad_id,
        ad_name as ad_name,
        
        -- We get the Ads Insights data per day with date_start == date_stop
        -- Just keep the date_start as the date this report is for
        date_start::date as insights_date,
        
        -- /PKEY

        spend as spend, -- The estimated total amount of money you've spent on your campaign, ad set or ad during its schedule.
        social_spend as social_spend, -- The total amount you've spent so far for your ads showed with social information.

        clicks as clicks, -- The number of clicks on your ads.
        unique_clicks as unique_clicks, -- The number of people who performed a click (all).

        impressions as impressions, -- The number of times your ads were on screen.
        reach as reach, -- The number of people who saw your ads at least once. 
                        -- Reach is different from impressions, which may include multiple views of your ads by the same people.
        
        inline_link_clicks as inline_link_clicks, -- The number of clicks on links to select destinations or experiences
        inline_post_engagement as inline_post_engagement, -- The total number of actions that people take involving your ads
        unique_inline_link_clicks as unique_inline_link_clicks,

        canvas_avg_view_percent as canvas_avg_view_percent,
        canvas_avg_view_time as canvas_avg_view_time,

        nullif(objective,'') as objective,

        -- Date parts for easy grouping 
        EXTRACT(DAY FROM date_start::date) insights_day,
        EXTRACT(WEEK FROM date_start::date) insights_week,
        EXTRACT(MONTH FROM date_start::date) insights_month,
        EXTRACT(QUARTER FROM date_start::date) insights_quarter,
        EXTRACT(YEAR FROM date_start::date) insights_year,

        -- calculated metrics, not safe for data analysis (can not aggregate already calculated weighted averages)
        --  those are safe to use only at the most granular (day) level
        -- we are going to generate those on our own; 
        --  bringing them in until we add support for ad hoc calculated metrics in Meltano Analyze
        cpc as cpc, -- (spend / clicks) | The average cost for each click (all)
        cpm as cpm, -- (spend / impressions) * 1000 | The average cost for 1,000 impressions.
        cpp as cpp, -- (spend / reach) * 1000 | The average cost to reach 1,000 people.
        ctr as ctr, -- (clicks / impressions)  * 100 % | The percentage of times people saw your ad and performed a click
        unique_ctr as unique_ctr, -- (unique_clicks / reach)  * 100 % 
        frequency as frequency -- (impressions / reach) | The average number of times each person saw your ad.

    from source

)

select * from renamed
