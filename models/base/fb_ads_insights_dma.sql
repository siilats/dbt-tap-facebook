with source as (

    select * from {{var('schema')}}.ads_insights_dma

),

renamed as (

    select

        -- Dimensions common for all Ads Insights Tables
        {{ tap_facebook.ads_insights_dimensions() }},

        -- Specific Dimensions for this Report
        dma as dma,

        -- Metrics common in all Ads Insights Tables
        {{ tap_facebook.ads_insights_metrics() }},

        -- Date parts for easy grouping
        {{ tap_facebook.ads_insights_date_parts() }}

    from source

)

select * from renamed
