DO $$
BEGIN
DELETE FROM sl_exp_dbf_orcl WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'SL_EXP_DBF_ORCL' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_EXP_DBF_ORCL' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;