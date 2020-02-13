{%- macro ads_insights_metrics() -%}

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

        -- Calculate the results for this Ad based on the Objective:
        -- 1. Iterate through the actions jsonb array and check each included hash (action_elements)
        -- 2. For the Objectives we know what to do with and depending on the objective
        --    match the action_elements.action_type with the appropriate string or set of strings
        -- 3. If you found anything, SUM all the action_elements.value for the action_elements that matched
        -- 4. If you found nothing, return a 0.0 for the Objectives we support or a NULL for the ones we do not
        coalesce(
            (
                SELECT
                    SUM((action_elements::json->>'value')::numeric)
                FROM
                    jsonb_array_elements(actions) action_elements
                WHERE
                    case
                        when objective = 'LINK_CLICKS'
                            then action_elements::json->>'action_type' = 'link_click'
                        when objective = 'PAGE_LIKES'
                            then action_elements::json->>'action_type' = 'like'
                        when objective = 'POST_ENGAGEMENT'
                            then action_elements::json->>'action_type' = 'post_engagement'
                        when objective = 'APP_INSTALLS'
                            -- app_install, mobile_app_install, omni_app_install
                            then action_elements::json->>'action_type' like '%app_install'
                        when objective = 'EVENT_RESPONSES'
                            then action_elements::json->>'action_type' = 'rsvp'
                        when objective = 'VIDEO_VIEWS'
                            then action_elements::json->>'action_type' = 'video_view'
                        when objective = 'LEAD_GENERATION'
                            then action_elements::json->>'action_type' = 'lead'
                        when objective = 'MESSAGES'
                            then action_elements::json->>'action_type' = 'onsite_conversion.messaging_conversation_started_7d'
                    end
            ),

            -- When we do not know how to calculate the results for an objective,
            -- notify consumers of this table with a NULL
            case
                when objective in (
                        'LINK_CLICKS', 'PAGE_LIKES', 'POST_ENGAGEMENT', 'APP_INSTALLS',
                        'EVENT_RESPONSES', 'VIDEO_VIEWS', 'LEAD_GENERATION', 'MESSAGES'
                    )
                    then 0.0
                else
                    NULL
            end

        ) AS results,

        nullif(objective,'') as objective,

        -- Extract various actions as metrics
        {{ tap_facebook.action_metric('link_click',         'actions_link_clicks') }},
        {{ tap_facebook.action_metric('like',               'actions_page_likes') }},
        {{ tap_facebook.action_metric('post_engagement',    'actions_post_engagements') }},
        {{ tap_facebook.action_metric('post_reaction',      'actions_post_reactions') }},
        {{ tap_facebook.action_metric('comment',            'actions_post_comments') }},
        {{ tap_facebook.action_metric('post',               'actions_post_shares') }},
        {{ tap_facebook.action_metric('onsite_conversion.post_save', 'actions_post_saves') }},
        {{ tap_facebook.action_metric('app_install',        'actions_app_installs') }},
        {{ tap_facebook.action_metric('mobile_app_install', 'actions_mobile_app_installs') }},
        {{ tap_facebook.action_metric('omni_app_install',   'actions_omni_app_installs') }},
        {{ tap_facebook.action_metric('rsvp',               'actions_event_responses') }},
        {{ tap_facebook.action_metric('video_view',         'actions_video_views') }},
        {{ tap_facebook.action_metric('lead',               'actions_leads') }},
        {{ tap_facebook.action_metric('onsite_conversion.messaging_conversation_started_7d', 'actions_messages') }},

        -- calculated metrics, not safe for data analysis (can not aggregate already calculated weighted averages)
        --  those are safe to use only at the most granular (day) level
        -- we are going to generate those on our own;
        --  bringing them in until we add support for ad hoc calculated metrics in Meltano Analyze

        -- cpc = (spend / clicks) | The average cost for each click (all)
        cpc as cpc,

        -- cpm = (spend / impressions) * 1000 | The average cost for 1,000 impressions.
        cpm as cpm,

        -- cpp = (spend / reach) * 1000 | The average cost to reach 1,000 people.
        cpp as cpp,

        -- ctr = (clicks / impressions)  * 100 % | The percentage of times people saw your ad and performed a click
        ctr as ctr,

        -- unique_ctr = (unique_clicks / reach)  * 100 %
        unique_ctr as unique_ctr,

        -- frequency = (impressions / reach) | The average number of times each person saw your ad.
        frequency as frequency

{%- endmacro -%}
