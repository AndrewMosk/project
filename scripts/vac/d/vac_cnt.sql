DO $$
BEGIN
DELETE FROM vac_cnt WHERE vac_num IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'VAC_CNT' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'VAC_CNT' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;