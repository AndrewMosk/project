DO $$
BEGIN
DELETE FROM s_arabv WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_ARABV' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_ARABV' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;