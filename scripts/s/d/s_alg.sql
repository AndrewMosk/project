DO $$
BEGIN
DELETE FROM s_alg WHERE r IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'S_ALG' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'S_ALG' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;