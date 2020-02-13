DO $$
BEGIN
DELETE FROM agr_tabel WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'AGR_TABEL' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'AGR_TABEL' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;