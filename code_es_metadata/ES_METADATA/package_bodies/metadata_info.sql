CREATE OR REPLACE PACKAGE BODY ES_METADATA.METADATA_INFO AS

    TYPE string_list IS
        TABLE OF VARCHAR2(700);

    FUNCTION should_search_for_dbobj_name (
        v_user_input VARCHAR2
    ) RETURN BOOLEAN IS
    BEGIN
        return not REGEXP_LIKE(v_user_input,'\.','i');
    END should_search_for_dbobj_name;

    FUNCTION search_for_dbobj_name (
        v_part_dbobj_name VARCHAR2
    ) RETURN string_list IS
        all_metadata string_list := string_list();
    BEGIN
        WITH q AS (
            SELECT type_name AS dbobjname
            FROM all_types
            WHERE type_name LIKE concat(v_part_dbobj_name,'%')
            UNION
            SELECT object_name AS dbobjname
            FROM all_procedures
            WHERE object_name LIKE concat(v_part_dbobj_name,'%')
        )
        SELECT dbobjname BULK COLLECT
        INTO all_metadata
        FROM q;

        RETURN all_metadata;
    END search_for_dbobj_name;

    FUNCTION search_dbobj_attrs_and_methods (
        v_dbobj_name VARCHAR2
    ) RETURN string_list IS

        dbobject_name VARCHAR2(30) := v_dbobj_name;
        TYPE argument_record IS RECORD (
            argument_name VARCHAR2(30), argument_data_type VARCHAR2(30)
        );
        TYPE argument_list IS
            TABLE OF argument_record;
        obj_attributes string_list := string_list();
        procedures string_list := string_list();
        tbl_columns string_list := string_list();
        arguments argument_list := argument_list();
        return_type VARCHAR2(30) := 'void';
        obj_types string_list := string_list();
        tbl_name VARCHAR2(30) := '';
        all_metadata string_list := string_list();
        tmp_proc_plus_arguments VARCHAR2(1000) := '';
        current_proc_name VARCHAR2(30);
    BEGIN
        SELECT object_type BULK COLLECT
        INTO obj_types
        FROM sys.all_objects
        WHERE upper(object_name) = upper(dbobject_name);

        BEGIN
            SELECT table_name
            INTO tbl_name
            FROM all_tables
            WHERE upper(table_name) = upper(dbobject_name);

        EXCEPTION
            WHEN no_data_found THEN
                tbl_name := '';
        END;

        IF obj_types IS EMPTY AND tbl_name IS NULL THEN
            dbms_output.put_line('nothing;found');
            RETURN all_metadata;
        END IF;

        IF tbl_name IS NOT NULL THEN
            SELECT column_name BULK COLLECT
            INTO tbl_columns
            FROM all_tab_cols
            WHERE upper(table_name) = upper(dbobject_name);

            all_metadata := tbl_columns;
        ELSIF obj_types(1) LIKE 'TYPE%' THEN
            SELECT attr_name BULK COLLECT
            INTO obj_attributes
            FROM all_type_attrs
            WHERE upper(type_name) = upper(dbobject_name);

            FOR i IN 1..obj_attributes.count LOOP
                all_metadata.extend;
                all_metadata(all_metadata.last) := obj_attributes(i);
            END LOOP;

            SELECT procedure_name BULK COLLECT
            INTO procedures
            FROM all_procedures
            WHERE owner = 'DIETPLAN' AND upper(object_type) = 'TYPE' AND object_name = upper(dbobject_name);

            FOR proc_idx IN 1..procedures.count LOOP
                current_proc_name := procedures(proc_idx);
                tmp_proc_plus_arguments := current_proc_name;
                SELECT argument_name, data_type BULK COLLECT
                INTO arguments
                FROM all_arguments
                WHERE owner = 'DIETPLAN' AND package_name = upper(dbobject_name) AND object_name = upper(current_proc_name)
                ORDER BY position;

                tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments, '(');
                FOR argument_idx IN 1..arguments.count LOOP IF arguments(argument_idx).argument_name IS NOT NULL AND arguments(argument_idx).argument_name != 'SELF'
                THEN
                    tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments, arguments(argument_idx).argument_name);
                    IF argument_idx != arguments.last THEN
                        tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments, ',');
                    END IF;

                ELSIF arguments(argument_idx).argument_name != 'SELF' THEN
                    return_type := arguments(argument_idx).argument_data_type;
                END IF;
                END LOOP;

                tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments, ')');
                tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments, ' : ' || return_type);
                all_metadata.extend;
                all_metadata(all_metadata.last) := tmp_proc_plus_arguments;
            END LOOP;

        ELSIF obj_types(1) LIKE 'PACKAGE%' THEN
            SELECT procedure_name BULK COLLECT
            INTO procedures
            FROM all_procedures
            WHERE object_type = 'PACKAGE' AND object_name = upper(dbobject_name) AND procedure_name IS NOT NULL;

            FOR proc_idx IN 1..procedures.count LOOP
                current_proc_name := procedures(proc_idx);
                tmp_proc_plus_arguments := current_proc_name;
                tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments, '(');
                SELECT argument_name, data_type BULK COLLECT
                INTO arguments
                FROM all_arguments
                WHERE package_name = upper(dbobject_name) AND object_name = upper(current_proc_name) AND data_type IS NOT NULL
                ORDER BY position;

                FOR arg_idx IN 1..arguments.count LOOP IF arguments(arg_idx).argument_name IS NOT NULL THEN
                    tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments, arguments(arg_idx).argument_name);
                    IF arg_idx != arguments.last THEN
                        tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments, ',');
                    END IF;

                ELSE
                    return_type := arguments(arg_idx).argument_data_type;
                END IF;
                END LOOP;

                tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments, ')');
                tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments, ' : ' || return_type);
                all_metadata.extend;
                all_metadata(all_metadata.last) := tmp_proc_plus_arguments;
            END LOOP;

        ELSIF obj_types(1) LIKE 'FUNCTION' THEN
            tmp_proc_plus_arguments := dbobject_name;
            tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments, '(');
            SELECT argument_name, data_type BULK COLLECT
            INTO arguments
            FROM all_arguments
            WHERE owner = 'DIETPLAN' AND object_name = upper(dbobject_name)
            ORDER BY position;

            FOR arg_idx IN 1..arguments.count LOOP IF arguments(arg_idx).argument_name IS NOT NULL THEN
                tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments, arguments(arg_idx).argument_name);
                IF arg_idx != arguments.last THEN
                    tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments, ',');
                END IF;

            ELSE
                return_type := arguments(arg_idx).argument_data_type;
            END IF;
            END LOOP;

            tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments, ')');
            tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments, ' : ' || return_type);
            all_metadata.extend;
            all_metadata(all_metadata.last) := tmp_proc_plus_arguments;
        ELSIF obj_types(1) LIKE 'PROCEDURE' THEN
            tmp_proc_plus_arguments := dbobject_name;
            tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments, '(');
            SELECT argument_name, data_type BULK COLLECT
            INTO arguments
            FROM all_arguments
            WHERE owner = 'DIETPLAN' AND object_name = upper(dbobject_name)
            ORDER BY position;

            FOR arg_idx IN 1..arguments.count LOOP
                tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments, arguments(arg_idx).argument_name);
                IF arg_idx != arguments.last THEN
                    tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments, ',');
                END IF;

            END LOOP;

            tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments, ')');
            tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments, ' : ' || return_type);
            all_metadata.extend;
            all_metadata(all_metadata.last) := tmp_proc_plus_arguments;
        END IF;

        RETURN all_metadata;
    END search_dbobj_attrs_and_methods;

    PROCEDURE extract_autocompletion_info (
        v_user_input IN VARCHAR2
    ) IS
        dbobj_name varchar2(30);
        all_metadata string_list;
        resultstring VARCHAR2(10000) := '';
    BEGIN
        IF should_search_for_dbobj_name(v_user_input) THEN
            all_metadata := search_for_dbobj_name(v_user_input);
        ELSE
            dbobj_name := replace(v_user_input,'.');
            all_metadata := search_dbobj_attrs_and_methods(dbobj_name);
       END IF;     
            
        FOR idx IN 1..all_metadata.count LOOP
            IF idx != 1 THEN
                resultstring := concat(resultstring, ';');
            END IF;

            resultstring := concat(resultstring, all_metadata(idx));
        END LOOP;

        dbms_output.put_line(resultstring);
    END extract_autocompletion_info;

END metadata_info;
/
