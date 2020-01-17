DO $$
BEGIN
DELETE FROM rk_list WHERE r_prot IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'RK_LIST' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'RK_LIST' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;