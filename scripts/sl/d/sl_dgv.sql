DO $$
BEGIN
DELETE FROM sl_dgv WHERE rpu_code IN (select "R_TABLE" from ora_replog999 WHERE "N_TABLE" = 'SL_DVG' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'SL_DVG' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;