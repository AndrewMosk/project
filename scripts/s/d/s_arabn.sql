DO $$
BEGIN
DELETE FROM s_arabn WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_ARABN' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_ARABN' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;