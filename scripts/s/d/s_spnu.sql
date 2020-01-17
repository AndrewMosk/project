DO $$
BEGIN
DELETE FROM s_spnu WHERE nu_cod IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_SPNU' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_SPNU' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;