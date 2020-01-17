DO $$
BEGIN
DELETE FROM s_arabu WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_ARABU' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_ARABU' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;