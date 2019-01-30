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

-- 2 - Le numéro de département doit être entre 61 - 69
CREATE OR REPLACE TRIGGER num_dept_intervalle
BEFORE  INSERT OR UPDATE OF deptno ON Emp 
FOR EACH ROW
BEGIN
    IF(:new.deptno < 61 OR :new.deptno > 69) THEN
        RAISE_APPLICATION_ERROR(-20230, 'Le numero du departement doit être compris entre 61 et 69');
    END IF;
END;
/

-- 3 - Si un employé est affecté à un département qui n’existe pas dans la base de
-- données, ce département doit être rajouté avec pour valeur « A SAISIR » pour les attributs Dname et Loc
CREATE OR REPLACE TRIGGER creer_dept
BEFORE  INSERT OR UPDATE OF deptno ON Emp 
FOR EACH ROW
DECLARE 
    c int default 0;
BEGIN
    select count(*) into c from dept where deptno = :new.deptno;
    IF(c = 0) THEN
        dbms_output.put_line('Le departement doit-être créé');
        EXECUTE IMMEDIATE 'INSERT INTO DEPT(deptno, dname, loc) VALUES('|| :new.deptno ||', ''A SAISIR'' , ''A SAISIR'' )';
    END IF;
END;
/

-- 4 - Pour des raisons de sécurité, on souhaite interdire toute modification de la relation
--employé pendant le week-end (samedi et dimanche)
CREATE OR REPLACE TRIGGER intredir_modif_weekend
BEFORE  INSERT OR UPDATE OR DELETE ON Emp 
FOR EACH ROW
DECLARE 
    numjour char;
BEGIN
    select to_char(sysdate, 'd') into numjour from dual;
    IF(numjour = '3' or numjour = '6' or numjour = '7') THEN
        --dbms_output.put_line('C''est le week-end!');
        RAISE_APPLICATION_ERROR(-20230, 'Interdit de modifier la table employe pendant le week-end');
    END IF;
END;
/

-- 5- Désactiver le trigger de la question précédente et tester le
ALTER TRIGGER intredir_modif_weekend DISABLE;

-- 6- Réactiver le trigger la question précédente
ALTER TRIGGER intredir_modif_weekend ENABLE;

-- 7- On souhaite conserver des statistiques concernant les mises à jour (insertions,
--modifications, suppressions) sur la table EMP. Créer à l’aide de SQL la structure de
--la table STATS_ votrenom et la peupler comme suit
CREATE TABLE STATS_bane 
(TypeMaj varchar(6),
 NbMaj number, 
 Date_derniere_Maj date);

 INSERT INTO STATS_bane 
 VALUES('INSERT', 0, NULL),
       ('UPDATE', 0, NULL),
       ('DELETE', 0, NULL);
COMMIT;