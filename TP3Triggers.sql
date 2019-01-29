-- 1 - Le salaire d’un employé ne diminue jamais
CREATE OR REPLACE TRIGGER refus_diminue_sal_emp
BEFORE UPDATE ON Emp 
FOR EACH ROW
BEGIN
    IF(:old.sal > :new.sal) THEN
        RAISE_APPLICATION_ERROR(-20230, 'Le salaire ne doit pas diminué');
    END IF;
END;
/