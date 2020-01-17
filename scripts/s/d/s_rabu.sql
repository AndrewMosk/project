DO $$
BEGIN
DELETE FROM s_rabu WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_RABU' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_RABU' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;