-- такой скрипт должен взять все строки из оракл и попытаться создать такие же в постгри, при конфликте будет делать полный апдейт конфликтующих строк
-- но перед запуском выполнить операции удаления и создания новых строк (в идеале должно получиться одинковое число строк в оракл и постгри)
DO $$
BEGIN
INSERT INTO
	vac_cnt ("vac_num", "cur_free", "cur_dir", "cur_spr", "att_f")
SELECT "vac_num", "cur_free", "cur_dir", "cur_spr", "att_f"
FROM ora_vac_cnt
ON CONFLICT ("vac_num") DO UPDATE SET "cur_free" = EXCLUDED.cur_free, "cur_dir" = EXCLUDED.cur_dir, "cur_spr" = EXCLUDED.cur_spr, "att_f" = EXCLUDED.att_f;
END;
$$ LANGUAGE plpgsql;