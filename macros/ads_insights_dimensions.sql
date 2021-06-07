{%- macro ads_insights_dimensions() -%}

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
        date_start::date as insights_date

{%- endmacro -%}
