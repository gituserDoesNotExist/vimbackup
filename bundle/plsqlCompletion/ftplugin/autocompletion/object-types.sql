DECLARE
    dbobject_name varchar2(30) := '&1';
    TYPE STRING_LIST IS
        TABLE OF VARCHAR2(700);
    TYPE argument_record IS RECORD(
            argument_name varchar2(30),
            argument_data_type varchar2(30)
        );    
    TYPE argument_list is table of argument_record;


    
    obj_attributes STRING_LIST := STRING_LIST();
    procedures STRING_LIST := STRING_LIST();
    tbl_columns STRING_LIST := STRING_LIST();
    arguments argument_list := argument_list();
    return_type varchar2(30) := 'void';
    obj_types         STRING_LIST := STRING_LIST();
    tbl_name varchar2(30) := '';
    all_metadata        STRING_LIST := STRING_LIST();
    tmp_proc_plus_arguments varchar2(1000) := '';
    current_proc_name varchar2(30);
    resultstring varchar2(10000) := '';
    ve boolean := false;
BEGIN
    SELECT object_type BULK COLLECT INTO obj_types FROM sys.all_objects WHERE upper(owner) = 'DIETPLAN' AND upper(object_name) = upper(dbobject_name);
    BEGIN
        SELECT table_name into tbl_name from user_tables where upper(table_name) = upper(dbobject_name);
        EXCEPTION
              WHEN no_data_found THEN
                tbl_name := '';
    end;
    IF obj_types IS EMPTY and tbl_name is null THEN
        dbms_output.put_line('nothing;found');
        return;
    END IF;

    if tbl_name is not null then
        select column_name bulk collect into tbl_columns from all_tab_cols where owner='DIETPLAN' and upper(table_name)=upper(dbobject_name);
        all_metadata := tbl_columns;
    elsif obj_types(1) LIKE 'TYPE%' THEN
        SELECT attr_name BULK COLLECT INTO obj_attributes FROM all_type_attrs WHERE upper(type_name) = upper(dbobject_name);

        FOR i IN 1..obj_attributes.count LOOP
            all_metadata.extend;
            all_metadata(all_metadata.last) := obj_attributes(i);
        END LOOP;
        
        select procedure_name bulk collect into procedures from user_procedures where upper(object_type) = 'TYPE' and OBJECT_NAME = upper(dbobject_name);
        for proc_idx in 1..procedures.count loop
            current_proc_name := procedures(proc_idx);
            tmp_proc_plus_arguments := current_proc_name;
            select argument_name,data_type bulk collect into arguments from USER_ARGUMENTS 
                where package_name = upper(dbobject_name) and object_name = upper(current_proc_name) order by position;

            tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments,'(');
            for argument_idx in 1..arguments.count loop
                if arguments(argument_idx).argument_name is not null and arguments(argument_idx).argument_name != 'SELF' then
                    tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments,arguments(argument_idx).argument_name);
                    if argument_idx != arguments.last then
                        tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments,',');
                    end if;
                elsif arguments(argument_idx).argument_name != 'SELF' then
                    return_type := arguments(argument_idx).argument_data_type;
                end if;
                
            end loop;
            tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments,')');
            tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments,' : ' || return_type);
            
            all_metadata.extend;   
            all_metadata(all_metadata.last) := tmp_proc_plus_arguments;
        end loop;
         
    elsif obj_types(1) LIKE 'PACKAGE%' then
       select procedure_name bulk collect into procedures from user_procedures where object_type = 'PACKAGE' and OBJECT_NAME = upper(dbobject_name) and procedure_name is not null;
        for proc_idx in 1..procedures.count loop
            current_proc_name := procedures(proc_idx);
            tmp_proc_plus_arguments := current_proc_name;
            tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments,'(');
            
            select argument_name,data_type bulk collect into arguments from user_arguments 
                where package_name = upper(dbobject_name) and object_name = upper(current_proc_name) and data_type is not null order by position;    
            for arg_idx in 1..arguments.count loop
                if arguments(arg_idx).argument_name is not null then
                    tmp_proc_plus_arguments :=concat(tmp_proc_plus_arguments,arguments(arg_idx).argument_name);
                    if arg_idx != arguments.last then
                        tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments,',');
                    end if;
                        
                else
                    return_type := arguments(arg_idx).argument_data_type;
                end if;
            end loop;
            tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments,')');
            tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments,' : ' || return_type);
            
            all_metadata.extend;
            all_metadata(all_metadata.last) := tmp_proc_plus_arguments;
        end loop;

    elsif obj_types(1) like 'FUNCTION' then
        tmp_proc_plus_arguments := dbobject_name;
        tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments,'(');
        select argument_name,data_type bulk collect into arguments from user_arguments where object_name = upper(dbobject_name) order by position;
        for arg_idx in 1..arguments.count loop
            if arguments(arg_idx).argument_name is not null then
                tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments,arguments(arg_idx).argument_name);
                if arg_idx != arguments.last then
                    tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments,',');    
                end if;
            else
                return_type := arguments(arg_idx).argument_data_type;
            end if;
        end loop;
        tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments,')');
        tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments,' : ' || return_type);
        
        all_metadata.extend;
        all_metadata(all_metadata.last) := tmp_proc_plus_arguments;


    elsif obj_types(1) like 'PROCEDURE' then
        tmp_proc_plus_arguments := dbobject_name;
        tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments,'(');
        select argument_name,data_type bulk collect into arguments from user_arguments where object_name = upper(dbobject_name) order by position;
        for arg_idx in 1..arguments.count loop
            tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments,arguments(arg_idx).argument_name);
            if arg_idx != arguments.last then
                tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments,',');    
            end if;
        end loop;
        tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments,')');
        tmp_proc_plus_arguments := concat(tmp_proc_plus_arguments,' : ' || return_type);
        
        all_metadata.extend;
        all_metadata(all_metadata.last) := tmp_proc_plus_arguments;

        
    end if;

    for idx in 1..all_metadata.count loop
        if idx!=1 then
           resultstring := concat(resultstring,';');
        end if;
        resultstring := concat(resultstring,all_metadata(idx));
    end loop;
    dbms_output.put_line(resultstring);
         

END;
