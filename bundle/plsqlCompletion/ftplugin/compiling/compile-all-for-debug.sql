SET SERVEROUTPUT ON;

DECLARE
    TYPE my_list IS
        TABLE OF VARCHAR2(50);
    v_statement       VARCHAR2(100);
    package_names     my_list;
    procedure_names   my_list;
    object_names my_list;
BEGIN
    SELECT concat(concat(owner, '.'), object_name) BULK COLLECT
    INTO package_names
    FROM sys.all_objects
    WHERE owner = 'DIETPLAN'
          AND object_type like 'PACKAGE%';

    dbms_output.put_line('#########COMPILING PACKAGES#########');
    FOR i IN 1..package_names.last LOOP
        dbms_output.put_line(package_names(i));
        v_statement := 'alter package ' || package_names(i) || ' compile debug';
        dbms_output.put_line(v_statement);
        EXECUTE IMMEDIATE v_statement;
    END LOOP;

    SELECT concat(concat(owner, '.'), object_name) bulk collect into procedure_names
    FROM sys.all_objects
    WHERE owner = 'DIETPLAN'
          AND object_type like 'PROCEDURE';


    dbms_output.put_line('#########COMPILING PROCEDURES#########');
    FOR i IN 1..procedure_names.last LOOP
        dbms_output.put_line(procedure_names(i));
        v_statement := 'alter procedure ' || procedure_names(i) || ' compile debug';
        dbms_output.put_line(v_statement);
        EXECUTE IMMEDIATE v_statement;
    END LOOP;

   SELECT concat(concat(owner, '.'), object_name) bulk collect into object_names
    FROM sys.all_objects
    WHERE owner = 'DIETPLAN'
          AND object_type like 'TYPE%';


    dbms_output.put_line('#########COMPILING OBJECTS#########');
    FOR i IN 1..object_names.last LOOP
        dbms_output.put_line(object_names(i));
        v_statement := 'alter type ' || object_names(i) || ' compile debug';
        dbms_output.put_line(v_statement);
        EXECUTE IMMEDIATE v_statement;
    END LOOP;


END;
/

