with source as (

    select * from {{var('schema')}}.adsets

),

renamed as (

    select

        nullif(id,'') as adset_id,

        name as name,

        -- Targeting definitions
        -- Adding them in case someone wants to analyze adsets
        -- for the same campaign by targeting type

		targeting__age_max as age_max,
		targeting__age_min as age_min,
		targeting__app_install_state as app_install_state,
		targeting__audience_network_positions as audience_network_positions,
		targeting__behaviors as behaviors,
		targeting__connections as connections,
		targeting__custom_audiences as custom_audiences,
		targeting__device_platforms as device_platforms,
		targeting__education_statuses as education_statuses,
		targeting__excluded_connections as excluded_connections,
		targeting__excluded_custom_audiences as excluded_custom_audiences,
		targeting__excluded_geo_locations__cities as excluded_geo_locations__cities,
		targeting__excluded_geo_locations__countries as excluded_geo_locations__countries,
		targeting__excluded_geo_locations__country_groups as excluded_geo_locations__country_groups,
		targeting__excluded_geo_locations__custom_locations as excluded_geo_locations__custom_locations,
		targeting__excluded_geo_locations__geo_markets as excluded_geo_locations__geo_markets,
		targeting__excluded_geo_locations__location_types as excluded_geo_locations__location_types,
		targeting__excluded_geo_locations__regions as excluded_geo_locations__regions,
		targeting__excluded_geo_locations__zips as excluded_geo_locations__zips,
		targeting__excluded_publisher_categories as excluded_publisher_categories,
		targeting__excluded_user_device as excluded_user_device,
		targeting__exclusions__behaviors as exclusions__behaviors,
		targeting__exclusions__connections as exclusions__connections,
		targeting__exclusions__custom_audiences as exclusions__custom_audiences,
		targeting__exclusions__education_majors as exclusions__education_majors,
		targeting__exclusions__excluded_connections as exclusions__excluded_connections,
		targeting__exclusions__excluded_custom_audiences as exclusions__excluded_custom_audiences,
		targeting__exclusions__family_statuses as exclusions__family_statuses,
		targeting__exclusions__friends_of_connections as exclusions__friends_of_connections,
		targeting__exclusions__generation as exclusions__generation,
		targeting__exclusions__home_ownership as exclusions__home_ownership,
		targeting__exclusions__home_type as exclusions__home_type,
		targeting__exclusions__household_composition as exclusions__household_composition,
		targeting__exclusions__income as exclusions__income,
		targeting__exclusions__industries as exclusions__industries,
		targeting__exclusions__interests as exclusions__interests,
		targeting__exclusions__life_events as exclusions__life_events,
		targeting__exclusions__moms as exclusions__moms,
		targeting__exclusions__net_worth as exclusions__net_worth,
		targeting__exclusions__politics as exclusions__politics,
		targeting__exclusions__relationship_statuses as exclusions__relationship_statuses,
		targeting__exclusions__user_adclusters as exclusions__user_adclusters,
		targeting__exclusions__work_employers as exclusions__work_employers,
		targeting__exclusions__work_positions as exclusions__work_positions,
		targeting__facebook_positions as facebook_positions,
		targeting__family_statuses as family_statuses,
		targeting__flexible_spec as flexible_spec,
		targeting__friends_of_connections as friends_of_connections,
		targeting__genders as genders,
		targeting__generation as generation,
		targeting__geo_locations__cities as geo_locations__cities,
		targeting__geo_locations__countries as geo_locations__countries,
		targeting__geo_locations__country_groups as geo_locations__country_groups,
		targeting__geo_locations__custom_locations as geo_locations__custom_locations,
		targeting__geo_locations__geo_markets as geo_locations__geo_markets,
		targeting__geo_locations__location_types as geo_locations__location_types,
		targeting__geo_locations__regions as geo_locations__regions,
		targeting__geo_locations__zips as geo_locations__zips,
		targeting__home_ownership as home_ownership,
		targeting__home_type as home_type,
		targeting__income as income,
		targeting__industries as industries,
		targeting__instagram_positions as instagram_positions,
		targeting__interested_in as interested_in,
		targeting__interests as interests,
		targeting__locales as locales,
		targeting__messenger_positions as messenger_positions,
		targeting__moms as moms,
		targeting__net_worth as net_worth,
		targeting__office_type as office_type,
		targeting__politics as politics,
		targeting__publisher_platforms as publisher_platforms,
		targeting__relationship_statuses as relationship_statuses,
		targeting__targeting_optimization as targeting_optimization,
		targeting__user_adclusters as user_adclusters,
		targeting__user_device as user_device,
		targeting__user_os as user_os,
		targeting__work_positions as work_positions

    from source

)

select * from renamed
