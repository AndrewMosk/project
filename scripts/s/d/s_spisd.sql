DO $$
BEGIN
DELETE FROM s_spisd WHERE sp_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_SPISD' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_SPISD' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;