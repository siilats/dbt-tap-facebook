with source as (

    select * from {{var('schema')}}.ads_insights_platform_and_device

),

renamed as (

    select

        -- Dimensions common for all Ads Insights Tables
        {{ tap_facebook.ads_insights_dimensions() }},

        -- Specific Dimensions for this Report
        impression_device as impression_device,
        publisher_platform as publisher_platform,
        platform_position as platform_position,

        -- Metrics common in all Ads Insights Tables
        {{ tap_facebook.ads_insights_metrics() }}

    from source

)

select * from renamed
