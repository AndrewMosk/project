DO $$
BEGIN
DELETE FROM s_aspis WHERE sp_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_ASPIS' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_ASPIS' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;