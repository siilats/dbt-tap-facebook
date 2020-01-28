with source as (

    select * from {{var('schema')}}.ads

),

renamed as (

    select

        nullif(id,'') as ad_id,

        nullif(account_id,'') as account_id,
        nullif(campaign_id,'') as campaign_id,
        nullif(adset_id,'') as adset_id,
        nullif(creative__id,'') as creative_id,

        name as name,
        status as status,
        effective_status as effective_status,
        bid_type as bid_type,

        created_time as created_at,
        updated_time as updated_at

    from source

)

select * from renamed
