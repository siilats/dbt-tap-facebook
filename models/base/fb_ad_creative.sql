with source as (

    select * from {{var('schema')}}.adcreative

),

renamed as (

    select

        id as creative_id,

        account_id as account_id,

        name as name,
        title as title,
        body as body,
        image_url as image_url,

        call_to_action_type as call_to_action_type,
        status as status,

        instagram_permalink_url as instagram_permalink_url,
        link_url as link_url,

        object_story_spec__link_data__name as ad_name,
        object_story_spec__link_data__description as ad_description,
        object_story_spec__link_data__message as ad_message,
        object_story_spec__link_data__caption as ad_caption,
        object_story_spec__link_data__call_to_action__type as ad_call_to_action__type,
        object_story_spec__link_data__attachment_style as ad_attachment_style,
        object_story_spec__link_data__link as ad_link,

        url_tags as url_tags

    from source

)

select * from renamed
