with source as (

    select * from {{var('schema')}}.adsets

),

renamed as (

    select

        nullif(id,'') as adset_id,

        nullif(account_id,'') as account_id,
        nullif(campaign_id,'') as campaign_id,

        name as name,
        effective_status as effective_status,

        created_time as created_at,
        updated_time as updated_at

    from source

)

select * from renamed

