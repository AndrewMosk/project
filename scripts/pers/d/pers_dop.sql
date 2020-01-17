DO $$
BEGIN
-- если удалена строка с допами для перса, то очевидно и перс будет удален. перса удалю в скрипте PERS, а отдельной таблицы для допов в постги нет
DELETE FROM ora_replog999 WHERE "N_TABLE" = 'PERS_DOP' AND "OPER" = 'D';
END;
$$ LANGUAGE plpgsql;