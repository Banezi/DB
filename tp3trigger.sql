-- 7-A - Définir un déclencheur après insertion/modification/suppression de la table EMP
--permettant de mettre à jour automatiquement la table STATS_votrenom. Tester
--son utilisation en effectuant diverses mises à jour sur la table EMP
CREATE OR REPLACE TRIGGER intredir_modif_weekend
BEFORE  INSERT OR UPDATE OR DELETE ON Emp 
FOR EACH ROW
DECLARE 
    numjour char;
BEGIN
    IF INSERTING THEN
        
    END IF;

    IF UPDATING THEN
        
    END IF;

    IF DELETING THEN
        
    END IF;
END;
/