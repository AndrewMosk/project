DO $$
BEGIN
DELETE FROM prof_vac WHERE vac_num IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'PROF_VAC' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PROF_VAC' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;