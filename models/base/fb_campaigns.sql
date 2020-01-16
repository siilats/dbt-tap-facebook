with source as (

    select * from {{var('schema')}}.campaigns

),

renamed as (

    select

        nullif(id,'') as campaign_id,

        nullif(account_id,'') as account_id,
        
        name as name,
        effective_status as effective_status,

        buying_type as buying_type,
        objective as objective,
        spend_cap as spend_cap,

        start_time as start_time,
        
        updated_time as updated_at

    from source

)

select * from renamed

