DO $$
BEGIN
DELETE FROM agr_spis WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'AGR_SPIS' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'AGR_SPIS' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;