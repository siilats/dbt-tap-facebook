{%- macro ads_insights_date_parts() -%}

        EXTRACT(DAY FROM date_start::date) insights_day,
        EXTRACT(WEEK FROM date_start::date) insights_week,
        EXTRACT(MONTH FROM date_start::date) insights_month,
        EXTRACT(QUARTER FROM date_start::date) insights_quarter,
        EXTRACT(YEAR FROM date_start::date) insights_year,
        EXTRACT(ISOYEAR FROM date_start::date) insights_iso_year

{%- endmacro -%}
