DO $$
BEGIN
DELETE FROM s_spis WHERE sp_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_SPIS' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_SPIS' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;