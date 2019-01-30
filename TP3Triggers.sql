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

-- 7-A - Définir un déclencheur après insertion/modification/suppression de la table EMP
--permettant de mettre à jour automatiquement la table STATS_votrenom. Tester
--son utilisation en effectuant diverses mises à jour sur la table EMP
CREATE OR REPLACE TRIGGER intredir_modif_weekend
BEFORE  INSERT OR DELETE OR UPDATE ON Emp 
FOR EACH ROW
DECLARE 
    typemodif varchar(6);
BEGIN
    IF INSERTING THEN
        typemodif := 'INSERT';
    END IF;

    IF UPDATING THEN
        typemodif := 'UPDATE';
    END IF;

    IF DELETING THEN
        typemodif := 'DELETE';
    END IF;

    UPDATE STATS_bane SET NBMAJ = NBMAJ + 1, Date_derniere_Maj= sysdate WHERE TypeMaj = typemodif;
END;
/

Commit;

-- 7-B - Tester l’effet de la présence et de l’absence de
--la clause FOR EACH ROW sur le comportement  du  déclencheur  en  utilisant  une  requête 
-- qui  modifie  plusieurs  n-uplets (ex. UPDATE EMP SET SAL = SAL * 1.05;)
UPDATE EMP SET SAL = SAL * 1.05;)
CREATE OR REPLACE TRIGGER intredir_modif_weekend
BEFORE  INSERT OR DELETE OR UPDATE ON Emp 

DECLARE 
    typemodif varchar(6);
BEGIN
    IF INSERTING THEN
        typemodif := 'INSERT';
    END IF;

    IF UPDATING THEN
        typemodif := 'UPDATE';
    END IF;

    IF DELETING THEN
        typemodif := 'DELETE';
    END IF;

    UPDATE STATS_bane SET NBMAJ = NBMAJ + 1, Date_derniere_Maj= sysdate WHERE TypeMaj = typemodif;
END;
/

Commit;

-- 8 - Augmentation changement job
create or replace trigger ModifSal
before update of sal on emp
for each row

declare
margesal number ;
v_sal emp.sal%type ;
v_lsalaire SalIntervalle_F2.lsal%type;
v_hsalaire SalIntervalle_F2.hsal%type;

begin

        select lsal , hsal into v_lsalaire , v_hsalaire
        from SalIntervalle_F2
        where job = :new.job ;
        v_sal  := :old.sal+100;
        if v_sal  > v_hsalaire then
            v_sal := v_hsalaire;
        elsif v_sal < v_lsalaire then
            v_sal  := v_lsalaire  ;
        else
            dbms_output.put_line('nickel');
        end if ;

    update emp set sal= v_sal where empno = :old.empno ;
end ;
/
Commit;


--- pour supprimer tous les object
set serveroutput on
declare
    v_statement varchar2(80) ;
    cursor selectAllObject is
        select object_type , object_name
        from user_objects ;
begin
    for objet in selectAllObject loop
    v_statement := 'DROP '||objet.object_type || ' ' ||objet.object_name ;
    dbms_output.put_line(v_statement);
    --Execute Immediate v_statement;
    end loop ;

   

end;
/
Commit;
