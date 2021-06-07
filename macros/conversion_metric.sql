{%- macro conversion_metric(action_type, column_name) -%}

	    coalesce(
	    (
	        SELECT
	            SUM((conversions::json->>'value')::numeric)
	        FROM
	            jsonb_array_elements(actions) action_elements
	        WHERE action_elements::json->>'action_type' = '{{ action_type }}'
	    ), 0.0) AS {{ column_name }}

{%- endmacro -%}
