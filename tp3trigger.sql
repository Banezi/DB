-- 2 - Le numéro de département doit être entre 61 - 69
CREATE OR REPLACE TRIGGER num_dept_intervalle
BEFORE UPDATE OR INSERT ON Emp 
FOR EACH ROW
BEGIN
    IF(:old.sal > :new.sal) THEN
        RAISE_APPLICATION_ERROR(-20230, 'Le salaire ne doit pas diminué');
    END IF;
END;
/