DO $$
BEGIN
DELETE FROM s_fpers WHERE pol_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_FPERS' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_FPERS' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;