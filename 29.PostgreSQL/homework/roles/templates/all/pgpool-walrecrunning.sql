CREATE OR REPLACE FUNCTION pgpool_walrecrunning()
RETURNS bool
AS '/usr/lib64/pgsql/pgpool-walrecrunning', 'pgpool_walrecrunning'
LANGUAGE C VOLATILE STRICT;
