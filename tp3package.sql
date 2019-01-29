-- Spécification
Create or Replace Package package_bane
IS
    Type EmpNumNameRecType IS Record (emp_num Emp.empno%type, emp_name Emp.ename%type);
    Cursor emp_par_dep_bane (pdeptno Emp.deptno%type) RETURN EmpNumNameRecType;
    PROCEDURE raisesalary_bane(numero_dept Dept.deptno%type, dept_name Dept.dname%type, localisation Dept.loc%type);
    PROCEDURE afficher_emp_bane(pdeptno Emp.deptno%type);
END package_bane;
/ 

-- Implémentation
Create or Replace Package Body package_bane
IS
    Cursor emp_par_dep_bane (pdeptno Emp.deptno%type) RETURN EmpNumNameRecType IS Select empno, ename from Emp Where Emp.deptno = pdeptno;

    PROCEDURE raisesalary_bane(numero_dept Dept.deptno%type, dept_name Dept.dname%type, localisation Dept.loc%type)
    IS
    BEGIN
        raisesalary_bane(numero_dept, dept_name, localisation);
    END raisesalary_bane;

    PROCEDURE afficher_emp_bane(pdeptno Emp.deptno%type)
    IS
        rec_c emp_par_dep_bane%ROWTYPE;
        v_no Emp.empno%type;
        v_name Emp.ename%type;
    BEGIN
        OPEN emp_par_dep_bane(pdeptno);
        --For rec_c in emp_par_dep_bane(deptno) remplacer par fetch dans la loop
        LOOP
            FETCH emp_par_dep_bane INTO v_no, v_name;
            EXIT WHEN(emp_par_dep_bane%NOTFOUND);
            --v_no := rec_c.empno;
            --v_name := rec_c.ename;
            --dbms_output.put_line(rec_c.empno || ' ' || rec_c.ename);
            dbms_output.put_line(v_no || ' ' || v_name);
        END LOOP;
        CLOSE emp_par_dep_bane;
    END afficher_emp_bane;

END package_bane;
/