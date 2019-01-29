-- A-1
CREATE OR REPLACE PROCEDURE createdept_bane(numero_dept Dept.deptno%type, dept_name Dept.dname%type, localisation Dept.loc%type)
IS 
	num_dept_exist Dept.deptno%type default 0;
BEGIN
	SELECT deptno INTO num_dept_exist FROM Dept WHERE deptno = numero_dept;
	IF(num_dept_exist != 0) THEN
		dbms_output.put_line('Le departement ' || numero_dept || ' existe deja!');
	END IF;
EXCEPTION WHEN no_data_found THEN
	INSERT INTO Dept Values(numero_dept, dept_name, localisation);
COMMIT;
END;
/

-- A-2
-- Création et remplissage de la table salIntervalle_F2
create table SalIntervalle_F2 (job varchar2(9), lsal number(7,2), hsal number(7,2));
insert into SalIntervalle_F2 values ('ANALYST', 2500, 3000) ;
insert into SalIntervalle_F2 values ('CLERK', 900, 1300) ;
insert into SalIntervalle_F2 values ('MANAGER', 2400, 3000) ;
insert into SalIntervalle_F2 values ('PRESIDENT', 4500, 4900) ;
insert into SalIntervalle_F2 values ('SALESMAN', 1200, 1700) ;

CREATE OR REPLACE FUNCTION salok_bane(p_job SalIntervalle_F2.job%type, salaire SalIntervalle_F2.lsal%type)
RETURN number
IS 
	Cursor curseur IS SELECT job FROM SalIntervalle_F2 WHERE lsal <= salaire or hsal <= salaire;
	v_job SalIntervalle_F2.job%type;
BEGIN
	OPEN curseur;
	LOOP
		FETCH curseur INTO v_job;
		--dbms_output.put_line('V_JOB = ' || v_job);
		IF(v_job is null) THEN
			dbms_output.put_line('OUPS!');
			RAISE no_data_found;
		END IF;
		EXIT WHEN (curseur%NOTFOUND);
		dbms_output.put_line('Le salaire du job ' || p_job || ' est dans l''intervale du job ' || v_job);
	END LOOP;
	RETURN 1;
EXCEPTION WHEN no_data_found THEN
	dbms_output.put_line('Le salaire du job ' || p_job || ' n''est dans aucun intervale des job');
	RETURN 0;
COMMIT;
END;
/
									      
-- A-3
CREATE OR REPLACE PROCEDURE raisesalary_bane(emp_id Emp.empno%type, amount Emp.sal%type)
IS 
	v_salaire_augmente Emp.sal%type default 0;
	v_salaire Emp.sal%type;
	v_empno Emp.empno%type;
	v_job Emp.job%type;
	v_req varchar(200);
	v_resultat number;
BEGIN
	SELECT empno, sal INTO v_empno, v_salaire FROM Emp WHERE empno = emp_id;
	v_salaire_augmente := v_salaire + amount;
	v_resultat := salok_bane(v_job, v_salaire_augmente);
	IF(v_resultat = 1) THEN
		dbms_output.put_line('Le salaire augmenté est dans l''intervalle');
		v_req := 'Update Emp set sal = ' || v_salaire_augmente || ' Where empno = ' || emp_id;
		dbms_output.put_line(v_req);
		execute immediate v_req;
	ELSE
		dbms_output.put_line('Le salaire augmenté n''est pas dans l''intervalle');
	END IF;
EXCEPTION WHEN no_data_found THEN
	dbms_output.put_line('L''employé ' || emp_id || ' n''existe pas dans la base');
COMMIT;
END;
/									      

--B
DECLARE
	v_req varchar(300);
	Cursor curseur IS SELECT table_name FROM user_tables;
	v_table_name User_tables.table_name%type;
BEGIN
	OPEN curseur;
	LOOP
		FETCH curseur INTO v_table_name;
		EXIT WHEN(curseur%NOTFOUND);
		dbms_output.put_line(v_table_name);
		PROC_DROP_TABLE(v_table_name|| '_old');
		v_req := 'Create table ' || v_table_name || '_old as Select * FROM ' || v_table_name;
		dbms_output.put_line(v_req);
		execute immediate v_req;
	END LOOP;
COMMIT;
END;
/									      
