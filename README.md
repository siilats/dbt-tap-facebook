# dbt | tap-facebook

This [dbt](https://github.com/fishtown-analytics/dbt) package contains data models for [tap-facebook](https://gitlab.com/meltano/tap-facebook).

Two variables are required:
* schema: the schema where the raw Facebook Ads tables (result of `tap-facebook`) are located

**dbt_project.yml**
```
... ...

models:
  tap_facebook:

    ... ...

    vars:
      schema:             'tap_facebook'        # the schema where the raw facebook tables are located
```
