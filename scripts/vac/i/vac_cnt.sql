DO $$
BEGIN
UPDATE vac_cnt SET %s = %s + '%s' where vac_num = '%s';
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_CNT' AND "R_TABLE" = '%s' AND "OPER" = 'I';
END;
$$ LANGUAGE plpgsql;