DO $$
BEGIN
DELETE FROM agr_or WHERE agr_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'AGR_OR' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'AGR_OR' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;