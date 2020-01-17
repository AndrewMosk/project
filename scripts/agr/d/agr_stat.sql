DO $$
BEGIN
DELETE FROM agr_stat WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'AGR_STAT' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'AGR_STAT' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;