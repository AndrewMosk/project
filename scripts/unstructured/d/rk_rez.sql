DO $$
BEGIN
DELETE FROM rk_rez WHERE r_rk IN (select "R_TABLE"::bigint from ora_replog999 WHERE "N_TABLE" = 'RK_REZ' and "OPER" = 'D');
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'RK_REZ' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;