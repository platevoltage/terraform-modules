# Grafana App

to add generic environment variables
```tf
  app_environments = [
        { name = "MODE_TYPE", value = "app" },
        { name = "AWS_DEFAULT_REGION", value = local.region }
      ]
```
or...

All parameter store variable matching the path prefix are automatically injected into ECS task. You can update environment variables in parameter store by runninng `prod/apps/grafana/env/get-parameters-by-path.sh`. Additionally you can get the existing parameter stores by executing `prod/apps/grafana/env/upload-env-to-ssm.sh`

secret_name and secret_passord should be the arn you can get from AWS console. Add the `:username::`` and :password:: suffixes select JSON keys from the Secrets Manager secret.

`arn:aws:secretsmanager:xx-xxxx-x:xxxxxxxxxxxx:secret:rds!cluster-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx-xxxxxx:username::`

`arn:aws:secretsmanager:xx-xxxx-x:xxxxxxxxxxxx:secret:rds!cluster-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx-xxxxxx:password::`


## Create Grafana Database

# 1) Open a psql shell as the master user
psql "host=$HOST port=$PORT user=$MASTER_USER dbname=$MASTER_DB sslmode=require"

# 2) In the psql prompt, create the Grafana role
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'grafana') THEN
    CREATE ROLE grafana LOGIN PASSWORD 'REPLACE_WITH_STRONG_PASSWORD';
  END IF;
END
$$;

ALTER ROLE grafana WITH LOGIN PASSWORD 'REPLACE_WITH_STRONG_PASSWORD';
-- or run interactively:
-- \password grafana

# 3) Create a database for Grafana (owned by master) and lock it down
CREATE DATABASE grafana_db;

REVOKE ALL ON DATABASE grafana_db FROM PUBLIC;
GRANT CONNECT ON DATABASE grafana_db TO grafana;
GRANT CREATE ON DATABASE grafana_db TO grafana;

# 4) Switch into the new DB and create a dedicated schema owned by Grafana
\c grafana_db

CREATE SCHEMA IF NOT EXISTS grafana AUTHORIZATION grafana;
ALTER ROLE grafana IN DATABASE grafana_db SET search_path = grafana, public;
GRANT USAGE ON SCHEMA grafana TO grafana;

ALTER DEFAULT PRIVILEGES FOR USER grafana IN SCHEMA grafana
  GRANT SELECT, INSERT, UPDATE, DELETE, TRIGGER ON TABLES TO grafana;
ALTER DEFAULT PRIVILEGES FOR USER grafana IN SCHEMA grafana
  GRANT USAGE, EXECUTE ON FUNCTIONS TO grafana;
ALTER DEFAULT PRIVILEGES FOR USER grafana IN SCHEMA grafana
  GRANT USAGE ON TYPES TO grafana;

# 5) (Optional) If you must have the DB owned by grafana
\c postgres
GRANT grafana TO CURRENT_USER;
\c grafana_db
ALTER DATABASE grafana_db OWNER TO grafana;

# 6) Quick verifications
SELECT current_user, session_user;
\du+ grafana
\dn+ grafana

# 7) Grafana connection settings
Host: $HOST
Port: $PORT
Database: grafana_db
User: grafana
Password: REPLACE_WITH_STRONG_PASSWORD
SSL mode: require
