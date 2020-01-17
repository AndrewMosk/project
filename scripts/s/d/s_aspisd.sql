DO $$
BEGIN
DELETE FROM s_aspisd WHERE sp_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_ASPISD' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_ASPISD' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;